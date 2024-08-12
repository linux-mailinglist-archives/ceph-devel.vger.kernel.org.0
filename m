Return-Path: <ceph-devel+bounces-1655-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 6A99694E9E8
	for <lists+ceph-devel@lfdr.de>; Mon, 12 Aug 2024 11:36:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9E11D1C2153C
	for <lists+ceph-devel@lfdr.de>; Mon, 12 Aug 2024 09:36:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8B7C716132B;
	Mon, 12 Aug 2024 09:35:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="tNDtPsbd"
X-Original-To: ceph-devel@vger.kernel.org
Received: from out-185.mta0.migadu.com (out-185.mta0.migadu.com [91.218.175.185])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82A7D16D4D9
	for <ceph-devel@vger.kernel.org>; Mon, 12 Aug 2024 09:35:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.185
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723455359; cv=none; b=Wvu9/h+wAoVhH0Hk2XkTrgqNKAxNkaJU54GKHYyBqmCubbIioPSfbUEADc5qRrnI3eyemSzJajRsnTlHxY/gFOntfNxBGpWdiNNtnn+BvJrqrkUiiyxpvbwsQjcUro7Blcribnr7w/yNBfPwS+pCNa3fSh3r9Y8uiTwKlbajUHc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723455359; c=relaxed/simple;
	bh=YoTfLOPmmUGVMc4b0IgPpBwZ45tKk8gYBGfAMaAA4mg=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=T+kcLHKUKKz7BsEH+c4B8U8grcd1Idpr8F7ge/tnJtQXzJ5oVK4HKA/zZLN5bYcVocQYfMO/dvJWm5oos21Fv9nAaff3BRpx5mldL/+EBN9Haq2E/Y7FO/jWGszkvOUJSYJNtdlocytWcZKSNFp+lSLfWcUYc7CWHBwFccDFj4Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=tNDtPsbd; arc=none smtp.client-ip=91.218.175.185
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1723455354;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=wMVaPmrmq752rvKiEd42/RiX6UfIwyIDgRY6yPX73SU=;
	b=tNDtPsbdwhxwCx0AS1ZSwrw/F95USOyIhVTBluoXGsXQH6O4C4gvwpbS7g5tCxexX936ac
	Zj7x5CISxCT7/xD3ewK8kIWSrvMyp+pzehk/SOX6nnM+7+xERHfcUsMN7vvY/R5XtGzDpr
	hdqi35IfUngOPlNyK7x8t+IE55NOIcU=
From: Luis Henriques <luis.henriques@linux.dev>
To: Xiubo Li <xiubli@redhat.com>
Cc: ceph-devel@vger.kernel.org
Subject: Re: ceph_read_iter NULL pointer dereference
In-Reply-To: <bcc43b79-1186-479f-8c27-9a652260106e@redhat.com> (Xiubo Li's
	message of "Mon, 5 Aug 2024 13:11:33 +0800")
References: <87msluswte.fsf@linux.dev>
	<bcc43b79-1186-479f-8c27-9a652260106e@redhat.com>
Date: Mon, 12 Aug 2024 10:35:47 +0100
Message-ID: <877ccmcccs.fsf@linux.dev>
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Migadu-Flow: FLOW_OUT

On Mon, Aug 05 2024, Xiubo Li wrote:

> Hi Luis,
>
> Thanks for your reporting, BTW, could this be reproduceable ?
>
> This is also the first time I see this crash BUG.
>
>
> The 'i_size =3D=3D 0' could be easy to reproduce, please see my following=
 debug
> logs:
>
> ++++++++++++++++++++++++++++
>
> =C2=A0ceph_read_iter: 0~1024 trying to get caps on 000000006a438277
> 100000001f7.fffffffffffffffe
> =C2=A0try_get_cap_refs: 000000006a438277 100000001f7.fffffffffffffffe nee=
d Fr want Fc
> =C2=A0__ceph_caps_issued: 000000006a438277 100000001f7.fffffffffffffffe c=
ap
> 000000001a8b6d16 issued pAsLsXsFrw
> =C2=A0try_get_cap_refs: 000000006a438277 100000001f7.fffffffffffffffe hav=
e pAsLsXsFrw
> but not Fc (revoking -)
> =C2=A0try_get_cap_refs: 000000006a438277 100000001f7.fffffffffffffffe ret=
 1 got Fr
