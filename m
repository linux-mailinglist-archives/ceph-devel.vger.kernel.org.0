Return-Path: <ceph-devel+bounces-4274-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 5C570CFB632
	for <lists+ceph-devel@lfdr.de>; Wed, 07 Jan 2026 00:50:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id E7EB4301CE96
	for <lists+ceph-devel@lfdr.de>; Tue,  6 Jan 2026 23:50:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9B6AE3191A9;
	Tue,  6 Jan 2026 23:50:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="a13CKHA0"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4616C2DE709
	for <ceph-devel@vger.kernel.org>; Tue,  6 Jan 2026 23:50:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767743417; cv=none; b=A1E0n8UL8BQloNLDoN/2h8UV54/mnLCvlPwI4b0qRE2MFArOuRohyw1dGptDC9gwEgGEcKq3yF0/So5ij/rvGqo0sZgnuM2Wv11E296lgtDbAWlglozvyuH8bdC+dahmBocuKwE6jbtf3M2AXZznM/dnR0Xaqa69oaND5DmNfGI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767743417; c=relaxed/simple;
	bh=9pVQgCdDn8H1/KOJLR9DY65laCZkAZ0jcuwH6GmgDGs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=jfVZHpW5D2+9GFfimqwyH2wiNvVAW5cpsnToSKpqINLgNuKP4oCYhiiSFafxh/t1+M4q100sz2ShSbw6abflIcE0gg+95xcbWUteq0kDIrZtH7GP2ww+/AGTb3yzKGc26c7Zn7nkgiEE0+Ah7tEuI6z19H7pHz/Z4iMDJcx0kiA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=a13CKHA0; arc=none smtp.client-ip=209.85.221.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-43260a5a096so973179f8f.0
        for <ceph-devel@vger.kernel.org>; Tue, 06 Jan 2026 15:50:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1767743412; x=1768348212; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pvoqbHBwcqaTfoJ83m8uYX7jZL+xrMk2XFXjpOm3W9I=;
        b=a13CKHA0pXthyko2v4/dXOxF5fYdAWKTRxVHrCy66rDVgoP7/aK0xI52z9wDh8AqzM
         vIli/+QGuC0L44AIeWcgx7s1eb3g38z6wdLAwwGeXMiv0p4RWyTAsVAj8fw/mHSZYp1y
         5E32LQ1+fxKcNn4uFY8WLMOFy22tBThcF+tbl6KSJCg2xrs7iM2B+UULP2a/5pX9nIy9
         mPDgjGg0HXjfV65u1KpUElEXvgMmrUKpXhtEw18qx0RQgYXLCe50BA7fVgm4sDEQ30E6
         rzmpXwqYOY6aYjtJXKn87FB/H2wBZJn1T0COWxgEqUbVB5O0lknFP0io69bZI8Hhec7Q
         wPwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767743412; x=1768348212;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=pvoqbHBwcqaTfoJ83m8uYX7jZL+xrMk2XFXjpOm3W9I=;
        b=PxVy8cZa95P05mVz5YHFIOWx5j0p1pzI0oCbngH1topDWLfYlx/3U24H41d1UgA0WK
         mbNfDm0qOur3ZwuZEQVEZ5GPEj87lw3tAI7iy4dzvldJgGWtAltqOKA37qyda71Ataay
         KU6Yosz96hy/lghF1XaiMVdI2bab+eNC1l5pLDfsUS9Y2v/SF0BTayU/09v7vUPvGkS5
         0BGTP3ImB0Ql1tgrICgEKMImKtYwDVdvcbxekXo0VrJGrrZRTO4L0YA7DRdP/irTdYtJ
         9ul4diGUksyHTgUbKCBrblyUiz2tVAmfYJZ9tvxEg71m5hIKmtn198ShJ5sOHotW6lM7
         +z8w==
X-Forwarded-Encrypted: i=1; AJvYcCUxBH9NY0Yo53oqLWxKK6ILqO7q6KVq/hm4hT+tUEmLBbJv0CKrcAoaxMbphQZ0YDWHZtHBEbqRg3mN@vger.kernel.org
X-Gm-Message-State: AOJu0YyXzGMAz6R0B+4DpNxm/FVJllABvY7R2CKpe3eqnrSnXOfSoiUI
	mdGxjMxui/UfOzQgdV6VuUkQwGlcvDbPhAXleT72qNF10gg2Kbz8nLRZo0sXLL7eDMMDduJCVLa
	/nb6LatN1WwDXpjbiGG8kidIfEhVjjBI=
