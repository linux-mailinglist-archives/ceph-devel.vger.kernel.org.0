Return-Path: <ceph-devel+bounces-3556-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B823EB48A37
	for <lists+ceph-devel@lfdr.de>; Mon,  8 Sep 2025 12:32:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6F62D3B11CB
	for <lists+ceph-devel@lfdr.de>; Mon,  8 Sep 2025 10:32:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 44CCC2E8E12;
	Mon,  8 Sep 2025 10:32:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="AUmEndsA"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-pg1-f182.google.com (mail-pg1-f182.google.com [209.85.215.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82BCD2139C9;
	Mon,  8 Sep 2025 10:32:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757327566; cv=none; b=ueGSkdzxoWDQIahbQsxDihP5LnN3kF4Xjher9lTmsgG+dGGiBcJxxZuB7TclCZLlk43gt+ynQnPNgjumBUtKFN7ZUDBuaE7oxVheFUvnGZqk661DcItA7YGga0ZJXR2KhSSpxPOu/zl2co7th/CQfQIgx0rsbtbwABPwWpXT5Zk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757327566; c=relaxed/simple;
	bh=+4XO0knlLrDUm9FG6npOceWMdlhrXtwcdX+lziaslZU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=m2fsYo5Fd4ApabJXC1g1FyC2MSQAC0rXKMS6dATRCtPSnd4Pow1wECydYE36ashth2ACQN3hW9EjFIvIRMC2n89EfOmTDa1qUb24D8aKW6MviNU/jMwyvR6ifFHmZNenbmlm6/LjrYsLpyZIXzX+1NPM3IYVh1pvC8KYg6SGhSg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=AUmEndsA; arc=none smtp.client-ip=209.85.215.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pg1-f182.google.com with SMTP id 41be03b00d2f7-b4f7053cc38so2612270a12.2;
        Mon, 08 Sep 2025 03:32:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757327564; x=1757932364; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3cF6c5wTxHhL2DgZqdn/ZJz8KkLWRy+JzuRme29y/+g=;
        b=AUmEndsAI9xRz/FWuYArd0SJQl7H51eaVsm+1RV15OmHDLxCvjGfd59ia3mt07cb1l
         4Bd+1rJikwVCBOt5SdVxoFPO4Aq6ch+aY2DJphDc7861JhKw9z0pzOUadFt7SW9r00gE
         ofaKxZuNn9qg/e0uz4RhRFh06UwDLNJhGEVcSKP6UD9GUdYv4mK9agCd7qxIDSCJPvnl
         u7SNTd0pSnRtlLCvV5z9GNI8NBBwhW1nFmauF9R06PF1Lut6ETPzK7S999ILnJR27Utl
         rWksrvj0dI9c0TsqSNX24D9E4vUhB3lzjQp3TLfHnV0AZAZeGOA8GZwH1r1fJOo1tdIT
         Y//w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757327564; x=1757932364;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=3cF6c5wTxHhL2DgZqdn/ZJz8KkLWRy+JzuRme29y/+g=;
        b=MqTrxM/M5c2ER8mNXYsEpQ87nVToPe3AhyKNHhuFKU5G0K3vpgH++/N4itNFc38CYe
         UzxgGmivXMRUcm8p1gtrO0g3OSFkuuvE98HOFrsR8seust3OD7dVeScrPyKhHFbmMZbe
         kbMu6XqLRlddEtC8Zo+KuoACtygGiLPyOT3ckENbBjeJJb4d5ByZ2ISdFSnLZU8jzFqc
         WbkvNlFf0B8rgujHbNHL7J/XdYVSLxwQzAZC7vUg2X2wzTQeR7uBKIMPCyU7+MfHPCzK
         IDg5Ot//m4bWgV5MlaYYl9UoL/m82vPGBs7OQ7LMdIFwBVmcqLJoKNS5wZXNW4WgAcok
         /yEA==
X-Forwarded-Encrypted: i=1; AJvYcCU4D/63nATBpd4qBwFO6ih547mpST/CETw76sVc8RU5oY1EKX6HxogCY2AqJahTTIQXZV41nNCN@vger.kernel.org, AJvYcCUEg38JnAA7y83oMW7X/HCr07FlivaBmvKO7OcpHTalpzIxGls6O/MZbaSSlnraH3ncZaIKMgiSYDaE9hKn@vger.kernel.org, AJvYcCVpNp61pBQuwnY0bIWPhMj+1yTzlvv0DkBx5oHTJDAt0XRDYVOYDtVx9PGC6QIXBthdOJp5srrUME7w@vger.kernel.org
X-Gm-Message-State: AOJu0YxKSdB14J0eLM3PHywrcZOLHnTGLQ/d/fpJc9D0zfHmOtv9twwx
	GEAYrKbsvKt6Cp+MUSQiBVg92dvXIvCOYC6vkkAXwPjWcFo0azCg2sarcx7lpQGtFJ/79UEzimC
	rWnneZnMQ48AmN++dYtmUzEeJKmLYVV8=
X-Gm-Gg: ASbGncs9N5TwPO1zBtT5tXJzwhYF2+qUxPRWMxah4ZfeEwtUdRYIKhIOX0VrhjvmhAf
	PPgPwR5cueD6t8QQqHDCam2NOKyeJEzVkfXj9oOHOUE+vtayduoaqkSmDnyV+15igeu1YthM+XZ
	dGcG6rjO97DYD2oVLd77eDL3V6fQ2xb2xgA12lu1+YMJg1sAruO1jOFM/w1pa1skNhgxBrFo4L/
	A83BL4Xm+9BPLNWGQ==
X-Google-Smtp-Source: AGHT+IHnJH0N3/loIyJTaAozc9HWxoZ/j+TmmvLppTeugA1WCtp61zAydIK8CV2uDM+K4H8jhTvQGAx7KS+i3dGnUm8=
X-Received: by 2002:a17:90b:3904:b0:32b:6132:5f94 with SMTP id
 98e67ed59e1d1-32d43f95d02mr10710949a91.21.1757327563647; Mon, 08 Sep 2025
 03:32:43 -0700 (PDT)
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250827181708.314248-1-max.kellermann@ionos.com>
In-Reply-To: <20250827181708.314248-1-max.kellermann@ionos.com>
From: Ilya Dryomov <idryomov@gmail.com>
Date: Mon, 8 Sep 2025 12:32:31 +0200
X-Gm-Features: Ac12FXybpA5tBFjqghr21v3E3Fpl48u7LFv5vyCLmT49bpExp3yxEYVGfIZVWc4
Message-ID: <CAOi1vP-uiSHW-3vTQXdBCWH25sUgiWVK4UvF2APsGM1QNpNqFw@mail.gmail.com>
Subject: Re: [PATCH] fs/ceph/addr: always call ceph_shift_unused_folios_left()
To: Max Kellermann <max.kellermann@ionos.com>
Cc: Slava.Dubeyko@ibm.com, xiubli@redhat.com, amarkuze@redhat.com, 
	ceph-devel@vger.kernel.org, linux-kernel@vger.kernel.org, 
	stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Aug 27, 2025 at 8:17=E2=80=AFPM Max Kellermann <max.kellermann@iono=
s.com> wrote:
>
> The function ceph_process_folio_batch() sets folio_batch entries to
> NULL, which is an illegal state.  Before folio_batch_release() crashes
> due to this API violation, the function
> ceph_shift_unused_folios_left() is supposed to remove those NULLs from
> the array.
>
> However, since commit ce80b76dd327 ("ceph: introduce
> ceph_process_folio_batch() method"), this shifting doesn't happen
> anymore because the "for" loop got moved to
> ceph_process_folio_batch(), and now the `i` variable that remains in
> ceph_writepages_start() doesn't get incremented anymore, making the
> shifting effectively unreachable much of the time.
>
> Later, commit 1551ec61dc55 ("ceph: introduce ceph_submit_write()
> method") added more preconditions for doing the shift, replacing the
> `i` check (with something that is still just as broken):
>
> - if ceph_process_folio_batch() fails, shifting never happens
>
> - if ceph_move_dirty_page_in_page_array() was never called (because
>   ceph_process_folio_batch() has returned early for some of various
>   reasons), shifting never happens
>
> - if `processed_in_fbatch` is zero (because ceph_process_folio_batch()
>   has returned early for some of the reasons mentioned above or
>   because ceph_move_dirty_page_in_page_array() has failed), shifting
>   never happens
>
> Since those two commits, any problem in ceph_process_folio_batch()
> could crash the kernel, e.g. this way:
>
>  BUG: kernel NULL pointer dereference, address: 0000000000000034
>  #PF: supervisor write access in kernel mode
>  #PF: error_code(0x0002) - not-present page
>  PGD 0 P4D 0
>  Oops: Oops: 0002 [#1] SMP NOPTI
>  CPU: 172 UID: 0 PID: 2342707 Comm: kworker/u778:8 Not tainted 6.15.10-cm=
4all1-es #714 NONE
>  Hardware name: Dell Inc. PowerEdge R7615/0G9DHV, BIOS 1.6.10 12/08/2023
>  Workqueue: writeback wb_workfn (flush-ceph-1)
>  RIP: 0010:folios_put_refs+0x85/0x140
>  Code: 83 c5 01 39 e8 7e 76 48 63 c5 49 8b 5c c4 08 b8 01 00 00 00 4d 85 =
ed 74 05 41 8b 44 ad 00 48 8b 15 b0 >
>  RSP: 0018:ffffb880af8db778 EFLAGS: 00010207
>  RAX: 0000000000000001 RBX: 0000000000000000 RCX: 0000000000000003
>  RDX: ffffe377cc3b0000 RSI: 0000000000000000 RDI: ffffb880af8db8c0
>  RBP: 0000000000000000 R08: 000000000000007d R09: 000000000102b86f
>  R10: 0000000000000001 R11: 00000000000000ac R12: ffffb880af8db8c0
>  R13: 0000000000000000 R14: 0000000000000000 R15: ffff9bd262c97000
>  FS:  0000000000000000(0000) GS:ffff9c8efc303000(0000) knlGS:000000000000=
0000
>  CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>  CR2: 0000000000000034 CR3: 0000000160958004 CR4: 0000000000770ef0
>  PKRU: 55555554
>  Call Trace:
>   <TASK>
>   ceph_writepages_start+0xeb9/0x1410
>
> The crash can be reproduced easily by changing the
> ceph_check_page_before_write() return value to `-E2BIG`.
>
> (Interestingly, the crash happens only if `huge_zero_folio` has
> already been allocated; without `huge_zero_folio`,
> is_huge_zero_folio(NULL) returns true and folios_put_refs() skips NULL
> entries instead of dereferencing them.  That makes reproducing the bug
> somewhat unreliable.  See
> https://lore.kernel.org/20250826231626.218675-1-max.kellermann@ionos.com
> for a discussion of this detail.)
>
> My suggestion is to move the ceph_shift_unused_folios_left() to right
> after ceph_process_folio_batch() to ensure it always gets called to
> fix up the illegal folio_batch state.
>
> Fixes: ce80b76dd327 ("ceph: introduce ceph_process_folio_batch() method")
> Link: https://lore.kernel.org/ceph-devel/aK4v548CId5GIKG1@swift.blarg.de/
> Cc: stable@vger.kernel.org
> Signed-off-by: Max Kellermann <max.kellermann@ionos.com>
> ---
>  fs/ceph/addr.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
>
> diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
> index 8b202d789e93..8bc66b45dade 100644
> --- a/fs/ceph/addr.c
> +++ b/fs/ceph/addr.c
> @@ -1687,6 +1687,7 @@ static int ceph_writepages_start(struct address_spa=
ce *mapping,
>
>  process_folio_batch:
>                 rc =3D ceph_process_folio_batch(mapping, wbc, &ceph_wbc);
> +               ceph_shift_unused_folios_left(&ceph_wbc.fbatch);
>                 if (rc)
>                         goto release_folios;
>
> @@ -1695,8 +1696,6 @@ static int ceph_writepages_start(struct address_spa=
ce *mapping,
>                         goto release_folios;
>
>                 if (ceph_wbc.processed_in_fbatch) {
> -                       ceph_shift_unused_folios_left(&ceph_wbc.fbatch);
> -
>                         if (folio_batch_count(&ceph_wbc.fbatch) =3D=3D 0 =
&&
>                             ceph_wbc.locked_pages < ceph_wbc.max_pages) {
>                                 doutc(cl, "reached end fbatch, trying for=
 more\n");
> --
> 2.47.2
>

Queued up for 6.17-rc6.

Thanks,

                Ilya

