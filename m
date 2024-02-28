Return-Path: <ceph-devel+bounces-923-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 3DC0086A48B
	for <lists+ceph-devel@lfdr.de>; Wed, 28 Feb 2024 01:45:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A9F201F23881
	for <lists+ceph-devel@lfdr.de>; Wed, 28 Feb 2024 00:45:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 85137A23;
	Wed, 28 Feb 2024 00:45:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ZQaWPm0q"
X-Original-To: ceph-devel@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58EA01103
	for <ceph-devel@vger.kernel.org>; Wed, 28 Feb 2024 00:45:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709081152; cv=none; b=FhvUwQoo7vi5SNNFroZ6dxy+D49Uq8qBbD/QVAZJYKBj5Qzv3C1rAnXQVxtvtqlTOCksmVEZ6oLPkwW8wtryVnHbLPdyJTBpUA3jZDqEdn8dGimydJRH13Vgbz0o0T1VN+z4xdYFdass0ZwxOKpsObwl5lIvmTBIM5FSS40h53Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709081152; c=relaxed/simple;
	bh=gSZyUP6O6g6J4r0kXzxhii7OTqAez7MkpEAt9mr2qdo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=YD4QohvWWuSA8p0fnOhQ0KKYNOV61xgxI87+S7PM6E9AoBay2oeF1KCWMZb726y7lI3S1LsVu1lyPwMEgSVaBy6eT/P9vNo+meiZwK9IN14ZGFpvXkie/zO4lBmgfLJEqoZYaJ8gTRwp6y/TPsUsxLLdXxY/9fit9EREM7CC7yU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ZQaWPm0q; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1709081149;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Ar8Zc8bvpsf0N4SaHRr4rzqiyWfxRRv+3XLplpbFMcA=;
	b=ZQaWPm0qoGTcToiklcsx5sdwXcxCRUI+7P7Jfu0C34UaelBf6h80m3uYkAM2c8tqx/p8SP
	P0N5RjUNIJUZnSoLTKfn5SKxn1ik5rVZRsM96x+hNR81cltl7ntYZOo+sS17z5ONk0BwwE
	AxuTPsUJSOFM7mJWmgaUdM0WihDpwW4=
