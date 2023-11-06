Return-Path: <ceph-devel+bounces-45-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id B2DEF7E1965
	for <lists+ceph-devel@lfdr.de>; Mon,  6 Nov 2023 05:35:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 68B9028139A
	for <lists+ceph-devel@lfdr.de>; Mon,  6 Nov 2023 04:35:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 23F2C139D;
	Mon,  6 Nov 2023 04:35:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="fxNntP9T"
X-Original-To: ceph-devel@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D60E1635
	for <ceph-devel@vger.kernel.org>; Mon,  6 Nov 2023 04:35:43 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A3BFA4
	for <ceph-devel@vger.kernel.org>; Sun,  5 Nov 2023 20:35:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1699245341;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=6wxOEYoBLjyfNNJ3uxJYCyC+R6yVViO6b8VQiG/NhMc=;
	b=fxNntP9TGHhBoNyHKtQYjwNiNdGuHCxz3d5jZPNUmY0jwn2/HW/aD+vRD/EISMKFtPIS4k
	oqNOO08tKz005FcmG8lIqJ9g/M9/SWTVGpSxt3DQxjpkUB7wtkWtpmpb8D52+f572QWtl2
	uXZsRbo3snFlr6cGtdSuxkZCF01rcYo=
Received: from mail-pf1-f197.google.com (mail-pf1-f197.google.com
 [209.85.210.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-354-wD1B30pkM4KjKUazGtNoyA-1; Sun, 05 Nov 2023 23:35:39 -0500
X-MC-Unique: wD1B30pkM4KjKUazGtNoyA-1
Received: by mail-pf1-f197.google.com with SMTP id d2e1a72fcca58-6b1cec068a9so3887948b3a.0
        for <ceph-devel@vger.kernel.org>; Sun, 05 Nov 2023 20:35:39 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699245338; x=1699850138;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=6wxOEYoBLjyfNNJ3uxJYCyC+R6yVViO6b8VQiG/NhMc=;
        b=hAGT97G0MDlwsXpNVirnpjMGxCgHyMa0IJK4nW7rcUBG5ojV6vLLErmFCJFA+G/1ub
         8xm5y3FqMdEE+5YRfYTCrGgjP+VIa1peXrWD7jU6om0fOXgkxXgNlFjFGDFhWoY4f1px
         0bEMRJyzFivH1yBgihXegIKy9laONA7yBHMy6cXqk9Gn1fS80oHXaYwe7dIQWtoybpKt
         vA5jAsjHDeMh9NpN+sZS2m6RiztKJi/B00w+TZLZt/z1QHt9RjQ8gCq8+cupxZ95OLgZ
         sz5Fi3W2Ksop2TcsEHXfhdBg4dQKEHlyMpuh9nIXbxYPYepj4cbdxnTwa0ZeWXiZOR/G
         5KYA==
X-Gm-Message-State: AOJu0YwNI515/26snr34gfIvDF9Fyr1ft0kFvxdt/XWz/hcaS6rZEOCf
	jHbA2Lxv0nMJtbpH+lm2dPpLulswFsUqYz5CvQsxWmhw2FXAmZP6lZeyy2LicAwliJtzRFiXlH5
	7GrjHsh/2myzAdS7YTN4Ogg==
X-Received: by 2002:a05:6a00:2352:b0:6bc:e7f8:821e with SMTP id j18-20020a056a00235200b006bce7f8821emr34078465pfj.10.1699245338661;
        Sun, 05 Nov 2023 20:35:38 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEmPuljOJPa6BUAhfnbHNHCPpJ56RsrqffKoHIL2/eL379AqLWfDihcoH3icResdkKSMl6aww==
X-Received: by 2002:a05:6a00:2352:b0:6bc:e7f8:821e with SMTP id j18-20020a056a00235200b006bce7f8821emr34078452pfj.10.1699245338246;
        Sun, 05 Nov 2023 20:35:38 -0800 (PST)
Received: from [10.72.112.124] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id x25-20020aa784d9000000b006babcf86b84sm4719916pfn.34.2023.11.05.20.35.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 05 Nov 2023 20:35:38 -0800 (PST)
Message-ID: <5079718b-f21f-7f5e-01af-e74822b3d4b2@redhat.com>
Date: Mon, 6 Nov 2023 12:35:35 +0800
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH] ceph: reinitialize mds feature bit even when session in
 open
Content-Language: en-US
To: Venky Shankar <vshankar@redhat.com>, ceph-devel@vger.kernel.org
Cc: mchangir@redhat.com
References: <20231106043232.321783-1-vshankar@redhat.com>
From: Xiubo Li <xiubli@redhat.com>
In-Reply-To: <20231106043232.321783-1-vshankar@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit


On 11/6/23 12:32, Venky Shankar wrote:
> Following along the same lines as per the user-space fix. Right
> now this isn't really an issue with the ceph kernel driver because
> of the feature bit laginess, however, that can change over time
> (when the new snaprealm info type is ported to the kernel driver)
> and depending on the MDS version that's being upgraded can cause
> message decoding issues - so, fix that early on.
>
> URL: Fixes: http://tracker.ceph.com/issues/63188
> Signed-off-by: Venky Shankar <vshankar@redhat.com>
> ---
>   fs/ceph/mds_client.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
> index a7bffb030036..e1136009b44a 100644
> --- a/fs/ceph/mds_client.c
> +++ b/fs/ceph/mds_client.c
> @@ -4189,12 +4189,12 @@ static void handle_session(struct ceph_mds_session *session,
>   			pr_info_client(cl, "mds%d reconnect success\n",
>   				       session->s_mds);
>   
> +		session->s_features = features;
>   		if (session->s_state == CEPH_MDS_SESSION_OPEN) {
>   			pr_notice_client(cl, "mds%d is already opened\n",
>   					 session->s_mds);
>   		} else {
>   			session->s_state = CEPH_MDS_SESSION_OPEN;
> -			session->s_features = features;
>   			renewed_caps(mdsc, session, 0);
>   			if (test_bit(CEPHFS_FEATURE_METRIC_COLLECT,
>   				     &session->s_features))

LGTM.

Reviewed-by: Xiubo Li <xiubli@redhat.com>


