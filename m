Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1FB043F48AD
	for <lists+ceph-devel@lfdr.de>; Mon, 23 Aug 2021 12:30:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236213AbhHWKbU (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 23 Aug 2021 06:31:20 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:22877 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236058AbhHWKbT (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Mon, 23 Aug 2021 06:31:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1629714636;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=kbIkElSjQRcJexp3JKzOKPNUENCLNVCT/BF0z19m4Ws=;
        b=OAWuU9WwG/6Psh5tg3NtP8lEcjNRZOBqvFjJ85OXMEI6pVxcIXOcLy5U/qtJp1xIO3cMpP
        KQ4AjVaDLC6BRpPlh2r66Z/FdNJkOBspgY7GYlOQgPxyp/myH1WmJt6vmP5qdWTNqzV2ad
        ZNQWwHLEM26I8bbFAKIzWo9Nu+l/ens=
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
 [209.85.222.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-527-21HXeOgrMvKANDd_ydbO2A-1; Mon, 23 Aug 2021 06:30:35 -0400
X-MC-Unique: 21HXeOgrMvKANDd_ydbO2A-1
Received: by mail-qk1-f198.google.com with SMTP id p23-20020a05620a22f700b003d5ac11ac5cso11541120qki.15
        for <ceph-devel@vger.kernel.org>; Mon, 23 Aug 2021 03:30:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=kbIkElSjQRcJexp3JKzOKPNUENCLNVCT/BF0z19m4Ws=;
        b=UaJhi2tJO7CL2jwEzXBHTqt3mVIb5saW5aA7ZDFskyyTvKDTkP8UkRgLrof/MhC7pT
         GQwCpdzdWC8YMZQrfjsPx0jT24aUl8LO6N0kKiWemkRNs6moxJsileELnr1xINnc8xp+
         yQ8R82yAYSOpWiJv+JapvAJ3hKnnVyHGXAI749Dpf3aUM72EEOAplVJ+r/aZi6jfmV4Y
         kLGMcmtCcKOQTUQ3b1DDlFtLg7sx2a6i1Vx/+ZjIUfwVNg/5k79VC4OmfjrQrB6GqCnE
         CIWtF/E5M/MHi9Z2OSIXz1HyPdxrPAm7ijfGiRpR6t3Zhgr9vcN9bEpSm41pdTYmO0YJ
         A1Ug==
X-Gm-Message-State: AOAM533ZxdHX4/fPMBQADI/v0VRxR2cE4OYFc0fzrR3hOa6noc9OoHSf
        u7xZm0JbvemnyNU7bHQkniE0MDiKVViDuibFeMEDAKe9nw5JqwFs/ksT27SDQ1jZ50EM28L3IDc
        q5u4FZRHxbgx8O9BgIOeqrQ==
X-Received: by 2002:ac8:5745:: with SMTP id 5mr28810646qtx.347.1629714634609;
        Mon, 23 Aug 2021 03:30:34 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwiM6KAB6sO3Efk67fJvOOJ7B5IrY7elv+WzHWL2Bg4O0i11gY7PiyIFcDDwWE6p0I01ZmJfw==
X-Received: by 2002:ac8:5745:: with SMTP id 5mr28810634qtx.347.1629714634466;
        Mon, 23 Aug 2021 03:30:34 -0700 (PDT)
Received: from [192.168.1.3] (68-20-15-154.lightspeed.rlghnc.sbcglobal.net. [68.20.15.154])
        by smtp.gmail.com with ESMTPSA id b19sm8383059qkc.7.2021.08.23.03.30.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Aug 2021 03:30:34 -0700 (PDT)
Message-ID: <9637f0f2ad85d63f7188c4587e89709f129ce5e3.camel@redhat.com>
Subject: Re: [PATCH 1/2] ceph: add helpers to create/cleanup debugfs
 sub-directories under "ceph" directory
From:   Jeff Layton <jlayton@redhat.com>
To:     Venky Shankar <vshankar@redhat.com>
Cc:     Patrick Donnelly <pdonnell@redhat.com>,
        ceph-devel <ceph-devel@vger.kernel.org>
Date:   Mon, 23 Aug 2021 06:30:33 -0400
In-Reply-To: <CACPzV1nDJq46_rai7wYpZqXB2UDmcxo9tfjwfrVPio6ZU0uWYw@mail.gmail.com>
References: <20210819060701.25486-1-vshankar@redhat.com>
         <20210819060701.25486-2-vshankar@redhat.com>
         <9891128997ecdd7a2b9c88b3a7271936f5d66fd7.camel@redhat.com>
         <CACPzV1nDJq46_rai7wYpZqXB2UDmcxo9tfjwfrVPio6ZU0uWYw@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
User-Agent: Evolution 3.40.4 (3.40.4-1.fc34) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Mon, 2021-08-23 at 10:25 +0530, Venky Shankar wrote:
> On Thu, Aug 19, 2021 at 10:46 PM Jeff Layton <jlayton@redhat.com> wrote:
> > 
> > On Thu, 2021-08-19 at 11:37 +0530, Venky Shankar wrote:
> > > Callers can use this helper to create a subdirectory under
> > > "ceph" directory in debugfs to place custom files for exporting
> > > information to userspace.
> > > 
> > > Signed-off-by: Venky Shankar <vshankar@redhat.com>
> > > ---
> > >  include/linux/ceph/debugfs.h |  3 +++
> > >  net/ceph/debugfs.c           | 27 +++++++++++++++++++++++++--
> > >  2 files changed, 28 insertions(+), 2 deletions(-)
> > > 
> > > diff --git a/include/linux/ceph/debugfs.h b/include/linux/ceph/debugfs.h
> > > index 8b3a1a7a953a..c372e6cb8aae 100644
> > > --- a/include/linux/ceph/debugfs.h
> > > +++ b/include/linux/ceph/debugfs.h
> > > @@ -10,5 +10,8 @@ extern void ceph_debugfs_cleanup(void);
> > >  extern void ceph_debugfs_client_init(struct ceph_client *client);
> > >  extern void ceph_debugfs_client_cleanup(struct ceph_client *client);
> > > 
> > > +extern struct dentry *ceph_debugfs_create_subdir(const char *subdir);
> > > +extern void ceph_debugfs_cleanup_subdir(struct dentry *subdir_dentry);
> > > +
> > >  #endif
> > > 
> > > diff --git a/net/ceph/debugfs.c b/net/ceph/debugfs.c
> > > index 2110439f8a24..cd6f69dd97fa 100644
> > > --- a/net/ceph/debugfs.c
> > > +++ b/net/ceph/debugfs.c
> > > @@ -404,6 +404,18 @@ void ceph_debugfs_cleanup(void)
> > >       debugfs_remove(ceph_debugfs_dir);
> > >  }
> > > 
> > > +struct dentry *ceph_debugfs_create_subdir(const char *subdir)
> > > +{
> > > +     return debugfs_create_dir(subdir, ceph_debugfs_dir);
> > > +}
> > > +EXPORT_SYMBOL(ceph_debugfs_create_subdir);
> > > +
> > > +void ceph_debugfs_cleanup_subdir(struct dentry *subdir_dentry)
> > > +{
> > > +     debugfs_remove(subdir_dentry);
> > > +}
> > > +EXPORT_SYMBOL(ceph_debugfs_cleanup_subdir);
> > > +
> > 
> > Rather than these specialized helpers, I think it'd be cleaner/more
> > evident to just export the ceph_debugfs_dir symbol and then use normal
> > debugfs commands in ceph.ko.
> 
> I had initially thought of doing that, but was concerned about putting
> ceph_debugfs_dir to abuse once exported.
> 

I wouldn't worry about that. The only external user of this symbol will
be in ceph.ko and we'll vet any code that goes in there.

> > 
> > >  void ceph_debugfs_client_init(struct ceph_client *client)
> > >  {
> > >       char name[80];
> > > @@ -413,7 +425,7 @@ void ceph_debugfs_client_init(struct ceph_client *client)
> > > 
> > >       dout("ceph_debugfs_client_init %p %s\n", client, name);
> > > 
> > > -     client->debugfs_dir = debugfs_create_dir(name, ceph_debugfs_dir);
> > > +     client->debugfs_dir = ceph_debugfs_create_subdir(name);
> > > 
> > >       client->monc.debugfs_file = debugfs_create_file("monc",
> > >                                                     0400,
> > > @@ -454,7 +466,7 @@ void ceph_debugfs_client_cleanup(struct ceph_client *client)
> > >       debugfs_remove(client->debugfs_monmap);
> > >       debugfs_remove(client->osdc.debugfs_file);
> > >       debugfs_remove(client->monc.debugfs_file);
> > > -     debugfs_remove(client->debugfs_dir);
> > > +     ceph_debugfs_cleanup_subdir(client->debugfs_dir);
> > >  }
> > > 
> > >  #else  /* CONFIG_DEBUG_FS */
> > > @@ -475,4 +487,15 @@ void ceph_debugfs_client_cleanup(struct ceph_client *client)
> > >  {
> > >  }
> > > 
> > > +struct dentry *ceph_debugfs_create_subdir(const char *subdir)
> > > +{
> > > +     return NULL;
> > > +}
> > > +EXPORT_SYMBOL(ceph_debugfs_create_subdir);
> > > +
> > > +void ceph_debugfs_cleanup_subdir(struct dentry *subdir_dentry)
> > > +{
> > > +}
> > > +EXPORT_SYMBOL(ceph_debugfs_cleanup_subdir);
> > > +
> > >  #endif  /* CONFIG_DEBUG_FS */
> > 
> > --
> > Jeff Layton <jlayton@redhat.com>
> > 
> 
> 

-- 
Jeff Layton <jlayton@redhat.com>

