Return-Path: <ceph-devel+bounces-528-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BD28682E59F
	for <lists+ceph-devel@lfdr.de>; Tue, 16 Jan 2024 01:48:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C8739283F90
	for <lists+ceph-devel@lfdr.de>; Tue, 16 Jan 2024 00:48:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7A29D1D521;
	Tue, 16 Jan 2024 00:24:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="IjhBEaOC"
X-Original-To: ceph-devel@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68E401CFA4
	for <ceph-devel@vger.kernel.org>; Tue, 16 Jan 2024 00:24:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1705364668;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=gfQVfSKyppNTSyn8jb/M37F+IzrS2tRex7F1cCJwhz4=;
	b=IjhBEaOC0TOVqUbwBbrT0lGPE4hZJgHV69C2Uc8WbzZdrsUWDOha3LdzoSnenyoCW2KUx2
	pQelj5SRysz3nufDeV2lyEzvC/1WMXXgHIUMvz9sSBLIRz8KYzNtIBfznwvPHQ9FxPALPw
	YFwmWyBEs1SHZ9YfRkpr/z2ODfNmhKc=
Received: from mail-oi1-f198.google.com (mail-oi1-f198.google.com
 [209.85.167.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-336-Rf1Bs1HoMZ6kUhnKsiNwSA-1; Mon, 15 Jan 2024 19:24:19 -0500
X-MC-Unique: Rf1Bs1HoMZ6kUhnKsiNwSA-1
Received: by mail-oi1-f198.google.com with SMTP id 5614622812f47-3bb87fc010fso11457793b6e.0
        for <ceph-devel@vger.kernel.org>; Mon, 15 Jan 2024 16:24:19 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1705364658; x=1705969458;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=gfQVfSKyppNTSyn8jb/M37F+IzrS2tRex7F1cCJwhz4=;
        b=T1VNU6nGJUrz3lFwfaQ25tfstNX1Iwom1c/BfKxHUOT+uCTAr0FDRYpKBaG8/5UEI3
         EO55U0LJifvlpcZQL0VAI6CHyRozfKyFKJuop1puI+1PBFnIpVslH7yIz3OorEHvqXTN
         gOeqlouO0iuIr/o0Rf70/4G2fqhuNE536sScJ7UQsh/bodadPYuvDJASzvCwVkfROLJv
         prOdSF1++3rYLSnw6j3o4oQ2YkepO5p+afJB2PzNo/PngUSzRSmvpxJ16GM7mIKClca1
         g7rPWavHtJbmLgHUwSASXzoQVFgYs6WGNqwuop17QMKZNLr1FI0qYiMthrAPaxCOwZUP
         dg3w==
X-Gm-Message-State: AOJu0Yy1zMeiOjXX4KII4Ni+EGrzTNXjbH0nUedX4pn9DOpFEPxl4tUP
	5aDFeXvIU71SwCyyk5f24tEbRoemOM53/ht8c2ko6ib3K4TigLuS2bASGhKkYT1jGbthDdXEAHH
	P4DY+ncM/w6e1tLl8OZw+AV4GM3T3ZA==
X-Received: by 2002:a05:6808:4497:b0:3bb:d83a:99a8 with SMTP id eq23-20020a056808449700b003bbd83a99a8mr8924230oib.58.1705364658810;
        Mon, 15 Jan 2024 16:24:18 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGESx3IfMu3XQcAeJYgbcITxARllNiAMr6TjybfMzQr31buhbogYnrSL21Y1sAVa1C2c3Ep0A==
X-Received: by 2002:a05:6808:4497:b0:3bb:d83a:99a8 with SMTP id eq23-20020a056808449700b003bbd83a99a8mr8924224oib.58.1705364658585;
        Mon, 15 Jan 2024 16:24:18 -0800 (PST)
Received: from [10.72.112.211] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id cm22-20020a056a020a1600b005bd980cca56sm7735197pgb.29.2024.01.15.16.24.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 15 Jan 2024 16:24:18 -0800 (PST)
Message-ID: <5d7afd30-6423-4e27-9771-e64d78ee3b12@redhat.com>
Date: Tue, 16 Jan 2024 08:24:14 +0800
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/2] ceph: add ceph_cap_unlink_work to fire check caps
 immediately
Content-Language: en-US
To: Ilya Dryomov <idryomov@gmail.com>
Cc: ceph-devel@vger.kernel.org, jlayton@kernel.org, vshankar@redhat.com,
 mchangir@redhat.com
References: <20231025061952.288730-1-xiubli@redhat.com>
 <20231025061952.288730-3-xiubli@redhat.com>
 <CAOi1vP9OdJsQ+AkJ7c7q6xjbsLE_pfLaiu+fwHCV7CUdp640yw@mail.gmail.com>
From: Xiubo Li <xiubli@redhat.com>
In-Reply-To: <CAOi1vP9OdJsQ+AkJ7c7q6xjbsLE_pfLaiu+fwHCV7CUdp640yw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit


On 1/16/24 06:44, Ilya Dryomov wrote:
> On Wed, Oct 25, 2023 at 8:22 AM <xiubli@redhat.com> wrote:
>> From: Xiubo Li <xiubli@redhat.com>
>>
>> When unlinking a file the check caps could be delayed for more than
>> 5 seconds, but in MDS side it maybe waiting for the clients to
>> release caps.
>>
>> This will add a dedicated work queue and list to help trigger to
>> fire the check caps and dirty buffer flushing immediately.
>>
>> URL: https://tracker.ceph.com/issues/50223
>> Signed-off-by: Xiubo Li <xiubli@redhat.com>
>> ---
>>   fs/ceph/caps.c       | 17 ++++++++++++++++-
>>   fs/ceph/mds_client.c | 34 ++++++++++++++++++++++++++++++++++
>>   fs/ceph/mds_client.h |  4 ++++
>>   3 files changed, 54 insertions(+), 1 deletion(-)
>>
>> diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
>> index 9b9ec1adc19d..be4f986e082d 100644
>> --- a/fs/ceph/caps.c
>> +++ b/fs/ceph/caps.c
>> @@ -4790,7 +4790,22 @@ int ceph_drop_caps_for_unlink(struct inode *inode)
>>                  if (__ceph_caps_dirty(ci)) {
>>                          struct ceph_mds_client *mdsc =
>>                                  ceph_inode_to_fs_client(inode)->mdsc;
>> -                       __cap_delay_requeue_front(mdsc, ci);
>> +
>> +                       doutc(mdsc->fsc->client, "%p %llx.%llx\n", inode,
>> +                             ceph_vinop(inode));
>> +                       spin_lock(&mdsc->cap_unlink_delay_lock);
>> +                       ci->i_ceph_flags |= CEPH_I_FLUSH;
>> +                       if (!list_empty(&ci->i_cap_delay_list))
>> +                               list_del_init(&ci->i_cap_delay_list);
>> +                       list_add_tail(&ci->i_cap_delay_list,
>> +                                     &mdsc->cap_unlink_delay_list);
>> +                       spin_unlock(&mdsc->cap_unlink_delay_lock);
>> +
>> +                       /*
>> +                        * Fire the work immediately, because the MDS maybe
>> +                        * waiting for caps release.
>> +                        */
>> +                       schedule_work(&mdsc->cap_unlink_work);
> Hi Xiubo,
>
> This schedules a work an a system-wide workqueue, not specific to
> CephFS.  Is there something that ensures that it gets flushed as part
> of unmount and possibly on other occasions that have to do with
> individual inodes?

Hi Ilya,

There seems no, I didn't find any.

Let me add a dedicated workqueue for this.

Thanks

- Xiubo


> Thanks,
>
>                  Ilya
>


