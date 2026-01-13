Return-Path: <ceph-devel+bounces-4377-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 37A60D1A9C4
	for <lists+ceph-devel@lfdr.de>; Tue, 13 Jan 2026 18:27:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 4E95F302BD02
	for <lists+ceph-devel@lfdr.de>; Tue, 13 Jan 2026 17:27:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ABFE5350293;
	Tue, 13 Jan 2026 17:27:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CHsKgpPS"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-dl1-f41.google.com (mail-dl1-f41.google.com [74.125.82.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 254C12E764C
	for <ceph-devel@vger.kernel.org>; Tue, 13 Jan 2026 17:27:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768325234; cv=none; b=qeXs0v70S+8K0ViYCOsPER/0YkpcTM+YellHxfB03mwCO+cl5a7q1kqWJK3jETtnTYIzjtDXsc+L1CAHgkyuTIYqszkFT6ecEJEmQvC1TKOJOEqUy6nOove34sO/o6+lwrYThToFhLaJr2Ns+29nvZBz7nO5pk9xzMyUD9yTcHQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768325234; c=relaxed/simple;
	bh=z/HPyDkNGo1sQechq6Gk3E8+TKE/5yYDGyHaqxkEF6U=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=GSHqpIRqbRMTr0H4LxUf+dvyjn9WfUPA4xBRbD+Dq4BJOtyH2hqc7zC9svoeOEqcm0lfEZxTVql8/HbxORPYw1qfPHg45CnJgxZLyc2+WsekAGwOdpusGs+JFsNPHyY0F9bfCA4JSr/uW+WiY0X/iWWVPygRjXYqu1ykh44nfdU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=CHsKgpPS; arc=none smtp.client-ip=74.125.82.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-dl1-f41.google.com with SMTP id a92af1059eb24-1205a8718afso8755552c88.0
        for <ceph-devel@vger.kernel.org>; Tue, 13 Jan 2026 09:27:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768325232; x=1768930032; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NJ/vlF56njPKqTEwdTGzkdWfSgydwa4jC6gZTFQ9yJw=;
        b=CHsKgpPSvb2WWT9wkZc92e/DuTesb1iZTXhlru8s+4w3XDj0mOisSKOCEYt71VncJm
         K7011f7W/zdiYXd378G/X+JlbTqDt7R6PwTiw9mEaJxu1GDrFo8qWTqCtYtFr6X91bHJ
         /5BWkz6IggbvsWaHkUUlpAolmH01FZTJJj9dirNTkcACiHOZb7M6yuO//NPnwuaEuZi1
         Z7mqRH0ueHCyuriw/9+kOgDZGrwCem6dyjs8qUF3OIQ6jD8nk4LOD7T7fiCZwGnBcjNr
         9u6MJhKUd0Z03s5pkON6YieqEUPA8ZU5B6hknuTDWAU7EUfvv6MNe/b4mKayVOdVWO/Z
         3bHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768325232; x=1768930032;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=NJ/vlF56njPKqTEwdTGzkdWfSgydwa4jC6gZTFQ9yJw=;
        b=QjGmqRxFMe6cCxjKpb8HRqmLAKIYnOlOSvmnm+wVwRut2VUSqgG99VSESkHgpNw+ug
         5+Cq1VUqqYIz9ZDoZhRCFt3HxuJW3kw7sbvtFXsbtxhlgAwa7ueiUK8pxhXLwQjNArRV
         AYpvLqEIaOyj7xOjZYLXfMdOfntriz3Pc1IJ6j3REumkAks6/HjPCh2moGi1f+jZAzi7
         RFjK0094C/pAvSmlfy1qNtnTXtGo1q04l1ILZQkq0FXJpvrjdgEcTMH2xF5KwuHuRvik
         6tVcK4AtpABRAfVPUJCCQfye0XIpkGwk8W/r9qosVGE8qvNwKdWFNG+QtfvzdcdM/Fmr
         oB2Q==
X-Forwarded-Encrypted: i=1; AJvYcCWs/yVSc3XE8LZ3RQkalHWbVFKhw90w6mBYHLRs1PTU2o/gWH7WHlOUt8vvIiWjRgjRDQHM6KBT0+v5@vger.kernel.org
X-Gm-Message-State: AOJu0YzGuJtg6IcwiA837bTbrZ3nnX/1ty3CJrTkJzDIo8yKvz186Iwo
	yIKTlZLmqH/E2dqZ4vdcDowLf2BXzOUd/CvxGDYlS/gcNwVMayxXOHdbCmoyWhyeNxAhTiLrrHr
	RwvnRvyoEtjf2CXFkwdg6H1AzK1zFeUg=
X-Gm-Gg: AY/fxX5ZSLCQR0b9bsamsA8J5XrOP2z9GGi6xI2K4Htr5TCuQy97IymCsy0AoinzipS
	2NBtHNDncnKsSxPp6HTHByBbtX7r4dlBsXv1A/HOmsVTuJjW/h4uZj+KaIE40TMdPdB8XSVAvoe
	56Rikl3rl8eOgqvUWCFtr6QLxzZkAtOjoWyHX8PH6yoOU30H567CO787HB0x90cjC8w2gtSpKB7
	1CilLbj1Jbg5BJTYSDHLu/PwS5AhQG9bcPmrNh7hIEa6up/aceH9VJ7GMbk3P12bQncWLc=
