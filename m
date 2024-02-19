Return-Path: <ceph-devel+bounces-876-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DC30E859A9D
	for <lists+ceph-devel@lfdr.de>; Mon, 19 Feb 2024 03:09:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5A660281364
	for <lists+ceph-devel@lfdr.de>; Mon, 19 Feb 2024 02:09:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4A1571865;
	Mon, 19 Feb 2024 02:09:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="TVnQEjJC"
X-Original-To: ceph-devel@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13C1FEDD
	for <ceph-devel@vger.kernel.org>; Mon, 19 Feb 2024 02:09:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708308549; cv=none; b=su2QwGfwXyeo1LaasIywZS4/tinF/KHVzGa06ycJqNryHvjovPRyLAf+/yusx5e4XelfnN34dDs9GZgxko0Ej/EzNzc84zieKEST705Lj6V/qzib7hvQk+vp9kfgvK4NpuMgibpqcjgif1K4pwaRorOCx+4fkUNSGo4laU/QN+c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708308549; c=relaxed/simple;
	bh=N39DeFxIxdvE4vcX9EqH0EPVv9WJwqN/fQY/bLGDOyU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=n3vd98tQWYZ0/yCnI7YjA5ClDDXYidWlRIbQiKqjiqpo+CYriSBeGZMpMd7uXg9iHYovMfHQRRu3pwhJvuknR5wVpf0wqe5dVF2VHVKP1iA7cDkB0Tkt6aplE9rH04bSTT3RFIKhFpKAk3/V1t2aGG0ay+q2fNZdeg+90oGjLXQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=TVnQEjJC; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1708308545;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=j+9jn5ERRw/ZCsmVBr6fiNQwovCsTDevK/jubQPwadk=;
	b=TVnQEjJC2/iXjfXTVwiuLgshOPP39u8uiZRFT8YX3Y4plzTGKYl16TzlZZcbIF0kQd//0C
	RaflQFiuMFCWQIOCJGk4gPc8as2xEZ6RJafiWMke14EVOo/BesEo++S2LVpuBEvBCs9FdK
	COhRdxown2Fx6ePe5GlrEpAQ6oaF1zI=
