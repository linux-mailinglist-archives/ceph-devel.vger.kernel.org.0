Return-Path: <ceph-devel+bounces-2973-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 1610AA6935A
	for <lists+ceph-devel@lfdr.de>; Wed, 19 Mar 2025 16:29:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E12D516D963
	for <lists+ceph-devel@lfdr.de>; Wed, 19 Mar 2025 15:24:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 161A61C5D79;
	Wed, 19 Mar 2025 15:24:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="JJRvzB3+"
X-Original-To: ceph-devel@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 316B519AD89
	for <ceph-devel@vger.kernel.org>; Wed, 19 Mar 2025 15:24:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742397878; cv=none; b=eWsDcLDaJKmTMxZDOxhy2XxnnZoOaf0mED0hyUWorBrVz3J+Lw0mye2cxH+aGIpPRyAsJglhHVIXFSMroUlNiRl4YHsvUK/eY+vFxaCd04Flhaf5Uulz5Fl6NGmluGBSm0i+tIujJtZcJSj/pa238IIG38hWpz8+aF6vJwK8ZXQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742397878; c=relaxed/simple;
	bh=P37qi40Ws5FQBrhzExvWM3FjjILBQqoBwdLQeMYzSVA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=gYaNvTcWUYX1zb8y8eCDPXaEnzTqgzAXDgjVOmEDSPNYfXDaBjW7uZChUF7LpCOh8lf9D4dJW1VM5/1xTLsLoQcbXnL76WqUCPdr55NiGf1SGvjfj8bnbY0Esyo0A3QKirmmtaey5YpN4TuxsKhHta0JEPHmza0r3h5zX6nr9L4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=JJRvzB3+; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1742397876;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=P37qi40Ws5FQBrhzExvWM3FjjILBQqoBwdLQeMYzSVA=;
	b=JJRvzB3+oavYW0d8Ek4giFcU6srzyelS9L2PKqrdqOAg6unM7wo0LT8ToGmFdo+arRjfsG
	ufLMKVIDyCwjIlJ8qvWu/HEcSfAuBnOLNQWJcUPvP6sMlGNNJnq9tfHLzfvgIiFV14xq7p
	YE/HzRBsg6qkZzs94YkC45K3G0iULL4=
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com
 [209.85.214.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-625-wb2HjpyiOd64a2MCEnL_fw-1; Wed, 19 Mar 2025 11:24:34 -0400
X-MC-Unique: wb2HjpyiOd64a2MCEnL_fw-1
X-Mimecast-MFC-AGG-ID: wb2HjpyiOd64a2MCEnL_fw_1742397874
Received: by mail-pl1-f198.google.com with SMTP id d9443c01a7336-2242ade807fso184794965ad.2
        for <ceph-devel@vger.kernel.org>; Wed, 19 Mar 2025 08:24:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742397873; x=1743002673;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=P37qi40Ws5FQBrhzExvWM3FjjILBQqoBwdLQeMYzSVA=;
        b=J6Xof+kIcwTdIr/UZOLi2jki91vFi5Hip2X5nyhqJPPdIXSx0g6NZY1X+1bcBK+esT
         RqjSQsMDkkf8jGE6z5ZHeBteRZeSsmgGJCjYGHdDiLPmTWjsJUn2YXVb4GQLEa7FmgUM
         1lp9xEbttyglPd3JL0cWQGXi4OqU/VO9N0ONfq4bsdiDWF54Q+PSo3V7S0QniVm0fef2
         qlYlBN97VRhM4Rqmt21JOeLi8+PIeh62pGBjpyjff4DQJOOgHovES7a+zC+Y99/HLFPt
         I53Wh46X7vMD97yl5ogrNM1SMRDDhKk0Pdk/euSrIWzihVH5ftzotlbz2zM4NZqcarBR
         Zw7w==
X-Gm-Message-State: AOJu0Yxiu2aBKWDpz3JJ9QNt4Oc/bvHam+iDgO6+F70ecCqIxdyIb1Zc
	MXY2HeZM/6pgAl3GUoNKngJ6x5YVipd1cdEP44Xp8vwwTnSUIEztWlsSuQRslarEo76/qzf2tSp
	m0K/DpKctJDgYeWZjX+cnU6acEDn21ZhzraeSGlNH2jWRTUClhYfhdCyaJjD18/VE+Rv7DvtvRh
	bZ5GkB6hqqrWXeLAn6Uu/e8fQB+MnrYU39tg==
X-Gm-Gg: ASbGncs0eqrt5uOoOwj4A0GtfnnZbSa6yWthvpbXVAtOH7EJqOFRrpT8wSgBGpY5z7D
	/PTW/EhEL04pO0E4osOl14+yKD1ol308QSyuyLPbaeyZM8im7M8W1yFXpZB6ZKhXFfZaaLT1ts/
	3VIPOxvkD0ebaH0y47BE7fKFaybTAhX8k=
X-Received: by 2002:a05:6a20:938a:b0:1f3:486c:8509 with SMTP id adf61e73a8af0-1fbebc83800mr5725972637.25.1742397873468;
        Wed, 19 Mar 2025 08:24:33 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGtajrOOycCqo+ctQq6DjEzA7+VzJUdO1juK6xrGmGpSnzkLMoZhTDxevcByLY9ELu1uKbiujwBlcIlCqy9ta8=
X-Received: by 2002:a05:6a20:938a:b0:1f3:486c:8509 with SMTP id
 adf61e73a8af0-1fbebc83800mr5725872637.25.1742397872411; Wed, 19 Mar 2025
 08:24:32 -0700 (PDT)
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250318234752.886003-1-slava@dubeyko.com>
In-Reply-To: <20250318234752.886003-1-slava@dubeyko.com>
From: Gregory Farnum <gfarnum@redhat.com>
Date: Wed, 19 Mar 2025 08:24:21 -0700
X-Gm-Features: AQ5f1JolNqI7B5lqhY5f-PIYn-KA3wVnHeoSYDShL43lA8KIwoXMw4jiEu0lfkM
Message-ID: <CAJ4mKGYmcJ5SSbGhEFKrTw_BJWtT1z460JMcbg++7EBreUn6tA@mail.gmail.com>
Subject: Re: [RFC PATCH] ceph: fix ceph_fallocate() ignoring of
 FALLOC_FL_ALLOCATE_RANGE mode
To: Viacheslav Dubeyko <slava@dubeyko.com>
Cc: ceph-devel@vger.kernel.org, amarkuze@redhat.com, dhowells@redhat.com, 
	idryomov@gmail.com, linux-fsdevel@vger.kernel.org, pdonnell@redhat.com, 
	Slava.Dubeyko@ibm.com, Milind Changire <mchangir@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Mar 18, 2025 at 4:48=E2=80=AFPM Viacheslav Dubeyko <slava@dubeyko.c=
om> wrote:
> From: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>
>
> The fio test reveals the issue for the case of file size
> is not aligned on 4K (for example, 4122, 8600, 10K etc).
> The reproducing path:
>
> target_dir=3D/mnt/cephfs
> report_dir=3D/report
> size=3D100ki
> nrfiles=3D10
> pattern=3D0x74657374
>
> fio --runtime=3D5M --rw=3Dwrite --bs=3D4k --size=3D$size \
> --nrfiles=3D$nrfiles --numjobs=3D16 --buffer_pattern=3D0x74657374 \
> --iodepth=3D1 --direct=3D0 --ioengine=3Dlibaio --group_reporting \
> --name=3Dfiotest --directory=3D$target_dir \
> --output $report_dir/sequential_write.log
>
> fio --runtime=3D5M --verify_only --verify=3Dpattern \
> --verify_pattern=3D0x74657374 --size=3D$size --nrfiles=3D$nrfiles \
> --numjobs=3D16 --bs=3D4k --iodepth=3D1 --direct=3D0 --name=3Dfiotest \
> --ioengine=3Dlibaio --group_reporting --verify_fatal=3D1 \
> --verify_state_save=3D0 --directory=3D$target_dir \
> --output $report_dir/verify_sequential_write.log
>
> The essence of the issue that the write phase calls
> the fallocate() to pre-allocate 10K of file size and, then,
> it writes only 8KB of data. However, CephFS code
> in ceph_fallocate() ignores the FALLOC_FL_ALLOCATE_RANGE
> mode and, finally, file is 8K in size only. As a result,
> verification phase initiates wierd behaviour of CephFS code.
> CephFS code calls ceph_fallocate() again and completely
> re-write the file content by some garbage. Finally,
> verification phase fails because file contains unexpected
> data pattern.


CephFS doesn=E2=80=99t really support fallocate in the general case to begi=
n
with =E2=80=94 we don=E2=80=99t want to go out and create an arbitrary numb=
er of 4MiB
objects in response to a large allocation command. AFAIK the only one
we really do is letting you set a specific file size up (or down,
maybe?). Do we actually want to support this specific sub-piece of the
API? What happens if somebody uses FALLOC_FL_ALLOCATE_RANGE to set a
size of 4MiB+1KiB? Is this synched with the current state of the user
space client? I know Milind just made some changes around userspace
fallocate to rationalize our behavior.


> fio: got pattern 'd0', wanted '74'. Bad bits 3
> fio: bad pattern block offset 0
> pattern: verify failed at file /mnt/cephfs/fiotest.3.0 offset 0, length 2=
631490270 (requested block: offset=3D0, length=3D4096, flags=3D8)
> fio: verify type mismatch (36969 media, 18 given)
> fio: got pattern '25', wanted '74'. Bad bits 3
> fio: bad pattern block offset 0
> pattern: verify failed at file /mnt/cephfs/fiotest.4.0 offset 0, length 1=
694436820 (requested block: offset=3D0, length=3D4096, flags=3D8)
> fio: verify type mismatch (6714 media, 18 given)
>
> Expected state ot the file:
>
> hexdump -C ./fiotest.0.0
> 00000000 74 65 73 74 74 65 73 74 74 65 73 74 74 65 73 74 |testtesttesttes=
t| *
> 00002000 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 |...............=
.| *
> 00002190 00 00 00 00 00 00 00 00 |........|
> 00002198
>
> Real state of the file:
>
> head -n 2 ./fiotest.0.0
> 00000000 35 e0 28 cc 38 a0 99 16 06 9c 6a a9 f2 cd e9 0a |5.(.8.....j....=
.|
> 00000010 80 53 2a 07 09 e5 0d 15 70 4a 25 f7 0b 39 9d 18 |.S*.....pJ%..9.=
.|
>
> The patch reworks ceph_fallocate() method by means of adding
> support of FALLOC_FL_ALLOCATE_RANGE mode. Also, it adds the checking
> that new size can be allocated by means of checking inode_newsize_ok(),
> fsc->max_file_size, and ceph_quota_is_max_bytes_exceeded().
> Invalidation and making dirty logic is moved into dedicated
> methods.
>
> There is one peculiarity for the case of generic/103 test.
> CephFS logic receives max_file_size from MDS server and it's 1TB
> by default. As a result, generic/103 can fail if max_file_size
> is smaller than volume size:
>
> generic/103 6s ... - output mismatch (see /home/slavad/XFSTESTS/xfstests-=
dev/results//generic/103.out.bad)
> --- tests/generic/103.out 2025-02-25 13:05:32.494668258 -0800
> +++ /home/slavad/XFSTESTS/xfstests-dev/results//generic/103.out.bad 2025-=
03-17 22:28:26.475750878 -0700
> @ -1,2 +1,3 @
> QA output created by 103
> +fallocate: No space left on device
> Silence is golden.
>
> The solution is to set the max_file_size equal to volume size:


That is really not a good idea. Is there really a test that tries to
fallocate that much space? We probably just want to skip it=E2=80=A6cleanin=
g
up files set to that size isn=E2=80=99t much fun.
-Greg