X-Google-Smtp-Source: AGHT+IEK+IPK20qJSSSXPkLv1dmGm30qvDpjp02tQOxxabBirCpngv3auAqygQZv/fqyQ+0BGcmXZ8EVD7Gynk4yPdk=
X-Received: by 2002:a05:7022:48d:b0:11a:fec5:d005 with SMTP id
 a92af1059eb24-121f8afe9d1mr22177969c88.10.1768325230576; Tue, 13 Jan 2026
 09:27:10 -0800 (PST)
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260113033113.149842-1-CFSworks@gmail.com>
In-Reply-To: <20260113033113.149842-1-CFSworks@gmail.com>
From: Ilya Dryomov <idryomov@gmail.com>
Date: Tue, 13 Jan 2026 18:26:59 +0100
X-Gm-Features: AZwV_Qi7cxIJDtQUFHkczBrlGxoQzb499y3s3D_qsAMFOWEbfk7kABA1P2MmzRs
Message-ID: <CAOi1vP94Eruq7k10fnpA7G+LjEHdxxFvL4jnTeLMqfoxnjrTkw@mail.gmail.com>
Subject: Re: [RFC PATCH] libceph: Handle sparse-read replies lacking data length
To: Sam Edwards <cfsworks@gmail.com>
Cc: Xiubo Li <xiubli@redhat.com>, Jeff Layton <jlayton@kernel.org>, ceph-devel@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Jan 13, 2026 at 4:31=E2=80=AFAM Sam Edwards <cfsworks@gmail.com> wr=
ote:
>
> When the OSD replies to a sparse-read request, but no extents matched
> the read (because the object is empty, the read requested a region
> backed by no extents, ...) it is expected to reply with two 32-bit
> zeroes: one indicating that there are no extents, the other that the
> total bytes read is zero.
>
> In certain circumstances (e.g. on Ceph 19.2.3, when the requested object
> is in an EC pool), the OSD sends back only one 32-bit zero. The
> sparse-read state machine will end up reading something else (such as
> the data CRC in the footer) and get stuck in a retry loop like:
>
>   libceph:  [0] got 0 extents
>   libceph: data len 142248331 !=3D extent len 0
>   libceph: osd0 (1)...:6801 socket error on read
>   libceph: data len 142248331 !=3D extent len 0
>   libceph: osd0 (1)...:6801 socket error on read
>
> This is probably a bug in the OSD, but even so, the kernel must handle
> it to avoid misinterpreting replies and entering a retry loop.

Hi Sam,

Yes, this is definitely a bug in the OSD (and I also see another
related bug in the userspace client code above the OSD...).  The
triggering condition is a sparse read beyond the end of an existing
object on an EC pool.  19.2.3 isn't the problem -- main branch is
affected as well.

If this was one of the common paths, I'd support adding some sort of
a workaround to "handle" this in the kernel client.  However, sparse
reads are pretty useless on EC pools because they just get converted
into regular thick reads.  Sparse reads offer potential benefits only
on replicated pools, but the kernel client doesn't use them by default
there either.  The sparseread mount option that is necessary for the
reproducer to work isn't documented and was added purely for testing
purposes.

>
> Detect this condition when the extent count is zero by checking the
> `payload_len` field of the op reply. If it is only big enough for the
> extent count, conclude that the data length is omitted and skip to the
> next op (which is what the state machine would have done immediately
> upon reading and validating the data length, if it were present).
>
> ---
>
> Hi list,
>
> RFC: This patch is submitted for comment only. I've tested it for about
> 2 weeks now and am satisfied that it prevents the hang, but the current
> approach decodes the entire op reply body while still in the
> data-gathering step, which is suboptimal; feedback on cleaner
> alternatives is welcome!
>
> I have not searched for nor opened a report with Ceph proper; I'd like a
> second pair of eyes to confirm that this is indeed an OSD bug before I
> proceed with that.

Let me know if you want me to file a Ceph tracker ticket on your
behalf.  I have a draft patch for the bug in the OSD and would link it
in the PR, crediting you as a reporter.

>
> Reproducer (Ceph 19.2.3, CephFS with an EC pool already created):
>   mount -o sparseread ... /mnt/cephfs
>   cd /mnt/cephfs
>   mkdir ec/
>   setfattr -n ceph.dir.layout.pool -v 'cephfs-data-ecpool' ec/
>   echo 'Hello world' > ec/sparsely-packed
>   truncate -s 1048576 ec/sparsely-packed
>   # Read from a hole-backed region via sparse read
>   dd if=3Dec/sparsely-packed bs=3D16 skip=3D10000 count=3D1 iflag=3Ddirec=
t | xxd
>   # The read hangs and triggers the retry loop described in the patch
>
> Hope this works,
> Sam
>
> PS: I would also like to write a pair of patches to our messenger v1/v2
> clients to check explicitly that sparse reads consume exactly the number
> of bytes in the data section, as I see there have already been previous
> bugs (including CVE-2023-52636) where the sparse-read machinery gets out
> of sync with the incoming TCP stream. Has this already been proposed?

Not that I'm aware of.  An additional safety net would be welcome as
long as it doesn't end up too invasive of course.

Thanks,

                Ilya

