Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A0FF5162E77
	for <lists+ceph-devel@lfdr.de>; Tue, 18 Feb 2020 19:26:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726296AbgBRS0t (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 18 Feb 2020 13:26:49 -0500
Received: from mail-il1-f193.google.com ([209.85.166.193]:33139 "EHLO
        mail-il1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726239AbgBRS0t (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 18 Feb 2020 13:26:49 -0500
Received: by mail-il1-f193.google.com with SMTP id s18so18179154iln.0
        for <ceph-devel@vger.kernel.org>; Tue, 18 Feb 2020 10:26:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=8W1wAikO5yTQVqFOSOsEelxeeVqqtSI2PpcjxGNDzSk=;
        b=L10AmXPciivbjqfYDGyyD7MFFg8prbh4/+u4xSC3iW6aEIt910BVxCtNebd3mUkqm3
         5QkRKmMGmL/hR+H9Hvl2xx1SSapuVHoRu2ZH5ontpLTVdNtPh/E8PEsFit4R84a8hg9d
         sg2xEBw3mStOYSOUbDK5HGJqSv/cfaZ09L8oEvCVOm+DEagymuKppRBn/cTQESBSfwXC
         PM0fpZ2/vTNvJY/SS/1oDc6a70tJVfMd68RofhQmd971xLjWHODRYyEoX0HntxvBC7lB
         OS6Ox32Kel3KJUPovjSeqd2pbBkIy2U1UnFTcDgmkoAIqX4AB4aPCdRjRPuMQgH0YeHk
         /W9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=8W1wAikO5yTQVqFOSOsEelxeeVqqtSI2PpcjxGNDzSk=;
        b=LdWPot/5KrjjqSISVILtIuIDYsoXYDQgjR4LaerU38J1iCfUqLtDYOsi5ir0MACth8
         QJo4AWGCEyYFWu27WrENF4SstrCqn+8HQ4tC/9PMKTjOHc2IQ73O/57kuy4nN0PjfkXD
         pgtP197Qk9hdFXDCeHXdtTMXhBf/fjvH16+X34nbZj9vYSBnPKpTFsfINq6PknA631tE
         8qldnN+kbNhl6K2ZM0qiLeBohccnnYMnZNqlwJyZvf8XCk2JXPs3dAogy62tq7H5Dk4U
         QqLEDqLBOCgMMHPFC44hZc7bRhfpIjZw3wt8o+aERgCkpaOaUiDBkqB2Mux3l6aYQCUW
         l6NQ==
X-Gm-Message-State: APjAAAWsjt4klPZH03F/75UO4y0DSnpCu292ZdnPSLS/rxBffOWagjI9
        4Gz0tGWrgmzJ0dwmy0MYVfMKEuf6Xh8f7IDD6Sg=
X-Google-Smtp-Source: APXvYqxQ0IAVpdvqH/6L/z3vKO5sqZh7AV/GzOD0ZgfgZpJOtI55RRZPyocLHJD21uO/BCbrSaNClnlzGG4ejwhB/ZA=
X-Received: by 2002:a92:d7c6:: with SMTP id g6mr19773434ilq.282.1582050408393;
 Tue, 18 Feb 2020 10:26:48 -0800 (PST)
MIME-Version: 1.0
References: <20200218153526.31389-1-jlayton@kernel.org>
In-Reply-To: <20200218153526.31389-1-jlayton@kernel.org>
From:   Ilya Dryomov <idryomov@gmail.com>
Date:   Tue, 18 Feb 2020 19:27:13 +0100
Message-ID: <CAOi1vP-wbXxjnVSyyFf2anUf9kbsVjfP7iGdbxeDfbaYNtsnNw@mail.gmail.com>
Subject: Re: [PATCH v2] ceph: move to a dedicated slabcache for mds requests
To:     Jeff Layton <jlayton@kernel.org>
Cc:     Ceph Development <ceph-devel@vger.kernel.org>,
        Sage Weil <sage@redhat.com>, "Yan, Zheng" <zyan@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Tue, Feb 18, 2020 at 4:35 PM Jeff Layton <jlayton@kernel.org> wrote:
>
> On my machine (x86_64) this struct is 952 bytes, which gets rounded up
> to 1024 by kmalloc. Move this to a dedicated slabcache, so we can
> allocate them without the extra 72 bytes of overhead per.
>
> Signed-off-by: Jeff Layton <jlayton@kernel.org>
> ---
>  fs/ceph/mds_client.c         | 5 +++--
>  fs/ceph/super.c              | 8 ++++++++
>  include/linux/ceph/libceph.h | 1 +
>  3 files changed, 12 insertions(+), 2 deletions(-)
>
> v2: switch to kmem_cache_zalloc()
>
> diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
> index 2980e57ca7b9..fab9d6461a65 100644
> --- a/fs/ceph/mds_client.c
> +++ b/fs/ceph/mds_client.c
> @@ -736,7 +736,7 @@ void ceph_mdsc_release_request(struct kref *kref)
>         put_request_session(req);
>         ceph_unreserve_caps(req->r_mdsc, &req->r_caps_reservation);
>         WARN_ON_ONCE(!list_empty(&req->r_wait));
> -       kfree(req);
> +       kmem_cache_free(ceph_mds_request_cachep, req);
>  }
>
>  DEFINE_RB_FUNCS(request, struct ceph_mds_request, r_tid, r_node)
> @@ -2094,8 +2094,9 @@ int ceph_alloc_readdir_reply_buffer(struct ceph_mds_request *req,
>  struct ceph_mds_request *
>  ceph_mdsc_create_request(struct ceph_mds_client *mdsc, int op, int mode)
>  {
> -       struct ceph_mds_request *req = kzalloc(sizeof(*req), GFP_NOFS);
> +       struct ceph_mds_request *req;
>
> +       req = kmem_cache_zalloc(ceph_mds_request_cachep, GFP_NOFS);
>         if (!req)
>                 return ERR_PTR(-ENOMEM);
>
> diff --git a/fs/ceph/super.c b/fs/ceph/super.c
> index c7f150686a53..b1329cd5388a 100644
> --- a/fs/ceph/super.c
> +++ b/fs/ceph/super.c
> @@ -729,6 +729,7 @@ struct kmem_cache *ceph_cap_flush_cachep;
>  struct kmem_cache *ceph_dentry_cachep;
>  struct kmem_cache *ceph_file_cachep;
>  struct kmem_cache *ceph_dir_file_cachep;
> +struct kmem_cache *ceph_mds_request_cachep;
>
>  static void ceph_inode_init_once(void *foo)
>  {
> @@ -769,6 +770,10 @@ static int __init init_caches(void)
>         if (!ceph_dir_file_cachep)
>                 goto bad_dir_file;
>
> +       ceph_mds_request_cachep = KMEM_CACHE(ceph_mds_request, SLAB_MEM_SPREAD);
> +       if (!ceph_mds_request_cachep)
> +               goto bad_mds_req;
> +
>         error = ceph_fscache_register();
>         if (error)
>                 goto bad_fscache;
> @@ -776,6 +781,8 @@ static int __init init_caches(void)
>         return 0;
>
>  bad_fscache:
> +       kmem_cache_destroy(ceph_mds_request_cachep);
> +bad_mds_req:
>         kmem_cache_destroy(ceph_dir_file_cachep);
>  bad_dir_file:
>         kmem_cache_destroy(ceph_file_cachep);
> @@ -804,6 +811,7 @@ static void destroy_caches(void)
>         kmem_cache_destroy(ceph_dentry_cachep);
>         kmem_cache_destroy(ceph_file_cachep);
>         kmem_cache_destroy(ceph_dir_file_cachep);
> +       kmem_cache_destroy(ceph_mds_request_cachep);
>
>         ceph_fscache_unregister();
>  }
> diff --git a/include/linux/ceph/libceph.h b/include/linux/ceph/libceph.h
> index ec73ebc4827d..525b7c3f1c81 100644
> --- a/include/linux/ceph/libceph.h
> +++ b/include/linux/ceph/libceph.h
> @@ -272,6 +272,7 @@ extern struct kmem_cache *ceph_cap_flush_cachep;
>  extern struct kmem_cache *ceph_dentry_cachep;
>  extern struct kmem_cache *ceph_file_cachep;
>  extern struct kmem_cache *ceph_dir_file_cachep;
> +extern struct kmem_cache *ceph_mds_request_cachep;
>
>  /* ceph_common.c */
>  extern bool libceph_compatible(void *data);

Looks good, thanks for addressing my nit.

                Ilya
