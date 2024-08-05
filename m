Return-Path: <ceph-devel+bounces-1633-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 9A62594748A
	for <lists+ceph-devel@lfdr.de>; Mon,  5 Aug 2024 07:11:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BCB471C20C22
	for <lists+ceph-devel@lfdr.de>; Mon,  5 Aug 2024 05:11:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A82F813D52F;
	Mon,  5 Aug 2024 05:11:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="GPP/4HM6"
X-Original-To: ceph-devel@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CFEE13AA2A
	for <ceph-devel@vger.kernel.org>; Mon,  5 Aug 2024 05:11:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722834703; cv=none; b=XZpo6RvnK7wQrCo01epCgeqUv9eBopefiwMI/J3WkcixAvIi8pzNtZjT6csIfGZoKJ4PSqeqAZLOFu6BurlOhh7kAYkfqmpSonEyLbcE60QxS08O4BJF5WtVIpEFWhHeIQ83VTHgdzen1DPbeF6EM98a5lt3IzC8qW+kXGkngG4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722834703; c=relaxed/simple;
	bh=uhEzFv14+ygwaZ8YJmzw/d8haQW368jbl7aWdujaThY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ZBGFUNfOuJwRzaUnzzRIg3/IvKRprkDUcitm4XWjKlwJKdiBLBtMXnNIcsKsiL7DjCcXpExkcFw4vHHawfhDhDxEFDpNxSwUYRomGYsME3+0T1e1xoRTQsQo2O4rRQVuWsC/gvb5LPo6rMYK0BE8CYKryGJ1DD0VYWn7SOms2ek=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=GPP/4HM6; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1722834700;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ORKFR99mh6i19div5TbeDUIHUDACz1MP6sWyxECr6c0=;
	b=GPP/4HM6qsxeyqvWi5fVwAa+i8hrSGr7w4R+9Ts8kz918N5ytpxxAutNKxHlc26ayt1oC8
	pOKlmOJfuuJ0ox1MQgEk/+4KEBXBCvAUlF8jd1ycRzMa1Y0Av8z6spKCcG87aQe9l414P1
	1/rf0vmugToVajupEZH0bMnO3YkUhuQ=
