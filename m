Return-Path: <ceph-devel+bounces-886-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 7388485CD84
	for <lists+ceph-devel@lfdr.de>; Wed, 21 Feb 2024 02:42:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D983F1F22DF1
	for <lists+ceph-devel@lfdr.de>; Wed, 21 Feb 2024 01:42:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6B9264428;
	Wed, 21 Feb 2024 01:42:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="PbF5m6HV"
X-Original-To: ceph-devel@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C0E217D5
	for <ceph-devel@vger.kernel.org>; Wed, 21 Feb 2024 01:42:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708479727; cv=none; b=VWXSAqCJrfCks/0hnmIyqscLz1m7R+tu6gRPUMcN20lJLSRmUYsr4eiuMzVY59G4AKugH+wCdtKZyr8cLOS1DOL2sofcKU2NFpjiCXcV8YzN/T2bY8sXh00E+f+FLU8a1EDUcfIAkw4GxiyVjBs89Um0BiKP3TrpGYmktvWT7as=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708479727; c=relaxed/simple;
	bh=PG6qREaP2ERyyxDF0nlTx6DWyPAj69xSzgVZ9uL9Grs=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=NNCiW26yYWw5zMaCqD3dQqpsJ+BGBvCf82OqoYEkX9SSytK/0I0XPD9AzNkRHGTZdJ4VL4VK3SileM2lPkSfh55IvGc/2/Kpu3dLG5LhuHIFtH3DO7W2wRbjhbYPGrvtEp0mYUCCgl7we3sMDd+N4XIhIEHUS8Lbzqmcdgplgec=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=PbF5m6HV; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1708479723;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=4Wx9E9xJ3P/LrYDM6scIbRtWnMIrWMOnDqWsdT9TdYQ=;
	b=PbF5m6HVzcHUWIhLPn/W4SzH7CcQueVFGJwZK9y4+C0GT98QRP9dA+XeaDVRRk8JYTKmrU
	uLS/YEx3frxjVkK/lXflkAuNZhyWDFXPWhRRu2gLqebBahPVngsfOORwxV1hBeMsBP8wWA
	RehaBrgLP4Z/agaFGgpbgAYeyRKFTck=
