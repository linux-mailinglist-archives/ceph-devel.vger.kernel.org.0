Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8BF145347B6
	for <lists+ceph-devel@lfdr.de>; Thu, 26 May 2022 02:55:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245562AbiEZAz5 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 25 May 2022 20:55:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345758AbiEZAz1 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 25 May 2022 20:55:27 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 9D74CE088
        for <ceph-devel@vger.kernel.org>; Wed, 25 May 2022 17:55:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1653526524;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=yJXqOz+uU25JvmhdChbh6XiN9Ren8ftiBWD/fyoXYhA=;
        b=VheoLs/oCfFZh1ZHZYdTrZ56TsdDfOuvSsfPjwnp4jD60vKvx+XUcq0/vZQ9dGNzBr0F97
        sXlVPiiF5O1yejCGBYQ5FcLHWngndvQemC8qyKhQV06V0fzUNyhhV/ksmNxrCS2HlAfM4T
        qUIjX3gc/zH/xvSV9Z/qruNgP5IGbTE=
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com
 [209.85.216.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-122-Yf4Yg0DBNbyxM7YEyx4vRg-1; Wed, 25 May 2022 20:55:23 -0400
X-MC-Unique: Yf4Yg0DBNbyxM7YEyx4vRg-1
Received: by mail-pj1-f69.google.com with SMTP id nv16-20020a17090b1b5000b001df2567933eso2198765pjb.4
        for <ceph-devel@vger.kernel.org>; Wed, 25 May 2022 17:55:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=yJXqOz+uU25JvmhdChbh6XiN9Ren8ftiBWD/fyoXYhA=;
        b=583cJ8RYCHeQcj+/gXuLM8+qu6ULhRj1mLsu5Gbkm7kBaswV8D8weeoiYE3wNY+i0G
         UT77+SIqdAAJZ4UL9J5c0BhAhB6rvpIjR7611kakqZHmHxOpf+D3B5vuvKhcM0RN9l8e
         oPhsYC2MWpIYbrJ2m2Bn/9SGrNvJNDXpCWP6voU0KJob4f0qZZPWfiNAwP8a0NzKmBDN
         KDWlWsu+x+CE1qxhxD5T4o1niN9H0EkYBWY2Kef1wNuxUz16pbtgKbWn+rIt0hoe6wZ9
         1b4dGNzH5StwAItkK5SoNWJF+6Jm4dShCzKzOCquwO+E6RxS8NhmAQdjqKwPflZ0vZya
         3kww==
X-Gm-Message-State: AOAM533CjYKwalmaI99magSGyiD/MQt3je+M9v2fSRCav5rpRHvAgdUP
        YEl8vXhID3xRZ+29SrXc3eNJB2oNt4mpDS51BXB1IZ6nLwA4Rz95XA6mEhOCWFl0FJhFBawaoUc
        h82nYFNscLQmmMRSeICdaXw==
X-Received: by 2002:a17:902:704a:b0:161:996e:bf4 with SMTP id h10-20020a170902704a00b00161996e0bf4mr35079473plt.118.1653526521673;
        Wed, 25 May 2022 17:55:21 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwCbrF0uQFcmCr95NaeasnD7ovOjx9IFdOE4/zRaiA1R+5amqdd7fy3VDDHcGFgiY+za6xE9Q==
X-Received: by 2002:a17:902:704a:b0:161:996e:bf4 with SMTP id h10-20020a170902704a00b00161996e0bf4mr35079456plt.118.1653526521428;
        Wed, 25 May 2022 17:55:21 -0700 (PDT)
Received: from [10.72.12.81] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id k2-20020a170902f28200b0015e8d4eb1dcsm37852plc.38.2022.05.25.17.55.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 25 May 2022 17:55:20 -0700 (PDT)
Subject: Re: [PATCH] ceph: use correct index when encoding client supported
 features
To:     =?UTF-8?Q?Lu=c3=ads_Henriques?= <lhenriques@suse.de>,
        Jeff Layton <jlayton@kernel.org>,
        Ilya Dryomov <idryomov@gmail.com>
Cc:     ceph-devel@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20220524160627.20893-1-lhenriques@suse.de>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <d1f22b3b-7415-0fdb-e702-24f2a7b0b939@redhat.com>
Date:   Thu, 26 May 2022 08:55:15 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20220524160627.20893-1-lhenriques@suse.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


On 5/25/22 12:06 AM, Luís Henriques wrote:
> Feature bits have to be encoded into the correct locations.  This hasn't
> been an issue so far because the only hole in the feature bits was in bit
> 10 (CEPHFS_FEATURE_RECLAIM_CLIENT), which is located in the 2nd byte.  When
> adding more bits that go beyond the this 2nd byte, the bug will show up.
>
> Fixes: 9ba1e224538a ("ceph: allocate the correct amount of extra bytes for the session features")
> Signed-off-by: Luís Henriques <lhenriques@suse.de>
> ---
>   fs/ceph/mds_client.c | 7 +++++--
>   fs/ceph/mds_client.h | 2 --
>   2 files changed, 5 insertions(+), 4 deletions(-)
>
> I hope I got this code right.  I found this issue when trying to add an
> extra feature bit that would go beyond bit 15 and that wasn't showing up
> on the MDS side.
>
> diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
> index 1bd3e1bb0fdf..77e742b6fd30 100644
> --- a/fs/ceph/mds_client.c
> +++ b/fs/ceph/mds_client.c
> @@ -1220,14 +1220,17 @@ static int encode_supported_features(void **p, void *end)
>   	if (count > 0) {
>   		size_t i;
>   		size_t size = FEATURE_BYTES(count);
> +		unsigned long bit;
>   
>   		if (WARN_ON_ONCE(*p + 4 + size > end))
>   			return -ERANGE;
>   
>   		ceph_encode_32(p, size);
>   		memset(*p, 0, size);
> -		for (i = 0; i < count; i++)
> -			((unsigned char*)(*p))[i / 8] |= BIT(feature_bits[i] % 8);
> +		for (i = 0; i < count; i++) {
> +			bit = feature_bits[i];
> +			((unsigned char *)(*p))[bit / 8] |= BIT(bit % 8);
> +		}
>   		*p += size;
>   	} else {
>   		if (WARN_ON_ONCE(*p + 4 > end))
> diff --git a/fs/ceph/mds_client.h b/fs/ceph/mds_client.h
> index 33497846e47e..12901e3a6823 100644
> --- a/fs/ceph/mds_client.h
> +++ b/fs/ceph/mds_client.h
> @@ -45,8 +45,6 @@ enum ceph_feature_type {
>   	CEPHFS_FEATURE_MULTI_RECONNECT,		\
>   	CEPHFS_FEATURE_DELEG_INO,		\
>   	CEPHFS_FEATURE_METRIC_COLLECT,		\
> -						\
> -	CEPHFS_FEATURE_MAX,			\
>   }
>   #define CEPHFS_FEATURES_CLIENT_REQUIRED {}
>   

LGTM. Just one small fix in the comment, since you have removed the 
'CEPHFS_FEATURE_MAX', which makes no sense any more:


diff --git a/fs/ceph/mds_client.h b/fs/ceph/mds_client.h
index 33497846e47e..ac49344ea79e 100644
--- a/fs/ceph/mds_client.h
+++ b/fs/ceph/mds_client.h
@@ -33,10 +33,6 @@ enum ceph_feature_type {
         CEPHFS_FEATURE_MAX = CEPHFS_FEATURE_METRIC_COLLECT,
  };

-/*
- * This will always have the highest feature bit value
- * as the last element of the array.
- */
  #define CEPHFS_FEATURES_CLIENT_SUPPORTED {     \
         0, 1, 2, 3, 4, 5, 6, 7,                 \
         CEPHFS_FEATURE_MIMIC,                   \

Merged into the testing branch.

Thanks Luis.

-- Xiubo


