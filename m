Return-Path: <ceph-devel+bounces-36-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1B0937E1817
	for <lists+ceph-devel@lfdr.de>; Mon,  6 Nov 2023 01:07:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id ABF192812F9
	for <lists+ceph-devel@lfdr.de>; Mon,  6 Nov 2023 00:07:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5E7DC441A;
	Mon,  6 Nov 2023 00:07:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="M43BhOEh"
X-Original-To: ceph-devel@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 286114404
	for <ceph-devel@vger.kernel.org>; Mon,  6 Nov 2023 00:07:18 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A138293
	for <ceph-devel@vger.kernel.org>; Sun,  5 Nov 2023 16:07:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1699229235;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=WZFOZlnS/6Jsio00sE62Ngny2lJb0ORqn6JIyBQx+gM=;
	b=M43BhOEh5tHySdg87EYPb965qkdK6CucLJr7mT/+vIhYQppjmZhGFQXeCa7RKQaXAKxBzs
	Aeh4/J73kjADuBqNRixgcGBlW6XL6SMKwV4DBLdeSSgGwTGEMnazeg5gFMLsFwYIpHk5uW
	a1WIENoP22v0iu12LVFxHx4WQDumef8=
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com
 [209.85.214.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-272-w-mH5NebOw-oOPArgIu3Lw-1; Sun, 05 Nov 2023 19:07:14 -0500
X-MC-Unique: w-mH5NebOw-oOPArgIu3Lw-1
Received: by mail-pl1-f198.google.com with SMTP id d9443c01a7336-1cc23f2226bso25161285ad.2
        for <ceph-devel@vger.kernel.org>; Sun, 05 Nov 2023 16:07:14 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699229233; x=1699834033;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=WZFOZlnS/6Jsio00sE62Ngny2lJb0ORqn6JIyBQx+gM=;
        b=W4iSIPZY+oyYa1Uk89dI2DPAnuv6yp66YfmjxXUau8up7bSS+kYtmkbgmTsPFXaRC+
         YUMGm2zN2rsnTl2OWUEtMcfOKkKTgjNxfr87H7FhbL/xNx9DlJH/xONICZKqLzhxgCcd
         gvTdpLviJeHo+DAmIlfnQLVamlQaBBBn0wi6fgr7tOYZuOccOslV/0vAARQ59MjvnI72
         gvW2JRwJ9K8HbfqVSk71iW6xgEKcvvsi8tMNDAD/gXJ1OtW/v0+ZGn6q5Bmr3AlcV9Hu
         lMaxIaq5AQKb0g8eYG48dsoRasVyI2beUL3Vp4wL0gPHvp8pBbocc0W2+m3LxOv+XCIo
         YFUw==
X-Gm-Message-State: AOJu0YwL7Q0RNpASF6HYV3iFwNBnmKPKqi8HvJWlDWj1wZkEUNSlAmoE
	IPhpYY+Xh3D1XA+g5RrRatHaByyYGIcvbEMsW6ZG5co78Z1ZseU8k4GM1+M90EAaiMbn7lSXo59
	+3RAlhPuYgoPz9eFqfA/zKA==
X-Received: by 2002:a17:902:f112:b0:1cc:4072:22c6 with SMTP id e18-20020a170902f11200b001cc407222c6mr14912823plb.24.1699229233169;
        Sun, 05 Nov 2023 16:07:13 -0800 (PST)
X-Google-Smtp-Source: AGHT+IE57Eq6hWxPznEbKTf22EpAA2jEizjEppbNDNqoAeoN5RLzHwVTyzZm/BfWtYWNOM+xAHom7g==
X-Received: by 2002:a17:902:f112:b0:1cc:4072:22c6 with SMTP id e18-20020a170902f11200b001cc407222c6mr14912808plb.24.1699229232744;
        Sun, 05 Nov 2023 16:07:12 -0800 (PST)
Received: from [10.72.112.124] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id 4-20020a170902ee4400b001c407fac227sm4625712plo.41.2023.11.05.16.07.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 05 Nov 2023 16:07:12 -0800 (PST)
Message-ID: <347a6862-c783-3f4a-38de-526d0506bcdb@redhat.com>
Date: Mon, 6 Nov 2023 08:07:08 +0800
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH v2 2/2] libceph: check the data length when finishes
Content-Language: en-US
To: Ilya Dryomov <idryomov@gmail.com>
Cc: ceph-devel@vger.kernel.org, jlayton@kernel.org, vshankar@redhat.com,
 mchangir@redhat.com
References: <20231101005033.21995-1-xiubli@redhat.com>
 <20231101005033.21995-3-xiubli@redhat.com>
 <CAOi1vP9pJGU4SeJntKoQYUarOc03Vn2sxqsd4H9LtGAe+dzZNg@mail.gmail.com>
From: Xiubo Li <xiubli@redhat.com>
In-Reply-To: <CAOi1vP9pJGU4SeJntKoQYUarOc03Vn2sxqsd4H9LtGAe+dzZNg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit


On 11/3/23 20:49, Ilya Dryomov wrote:
> On Wed, Nov 1, 2023 at 1:52 AM <xiubli@redhat.com> wrote:
>> From: Xiubo Li <xiubli@redhat.com>
>>
>> For sparse reading the real length of the data should equal to the
>> total length from the extent array.
>>
>> URL: https://tracker.ceph.com/issues/62081
>> Signed-off-by: Xiubo Li <xiubli@redhat.com>
>> Reviewed-by: Jeff Layton <jlayton@kernel.org>
>> ---
>>   net/ceph/osd_client.c | 9 +++++++++
>>   1 file changed, 9 insertions(+)
>>
>> diff --git a/net/ceph/osd_client.c b/net/ceph/osd_client.c
>> index 800a2acec069..7af35106acaf 100644
>> --- a/net/ceph/osd_client.c
>> +++ b/net/ceph/osd_client.c
>> @@ -5921,6 +5921,13 @@ static int osd_sparse_read(struct ceph_connection *con,
>>                  fallthrough;
>>          case CEPH_SPARSE_READ_DATA:
>>                  if (sr->sr_index >= count) {
>> +                       if (sr->sr_datalen && count) {
>> +                               pr_warn_ratelimited("sr_datalen %d sr_index %d count %d\n",
>> +                                                   sr->sr_datalen, sr->sr_index,
>> +                                                   count);
>> +                               WARN_ON_ONCE(sr->sr_datalen);
> Hi Xiubo,
>
> I don't think we need both pr_warn_ratelimited and WARN_ON_ONCE?  This
> is a state machine, so the stack trace that WARN_ON_ONCE would dump is
> unlikely to be of any help.

Okay, makes sense. Let me remove the WARN_ON_ONCE.

Thanks

- Xiubo

> Thanks,
>
>                  Ilya
>


