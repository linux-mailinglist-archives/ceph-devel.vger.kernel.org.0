Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D392276C176
	for <lists+ceph-devel@lfdr.de>; Wed,  2 Aug 2023 02:22:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231309AbjHBAW3 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 1 Aug 2023 20:22:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230159AbjHBAW1 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 1 Aug 2023 20:22:27 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A54A82113
        for <ceph-devel@vger.kernel.org>; Tue,  1 Aug 2023 17:21:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1690935701;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=iW8hBZZUgV3cs9gj+IYGks8l1nDjtjLJXBUbMFxFngc=;
        b=iswv/B2leoGyxh3gAgWyEMfAC2y3L8B3JAD7pDK5V1U1ZiB0leFxPhrqGMnsaf61TGpQqf
        FOrLMgaa2UPzyS3G7cZSlkYHZYRAODJhNEj1R2dFV9hwHKGsp6eL1R3cOEz0fRz442ZqkM
        F/liYIT9J3ducINpldEetLyMJ1FU9Dg=
Received: from mail-pf1-f200.google.com (mail-pf1-f200.google.com
 [209.85.210.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-561-pm6cCNheMRiw-TB307egPw-1; Tue, 01 Aug 2023 20:21:40 -0400
X-MC-Unique: pm6cCNheMRiw-TB307egPw-1
Received: by mail-pf1-f200.google.com with SMTP id d2e1a72fcca58-686db1e037fso4542442b3a.3
        for <ceph-devel@vger.kernel.org>; Tue, 01 Aug 2023 17:21:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690935699; x=1691540499;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=iW8hBZZUgV3cs9gj+IYGks8l1nDjtjLJXBUbMFxFngc=;
        b=KNX8hMfMDspdV4dsYACUnKzMF1EO2WqJi5N7DW7sWMCP9d2rNWQUosCFWHFfnjYd5F
         ryEOQai6BZEV4yah/QUfAUXGx/7tZZ8LZpIcOvErFdsFqtGUllgUyjXZQBy9Nc56ebK2
         HrKtyjRC8IjIRriqCV/fL7CWAqVdF0c80ikwKecw63V+odfr+OMq2UrB4E//JivAiunc
         jcazhaLbclg1B1nUNUvDYhs7zS3BBjHycCnQh9gToL1+2kjfdMiC/mkQfPzHZNaGiBP9
         0eefy39RxmhYgE5GfPvB1r9Q8Qx148ltj2W3QIY3VSxSFhLeTo/tawQjRRMHGP9GWfIo
         /2sQ==
X-Gm-Message-State: ABy/qLah8DI3hhOhstYRCnLmOUt8rG5YJKmbs6vl9ZxNPvCZMzrfNkU8
        s4LCAYD9lMKAss/vW8krKgdJ++j81Ia+bYOmbSYmT319eeUx24N2CUG4C2H3RjYg4b37e1sKc9q
        hu+8ro7Il84Np/dw06x2nvgPzt58YIqV9cTE=
X-Received: by 2002:a05:6a00:8c9:b0:668:74e9:8efb with SMTP id s9-20020a056a0008c900b0066874e98efbmr16107322pfu.8.1690935699498;
        Tue, 01 Aug 2023 17:21:39 -0700 (PDT)
X-Google-Smtp-Source: APBJJlHpg49oeXjBxHkw5/bRc9tnlkAZVe/58yxApl5Fqn7761Go1GmwzHSou5WHfDnqqwJZTcPXiw==
X-Received: by 2002:a05:6a00:8c9:b0:668:74e9:8efb with SMTP id s9-20020a056a0008c900b0066874e98efbmr16107311pfu.8.1690935699230;
        Tue, 01 Aug 2023 17:21:39 -0700 (PDT)
Received: from [10.72.112.81] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id q23-20020a62e117000000b00682b2fbd20fsm9870635pfh.31.2023.08.01.17.21.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 01 Aug 2023 17:21:38 -0700 (PDT)
Message-ID: <e5b081da-bb6d-0fb3-29c5-beb8b479b16d@redhat.com>
Date:   Wed, 2 Aug 2023 08:21:34 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH] libceph: fix potential hang in ceph_osdc_notify()
Content-Language: en-US
To:     Ilya Dryomov <idryomov@gmail.com>, ceph-devel@vger.kernel.org
Cc:     Dongsheng Yang <dongsheng.yang@easystack.cn>
References: <20230801222529.674721-1-idryomov@gmail.com>
From:   Xiubo Li <xiubli@redhat.com>
In-Reply-To: <20230801222529.674721-1-idryomov@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

LGTM.

Reviewed-by: Xiubo Li <xiubli@redhat.com>

On 8/2/23 06:25, Ilya Dryomov wrote:
> If the cluster becomes unavailable, ceph_osdc_notify() may hang even
> with osd_request_timeout option set because linger_notify_finish_wait()
> waits for MWatchNotify NOTIFY_COMPLETE message with no associated OSD
> request in flight -- it's completely asynchronous.
>
> Introduce an additional timeout, derived from the specified notify
> timeout.  While at it, switch both waits to killable which is more
> correct.
>
> Cc: stable@vger.kernel.org
> Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
> ---
>   net/ceph/osd_client.c | 20 ++++++++++++++------
>   1 file changed, 14 insertions(+), 6 deletions(-)
>
> diff --git a/net/ceph/osd_client.c b/net/ceph/osd_client.c
> index 11c04e7d928e..658a6f2320cf 100644
> --- a/net/ceph/osd_client.c
> +++ b/net/ceph/osd_client.c
> @@ -3334,17 +3334,24 @@ static int linger_reg_commit_wait(struct ceph_osd_linger_request *lreq)
>   	int ret;
>   
>   	dout("%s lreq %p linger_id %llu\n", __func__, lreq, lreq->linger_id);
> -	ret = wait_for_completion_interruptible(&lreq->reg_commit_wait);
> +	ret = wait_for_completion_killable(&lreq->reg_commit_wait);
>   	return ret ?: lreq->reg_commit_error;
>   }
>   
> -static int linger_notify_finish_wait(struct ceph_osd_linger_request *lreq)
> +static int linger_notify_finish_wait(struct ceph_osd_linger_request *lreq,
> +				     unsigned long timeout)
>   {
> -	int ret;
> +	long left;
>   
>   	dout("%s lreq %p linger_id %llu\n", __func__, lreq, lreq->linger_id);
> -	ret = wait_for_completion_interruptible(&lreq->notify_finish_wait);
> -	return ret ?: lreq->notify_finish_error;
> +	left = wait_for_completion_killable_timeout(&lreq->notify_finish_wait,
> +						ceph_timeout_jiffies(timeout));
> +	if (left <= 0)
> +		left = left ?: -ETIMEDOUT;
> +	else
> +		left = lreq->notify_finish_error; /* completed */
> +
> +	return left;
>   }
>   
>   /*
> @@ -4896,7 +4903,8 @@ int ceph_osdc_notify(struct ceph_osd_client *osdc,
>   	linger_submit(lreq);
>   	ret = linger_reg_commit_wait(lreq);
>   	if (!ret)
> -		ret = linger_notify_finish_wait(lreq);
> +		ret = linger_notify_finish_wait(lreq,
> +				 msecs_to_jiffies(2 * timeout * MSEC_PER_SEC));
>   	else
>   		dout("lreq %p failed to initiate notify %d\n", lreq, ret);
>   

