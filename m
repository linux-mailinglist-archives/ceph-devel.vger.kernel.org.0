Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4ED8059953D
	for <lists+ceph-devel@lfdr.de>; Fri, 19 Aug 2022 08:22:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345460AbiHSGQC (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 19 Aug 2022 02:16:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346906AbiHSGPv (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Fri, 19 Aug 2022 02:15:51 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DED7E29820
        for <ceph-devel@vger.kernel.org>; Thu, 18 Aug 2022 23:15:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1660889749;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xyJ7v1TjOGG67+b2SwY4LowK10pJayN42qQpXaYAF1U=;
        b=DL1JpFvCs/agBVVt5MLU/Ffyd8MK1rsWCOJaTEeVOwnoFKYmFq1NYmav3NjXCFvmXBY0DJ
        G7WK2AaZ0m4R8O03l5yINewpqqOhBjMGkI41IwvBghtzEaS5VTlFOGpqBIzdMpvtmRGM9A
        /7pwfhFm8AZLLARId3QKc2NrlHuYO/s=
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com
 [209.85.216.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-509-s9mfNXYGOh6ID1z_zmYo_g-1; Fri, 19 Aug 2022 02:15:48 -0400
X-MC-Unique: s9mfNXYGOh6ID1z_zmYo_g-1
Received: by mail-pj1-f70.google.com with SMTP id 92-20020a17090a09e500b001d917022847so1885015pjo.1
        for <ceph-devel@vger.kernel.org>; Thu, 18 Aug 2022 23:15:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-language:content-transfer-encoding:in-reply-to:mime-version
         :user-agent:date:message-id:from:references:cc:to:subject
         :x-gm-message-state:from:to:cc;
        bh=xyJ7v1TjOGG67+b2SwY4LowK10pJayN42qQpXaYAF1U=;
        b=OzdZJjq1MYX/hbsbuptnLQqyiGm7sGVb0hkWGJMYT9feTO//fcGLc7ZJ1tgyCs/9MU
         Zlqorea11zuGO+eM6jluM/qz0QWv1zUvscSy1DSG/fH5q5bIuzojPqEUBJCK+/TZoKrU
         b1Rh3BsEcHZxWcnVFaytmrwJcLFBBCeX9OhPPyVC03R9ElngwIBwm9Tvr0aV+k1Ga8h9
         TjjWo7WSOBux/0u2kt8uHT7Zg0S673PvjkH0Gz1ZIHfTY3CiygsGIXbis7oaUMhKRycC
         rW73Xo6zZPZvwZOmorZIz6OGCHUERkJe/8okw5WFacxfMALAMtB8cYgjZC+HnHocEUW1
         HM6g==
X-Gm-Message-State: ACgBeo3AjmM8VbVvN2fAuVpXe5XX1W/20ysdh9d1yODO3oEEsE4Dsweu
        uUqv1Q465RGQoN1ln2gcAaH7Zgx+wnNQphHI/N1ZprCCPe3NxXP7wFs1uQEtpeg48ptkf5Y6J/+
        V8bkY+sNHiB75tpaaziCy/w6GiXMOiF1M3x1ClHAMtLKzKkX4lP7gkEXG4XwijrXjtsXRi8E=
X-Received: by 2002:a17:903:22cb:b0:16e:e31f:5197 with SMTP id y11-20020a17090322cb00b0016ee31f5197mr5926909plg.23.1660889747483;
        Thu, 18 Aug 2022 23:15:47 -0700 (PDT)
X-Google-Smtp-Source: AA6agR6RX1p6hB7Mov78IvgyVDILRIRXGlFDmhhYwJ50vpf9iK23JBh8W5aznwJ6rr0zQTaufceGWw==
X-Received: by 2002:a17:903:22cb:b0:16e:e31f:5197 with SMTP id y11-20020a17090322cb00b0016ee31f5197mr5926879plg.23.1660889747126;
        Thu, 18 Aug 2022 23:15:47 -0700 (PDT)
Received: from [10.72.13.207] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id u33-20020a631421000000b004215af667cdsm2192541pgl.41.2022.08.18.23.15.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 18 Aug 2022 23:15:46 -0700 (PDT)
Subject: Re: [PATCH] ceph: Use kcalloc for allocating multiple elements
To:     Kenneth Lee <klee33@uw.edu>, idryomov@gmail.com, jlayton@kernel.org
Cc:     ceph-devel@vger.kernel.org
References: <20220819054255.2406633-1-klee33@uw.edu>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <2fac0996-5829-e87a-2cbd-11a6928f0b47@redhat.com>
Date:   Fri, 19 Aug 2022 14:15:41 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20220819054255.2406633-1-klee33@uw.edu>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


On 8/19/22 1:42 PM, Kenneth Lee wrote:
> Prefer using kcalloc(a, b) over kzalloc(a * b) as this improves
> semantics since kcalloc is intended for allocating an array of memory.
>
> Signed-off-by: Kenneth Lee <klee33@uw.edu>
> ---
>   fs/ceph/caps.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
> index 53cfe026b3ea..1eb2ff0f6bd8 100644
> --- a/fs/ceph/caps.c
> +++ b/fs/ceph/caps.c
> @@ -2285,7 +2285,7 @@ static int flush_mdlog_and_wait_inode_unsafe_requests(struct inode *inode)
>   		struct ceph_mds_request *req;
>   		int i;
>   
> -		sessions = kzalloc(max_sessions * sizeof(s), GFP_KERNEL);
> +		sessions = kcalloc(max_sessions, sizeof(s), GFP_KERNEL);
>   		if (!sessions) {
>   			err = -ENOMEM;
>   			goto out;

Merged into the testing branch. Thanks Kenneth!

-- Xiubo