Received: from mail-pg1-f197.google.com (mail-pg1-f197.google.com
 [209.85.215.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-511-HFNtMAL6OHCRsIXGZkHpaA-1; Sun, 18 Feb 2024 21:09:03 -0500
X-MC-Unique: HFNtMAL6OHCRsIXGZkHpaA-1
Received: by mail-pg1-f197.google.com with SMTP id 41be03b00d2f7-5dcab65d604so2880069a12.3
        for <ceph-devel@vger.kernel.org>; Sun, 18 Feb 2024 18:09:03 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708308542; x=1708913342;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=j+9jn5ERRw/ZCsmVBr6fiNQwovCsTDevK/jubQPwadk=;
        b=BZK1/lm5yx+ykj/ZxK8G2o8UfAMD9WSBAPVtpzyuRyFnGaK/ZyiBVYac1GvSaLVj2q
         ex9hpLLZptlGotdL8w/gmm98yJnLrzlPbPT6OIaI5Xu0SnWJvY5lb7SIdMfigE+mv55b
         9LTawey3VMtb5HoGj4wHESB2BqkPbPRPqSJh5BiWfj2fj7gj4w3T1GnFTuhTr7orbQHa
         ZTQzddNT1UttNhYccp/u1pzUEa1kGnBvgwbEXHznoicR/i10c0cXoiMPlsSCC+IHrfxw
         qcE8lzvYeWvO/4E1WXCG9V2a+s84LsQO+J7BZUKF2vANv0SGEKqBb6+Li3IEID2AoOeX
         d1UA==
X-Forwarded-Encrypted: i=1; AJvYcCXYyUq96fccp++Ye7uSJwiuIqfgmkQR4zHd1OxFSY49z/B/OY9D2kEFKSpIEjmEI3wNXoEqxrUMUXJamWbS4w0aXoSyK16usNZRVg==
X-Gm-Message-State: AOJu0YwK2j3J9VIOBDfhuZonW6yRbYa+UmmBtnw4AU9vYvfs6Lghcj1T
	N826eBIgiR3sPg1zLddqOub1y3JPXMH/H1+az1mZfcsQMAhSO6/zgjCHvo51hNu+65wPjxVO84M
	Dd591UruOFaITbfxLBx2Wr9lEHsxWg6EXWYA11W7XIYAJlKrhaXDA+iKfaA5RozbgF6S0Rg==
X-Received: by 2002:a05:6a21:1394:b0:1a0:9b59:c167 with SMTP id oa20-20020a056a21139400b001a09b59c167mr4446226pzb.35.1708308542542;
        Sun, 18 Feb 2024 18:09:02 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEFCLS9SWCQt6GDTmh6Tepf0hHm+hjjBrfg3bNKx0/rcL52+wGMuHSIJZBuSx/ugsqtA+pH0Q==
X-Received: by 2002:a05:6a21:1394:b0:1a0:9b59:c167 with SMTP id oa20-20020a056a21139400b001a09b59c167mr4446214pzb.35.1708308542198;
        Sun, 18 Feb 2024 18:09:02 -0800 (PST)
Received: from [10.72.112.169] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id x3-20020a170902fe8300b001db47423bdfsm3090336plm.97.2024.02.18.18.09.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 18 Feb 2024 18:09:01 -0800 (PST)
Message-ID: <b44f1d8f-b6cc-44f2-ab30-217a8a918686@redhat.com>
Date: Mon, 19 Feb 2024 10:08:57 +0800
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: =?UTF-8?B?UmU6IOWbnuimhjogUmVhZCBvcGVyYXRpb24gZ2V0cyBFT0YgcmV0dXJu?=
 =?UTF-8?Q?_when_there_is_multi-client_read/write_after_linux_5=2E16-rc1?=
To: =?UTF-8?B?RnJhbmsgSHNpYW8g6JWt5rOV5a6j?= <frankhsiao@qnap.com>,
 "ceph-devel@vger.kernel.org" <ceph-devel@vger.kernel.org>
Cc: "jlayton@kernel.org" <jlayton@kernel.org>,
 "idryomov@gmail.com" <idryomov@gmail.com>
References: <SEZPR04MB697268A8E75E22B0A0F10129B77B2@SEZPR04MB6972.apcprd04.prod.outlook.com>
 <SEZPR04MB697298071AB99C3D1A63210EB74C2@SEZPR04MB6972.apcprd04.prod.outlook.com>
Content-Language: en-US
From: Xiubo Li <xiubli@redhat.com>
In-Reply-To: <SEZPR04MB697298071AB99C3D1A63210EB74C2@SEZPR04MB6972.apcprd04.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Hi

Just back from PTO and holiday.

I will check it today or tomorrow.

Thanks

- Xiubo

On 2/16/24 12:24, Frank Hsiao 蕭法宣 wrote:
> Hi, it is a friendly ping, thanks.
>
> ________________________________________
> 寄件者: Frank Hsiao 蕭法宣 <frankhsiao@qnap.com>
> 寄件日期: 2024年1月24日 上午 11:25
> 收件者: ceph-devel@vger.kernel.org
> 主旨: Read operation gets EOF return when there is multi-client read/write after linux 5.16-rc1
>
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
> [Wed Jan 10 09:44:56 2024] [153221] ceph_read_iter:1559: ceph:  aio_sync_read
> 00000000789dccee 100000010ef.fffffffffffffffe 0~440 got cap refs on Fr
> [Wed Jan 10 09:44:56 2024] [153221] ceph_sync_read:852: ceph:  sync_read on file
> 00000000d9e861fb 0~440
> [Wed Jan 10 09:44:56 2024] [153221] ceph_sync_read:913: ceph:  sync_read 0~440 got 440 i_size 0
> [Wed Jan 10 09:44:56 2024] [153221] ceph_sync_read:966: ceph:  sync_read result 0 retry_op 2
>
> ...
>
> [Wed Jan 10 09:44:57 2024] [153221] ceph_read_iter:1559: ceph:  aio_sync_read
> 00000000789dccee 100000010ef.fffffffffffffffe 0~440 got cap refs on Fr
> [Wed Jan 10 09:44:57 2024] [153221] ceph_sync_read:852: ceph:  sync_read on file
> 00000000d9e861fb 0~0
>
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
>                  idx = 0;
>                  left = ret > 0 ? ret : 0;
> +               if (left > i_size) {
> +                       left = i_size;
> +               }
>                  while (left > 0) {
>                          size_t len, copied;
>                          page_off = off & ~PAGE_MASK;
> @@ -952,7 +955,7 @@ static ssize_t ceph_sync_read(struct kiocb *iocb, struct iov_iter *to,
>                          break;
>          }
>
> -       if (off > iocb->ki_pos) {
> +       if (off > iocb->ki_pos || i_size == 0) {
>                  if (off >= i_size) {
>                          *retry_op = CHECK_EOF;
>                          ret = i_size - iocb->ki_pos;


