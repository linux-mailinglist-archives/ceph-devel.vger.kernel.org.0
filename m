Return-Path: <ceph-devel+bounces-1772-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 977DA962CF6
	for <lists+ceph-devel@lfdr.de>; Wed, 28 Aug 2024 17:50:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4CAC91F27065
	for <lists+ceph-devel@lfdr.de>; Wed, 28 Aug 2024 15:50:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 819AE1A4B73;
	Wed, 28 Aug 2024 15:48:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="ek0+dSIa"
X-Original-To: ceph-devel@vger.kernel.org
Received: from out-172.mta0.migadu.com (out-172.mta0.migadu.com [91.218.175.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBCFD15B12F
	for <ceph-devel@vger.kernel.org>; Wed, 28 Aug 2024 15:48:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724860112; cv=none; b=nwdnrK9MUazQiL0awNLRsMQpoCHpxzUkL8w0sLTIfGdfZJiKPhMj92tjknVDmaC6AmMkACbMESh0fUUDE+EO+7VmFZvaLSRLpfQb6NofSF99OCMynIQS2rEtjGJSG9liKlNhb1y8KnMq5lH5kXIR0poFSlBv+PDnVvQkvQLfH0U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724860112; c=relaxed/simple;
	bh=QQIAkG8BL6VaqRW8sK+VGWoxj4TPTPaEAwS3gZ6j1oo=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=P+7iJySzWoBHm1NdvhAUjHF2I96JuPT6XTzuE5sxlrvq9iy6c3ZXXgPjCWKe+A4JK5XZ7cmRwWIRapA6+8RmaabFTi4Y/zVbHVxu6xURofJda2ujrTMb+Mvl0jF7D3KogUlMgv7Em3Z4/9rpLy5WtH0d/y0KwS3GEkO7dbqiL8Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=ek0+dSIa; arc=none smtp.client-ip=91.218.175.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1724860107;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=rZFebvQx1lq4LmOvSNV59MQj2DCkftTFtvDq1WfbR7E=;
	b=ek0+dSIa+Ect5YD5nns2Y/h7joO8YkE/fzKibTAl82ci9lFPaPAU39byqmsKfxtlOAyGlE
	kqJMjsHL/K+wEhDjMZQ2EZbuqaAmQUHlWx8UihZkoNPG3bIaFqbroZeBEQp8ymXZPWmD9x
	jiJnDYg5L+wAiZE+Edcr030rqXpfJPU=
From: Luis Henriques <luis.henriques@linux.dev>
To: Xiubo Li <xiubli@redhat.com>
Cc: Ilya Dryomov <idryomov@gmail.com>,  ceph-devel@vger.kernel.org,
  linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH] ceph: fix out-of-bound array access when doing a
 file read
In-Reply-To: <5d44ae23-4a68-446a-9ae8-f5b809437b32@redhat.com> (Xiubo Li's
	message of "Wed, 28 Aug 2024 13:47:10 +0800")
References: <20240822150113.14274-1-luis.henriques@linux.dev>
	<87mskyxf3l.fsf@linux.dev>
	<5d44ae23-4a68-446a-9ae8-f5b809437b32@redhat.com>
Date: Wed, 28 Aug 2024 16:48:17 +0100
Message-ID: <87y14gy7ge.fsf@linux.dev>
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Migadu-Flow: FLOW_OUT

On Wed, Aug 28 2024, Xiubo Li wrote:

> On 8/27/24 21:36, Luis Henriques wrote:
>> On Thu, Aug 22 2024, Luis Henriques (SUSE) wrote:
>>
>>> If, while doing a read, the inode is updated and the size is set to zer=
o,
>>> __ceph_sync_read() may not be able to handle it.  It is thus easy to hi=
t a
>>> NULL pointer dereferrence by continuously reading a file while, on anot=
her
>>> client, we keep truncating and writing new data into it.
>>>
>>> This patch fixes the issue by adding extra checks to avoid integer over=
flows
>>> for the case of a zero size inode.  This will prevent the loop doing pa=
ge
>>> copies from running and thus accessing the pages[] array beyond num_pag=
es.
>>>
>>> Link: https://tracker.ceph.com/issues/67524
>>> Signed-off-by: Luis Henriques (SUSE) <luis.henriques@linux.dev>
>>> ---
>>> Hi!
>>>
>>> Please note that this patch is only lightly tested and, to be honest, I=
'm
>>> not sure if this is the correct way to fix this bug.  For example, if t=
he
>>> inode size is 0, then maybe ceph_osdc_wait_request() should have return=
ed
>>> 0 and the problem would be solved.  However, it seems to be returning t=
he
>>> size of the reply message and that's not something easy to change.  Or =
maybe
>>> I'm just reading it wrong.  Anyway, this is just an RFC to see if there=
's
>>> other ideas.
>>>
>>> Also, the tracker contains a simple testcase for crashing the client.
>> Just for the record, I've done a quick bisect as this bug is easily
>> reproducible.  The issue was introduced in v6.9-rc1, with commit
>> 1065da21e5df ("ceph: stop copying to iter at EOF on sync reads").
>> Reverting it makes the crash go away.
>
> Thanks very much Luis.
>
> So let's try to find the root cause of it and then improve the patch.

What's happening is that we have an inode with size 0, but we are not
checking it's size.  The bug is easy to trigger (at least in my test
environment), and the conditions for it are:

 1) the inode size has to be 0, and
 2) the read has to return data ('ret =3D ceph_osdc_wait_request()').

This will lead to 'left' being set to huge values due to the overflow in:

	left =3D i_size - off;

However, some times (maybe most of the time) __ceph_sync_read() will not
crash and will return -EFAULT instead.  In the 'while (left > 0) { ... }'
loop, the condition '(copied < plen)' will be true and this error is
returned in the first iteration of the loop.

So, here's a much simpler approach to fix this issue: to bailout if we
have a 0-sized inode.  What do you think?

Cheers,
--=20
Lu=C3=ADs


diff --git a/fs/ceph/file.c b/fs/ceph/file.c
index 4b8d59ebda00..41d4eac128bb 100644
--- a/fs/ceph/file.c
+++ b/fs/ceph/file.c
@@ -1066,7 +1066,7 @@ ssize_t __ceph_sync_read(struct inode *inode, loff_t =
*ki_pos,
 	if (ceph_inode_is_shutdown(inode))
 		return -EIO;
=20
-	if (!len)
+	if (!len || !i_size)
 		return 0;
 	/*
 	 * flush any page cache pages in this range.  this
@@ -1154,6 +1154,9 @@ ssize_t __ceph_sync_read(struct inode *inode, loff_t =
*ki_pos,
 		doutc(cl, "%llu~%llu got %zd i_size %llu%s\n", off, len,
 		      ret, i_size, (more ? " MORE" : ""));
=20
+		if (i_size =3D=3D 0)
+			ret =3D 0;
+
 		/* Fix it to go to end of extent map */
 		if (sparse && ret >=3D 0)
 			ret =3D ceph_sparse_ext_map_end(op);

