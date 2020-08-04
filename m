Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CDF7A23BA57
	for <lists+ceph-devel@lfdr.de>; Tue,  4 Aug 2020 14:29:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726615AbgHDM3i (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 4 Aug 2020 08:29:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:54634 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726027AbgHDM3Z (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Tue, 4 Aug 2020 08:29:25 -0400
Received: from tleilax.poochiereds.net (68-20-15-154.lightspeed.rlghnc.sbcglobal.net [68.20.15.154])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 230EA22BED;
        Tue,  4 Aug 2020 12:29:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596544160;
        bh=ncw4z3UOHlbZv7vJq3zn3s52OBZcjpwdvXPHRvhArb0=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=KTj6fYEzec++O75OfHTob6eVx0yEE34T/moqqt3SqtfqQSJxaLXnxdvyhhy6bc8pn
         Sb3B9Rog1WvK0uJOzUqzFD18HqAjVKNtRociKm9gN8JsOMdSuQMNnPRIEXsHgGJwmp
         NcMDQX+KGkcAQXTGYE+9ogPJ5zgrgZDQxlQ6E50o=
Message-ID: <32c196a970c4ec6d0ddf2609c4280db403d6fefa.camel@kernel.org>
Subject: Re: [PATCH] ceph: set sec_context xattr on symlink creation
From:   Jeff Layton <jlayton@kernel.org>
To:     Ilya Dryomov <idryomov@gmail.com>
Cc:     Ceph Development <ceph-devel@vger.kernel.org>
Date:   Tue, 04 Aug 2020 08:29:19 -0400
In-Reply-To: <8e1ca822212f35c3db669d84afb4bd3debe1d7a1.camel@kernel.org>
References: <20200728191838.315530-1-jlayton@kernel.org>
         <CAOi1vP8PKN2ojoEkrmB4+rDoO0WKoo07oB_wRRBK8h6RE=p=bg@mail.gmail.com>
         <8e1ca822212f35c3db669d84afb4bd3debe1d7a1.camel@kernel.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.4 (3.36.4-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Mon, 2020-08-03 at 06:41 -0400, Jeff Layton wrote:
> On Mon, 2020-08-03 at 11:33 +0200, Ilya Dryomov wrote:
> > On Tue, Jul 28, 2020 at 10:04 PM Jeff Layton <jlayton@kernel.org> wrote:
> > > Symlink inodes should have the security context set in their xattrs on
> > > creation. We already set the context on creation, but we don't attach
> > > the pagelist. Make it do so.
> > > 
> > > Signed-off-by: Jeff Layton <jlayton@kernel.org>
> > > ---
> > >  fs/ceph/dir.c | 4 ++++
> > >  1 file changed, 4 insertions(+)
> > > 
> > > diff --git a/fs/ceph/dir.c b/fs/ceph/dir.c
> > > index 39f5311404b0..060bdcc5ce32 100644
> > > --- a/fs/ceph/dir.c
> > > +++ b/fs/ceph/dir.c
> > > @@ -930,6 +930,10 @@ static int ceph_symlink(struct inode *dir, struct dentry *dentry,
> > >         req->r_num_caps = 2;
> > >         req->r_dentry_drop = CEPH_CAP_FILE_SHARED | CEPH_CAP_AUTH_EXCL;
> > >         req->r_dentry_unless = CEPH_CAP_FILE_EXCL;
> > > +       if (as_ctx.pagelist) {
> > > +               req->r_pagelist = as_ctx.pagelist;
> > > +               as_ctx.pagelist = NULL;
> > > +       }
> > >         err = ceph_mdsc_do_request(mdsc, dir, req);
> > >         if (!err && !req->r_reply_info.head->is_dentry)
> > >                 err = ceph_handle_notrace_create(dir, dentry);
> > 
> > What is the side effect?  Should this go to stable?
> > 
> 
> The effect is that symlink inodes don't get an SELinux context set on
> them at creation, so they end up unlabeled instead of inheriting the
> proper context. As to the severity, it really depends on what ends up
> being unlabeled.
> 
> It's probably harmless enough to put this into stable, but I only
> noticed it by inspection, so I'm not sure it meets the "it must fix a
> real bug that bothers people" criterion.

After thinking about it some more, let's do go ahead and mark this for
stable. While no one has complained about it, it's a subtle bug that
could be problematic once people start populating cephfs trees with
unlabeled symlinks. Better that we fix it early before SELinux support
becomes even more widespread.

Ilya, can you add the Cc: stable tag before you send a PR to Linus?

Thanks,
-- 
Jeff Layton <jlayton@kernel.org>

