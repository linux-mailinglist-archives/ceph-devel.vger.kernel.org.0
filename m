Return-Path: <ceph-devel+bounces-4260-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 0A838CF6ED8
	for <lists+ceph-devel@lfdr.de>; Tue, 06 Jan 2026 07:52:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 9F3CA30155FF
	for <lists+ceph-devel@lfdr.de>; Tue,  6 Jan 2026 06:52:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1BB9D3009C1;
	Tue,  6 Jan 2026 06:52:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ZjFae/BG"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com [209.85.221.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF19E2248B3
	for <ceph-devel@vger.kernel.org>; Tue,  6 Jan 2026 06:52:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767682343; cv=none; b=PdA5mBpOesly1cHJaVH6OgyI6t5OeUvCs2rosOhTTpjmnHTDGH/OJQx3F6AhoDRCa6Ohwa7mXURRnK0MWWyZr+N8yqwMkLJASmd02gr8JbqGs7VdNt/78sH3ZWyF887QtH3UnovwG76OtvqbNG13GUU1jWeyKbmn3P+824PcgMY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767682343; c=relaxed/simple;
	bh=9Cw86CX0Dci1mnYLZkNN+CeP0LIAhYvokNBtfKQI0Nw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=hoO1OSOTEonadtRav9/Qoc9qoLSh0dkuhcOuAh+i1Q0Dba03txqpkIu5fF2JVixop2b6x8nJuethjHRh6gv5cOqwEMRNojZ47fYXHpkiKnq8p3MJyTrfIAY2GAmM6OxMKVVu84+484NhMOl3DEGveS4+PSzzyRq6H9BBOegjvEc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ZjFae/BG; arc=none smtp.client-ip=209.85.221.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f53.google.com with SMTP id ffacd0b85a97d-42fb6ce71c7so409631f8f.1
        for <ceph-devel@vger.kernel.org>; Mon, 05 Jan 2026 22:52:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1767682340; x=1768287140; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=a5MbjTHPCVCDNqoOckwZhtsYdIa3XvI/J5e476w1Ly4=;
        b=ZjFae/BGABzOds5GfoWGEG9XcMfO/Enf4ExBUwZT3JKNiYLdxSLynd5nNzgCAfYSM5
         emsIvW5uEP6eSY+zd18hhiGdihWS78/MZh9/bfn4ieVl5JLKE1k47KvaPYzSnk+g5qnw
         OamgCwoI0pSCOkAbiC7Zk4nZKRGqZ1m6ZkeBSzIbuNlmcqQfqdXbA1vsQHKcbvLchsus
         /qrPW71Cd9+1P0XvZF6ROwUhboEsTN2JrTQyEKSNgiazCc4p8qClhs+uVdRx6J8ZxT1J
         dinhgPiZ5ILSXGdg4tqo2pGRCeNeEqVVc1zsJwvzsL31L8GztU73BYOjU5lPwsuJaBRY
         J9FA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767682340; x=1768287140;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=a5MbjTHPCVCDNqoOckwZhtsYdIa3XvI/J5e476w1Ly4=;
        b=LODgJJO1fXh5F9girGLMUFikDT+WgG8/Up0tfcmkrDIUi4VRAcl1KkNK2JVSjMhuic
         S14sAQ8RS2ERQUwRmzoL8xf06FGukwWQIFt03LiRxicNevOWujcuQ6oPxgXcqMhqkR2V
         sb3LcrzkUp4jXh/wnxPJR3sYx3EjszQSOI9ZMeEZZN0eX7IbtaciKxvJWOZQ6ydZpAmP
         wW337pgGEmzFf/NO0rvIEOjZxcNorTrSA2t3uG/uVGIuSRNHmETdjnSGLoiwQ6tKp0DE
         AipvJ5CN8tHiJJxFeSkBHPj7TOOvqAnn18bYNQTA+94AzA08OwEreM5pSkSn0x3xmdyd
         gFvg==