> =C2=A0ceph_read_iter: sync 000000006a438277 100000001f7.fffffffffffffffe =
0~1024 got
> cap refs on Fr
> =C2=A0ceph_sync_read: on file 00000000e029b65e 0~400
> =C2=A0__ceph_sync_read: on inode 000000006a438277 100000001f7.fffffffffff=
ffffe 0~400
> =C2=A0__ceph_sync_read: orig 0~1024 reading 0~1024
> =C2=A0__ceph_sync_read: 0~1024 got -2 i_size 0
> =C2=A0__ceph_sync_read: result 0 retry_op 0
> =C2=A0ceph_read_iter: 000000006a438277 100000001f7.fffffffffffffffe dropp=
ing cap refs
> on Fr =3D 0
> =C2=A0__ceph_put_cap_refs: 000000006a438277 100000001f7.fffffffffffffffe =
had Fr last
> =C2=A0__ceph_caps_issued: 000000006a438277 100000001f7.fffffffffffffffe c=
ap
> 000000001a8b6d16 issued pAsLsXsFrw
> +++++++++++++++++++++++++++++++++
>
> I just created one empty file and then in Client.A open it for r/w, and t=
hen
> open the same file in Client.B and did a simple read.
>
> Currently ceph kclient won't check the 'i_size' before sending out the sy=
nc read
> request to Rados, but will do it after it getting the contents back, As I
> remembered this logic comply to the "MIX" filelock state in MDS:
>
> [LOCK_MIX]=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 =3D { 0,=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 false, LOCK_MIX,=C2=A0 0,=C2=A0=C2=A0=C2=A0 =
0,=C2=A0=C2=A0 REQ, ANY, 0,=C2=A0=C2=A0 0,=C2=A0=C2=A0
> 0, CEPH_CAP_GRD|CEPH_CAP_GWR|CEPH_CAP_GLAZYIO,0,0,CEPH_CAP_GRD },
>
> You can raise one ceph tracker for this.

I'll do that, and thanks for analysis.  I'll need to catch-up with a few
things first after being a week offline, but I'll get back to this bug
shortly.

Cheers,
--=20
Lu=C3=ADs


>
> Thanks
>
> - Xiubo
>
> On 8/3/24 00:39, Luis Henriques wrote:
>> Hi Xiubo,
>>
>> I was wondering if you ever seen the BUG below.  I've debugged it a bit
>> and the issue seems occurs here, while doing the SetPageUptodate():
>>
>> 		if (ret <=3D 0)
>> 			left =3D 0;
>> 		else if (off + ret > i_size)
>> 			left =3D i_size - off;
>> 		else
>> 			left =3D ret;
>> 		while (left > 0) {
>> 			size_t plen, copied;
>>
>> 			plen =3D min_t(size_t, left, PAGE_SIZE - page_off);
>> 			SetPageUptodate(pages[idx]);
>> 			copied =3D copy_page_to_iter(pages[idx++],
>> 						   page_off, plen, to);
>> 			off +=3D copied;
>> 			left -=3D copied;
>> 			page_off =3D 0;
>> 			if (copied < plen) {
>> 				ret =3D -EFAULT;
>> 				break;
>> 			}
>> 		}
>>
>> So, the issue is that we have idx > num_pages.  And I'm almost sure that=
's
>> because of i_size being '0' and 'left' ending up with a huge value.  But
>> haven't managed to figure out yet why i_size is '0'.
>>
>> (Note: I'll be offline next week, but I'll continue looking into this the
>> week after.  But I figured I should report the bug anyway, in case you've
>> seen something similar.)
>>
>> Cheers,
>

