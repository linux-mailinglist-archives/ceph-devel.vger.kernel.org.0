Return-Path: <ceph-devel+bounces-380-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 1D05B81ABDA
	for <lists+ceph-devel@lfdr.de>; Thu, 21 Dec 2023 01:45:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CD58B28710F
	for <lists+ceph-devel@lfdr.de>; Thu, 21 Dec 2023 00:45:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6F1ED10EB;
	Thu, 21 Dec 2023 00:45:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="I9dPuuab"
X-Original-To: ceph-devel@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B5CDEC3
	for <ceph-devel@vger.kernel.org>; Thu, 21 Dec 2023 00:45:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1703119527;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=O0mAFvrG1uLVuIDPupMM8tYALPgi3XmxPECK7F99iME=;
	b=I9dPuuabrxEFcocBmJUZbh5WgCe/1smNKHVB88DgAEyyjNvcAyV3wbgEicBvy0K5iF26xB
	eCwwPyYZRvccTTo8IBq/IOIe75ZbgPSOEThJx0Osnj7PpRc0Y4mF4ujJm+A3LdZCcloXnP
	HctpzWYiBMdTkdBPhluzb+QsTvYknEM=
Received: from mail-oi1-f198.google.com (mail-oi1-f198.google.com
 [209.85.167.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-454-oamaOL6tMWOL6SA2GMHj3w-1; Wed, 20 Dec 2023 19:45:25 -0500
X-MC-Unique: oamaOL6tMWOL6SA2GMHj3w-1
Received: by mail-oi1-f198.google.com with SMTP id 5614622812f47-3b9f0dce5bfso264967b6e.3
        for <ceph-devel@vger.kernel.org>; Wed, 20 Dec 2023 16:45:25 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1703119524; x=1703724324;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=O0mAFvrG1uLVuIDPupMM8tYALPgi3XmxPECK7F99iME=;
        b=QJKmD0FF6hEfKWUHGaMhRqoy1TF1KpumA7c8wjOE6fcDWlhQWQVd4qWjOCMUhOt/uG
         TCITyvnHcGSbky7sftT2EY4KSzQPQrUZNU/KhYBwOcatylkgiet12vZOdoAd/U4w9+NV
         luzRaSaXuJEBAN3jp5Wd4956cfqB/Jxx9m7RJ1JBKFfBiChiCMZF3weAiEc9/lrRpV+e
         Ym+zbIS06CuZYBqHrLxtnN5g24Sm+iqCZ2FEgyizWow/mSv7Uze3qBRQWVKpzhrDKP8o
         WqqFgPvBfu9kiGcZqj2BsMb4wgG3IDkCmqZvGClwrDNPT2B+bpymWWp6s3CFjTaUTZEW
         GXjw==
X-Gm-Message-State: AOJu0Yxmv+EnfSFxxIlmGSH+SYKnvFppU6kVTrXrk9VimPE2vBGaLtAB
	/7GV52iBgYxfGw+MOybK/04Bq6clbxeNnwddORkh1jGwDkqYlixnw41t1lIHWV/vJSSbL4ujGd9
	gJI4RYIPlca+xrEV9yjCjtg==
X-Received: by 2002:a05:6808:648b:b0:3ba:5dd:946c with SMTP id fh11-20020a056808648b00b003ba05dd946cmr25906782oib.4.1703119524733;
        Wed, 20 Dec 2023 16:45:24 -0800 (PST)
X-Google-Smtp-Source: AGHT+IH88GeAzWTs3T0ANaUjp2q9gM56UgqBh7hPQqiwagA2y0hyuTaKXwA4Rso3qJ8CgP+v1mSTKA==
X-Received: by 2002:a05:6808:648b:b0:3ba:5dd:946c with SMTP id fh11-20020a056808648b00b003ba05dd946cmr25906770oib.4.1703119524435;
        Wed, 20 Dec 2023 16:45:24 -0800 (PST)
Received: from [10.72.112.86] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id u11-20020a17090282cb00b001d398889d4dsm317411plz.127.2023.12.20.16.45.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 20 Dec 2023 16:45:23 -0800 (PST)
Message-ID: <446cf570-4d3d-4bdb-978c-a61d801a8c32@redhat.com>
Date: Thu, 21 Dec 2023 08:45:18 +0800
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 17/22] get rid of passing callbacks to ceph
 __dentry_leases_walk()
Content-Language: en-US
To: Al Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org
Cc: ceph-devel@vger.kernel.org
References: <20231220051348.GY1674809@ZenIV> <20231220052925.GP1674809@ZenIV>
From: Xiubo Li <xiubli@redhat.com>
In-Reply-To: <20231220052925.GP1674809@ZenIV>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit


On 12/20/23 13:29, Al Viro wrote:
> __dentry_leases_walk() is gets a callback and calls it for
> a bunch of denties; there are exactly two callers and
> we already have a flag telling them apart - lwc->dir_lease.
>
> Seeing that indirect calls are costly these days, let's
> get rid of the callback and just call the right function
> directly.  Has a side benefit of saner signatures...
>
> Signed-off-by Al Viro <viro@zeniv.linux.org.uk>
> ---
>   fs/ceph/dir.c | 21 +++++++++++++--------
>   1 file changed, 13 insertions(+), 8 deletions(-)
>
> diff --git a/fs/ceph/dir.c b/fs/ceph/dir.c
> index 91709934c8b1..768158743750 100644
> --- a/fs/ceph/dir.c
> +++ b/fs/ceph/dir.c
> @@ -1593,10 +1593,12 @@ struct ceph_lease_walk_control {
>   	unsigned long dir_lease_ttl;
>   };
>   
> +static int __dir_lease_check(const struct dentry *, struct ceph_lease_walk_control *);
> +static int __dentry_lease_check(const struct dentry *);
> +
>   static unsigned long
>   __dentry_leases_walk(struct ceph_mds_client *mdsc,
> -		     struct ceph_lease_walk_control *lwc,
> -		     int (*check)(struct dentry*, void*))
> +		     struct ceph_lease_walk_control *lwc)
>   {
>   	struct ceph_dentry_info *di, *tmp;
>   	struct dentry *dentry, *last = NULL;
> @@ -1624,7 +1626,10 @@ __dentry_leases_walk(struct ceph_mds_client *mdsc,
>   			goto next;
>   		}
>   
> -		ret = check(dentry, lwc);
> +		if (lwc->dir_lease)
> +			ret = __dir_lease_check(dentry, lwc);
> +		else
> +			ret = __dentry_lease_check(dentry);
>   		if (ret & TOUCH) {
>   			/* move it into tail of dir lease list */
>   			__dentry_dir_lease_touch(mdsc, di);
> @@ -1681,7 +1686,7 @@ __dentry_leases_walk(struct ceph_mds_client *mdsc,
>   	return freed;
>   }
>   
> -static int __dentry_lease_check(struct dentry *dentry, void *arg)
> +static int __dentry_lease_check(const struct dentry *dentry)
>   {
>   	struct ceph_dentry_info *di = ceph_dentry(dentry);
>   	int ret;
> @@ -1696,9 +1701,9 @@ static int __dentry_lease_check(struct dentry *dentry, void *arg)
>   	return DELETE;
>   }
>   
> -static int __dir_lease_check(struct dentry *dentry, void *arg)
> +static int __dir_lease_check(const struct dentry *dentry,
> +			     struct ceph_lease_walk_control *lwc)
>   {
> -	struct ceph_lease_walk_control *lwc = arg;
>   	struct ceph_dentry_info *di = ceph_dentry(dentry);
>   
>   	int ret = __dir_lease_try_check(dentry);
> @@ -1737,7 +1742,7 @@ int ceph_trim_dentries(struct ceph_mds_client *mdsc)
>   
>   	lwc.dir_lease = false;
>   	lwc.nr_to_scan  = CEPH_CAPS_PER_RELEASE * 2;
> -	freed = __dentry_leases_walk(mdsc, &lwc, __dentry_lease_check);
> +	freed = __dentry_leases_walk(mdsc, &lwc);
>   	if (!lwc.nr_to_scan) /* more invalid leases */
>   		return -EAGAIN;
>   
> @@ -1747,7 +1752,7 @@ int ceph_trim_dentries(struct ceph_mds_client *mdsc)
>   	lwc.dir_lease = true;
>   	lwc.expire_dir_lease = freed < count;
>   	lwc.dir_lease_ttl = mdsc->fsc->mount_options->caps_wanted_delay_max * HZ;
> -	freed +=__dentry_leases_walk(mdsc, &lwc, __dir_lease_check);
> +	freed +=__dentry_leases_walk(mdsc, &lwc);
>   	if (!lwc.nr_to_scan) /* more to check */
>   		return -EAGAIN;
>   

Reviewed-by: Xiubo Li <xiubli@redhat.com>

Al,

I think these two ceph patches won't be dependent by your following 
patches,  right ?

If so we can apply them to ceph-client tree and run more tests.


Thanks!



