Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CEFC92B0653
	for <lists+ceph-devel@lfdr.de>; Thu, 12 Nov 2020 14:22:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728219AbgKLNWG (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 12 Nov 2020 08:22:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:54204 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727646AbgKLNWF (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Thu, 12 Nov 2020 08:22:05 -0500
Received: from tleilax.poochiereds.net (68-20-15-154.lightspeed.rlghnc.sbcglobal.net [68.20.15.154])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3097D22201;
        Thu, 12 Nov 2020 13:22:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605187324;
        bh=E03FFk10N59RLyLQTqGfmVdga98+suTAIqgHYMBC3Mo=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=TWJa+JBdlE7HgqNQbOvPjNK2xscH2t3RGe207eeU8sPLUUhkrR1FsvOR1/fOsGC4y
         BFJO9+b7zN90OEXAPfmvu3S/fWd7D9mdh1GPhg35k0BCrwYxOgxhjWHXE/sECLH+c5
         2bbXclKRGWIxrpZ+taFYcUfHtv4yTMNMrBhbyGiU=
Message-ID: <2e81958e92563a568f2b9b5b4d23c4c7bab52f1c.camel@kernel.org>
Subject: Re: [PATCH] ceph: fix race in concurrent __ceph_remove_cap
 invocations
From:   Jeff Layton <jlayton@kernel.org>
To:     "Yan, Zheng" <ukernel@gmail.com>,
        Luis Henriques <lhenriques@suse.de>
Cc:     Ilya Dryomov <idryomov@gmail.com>,
        ceph-devel <ceph-devel@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date:   Thu, 12 Nov 2020 08:22:02 -0500
In-Reply-To: <CAAM7YA=eO-1AdgPJk6-3=FbDFtHJ9e_Rydo+7LDHqVwxtk1-jA@mail.gmail.com>
References: <20201112104512.17472-1-lhenriques@suse.de>
         <CAAM7YA=eO-1AdgPJk6-3=FbDFtHJ9e_Rydo+7LDHqVwxtk1-jA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.1 (3.38.1-1.fc33) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Thu, 2020-11-12 at 20:43 +0800, Yan, Zheng wrote:
> On Thu, Nov 12, 2020 at 6:48 PM Luis Henriques <lhenriques@suse.de> wrote:
> > 
> > A NULL pointer dereference may occur in __ceph_remove_cap with some of the
> > callbacks used in ceph_iterate_session_caps, namely trim_caps_cb and
> > remove_session_caps_cb.  These aren't protected against the concurrent
> > execution of __ceph_remove_cap.
> > 
> 
> they are protected by session mutex, never get executed concurrently
> 

Maybe not concurrently with one another, but the s_mutex is _not_ held
when __ceph_remove_caps is called from ceph_evict_inode. We can't rely
on it to protect this.

> > Since the callers of this function hold the i_ceph_lock, the fix is simply
> > a matter of returning immediately if caps->ci is NULL.
> > 
> > Based on a patch from Jeff Layton.
> > 
> > Cc: stable@vger.kernel.org
> > URL: https://tracker.ceph.com/issues/43272
> > Link: https://www.spinics.net/lists/ceph-devel/msg47064.html
> > Signed-off-by: Luis Henriques <lhenriques@suse.de>
> > ---
> >  fs/ceph/caps.c | 11 +++++++++--
> >  1 file changed, 9 insertions(+), 2 deletions(-)
> > 
> > diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
> > index ded4229c314a..443f164760d5 100644
> > --- a/fs/ceph/caps.c
> > +++ b/fs/ceph/caps.c
> > @@ -1140,12 +1140,19 @@ void __ceph_remove_cap(struct ceph_cap *cap, bool queue_release)
> >  {
> >         struct ceph_mds_session *session = cap->session;
> >         struct ceph_inode_info *ci = cap->ci;
> > -       struct ceph_mds_client *mdsc =
> > -               ceph_sb_to_client(ci->vfs_inode.i_sb)->mdsc;
> > +       struct ceph_mds_client *mdsc;
> >         int removed = 0;
> > 
> > +       /* 'ci' being NULL means he remove have already occurred */
> > +       if (!ci) {
> > +               dout("%s: cap inode is NULL\n", __func__);
> > +               return;
> > +       }
> > +
> >         dout("__ceph_remove_cap %p from %p\n", cap, &ci->vfs_inode);
> > 
> > +       mdsc = ceph_inode_to_client(&ci->vfs_inode)->mdsc;
> > +
> >         /* remove from inode's cap rbtree, and clear auth cap */
> >         rb_erase(&cap->ci_node, &ci->i_caps);
> >         if (ci->i_auth_cap == cap) {

-- 
Jeff Layton <jlayton@kernel.org>

