Return-Path: <ceph-devel+bounces-3490-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id A9B1EB3AA8B
	for <lists+ceph-devel@lfdr.de>; Thu, 28 Aug 2025 21:05:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id BF632188BE31
	for <lists+ceph-devel@lfdr.de>; Thu, 28 Aug 2025 19:05:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0C14C30DD30;
	Thu, 28 Aug 2025 19:05:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Z0U1Iyuy"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61DF2BA4A;
	Thu, 28 Aug 2025 19:05:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756407927; cv=none; b=FCuwimi8KQ9x+R2Cu5kzhRCu+AVLilG+Rd4qiBbOUAGBw7db8ZfUR8gPS2IUkmDJf7WoG2KLTf2V+oG5G4k9DsWW8/dEibA/x9H1dwdWD6DpxBe8Qk/25qzWel2m/LQ4GWgPCxDElpCK3FuF6x4ePY70brIFOp3/kPTQVV8fHxo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756407927; c=relaxed/simple;
	bh=SpsoAYl55zrLHYlbpk4zDAkQFwqQbAw+k16o38jMBO8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=PsefAqYy6s/En6oEIJ3UO1AzEYIF/OCBxgwWlLgupCuUbjS5r9KORkCnzxyAjcOHrFqBFx++Vd9cym36GtlekxPrVSTCfRQoB/ljT+O0b45ySC2rBOQsw95wKAnIF3TBL1EB2/IFR5iJ/kYg+b3mquqrJlJ5bp0iXaQfPn5w0NA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Z0U1Iyuy; arc=none smtp.client-ip=209.85.214.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-24622df0d95so10291485ad.2;
        Thu, 28 Aug 2025 12:05:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756407926; x=1757012726; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rR0+JHs1NacLYH8MYBujXaoNJIKko2mzeDV5ZiP7NL8=;
        b=Z0U1IyuyGQr9/cm/+gFTh4sFW3c7SMZOniLqg8OwS7yv9FPjhwWth+9t3i6STe7qnS
         cuqZ6aVz6HqV5QFdGnoCxqRQFDODH5K6q+KVhxo3HJNhMbifQisqbqkerbAOpB/J2++G
         R/wSa1+TTV4vzbzemwYPE7FUiLH/43DZ7xJVA8fY/7f3BWuY+SkX7VLx1w+tLbgCRKrd
         5tnltDBcip6aiGlGveXVB7NVVl+E0epe84Bwk+PvrfrWs8Eg4M6w2JEQ4CPl4/opGILO
         R/TJuCxf+IvbII4+PokArxDv83yBURdAd1R2H2Iu5MK5Yhk62ZUqe9udCz9+5HBbDzGQ
         0uQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756407926; x=1757012726;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=rR0+JHs1NacLYH8MYBujXaoNJIKko2mzeDV5ZiP7NL8=;
        b=gsp/4WavcpQyyM/NoLu4dAc9Gw8/L4A/TIICqkkAH2PtkCJJqkJAKNVSpqWPa9QCBJ
         1Htwf6Bvjgpr7z+ajbtVXZeSaIueSiYsexON3KbhWZN1Yj/B7hfiQ+cumBKXk0Ke3qmv
         TMi6/fVSb1YoVG0S4h/QLe7epFyrzrgGEN2Yzw4SInWkXEnWTiiKhOKB6tiEwf7BrQax
         SbhwO/vjo/Of45VdqnVPX9FYhnZ8RU1IQi3Sdo21hhzsm8HAiybTGqMBd8fc9HUaKPJF
         g2pdAD5IxebOGaO9oGgKbswMToue+zHc1YlJJ0YV/Kv30tctdW2KY7b7seouKgCW/4Qq
         bFwQ==
X-Forwarded-Encrypted: i=1; AJvYcCWL6OurQszjcnsm96DhskGco7HcYqiHjoICVLqYtCoHk67+lWoOJIpb0DVkuiMw3YHSsRIqwDfwLhfl+c4=@vger.kernel.org, AJvYcCWdGEsx2mE0qX5uulXmg3r5Xc25qIEkkkxIzotYhLHWCQGwJ0WTHgu0vGS1pkruJMrxw/GAroln@vger.kernel.org
X-Gm-Message-State: AOJu0YzI8ZMvO6k3+c2nXmhEtjKVyR4fvb4Tjv8dCgZ2WgYp8wygr0xp
	EMON2b2SMXhxj2TVbDhYpecEDR6y1pd82Ev8arKJEYjge75lfRkAxgBKMx9HNOdUuHC3FcrvBe8
	f/t8fV11dngK06+xRpBk4Gvyavj9+I2w=
X-Gm-Gg: ASbGncvCFtcHQrIidt73A3EGAmkQDki754+R378YhhxqX5dRA5IW01xqD0FmdA3ZHv2
	Ja7O23e2VoVU3JiaWtcLNiv3OKqWQXktlvKuYAI8qhKiTuNLJFweB2/JpaeF2OSTzhUFZ4tApYJ
	3garmQrLIpv+WqdcMN8EnCB6JFFHyGPu8q98bJVo8KATbYzCGkbjmgPf0bgySb11S/LsKXi8xPE
	dZ2xwQ=