X-Forwarded-Encrypted: i=1; AJvYcCVb9fg6FUY2aj8hDVLYtSq8Hv7ydI04CEyp5cyKTWnjrQsxunFWVur/IzCA1qVX/oaJMP5huIUTCUVN@vger.kernel.org
X-Gm-Message-State: AOJu0YwhhDbs3JN9AKAIXpZXt/4KL/B43Y+eXWAT5zLzdCdI3HIMkPBE
	5cbvrH2hJwa60U6kWUWAKlwQeWHfClYRpArabGMvF+T2aecXveZpWricFlgQHhUzZQoBSRHzgZY
	h8dcmUJXE9SKl+R4FMv4nNzg7uDlwcIE=
X-Gm-Gg: AY/fxX6wCuMvAaDUDw25in8Bc+ayaNFoqtI7biCDsQtAnCv+sJ3UbV76PpzZ73mT+Rg
	jAAqaq8IDCZ7w4+apRmXwX6yc8yNQmtFXw4RpI+bJzJO1dUpX7yEmHamdIVd0PEh/Omz1lKQHoI
	jfUD0nb++H1VwBlcPPsqDVt91y9kjN5pShSppfQWiPT2xdmOe5D7CdLNfrajTeDFmszwYw6QSyo
	4jQgYCjw5lX+CLGYm2+yn4+YxyqgoFegnITrUYvVn/+bldRURVNLupB6sRafsrYA/YbNOouDlW3
	NrzjJvTbrHh9HqXis6tLwkVNuAsz
X-Google-Smtp-Source: AGHT+IEwY7f43Mq2osMvDOQZjAjOg6y4nxe8jcr9nGSLJUpcrEWhLOs46bxfR7AfUXsae8GTxGfxj8WFRO3TzUfdp5M=
X-Received: by 2002:a05:6000:310c:b0:430:b100:f591 with SMTP id
 ffacd0b85a97d-432bc9d9128mr2322950f8f.28.1767682339754; Mon, 05 Jan 2026
 22:52:19 -0800 (PST)
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251231024316.4643-1-CFSworks@gmail.com> <20251231024316.4643-2-CFSworks@gmail.com>
 <24adfb894c25531d342fdc20310ca9286d605e3d.camel@ibm.com>
In-Reply-To: <24adfb894c25531d342fdc20310ca9286d605e3d.camel@ibm.com>
From: Sam Edwards <cfsworks@gmail.com>
Date: Mon, 5 Jan 2026 22:52:07 -0800
X-Gm-Features: AQt7F2qdUUpXyURjPb1fuUeAHQtsYXnqOL0vDFAcXJSkfDM9w4GJZdn6dtJNEBo
Message-ID: <CAH5Ym4gHTNDVCiy5YQwQwg_JmBt=UKgoui9RzUcBgv6Vr-ezZw@mail.gmail.com>
Subject: Re: [PATCH 1/5] ceph: Do not propagate page array emplacement errors
 as batch errors
To: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>
Cc: Xiubo Li <xiubli@redhat.com>, "idryomov@gmail.com" <idryomov@gmail.com>, 
	Milind Changire <mchangir@redhat.com>, "stable@vger.kernel.org" <stable@vger.kernel.org>, 
	"ceph-devel@vger.kernel.org" <ceph-devel@vger.kernel.org>, "brauner@kernel.org" <brauner@kernel.org>, 
	"jlayton@kernel.org" <jlayton@kernel.org>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Jan 5, 2026 at 12:24=E2=80=AFPM Viacheslav Dubeyko
<Slava.Dubeyko@ibm.com> wrote:
>
> On Tue, 2025-12-30 at 18:43 -0800, Sam Edwards wrote:
> > When fscrypt is enabled, move_dirty_folio_in_page_array() may fail
> > because it needs to allocate bounce buffers to store the encrypted
> > versions of each folio. Each folio beyond the first allocates its bounc=
e
> > buffer with GFP_NOWAIT. Failures are common (and expected) under this
> > allocation mode; they should flush (not abort) the batch.
> >
> > However, ceph_process_folio_batch() uses the same `rc` variable for its
> > own return code and for capturing the return codes of its routine calls=
;
> > failing to reset `rc` back to 0 results in the error being propagated
> > out to the main writeback loop, which cannot actually tolerate any
> > errors here: once `ceph_wbc.pages` is allocated, it must be passed to
> > ceph_submit_write() to be freed. If it survives until the next iteratio=
n
> > (e.g. due to the goto being followed), ceph_allocate_page_array()'s
> > BUG_ON() will oops the worker. (Subsequent patches in this series make
> > the loop more robust.)
>

