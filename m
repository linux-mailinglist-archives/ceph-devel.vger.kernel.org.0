Return-Path: <ceph-devel+bounces-1581-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8939993F995
	for <lists+ceph-devel@lfdr.de>; Mon, 29 Jul 2024 17:36:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9009E1C21BF9
	for <lists+ceph-devel@lfdr.de>; Mon, 29 Jul 2024 15:36:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 03B6B158DA0;
	Mon, 29 Jul 2024 15:36:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ionos.com header.i=@ionos.com header.b="WHw1wrHq"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com [209.85.218.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6397F158A3C
	for <ceph-devel@vger.kernel.org>; Mon, 29 Jul 2024 15:36:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722267370; cv=none; b=uFT7BFMEHTyjyJCYXJzldAqT6nMSnkfcenz62Q8s+wERDFbDpdvPFmPEtlW9wt18cbUHTjDqc580dckXk+cAxW6lIa2CHKwLguv3yqelbkwCVJX+TDShXo19572kVv+ZWgCggOUDfye7yFs7AcsFj+uQmhuVn9O55+bo7L/3z34=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722267370; c=relaxed/simple;
	bh=ocxWEMAgXfcr9s1eHy+pgOW2BSzmq6AtWSWNCH4xXoI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=sNXw2xJ1MAXtMM598qStGN+gtnWPVbqHm80SqBrcFAUoKg6w9kxSSZd3ShTFp1/jmlUTVYeYkMnAq75C2owUR+0SdnZSWaZ8H0ptRq6+q54MnYC3EouG1eDnJnWTPPCwWJLk03jjubKlHjCT7EdHGUrBxtuiW+0/LCmeq7WvDSg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ionos.com; spf=pass smtp.mailfrom=ionos.com; dkim=pass (2048-bit key) header.d=ionos.com header.i=@ionos.com header.b=WHw1wrHq; arc=none smtp.client-ip=209.85.218.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ionos.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ionos.com
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-a7ac449a0e6so266896166b.1
        for <ceph-devel@vger.kernel.org>; Mon, 29 Jul 2024 08:36:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google; t=1722267367; x=1722872167; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ocxWEMAgXfcr9s1eHy+pgOW2BSzmq6AtWSWNCH4xXoI=;
        b=WHw1wrHqBPJ+zZ0PwHxGHDESdNdToLjkHGKhRGIlNmWtyaazePZwF/EDa2wM53kczX
         3Jc1bXKHbopbQHJuokvrgQf2087o0rmT8Xh830J+PjbggoJSEFKLPMUx8zBTWPMZ4p9I
         Kp4WnnsoCZODr1zavcojUuoX+1BDrRVYJRmfcg/cjK6EUWuDso8j9i41s2wcteSOszeR
         tRBEpRBKp7eVHZrKx66GoAxuZe7nYALw8xvyLDfhiBsQSk0kUgnGjOftvpf0TiWtO3B7
         rvzQHFs9w5pXIV3TYWxKQwmd3gIxwV+o/RSVS2zXj9Zq5IXo0dv3wqG/XFNAU1aw4eNy
         0jew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722267367; x=1722872167;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ocxWEMAgXfcr9s1eHy+pgOW2BSzmq6AtWSWNCH4xXoI=;
        b=sqoPWKmeOruAsqbjoXsXob5QsGP515IceBPBHecnEvbG2WXwnpmpE953k54aaPRuG5
         pY+bbspSwh50jaFeRGRAtxAZ2H+CkHIVj4jNu9pysHL/nE9XFLg77vcpKCuaJvofecS2
         etrLCuaHdMER1mfCd3hJEVGi5fpblAyO/HCK0TSaEillx+nxi7O9nh73tPUJNCYxAI6L
         H9okt8bTgT5cBogfbYB4Yxzcs1wnu3F9cYZn9VU3phz+2efxDKgR3gYyuhlXSFJCHMtK
         f+a2/lCzsZhxPcG+nVwkzTWAJDtsrVsmjwBYEkWsyi/oLscxUkbKDbJVjs/7JEXRljo6
         5fbA==
X-Forwarded-Encrypted: i=1; AJvYcCVmLG5IK9ZGFJiXV0VaPUA/fO0hMrxgylPBFcN+xoH0xb/kDWOIyTqDZ0ZIJwRF67PLkhVZZGYW8lSm/hhXlWTtD74plW9JaGpdzA==
X-Gm-Message-State: AOJu0Yw+Bg84W/9gcYHOnY/dvu5IGz2paJjYqOX0k1u9/rKa4cnTgTTP
	BTCqORU//eAW1IYFcA3rLOlzBMzfSq4B8FpPBJnrhkVyth8RXDrDu36DeeuZPreoWdxcPRHgddL
	dtcHnH06TE6Cls2/TSZtF9AG+kSHHK6gdFmi6tw==
X-Google-Smtp-Source: AGHT+IFKGWOaf1XB1ZjzjA0Mr1+q4/qtfehNJNYG4kNlUncpGLDTuedMctPdToKvZVjv5J+J5MEk7dLKDeTfIxGpGLI=
X-Received: by 2002:a17:907:7205:b0:a7a:9ca6:527 with SMTP id
 a640c23a62f3a-a7d3ff7cce8mr575337166b.8.1722267366583; Mon, 29 Jul 2024
 08:36:06 -0700 (PDT)
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240729091532.855688-1-max.kellermann@ionos.com> <d03ba5c264de1d3601853d91810108d9897661fb.camel@kernel.org>
In-Reply-To: <d03ba5c264de1d3601853d91810108d9897661fb.camel@kernel.org>
From: Max Kellermann <max.kellermann@ionos.com>
Date: Mon, 29 Jul 2024 17:35:55 +0200
Message-ID: <CAKPOu+8fgsNi3UVfrZQf9WBHwrXq_D=6oauqWJeiOqSeQedgaw@mail.gmail.com>
Subject: Re: [PATCH] fs/netfs/fscache_io: remove the obsolete "using_pgpriv2" flag
To: Jeff Layton <jlayton@kernel.org>
Cc: dhowells@redhat.com, willy@infradead.org, linux-cachefs@redhat.com, 
	linux-fsdevel@vger.kernel.org, ceph-devel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, stable@vger.kernel.org, xiubli@redhat.com, 
	Ilya Dryomov <idryomov@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Jul 29, 2024 at 2:56=E2=80=AFPM Jeff Layton <jlayton@kernel.org> wr=
ote:
> Either way, you can add this to both patches:
>
> Reviewed-by: Jeff Layton <jlayton@kernel.org>

Stop the merge :-)

