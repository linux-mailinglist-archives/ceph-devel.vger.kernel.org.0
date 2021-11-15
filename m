Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D09D544FD4A
	for <lists+ceph-devel@lfdr.de>; Mon, 15 Nov 2021 03:56:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229723AbhKOC7w (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Sun, 14 Nov 2021 21:59:52 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:41285 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229568AbhKOC7j (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Sun, 14 Nov 2021 21:59:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1636945004;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=8fEy9up/M+0PBrQO4A1PKgHkl5KAwX/RYMk7/9/S6j4=;
        b=ifMZQhaFvcb5MR80AWMmExvQnrqjl26vcJMNRDqNvHa+WWRsw0KBVB+Q7M3LScf1nbsHzp
        EMJlO9i5OLG+5eQYtSxsZSec+kPprTXccxafQhHeqinZ7Tj5PK7rbCh6YgOYUZPiYQ+kMX
        otR2LOYvGH1lxhPjssohoO56ZJMauNM=
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com
 [209.85.216.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-242-D6x0ic2YMuuOriCTBSMyZw-1; Sun, 14 Nov 2021 21:56:38 -0500
X-MC-Unique: D6x0ic2YMuuOriCTBSMyZw-1
Received: by mail-pj1-f71.google.com with SMTP id gx17-20020a17090b125100b001a6f72e2dbdso4619671pjb.7
        for <ceph-devel@vger.kernel.org>; Sun, 14 Nov 2021 18:56:38 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=8fEy9up/M+0PBrQO4A1PKgHkl5KAwX/RYMk7/9/S6j4=;
        b=T6SFoJ5iYXVDP5KluE3SglU+fAoY7wcnkMT/ebiVgLP16B6hgF08iNb6oY0S6ODHeF
         htnBpJFbp6RVozIXi5hdZroSAJP8cxdBH0L4r2WduXBDtNWdnZWxd4VQDJONVcV2W4Ro
         fiZNcNWp+Uiulz/sPBc+MyU9kjon63BhX/qhkadCSf2gIqegfFJUInkjuDMD5NKMr1JW
         mRyokn/fYyD8x6+N+T0301Suz6D8nDKWR2AuFILnqeGOG3hL9Pjnb3brj61qpaZ/AwbI
         ida9GUNjfona4p45WnH/X4BFsY5gbVPMVAIpxvbU2fyLtZZwG9d6FYgBzdNziyWq1i7R
         dYXw==
X-Gm-Message-State: AOAM530DXn7IMnAnnGAsNG73ko8KguFjRwEiTWRBD2BhY6qJhCJSL14T
        xX0302p1qPG/5I5xXT9h6/fQF4Dz/rdd6wJjOZtTxK9EMrtrCKWUj112RWEcMgqeAf6xa2fDsME
        hYxo2jzFxcjgzcOckizCZrg==
X-Received: by 2002:a63:54f:: with SMTP id 76mr22479149pgf.26.1636944997816;
        Sun, 14 Nov 2021 18:56:37 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyxdWM4nKcuGQqMlcnHCg4WoC8kkYtHDXihnLI0dbsDbyD2NSiydQWuMQu9k9VtLq8lK8+FRA==
X-Received: by 2002:a63:54f:: with SMTP id 76mr22479129pgf.26.1636944997574;
        Sun, 14 Nov 2021 18:56:37 -0800 (PST)
Received: from [10.72.12.80] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id mi18sm11409245pjb.13.2021.11.14.18.56.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 14 Nov 2021 18:56:37 -0800 (PST)
Subject: Re: [PATCH] ceph: don't check for quotas on MDS stray dirs
To:     Jeff Layton <jlayton@kernel.org>, ceph-devel@vger.kernel.org
Cc:     idryomov@gmail.com, lhenriques@suse.de
References: <20211109171011.39571-1-jlayton@kernel.org>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <90f6ac4c-5b7c-9769-2fb1-a2880f30ab54@redhat.com>
Date:   Mon, 15 Nov 2021 10:56:32 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20211109171011.39571-1-jlayton@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


On 11/10/21 1:10 AM, Jeff Layton wrote:
> 玮文 胡 reported seeing the WARN_RATELIMITED pop when writing to an
> inode that had been transplanted into the stray dir. The client was
> trying to look up the quotarealm info from the parent and that tripped
> the warning.
>
> Change the ceph_vino_is_reserved helper to not throw a warning and
> add a new ceph_vino_warn_reserved() helper that does. Change all of the
> existing callsites to call the "warn" variant, and have
> ceph_has_realms_with_quotas check return false when the vino is
> reserved.
>
> URL: https://tracker.ceph.com/issues/53180
> Signed-off-by: Jeff Layton <jlayton@kernel.org>
> ---
>   fs/ceph/export.c |  4 ++--
>   fs/ceph/inode.c  |  2 +-
>   fs/ceph/quota.c  |  3 +++
>   fs/ceph/super.h  | 17 ++++++++++-------
>   4 files changed, 16 insertions(+), 10 deletions(-)
>
> diff --git a/fs/ceph/export.c b/fs/ceph/export.c
> index e0fa66ac8b9f..a75cf07d668f 100644
> --- a/fs/ceph/export.c
> +++ b/fs/ceph/export.c
> @@ -130,7 +130,7 @@ static struct inode *__lookup_inode(struct super_block *sb, u64 ino)
>   	vino.ino = ino;
>   	vino.snap = CEPH_NOSNAP;
>   
> -	if (ceph_vino_is_reserved(vino))
> +	if (ceph_vino_warn_reserved(vino))
>   		return ERR_PTR(-ESTALE);
>   
>   	inode = ceph_find_inode(sb, vino);
> @@ -224,7 +224,7 @@ static struct dentry *__snapfh_to_dentry(struct super_block *sb,
>   		vino.snap = sfh->snapid;
>   	}
>   
> -	if (ceph_vino_is_reserved(vino))
> +	if (ceph_vino_warn_reserved(vino))
>   		return ERR_PTR(-ESTALE);
>   
>   	inode = ceph_find_inode(sb, vino);
> diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
> index e8eb8612ddd6..a685fab56772 100644
> --- a/fs/ceph/inode.c
> +++ b/fs/ceph/inode.c
> @@ -56,7 +56,7 @@ struct inode *ceph_get_inode(struct super_block *sb, struct ceph_vino vino)
>   {
>   	struct inode *inode;
>   
> -	if (ceph_vino_is_reserved(vino))
> +	if (ceph_vino_warn_reserved(vino))
>   		return ERR_PTR(-EREMOTEIO);
>   
>   	inode = iget5_locked(sb, (unsigned long)vino.ino, ceph_ino_compare,
> diff --git a/fs/ceph/quota.c b/fs/ceph/quota.c
> index 620c691af40e..d1158c40bb0c 100644
> --- a/fs/ceph/quota.c
> +++ b/fs/ceph/quota.c
> @@ -30,6 +30,9 @@ static inline bool ceph_has_realms_with_quotas(struct inode *inode)
>   	/* if root is the real CephFS root, we don't have quota realms */
>   	if (root && ceph_ino(root) == CEPH_INO_ROOT)
>   		return false;
> +	/* MDS stray dirs have no quota realms */
> +	if (ceph_vino_is_reserved(ceph_inode(inode)->i_vino))
> +		return false;
>   	/* otherwise, we can't know for sure */
>   	return true;
>   }
> diff --git a/fs/ceph/super.h b/fs/ceph/super.h
> index ed51e04739c4..c232ed8e8a37 100644
> --- a/fs/ceph/super.h
> +++ b/fs/ceph/super.h
> @@ -547,18 +547,21 @@ static inline int ceph_ino_compare(struct inode *inode, void *data)
>   
>   static inline bool ceph_vino_is_reserved(const struct ceph_vino vino)
>   {
> -	if (vino.ino < CEPH_INO_SYSTEM_BASE &&
> -	    vino.ino >= CEPH_MDS_INO_MDSDIR_OFFSET) {
> -		WARN_RATELIMIT(1, "Attempt to access reserved inode number 0x%llx", vino.ino);
> -		return true;
> -	}
> -	return false;
> +	return vino.ino < CEPH_INO_SYSTEM_BASE &&
> +	       vino.ino >= CEPH_MDS_INO_MDSDIR_OFFSET;
> +}
> +
> +static inline bool ceph_vino_warn_reserved(const struct ceph_vino vino)
> +{
> +	return WARN_RATELIMIT(ceph_vino_is_reserved(vino),
> +				"Attempt to access reserved inode number 0x%llx",
> +				vino.ino);
>   }
>   
>   static inline struct inode *ceph_find_inode(struct super_block *sb,
>   					    struct ceph_vino vino)
>   {
> -	if (ceph_vino_is_reserved(vino))
> +	if (ceph_vino_warn_reserved(vino))
>   		return NULL;
>   
>   	/*

LGTM.

Reviewed-by: Xiubo Li <xiubli@redhat.com>


