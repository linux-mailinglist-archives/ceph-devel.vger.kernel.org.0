Return-Path: <ceph-devel+bounces-1857-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 3232398A899
	for <lists+ceph-devel@lfdr.de>; Mon, 30 Sep 2024 17:33:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D07531F248BB
	for <lists+ceph-devel@lfdr.de>; Mon, 30 Sep 2024 15:33:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 49813193428;
	Mon, 30 Sep 2024 15:30:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="UuWfg+PA"
X-Original-To: ceph-devel@vger.kernel.org
Received: from out-176.mta0.migadu.com (out-176.mta0.migadu.com [91.218.175.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AB3D1925BB
	for <ceph-devel@vger.kernel.org>; Mon, 30 Sep 2024 15:30:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727710255; cv=none; b=d1mac/FX5U1o24CvKWHA1RpVfrLp0RdZxLl2YRi4Odwl0MBUwf73wRW3bW6WETDUaRzpm93Nhl99O0Ws+LjZ5z8Dr8dFE85LYq9qQhHvPe2XGLxNrWTjYOMGY2Ak3+NnevLr4QcstN5A57uznr4WxdCnU5691HAOd6+xpmQ1Wxc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727710255; c=relaxed/simple;
	bh=UBZJi88c5WKqoXkCKLKTqd+oD8CxUv1ODcdaCjvH+YQ=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=CP/M42ZER9lHysEFza2YvGo5SF88iih9sqXgYwfLC6ykfqmKnGo9UuIwx4PgS63NeYudc21p3CPxGhydKIacod+s0/+Li4IewRUQN5XGwuokMYb49poYHlKFFhnSR853Tvwpj5QwB+Z/GAS/3oIfqdx7bhMWfMxCSQV7m8RF1H8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=UuWfg+PA; arc=none smtp.client-ip=91.218.175.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1727710250;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=D3I8jrCALn3p5oHKvSDm0sbViBwy5IJ7FtH+Jn5AeyM=;
	b=UuWfg+PA70v/tO+Ry8K9HQGPAbp6+ZUg3Pw9ii8dtGFGKh3XIWmsLRxPZECk6c7PbSzPcu
	KI+R/Kue+mkCwyBwifjwpxo0Q+bQjpd8CopTD2xa0gpKdgzfoYU9O09lSgbkbwB/9mAXoU
	8A2l5AOlcpDg7uGwMoJppH08FGJzrg4=
From: Luis Henriques <luis.henriques@linux.dev>
To: Xiubo Li <xiubli@redhat.com>
Cc: Ilya Dryomov <idryomov@gmail.com>,  ceph-devel@vger.kernel.org,
  linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v2] ceph: ceph: fix out-of-bound array access when
 doing a file read
In-Reply-To: <bb7c03b3-f922-4146-8644-bd9889e1bf86@redhat.com> (Xiubo Li's
	message of "Fri, 6 Sep 2024 20:48:13 +0800")
References: <20240905135700.16394-1-luis.henriques@linux.dev>
	<e1c50195-07a9-4634-be01-71f4567daa54@redhat.com>
	<87plphm32k.fsf@linux.dev>
	<bb7c03b3-f922-4146-8644-bd9889e1bf86@redhat.com>
Date: Mon, 30 Sep 2024 16:30:40 +0100
Message-ID: <87ldz9ma5b.fsf@linux.dev>
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Migadu-Flow: FLOW_OUT

On Fri, Sep 06 2024, Xiubo Li wrote:

> On 9/6/24 19:30, Luis Henriques wrote:
>> On Fri, Sep 06 2024, Xiubo Li wrote:
>>
>>> On 9/5/24 21:57, Luis Henriques (SUSE) wrote:
>>>> __ceph_sync_read() does not correctly handle reads when the inode size=
 is
>>>> zero.  It is easy to hit a NULL pointer dereference by continuously re=
ading
>>>> a file while, on another client, we keep truncating and writing new da=
ta
>>>> into it.
>>>>
>>>> The NULL pointer dereference happens when the inode size is zero but t=
he
>>>> read op returns some data (ceph_osdc_wait_request()).  This will lead =
to
>>>> 'left' being set to a huge value due to the overflow in:
>>>>
>>>> 	left =3D i_size - off;
>>>>
>>>> and, in the loop that follows, the pages[] array being accessed beyond
>>>> num_pages.
>>>>
>>>> This patch fixes the issue simply by checking the inode size and retur=
ning
>>>> if it is zero, even if there was data from the read op.
>>>>
>>>> Link: https://tracker.ceph.com/issues/67524
>>>> Fixes: 1065da21e5df ("ceph: stop copying to iter at EOF on sync reads")
>>>> Signed-off-by: Luis Henriques (SUSE) <luis.henriques@linux.dev>
>>>> ---
>>>>    fs/ceph/file.c | 5 ++++-
>>>>    1 file changed, 4 insertions(+), 1 deletion(-)
>>>>
>>>> diff --git a/fs/ceph/file.c b/fs/ceph/file.c
>>>> index 4b8d59ebda00..41d4eac128bb 100644
>>>> --- a/fs/ceph/file.c
>>>> +++ b/fs/ceph/file.c
>>>> @@ -1066,7 +1066,7 @@ ssize_t __ceph_sync_read(struct inode *inode, lo=
ff_t *ki_pos,
>>>>    	if (ceph_inode_is_shutdown(inode))
>>>>    		return -EIO;
>>>>    -	if (!len)
>>>> +	if (!len || !i_size)
>>>>    		return 0;
>>>>    	/*
>>>>    	 * flush any page cache pages in this range.  this
>>>> @@ -1154,6 +1154,9 @@ ssize_t __ceph_sync_read(struct inode *inode, lo=
ff_t *ki_pos,
>>>>    		doutc(cl, "%llu~%llu got %zd i_size %llu%s\n", off, len,
>>>>    		      ret, i_size, (more ? " MORE" : ""));
>>>>    +		if (i_size =3D=3D 0)
>>>> +			ret =3D 0;
>>>> +
>>>>    		/* Fix it to go to end of extent map */
>>>>    		if (sparse && ret >=3D 0)
>>>>    			ret =3D ceph_sparse_ext_map_end(op);
>>>>
>>> Hi Luis,
>>>
>>> BTW, so in the following code:
>>>
>>> 1202=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 idx =3D 0;
>>> 1203=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (ret <=3D 0)
>>> 1204=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0 left =3D 0;
>>> 1205=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 else if (off + ret > i_size)
>>> 1206=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0 left =3D i_size - off;
>>> 1207=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 else
>>> 1208=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0 left =3D ret;
>>>
>>> The 'ret' should be larger than '0', right ?
>> Right.  (Which means we read something from the file.)
>>
>>> If so we do not check anf fix it in the 'else if' branch instead?
>> Yes, and then we'll have:
>>
>> 	left =3D i_size - off;
>>
>> and because 'i_size' is 0, so 'left' will be set to 0xffffffffff...
>> And the loop that follows:
>>
>> 	while (left > 0) {
>>          	...
>>          }
>>
>> will keep looping until we get a NULL pointer.  Have you tried the
>> reproducer?
>
> Hi Luis,
>
> Not yet, and recently I haven't get a chance to do that for the reason as=
 you
> know.

Hi Xiubo,

I know you've been busy, but I was wondering if you (or someone else) had
a chance to have a look at this.  It's pretty easy to reproduce, and it
has been seen in production.  Any chances of getting some more feedback on
this fix?

Cheers,
--=20
Lu=C3=ADs

