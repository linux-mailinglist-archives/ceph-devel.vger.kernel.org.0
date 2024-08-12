Return-Path: <ceph-devel+bounces-1653-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 50A8994E5F0
	for <lists+ceph-devel@lfdr.de>; Mon, 12 Aug 2024 07:04:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id AFF7AB216F8
	for <lists+ceph-devel@lfdr.de>; Mon, 12 Aug 2024 05:04:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 27D8E142631;
	Mon, 12 Aug 2024 05:04:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="JyfgUgI1"
X-Original-To: ceph-devel@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E6EB136A
	for <ceph-devel@vger.kernel.org>; Mon, 12 Aug 2024 05:03:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723439039; cv=none; b=oP6PlVePDxAHWtYcA4p22+hXSCiO0eunFyin9fkIKI+MdOOVV/UyxKw6OR9itMwoFeTQpkP1MsqQW5L23ImFrmtpAbRBg6zEr7Dwso3YVR94UCYqyABAk6Ad6fj+jAVr3+kGkG41X1+CsGW/gxmVhrDDEZdADvIQFZ+vWfkQeSw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723439039; c=relaxed/simple;
	bh=/HARrPdkHb+260/+fb68PsV7Lf9XhleuY1Wm+C/kv4Q=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=BM+2CfsDSdR+NLan06icsIajY8ZlGJNBFlxc3PseRr0Ok1WjqGF00yPuTUhyXXALTCfd+yRp3GtrMyM1Hcfr/CK+BxjBTdM7XZ+81k7YGemNbVRAZOgVUxYEtYT8xcz4EgdusuV/h7dLFMPQA9A3Q/8nlQmJToWDtyC0tsq2w4c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=JyfgUgI1; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1723439036;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=7vIKLIJtRsBNGOa4tAAmFSyKAxCU9DLA5TPJcMmmHMw=;
	b=JyfgUgI1ABwhiEQrKUpi4mfSkQx28IM3z3i7UxC5WdESYKF+Pvdr7CmUNNqxb8aFEBHWpi
	NGsXBqbwfXinMe8rPYXYsTiEb1xzgV+LvmkaliNzOtxBPlnZHDQ7M7TR7pUaqGDDBxVXif
	YsNbKhq3LmILdjl7l8WV6xs2FGeIHM0=
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com
 [209.85.216.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-381-WEDRwKFxMHCxSPC5_b0jVw-1; Mon, 12 Aug 2024 01:03:53 -0400
X-MC-Unique: WEDRwKFxMHCxSPC5_b0jVw-1
Received: by mail-pj1-f69.google.com with SMTP id 98e67ed59e1d1-2cb576921b6so4801076a91.1
        for <ceph-devel@vger.kernel.org>; Sun, 11 Aug 2024 22:03:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723439033; x=1724043833;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=7vIKLIJtRsBNGOa4tAAmFSyKAxCU9DLA5TPJcMmmHMw=;
        b=g0wktTzEwhK8rhGcV4pR1u1JXQ+gNomJh8xMvOazTUaDNcZiZ5OvDCrolwmdFzeK2z
         ht8sHYn9k+C0Pc0at3f6Jl6PsV9RIvOdA53/Bbs2fb2mydqBFHowYKVlGqUzjsPR+R0e
         BMdzVANVcpAVRyT4rFseSooUuCVXswiza4I4bPqdkxlMbaSIZVsDSpsF2+oAUP0PRgjU
         yXcK6qYd7p48JwgkUvPChOfBsZUb2H+heWFLAzOCk0uaqgrvADm789cSdULx+ABddO0f
         twiguEefvE8siWzQw9/lc3LOoL8YkguR6JKIEoyE4XkDnyYadsNDspNo/3QnedOwPBM6
         sbwg==
X-Gm-Message-State: AOJu0YwWI6i1ozHMf94PnJ1ZlBRBGJg5B5TovAswA4RsjRXLhtekPGKf
	/AgdfTW17aM7WCF4sEKto8I6Nrh7MbYtCCk/M3xvIwpWtfO3LtQ1cszr4xZ9Ji9WdBXOQ+jZLJj
	gkx+NBthFWM1TPl6Px1Q9Wq/cF1VG/yEKP4oTDVKVqRI/qtjPx0Xgnp94Dt9I9e2Xv/Q=
X-Received: by 2002:a17:90a:5e02:b0:2c8:f3b4:425 with SMTP id 98e67ed59e1d1-2d1e7fe94d5mr9065267a91.23.1723439032689;
        Sun, 11 Aug 2024 22:03:52 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEKvVYUy9Ew3v+SuwuF/0ggA1MISkjoVp36ueg7q2KNxpRLx4ihIlIy6Y4CPK99Rs1+tNerNg==
X-Received: by 2002:a17:90a:5e02:b0:2c8:f3b4:425 with SMTP id 98e67ed59e1d1-2d1e7fe94d5mr9065251a91.23.1723439032282;
        Sun, 11 Aug 2024 22:03:52 -0700 (PDT)
Received: from [10.72.116.20] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2d1c9ca6c4dsm7167014a91.33.2024.08.11.22.03.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 11 Aug 2024 22:03:52 -0700 (PDT)
Message-ID: <c0f09270-1836-43d9-8088-5c595d8d451f@redhat.com>
Date: Mon, 12 Aug 2024 13:03:48 +0800
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [bug report] ceph: add new field max_file_size in ceph_fs_client
To: Dan Carpenter <dan.carpenter@linaro.org>, Chengguang Xu <cgxu519@gmx.com>
Cc: ceph-devel@vger.kernel.org
References: <6febcf36-2d30-4338-b1cc-641ddd14314b@stanley.mountain>
Content-Language: en-US
From: Xiubo Li <xiubli@redhat.com>
In-Reply-To: <6febcf36-2d30-4338-b1cc-641ddd14314b@stanley.mountain>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit


On 8/9/24 20:31, Dan Carpenter wrote:
> Hello Chengguang Xu,
>
> Commit 719784ba706c ("ceph: add new field max_file_size in
> ceph_fs_client") from Jul 19, 2018 (linux-next), leads to the
> following Smatch static checker warning:
>
> 	fs/ceph/mds_client.c:6157 ceph_mdsc_handle_mdsmap()
> 	warn: truncated comparison 'mdsc->mdsmap->m_max_file_size' 'u64max' to 's64max'
>
> fs/ceph/mds_client.c
>      6142         newmap = ceph_mdsmap_decode(mdsc, &p, end, ceph_msgr2(mdsc->fsc->client));
>
> m_max_file_size comes from the user here
>
>      6143         if (IS_ERR(newmap)) {
>      6144                 err = PTR_ERR(newmap);
>      6145                 goto bad_unlock;
>      6146         }
>      6147
>      6148         /* swap into place */
>      6149         if (mdsc->mdsmap) {
>      6150                 oldmap = mdsc->mdsmap;
>      6151                 mdsc->mdsmap = newmap;
>      6152                 check_new_map(mdsc, newmap, oldmap);
>      6153                 ceph_mdsmap_destroy(oldmap);
>      6154         } else {
>      6155                 mdsc->mdsmap = newmap;  /* first mds map */
>      6156         }
> --> 6157         mdsc->fsc->max_file_size = min((loff_t)mdsc->mdsmap->m_max_file_size,
>
> High positive values are cast to negative so we end up with a negative
> max_file_size.  I dont' see that this causes an issue though...

In MDS sever side I didn't see any case will it be a negative value yet. 
So this cast is safe.

We can just ignore it by sending a patch to dismiss this warning.

Thanks

- Xiubo

>
>      6158                                         MAX_LFS_FILESIZE);
>      6159
>      6160         __wake_requests(mdsc, &mdsc->waiting_for_map);
>      6161         ceph_monc_got_map(&mdsc->fsc->client->monc, CEPH_SUB_MDSMAP,
>      6162                           mdsc->mdsmap->m_epoch);
>      6163
>      6164         mutex_unlock(&mdsc->mutex);
>      6165         schedule_delayed(mdsc, 0);
>      6166         return;
>      6167
>      6168 bad_unlock:
>      6169         mutex_unlock(&mdsc->mutex);
>      6170 bad:
>      6171         pr_err_client(cl, "error decoding mdsmap %d. Shutting down mount.\n",
>      6172                       err);
>      6173         ceph_umount_begin(mdsc->fsc->sb);
>      6174         ceph_msg_dump(msg);
>      6175         return;
>      6176 }
>
> regards,
> dan carpenter
>


