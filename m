Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 85D1D564E12
	for <lists+ceph-devel@lfdr.de>; Mon,  4 Jul 2022 08:59:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230450AbiGDG6y (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 4 Jul 2022 02:58:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232381AbiGDG6q (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 4 Jul 2022 02:58:46 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id D085D1A9
        for <ceph-devel@vger.kernel.org>; Sun,  3 Jul 2022 23:58:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1656917925;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Ghxbx0CrH3dddBVyHTb8hqO8bOGREHZArBfhTAg4nok=;
        b=O9RLwHYZ3shJU8JHK+43RA0JMK4CWrMVruRKRJLq/3Yv05x3jrd5DXGDfM0ilTHkKMEiuG
        PO72mnKBWOwwXnWaC73ZUX8/jjRRyC/CYGaAvC69yHO68Yc1gN9zrmHP5pWSVwALNjP20K
        +ZF63/hdosOFmDcMZcCMOI0wgGZ+87U=
Received: from mail-pf1-f200.google.com (mail-pf1-f200.google.com
 [209.85.210.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-561-o_WzF-vNMJe_SaWx0PgLTA-1; Mon, 04 Jul 2022 02:58:41 -0400
X-MC-Unique: o_WzF-vNMJe_SaWx0PgLTA-1
Received: by mail-pf1-f200.google.com with SMTP id n21-20020a056a000d5500b005251893308cso2291475pfv.6
        for <ceph-devel@vger.kernel.org>; Sun, 03 Jul 2022 23:58:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=Ghxbx0CrH3dddBVyHTb8hqO8bOGREHZArBfhTAg4nok=;
        b=VMDcNCDBXfZUO7QSB1SfNQTQmDfoidZl9TY7vzEk74omYDYsVJ0hhZ2MV3RDythx8J
         IjN4Av7EYbo+mFuvmKxqi8ynQ3m2E2GkHRuwbCUWaCtGIJSlZqHvHGiJ8CZrAVDdFm0f
         Gc+lOIgg8jcwSK7BLCoWw+fUevcAQVEmk4lbyk7o/KPmtfqJm3ZJsme2zAm3G7to94N2
         VrBiPyTrhL25n5sVuoQ8arjqJqzw8DthK+SsKIaf+kTIHiWsxn40ioWVH4uc7A4MwIWE
         K5MAiDEdh5tPVecHxZxFB+GqVvpuT5PMMi0Iq7vbqbjA6uzRHQFen4k2+X0ijClH56ND
         k/YA==
X-Gm-Message-State: AJIora+TYi/L/WeiHVxGmBvlihEDRs3mzxuk44I2npwIVEGkYOhFUJ6e
        sfNqaSJZq94APNhnuGOjccZIw4rB8BtGYsNmOJz0p5eDlGRTE2EmSNB5OBRtfO+r/dGqZRez8Dn
        6CgBphxf3jw19Tbc1/o2FTg==
X-Received: by 2002:a17:90b:35d2:b0:1ef:3695:f1ea with SMTP id nb18-20020a17090b35d200b001ef3695f1eamr27947310pjb.127.1656917920803;
        Sun, 03 Jul 2022 23:58:40 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1sUsVrLQldShVE3/gxCAEU958LIEvJsghCNdNaAbMJ5v/bDAYIRm40Vl6khnOnFJy17l1K8DQ==
X-Received: by 2002:a17:90b:35d2:b0:1ef:3695:f1ea with SMTP id nb18-20020a17090b35d200b001ef3695f1eamr27947289pjb.127.1656917920514;
        Sun, 03 Jul 2022 23:58:40 -0700 (PDT)
Received: from [10.72.12.186] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id u7-20020a17090341c700b0016be3f2cca4sm1189697ple.239.2022.07.03.23.58.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 03 Jul 2022 23:58:39 -0700 (PDT)
Subject: Re: [PATCH 1/2] netfs: release the folio lock and put the folio
 before retrying
To:     Jeff Layton <jlayton@kernel.org>, idryomov@gmail.com,
        dhowells@redhat.com
Cc:     vshankar@redhat.com, linux-kernel@vger.kernel.org,
        ceph-devel@vger.kernel.org, willy@infradead.org,
        keescook@chromium.org, linux-fsdevel@vger.kernel.org,
        linux-cachefs@redhat.com
References: <20220701022947.10716-1-xiubli@redhat.com>
 <20220701022947.10716-2-xiubli@redhat.com>
 <30a4bd0e19626f5fb30f19f0ae70fba2debb361a.camel@kernel.org>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <c2eea9eb-e4b2-efdf-8edc-a929ac276c19@redhat.com>
Date:   Mon, 4 Jul 2022 14:58:33 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <30a4bd0e19626f5fb30f19f0ae70fba2debb361a.camel@kernel.org>
Content-Type: text/plain; charset=iso-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


On 7/1/22 6:38 PM, Jeff Layton wrote:
> On Fri, 2022-07-01 at 10:29 +0800, xiubli@redhat.com wrote:
>> From: Xiubo Li <xiubli@redhat.com>
>>
>> The lower layer filesystem should always make sure the folio is
>> locked and do the unlock and put the folio in netfs layer.
>>
>> URL: https://tracker.ceph.com/issues/56423
>> Signed-off-by: Xiubo Li <xiubli@redhat.com>
>> ---
>>   fs/netfs/buffered_read.c | 5 ++++-
>>   1 file changed, 4 insertions(+), 1 deletion(-)
>>
>> diff --git a/fs/netfs/buffered_read.c b/fs/netfs/buffered_read.c
>> index 42f892c5712e..257fd37c2461 100644
>> --- a/fs/netfs/buffered_read.c
>> +++ b/fs/netfs/buffered_read.c
>> @@ -351,8 +351,11 @@ int netfs_write_begin(struct netfs_inode *ctx,
>>   		ret = ctx->ops->check_write_begin(file, pos, len, folio, _fsdata);
>>   		if (ret < 0) {
>>   			trace_netfs_failure(NULL, NULL, ret, netfs_fail_check_write_begin);
>> -			if (ret == -EAGAIN)
>> +			if (ret == -EAGAIN) {
>> +				folio_unlock(folio);
>> +				folio_put(folio);
>>   				goto retry;
>> +			}
>>   			goto error;
>>   		}
>>   	}
> I don't know here... I think it might be better to just expect that when
> this function returns an error that the folio has already been unlocked.
> Doing it this way will mean that you will lock and unlock the folio a
> second time for no reason.
>
> Maybe something like this instead?
>
> diff --git a/fs/netfs/buffered_read.c b/fs/netfs/buffered_read.c
> index 42f892c5712e..8ae7b0f4c909 100644
> --- a/fs/netfs/buffered_read.c
> +++ b/fs/netfs/buffered_read.c
> @@ -353,7 +353,7 @@ int netfs_write_begin(struct netfs_inode *ctx,
>                          trace_netfs_failure(NULL, NULL, ret, netfs_fail_check_write_begin);
>                          if (ret == -EAGAIN)
>                                  goto retry;
> -                       goto error;
> +                       goto error_unlocked;
>                  }
>          }
>   
> @@ -418,6 +418,7 @@ int netfs_write_begin(struct netfs_inode *ctx,
>   error:
>          folio_unlock(folio);
>          folio_put(folio);
> +error_unlocked:

Should we also put the folio in ceph and afs ? Won't it introduce 
something like use-after-free bug ?

Maybe we should unlock it in ceph and afs and put it in netfs layer.

-- Xiubo



>          _leave(" = %d", ret);
>          return ret;
>   }
>