Hi Slava,

> I think you are right with the fix. We have the loop here and if we alrea=
dy
> moved some dirty folios, then we should flush it. But what if we failed o=
n the
> first one folio, then should we return no error code in this case?

The case you ask about, where move_dirty_folio_in_page_array() returns
an error for the first folio, is currently not possible:
1) The only error code that move_dirty_folio_in_page_array() can
propagate is from fscrypt_encrypt_pagecache_blocks(), which it calls
with GFP_NOFS for the first folio. The latter function's doc comment
outright states:
 * The bounce page allocation is mempool-backed, so it will always succeed =
when
 * @gfp_flags includes __GFP_DIRECT_RECLAIM, e.g. when it's GFP_NOFS.
2) The error return isn't even reachable for the first folio because
of the BUG_ON(ceph_wbc->locked_pages =3D=3D 0); line.

>
> >
> > Note that this failure mode is currently masked due to another bug
> > (addressed later in this series) that prevents multiple encrypted folio=
s
> > from being selected for the same write.
>
> So, maybe, this patch has been not correctly placed in the order?

This crash is unmasked by patch 5 of this series. (It allows multiple
folios to be batched when fscrypt is enabled.) Patch 5 has no hard
dependency on anything else in this series, so it could -- in
principle -- be ordered first as you suggest. However, that ordering
would deliberately cause a regression in kernel stability, even if
only briefly. That's not considered good practice in my view, as it
may affect people who are trying to bisect and regression test. So the
ordering of this series is: fix the crash in the unused code first,
then fix the bug that makes it unused.

> It will be
> good to see the reproduction of the issue and which symptoms we have for =
this
> issue. Do you have the reproduction script and call trace of the issue?

Fair point!

Function inlining makes the call trace not very interesting:
Call trace:
 ceph_writepages_start+0x16ec/0x18e0 [ceph] ()
 do_writepages+0xb0/0x1c0
 __writeback_single_inode+0x4c/0x4d8
 writeback_sb_inodes+0x238/0x4c8
 __writeback_inodes_wb+0x64/0x120
 wb_writeback+0x320/0x3e8
 wb_workfn+0x42c/0x518
 process_one_work+0x17c/0x428
 worker_thread+0x260/0x390
 kthread+0x148/0x240
 ret_from_fork+0x10/0x20
Code: 34ffdee0 52800020 3903e7e0 17fffef4 (d4210000)
---[ end trace 0000000000000000 ]---
Kernel panic - not syncing: Oops - BUG: Fatal exception

ceph_writepages_start+0x16ec corresponds to linux-6.18.2/fs/ceph/addr.c:122=
2

However, these repro steps should work:
1) Apply patch 5 from this series (and no other patches)
2) Mount CephFS and activate fscrypt
3) Copy a large directory into the CephFS mount
4) After dozens of GBs transferred, you should observe the above kernel oop=
s

Warm regards,
Sam




>
> >
> > For now, just reset `rc` when redirtying the folio and prevent the
> > error from propagating. After this change, ceph_process_folio_batch() n=
o
> > longer returns errors; its only remaining failure indicator is
> > `locked_pages =3D=3D 0`, which the caller already handles correctly. Th=
e
> > next patch in this series addresses this.
> >
> > Fixes: ce80b76dd327 ("ceph: introduce ceph_process_folio_batch() method=
")
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Sam Edwards <CFSworks@gmail.com>
> > ---
> >  fs/ceph/addr.c | 1 +
> >  1 file changed, 1 insertion(+)
> >
> > diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
> > index 63b75d214210..3462df35d245 100644
> > --- a/fs/ceph/addr.c
> > +++ b/fs/ceph/addr.c
> > @@ -1369,6 +1369,7 @@ int ceph_process_folio_batch(struct address_space=
 *mapping,
> >               rc =3D move_dirty_folio_in_page_array(mapping, wbc, ceph_=
wbc,
> >                               folio);
> >               if (rc) {
> > +                     rc =3D 0;
>
> I like the fix but I would like to clarify the above questions at first.
>
> Thanks,
> Slava.
>
> >                       folio_redirty_for_writepage(wbc, folio);
> >                       folio_unlock(folio);
> >                       break;

