Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AFE1C3F4488
	for <lists+ceph-devel@lfdr.de>; Mon, 23 Aug 2021 06:56:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234258AbhHWE5B (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 23 Aug 2021 00:57:01 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:60170 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233781AbhHWE46 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Mon, 23 Aug 2021 00:56:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1629694576;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=lSHncA6DD3kaBfF+CaYFlWCJ/b0v8K8rwqBCE876F+w=;
        b=hlSt8IU/pezCyhyZs0UkYCJtMHK2Sy81jrvMZcddayVDjn3mvkAQOit7UElOweZhF5uSB1
        0ijKz1fmAseo8aT3YKvZmx5/Z/NmXE8/mlYAfNL7P1d5R/RbkufCMKIqyajspnbTHuFhEJ
        Q+qKcGmCz1n0bAVvWWuR6Sz2wWXecTg=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-347-rYgaNSGrOlCkXyiKky0HHg-1; Mon, 23 Aug 2021 00:56:12 -0400
X-MC-Unique: rYgaNSGrOlCkXyiKky0HHg-1
Received: by mail-ed1-f71.google.com with SMTP id r12-20020aa7d14c000000b003c1aa118ad1so2174345edo.2
        for <ceph-devel@vger.kernel.org>; Sun, 22 Aug 2021 21:56:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=lSHncA6DD3kaBfF+CaYFlWCJ/b0v8K8rwqBCE876F+w=;
        b=FCdCn2oI6XgAokLg15XAitHgm9vH14SuR3B124USeba+IBb6lNs5uCE6cXRpqFrGWy
         0QuxN4LzyH1WGzug6tFhMc8msoVzY+Lkx2aWfuW6slz5YHKQ6iVR5N6QruXiCvlZD6ah
         SYySYfvSK4MvwmXeOdQNZMBm0BaE70Md895pkE1sC1hgcGHoEWmG8eAv2Cyy13YgnnY3
         vYvJCVaeyePnTcxuE1BWvj5M5b4LCAHlBgmdFmkKcbQVJvolIfYFRkeKwCcpzqduFJ7n
         dzQ81ziue7mSz7EjUi1STf9dERYWSv7TLUOwSMbNHpSE3HSTfJmt764ZsuiQg7alBcdu
         IcqQ==
X-Gm-Message-State: AOAM530rf8m2YJ1o0PzJydLZshqgCGEtznLYHKCNsUObkLrCsbOW9mLE
        0Pk7RkdMqzNIWauSkUc6ovyXSqTwtNPJvS11kdUR3tOgSAS6eZtpFv2GabU48ZgrmmFmoICm/3O
        MlQinILkxOtz5VGS+2sFCnODmgf1jldfJH1bdRg==
X-Received: by 2002:a05:6402:cb7:: with SMTP id cn23mr34461154edb.82.1629694571310;
        Sun, 22 Aug 2021 21:56:11 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyQQ95BYIDt8BX1qt2+zNT9wBmCm9EU6ofYyirTSu/3DJQysAhmC1KYMsAREM+E7sGcs8g4ke06B86IlV7F7Gg=
X-Received: by 2002:a05:6402:cb7:: with SMTP id cn23mr34461140edb.82.1629694571177;
 Sun, 22 Aug 2021 21:56:11 -0700 (PDT)
MIME-Version: 1.0
References: <20210819060701.25486-1-vshankar@redhat.com> <20210819060701.25486-2-vshankar@redhat.com>
 <9891128997ecdd7a2b9c88b3a7271936f5d66fd7.camel@redhat.com>
In-Reply-To: <9891128997ecdd7a2b9c88b3a7271936f5d66fd7.camel@redhat.com>
From:   Venky Shankar <vshankar@redhat.com>
Date:   Mon, 23 Aug 2021 10:25:35 +0530
Message-ID: <CACPzV1nDJq46_rai7wYpZqXB2UDmcxo9tfjwfrVPio6ZU0uWYw@mail.gmail.com>
Subject: Re: [PATCH 1/2] ceph: add helpers to create/cleanup debugfs
 sub-directories under "ceph" directory
To:     Jeff Layton <jlayton@redhat.com>
Cc:     Patrick Donnelly <pdonnell@redhat.com>,
        ceph-devel <ceph-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Thu, Aug 19, 2021 at 10:46 PM Jeff Layton <jlayton@redhat.com> wrote:
>
> On Thu, 2021-08-19 at 11:37 +0530, Venky Shankar wrote:
> > Callers can use this helper to create a subdirectory under
> > "ceph" directory in debugfs to place custom files for exporting
> > information to userspace.
> >
> > Signed-off-by: Venky Shankar <vshankar@redhat.com>
> > ---
> >  include/linux/ceph/debugfs.h |  3 +++
> >  net/ceph/debugfs.c           | 27 +++++++++++++++++++++++++--
> >  2 files changed, 28 insertions(+), 2 deletions(-)
> >
> > diff --git a/include/linux/ceph/debugfs.h b/include/linux/ceph/debugfs.h
> > index 8b3a1a7a953a..c372e6cb8aae 100644
> > --- a/include/linux/ceph/debugfs.h
> > +++ b/include/linux/ceph/debugfs.h
> > @@ -10,5 +10,8 @@ extern void ceph_debugfs_cleanup(void);
> >  extern void ceph_debugfs_client_init(struct ceph_client *client);
> >  extern void ceph_debugfs_client_cleanup(struct ceph_client *client);
> >
> > +extern struct dentry *ceph_debugfs_create_subdir(const char *subdir);
> > +extern void ceph_debugfs_cleanup_subdir(struct dentry *subdir_dentry);
> > +
> >  #endif
> >
> > diff --git a/net/ceph/debugfs.c b/net/ceph/debugfs.c
> > index 2110439f8a24..cd6f69dd97fa 100644
> > --- a/net/ceph/debugfs.c
> > +++ b/net/ceph/debugfs.c
> > @@ -404,6 +404,18 @@ void ceph_debugfs_cleanup(void)
> >       debugfs_remove(ceph_debugfs_dir);
> >  }
> >
> > +struct dentry *ceph_debugfs_create_subdir(const char *subdir)
> > +{
> > +     return debugfs_create_dir(subdir, ceph_debugfs_dir);
> > +}
> > +EXPORT_SYMBOL(ceph_debugfs_create_subdir);
> > +
> > +void ceph_debugfs_cleanup_subdir(struct dentry *subdir_dentry)
> > +{
> > +     debugfs_remove(subdir_dentry);
> > +}
> > +EXPORT_SYMBOL(ceph_debugfs_cleanup_subdir);
> > +
>
> Rather than these specialized helpers, I think it'd be cleaner/more
> evident to just export the ceph_debugfs_dir symbol and then use normal
> debugfs commands in ceph.ko.