Received: from mail-pf1-f199.google.com (mail-pf1-f199.google.com
 [209.85.210.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-607-whP4JQQvNjusfmmmV5fl1A-1; Tue, 27 Feb 2024 19:45:47 -0500
X-MC-Unique: whP4JQQvNjusfmmmV5fl1A-1
Received: by mail-pf1-f199.google.com with SMTP id d2e1a72fcca58-6e5355a7e7fso1219292b3a.2
        for <ceph-devel@vger.kernel.org>; Tue, 27 Feb 2024 16:45:47 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709081146; x=1709685946;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Ar8Zc8bvpsf0N4SaHRr4rzqiyWfxRRv+3XLplpbFMcA=;
        b=Q1/1+CV9P/d+2DBlypFAbPfgwZmm8ocYJik3IPI2T7xUxokHiwezsh9ZdR9Ac3LTpD
         IwY49PLqdOOfJnUKeHBkc4DEPK5u36qzDyjZjLbdJNvgywidCm3r02k/sccOnQL6xFzj
         YWZJrHJZVpR7xUvtA/WVmtyAN9osKy2aSm85zo8XhG+sHAtaSQeJo/BGGNuPshAl3+V1
         NiWSlI6OPfs/5cMAjbGuU9Hf2e0gQlPFbZrzrBHyiYKyNUzENP+qY5gX9eVBW4Tw5rES
         Uhax1WhPEY4qkQJsPJbkWDb6w3gYqgiJsXLnQEUiBvdjeiktQA6dQQHxS9IU8mkOczP2
         MXXg==
X-Gm-Message-State: AOJu0YwvIKvjOVmAH4WkMieHm+1/BaQriz5ygjWk33k9M+82DfV97UvG
	sUAesxZ4JJwwnK9dBTYX0VLt0m0y3uZiWDOjZ9AZGyGeFWafvr4UXqs3Ler802+9f98HocNyujX
	UEm8WoNKk1CptlupNfE8Gmv3gPcYVoc69ZPsZLML6cbTBlSqaOIaoMPulzSk=
X-Received: by 2002:a17:902:a3c6:b0:1d9:9e4f:c0b3 with SMTP id q6-20020a170902a3c600b001d99e4fc0b3mr10001816plb.64.1709081146335;
        Tue, 27 Feb 2024 16:45:46 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFQDeeFYyzee8qHoEMmjCRvcx2e+eIuWqAutzQoa4Zch0jIPe35S1ujU8fDBeKFMiqxUoYO0Q==
X-Received: by 2002:a17:902:a3c6:b0:1d9:9e4f:c0b3 with SMTP id q6-20020a170902a3c600b001d99e4fc0b3mr10001804plb.64.1709081146000;
        Tue, 27 Feb 2024 16:45:46 -0800 (PST)
Received: from [10.72.112.85] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id s18-20020a170902a51200b001d9a42f6183sm2101916plq.45.2024.02.27.16.45.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 27 Feb 2024 16:45:45 -0800 (PST)
Message-ID: <831bfb4a-6213-4e32-8c68-252be354342e@redhat.com>
Date: Wed, 28 Feb 2024 08:45:41 +0800
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 3/3] libceph: just wait for more data to be available
 on the socket
Content-Language: en-US
To: Luis Henriques <lhenriques@suse.de>
Cc: ceph-devel@vger.kernel.org, idryomov@gmail.com, jlayton@kernel.org,
 vshankar@redhat.com, mchangir@redhat.com
References: <20240125023920.1287555-1-xiubli@redhat.com>
 <20240125023920.1287555-4-xiubli@redhat.com> <871q8x4yac.fsf@suse.de>
From: Xiubo Li <xiubli@redhat.com>
In-Reply-To: <871q8x4yac.fsf@suse.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit


On 2/28/24 01:22, Luis Henriques wrote:
> Hi Xiubo!
>
> xiubli@redhat.com writes:
>
>> From: Xiubo Li <xiubli@redhat.com>
>>
>> A short read may occur while reading the message footer from the
>> socket.  Later, when the socket is ready for another read, the
>> messenger shoudl invoke all read_partial* handlers, except the
>> read_partial_sparse_msg_data().  The contract between the messenger
>> and these handlers is that the handlers should bail if the area
>> of the message is responsible for is already processed.  So,
>> in this case, it's expected that read_sparse_msg_data() would bail,
>> allowing the messenger to invoke read_partial() for the footer and
>> pick up where it left off.
>>
>> However read_partial_sparse_msg_data() violates that contract and
>> ends up calling into the state machine in the OSD client. The
>> sparse-read state machine just assumes that it's a new op and
>> interprets some piece of the footer as the sparse-read extents/data
>> and then returns bogus extents/data length, etc.
>>
>> This will just reuse the 'total_resid' to determine whether should
>> the read_partial_sparse_msg_data() bail out or not. Because once
>> it reaches to zero that means all the extents and data have been
>> successfully received in last read, else it could break out when
>> partially reading any of the extents and data. And then the
>> osd_sparse_read() could continue where it left off.
> I'm seeing an issue with fstest generic/580, which seems to enter an
> infinite loop effectively rendering the testing VM unusable.  It's pretty
> easy to reproduce, just run the test ensuring to be using msgv2 (I'm
> mounting the filesystem with 'ms_mode=crc'), and you should see the
> following on the logs:
>
> [...]
>    libceph: prepare_sparse_read_cont: ret 0x1000 total_resid 0x0 resid 0x0
>    libceph: osd1 (2)192.168.155.1:6810 read processing error
>    libceph: mon0 (2)192.168.155.1:40608 session established
>    libceph: bad late_status 0x1
>    libceph: osd1 (2)192.168.155.1:6810 protocol error, bad epilogue
>    libceph: mon0 (2)192.168.155.1:40608 session established
>    libceph: prepare_sparse_read_cont: ret 0x1000 total_resid 0x0 resid 0x0
>    libceph: osd1 (2)192.168.155.1:6810 read processing error
>    libceph: mon0 (2)192.168.155.1:40608 session established
>    libceph: bad late_status 0x1
> [...]
>
> Reverting this patch (commit 8e46a2d068c9 ("libceph: just wait for more
> data to be available on the socket")) seems to fix.  I haven't
> investigated it further, but since it'll take me some time to refresh my
> memory, I thought I should report it immediately.  Maybe someone has any
> idea.

The following patch should fix it. I haven't test it yet. Will do it 
later today:


diff --git a/net/ceph/messenger_v2.c b/net/ceph/messenger_v2.c
index a0ca5414b333..2c32ad4d9774 100644
--- a/net/ceph/messenger_v2.c
+++ b/net/ceph/messenger_v2.c
@@ -1860,10 +1860,10 @@ static int prepare_read_control_remainder(struct 
ceph_connection *con)
  static int prepare_read_data(struct ceph_connection *con)
  {
         struct bio_vec bv;
+       u64 len = con->in_msg->sparse_read_total ? : data_len(con->in_msg);

         con->in_data_crc = -1;
-       ceph_msg_data_cursor_init(&con->v2.in_cursor, con->in_msg,
-                                 data_len(con->in_msg));
+       ceph_msg_data_cursor_init(&con->v2.in_cursor, con->in_msg, len);

         get_bvec_at(&con->v2.in_cursor, &bv);
         if (ceph_test_opt(from_msgr(con->msgr), RXBOUNCE)) {


> Cheers,


