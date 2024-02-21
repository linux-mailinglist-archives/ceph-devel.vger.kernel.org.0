Return-Path: <ceph-devel+bounces-895-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 15B6585E41D
	for <lists+ceph-devel@lfdr.de>; Wed, 21 Feb 2024 18:13:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6928C1F255B3
	for <lists+ceph-devel@lfdr.de>; Wed, 21 Feb 2024 17:13:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 272EF83CAF;
	Wed, 21 Feb 2024 17:12:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="LmxXQRNF"
X-Original-To: ceph-devel@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E515333F7
	for <ceph-devel@vger.kernel.org>; Wed, 21 Feb 2024 17:12:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708535573; cv=none; b=ayvBibXv5531K7pI2zP/ytOgbCYRNRHce8lmSDSfA0K41LVUOIt9PBsdBwFzzmTPpzcttB7s4/FToV/TpbzHEAssDopCxUAZhwHfSqYptnqGFQMu0zw3Ocl3armKLBKKsJdpSHgGkoYyW9rZKuNxlAyHeUHm4GrMJSgK1lHHH7U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708535573; c=relaxed/simple;
	bh=W6+Ip2QeWrVmCxpNyRsf3NOJyGeCZxAYgRXZ9eR/wkE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=iWFQuye0TmpaX5PSDN4wHdWSJGd/hHxA2DTLB1J5ejvvlZF3Dz2qsIg6OM0A5CMHzaMblkiaqZbVJw9HMvbGvOUZkkmV1myUrbpFFAtjhdbqU0nXeT1E0dmtRTTPk9NXrGqa8D2l4zjtAbOo0alFgJhZSicH6MYHwJORuv+/RCI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=LmxXQRNF; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1708535570;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=PMZfuItrr0qljnMXwf7d5BVvHGxD1KtxZBsU9sICmKg=;
	b=LmxXQRNFh+IDp8fsaHvllkAt/OjulqSRN1/bl0AbiuliMqY80dfw/5at20PPZTZ1m1REF1
	LKuJuzxLk6IUxOo+Pxlf/R9hfnhqKu51UHQkMPwjytjX3R4IWHCN8cjp8rn8oClX3DDB8a
	iovvQAyFI7IQ4oGJsuVwjCysF2XY86A=
Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com
 [209.85.214.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-453-qq6A36lAMZCSo3EK69XajA-1; Wed, 21 Feb 2024 12:12:49 -0500
X-MC-Unique: qq6A36lAMZCSo3EK69XajA-1
Received: by mail-pl1-f200.google.com with SMTP id d9443c01a7336-1d4a645af79so79330695ad.3
        for <ceph-devel@vger.kernel.org>; Wed, 21 Feb 2024 09:12:48 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708535568; x=1709140368;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=PMZfuItrr0qljnMXwf7d5BVvHGxD1KtxZBsU9sICmKg=;
        b=c5XsM+zLyuvhcnohUC4TuUetQZp9bDaZnQIF/EzFidnMvpHzrV7zmFMvd0XzGY50OK
         LNN0wJdNZFxoU0EgSqCcUcRla0bJFSW0isEfi2dYSvg9KuUfTzi+gMYjOWB/0ylTzIti
         zvKnMY2a87yMdGIj/TrXifJ/kZaFcQYCDci31sRu5q8dkDdFcum437eLh/VpkvXn8WHy
         wLnV/mn/yKQgcpo0mOIxpsLO4NVXBy1TSczZ9pB4pIZ80E2l4HUK6gt00I1PpFSEYOh0
         R3RMPZEXlvaYYjVNiYc1SE9ihDXi/kbQPqIXicZ6j5JsfsFZTDVQeV+UE3kXXslhB8YA
         hnrQ==
X-Forwarded-Encrypted: i=1; AJvYcCXQEV/msOFpUtyC4qQ1VOKklEWZA6jsXjKhnRHnx4iVEU+yuWp38H8UvPx3qDmP/yalPCJ3f4WWMGg3fBrC88HSWqvBhAX4jnx71w==
X-Gm-Message-State: AOJu0Yy2/PcfEPA/Aub8uLb/NxCRnHywV0c6wz1lL/q5gsWSOdwdRg6x
	T2mRquFZoW0qdRyIGSORtkaTCNf5210J11f6R9h5H+E49fSxJ4WyKlnDCifcRRVEF9x5QewF7dN
	UeXIBoe9glgT6tx9KAdYwHRQr0PxnY0DbxX5VXcls1CUMYZBc9n1hZ/PJ/zOyHqxuMNir4W3oF1
	P2b0sMCtFWz8hOX3YtX6vc+yX6vh1GhJHgaQ==
X-Received: by 2002:a17:903:11c3:b0:1d9:a4a5:7a6c with SMTP id q3-20020a17090311c300b001d9a4a57a6cmr25906765plh.57.1708535567905;
        Wed, 21 Feb 2024 09:12:47 -0800 (PST)
X-Google-Smtp-Source: AGHT+IE2FMOsCDqx7Elh1YRJ9sb6KWCXHyeKl8gh7xmZ+cLG7nJI8VTGjhRd0Cc2dT9cv+XHOqpJldzpYnmOqa8PLx8=
X-Received: by 2002:a17:903:11c3:b0:1d9:a4a5:7a6c with SMTP id
 q3-20020a17090311c300b001d9a4a57a6cmr25906746plh.57.1708535567543; Wed, 21
 Feb 2024 09:12:47 -0800 (PST)
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <SEZPR04MB697268A8E75E22B0A0F10129B77B2@SEZPR04MB6972.apcprd04.prod.outlook.com>
 <6f953a75-23cc-4d41-bbc5-2ca0a839f6d3@redhat.com>
In-Reply-To: <6f953a75-23cc-4d41-bbc5-2ca0a839f6d3@redhat.com>
From: Gregory Farnum <gfarnum@redhat.com>
Date: Wed, 21 Feb 2024 09:12:35 -0800
Message-ID: <CAJ4mKGaSyNPMyCiM6WwyB9rAVGFr-_MYdwc5Q0k2YA4y0vOHWQ@mail.gmail.com>
Subject: Re: Read operation gets EOF return when there is multi-client
 read/write after linux 5.16-rc1
To: Xiubo Li <xiubli@redhat.com>
Cc: =?UTF-8?B?RnJhbmsgSHNpYW8g6JWt5rOV5a6j?= <frankhsiao@qnap.com>, 
	"ceph-devel@vger.kernel.org" <ceph-devel@vger.kernel.org>, Jeff Layton <jlayton@kernel.org>, 
	Venky Shankar <vshankar@redhat.com>, Patrick Donnelly <pdonnell@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Feb 19, 2024 at 9:09=E2=80=AFPM Xiubo Li <xiubli@redhat.com> wrote:
>
>
> On 1/24/24 11:25, Frank Hsiao =E8=95=AD=E6=B3=95=E5=AE=A3 wrote:
>
> When multiple ceph kernel clients perform read/write on the same file, th=
e read
> operation(ceph_sync_read) returns EOF(ret =3D 0) even though the file has=
 been
> written by another client.
>
> My envs use Ceph quincy(v17.2.6) and mount cephfs by ceph kernel client. =
For the
> client side, I use Samba(v4.18.8) to export the folder as smb share and t=
est it
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
> After some testing, I figured out that the failure only happens when I ha=
ve
> linux kernel version>=3D5.16-rc1, specifically after commit
> c3d8e0b5de487a7c462781745bc17694a4266696. Kernel logs as below(on 5.16-rc=
1):
>
>
> [Wed Jan 10 09:44:56 2024] [153221] ceph_read_iter:1559: ceph:  aio_sync_=
read
> 00000000789dccee 100000010ef.fffffffffffffffe 0~440 got cap refs on Fr
> [Wed Jan 10 09:44:56 2024] [153221] ceph_sync_read:852: ceph:  sync_read =
on file
> 00000000d9e861fb 0~440
> [Wed Jan 10 09:44:56 2024] [153221] ceph_sync_read:913: ceph:  sync_read =
0~440 got 440 i_size 0
> [Wed Jan 10 09:44:56 2024] [153221] ceph_sync_read:966: ceph:  sync_read =
result 0 retry_op 2
>
> ...
>
> [Wed Jan 10 09:44:57 2024] [153221] ceph_read_iter:1559: ceph:  aio_sync_=
read
> 00000000789dccee 100000010ef.fffffffffffffffe 0~440 got cap refs on Fr
> [Wed Jan 10 09:44:57 2024] [153221] ceph_sync_read:852: ceph:  sync_read =
on file
> 00000000d9e861fb 0~0
>
>
> The logs indicate that:
> 1. ceph_sync_read may read data but i_size is obsolete in simultaneous rw=
 situation
> 2. The commit in 5.16-rc1 cap ret to i_size and set retry_op =3D CHECK_EO=
F
> 3. When retrying, ceph_sync_read gets len=3D0 since iov count has modifie=
d in
> copy_page_to_iter
> 4. ceph_read_iter return 0
>
> Yeah, in simultaneious read and write case, the CInode's filelock will be=
 in MIX mode. When one client append new contents to the file it will incre=
ase the 'i_size' metadata to MDS, and then the MDS will broadcast the new m=
etadatas to all the other clients. But in your case the reader client didn'=
t get it yet before reading and was still using the old metadata.
>
> And the cephfs itself won't guarantee that the reader clients could get l=
atest contents and metadata immediately. There will be a delay between clie=
nts. It should the apps themself to guarantee this.
>
> Before commit c3d8e0b5de487a7c462781745bc17694a4266696 it won't check the=
 local 'i_size' and just read contents beyond of the file end boundary from=
 Rados. Even we allow it like this for the contents, but the metadatas stil=
l have the same issue. So this sounds incorrect to me.
>
> Greg, Venky, Patrick, Jeff
>
> What do you think ?

I'm a little worried about this phrasing. In a MIX mode, clients can
only have Frw caps (and the lack of Fs means, don't cache file size
locally); the MDS may broadcast file size updates but I don't think
clients are allowed to rely on that. So from looking at the userspace
client, what should be happening in the described scenario is, the
client extends the file size with the MDS, then does its
file-extending write to the OSD, then the write is reported as
complete. And the second client gets the read request, at which point
it would have to check the file size from the MDS, then see the larger
size, then do the OSD read.
...and actually, when the MDS gets a setattr for the size, it grabs an
xlock locally, which may mean it recalls the Frw caps while it makes
that change? I haven't had to dig into the guts of this in a while, so
maybe the local file size is reliable. I guess Fs also covers mtime,
and that's why we don't issue it in MIX mode? Ugh.

Anyway, it is definitely not up to the applications to try and provide
file consistency as that is why we have filesystems at all. :) We
definitely do guarantee that readers get contents and metadata which
reflect any completed writes, as of the time the read was initiated =E2=80=
=94
this is a basic requirement of POSIX. (Of course, if the write isn't
completed when the write starts, we can do whatever we want.)

