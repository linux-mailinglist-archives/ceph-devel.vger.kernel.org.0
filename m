Return-Path: <ceph-devel+bounces-1558-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2400D93BDA9
	for <lists+ceph-devel@lfdr.de>; Thu, 25 Jul 2024 10:04:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5216C1C21B40
	for <lists+ceph-devel@lfdr.de>; Thu, 25 Jul 2024 08:04:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4B3A2173344;
	Thu, 25 Jul 2024 08:04:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Km3/Y9YH"
X-Original-To: ceph-devel@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14769173326
	for <ceph-devel@vger.kernel.org>; Thu, 25 Jul 2024 08:04:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721894678; cv=none; b=DKzNAhAxoIrnd2dSXWQFkSK4bim9p+CM9XXnQdF44gly0WrayMqmF7waB6Cu+frHSQT2h7yGvWLPmP23NPL8NqVFJZYK3h9PG75gH6JTMwPqRSMuPfq/4NX8N+SHh4lA9zmoTQsXeMmZzAA4KqwsMXCRPCZG+xIcf31cUBCceSk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721894678; c=relaxed/simple;
	bh=QQy/RmWTVjOKlPqq55FBCITnh1XlHjN+1fb8Yxi9I5Q=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=VfN8eIVvGUIeCPUM/TCL4tS6BNxcatuaizKVU2+KS+R2OHO4GNN1CMM79fi2zPaf0v5Byk/DW2RuMK6Q+IZRHhaXMpHfgVUBhashxTRU5mG1KEfzL0ykUY5hzmhguDPmqcxTl1m1r5Fbh90kUp0DzCzVl1w7Djr+btDFVDDq4bc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Km3/Y9YH; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1721894675;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=FmEpSXDSyLPllJM/G/bh0MRW82riFJT4pe4Krd+7zeQ=;
	b=Km3/Y9YHGB2MBHO7uVyut2CldWwRd6uqBgBls5VWg0kOtvLypHm+iznRGfrxtsFg+4dm9m
	sGKNIyYEql2rhYtBy6CXhjX+urlKlLQmxnGeyrH00puNh4J1vFiKVNCwHE5xdPJ+rQLPjc
	8uwV/3gixWxYM2RibxSmNSW2l4wlLDI=