Received: from mail-pf1-f199.google.com (mail-pf1-f199.google.com
 [209.85.210.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-636-nwUP8V-cPDWruIoQMLlK3w-1; Tue, 20 Feb 2024 20:42:02 -0500
X-MC-Unique: nwUP8V-cPDWruIoQMLlK3w-1
Received: by mail-pf1-f199.google.com with SMTP id d2e1a72fcca58-6e469a6eeb8so176670b3a.3
        for <ceph-devel@vger.kernel.org>; Tue, 20 Feb 2024 17:42:02 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708479721; x=1709084521;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=4Wx9E9xJ3P/LrYDM6scIbRtWnMIrWMOnDqWsdT9TdYQ=;
        b=BXxPuavA8rhu5gIneerzqT9uQD1bZCq5JvxuC1pXwVslss9tpYP8s91QTuYLcFfsQ/
         8/IPuLynlu5KZ2fBX/dUWsthQ7LeVHoZVds4VRZ/p9I65IAiGBTLp1IpNHc8HKORYU74
         YTJsTzrF8rQTuv+NSDL52UdS/PHkz7gnWv+GDKG7O7uIBrACFYG7/jzSoc9+k70RUp47
         fzB9SIXMEBAEHllQL8Gy00aihBDV77tT3apiDK1N0anglmiaOgrKqiC+1Q5aab7Jh2GS
         FgIol9EJHA1KqrLt5Wj9plsOZe4ffAL+dYaS3Knc4V5cmcemk/9RGBtVDlPpRmo1onrs
         U/Fg==
X-Forwarded-Encrypted: i=1; AJvYcCWh3iqU0usW3boZ5tL3JHOMDd17YbgdMdIabh25YlxGY4w2t5dIeAmyf0RZ7enryFMmYTUa9mFQ7ynxzBOk9rZ3qDuRzq0Rc1zpdA==
X-Gm-Message-State: AOJu0YztVc+mTiyuXGjGKhXa56+YfCgN1Iq7f+egUdlfhjsmVdO6WDUL
	zCbaepaFYF8RXuTnkgAwSUmaHGKFQU34LYbgwkvtHcnDmWo6bAZyX9VfszUmTYHDsQdpQpcAeBU
	t1zbAdmmueAS4WY9BdnTVPvf1quwuMh7IYlbdiID19brLIyBBANvDYSzxt86zdFu7H0QTm/Xo
X-Received: by 2002:a05:6a00:a29:b0:6e0:9a9b:b620 with SMTP id p41-20020a056a000a2900b006e09a9bb620mr23694464pfh.27.1708479720728;
        Tue, 20 Feb 2024 17:42:00 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEohcuEAIVFKhfgZsbdAX9tP3B9ZXHsBNb2O3A79UfTaKPgRR6hQss3uu1TTb9Dp6dm17VTAA==
X-Received: by 2002:a05:6a00:a29:b0:6e0:9a9b:b620 with SMTP id p41-20020a056a000a2900b006e09a9bb620mr23694446pfh.27.1708479720289;
        Tue, 20 Feb 2024 17:42:00 -0800 (PST)
Received: from [10.72.112.141] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id y17-20020aa78551000000b006e0e66369e5sm7588692pfn.66.2024.02.20.17.41.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 20 Feb 2024 17:41:59 -0800 (PST)
Message-ID: <8c967388-f13f-4fea-927d-a41be0cbafbf@redhat.com>
Date: Wed, 21 Feb 2024 09:41:55 +0800
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: Read operation gets EOF return when there is multi-client
 read/write after linux 5.16-rc1
Content-Language: en-US
To: =?UTF-8?B?RnJhbmsgSHNpYW8g6JWt5rOV5a6j?= <frankhsiao@qnap.com>,
 "ceph-devel@vger.kernel.org" <ceph-devel@vger.kernel.org>
References: <SEZPR04MB697268A8E75E22B0A0F10129B77B2@SEZPR04MB6972.apcprd04.prod.outlook.com>
From: Xiubo Li <xiubli@redhat.com>
In-Reply-To: <SEZPR04MB697268A8E75E22B0A0F10129B77B2@SEZPR04MB6972.apcprd04.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Hi Rrank,

Thanks for your debug logs. I just improved your patch, could you have a 
try ?

diff --git a/fs/ceph/file.c b/fs/ceph/file.c
index 06fdb3d05095..75bd46d0291b 100644
--- a/fs/ceph/file.c
+++ b/fs/ceph/file.c
@@ -1194,7 +1194,7 @@ ssize_t __ceph_sync_read(struct inode *inode, 
loff_t *ki_pos,
                 }

                 idx = 0;
-               left = ret > 0 ? ret : 0;
+               left = ret > 0 ? umin(ret, i_size) : 0;
                 while (left > 0) {
                         size_t plen, copied;

@@ -1223,15 +1223,13 @@ ssize_t __ceph_sync_read(struct inode *inode, 
loff_t *ki_pos,
         }

         if (ret > 0) {
-               if (off > *ki_pos) {
-                       if (off >= i_size) {
-                               *retry_op = CHECK_EOF;
-                               ret = i_size - *ki_pos;
-                               *ki_pos = i_size;
-                       } else {
-                               ret = off - *ki_pos;
-                               *ki_pos = off;
-                       }
+               if (off >= i_size) {
+                       *retry_op = CHECK_EOF;
+                       ret = i_size - *ki_pos;
+                       *ki_pos = i_size;
+               } else {
+                       ret = off - *ki_pos;
+                       *ki_pos = off;
                 }

                 if (last_objver)


- Xiubo


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