I'm not generally up on the kernel implementation, so any patches
which may have broken it, and the correct fix, are beyond me.

But having said all that, layering samba on top of the kernel client
is going to have wildly unpredictable behavior =E2=80=94 the kernel client =
can
maintain all the consistency it wants, but with Samba sitting on top
caching things then the real file state is going to be completely
uncontrolled. I don't see how you're going to get predictable
outcomes, and am surprised any kernel client cephfs change could
reliably influence this, although the referenced kernel patch
certainly does change what we return to reads when there is
simultaneous IO. What's the change from i_size_read(inode) -> i_size
do =E2=80=94 is that correctly covered by cap state? Or is the problem here
that smbtorture is running on nodes going to multiple sambas that are
speaking to the kernel cephfs client and getting fairly random results
back due to that? (I could see eg smb1 does a truncate+write which
gets flushed to OSD, then smb2 does a read before the cephfs write is
finished which happens to pick up the new data while the size updates
are happening.)
-Greg

> I'm not sure if my understanding is correct. As a reference, here is my s=
imple
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
> @@ -926,6 +926,9 @@ static ssize_t ceph_sync_read(struct kiocb *iocb, str=
uct iov_iter *to,
>
>                 idx =3D 0;
>                 left =3D ret > 0 ? ret : 0;
> +               if (left > i_size) {
> +                       left =3D i_size;
> +               }
>                 while (left > 0) {
>                         size_t len, copied;
>                         page_off =3D off & ~PAGE_MASK;
> @@ -952,7 +955,7 @@ static ssize_t ceph_sync_read(struct kiocb *iocb, str=
uct iov_iter *to,
>                         break;
>         }
>
> -       if (off > iocb->ki_pos) {
> +       if (off > iocb->ki_pos || i_size =3D=3D 0) {
>
> This seems incorrect to me.
>
> For example, what if the existing file size is 1024 bytes and then the wr=
iter client tries to append 1024 bytes to the file, then the file new size =
will be 2048. And then the reader clients' file i_size could still be 1024.
>
> Thanks
>
> - Xiubo
>
>                 if (off >=3D i_size) {
>                         *retry_op =3D CHECK_EOF;
>                         ret =3D i_size - iocb->ki_pos;


