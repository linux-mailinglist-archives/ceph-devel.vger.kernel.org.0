Return-Path: <ceph-devel+bounces-880-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6DD8985B541
	for <lists+ceph-devel@lfdr.de>; Tue, 20 Feb 2024 09:32:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 79CFCB2195C
	for <lists+ceph-devel@lfdr.de>; Tue, 20 Feb 2024 08:32:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1F7615D8F0;
	Tue, 20 Feb 2024 08:31:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="LncHBc+j"
X-Original-To: ceph-devel@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E47855D75B
	for <ceph-devel@vger.kernel.org>; Tue, 20 Feb 2024 08:31:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708417893; cv=none; b=Ap8yfA+ytLbQUjAONEH8BGC6Wt2Qx6lIB1+qjxIDN53Ah5glmtmoihB8Mryvl+ViI3W7JMEbkr0CK81VJhJ6JQ3mSsP5MHR6ojLtY2o0ven5In+Qa651TqKQoutIfH1qyq3hxGkqe+uTsgOyM+pVZSiwFlvUTILheo1SIJKzNDc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708417893; c=relaxed/simple;
	bh=Jl4SO/ujMpW7bdTWMIClZkRwLGnkc2EzmiYObw3V6Tg=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=SjtCcU21Vha2RGnxbhLXDNt7PxcAoXXCzflHkzn7i2W5AoqdH469xDzLXbPE4WRFTJPCxl95Gwx4mrZDnG4xd727E+CzIq2Cttq3o4c1H0UpvV+T5v99ptopOfLYoKsHPgS0il9ppJ0GNgtijGpXmm1EArLuwyxgi/JVHOtuls0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=LncHBc+j; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1708417890;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=sBdCNLBFXTsyOgRKKc3RzxFREp0tTc9zMsnbBu4ITcI=;
	b=LncHBc+j3ad59686kLvMenEZcd4sApesp4SzGU9HyOJO1Cy2p9SwqK3BxLPYFEPT9u8Zro
	8y3kEBm1XhzuvfQpgOOAqwbpTezQgFMXvL3Z9+TG9G9txonYL7zxyDmIwDxbFbPpt1wkmW
	WiMXkFpOQpfHqXVsTUVRyFxh2dIeAgI=