X-Gm-Gg: AY/fxX6FLRCzhaQ7ICUnhYM2C4Q9X7//PNGCydQRe2iFtt9VwsH5sqhfmEKqiPJlKsH
	q7it6drhBJsSuZa2yFfqex/vIFlHXH9pVMVxhzMg1rtKExlD/yD3ZUR9UoY0IGGfHqDt6sqzmvK
	dTCGbNCH61Vu04qOYcphh8eIgL9m/NPg+3Vqiw+BX648P/XFHqpKs5Ji5voxzxlqt1pY0UGPjsM
	vzwsd7XjF75iB4r6uBx7J5dEkg/AoCDaJzk3bNdinFLAhZj6JP9++gFTyf0TseLFA8qvEvGWOjT
	s7rgnX+Zkp8XhuXfBrzoX6tog4Tu
X-Google-Smtp-Source: AGHT+IHpzaQ5J6l9HxCiQdfNYjUyRE7zi7ZdyAX/VCqmW8aXxVLlZ8XCA8qlHdzC4g5L9H0kOhHdIYHWKNWTcO1AvbM=
X-Received: by 2002:a05:6000:2511:b0:430:f454:84ae with SMTP id
 ffacd0b85a97d-432c38d27b6mr763817f8f.63.1767743412266; Tue, 06 Jan 2026
 15:50:12 -0800 (PST)
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251231024316.4643-1-CFSworks@gmail.com> <20251231024316.4643-2-CFSworks@gmail.com>
 <24adfb894c25531d342fdc20310ca9286d605e3d.camel@ibm.com> <CAH5Ym4gHTNDVCiy5YQwQwg_JmBt=UKgoui9RzUcBgv6Vr-ezZw@mail.gmail.com>
 <8d8860371bcf4db044a8e1559b674189996c0790.camel@ibm.com>
In-Reply-To: <8d8860371bcf4db044a8e1559b674189996c0790.camel@ibm.com>
From: Sam Edwards <cfsworks@gmail.com>
Date: Tue, 6 Jan 2026 15:50:01 -0800
X-Gm-Features: AQt7F2qYZc7ZWiCwPIKfMFwfJe0FxD1QtL6RWI2gMzCvDWSaHt8htq0pxnXlM-8
Message-ID: <CAH5Ym4h7CkX6HEukguzbgjPcr6mpUZn8Rcf55m7B=YXYpomLXg@mail.gmail.com>
Subject: Re: [PATCH 1/5] ceph: Do not propagate page array emplacement errors
 as batch errors
To: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>
Cc: Xiubo Li <xiubli@redhat.com>, "brauner@kernel.org" <brauner@kernel.org>, 
	"ceph-devel@vger.kernel.org" <ceph-devel@vger.kernel.org>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "jlayton@kernel.org" <jlayton@kernel.org>, 
	Milind Changire <mchangir@redhat.com>, "idryomov@gmail.com" <idryomov@gmail.com>, 
	"stable@vger.kernel.org" <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Jan 6, 2026 at 1:08=E2=80=AFPM Viacheslav Dubeyko <Slava.Dubeyko@ib=
m.com> wrote:
>
> On Mon, 2026-01-05 at 22:52 -0800, Sam Edwards wrote:
> > On Mon, Jan 5, 2026 at 12:24=E2=80=AFPM Viacheslav Dubeyko
> > <Slava.Dubeyko@ibm.com> wrote:
> > >
> > > On Tue, 2025-12-30 at 18:43 -0800, Sam Edwards wrote:
> > > > When fscrypt is enabled, move_dirty_folio_in_page_array() may fail
> > > > because it needs to allocate bounce buffers to store the encrypted
> > > > versions of each folio. Each folio beyond the first allocates its b=
ounce
> > > > buffer with GFP_NOWAIT. Failures are common (and expected) under th=
is
> > > > allocation mode; they should flush (not abort) the batch.
> > > >
> > > > However, ceph_process_folio_batch() uses the same `rc` variable for=
 its
