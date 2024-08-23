Return-Path: <ceph-devel+bounces-1730-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 85E6295CA83
	for <lists+ceph-devel@lfdr.de>; Fri, 23 Aug 2024 12:33:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id D55C5B23BF8
	for <lists+ceph-devel@lfdr.de>; Fri, 23 Aug 2024 10:33:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 92EBC16EB4B;
	Fri, 23 Aug 2024 10:33:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="WjqS93v3"
X-Original-To: ceph-devel@vger.kernel.org
Received: from out-171.mta0.migadu.com (out-171.mta0.migadu.com [91.218.175.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 918641428E8
	for <ceph-devel@vger.kernel.org>; Fri, 23 Aug 2024 10:33:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724409220; cv=none; b=NnL85+QDIzJchd0MBd+bS6kobdio9IAwQXGWRP2DE+WyJ1kg8G/LzEWx8ceCrRHim2Q9IyPlH9tfTDDboJssZfV9ijBroAMzjKjdF/Dt9OZqX++Hh9goCY5P9xhyGfoE56eate/j4skbPDxn+mdYaLTpEFtboODgDGp+pV/CQiA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724409220; c=relaxed/simple;
	bh=5tzmMqE4uw8YNLH37w3JdkTPy1lBds4uLS8HcjKaLqE=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=Ms0VL38nCpk4ny4Q8RtVPHflLkBVqH5wxcunx3nkEtcnp61Am4Hc+gD3vwjDHdACdnGWStCKklMP+Ti/cJqGFhtRr7cKmwDcZSwxPkZI8l6r4ZFZZAopzlRNPMIbc8igNB85k16D/t+6ZOEbIovVmifDcdbYQl08Mparaaeki2o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=WjqS93v3; arc=none smtp.client-ip=91.218.175.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1724409215;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=23y0Dpx06rVTsxajJlUy4GfX8Ye+RAWg4FefK6RDN4E=;
	b=WjqS93v31AaeOz0pzVGR2Z4adLcbTjz0oM06c1Y7ujqJmomR35nb+1tG6FieL7NBvE0Pq8
	0f0kkVVWnWCxswKVxuCNXUdIVH3Bn89p4oyenW2GqSWQSsw0egg66HhkgnuQ/U9NYZeAif
	QrecW6NMUJE5EYhBPdgQA8MNPmoL+p0=
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
Date: Fri, 23 Aug 2024 11:33:27 +0100
Message-ID: <87msl3lea0.fsf@linux.dev>
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

(I forgot to comment here.)

This change is _exactly_ what will prevent the NULL pointer from
occurring, because if 'i_size' is 0, then:

		left =3D i_size - off;

will leave 'left' with a huge value.  And the loop 'while (left > 0) {}'
will execute until the access to 'pages[idx]' crashes.

Cheers,
--=20
Lu=C3=ADs

> BTW, could you reproduce the crash issue ?
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