I just found that my patch introduces another lockup; copy_file_range
locks up this way:

 [<0>] folio_wait_private_2+0xd9/0x140
 [<0>] ceph_write_begin+0x56/0x90
 [<0>] generic_perform_write+0xc0/0x210
 [<0>] ceph_write_iter+0x4e2/0x650
 [<0>] iter_file_splice_write+0x30d/0x550
 [<0>] splice_file_range_actor+0x2c/0x40
 [<0>] splice_direct_to_actor+0xee/0x270
 [<0>] splice_file_range+0x80/0xc0
 [<0>] ceph_copy_file_range+0xbb/0x5b0
 [<0>] vfs_copy_file_range+0x33e/0x5d0
 [<0>] __x64_sys_copy_file_range+0xf7/0x200
 [<0>] do_syscall_64+0x64/0x100
 [<0>] entry_SYSCALL_64_after_hwframe+0x76/0x7e

Turns out that there are still private_2 users left in both fs/ceph
and fs/netfs. My patches fix one problem, but cause another problem.
Too bad!

This leaves me confused again: how shall I fix this? Can all
folio_wait_private_2() calls simply be removed?
This looks like some refactoring gone wrong, and some parts don't make
sense (like netfs and ceph claim ownership of the folio_private
pointer). I could try to fix the mess, but I need to know how this is
meant to be. David, can you enlighten me?

Max