Received: from mail-pf1-f200.google.com (mail-pf1-f200.google.com
 [209.85.210.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-320-Umq0d00KPSW5gR0Tym4FEw-1; Tue, 20 Feb 2024 03:31:29 -0500
X-MC-Unique: Umq0d00KPSW5gR0Tym4FEw-1
Received: by mail-pf1-f200.google.com with SMTP id d2e1a72fcca58-6e45d9ed898so1588538b3a.1
        for <ceph-devel@vger.kernel.org>; Tue, 20 Feb 2024 00:31:28 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708417888; x=1709022688;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=sBdCNLBFXTsyOgRKKc3RzxFREp0tTc9zMsnbBu4ITcI=;
        b=d1wb7lXbklNyJ5o2PUttDZPoHtMennyo8Cw0Enx3rVBgWv+UkTbPESPZOKRFoZws2b
         S/NK8AXY1VoK5J9zP++9CrwuzP6XIWVOntTui3E6stjOP59yVFetVIRuq+ysw09alf7K
         SUNMbmvNsIeGFTLbuZ0B6F69Lt6ZEQEuLKWj+o16wHtlUT9w2RVQRqug2Wg4zljeKCqY
         ZASaYL6U7yyox7DEtWZjxY1iso+eLTE/6mM9wGioVwuCaVSui1CnHtSn6vAiPx8A9oDf
         fSRXCYbHkyP1b/rmFaKqB/GmzXGTTra8M6l43C9y/h34D5piGVMi2POiY3nNhhpZW0D0
         pdrg==
X-Forwarded-Encrypted: i=1; AJvYcCW9nar2HO3VgZ7xEaaoicjZPn5AL5e30lSIOJviwaIgq93cohyjqtgy7XCIGro86gTp702fxnYPVczJddiIo1Bf3p6gbJGX+uIdKQ==
X-Gm-Message-State: AOJu0YyDNVC9Os7tbe73INeGhBDPjssEW/DhfoO24wR8kb0Kd0G2TkbB
	3ZQjgNIB7dxnOk81DMe71EC1gCmHfsScMdKZWxsoJiZ+c1grs2fzAbr423/K5rceLwPnLJTP2RG
	TNcVuHswEx6MOlqlHm0f+/TzhwFxcPlbVF+es/KtUtaOz/e6DdtrbGoA/Ut8=
X-Received: by 2002:a05:6a20:c90a:b0:19c:ad6b:e1c2 with SMTP id gx10-20020a056a20c90a00b0019cad6be1c2mr15156636pzb.12.1708417887910;
        Tue, 20 Feb 2024 00:31:27 -0800 (PST)
X-Google-Smtp-Source: AGHT+IE2JKdPEFtW2o9ACeReo+crK4J2G1FRnOilPv84k749nL0AD9snF0tCQ1twvqFoUTZ0UuCrzw==
X-Received: by 2002:a05:6a20:c90a:b0:19c:ad6b:e1c2 with SMTP id gx10-20020a056a20c90a00b0019cad6be1c2mr15156620pzb.12.1708417887487;
        Tue, 20 Feb 2024 00:31:27 -0800 (PST)
Received: from [10.72.112.28] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id x16-20020aa784d0000000b006e13a5ab1e5sm4093840pfn.73.2024.02.20.00.31.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 20 Feb 2024 00:31:27 -0800 (PST)
Message-ID: <49c73a1b-19d5-45b6-8703-1e4f1355d81a@redhat.com>
Date: Tue, 20 Feb 2024 16:31:23 +0800
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: Read operation gets EOF return when there is multi-client
 read/write after linux 5.16-rc1
To: =?UTF-8?B?RnJhbmsgSHNpYW8g6JWt5rOV5a6j?= <frankhsiao@qnap.com>,
 "ceph-devel@vger.kernel.org" <ceph-devel@vger.kernel.org>
References: <SEZPR04MB697268A8E75E22B0A0F10129B77B2@SEZPR04MB6972.apcprd04.prod.outlook.com>
Content-Language: en-US
From: Xiubo Li <xiubli@redhat.com>
In-Reply-To: <SEZPR04MB697268A8E75E22B0A0F10129B77B2@SEZPR04MB6972.apcprd04.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit


On 1/24/24 11:25, Frank Hsiao 蕭法宣 wrote:
> When multiple ceph kernel clients perform read/write on the same file, the read
> operation(ceph_sync_read) returns EOF(ret = 0) even though the file has been
> written by another client.
>
> My envs use Ceph quincy(v17.2.6) and mount cephfs by ceph kernel client. For the
> client side, I use Samba(v4.18.8) to export the folder as smb share and test it
> with smbtorture. The test case is smb2.rw.rw1 with the following failure
> message:
>
> test: samba4.smb2.rw.rw1
> Checking data integrity over 10 ops
> read failed(NT_STATUS_END_OF_FILE)
> failure: samba4.smb2.rw.rw1 [
> Exception: read 0, expected 440
> ]
>
> After some testing, I figured out that the failure only happens when I have
> linux kernel version>=5.16-rc1, specifically after commit
> c3d8e0b5de487a7c462781745bc17694a4266696. Kernel logs as below(on 5.16-rc1):
>
>
> [Wed Jan 10 09:44:56 2024] [153221] ceph_read_iter:1559: ceph:  aio_sync_read
> 00000000789dccee 100000010ef.fffffffffffffffe 0~440 got cap refs on Fr
> [Wed Jan 10 09:44:56 2024] [153221] ceph_sync_read:852: ceph:  sync_read on file
> 00000000d9e861fb 0~440
> [Wed Jan 10 09:44:56 2024] [153221] ceph_sync_read:913: ceph:  sync_read 0~440 got 440 i_size 0
> [Wed Jan 10 09:44:56 2024] [153221] ceph_sync_read:966: ceph:  sync_read result 0 retry_op 2
>
> ...
>
> [Wed Jan 10 09:44:57 2024] [153221] ceph_read_iter:1559: ceph:  aio_sync_read
> 00000000789dccee 100000010ef.fffffffffffffffe 0~440 got cap refs on Fr
> [Wed Jan 10 09:44:57 2024] [153221] ceph_sync_read:852: ceph:  sync_read on file
> 00000000d9e861fb 0~0

Locally I tried to reproduce it but failed, the following is my logs:

<7>[ 3524.212187] ceph: [49172eb5-aa13-4408-956b-e10a6d02b0f6 4228] 
ceph_read_iter: sync 00000000b6ea7952 10000000000.fffffffffffffffe 
0~8192 got cap refs on Fr
<7>[ 3524.212194] ceph: [49172eb5-aa13-4408-956b-e10a6d02b0f6 4228] 
ceph_sync_read: on file 00000000a06cac30 0~2000
<7>[ 3524.212201] ceph: [49172eb5-aa13-4408-956b-e10a6d02b0f6 4228] 
__ceph_sync_read: on inode 00000000b6ea7952 10000000000.fffffffffffffffe 
0~2000
<7>[ 3524.212209] ceph: [49172eb5-aa13-4408-956b-e10a6d02b0f6 4228] 
__ceph_sync_read: orig 0~8192 reading 0~8192
<7>[ 3524.213008] ceph: [49172eb5-aa13-4408-956b-e10a6d02b0f6 4228] 
__ceph_sync_read: 0~8192 got 97 i_size 90
<7>[ 3524.213100] ceph: [49172eb5-aa13-4408-956b-e10a6d02b0f6 4228] 
__ceph_sync_read: result 90 retry_op 2
<7>[ 3524.213107] ceph: [49172eb5-aa13-4408-956b-e10a6d02b0f6 4228] 
ceph_read_iter: 00000000b6ea7952 10000000000.fffffffffffffffe dropping 
cap refs on Fr = 90
...

<7>[ 3524.213151] ceph: [49172eb5-aa13-4408-956b-e10a6d02b0f6 4228] 
__ceph_do_getattr: inode 00000000b6ea7952 10000000000.fffffffffffffffe 
mask Fsr mode 0100644
<7>[ 3524.213159] ceph: [49172eb5-aa13-4408-956b-e10a6d02b0f6 4228] 
__ceph_caps_issued: 00000000b6ea7952 10000000000.fffffffffffffffe cap 
0000000067201935 issued pAsLsXsFr
<7>[ 3524.213193] ceph: [49172eb5-aa13-4408-956b-e10a6d02b0f6 4228] 
ceph_mdsc_do_request: do_request on 0000000008917ba4
<7>[ 3524.213201] ceph: [49172eb5-aa13-4408-956b-e10a6d02b0f6 4228] 
ceph_mdsc_submit_request: submit_request on 0000000008917ba4 for inode 
0000000000000000
...

<7>[ 3524.345996] ceph: [49172eb5-aa13-4408-956b-e10a6d02b0f6 4228] 
ceph_fill_inode: 00000000b6ea7952 10000000000.fffffffffffffffe mode 
0100644 uid.gid 1000.1000
<7>[ 3524.346004] ceph: [49172eb5-aa13-4408-956b-e10a6d02b0f6 4228] 
ceph_fill_file_size: size 90 -> 97
...

<7>[ 3524.346235] ceph: [49172eb5-aa13-4408-956b-e10a6d02b0f6 4228] 
__ceph_do_getattr: result=0
<7>[ 3524.346236] ceph: [49172eb5-aa13-4408-956b-e10a6d02b0f6 4228] 
ceph_check_caps:  mds0 cap 0000000067201935 used - issued pAsLsXsFr 
implemented pAsLsXsFscr revoking Fsc
<7>[ 3524.346241] ceph: [49172eb5-aa13-4408-956b-e10a6d02b0f6 4228] 
ceph_read_iter: hit hole, ppos 90 < size 97, reading more
...
<7>[ 3524.346307] ceph: [49172eb5-aa13-4408-956b-e10a6d02b0f6 4228] 
__ceph_sync_read: on inode 00000000b6ea7952 10000000000.fffffffffffffffe 
5a~1f9f
<7>[ 3524.346313] ceph: [49172eb5-aa13-4408-956b-e10a6d02b0f6 4228] 
__ceph_sync_read: orig 90~8095 reading 90~8095
...

<7>[ 3524.370645] ceph: [49172eb5-aa13-4408-956b-e10a6d02b0f6 4228] 
__ceph_sync_read: 90~8095 got 7 i_size 97
<7>[ 3524.370776] ceph: [49172eb5-aa13-4408-956b-e10a6d02b0f6 4228] 
__ceph_sync_read: result 7 retry_op 2

As you can see that the first time it will read only 90 bytes, actually 
the file size is 97. Then the 'ceph_read_iter()' will call 
'__ceph_do_getattr()' to get the real i_size from MDS, and finally it 
will retry to read more and read the last 7 bytes.

Locally my test succeeded.

Could you upload more detail debug logs ? Have you seen the 
'ceph_read_iter()' was retried ?

Thanks

- Xiubo




>
> The logs indicate that:
> 1. ceph_sync_read may read data but i_size is obsolete in simultaneous rw situation
> 2. The commit in 5.16-rc1 cap ret to i_size and set retry_op = CHECK_EOF
> 3. When retrying, ceph_sync_read gets len=0 since iov count has modified in
> copy_page_to_iter
> 4. ceph_read_iter return 0
>
> I'm not sure if my understanding is correct. As a reference, here is my simple
> patch and I need more comments. The purpose of the patch is to prevent
> sync read handler from doing copy page when ret > i_size.
>
> Thanks.
>
>
> diff --git a/fs/ceph/file.c b/fs/ceph/file.c
> index 220a41831b46..5897f52ee998 100644
> --- a/fs/ceph/file.c
> +++ b/fs/ceph/file.c
> @@ -926,6 +926,9 @@ static ssize_t ceph_sync_read(struct kiocb *iocb, struct iov_iter *to,
>
>                  idx = 0;
>                  left = ret > 0 ? ret : 0;
> +               if (left > i_size) {
> +                       left = i_size;
> +               }
>                  while (left > 0) {
>                          size_t len, copied;
>                          page_off = off & ~PAGE_MASK;
> @@ -952,7 +955,7 @@ static ssize_t ceph_sync_read(struct kiocb *iocb, struct iov_iter *to,
>                          break;
>          }
>
> -       if (off > iocb->ki_pos) {
> +       if (off > iocb->ki_pos || i_size == 0) {
>                  if (off >= i_size) {
>                          *retry_op = CHECK_EOF;
>                          ret = i_size - iocb->ki_pos;


