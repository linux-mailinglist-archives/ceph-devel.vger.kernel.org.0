Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DEC6849CFCA
	for <lists+ceph-devel@lfdr.de>; Wed, 26 Jan 2022 17:34:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243095AbiAZQe6 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 26 Jan 2022 11:34:58 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:49590 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236658AbiAZQe6 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 26 Jan 2022 11:34:58 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2CA1BB81978
        for <ceph-devel@vger.kernel.org>; Wed, 26 Jan 2022 16:34:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76954C340E3;
        Wed, 26 Jan 2022 16:34:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643214895;
        bh=ZX8qcxdjRdn+go/Rxo4FfHwUCT6t6789CVOObt7rxHE=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=id17YxStH41iaTwFtyEnKQ+H6j5BUmRJ3c46XbBwMfZ4Lf+D8rBiucEyWu1JTwjpH
         YuvwLNcYFRAkdPa24AtaDpKvHmxBTCOEr+IA6g8eAdE9dIZQTzfTTvSMxSf4lydeT2
         ioefJTgtRys7ueWRC20pOuWIfx7eLwLxc8kztaM5AuaYAuwKu7OCHvlxs/yZbLy57b
         R7w9bZn4g3j7NAcSdgDCG2HjaknLcn9RzlhRUZtpQN5YFVeKA8XKLq9OJUeHQ2P4LK
         XQv8ylWXK8IjbMBWNx0FXltP1Z1mn5A51V4sGXfGrKxf2M+OBBcCrjDjaBKx6EN/Kb
         Ey92wck1MsOUQ==
Message-ID: <eb79dcdabcc2b90ffbcf3b0b3cce29ed6fdd7480.camel@kernel.org>
Subject: Re: [PATCH] ceph: set pool_ns in new inode layout for async creates
From:   Jeff Layton <jlayton@kernel.org>
To:     Ilya Dryomov <idryomov@gmail.com>
Cc:     Ceph Development <ceph-devel@vger.kernel.org>,
        Dan van der Ster <dan@vanderster.com>
Date:   Wed, 26 Jan 2022 11:34:54 -0500
In-Reply-To: <CAOi1vP-W=k=dAmMoXCfQ4McyyP-boRYCdUF6HthCNyfgbOzNWw@mail.gmail.com>
References: <20220125211022.114286-1-jlayton@kernel.org>
         <CAOi1vP-W=k=dAmMoXCfQ4McyyP-boRYCdUF6HthCNyfgbOzNWw@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
User-Agent: Evolution 3.42.3 (3.42.3-1.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Wed, 2022-01-26 at 17:23 +0100, Ilya Dryomov wrote:
> On Tue, Jan 25, 2022 at 10:10 PM Jeff Layton <jlayton@kernel.org> wrote:
> > 
> > Dan reported that he was unable to write to files that had been
> > asynchronously created when the client's OSD caps are restricted to a
> > particular namespace.
> > 
> > The issue is that the layout for the new inode is only partially being
> > filled. Ensure that we populate the pool_ns_data and pool_ns_len in the
> > iinfo before calling ceph_fill_inode.
> > 
> > Reported-by: Dan van der Ster <dan@vanderster.com>
> > Fixes: 9a8d03ca2e2c ("ceph: attempt to do async create when possible")
> > Signed-off-by: Jeff Layton <jlayton@kernel.org>
> > ---
> >  fs/ceph/file.c | 7 +++++++
> >  1 file changed, 7 insertions(+)
> > 
> > diff --git a/fs/ceph/file.c b/fs/ceph/file.c
> > index cbe4d5a5cde5..efea321ff643 100644
> > --- a/fs/ceph/file.c
> > +++ b/fs/ceph/file.c
> > @@ -599,6 +599,7 @@ static int ceph_finish_async_create(struct inode *dir, struct dentry *dentry,
> >         struct ceph_inode_info *ci = ceph_inode(dir);
> >         struct inode *inode;
> >         struct timespec64 now;
> > +       struct ceph_string *pool_ns;
> >         struct ceph_mds_client *mdsc = ceph_sb_to_mdsc(dir->i_sb);
> >         struct ceph_vino vino = { .ino = req->r_deleg_ino,
> >                                   .snap = CEPH_NOSNAP };
> > @@ -648,11 +649,17 @@ static int ceph_finish_async_create(struct inode *dir, struct dentry *dentry,
> >         in.max_size = cpu_to_le64(lo->stripe_unit);
> > 
> >         ceph_file_layout_to_legacy(lo, &in.layout);
> > +       pool_ns = ceph_try_get_string(lo->pool_ns);
> > +       if (pool_ns) {
> > +               iinfo.pool_ns_len = pool_ns->len;
> > +               iinfo.pool_ns_data = pool_ns->str;
> > +       }
> 
> Considering that we have a reference from try_prep_async_create(), do
> we actually need to bother with ceph_try_get_string() here?
> 

Technically, no. We could just do a rcu_dereference_protected there
since we know that lo is private and can't change. Want me to send a v2?
-- 
Jeff Layton <jlayton@kernel.org>
