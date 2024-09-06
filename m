Return-Path: <ceph-devel+bounces-1798-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 9A3D096F31C
	for <lists+ceph-devel@lfdr.de>; Fri,  6 Sep 2024 13:31:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 59EC02860CE
	for <lists+ceph-devel@lfdr.de>; Fri,  6 Sep 2024 11:31:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EF41F1CB31D;
	Fri,  6 Sep 2024 11:31:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="YgIRioNf"
X-Original-To: ceph-devel@vger.kernel.org
Received: from out-175.mta0.migadu.com (out-175.mta0.migadu.com [91.218.175.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11AF715852B
	for <ceph-devel@vger.kernel.org>; Fri,  6 Sep 2024 11:31:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725622274; cv=none; b=b3/BHEfnvj+HEQsGJBkFFGEEbj4NMjWYPuu2yEoAQ7HoB4NO9YKW96BRVK4TDXU3OJabUfFOmBUU4O/ZeSdRxRTeeYuUG+hpr/ffIuCY+6gABJk1guMMBmD7PX+XVpRviVM6n43V6OitOuQcu8BSfsjuIyQI58fr7Iv4Yt8v0Dk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725622274; c=relaxed/simple;
	bh=I+UIT6pE7Y9QTLadbLXtbfO2dU0Dq4lMpv/b7Ff1OO4=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=e3EcZtUxwmpCjg+M0mkIAaaqjmpP9CUrne2O2xKuxBiVJSXoPglxpviiYNI2rBAWpe8ZBArhsl3/mTffPUSRGBgb6G7wuy4/TZaLyv/BoDdWgz2lNG7hrLWCvpTGdWULXMYNQBfWof3AMw557mgPElg1YfVkQYtO2NOncAmZilA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=YgIRioNf; arc=none smtp.client-ip=91.218.175.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1725622268;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=YGxm4syi/7GW5QpqNl2nKGcGBXxggaJ5/exSagt2b+w=;
	b=YgIRioNfUM6aP2CZE1rAqge+E6LXCxu2ofp7Hb61dRe8kZI9VlcomhAlFJU2w8sD+2K4Fs
	dPpxKKbCvCmqd5BFGdlob1rWcnqA7qIUhYdg71Z9MAFUra2aGutBnQfQnk/ekbnHws8rAE
	aYa7TZQaiolTgPOjuz2rCSc7RwOnI0k=
From: Luis Henriques <luis.henriques@linux.dev>
To: Xiubo Li <xiubli@redhat.com>
Cc: Ilya Dryomov <idryomov@gmail.com>,  ceph-devel@vger.kernel.org,
  linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v2] ceph: ceph: fix out-of-bound array access when
 doing a file read
In-Reply-To: <e1c50195-07a9-4634-be01-71f4567daa54@redhat.com> (Xiubo Li's
	message of "Fri, 6 Sep 2024 19:17:45 +0800")
References: <20240905135700.16394-1-luis.henriques@linux.dev>
	<e1c50195-07a9-4634-be01-71f4567daa54@redhat.com>
Date: Fri, 06 Sep 2024 12:30:59 +0100
Message-ID: <87plphm32k.fsf@linux.dev>
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

> On 9/5/24 21:57, Luis Henriques (SUSE) wrote:
>> __ceph_sync_read() does not correctly handle reads when the inode size is
>> zero.  It is easy to hit a NULL pointer dereference by continuously read=
ing
>> a file while, on another client, we keep truncating and writing new data
>> into it.
>>
>> The NULL pointer dereference happens when the inode size is zero but the
>> read op returns some data (ceph_osdc_wait_request()).  This will lead to
>> 'left' being set to a huge value due to the overflow in:
>>
>> 	left =3D i_size - off;
>>
>> and, in the loop that follows, the pages[] array being accessed beyond
>> num_pages.
>>
>> This patch fixes the issue simply by checking the inode size and returni=
ng
>> if it is zero, even if there was data from the read op.
>>
>> Link: https://tracker.ceph.com/issues/67524
>> Fixes: 1065da21e5df ("ceph: stop copying to iter at EOF on sync reads")
>> Signed-off-by: Luis Henriques (SUSE) <luis.henriques@linux.dev>
>> ---
>>   fs/ceph/file.c | 5 ++++-
>>   1 file changed, 4 insertions(+), 1 deletion(-)
>>
>> diff --git a/fs/ceph/file.c b/fs/ceph/file.c
>> index 4b8d59ebda00..41d4eac128bb 100644
>> --- a/fs/ceph/file.c
>> +++ b/fs/ceph/file.c
>> @@ -1066,7 +1066,7 @@ ssize_t __ceph_sync_read(struct inode *inode, loff=
_t *ki_pos,
>>   	if (ceph_inode_is_shutdown(inode))
>>   		return -EIO;
>>   -	if (!len)
>> +	if (!len || !i_size)
>>   		return 0;
>>   	/*
>>   	 * flush any page cache pages in this range.  this
>> @@ -1154,6 +1154,9 @@ ssize_t __ceph_sync_read(struct inode *inode, loff=
_t *ki_pos,
>>   		doutc(cl, "%llu~%llu got %zd i_size %llu%s\n", off, len,
>>   		      ret, i_size, (more ? " MORE" : ""));
>>   +		if (i_size =3D=3D 0)
>> +			ret =3D 0;
>> +
>>   		/* Fix it to go to end of extent map */
>>   		if (sparse && ret >=3D 0)
>>   			ret =3D ceph_sparse_ext_map_end(op);
>>
> Hi Luis,
>
> BTW, so in the following code:
>
> 1202=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 idx =3D 0;
> 1203=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (ret <=3D 0)
> 1204=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
 left =3D 0;
> 1205=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 else if (off + ret > i_size)
> 1206=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
 left =3D i_size - off;
> 1207=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 else
> 1208=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
 left =3D ret;
>
> The 'ret' should be larger than '0', right ?

Right.  (Which means we read something from the file.)

> If so we do not check anf fix it in the 'else if' branch instead?

Yes, and then we'll have:

	left =3D i_size - off;

and because 'i_size' is 0, so 'left' will be set to 0xffffffffff...
And the loop that follows:

	while (left > 0) {
        	...
        }

will keep looping until we get a NULL pointer.  Have you tried the
reproducer?

Cheers,
--=20
Lu=C3=ADs

> Because currently the read path code won't exit directly and keep retryin=
g to
> read if it found that the real content length is longer than the local 'i=
_size'.
>
> Again I am afraid your current fix will break the MIX filelock semantic ?
>
> Thanks
>
> - Xiubo
>


