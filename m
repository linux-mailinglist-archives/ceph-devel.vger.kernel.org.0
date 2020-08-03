Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0328923A2D1
	for <lists+ceph-devel@lfdr.de>; Mon,  3 Aug 2020 12:41:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726291AbgHCKlv (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 3 Aug 2020 06:41:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:42386 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725933AbgHCKlu (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Mon, 3 Aug 2020 06:41:50 -0400
Received: from tleilax.poochiereds.net (68-20-15-154.lightspeed.rlghnc.sbcglobal.net [68.20.15.154])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 29D5720738;
        Mon,  3 Aug 2020 10:41:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596451309;
        bh=Lg0PgG2pwYO3lU+FIuTGsl0JmF1qBNXn8Sb9yan1ZNA=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=H43KoF1HO5zAEAFdoZI6fk/sWr532JgIzDGA3zQ7rXLPGaqtwULZW6aF0jDJBWQd+
         q/yESJ+HzKRxK3rf5XvmiF9K0urmFYoqhXa8VOqirgPCzEz+zWFySqvVadg9YizPIJ
         qQ+uSNNVnCGfxPQ+0vi678g4yGQdckhb9dtuBCEs=
Message-ID: <8e1ca822212f35c3db669d84afb4bd3debe1d7a1.camel@kernel.org>
Subject: Re: [PATCH] ceph: set sec_context xattr on symlink creation
From:   Jeff Layton <jlayton@kernel.org>
To:     Ilya Dryomov <idryomov@gmail.com>
Cc:     Ceph Development <ceph-devel@vger.kernel.org>
Date:   Mon, 03 Aug 2020 06:41:48 -0400
In-Reply-To: <CAOi1vP8PKN2ojoEkrmB4+rDoO0WKoo07oB_wRRBK8h6RE=p=bg@mail.gmail.com>
References: <20200728191838.315530-1-jlayton@kernel.org>
         <CAOi1vP8PKN2ojoEkrmB4+rDoO0WKoo07oB_wRRBK8h6RE=p=bg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.4 (3.36.4-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Mon, 2020-08-03 at 11:33 +0200, Ilya Dryomov wrote:
> On Tue, Jul 28, 2020 at 10:04 PM Jeff Layton <jlayton@kernel.org> wrote:
> > Symlink inodes should have the security context set in their xattrs on
> > creation. We already set the context on creation, but we don't attach
> > the pagelist. Make it do so.
> > 
> > Signed-off-by: Jeff Layton <jlayton@kernel.org>
> > ---
> >  fs/ceph/dir.c | 4 ++++
> >  1 file changed, 4 insertions(+)
> > 
> > diff --git a/fs/ceph/dir.c b/fs/ceph/dir.c
> > index 39f5311404b0..060bdcc5ce32 100644
> > --- a/fs/ceph/dir.c
> > +++ b/fs/ceph/dir.c
> > @@ -930,6 +930,10 @@ static int ceph_symlink(struct inode *dir, struct dentry *dentry,
> >         req->r_num_caps = 2;
> >         req->r_dentry_drop = CEPH_CAP_FILE_SHARED | CEPH_CAP_AUTH_EXCL;
> >         req->r_dentry_unless = CEPH_CAP_FILE_EXCL;
> > +       if (as_ctx.pagelist) {
> > +               req->r_pagelist = as_ctx.pagelist;
> > +               as_ctx.pagelist = NULL;
> > +       }
> >         err = ceph_mdsc_do_request(mdsc, dir, req);
> >         if (!err && !req->r_reply_info.head->is_dentry)
> >                 err = ceph_handle_notrace_create(dir, dentry);
> 
> What is the side effect?  Should this go to stable?
> 

The effect is that symlink inodes don't get an SELinux context set on
them at creation, so they end up unlabeled instead of inheriting the
proper context. As to the severity, it really depends on what ends up
being unlabeled.

It's probably harmless enough to put this into stable, but I only
noticed it by inspection, so I'm not sure it meets the "it must fix a
real bug that bothers people" criterion.
-- 
Jeff Layton <jlayton@kernel.org>