X-Google-Smtp-Source: AGHT+IGPUo/IY53+KORmENAfo8Tih/RI8yw4eqrGp9vOFTKkz7K3VNQnsD6zUalN8Z79FHLsYMjvTCe6b9qQMyTO78Q=
X-Received: by 2002:a17:902:d551:b0:248:f211:cd44 with SMTP id
 d9443c01a7336-248f211d045mr31257545ad.48.1756407925546; Thu, 28 Aug 2025
 12:05:25 -0700 (PDT)
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250827181708.314248-1-max.kellermann@ionos.com> <791306ab6884aa732c58ccabd9b89e3fd92d2cb0.camel@ibm.com>
In-Reply-To: <791306ab6884aa732c58ccabd9b89e3fd92d2cb0.camel@ibm.com>
From: Ilya Dryomov <idryomov@gmail.com>
Date: Thu, 28 Aug 2025 21:05:14 +0200
X-Gm-Features: Ac12FXw6ykozFutsbYqGCTH-l1MNV1l9ZWN0X90YhyRSZcdMJonmOpOREm8vhks
Message-ID: <CAOi1vP_pCbVJFG4DqLWGmc6tfzcHvOADt75rryEyaMjtuggcUA@mail.gmail.com>
Subject: Re: [PATCH] fs/ceph/addr: always call ceph_shift_unused_folios_left()
To: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>
Cc: "ceph-devel@vger.kernel.org" <ceph-devel@vger.kernel.org>, 
	"max.kellermann@ionos.com" <max.kellermann@ionos.com>, Xiubo Li <xiubli@redhat.com>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Alex Markuze <amarkuze@redhat.com>, 
	"stable@vger.kernel.org" <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Aug 28, 2025 at 8:55=E2=80=AFPM Viacheslav Dubeyko
<Slava.Dubeyko@ibm.com> wrote:
>
> On Wed, 2025-08-27 at 20:17 +0200, Max Kellermann wrote:
> > The function ceph_process_folio_batch() sets folio_batch entries to
> > NULL, which is an illegal state.  Before folio_batch_release() crashes
> > due to this API violation, the function
> > ceph_shift_unused_folios_left() is supposed to remove those NULLs from
> > the array.
> >
> > However, since commit ce80b76dd327 ("ceph: introduce
> > ceph_process_folio_batch() method"), this shifting doesn't happen
> > anymore because the "for" loop got moved to
> > ceph_process_folio_batch(), and now the `i` variable that remains in
> > ceph_writepages_start() doesn't get incremented anymore, making the
> > shifting effectively unreachable much of the time.
> >
> > Later, commit 1551ec61dc55 ("ceph: introduce ceph_submit_write()
> > method") added more preconditions for doing the shift, replacing the
> > `i` check (with something that is still just as broken):
> >
> > - if ceph_process_folio_batch() fails, shifting never happens
> >
> > - if ceph_move_dirty_page_in_page_array() was never called (because
> >   ceph_process_folio_batch() has returned early for some of various
> >   reasons), shifting never happens
> >
> > - if `processed_in_fbatch` is zero (because ceph_process_folio_batch()
> >   has returned early for some of the reasons mentioned above or
> >   because ceph_move_dirty_page_in_page_array() has failed), shifting
> >   never happens
> >
> > Since those two commits, any problem in ceph_process_folio_batch()
> > could crash the kernel, e.g. this way:
> >
> >  BUG: kernel NULL pointer dereference, address: 0000000000000034
> >  #PF: supervisor write access in kernel mode
> >  #PF: error_code(0x0002) - not-present page
> >  PGD 0 P4D 0
> >  Oops: Oops: 0002 [#1] SMP NOPTI
> >  CPU: 172 UID: 0 PID: 2342707 Comm: kworker/u778:8 Not tainted 6.15.10-=
cm4all1-es #714 NONE
> >  Hardware name: Dell Inc. PowerEdge R7615/0G9DHV, BIOS 1.6.10 12/08/202=
3
> >  Workqueue: writeback wb_workfn (flush-ceph-1)
> >  RIP: 0010:folios_put_refs+0x85/0x140
> >  Code: 83 c5 01 39 e8 7e 76 48 63 c5 49 8b 5c c4 08 b8 01 00 00 00 4d 8=
5 ed 74 05 41 8b 44 ad 00 48 8b 15 b0 >
> >  RSP: 0018:ffffb880af8db778 EFLAGS: 00010207
> >  RAX: 0000000000000001 RBX: 0000000000000000 RCX: 0000000000000003
> >  RDX: ffffe377cc3b0000 RSI: 0000000000000000 RDI: ffffb880af8db8c0
> >  RBP: 0000000000000000 R08: 000000000000007d R09: 000000000102b86f
> >  R10: 0000000000000001 R11: 00000000000000ac R12: ffffb880af8db8c0
> >  R13: 0000000000000000 R14: 0000000000000000 R15: ffff9bd262c97000
> >  FS:  0000000000000000(0000) GS:ffff9c8efc303000(0000) knlGS:0000000000=
000000
> >  CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> >  CR2: 0000000000000034 CR3: 0000000160958004 CR4: 0000000000770ef0
> >  PKRU: 55555554
> >  Call Trace:
> >   <TASK>
> >   ceph_writepages_start+0xeb9/0x1410
> >
> > The crash can be reproduced easily by changing the
> > ceph_check_page_before_write() return value to `-E2BIG`.
> >
>
> I cannot reproduce the crash/issue. If ceph_check_page_before_write() ret=
urns
> `-E2BIG`, then nothing happens. There is no crush and no write operations=
 could
> be processed by file system driver anymore. So, it doesn't look like reci=
pe to
> reproduce the issue. I cannot confirm that the patch fixes the issue with=
out
> clear way to reproduce the issue.
>
> Could you please provide more clear explanation of the issue reproduction=
 path?

Hi Slava,

Was this bit taken into account?

  (Interestingly, the crash happens only if `huge_zero_folio` has
  already been allocated; without `huge_zero_folio`,
  is_huge_zero_folio(NULL) returns true and folios_put_refs() skips NULL
  entries instead of dereferencing them.  That makes reproducing the bug
  somewhat unreliable.  See
  https://lore.kernel.org/20250826231626.218675-1-max.kellermann@ionos.com
  for a discussion of this detail.)

Thanks,

                Ilya

