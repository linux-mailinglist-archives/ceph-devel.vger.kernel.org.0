Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 46A5F23BB67
	for <lists+ceph-devel@lfdr.de>; Tue,  4 Aug 2020 15:51:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728258AbgHDNvi (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 4 Aug 2020 09:51:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725826AbgHDNvg (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 4 Aug 2020 09:51:36 -0400
Received: from mail-io1-xd44.google.com (mail-io1-xd44.google.com [IPv6:2607:f8b0:4864:20::d44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4D5DC06174A
        for <ceph-devel@vger.kernel.org>; Tue,  4 Aug 2020 06:51:36 -0700 (PDT)
Received: by mail-io1-xd44.google.com with SMTP id g19so30180017ioh.8
        for <ceph-devel@vger.kernel.org>; Tue, 04 Aug 2020 06:51:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=tsUK3H2Rdlh/2QyP2Fpj3oSgbEIJH/UvfGGtiKTaKe4=;
        b=pAMYFbbQSnY4whJuAOWFBXCvFsO2SVJnG9leWNs/5rJ+1dLfuHZx/q7wmnpr1dLquK
         Lsppfla71Kx/Ce1obtXvxi44aAcRcn9AvWOpyHAQraMEZxCG219Ab3bUoXwr8Jz9Jj1R
         sDNASglwxwPB57tUoEhUIg9QcSsc9kLN35bBzbrarGzTRTdTEir3+dQtCRgW4mN+JI5u
         orzespIGyw3K+RnXvYQep3ROj3AJU+h/RAd9l/M44KaZHgLw0YUTVZ4hW2sVCff8B1tR
         sP/Lp6cnlDEhJ16MZM0d+4SYbrGvL656ttrUyUUXM7MQKSvN9qZMil6GL9OYNjO5302G
         Ixmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=tsUK3H2Rdlh/2QyP2Fpj3oSgbEIJH/UvfGGtiKTaKe4=;
        b=YitWL4gH7MurOlAW/OXHuTGcnYxXDsyLRDt4Lnq/K4fUyoIflhqabeCP3/nhUolU79
         JjnMkvbTqSzoQeJB9l+e88ZMqfolx27+/cef1HeHtA1S4Wq9hELRVeQF+ZN48iTsQNgC
         YP/1tHykCfsFTGNz5n1NF9DdiMqvu1Ya68YB3aVfN/0Uy7cTnPth0PrFIWUBTUzNEY2h
         VNce3fE22xjIYhg+FkjY5W5n+vgn5trc2xRXf420H1Dd6iMaF7rc5sr3ytlqt6VItp5t
         ajKI362L2MegCHE4eiscvaQvEUtquHhR7j6rVV+flEdm9jGnb/qDGqKMRUfn0+e5Fraf
         0K0w==
X-Gm-Message-State: AOAM532nylXibkrqcTHF0LpMC2kdcVgcbG6eLnxb/Vue7+hLYlDcePru
        K0gteVES1h11IS01yJj2XByAZyHW86Z5cwfXodA=
X-Google-Smtp-Source: ABdhPJzUchLQiRf0ftzGQzx1TgktuF0fPRVt2lf83s1NRwuS9DvSCGXmS9KhsuuBGUFPVbtMpOfmzNHeeXySlNdpOCw=
X-Received: by 2002:a6b:e40b:: with SMTP id u11mr5438238iog.123.1596549096058;
 Tue, 04 Aug 2020 06:51:36 -0700 (PDT)
MIME-Version: 1.0
References: <20200728191838.315530-1-jlayton@kernel.org> <CAOi1vP8PKN2ojoEkrmB4+rDoO0WKoo07oB_wRRBK8h6RE=p=bg@mail.gmail.com>
 <8e1ca822212f35c3db669d84afb4bd3debe1d7a1.camel@kernel.org> <32c196a970c4ec6d0ddf2609c4280db403d6fefa.camel@kernel.org>
In-Reply-To: <32c196a970c4ec6d0ddf2609c4280db403d6fefa.camel@kernel.org>
From:   Ilya Dryomov <idryomov@gmail.com>
Date:   Tue, 4 Aug 2020 15:51:36 +0200
Message-ID: <CAOi1vP8TVSevrxroboVwjfaVP+KUZSOiVAHcMDZ_6C=zVHy6iw@mail.gmail.com>
Subject: Re: [PATCH] ceph: set sec_context xattr on symlink creation
To:     Jeff Layton <jlayton@kernel.org>
Cc:     Ceph Development <ceph-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Tue, Aug 4, 2020 at 2:29 PM Jeff Layton <jlayton@kernel.org> wrote:
>
> On Mon, 2020-08-03 at 06:41 -0400, Jeff Layton wrote:
> > On Mon, 2020-08-03 at 11:33 +0200, Ilya Dryomov wrote:
> > > On Tue, Jul 28, 2020 at 10:04 PM Jeff Layton <jlayton@kernel.org> wrote:
> > > > Symlink inodes should have the security context set in their xattrs on
> > > > creation. We already set the context on creation, but we don't attach
> > > > the pagelist. Make it do so.
> > > >
> > > > Signed-off-by: Jeff Layton <jlayton@kernel.org>
> > > > ---
> > > >  fs/ceph/dir.c | 4 ++++
> > > >  1 file changed, 4 insertions(+)
> > > >
> > > > diff --git a/fs/ceph/dir.c b/fs/ceph/dir.c
> > > > index 39f5311404b0..060bdcc5ce32 100644
> > > > --- a/fs/ceph/dir.c
> > > > +++ b/fs/ceph/dir.c
> > > > @@ -930,6 +930,10 @@ static int ceph_symlink(struct inode *dir, struct dentry *dentry,
> > > >         req->r_num_caps = 2;
> > > >         req->r_dentry_drop = CEPH_CAP_FILE_SHARED | CEPH_CAP_AUTH_EXCL;
> > > >         req->r_dentry_unless = CEPH_CAP_FILE_EXCL;
> > > > +       if (as_ctx.pagelist) {
> > > > +               req->r_pagelist = as_ctx.pagelist;
> > > > +               as_ctx.pagelist = NULL;
> > > > +       }
> > > >         err = ceph_mdsc_do_request(mdsc, dir, req);
> > > >         if (!err && !req->r_reply_info.head->is_dentry)
> > > >                 err = ceph_handle_notrace_create(dir, dentry);
> > >
> > > What is the side effect?  Should this go to stable?
> > >
> >
> > The effect is that symlink inodes don't get an SELinux context set on
> > them at creation, so they end up unlabeled instead of inheriting the
> > proper context. As to the severity, it really depends on what ends up
> > being unlabeled.
> >
> > It's probably harmless enough to put this into stable, but I only
> > noticed it by inspection, so I'm not sure it meets the "it must fix a
> > real bug that bothers people" criterion.
>
> After thinking about it some more, let's do go ahead and mark this for
> stable. While no one has complained about it, it's a subtle bug that
> could be problematic once people start populating cephfs trees with
> unlabeled symlinks. Better that we fix it early before SELinux support
> becomes even more widespread.
>
> Ilya, can you add the Cc: stable tag before you send a PR to Linus?

Sure, will do.

Thanks,

                Ilya
