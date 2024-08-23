Return-Path: <ceph-devel+bounces-1729-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4942795C67C
	for <lists+ceph-devel@lfdr.de>; Fri, 23 Aug 2024 09:25:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 61273B21683
	for <lists+ceph-devel@lfdr.de>; Fri, 23 Aug 2024 07:25:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CDDD013B2A8;
	Fri, 23 Aug 2024 07:25:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="X0vCAbUe"
X-Original-To: ceph-devel@vger.kernel.org
Received: from out-181.mta1.migadu.com (out-181.mta1.migadu.com [95.215.58.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6390C12C484;
	Fri, 23 Aug 2024 07:25:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724397928; cv=none; b=XPi2XmpZe7OGW1zRB/Mlao9kVX7AmWH/SEebR2GZRKN4FEyJHcj8oSYSxCUxeNG24K/trkJIRHXVA3rxdKSZC7vxOkUL2pR4W86/NeCPDQiB+4GQpzWs1QCnTERkidBHlcnPgrw6ZQdz07SVcHfxo1waoZ9RS1EzrR/TZmBexac=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724397928; c=relaxed/simple;
	bh=l2borQ6BL7UJAeCJ8fjSxCZVWGtcnM5bweA18vjtZOw=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=NHQTP/ZCM5VJancj9g7Lz02Zn1YjC5Tb8QxJkzgrIvwULqJJA/iY/qjkcTCjE6DlTq/ppd+6oZX1/jVxqsLKWDNE9q6G2iBmpmcTqCSnSccf/mjFKQ9SafTYG1a1HWcizZBCQ/tWF2dfMwF3GLQv5Yq+5PxgMT3xKiiTi1Qk9B8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=X0vCAbUe; arc=none smtp.client-ip=95.215.58.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1724397923;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=o6nm/KD+x6LmewnNHCRvgZAlRU/7D6SolWNRFixGP90=;
	b=X0vCAbUe7cjqzn/KTpFLWQ/IA8WPDIZ1X3i7ZEd3K3LTEUBbB0ls4Ct+/5PoFDX9JtWfRJ
	RIXM7CfDJX2jfsTHW9UhderGbVrJ0xtfHRX96C/QENigg3AKyJ0joQ+ggTxKJFtfmZj3Yo
	qqKdluJtJhwBG3SSDD47hDiUxALM+Gw=
From: Luis Henriques <luis.henriques@linux.dev>
To: Xiubo Li <xiubli@redhat.com>
Cc: Ilya Dryomov <idryomov@gmail.com>,  ceph-devel@vger.kernel.org,
  linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH] ceph: fix out-of-bound array access when doing a
 file read
In-Reply-To: <0205e0b6-fad9-4519-adec-f1d1b30d9ef9@redhat.com> (Xiubo Li's
	message of "Fri, 23 Aug 2024 09:48:16 +0800")
References: <20240822150113.14274-1-luis.henriques@linux.dev>
	<0205e0b6-fad9-4519-adec-f1d1b30d9ef9@redhat.com>
Date: Fri, 23 Aug 2024 08:25:20 +0100
Message-ID: <87ikvrhfa7.fsf@linux.dev>
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Migadu-Flow: FLOW_OUT

On Fri, Aug 23 2024, Xiubo Li wrote:

> On 8/22/24 23:01, Luis Henriques (SUSE) wrote:
>> If, while doing a read, the inode is updated and the size is set to zero,
>> __ceph_sync_read() may not be able to handle it.  It is thus easy to hit=
 a
>> NULL pointer dereferrence by continuously reading a file while, on anoth=
er
>> client, we keep truncating and writing new data into it.
>>
>> This patch fixes the issue by adding extra checks to avoid integer overf=
lows
>> for the case of a zero size inode.  This will prevent the loop doing page
>> copies from running and thus accessing the pages[] array beyond num_page=
s.
>>
>> Link: https://tracker.ceph.com/issues/67524
>> Signed-off-by: Luis Henriques (SUSE) <luis.henriques@linux.dev>
>> ---
>> Hi!
>>
>> Please note that this patch is only lightly tested and, to be honest, I'm
>> not sure if this is the correct way to fix this bug.  For example, if the
>> inode size is 0, then maybe ceph_osdc_wait_request() should have returned
>> 0 and the problem would be solved.  However, it seems to be returning the
>> size of the reply message and that's not something easy to change.  Or m=
aybe
>> I'm just reading it wrong.  Anyway, this is just an RFC to see if there's
>> other ideas.
>>
>> Also, the tracker contains a simple testcase for crashing the client.
>>
>>   fs/ceph/file.c | 7 ++++---
>>   1 file changed, 4 insertions(+), 3 deletions(-)
>>
>> diff --git a/fs/ceph/file.c b/fs/ceph/file.c
>> index 4b8d59ebda00..dc23d5e5b11e 100644
>> --- a/fs/ceph/file.c
>> +++ b/fs/ceph/file.c
>> @@ -1200,9 +1200,9 @@ ssize_t __ceph_sync_read(struct inode *inode, loff=
_t *ki_pos,
>>   		}
>>     		idx =3D 0;
>> -		if (ret <=3D 0)
>> +		if ((ret <=3D 0) || (i_size =3D=3D 0))
>
> Hi Luis,
>
> This change looks incorrect to me.
>
> As I mentioned before when the 'IFILE' lock is in MIX state the 'Frw' cap=
s could
> be issued to multiple clients at the same time. Which means the file coul=
d be
> updated by another client and the local 'i_size' may haven't been changed=
 in
> time. So in this case the 'ret' will be larger than '0' and the 'i_size' =
could
> be '0'.
>
>
>>   			left =3D 0;
>> -		else if (off + ret > i_size)
>> +		else if ((i_size >=3D off) && (off + ret > i_size))
>
> And the 'off' also could equal to little than the 'i_size'.
>
> BTW, could you reproduce the crash issue ?

Yes, 100% reproducible :-)

See https://tracker.ceph.com/issues/67524

Cheers,
--=20
Lu=C3=ADs


>
> Thanks
>
> - Xiubo
>
>>   			left =3D i_size - off;
>>   		else
>>   			left =3D ret;
>> @@ -1210,6 +1210,7 @@ ssize_t __ceph_sync_read(struct inode *inode, loff=
_t *ki_pos,
>>   			size_t plen, copied;
>>     			plen =3D min_t(size_t, left, PAGE_SIZE - page_off);
>> +			WARN_ON_ONCE(idx >=3D num_pages);
>>   			SetPageUptodate(pages[idx]);
>>   			copied =3D copy_page_to_iter(pages[idx++],
>>   						   page_off, plen, to);
>> @@ -1234,7 +1235,7 @@ ssize_t __ceph_sync_read(struct inode *inode, loff=
_t *ki_pos,
>>   	}
>>     	if (ret > 0) {
>> -		if (off >=3D i_size) {
>> +		if ((i_size >=3D *ki_pos) && (off >=3D i_size)) {
>>   			*retry_op =3D CHECK_EOF;
>>   			ret =3D i_size - *ki_pos;
>>   			*ki_pos =3D i_size;
>>
>

