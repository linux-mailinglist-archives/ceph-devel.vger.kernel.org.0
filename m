Return-Path: <ceph-devel+bounces-182-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id DDA677F5666
	for <lists+ceph-devel@lfdr.de>; Thu, 23 Nov 2023 03:25:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8B605280C60
	for <lists+ceph-devel@lfdr.de>; Thu, 23 Nov 2023 02:25:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CF9B54420;
	Thu, 23 Nov 2023 02:25:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="BUFlmHRw"
X-Original-To: ceph-devel@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1553B191
	for <ceph-devel@vger.kernel.org>; Wed, 22 Nov 2023 18:25:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1700706329;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=4fZhNq8GJeX9SWeHe/i+bqnWhN/Cr+deFv7p3LiotmY=;
	b=BUFlmHRw8K/945aB/py2+XSGanLnfyIHbaUP2ewYnM4IGRX1jYmpn6EOBYS8zT8869Xn5O
	WhNl6hSecQzMFW+dR1wRsWa/DI4nNFNogwef7Z1dsVeipKoS6Rubltk1wDJ8p9NFFptOik
	rYs9KC8P6ASf3Qb2k80QOxJF1LsXdII=
Received: from mail-pg1-f199.google.com (mail-pg1-f199.google.com
 [209.85.215.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-558-jcnhMyHfPVC0ggB2SRidjw-1; Wed, 22 Nov 2023 21:25:25 -0500
X-MC-Unique: jcnhMyHfPVC0ggB2SRidjw-1
Received: by mail-pg1-f199.google.com with SMTP id 41be03b00d2f7-5c1bfc5066aso363006a12.2
        for <ceph-devel@vger.kernel.org>; Wed, 22 Nov 2023 18:25:25 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1700706324; x=1701311124;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=4fZhNq8GJeX9SWeHe/i+bqnWhN/Cr+deFv7p3LiotmY=;
        b=sA+9VW8WmZFDw9/8gxvt4UfpmGEck2R+pSd0niSzBQjwPIjpc80FazmY/QVvSCA+Ve
         G3Thf3OH4Nm9LzT02whiBwctV0HMVjx0se8vEgXexn3riGdS1NMYjoWT6zZXIzbLnOZZ
         AUXgp82SusXRj3iF1o/xa61Jina8Yf0O5MCHYzqMXDSDaAw3zROH62rtUuzLYHWld4kE
         bMj5QLxKYgj62Xnc+m8VL5luOR7Ctr7xvzK9toxwPRyQaTzd5q/3OvIV9tCx0Xb2IbFf
         OKveqASGbr+WxzAEUwaOdxlZiv2ywKq2hc4T/6l8iJQMeizESmC9GfE+L4If8Au//USW
         Wlow==
X-Gm-Message-State: AOJu0YzpaOeJo6Med7XHtMTsNSFGCfCfbCSxidL3Wk6bSLw32ZF+k5H8
	l9zrNLGH9tHjmdUcdqWIzGFMOLcdsyv0F9gz4joykRj2QB3clGS89Rwtwgb91VQKcci6k7Zkd3T
	vvE0XUBNNUNijgn2mWyNyyg==
X-Received: by 2002:a05:6a20:8e27:b0:18a:d8ba:ca4c with SMTP id y39-20020a056a208e2700b0018ad8baca4cmr4605137pzj.52.1700706324639;
        Wed, 22 Nov 2023 18:25:24 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGxR7M/YEWGyFnEtNUc5LBO0hyjZ/IXAwm0JsZfrzv3JEa1H0xAKSCsRQjwMBfMFkkL/yrBvw==
X-Received: by 2002:a05:6a20:8e27:b0:18a:d8ba:ca4c with SMTP id y39-20020a056a208e2700b0018ad8baca4cmr4605122pzj.52.1700706324252;
        Wed, 22 Nov 2023 18:25:24 -0800 (PST)
Received: from [10.72.112.224] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id a16-20020a170902ecd000b001cf5d59c739sm100589plh.271.2023.11.22.18.25.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 22 Nov 2023 18:25:23 -0800 (PST)
Message-ID: <748532c2-9382-0a3c-8acd-c8261f741174@redhat.com>
Date: Thu, 23 Nov 2023 10:25:18 +0800
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH v3] ceph: quota: Fix invalid pointer access if
 get_quota_realm return ERR_PTR
Content-Language: en-US
To: Wenchao Hao <haowenchao2@huawei.com>, Ilya Dryomov <idryomov@gmail.com>,
 Jeff Layton <jlayton@kernel.org>, Luis Henriques <lhenriques@suse.de>,
 ceph-devel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
References: <20231123015340.3935321-1-haowenchao2@huawei.com>
From: Xiubo Li <xiubli@redhat.com>
In-Reply-To: <20231123015340.3935321-1-haowenchao2@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit


On 11/23/23 09:53, Wenchao Hao wrote:
> This issue is reported by smatch that get_quota_realm() might return
> ERR_PTR but we did not handle it. It's not a immediate bug, while we
> still should address it to avoid potential bugs if get_quota_realm()
> is changed to return other ERR_PTR in future.
>
> Set ceph_snap_realm's pointer in get_quota_realm()'s to address this
> issue, the pointer would be set to NULL if get_quota_realm() failed
> to get struct ceph_snap_realm, so no ERR_PTR would happen any more.
>
> Signed-off-by: Wenchao Hao <haowenchao2@huawei.com>
> ---
> V3:
>   - Remove redundant variable initialization in ceph_quota_is_same_realm
>
> V2:
>   - Fix all potential invalid pointer access caused by get_quota_realm
>   - Update commit comment and point it's not a immediate bug
>
>   fs/ceph/quota.c | 39 ++++++++++++++++++++++-----------------
>   1 file changed, 22 insertions(+), 17 deletions(-)
>
> diff --git a/fs/ceph/quota.c b/fs/ceph/quota.c
> index 9d36c3532de1..b25906a5bfbb 100644
> --- a/fs/ceph/quota.c
> +++ b/fs/ceph/quota.c
> @@ -197,10 +197,10 @@ void ceph_cleanup_quotarealms_inodes(struct ceph_mds_client *mdsc)
>   }
>   
>   /*
> - * This function walks through the snaprealm for an inode and returns the
> - * ceph_snap_realm for the first snaprealm that has quotas set (max_files,
> + * This function walks through the snaprealm for an inode and set the
> + * realmp with the first snaprealm that has quotas set (max_files,
>    * max_bytes, or any, depending on the 'which_quota' argument).  If the root is
> - * reached, return the root ceph_snap_realm instead.
> + * reached, set the realmp with the root ceph_snap_realm instead.
>    *
>    * Note that the caller is responsible for calling ceph_put_snap_realm() on the
>    * returned realm.
> @@ -211,10 +211,9 @@ void ceph_cleanup_quotarealms_inodes(struct ceph_mds_client *mdsc)
>    * this function will return -EAGAIN; otherwise, the snaprealms walk-through
>    * will be restarted.
>    */
> -static struct ceph_snap_realm *get_quota_realm(struct ceph_mds_client *mdsc,
> -					       struct inode *inode,
> -					       enum quota_get_realm which_quota,
> -					       bool retry)
> +static int get_quota_realm(struct ceph_mds_client *mdsc, struct inode *inode,
> +			   enum quota_get_realm which_quota,
> +			   struct ceph_snap_realm **realmp, bool retry)
>   {
>   	struct ceph_client *cl = mdsc->fsc->client;
>   	struct ceph_inode_info *ci = NULL;
> @@ -222,8 +221,10 @@ static struct ceph_snap_realm *get_quota_realm(struct ceph_mds_client *mdsc,
>   	struct inode *in;
>   	bool has_quota;
>   
> +	if (realmp)
> +		*realmp = NULL;
>   	if (ceph_snap(inode) != CEPH_NOSNAP)
> -		return NULL;
> +		return 0;
>   
>   restart:
>   	realm = ceph_inode(inode)->i_snap_realm;
> @@ -250,7 +251,7 @@ static struct ceph_snap_realm *get_quota_realm(struct ceph_mds_client *mdsc,
>   				break;
>   			ceph_put_snap_realm(mdsc, realm);
>   			if (!retry)
> -				return ERR_PTR(-EAGAIN);
> +				return -EAGAIN;
>   			goto restart;
>   		}
>   
> @@ -259,8 +260,11 @@ static struct ceph_snap_realm *get_quota_realm(struct ceph_mds_client *mdsc,
>   		iput(in);
>   
>   		next = realm->parent;
> -		if (has_quota || !next)
> -		       return realm;
> +		if (has_quota || !next) {
> +			if (realmp)
> +				*realmp = realm;
> +			return 0;
> +		}
>   
>   		ceph_get_snap_realm(mdsc, next);
>   		ceph_put_snap_realm(mdsc, realm);
> @@ -269,7 +273,7 @@ static struct ceph_snap_realm *get_quota_realm(struct ceph_mds_client *mdsc,
>   	if (realm)
>   		ceph_put_snap_realm(mdsc, realm);
>   
> -	return NULL;
> +	return 0;
>   }
>   
>   bool ceph_quota_is_same_realm(struct inode *old, struct inode *new)
> @@ -277,6 +281,7 @@ bool ceph_quota_is_same_realm(struct inode *old, struct inode *new)
>   	struct ceph_mds_client *mdsc = ceph_sb_to_mdsc(old->i_sb);
>   	struct ceph_snap_realm *old_realm, *new_realm;
>   	bool is_same;
> +	int ret;
>   
>   restart:
>   	/*
> @@ -286,9 +291,9 @@ bool ceph_quota_is_same_realm(struct inode *old, struct inode *new)
>   	 * dropped and we can then restart the whole operation.
>   	 */
>   	down_read(&mdsc->snap_rwsem);
> -	old_realm = get_quota_realm(mdsc, old, QUOTA_GET_ANY, true);
> -	new_realm = get_quota_realm(mdsc, new, QUOTA_GET_ANY, false);
> -	if (PTR_ERR(new_realm) == -EAGAIN) {
> +	get_quota_realm(mdsc, old, QUOTA_GET_ANY, &old_realm, true);
> +	ret = get_quota_realm(mdsc, new, QUOTA_GET_ANY, &new_realm, false);
> +	if (ret == -EAGAIN) {
>   		up_read(&mdsc->snap_rwsem);
>   		if (old_realm)
>   			ceph_put_snap_realm(mdsc, old_realm);
> @@ -492,8 +497,8 @@ bool ceph_quota_update_statfs(struct ceph_fs_client *fsc, struct kstatfs *buf)
>   	bool is_updated = false;
>   
>   	down_read(&mdsc->snap_rwsem);
> -	realm = get_quota_realm(mdsc, d_inode(fsc->sb->s_root),
> -				QUOTA_GET_MAX_BYTES, true);
> +	get_quota_realm(mdsc, d_inode(fsc->sb->s_root),
> +				QUOTA_GET_MAX_BYTES, &realm, true);

Some extra white spaces here.

Otherwise LGTM.

I will adjust it and applying it to the testing branch.

Thanks

- Xiubo

>   	up_read(&mdsc->snap_rwsem);
>   	if (!realm)
>   		return false;