Received: from mail-pf1-f199.google.com (mail-pf1-f199.google.com
 [209.85.210.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-547-3iq1sjskNZaLoHPpA54PPw-1; Mon, 05 Aug 2024 01:11:38 -0400
X-MC-Unique: 3iq1sjskNZaLoHPpA54PPw-1
Received: by mail-pf1-f199.google.com with SMTP id d2e1a72fcca58-70d1c28cd89so8560399b3a.1
        for <ceph-devel@vger.kernel.org>; Sun, 04 Aug 2024 22:11:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722834697; x=1723439497;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ORKFR99mh6i19div5TbeDUIHUDACz1MP6sWyxECr6c0=;
        b=oOtY7ysTAj+QtLEamDQb0O+9tm7KNMBktVV/DbOvtMyRaKrLhKraNhVwh3BHL59iL7
         qRrcflVU0d6fpxqRNiG8gUMMRaW7GrTwzqbOb37j77tDmGjYfzD2zo30GEb62eLVnmlF
         e+1pMaeT847O9e5hHsy0r2PM2Caiovh6oax4pKmpO31RGW4+gIfJYls8G/Zdw+1rfWEg
         7KKUnFpKZjOpdTMf+3yPoHy2fXhDwlYQujlg1ubvsBcZshgq8UugaAn76e+WAvEbMaOM
         Z2tyTxeBJEo0/mE2fvV8SQZAo4tW9awAwameWl2Oc690aj6D0KeEt1D/KywMrSQF5QLN
         BUtA==
X-Gm-Message-State: AOJu0YzYKqEnZannFxFKfRIfYz4Xdiku16TkplI8QOUH38fc9F9PqWRd
	4BmzAtx0NJRuylnwaD/ijJ7g5DMWSWE1O8zFPgySPezKMk9nwUDrjRI+kT6TKI9re07lwI1kOC+
	BqoWLtxBwRL6iTZvyxVJj+x++M4KZq5HUqXZYKmEJ41h+MDB7+wjh7ikGTY+XsjvVblo=
X-Received: by 2002:a05:6a00:9451:b0:70e:98e3:1aef with SMTP id d2e1a72fcca58-7106d084745mr8298462b3a.29.1722834697471;
        Sun, 04 Aug 2024 22:11:37 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFvHCXhH8dsIHLQNzoo3uscp8Dgu4ntqfoZu0YC8zySIMvSGPRmnzyM6a+fNO73dUlTVrCF7w==
X-Received: by 2002:a05:6a00:9451:b0:70e:98e3:1aef with SMTP id d2e1a72fcca58-7106d084745mr8298450b3a.29.1722834697025;
        Sun, 04 Aug 2024 22:11:37 -0700 (PDT)
Received: from [10.72.116.44] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7106ec4292fsm4666369b3a.73.2024.08.04.22.11.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 04 Aug 2024 22:11:36 -0700 (PDT)
Message-ID: <bcc43b79-1186-479f-8c27-9a652260106e@redhat.com>
Date: Mon, 5 Aug 2024 13:11:33 +0800
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: ceph_read_iter NULL pointer dereference
To: Luis Henriques <luis.henriques@linux.dev>
Cc: ceph-devel@vger.kernel.org
References: <87msluswte.fsf@linux.dev>
Content-Language: en-US
From: Xiubo Li <xiubli@redhat.com>
In-Reply-To: <87msluswte.fsf@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Hi Luis,

Thanks for your reporting, BTW, could this be reproduceable ?

This is also the first time I see this crash BUG.


The 'i_size == 0' could be easy to reproduce, please see my following 
debug logs:

++++++++++++++++++++++++++++

  ceph_read_iter: 0~1024 trying to get caps on 000000006a438277 
100000001f7.fffffffffffffffe
  try_get_cap_refs: 000000006a438277 100000001f7.fffffffffffffffe need 
Fr want Fc
  __ceph_caps_issued: 000000006a438277 100000001f7.fffffffffffffffe cap 
000000001a8b6d16 issued pAsLsXsFrw
  try_get_cap_refs: 000000006a438277 100000001f7.fffffffffffffffe have 
pAsLsXsFrw but not Fc (revoking -)
  try_get_cap_refs: 000000006a438277 100000001f7.fffffffffffffffe ret 1 
got Fr
  ceph_read_iter: sync 000000006a438277 100000001f7.fffffffffffffffe 
0~1024 got cap refs on Fr
  ceph_sync_read: on file 00000000e029b65e 0~400
  __ceph_sync_read: on inode 000000006a438277 
100000001f7.fffffffffffffffe 0~400
  __ceph_sync_read: orig 0~1024 reading 0~1024
  __ceph_sync_read: 0~1024 got -2 i_size 0
  __ceph_sync_read: result 0 retry_op 0
  ceph_read_iter: 000000006a438277 100000001f7.fffffffffffffffe dropping 
cap refs on Fr = 0
  __ceph_put_cap_refs: 000000006a438277 100000001f7.fffffffffffffffe had 
Fr last
  __ceph_caps_issued: 000000006a438277 100000001f7.fffffffffffffffe cap 
000000001a8b6d16 issued pAsLsXsFrw
+++++++++++++++++++++++++++++++++

I just created one empty file and then in Client.A open it for r/w, and 
then open the same file in Client.B and did a simple read.

Currently ceph kclient won't check the 'i_size' before sending out the 
sync read request to Rados, but will do it after it getting the contents 
back, As I remembered this logic comply to the "MIX" filelock state in MDS:

[LOCK_MIX]       = { 0,         false, LOCK_MIX,  0,    0,   REQ, ANY, 
0,   0,   0, CEPH_CAP_GRD|CEPH_CAP_GWR|CEPH_CAP_GLAZYIO,0,0,CEPH_CAP_GRD },

You can raise one ceph tracker for this.

Thanks

- Xiubo

On 8/3/24 00:39, Luis Henriques wrote:
> Hi Xiubo,
>
> I was wondering if you ever seen the BUG below.  I've debugged it a bit
> and the issue seems occurs here, while doing the SetPageUptodate():
>
> 		if (ret <= 0)
> 			left = 0;
> 		else if (off + ret > i_size)
> 			left = i_size - off;
> 		else
> 			left = ret;
> 		while (left > 0) {
> 			size_t plen, copied;
>
> 			plen = min_t(size_t, left, PAGE_SIZE - page_off);
> 			SetPageUptodate(pages[idx]);
> 			copied = copy_page_to_iter(pages[idx++],
> 						   page_off, plen, to);
> 			off += copied;
> 			left -= copied;
> 			page_off = 0;
> 			if (copied < plen) {
> 				ret = -EFAULT;
> 				break;
> 			}
> 		}
>
> So, the issue is that we have idx > num_pages.  And I'm almost sure that's
> because of i_size being '0' and 'left' ending up with a huge value.  But
> haven't managed to figure out yet why i_size is '0'.
>
> (Note: I'll be offline next week, but I'll continue looking into this the
> week after.  But I figured I should report the bug anyway, in case you've
> seen something similar.)
>
> Cheers,


