Return-Path: <ceph-devel+bounces-922-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id AE25686A45B
	for <lists+ceph-devel@lfdr.de>; Wed, 28 Feb 2024 01:22:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3B81D1F2B34C
	for <lists+ceph-devel@lfdr.de>; Wed, 28 Feb 2024 00:22:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 664D236B;
	Wed, 28 Feb 2024 00:22:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="IV0ta4lB"
X-Original-To: ceph-devel@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A4A5363
	for <ceph-devel@vger.kernel.org>; Wed, 28 Feb 2024 00:22:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709079756; cv=none; b=jnX8d+cnhCdTy+htPAPlvQkCVxH6rGNVbm/usSIIRN7h3fIGi910Pu1xM+BAS7FAN+37oSm7y+JXGGcTxUSjYBkL7Z1DBqx/AySiE7dvdWyhrCIqoJTZDD0KpapbiFfnubzFIhInlMQ52FI46XDItObZbFTz2FB1xq1kwoaZTyE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709079756; c=relaxed/simple;
	bh=AvthNizxEnoDWVRmPuDgHVRQdoqUS9mVhOmEfBdR37A=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=OmyV3K1lyctfx/9Rbev8LiL3gGp85V1oHc3kHHU+vPtpCss3B6nlZalvYWetv6IKaZlv9ri3QGAMtJVqAhJhq3ISmh7fss8R0+FN0C3mhuCVeZhCi/1S4c7/k4dPPfh2WzdR54gKZQH35KHlxevz8Mdzi5F+I0Pp9AvzL+5H0Bs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=IV0ta4lB; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1709079753;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=LDn8Z9M8eJrtz+eFKCzeIbal9gKBwiSbIH7LzjGN38M=;
	b=IV0ta4lB5yXcGSbfCcLzRHK1j2y9DZTJUJq+ApxBuxbZA/4b8p50my+ODsB5I8lVpt479b
	f7QgDjhBS9BNx72hr9teCkKVdoSkvhpsbfZr0YKr4L+gca9iwZ54gY6KjjqaRl6BZG1dZc
	NJEsZv1A2glfdMrulL0Pmbu5Qx4SdIw=
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com
 [209.85.214.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-502-HhWAuP0rMWWN4OH7lFh9qA-1; Tue, 27 Feb 2024 19:22:28 -0500
X-MC-Unique: HhWAuP0rMWWN4OH7lFh9qA-1
Received: by mail-pl1-f199.google.com with SMTP id d9443c01a7336-1dc8e1a6011so34629665ad.2
        for <ceph-devel@vger.kernel.org>; Tue, 27 Feb 2024 16:22:28 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709079747; x=1709684547;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=LDn8Z9M8eJrtz+eFKCzeIbal9gKBwiSbIH7LzjGN38M=;
        b=lVRYcRlEJiPc1Y66s4WG2DVZI90bYYWMHeh3z9VidbnTxzIpt6lig0rw72LpnGCmfq
         41w7HdDnbpi4DgBhDFIfhbkpXu+C9Nk0zCEjROm7Frfog6mBmnMCi5fo9n5xNgd3lpzo
         SHsO2MLrncLcUrzPcgTjZ46RTv0wfzCCatvagr3KwJaFebeCWnQ0GQmQDfuj5nhEmo6O
         oBtrlS/H8Y6k/m0X9AoLj3ZOYMy9il46UiE9jYvQcKWanPYl6HnJgAd6txNo/UNnsWo5
         GKzlZd6Ski1fMSLEVKKFFoEm2YZKm2Og8n7o2FZLtF9VSyFwaY2wJmbtTRsJ242FvulG
         Z6EQ==
X-Gm-Message-State: AOJu0YxeZx6wC1z8GJmZVL89EGwAUY9yb0Y8R+UbPsX0E2WoVasUisQw
	2VUA5xOn16jhP//ZR7m/ti3Anmn2KcgFQaPIoG8IqRM4JwTZx10G8CwkVmVJD+2fHZ/fH8BT0U1
	kvB1bk1vdy8NxCJZKupM3lGc5bqIT/GPA4qilERUP+YUFXxJoBRbRgjrStrg=
X-Received: by 2002:a17:903:2310:b0:1dc:b30b:505b with SMTP id d16-20020a170903231000b001dcb30b505bmr6285261plh.31.1709079747568;
        Tue, 27 Feb 2024 16:22:27 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFBtiC921MlAIoF/dE03NPxSmmJt0UvO4VvyKbJ13eTEmRSbsYntdVwvLxoLHUuoW19wi9ZSw==
X-Received: by 2002:a17:903:2310:b0:1dc:b30b:505b with SMTP id d16-20020a170903231000b001dcb30b505bmr6285246plh.31.1709079747248;
        Tue, 27 Feb 2024 16:22:27 -0800 (PST)
Received: from [10.72.112.85] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id lh3-20020a170903290300b001dc95cded74sm2100852plb.233.2024.02.27.16.22.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 27 Feb 2024 16:22:26 -0800 (PST)
Message-ID: <2563efc0-38a8-45b4-b6fe-e0eac5d8c558@redhat.com>
Date: Wed, 28 Feb 2024 08:22:22 +0800
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 3/3] libceph: just wait for more data to be available
 on the socket
To: Luis Henriques <lhenriques@suse.de>
Cc: ceph-devel@vger.kernel.org, idryomov@gmail.com, jlayton@kernel.org,
 vshankar@redhat.com, mchangir@redhat.com
References: <20240125023920.1287555-1-xiubli@redhat.com>
 <20240125023920.1287555-4-xiubli@redhat.com> <871q8x4yac.fsf@suse.de>
Content-Language: en-US
From: Xiubo Li <xiubli@redhat.com>
In-Reply-To: <871q8x4yac.fsf@suse.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit


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

Thanks Luis to reporting this.

Let me try to have a look and fix it.

- Xiubo


> Cheers,