> > > > own return code and for capturing the return codes of its routine c=
alls;
> > > > failing to reset `rc` back to 0 results in the error being propagat=
ed
> > > > out to the main writeback loop, which cannot actually tolerate any
> > > > errors here: once `ceph_wbc.pages` is allocated, it must be passed =
to
> > > > ceph_submit_write() to be freed. If it survives until the next iter=
ation
> > > > (e.g. due to the goto being followed), ceph_allocate_page_array()'s
> > > > BUG_ON() will oops the worker. (Subsequent patches in this series m=
ake
> > > > the loop more robust.)
> > >
> >
> > Hi Slava,
> >
> > > I think you are right with the fix. We have the loop here and if we a=
lready
> > > moved some dirty folios, then we should flush it. But what if we fail=
ed on the
> > > first one folio, then should we return no error code in this case?
> >
> > The case you ask about, where move_dirty_folio_in_page_array() returns
> > an error for the first folio, is currently not possible:
> > 1) The only error code that move_dirty_folio_in_page_array() can
> > propagate is from fscrypt_encrypt_pagecache_blocks(), which it calls
> > with GFP_NOFS for the first folio. The latter function's doc comment
> > outright states:
> >  * The bounce page allocation is mempool-backed, so it will always succ=
eed when
> >  * @gfp_flags includes __GFP_DIRECT_RECLAIM, e.g. when it's GFP_NOFS.
> > 2) The error return isn't even reachable for the first folio because
> > of the BUG_ON(ceph_wbc->locked_pages =3D=3D 0); line.
> >
>

Good day Slava,

> Unfortunately, the kernel code is not something completely stable. We can=
not
> rely on particular state of the code. The code should be stable, robust e=
nough,
> and ready for different situations.

You describe "defensive programming." I fully agree and am a strong
advocate for it, but each defensive measure comes with a complexity
cost. A skilled defensive programmer evaluates the likelihood of each
failure and invests that cost only where it's most warranted.

> The mentioned BUG_ON() could be removed
> somehow during refactoring because we already have comment there "better =
not
> fail on first page!".

If the question is "What happens if the first folio fails when the
BUG_ON is removed?" then my answer is: that is the responsibility of
the person removing it. I am leaving the BUG_ON() in place.

> Also, the behavior of fscrypt_encrypt_pagecache_blocks()
> could be changed too.

Changing that would alter the contract of
fscrypt_encrypt_pagecache_blocks(). Contracts can evolve, but anyone
making such a change must audit all call sites to ensure nothing
breaks. Today, this is purely hypothetical; the function is not being
changed. Speculating about behavior under a different, unimplemented
contract is not a basis for complicating the current code.

> So, we need to expect any bad situation and this is why I
> prefer to manage such potential (and maybe not so potential) erroneous
> situation(s).

This point is moot. Even if move_dirty_folio_in_page_array() somehow
returned nonzero on the first folio, ceph_process_folio_batch() would
simply lock zero folios, which ceph_writepages_start() already handles
gracefully.

>
> > >
> > > >
> > > > Note that this failure mode is currently masked due to another bug
> > > > (addressed later in this series) that prevents multiple encrypted f=
olios
> > > > from being selected for the same write.
> > >
> > > So, maybe, this patch has been not correctly placed in the order?
> >
> > This crash is unmasked by patch 5 of this series. (It allows multiple
> > folios to be batched when fscrypt is enabled.) Patch 5 has no hard
> > dependency on anything else in this series, so it could -- in
> > principle -- be ordered first as you suggest. However, that ordering
> > would deliberately cause a regression in kernel stability, even if
> > only briefly. That's not considered good practice in my view, as it
> > may affect people who are trying to bisect and regression test. So the
> > ordering of this series is: fix the crash in the unused code first,
> > then fix the bug that makes it unused.
> >
>
> OK, your point sounds confusing, frankly speaking. If we cannot reproduce=
 the
> issue because another bug hides the issue, then no such issue exists. And=
 we
> don't need to fix something. So, from the logical point of view, we need =
to fix
> the first bug, then we can reproduce the hidden issue, and, finally, the =
fix
> makes sense.

With respect, that reasoning is flawed and not appropriate for a
technical discussion. The crash in question cannot currently occur,
but that does *not* make the fix unnecessary. Patch #5 in this series
will re-enable the code path, at which point the crash becomes
possible. Addressing it now ensures correctness and avoids introducing
a regression. Attempting to "see it happen in the wild" before fixing
it is neither required nor acceptable practice.

