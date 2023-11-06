Return-Path: <ceph-devel+bounces-54-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6A3197E2124
	for <lists+ceph-devel@lfdr.de>; Mon,  6 Nov 2023 13:18:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id CB003B20E16
	for <lists+ceph-devel@lfdr.de>; Mon,  6 Nov 2023 12:18:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CCD7D1EB4C;
	Mon,  6 Nov 2023 12:18:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="K0gLypdw"
X-Original-To: ceph-devel@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49BDE1EB36
	for <ceph-devel@vger.kernel.org>; Mon,  6 Nov 2023 12:18:03 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4E36107
	for <ceph-devel@vger.kernel.org>; Mon,  6 Nov 2023 04:18:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1699273081;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=qsdZdLiyJN8osh7LUA5CumWrLvUzdg/q8I1JWyt2xxE=;
	b=K0gLypdwiCrAyLMn5Fb299k4SR6Ottb8QotJsEZxeJzrVDRQB1/xGzaGJGlnGV4SrJY2v+
	9LKBMfoKdHBhupaSkA/TLq9ini3cbci9ryRQJR88il1soA+6gq8htK4vZVs6LVC53B8yaP
	QW9CIikiyTj9+fP2nqiVuN34NffX2Q8=
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com
 [209.85.216.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-155-NOzGU8oHPdmjy-3AXzOl8g-1; Mon, 06 Nov 2023 07:17:59 -0500
X-MC-Unique: NOzGU8oHPdmjy-3AXzOl8g-1
Received: by mail-pj1-f71.google.com with SMTP id 98e67ed59e1d1-28032570a00so3179994a91.0
        for <ceph-devel@vger.kernel.org>; Mon, 06 Nov 2023 04:17:59 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699273078; x=1699877878;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=qsdZdLiyJN8osh7LUA5CumWrLvUzdg/q8I1JWyt2xxE=;
        b=hZPwrkX42/Hg+Kuxd4eNXTjRlYOK6A5KObe72h/rlMikOuzEUhzg3nWHmC3Bc6LR+l
         stEB9u2DWYaV4Afz4GsXlqddnSZapbW6dn7RlwDmasFLBaqDTSx5DDQ2P9qNLn9xPH9m
         uDQKg3+g3YfNlf5FXyFohEpnZe78++oj+L54P5n5Q3b1kHKVzKkykFyqoKGNaEh8ycfD
         nsvbOjgRj7g3nJUVfNhMi3kh0MtoUWNNbX7WPzdV1CETsOur24Ckj1KwP+Nxxs3FXvQa
         28BO8wgrkNb5F14hNP6CXHHTmvWumqngF8FkxpCCpB+8KLVECr1EwKT/+WG4x09eaCsg
         fcZQ==
X-Gm-Message-State: AOJu0YxDG3QIruKAikv4ycq9BTHCcv6mVpyyvAlKbuvjIQxoNaVzEghp
	CcA5SS18K/VANytdRIgMIf2MlRtPBP75d4VmHSIn7R88x8K4yz/paQ+wJ+CbeBfb/pvjDyp8BPj
	aD8I9QDJ4fr7swVliHcFuyw==
X-Received: by 2002:a17:90b:617:b0:27d:58a8:fa7f with SMTP id gb23-20020a17090b061700b0027d58a8fa7fmr24186280pjb.37.1699273078668;
        Mon, 06 Nov 2023 04:17:58 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGVg58KpmJH+4d6C/bNzkV8igVqstDp4ZeDqxDC8cYZ+hoeivUksrEazQAHbD0KKPJLc7nNqA==
X-Received: by 2002:a17:90b:617:b0:27d:58a8:fa7f with SMTP id gb23-20020a17090b061700b0027d58a8fa7fmr24186255pjb.37.1699273077996;
        Mon, 06 Nov 2023 04:17:57 -0800 (PST)
Received: from [10.72.112.221] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id nh5-20020a17090b364500b00280202c092fsm5401295pjb.33.2023.11.06.04.17.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 06 Nov 2023 04:17:57 -0800 (PST)
Message-ID: <873e9540-cf61-e517-eb68-5b83e8984f0e@redhat.com>
Date: Mon, 6 Nov 2023 20:17:54 +0800
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH v3 2/2] libceph: check the data length when sparse-read
 finishes
Content-Language: en-US
To: Ilya Dryomov <idryomov@gmail.com>
Cc: ceph-devel@vger.kernel.org, jlayton@kernel.org, vshankar@redhat.com,
 mchangir@redhat.com
References: <20231106011644.248119-1-xiubli@redhat.com>
 <20231106011644.248119-3-xiubli@redhat.com>
 <CAOi1vP_NQmkreqVoM+CP=v3PkGh-79jYV8xgrmDA0b4z8PJ3mA@mail.gmail.com>
From: Xiubo Li <xiubli@redhat.com>
In-Reply-To: <CAOi1vP_NQmkreqVoM+CP=v3PkGh-79jYV8xgrmDA0b4z8PJ3mA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit


On 11/6/23 19:54, Ilya Dryomov wrote:
> On Mon, Nov 6, 2023 at 2:19 AM <xiubli@redhat.com> wrote:
>> From: Xiubo Li <xiubli@redhat.com>
>>
>> For sparse reading the real length of the data should equal to the
>> total length from the extent array.
>>
>> URL: https://tracker.ceph.com/issues/62081
>> Signed-off-by: Xiubo Li <xiubli@redhat.com>
>> Reviewed-by: Jeff Layton <jlayton@kernel.org>
>> ---
>>   net/ceph/osd_client.c | 8 ++++++++
>>   1 file changed, 8 insertions(+)
>>
>> diff --git a/net/ceph/osd_client.c b/net/ceph/osd_client.c
>> index 0e629dfd55ee..050dc39065fb 100644
>> --- a/net/ceph/osd_client.c
>> +++ b/net/ceph/osd_client.c
>> @@ -5920,6 +5920,12 @@ static int osd_sparse_read(struct ceph_connection *con,
>>                  fallthrough;
>>          case CEPH_SPARSE_READ_DATA:
>>                  if (sr->sr_index >= count) {
>> +                       if (sr->sr_datalen && count) {
>> +                               pr_warn_ratelimited("%s: datalen and extents mismath, %d left\n",
>> +                                                   __func__, sr->sr_datalen);
>> +                               return -EREMOTEIO;
> By returning EREMOTEIO here you have significantly changed the
> semantics (in v2 it was just a warning) but Jeff's Reviewed-by is
> retained.  Has he acked the change?

Oh, sorry I forgot to remove that.

Jeff, Please take a look here again.

Thanks

- Xiubo

> Thanks,
>
>                  Ilya
>


