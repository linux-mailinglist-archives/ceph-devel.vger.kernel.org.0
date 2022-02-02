Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 47E6C4A70EF
	for <lists+ceph-devel@lfdr.de>; Wed,  2 Feb 2022 13:40:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231748AbiBBMk4 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 2 Feb 2022 07:40:56 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:48984 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344179AbiBBMkz (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 2 Feb 2022 07:40:55 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B062B6177D
        for <ceph-devel@vger.kernel.org>; Wed,  2 Feb 2022 12:40:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9994C004E1;
        Wed,  2 Feb 2022 12:40:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643805655;
        bh=SJg/wqOL8TLLZNgIP2T1Nvb/O1PCMcraHCYauZpBUg4=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=rxCPq8RXpK34UjevBVSmM9jNI7jjDraHeiLuFKfH1qbRp8UslU8TnBe2uWTss+Apl
         H9Hc0pTN77Y2JCzT2B9aIAFbr0z4oW8y+NpVOSa5GaHnvy0nBvUQEM4jbNLhl4s7fw
         yI/Iheo6AXNL18JOQPlay7F3jcKMhVpNbiHh5VGAjAveh/4QwjdzwEpWaPYBNE0yWA
         WyvEKV3VEHhXwEFwnARIbh1DNO/HDVydzpGDYWN0UxRxQCZAq4mPtxzW02mk3scHXL
         7VGV0IG5SQjGLiLrqZdfaMfa4IO3Jrlh9Dyp0YwQXgowp7NKXpEW2iZev9GozozlW1
         6g8Tr5J8d5iWg==
Message-ID: <a6a08d6ea41b996568fdf16314fec83b34234626.camel@kernel.org>
Subject: Re: [PATCH] ceph: wake waiters on any IMPORT that grants new caps
From:   Jeff Layton <jlayton@kernel.org>
To:     "Yan, Zheng" <ukernel@gmail.com>
Cc:     Ilya Dryomov <idryomov@gmail.com>,
        ceph-devel <ceph-devel@vger.kernel.org>
Date:   Wed, 02 Feb 2022 07:40:52 -0500
In-Reply-To: <CAAM7YAn+8H5nv_Y3hBDtEGA5=jbtsG8-RX=dGU6wB3RRH-HGmw@mail.gmail.com>
References: <20220127200849.96580-1-jlayton@kernel.org>
         <CAAM7YAmcj4JQ64EHWRTAVnEGnhfSN1OSUCSuOoi2PhOT8s_cHg@mail.gmail.com>
         <61d982d3a9a3d2ba39de755be5559391221061fb.camel@kernel.org>
         <CAAM7YAn+8H5nv_Y3hBDtEGA5=jbtsG8-RX=dGU6wB3RRH-HGmw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.3 (3.42.3-1.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Wed, 2022-02-02 at 03:36 +0800, Yan, Zheng wrote:
> 
> 
> Jeff Layton <jlayton@kernel.org>于2022年1月29日 周六18:36写道：
> > On Sat, 2022-01-29 at 11:14 +0800, Yan, Zheng wrote:
> > > On Sat, Jan 29, 2022 at 2:32 AM Jeff Layton <jlayton@kernel.org>
> > > wrote:
> > > > 
> > > > I've noticed an intermittent hang waiting for caps in some
> > > > testing. What
> > > > I see is that the client will try to get caps for an operation
> > > > (e.g. a
> > > > read), and ends up waiting on the waitqueue forever. The caps
> > > > debugfs
> > > > file however shows that the caps it's waiting on have already
> > > > been
> > > > granted.
> > > > 
> > > > The current grant handling code will wake the waitqueue when it
> > > > sees
> > > > that there are newly-granted caps in the issued set. On an
> > > > import
> > > > however, we'll end up adding a new cap first, which fools the
> > > > logic into
> > > > thinking that nothing has changed. A later hack in the code
> > > > works around
> > > > this, but only for auth caps.
> > > 
> > > not right. handle_cap_import() saves old issued to extra_info-
> > > >issued.
> > > 
> > 
> > It does save the old issued value to extra_info->issued, but
> > handle_cap
> > grant consults cap->issued for most of its logic. It does check
> > against
> > extra_info->issued for auth caps to determine whether to wake
> > waiters,
> > but doesn't do that for non-auth caps. This patch corrects that.
> > 
> 
> 
> non auth mds never imports caps. ‘ci->i_auth_cap != cap’ happened only
> when client receives out-of-order messages for successive cap
> import/export. It’s unlikely in your case because you saw caps were
> there.
> 

Ok! I'll drop this patch, and keep hunting for how we're not getting
awoken. Let me know if you see any gaps in how "wake" gets set.

Thanks,
Jeff

> 
> > 
> > If you think this patch isn't right, can you elaborate on why and
> > what
> > would make it correct?
> > 
> > Thanks,
> > Jeff
> > 
> > > > 
> > > > Ensure we wake the waiters whenever we get an IMPORT that grants
> > > > new
> > > > caps for the inode.
> > > > 
> > > > URL: https://tracker.ceph.com/issues/54044
> > > > Signed-off-by: Jeff Layton <jlayton@kernel.org>
> > > > ---
> > > >   fs/ceph/caps.c | 23 ++++++++++++-----------
> > > >   1 file changed, 12 insertions(+), 11 deletions(-)
> > > > 
> > > > I'm still testing this patch, but I think this may be the cause
> > > > of some
> > > > mysterious hangs I've hit in testing.
> > > > 
> > > > diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
> > > > index e668cdb9c99e..06b65a68e920 100644
> > > > --- a/fs/ceph/caps.c
> > > > +++ b/fs/ceph/caps.c
> > > > @@ -3541,21 +3541,22 @@ static void handle_cap_grant(struct
> > > > inode *inode,
> > > >                          fill_inline = true;
> > > >          }
> > > > 
> > > > -       if (ci->i_auth_cap == cap &&
> > > > -           le32_to_cpu(grant->op) == CEPH_CAP_OP_IMPORT) {
> > > > +       if (le32_to_cpu(grant->op) == CEPH_CAP_OP_IMPORT) {
> > > >                  if (newcaps & ~extra_info->issued)
> > > >                          wake = true;
> > > > 
> > > > -               if (ci->i_requested_max_size > max_size ||
> > > > -                   !(le32_to_cpu(grant->wanted) &
> > > > CEPH_CAP_ANY_FILE_WR)) {
> > > > -                       /* re-request max_size if necessary */
> > > > -                       ci->i_requested_max_size = 0;
> > > > -                       wake = true;
> > > > -               }
> > > > +               if (ci->i_auth_cap == cap) {
> > > > +                       if (ci->i_requested_max_size > max_size
> > > > ||
> > > > +                           !(le32_to_cpu(grant->wanted) &
> > > > CEPH_CAP_ANY_FILE_WR)) {
> > > > +                               /* re-request max_size if
> > > > necessary */
> > > > +                               ci->i_requested_max_size = 0;
> > > > +                               wake = true;
> > > > +                       }
> > > > 
> > > > -               ceph_kick_flushing_inode_caps(session, ci);
> > > > -               spin_unlock(&ci->i_ceph_lock);
> > > > -               up_read(&session->s_mdsc->snap_rwsem);
> > > > +                       ceph_kick_flushing_inode_caps(session,
> > > > ci);
> > > > +                       spin_unlock(&ci->i_ceph_lock);
> > > > +                       up_read(&session->s_mdsc->snap_rwsem);
> > > > +               }
> > > >          } else {
> > > >                  spin_unlock(&ci->i_ceph_lock);
> > > >          }
> > > > --
> > > > 2.34.1
> > > > 
> > 

-- 
Jeff Layton <jlayton@kernel.org>
