Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A5CFA5CE3A
	for <lists+ceph-devel@lfdr.de>; Tue,  2 Jul 2019 13:15:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726369AbfGBLP1 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 2 Jul 2019 07:15:27 -0400
Received: from mail-yb1-f196.google.com ([209.85.219.196]:34909 "EHLO
        mail-yb1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726305AbfGBLP1 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 2 Jul 2019 07:15:27 -0400
Received: by mail-yb1-f196.google.com with SMTP id p85so1169778yba.2
        for <ceph-devel@vger.kernel.org>; Tue, 02 Jul 2019 04:15:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=AU/yxioX5MeEbNLlk6+Fqc2847LOxYHCFHhQ99AFEbs=;
        b=BgGKkxRI6270y0We/cbbUc3Uf644GSCr0h+VROEDiFuHp0c3cOyB1N0MOCOQcle2OE
         shsHM6cYXaJ9q0ZbKZSWMWg9rLSjCcfsqZIa+buDu/XHEjHludw/7u5q6OkYsT5PE+ft
         w8ImljfeJ//0Ar2MIBPX4zvvv4y2Zi+7tN5FmSU+nA5yUAjTSo4u7lNxYoIWBb1IMVty
         W2eZOYxcZ/W6VU2aB3hpTe5ut/Ir7b9YRFw2e1C1OjCgxeIg8qHf3dVe/ryWHgZS3vvo
         BJPtiH/1FWbIC+AxVqruZqvKU6MVnLdis5vWrRh0MJ/CFHBO9TRlDdxiAsXIpflCCJ1c
         vZLQ==
X-Gm-Message-State: APjAAAXjilXFbuxJq9/lSkNqsXVyORHOVw+Iz8KaY/1orEdG96ibsD3t
        nqOA1XCJzyl0CbVUwFsBb9C7FOMVGv4=
X-Google-Smtp-Source: APXvYqy25LctTZaCQRrLKK/UTXT3BZvRiEcbH9HDOHxEqeppzNuwSJ6RzVLDfxyk3znOQl2V6Vkr5A==
X-Received: by 2002:a25:3d44:: with SMTP id k65mr20315375yba.43.1562066126495;
        Tue, 02 Jul 2019 04:15:26 -0700 (PDT)
Received: from tleilax.poochiereds.net (cpe-2606-A000-1100-37D-0-0-0-E37.dyn6.twc.com. [2606:a000:1100:37d::e37])
        by smtp.gmail.com with ESMTPSA id e20sm3260490ywe.95.2019.07.02.04.15.25
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 02 Jul 2019 04:15:25 -0700 (PDT)
Message-ID: <ae4debe6088381e32444fd24942686236b9c8442.camel@redhat.com>
Subject: Re: [PATCH] ceph: use ceph_evict_inode to cleanup inode's resource
From:   Jeff Layton <jlayton@redhat.com>
To:     "Yan, Zheng" <zyan@redhat.com>, ceph-devel@vger.kernel.org
Cc:     idryomov@redhat.com
Date:   Tue, 02 Jul 2019 07:15:23 -0400
In-Reply-To: <20190702013254.21028-1-zyan@redhat.com>
References: <20190702013254.21028-1-zyan@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.32.3 (3.32.3-1.fc30) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Tue, 2019-07-02 at 09:32 +0800, Yan, Zheng wrote:
> remove_session_caps() relies on __wait_on_freeing_inode(), to wait for
> freeing inode to remove its caps. But VFS wakes freeing inode waiters
> before calling destroy_inode().
> 
> Link: https://tracker.ceph.com/issues/40102
> Cc: stable@vger.kernel.org
> Signed-off-by: "Yan, Zheng" <zyan@redhat.com>
> ---
>  fs/ceph/inode.c | 7 +++++--
>  fs/ceph/super.c | 2 +-
>  fs/ceph/super.h | 2 +-
>  3 files changed, 7 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
> index 2c49eb831c6f..a565ab124282 100644
> --- a/fs/ceph/inode.c
> +++ b/fs/ceph/inode.c
> @@ -526,13 +526,16 @@ void ceph_free_inode(struct inode *inode)
>  	kmem_cache_free(ceph_inode_cachep, ci);
>  }
>  
> -void ceph_destroy_inode(struct inode *inode)
> +void ceph_evict_inode(struct inode *inode)
>  {
>  	struct ceph_inode_info *ci = ceph_inode(inode);
>  	struct ceph_inode_frag *frag;
>  	struct rb_node *n;
>  
> -	dout("destroy_inode %p ino %llx.%llx\n", inode, ceph_vinop(inode));
> +	dout("evict_inode %p ino %llx.%llx\n", inode, ceph_vinop(inode));
> +
> +	truncate_inode_pages_final(&inode->i_data);
> +	clear_inode(inode);
>  
>  	ceph_fscache_unregister_inode_cookie(ci);
>  
> diff --git a/fs/ceph/super.c b/fs/ceph/super.c
> index c21201a951ce..5f0c950ca966 100644
> --- a/fs/ceph/super.c
> +++ b/fs/ceph/super.c
> @@ -840,10 +840,10 @@ static int ceph_remount(struct super_block *sb, int *flags, char *data)
>  
>  static const struct super_operations ceph_super_ops = {
>  	.alloc_inode	= ceph_alloc_inode,
> -	.destroy_inode	= ceph_destroy_inode,
>  	.free_inode	= ceph_free_inode,
>  	.write_inode    = ceph_write_inode,
>  	.drop_inode	= ceph_drop_inode,
> +	.evict_inode	= ceph_evict_inode,
>  	.sync_fs        = ceph_sync_fs,
>  	.put_super	= ceph_put_super,
>  	.remount_fs	= ceph_remount,
> diff --git a/fs/ceph/super.h b/fs/ceph/super.h
> index a592d4a8266c..30e9a4e415cc 100644
> --- a/fs/ceph/super.h
> +++ b/fs/ceph/super.h
> @@ -884,7 +884,7 @@ static inline bool __ceph_have_pending_cap_snap(struct ceph_inode_info *ci)
>  extern const struct inode_operations ceph_file_iops;
>  
>  extern struct inode *ceph_alloc_inode(struct super_block *sb);
> -extern void ceph_destroy_inode(struct inode *inode);
> +extern void ceph_evict_inode(struct inode *inode);
>  extern void ceph_free_inode(struct inode *inode);
>  extern int ceph_drop_inode(struct inode *inode);
>  

Looks good.

Reviewed-by: Jeff Layton <jlayton@redhat.com>