Received: from mail-pf1-f197.google.com (mail-pf1-f197.google.com
 [209.85.210.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-390-tFNE_yJUO-OWTqocsKLywQ-1; Thu, 25 Jul 2024 04:04:33 -0400
X-MC-Unique: tFNE_yJUO-OWTqocsKLywQ-1
Received: by mail-pf1-f197.google.com with SMTP id d2e1a72fcca58-70d2246c555so611220b3a.2
        for <ceph-devel@vger.kernel.org>; Thu, 25 Jul 2024 01:04:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721894672; x=1722499472;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=FmEpSXDSyLPllJM/G/bh0MRW82riFJT4pe4Krd+7zeQ=;
        b=XIoLUaZC+OE6QepF5AhVP79auuKG4RWqecRVTrdnJOBNCzAzer9TPA2JZA/dW4r7Py
         rSEhC9Axu9o+xiM78Cfn3U2RAHdF6HZnejZKVoDCve+M5nYFGArELVOfo5PGxZtj9Ra9
         agHaVKEeEHhIYuO/KSW7FUWvsCkHl45uha5iyFRTZfqhKct0aEj3EMj4wyAId/n54Jog
         BATuGdlF9bu/vr3rdmjZJM6eb8IGf1MaDiKlt4u3ZvAZp7T3OMm/OqpNZjAoUvP33oDr
         2xyOtUIK9yFK9lMz8zTrrc+Ew4PZZMVLey3sB641qhzXN2kncHy/kEGqTHd9C8nxasfx
         mCkA==
X-Gm-Message-State: AOJu0Yw3MUR7nynnBjfvX7KPk8tRx2hdylxFih0CI12ZMMCi078ZgRTT
	OCyFl5yzN0mxnxRu0zbrLibZBBgf4CxAJ/gWpnc7PPTpfnrOZgR107FzrnpD8+ctnmI2NLDuavx
	BNEeusPjSiNqvnUv9xN9OBWNv4hHjlqgi1raA5qpzTl82EP3uoecMM/L03k8=
X-Received: by 2002:a05:6a20:2454:b0:1c2:a3c7:47dd with SMTP id adf61e73a8af0-1c47b4ae37amr1260036637.42.1721894672588;
        Thu, 25 Jul 2024 01:04:32 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGRps0xWnawxTzKHV4AOS2h5Ep3LPFQ6jbpYGDaFzNNAxjtYGh0BjYzZauqa5wxydY2D8fnqw==
X-Received: by 2002:a05:6a20:2454:b0:1c2:a3c7:47dd with SMTP id adf61e73a8af0-1c47b4ae37amr1260008637.42.1721894672194;
        Thu, 25 Jul 2024 01:04:32 -0700 (PDT)
Received: from [10.72.116.41] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-1fed7fe1a26sm8034625ad.288.2024.07.25.01.04.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 25 Jul 2024 01:04:31 -0700 (PDT)
Message-ID: <8bf8d79c-78e1-479c-bd13-52bc4a1c7d07@redhat.com>
Date: Thu, 25 Jul 2024 16:04:22 +0800
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] ceph: stop reconnecting to MDS after connection being
 closed
To: Venky Shankar <vshankar@redhat.com>
Cc: ceph-devel@vger.kernel.org, idryomov@gmail.com, mchangir@redhat.com
References: <20240514070856.194701-1-xiubli@redhat.com>
 <CACPzV1nHXN6Bh-8i6VyMnmMX5-26D0ra1nfD=Ly_sAYa1_M_OA@mail.gmail.com>
Content-Language: en-US
From: Xiubo Li <xiubli@redhat.com>
In-Reply-To: <CACPzV1nHXN6Bh-8i6VyMnmMX5-26D0ra1nfD=Ly_sAYa1_M_OA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit


On 7/25/24 13:22, Venky Shankar wrote:
> Hi Xiubo,
>
> On Tue, May 14, 2024 at 12:39 PM <xiubli@redhat.com> wrote:
>> From: Xiubo Li <xiubli@redhat.com>
>>
>> The reconnect feature never been supported by MDS in mds non-RECONNECT
>> state. This reconnect requests will incorrectly close the just reopened
>> sessions when the MDS kills them during the "mds_session_blocklist_on_evict"
>> option is disabled.
>>
>> Remove it for now.
>>
>> Fixes: 7e70f0ed9f3e ("ceph: attempt mds reconnect if mds closes our session")
>> URL: https://tracker.ceph.com/issues/65647
>> Signed-off-by: Xiubo Li <xiubli@redhat.com>
>> ---
>>   fs/ceph/mds_client.c | 3 ---
>>   1 file changed, 3 deletions(-)
>>
>> diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
>> index f5b25d178118..97a126c54578 100644
>> --- a/fs/ceph/mds_client.c
>> +++ b/fs/ceph/mds_client.c
>> @@ -6241,9 +6241,6 @@ static void mds_peer_reset(struct ceph_connection *con)
>>
>>          pr_warn_client(mdsc->fsc->client, "mds%d closed our session\n",
>>                         s->s_mds);
>> -       if (READ_ONCE(mdsc->fsc->mount_state) != CEPH_MOUNT_FENCE_IO &&
>> -           ceph_mdsmap_get_state(mdsc->mdsmap, s->s_mds) >= CEPH_MDS_STATE_RECONNECT)
>> -               send_mds_reconnect(mdsc, s);
>>   }
>>
>>   static void mds_dispatch(struct ceph_connection *con, struct ceph_msg *msg)
>> --
>> 2.44.0
>>
> I don't see this change in the testing branch so that the fix can be
> verified with
>
>          https://github.com/ceph/ceph/pull/57458

Venky,

As I rememembered this is buggy and there was a failure in qa runs. So 
this change won't work.

Let me have a check again.

Thanks

- Xiubo



