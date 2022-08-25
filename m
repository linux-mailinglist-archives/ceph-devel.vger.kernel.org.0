Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A6F395A0592
	for <lists+ceph-devel@lfdr.de>; Thu, 25 Aug 2022 03:22:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231177AbiHYBWy (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 24 Aug 2022 21:22:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229490AbiHYBWw (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 24 Aug 2022 21:22:52 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C58E7539C
        for <ceph-devel@vger.kernel.org>; Wed, 24 Aug 2022 18:22:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1661390571;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=bKTzbyHSfHSNIbKc4zRKBhHH0O8S5QF2666vIWnJGUw=;
        b=IHRke9Bvk1TM82u9QVHhJxYOklxHMv46/CsFIxtwwA7/qLBQcUKi9rZ39CzEWmY7/2AY0z
        gC8NaK41d2+Iky167T+PCa7vQJSB5jhp57DXVn+gMujvjLi4X9Y0QDfZ1oDyI5D9G2daM8
        lIj1wo4YlmrERu+b4y4u58jsUzQ9ab4=
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com
 [209.85.216.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-533-XXowK9HbM2Oz3r2c5KfnJw-1; Wed, 24 Aug 2022 21:22:50 -0400
X-MC-Unique: XXowK9HbM2Oz3r2c5KfnJw-1
Received: by mail-pj1-f70.google.com with SMTP id z8-20020a17090a014800b001fac4204c7eso1624460pje.8
        for <ceph-devel@vger.kernel.org>; Wed, 24 Aug 2022 18:22:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-language:content-transfer-encoding:in-reply-to:mime-version
         :user-agent:date:message-id:from:references:cc:to:subject
         :x-gm-message-state:from:to:cc;
        bh=bKTzbyHSfHSNIbKc4zRKBhHH0O8S5QF2666vIWnJGUw=;
        b=gp9cuVYPzcKupoBUpdzjBC1oZQSN2x1Sn/BgBLsWG8/8k73mm3GdMjIBQ+/Lxz9Ag5
         TkCEq8qbIActUhS7EAmecK0u76BgXS1xtckVNr29vbGWxZjfCbhZ9BovHHg+EsuOiUrW
         m0Bz+w54FL5AH3d3ZsOGnHLejxFmHoDhv0HDF2P62Vd8zSHdPycTm1Uxl9bth8+T64ea
         7qlQ4P+DB3LTbp84iv5A7UM6MhqJgvN12Tq2cJpQDYFcM+z4RTaxBrxVnSSEK1gn/MqK
         QG0bEFdBl5toVE6wDuK3zlZ9+ScdHCsEEMoWhurMo1KKuLNg6ObH69tY78LSmovXWaqj
         uJKA==
X-Gm-Message-State: ACgBeo30Creta+wyjRCrEZJBwQCSzSyX1CzX1M6UII/0tLoC4fW3gwsg
        qaRo1zariOfMJZeVU4eQyRHW2FaTeOdF7SrGueWjUILu0ELoBqPdrvIK5fjkjDVMHSMqDHoQ3NY
        Rc5JrznUD30oKH1to03sGeuN6kqRB+fpstYkzOCMlPSZ3BfPT1nXziIH8UxOiyQTG4iWA1VY=
X-Received: by 2002:a17:90b:1803:b0:1fb:45e2:5d85 with SMTP id lw3-20020a17090b180300b001fb45e25d85mr11299081pjb.163.1661390568708;
        Wed, 24 Aug 2022 18:22:48 -0700 (PDT)
X-Google-Smtp-Source: AA6agR6F2rb/AZQsA2EezLvs4/TLz9PiNhA/Hhox5LTEI3smsQ6z4GIH1GexnucNZ81ovInrhK+4sA==
X-Received: by 2002:a17:90b:1803:b0:1fb:45e2:5d85 with SMTP id lw3-20020a17090b180300b001fb45e25d85mr11299065pjb.163.1661390568374;
        Wed, 24 Aug 2022 18:22:48 -0700 (PDT)
Received: from [10.72.12.34] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id m129-20020a625887000000b0052c456eafe1sm14135656pfb.176.2022.08.24.18.22.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 24 Aug 2022 18:22:48 -0700 (PDT)
Subject: Re: [PATCH] ceph: fix error handling in ceph_sync_write
To:     Jeff Layton <jlayton@kernel.org>
Cc:     idryomov@gmail.com, ceph-devel@vger.kernel.org
References: <20220824205331.473248-1-jlayton@kernel.org>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <f1ec7d3e-b23a-63ca-8bb5-29b261b2fced@redhat.com>
Date:   Thu, 25 Aug 2022 09:22:43 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20220824205331.473248-1-jlayton@kernel.org>
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

Hi Jeff,

How reproducible of this ? Two weeks ago I have run some tests didn't 
hit this.

-- Xiubo

On 8/25/22 4:53 AM, Jeff Layton wrote:
> ceph_sync_write has assumed that a zero result in req->r_result means
> success. Testing with a recent cluster however shows the OSD returning
> a non-zero length written here. I'm not sure whether and when this
> changed, but fix the code to accept either result.
>
> Assume a negative result means error, and anything else is a success. If
> we're given a short length, then return a short write.
>
> Signed-off-by: Jeff Layton <jlayton@kernel.org>
> ---
>   fs/ceph/file.c | 10 +++++++++-
>   1 file changed, 9 insertions(+), 1 deletion(-)
>
> diff --git a/fs/ceph/file.c b/fs/ceph/file.c
> index 86265713a743..c0b2c8968be9 100644
> --- a/fs/ceph/file.c
> +++ b/fs/ceph/file.c
> @@ -1632,11 +1632,19 @@ ceph_sync_write(struct kiocb *iocb, struct iov_iter *from, loff_t pos,
>   					  req->r_end_latency, len, ret);
>   out:
>   		ceph_osdc_put_request(req);
> -		if (ret != 0) {
> +		if (ret < 0) {
>   			ceph_set_error_write(ci);
>   			break;
>   		}
>   
> +		/*
> +		 * FIXME: it's unclear whether all OSD versions return the
> +		 * length written on a write. For now, assume that a 0 return
> +		 * means that everything got written.
> +		 */
> +		if (ret && ret < len)
> +			len = ret;
> +
>   		ceph_clear_error_write(ci);
>   		pos += len;
>   		written += len;