I had initially thought of doing that, but was concerned about putting
ceph_debugfs_dir to abuse once exported.

>
> >  void ceph_debugfs_client_init(struct ceph_client *client)
> >  {
> >       char name[80];
> > @@ -413,7 +425,7 @@ void ceph_debugfs_client_init(struct ceph_client *client)
> >
> >       dout("ceph_debugfs_client_init %p %s\n", client, name);
> >
> > -     client->debugfs_dir = debugfs_create_dir(name, ceph_debugfs_dir);
> > +     client->debugfs_dir = ceph_debugfs_create_subdir(name);
> >
> >       client->monc.debugfs_file = debugfs_create_file("monc",
> >                                                     0400,
> > @@ -454,7 +466,7 @@ void ceph_debugfs_client_cleanup(struct ceph_client *client)
> >       debugfs_remove(client->debugfs_monmap);
> >       debugfs_remove(client->osdc.debugfs_file);
> >       debugfs_remove(client->monc.debugfs_file);
> > -     debugfs_remove(client->debugfs_dir);
> > +     ceph_debugfs_cleanup_subdir(client->debugfs_dir);
> >  }
> >
> >  #else  /* CONFIG_DEBUG_FS */
> > @@ -475,4 +487,15 @@ void ceph_debugfs_client_cleanup(struct ceph_client *client)
> >  {
> >  }
> >
> > +struct dentry *ceph_debugfs_create_subdir(const char *subdir)
> > +{
> > +     return NULL;
> > +}
> > +EXPORT_SYMBOL(ceph_debugfs_create_subdir);
> > +
> > +void ceph_debugfs_cleanup_subdir(struct dentry *subdir_dentry)
> > +{
> > +}
> > +EXPORT_SYMBOL(ceph_debugfs_cleanup_subdir);
> > +
> >  #endif  /* CONFIG_DEBUG_FS */
>
> --
> Jeff Layton <jlayton@redhat.com>
>


-- 
Cheers,
Venky