We are not uncertain about the crash: I have provided steps to
reproduce it. You can apply patch #5 before #1 *in your own tree* to
observe the crash if that helps you evaluate the patches. *But under
no circumstances should this be done in mainline!* Introducing a crash
upstream, even transiently, is strictly disallowed, and suggesting
otherwise is not appropriate behavior for a Linux kernel developer.

>
> I didn't suggest too make the patch 5th as the first one. But I believe t=
hat
> this patch should follow to the patch 5th.

As I explained, putting patch #5 before this one would deliberately
introduce a regression -- a crash. Triggering this in mainline is not
allowed by kernel development policy [1]; there is no exception for
"transient regressions that are fixed immediately afterward." A
regression is a regression.

>
> > > It will be
> > > good to see the reproduction of the issue and which symptoms we have =
for this
> > > issue. Do you have the reproduction script and call trace of the issu=
e?
> >
> > Fair point!
> >
> > Function inlining makes the call trace not very interesting:
> > Call trace:
> >  ceph_writepages_start+0x16ec/0x18e0 [ceph] ()
> >  do_writepages+0xb0/0x1c0
> >  __writeback_single_inode+0x4c/0x4d8
> >  writeback_sb_inodes+0x238/0x4c8
> >  __writeback_inodes_wb+0x64/0x120
> >  wb_writeback+0x320/0x3e8
> >  wb_workfn+0x42c/0x518
> >  process_one_work+0x17c/0x428
> >  worker_thread+0x260/0x390
> >  kthread+0x148/0x240
> >  ret_from_fork+0x10/0x20
> > Code: 34ffdee0 52800020 3903e7e0 17fffef4 (d4210000)
> > ---[ end trace 0000000000000000 ]---
> > Kernel panic - not syncing: Oops - BUG: Fatal exception
> >
> > ceph_writepages_start+0x16ec corresponds to linux-6.18.2/fs/ceph/addr.c=
:1222
> >
> > However, these repro steps should work:
> > 1) Apply patch 5 from this series (and no other patches)
> > 2) Mount CephFS and activate fscrypt
> > 3) Copy a large directory into the CephFS mount
> > 4) After dozens of GBs transferred, you should observe the above kernel=
 oops
>
> Could we have all of these details in the commit message?

Would this truly help future readers, or just create noise? The commit
message already explains the exact execution path to the
BUG_ON()/oops, which is what really matters; call traces are
secondary. I did not want to imply that readers cannot understand the
seriousness of the issue without a crash log. I will include these
details if the group consensus prefers it, but I am otherwise opposed.

Hope you and yours are well,
Sam

[1] See the "no regressions" rule:
https://docs.kernel.org/admin-guide/reporting-regressions.html

>
> Thanks,
> Slava.
>
> >
> > Warm regards,
> > Sam
> >
> >
> >
> >
> > >
> > > >
> > > > For now, just reset `rc` when redirtying the folio and prevent the
> > > > error from propagating. After this change, ceph_process_folio_batch=
() no
> > > > longer returns errors; its only remaining failure indicator is
> > > > `locked_pages =3D=3D 0`, which the caller already handles correctly=
. The
> > > > next patch in this series addresses this.
> > > >
> > > > Fixes: ce80b76dd327 ("ceph: introduce ceph_process_folio_batch() me=
thod")
> > > > Cc: stable@vger.kernel.org
> > > > Signed-off-by: Sam Edwards <CFSworks@gmail.com>
> > > > ---
> > > >  fs/ceph/addr.c | 1 +
> > > >  1 file changed, 1 insertion(+)
> > > >
> > > > diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
> > > > index 63b75d214210..3462df35d245 100644
> > > > --- a/fs/ceph/addr.c
> > > > +++ b/fs/ceph/addr.c
> > > > @@ -1369,6 +1369,7 @@ int ceph_process_folio_batch(struct address_s=
pace *mapping,
> > > >               rc =3D move_dirty_folio_in_page_array(mapping, wbc, c=
eph_wbc,
> > > >                               folio);
> > > >               if (rc) {
> > > > +                     rc =3D 0;
> > >
> > > I like the fix but I would like to clarify the above questions at fir=
st.
> > >
> > > Thanks,
> > > Slava.
> > >
> > > >                       folio_redirty_for_writepage(wbc, folio);
> > > >                       folio_unlock(folio);
> > > >                       break;

