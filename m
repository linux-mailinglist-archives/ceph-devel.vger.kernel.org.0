Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B8DE4A2DB7
	for <lists+ceph-devel@lfdr.de>; Sat, 29 Jan 2022 11:36:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229942AbiA2Kgz (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Sat, 29 Jan 2022 05:36:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229484AbiA2Kgz (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Sat, 29 Jan 2022 05:36:55 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F3A1C061714
        for <ceph-devel@vger.kernel.org>; Sat, 29 Jan 2022 02:36:55 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3DEB560B19
        for <ceph-devel@vger.kernel.org>; Sat, 29 Jan 2022 10:36:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42333C340E5;
        Sat, 29 Jan 2022 10:36:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643452613;
        bh=rRvVrtIlD4TPUif66+Orjvg9GzTOg9439FCMyIVWqpk=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=c1JTaYbfv1Fu+QnHVriZSdABgbyAsEVfzklCLhoQ8S/WFbt8c62JqoCgWe0OU6ygJ
         olAgwLFB2s5JPyOrD/vL5MihE5HkHP3PAlwf929Gh89mol/1CDMOryOPMcxCkPLkZC
         BPk9LVS0csakk0707j0QzwFzVOS/DVdhF8BHspnx9s7lEkxXg5EdMi5SJJl6Y+Arqe
         NzSX6MScgZx8VVqNNxN8FREz0Jd1PWqSCcA9lq3cb/OReH0HYjPdwFgjP4pwgvcshH
         eQj6WNa9DpY8O5twzXc/R65GFDvYEHM+gdER0OBE05bEFgNzpvBG0Is5dwapgE83qQ
         SLsksDca51fzg==
Message-ID: <61d982d3a9a3d2ba39de755be5559391221061fb.camel@kernel.org>
Subject: Re: [PATCH] ceph: wake waiters on any IMPORT that grants new caps
From:   Jeff Layton <jlayton@kernel.org>
To:     "Yan, Zheng" <ukernel@gmail.com>
Cc:     ceph-devel <ceph-devel@vger.kernel.org>,
        Ilya Dryomov <idryomov@gmail.com>
Date:   Sat, 29 Jan 2022 05:36:52 -0500
In-Reply-To: <CAAM7YAmcj4JQ64EHWRTAVnEGnhfSN1OSUCSuOoi2PhOT8s_cHg@mail.gmail.com>
References: <20220127200849.96580-1-jlayton@kernel.org>
         <CAAM7YAmcj4JQ64EHWRTAVnEGnhfSN1OSUCSuOoi2PhOT8s_cHg@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
User-Agent: Evolution 3.42.3 (3.42.3-1.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Sat, 2022-01-29 at 11:14 +0800, Yan, Zheng wrote:
> On Sat, Jan 29, 2022 at 2:32 AM Jeff Layton <jlayton@kernel.org> wrote:
> > 
> > I've noticed an intermittent hang waiting for caps in some testing. What
> > I see is that the client will try to get caps for an operation (e.g. a
> > read), and ends up waiting on the waitqueue forever. The caps debugfs
> > file however shows that the caps it's waiting on have already been
> > granted.
> > 
> > The current grant handling code will wake the waitqueue when it sees
> > that there are newly-granted caps in the issued set. On an import
> > however, we'll end up adding a new cap first, which fools the logic into
> > thinking that nothing has changed. A later hack in the code works around
> > this, but only for auth caps.
> 
> not right. handle_cap_import() saves old issued to extra_info->issued.
> 

It does save the old issued value to extra_info->issued, but handle_cap
grant consults cap->issued for most of its logic. It does check against
extra_info->issued for auth caps to determine whether to wake waiters,
but doesn't do that for non-auth caps. This patch corrects that.

If you think this patch isn't right, can you elaborate on why and what
would make it correct?

Thanks,
Jeff

> > 
> > Ensure we wake the waiters whenever we get an IMPORT that grants new
> > caps for the inode.
> > 
> > URL: https://tracker.ceph.com/issues/54044
> > Signed-off-by: Jeff Layton <jlayton@kernel.org>
> > ---
> >  fs/ceph/caps.c | 23 ++++++++++++-----------
> >  1 file changed, 12 insertions(+), 11 deletions(-)
> > 
> > I'm still testing this patch, but I think this may be the cause of some
> > mysterious hangs I've hit in testing.
> > 
> > diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
> > index e668cdb9c99e..06b65a68e920 100644
> > --- a/fs/ceph/caps.c
> > +++ b/fs/ceph/caps.c
> > @@ -3541,21 +3541,22 @@ static void handle_cap_grant(struct inode *inode,
> >                         fill_inline = true;
> >         }
> > 
> > -       if (ci->i_auth_cap == cap &&
> > -           le32_to_cpu(grant->op) == CEPH_CAP_OP_IMPORT) {
> > +       if (le32_to_cpu(grant->op) == CEPH_CAP_OP_IMPORT) {
> >                 if (newcaps & ~extra_info->issued)
> >                         wake = true;
> > 
> > -               if (ci->i_requested_max_size > max_size ||
> > -                   !(le32_to_cpu(grant->wanted) & CEPH_CAP_ANY_FILE_WR)) {
> > -                       /* re-request max_size if necessary */
> > -                       ci->i_requested_max_size = 0;
> > -                       wake = true;
> > -               }
> > +               if (ci->i_auth_cap == cap) {
> > +                       if (ci->i_requested_max_size > max_size ||
> > +                           !(le32_to_cpu(grant->wanted) & CEPH_CAP_ANY_FILE_WR)) {
> > +                               /* re-request max_size if necessary */
> > +                               ci->i_requested_max_size = 0;
> > +                               wake = true;
> > +                       }
> > 
> > -               ceph_kick_flushing_inode_caps(session, ci);
> > -               spin_unlock(&ci->i_ceph_lock);
> > -               up_read(&session->s_mdsc->snap_rwsem);
> > +                       ceph_kick_flushing_inode_caps(session, ci);
> > +                       spin_unlock(&ci->i_ceph_lock);
> > +                       up_read(&session->s_mdsc->snap_rwsem);
> > +               }
> >         } else {
> >                 spin_unlock(&ci->i_ceph_lock);
> >         }
> > --
> > 2.34.1
> > 

-- 
Jeff Layton <jlayton@kernel.org>
