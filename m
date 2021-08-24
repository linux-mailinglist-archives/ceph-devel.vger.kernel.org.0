Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF52A3F6041
	for <lists+ceph-devel@lfdr.de>; Tue, 24 Aug 2021 16:25:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237755AbhHXO0J (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 24 Aug 2021 10:26:09 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:31335 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237731AbhHXO0I (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Tue, 24 Aug 2021 10:26:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1629815123;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=jS4DMiYMJEvLKBLFhfVXQbwK/7O32UF1dBTczqvLw1Y=;
        b=BlaFjdHzjk9Eerzt1bRAubbkSEHUstJp9RWZzfMtvLjEHqLlt/LQbAgnVXgBXaqup+dls+
        hUffbufSCi7yr4+nzrVF/kO4kRbJdHzLPPGwkcs2Gi5xbZW7DA9AQK+gS/mZpqYk5d+3ct
        2N3RgowYBcc4TUNlq4OqBqs0WKMs/+A=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-357-jVFi6A7jPA6Chi3CakM5jQ-1; Tue, 24 Aug 2021 10:25:22 -0400
X-MC-Unique: jVFi6A7jPA6Chi3CakM5jQ-1
Received: by mail-qk1-f199.google.com with SMTP id c27-20020a05620a165b00b003d3817c7c23so14324904qko.16
        for <ceph-devel@vger.kernel.org>; Tue, 24 Aug 2021 07:25:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=jS4DMiYMJEvLKBLFhfVXQbwK/7O32UF1dBTczqvLw1Y=;
        b=m+yVcQE1R4StYduvw1EDqIAlt05T0mrBaoKgsxBrwp3AbWeiFIsMwcXROpgyeb7t0s
         fScgItVRauQ1U5PbPu+BVUj8rcCs1tLO8iy32bGLOwQ/aiQeDPFXDMQ8fVAZyYViZviC
         r3MaLU/qcMrF0fRP+0ZHA3/fUKUmkRjMWoUi6/f2d1lIOHfkZSNj4tsnkEnk6PMJazjP
         uR3qNrIlxoCzSLDG1+E1KrfQdglVE/BVYZMnrObgQeO77INu2GW+14lCeCvmjD4qTuaE
         tyIssEXQhy7f9ZrHIvHgq4Omhi0Ww0neeOaWICnaGRmzDlWTVatFawzP108eu+15csbn
         R18Q==
X-Gm-Message-State: AOAM530afOV/ksUaA1btcyp4XbT0BNMnuvVs3QyrQml4hA64Cb/EDy77
        lJX2vYkfU9zVZnkX+xsbRfTSGm+rqGL8n/nTMT7xGG49WY7b/mPc2pbDG8F6kxwlHVJlg+fDb9g
        fEkOa/5v+A/rqLEUC1CApmQ==
X-Received: by 2002:a05:620a:4050:: with SMTP id i16mr25621272qko.90.1629815121783;
        Tue, 24 Aug 2021 07:25:21 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyw/vN4HfM869zB70GdhFgvXTyrDBhnvRbUsGuCtjTO3eGJIomB0OdYM13LOc5okIw+BG25bQ==
X-Received: by 2002:a05:620a:4050:: with SMTP id i16mr25621249qko.90.1629815121635;
        Tue, 24 Aug 2021 07:25:21 -0700 (PDT)
Received: from [192.168.1.3] (68-20-15-154.lightspeed.rlghnc.sbcglobal.net. [68.20.15.154])
        by smtp.gmail.com with ESMTPSA id w20sm10217864qkj.116.2021.08.24.07.25.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Aug 2021 07:25:21 -0700 (PDT)
Message-ID: <01c442d2b3aff85e0e95bfefb44ac6e77eb3373f.camel@redhat.com>
Subject: Re: [PATCH 00/12] fscache: Some prep work for fscache rewrite
From:   Jeff Layton <jlayton@redhat.com>
To:     David Howells <dhowells@redhat.com>, linux-cachefs@redhat.com
Cc:     Anna Schumaker <anna.schumaker@netapp.com>,
        Steve French <sfrench@samba.org>,
        Dominique Martinet <asmadeus@codewreck.org>,
        David Wysochanski <dwysocha@redhat.com>,
        linux-afs@lists.infradead.org, linux-nfs@vger.kernel.org,
        linux-cifs@vger.kernel.org, ceph-devel@vger.kernel.org,
        v9fs-developer@lists.sourceforge.net,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Date:   Tue, 24 Aug 2021 10:25:20 -0400
In-Reply-To: <162431188431.2908479.14031376932042135080.stgit@warthog.procyon.org.uk>
References: <162431188431.2908479.14031376932042135080.stgit@warthog.procyon.org.uk>
Content-Type: text/plain; charset="ISO-8859-15"
User-Agent: Evolution 3.40.4 (3.40.4-1.fc34) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Mon, 2021-06-21 at 22:44 +0100, David Howells wrote:
> Here are some patches that perform some preparatory work for the fscache
> rewrite that's being worked on.  These include:
> 
>  (1) Always select netfs stats when enabling fscache stats since they're
>      displayed through the same procfile.
> 
>  (2) Add a cookie debug ID that can be used in tracepoints instead of a
>      pointer and cache it in the netfs_cache_resources struct rather than
>      in the netfs_read_request struct to make it more available.
> 
>  (3) Use file_inode() in cachefiles rather than dereferencing file->f_inode
>      directly.
> 
>  (4) Provide a procfile to display fscache cookies.
> 
>  (5) Remove the fscache and cachefiles histogram procfiles.
> 
>  (6) Remove the fscache object list procfile.
> 
>  (7) Avoid using %p in fscache and cachefiles as the value is hashed and
>      not comparable to the register dump in an oops trace.
> 
>  (8) Fix the cookie hash function to actually achieve useful dispersion.
> 
>  (9) Fix fscache_cookie_put() so that it doesn't dereference the cookie
>      pointer in the tracepoint after the refcount has been decremented
>      (we're only allowed to do that if we decremented it to zero).
> 
> (10) Use refcount_t rather than atomic_t for the fscache_cookie refcount.
> 
> The patches can be found on this branch:
> 
> 	http://git.kernel.org/cgit/linux/kernel/git/dhowells/linux-fs.git/log/?h=fscache-next
> 
> David
> ---
> David Howells (12):
>       fscache: Select netfs stats if fscache stats are enabled
>       netfs: Move cookie debug ID to struct netfs_cache_resources
>       cachefiles: Use file_inode() rather than accessing ->f_inode
>       fscache: Add a cookie debug ID and use that in traces
>       fscache: Procfile to display cookies
>       fscache, cachefiles: Remove the histogram stuff
>       fscache: Remove the object list procfile
>       fscache: Change %p in format strings to something else
>       cachefiles: Change %p in format strings to something else
>       fscache: Fix cookie key hashing
>       fscache: Fix fscache_cookie_put() to not deref after dec
>       fscache: Use refcount_t for the cookie refcount instead of atomic_t
> 
> 
>  fs/cachefiles/Kconfig             |  19 --
>  fs/cachefiles/Makefile            |   2 -
>  fs/cachefiles/bind.c              |   2 -
>  fs/cachefiles/interface.c         |   6 +-
>  fs/cachefiles/internal.h          |  25 --
>  fs/cachefiles/io.c                |   6 +-
>  fs/cachefiles/key.c               |   2 +-
>  fs/cachefiles/main.c              |   7 -
>  fs/cachefiles/namei.c             |  61 ++---
>  fs/cachefiles/proc.c              | 114 --------
>  fs/cachefiles/xattr.c             |   4 +-
>  fs/fscache/Kconfig                |  24 --
>  fs/fscache/Makefile               |   2 -
>  fs/fscache/cache.c                |  11 +-
>  fs/fscache/cookie.c               | 201 +++++++++++----
>  fs/fscache/fsdef.c                |   3 +-
>  fs/fscache/histogram.c            |  87 -------
>  fs/fscache/internal.h             |  57 +---
>  fs/fscache/main.c                 |  39 +++
>  fs/fscache/netfs.c                |   2 +-
>  fs/fscache/object-list.c          | 414 ------------------------------
>  fs/fscache/object.c               |   8 -
>  fs/fscache/operation.c            |   3 -
>  fs/fscache/page.c                 |   6 -
>  fs/fscache/proc.c                 |  20 +-
>  include/linux/fscache-cache.h     |   4 -
>  include/linux/fscache.h           |   4 +-
>  include/linux/netfs.h             |   2 +-
>  include/trace/events/cachefiles.h |  68 ++---
>  include/trace/events/fscache.h    | 160 ++++++------
>  include/trace/events/netfs.h      |   2 +-
>  31 files changed, 367 insertions(+), 998 deletions(-)
>  delete mode 100644 fs/cachefiles/proc.c
>  delete mode 100644 fs/fscache/histogram.c
>  delete mode 100644 fs/fscache/object-list.c
> 
> 

This all looks good (modulo a nitpicky changelog comment). You can add:

Reviewed-by: Jeff Layton <jlayton@redhat.com>

