Return-Path: <ceph-devel+bounces-4291-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id AD864D00162
	for <lists+ceph-devel@lfdr.de>; Wed, 07 Jan 2026 22:03:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 7B788304DE0A
	for <lists+ceph-devel@lfdr.de>; Wed,  7 Jan 2026 21:02:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3D65C296BA8;
	Wed,  7 Jan 2026 21:02:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="H4eFsn+O"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-dy1-f180.google.com (mail-dy1-f180.google.com [74.125.82.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 397E53A0B33
	for <ceph-devel@vger.kernel.org>; Wed,  7 Jan 2026 21:02:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767819728; cv=none; b=m2kFGdkK85332Ukj5ONuoRNTmFTtcXHTHGTK7gf8iKBh7CrPwTuZ/4OEtYF54HwgHraTNwAvZ93iuu60efbG96bCT9TmlvexS8tqltNAGonh2WZs60HOB1HhyiYjhVJ4L/IbB4oW38ruceLZD2kNgRyw85vXn3rV4PmeKK6N15o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767819728; c=relaxed/simple;
	bh=nLiFrKrMWEDWhKYA4SThkJDHfr+tx4Mh+DpaUsX3kz0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Ze9MRzg0FoTbZE7jjsNdkbxqJx48k9DvCXcH7Oz3D8y8iLWfIr6rRLR24SquKps0xnE+GRsamSjs3yYkHpIUr84TBtXPf7SRblGx+Ieq7HCQtZ0/AO2Nxl+KLZJxDInVGPk6HocdPA80xZ4+1bY6iW7uNMqpSCqdrcs4ggy6WKI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=H4eFsn+O; arc=none smtp.client-ip=74.125.82.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-dy1-f180.google.com with SMTP id 5a478bee46e88-2b053ec7d90so1714683eec.0
        for <ceph-devel@vger.kernel.org>; Wed, 07 Jan 2026 13:02:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1767819726; x=1768424526; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=IYueof6u3LKjffd6jasQycdzzhZzGuaZ1K2N/IJAVwo=;
        b=H4eFsn+O0rwlj5rv1SwGsm+EAyIM68IHOU0nnNPAfEKJGXfM11hZMh38fSeaN7TAoa
         j16LEOPMfAFLuBJrDaKsxDVF0B1ZZDz+2SQ2Dng+J/MtUkdjeDypyrRzu2t5fjWNVuNL
         gpBaP+rVxOOc7EH5VqOWKQoYMW0yBfaZfn9HBWbI2J97OcN3iEtcZnz7Al+ZKKciIBVp
         upk2fSeXSYSQe/HWwRFnCTmZxrKW04HDUuMgzjYHGRWjg7YGlpNRDdeIx2iZEGt4dtyc
         /hy6TGgkq0cAkExJnIU9ysoCWFoCzUiISGKcVLLHbnpjka4l5vv1dUdml6zaGu9r6R8B
         cKZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767819726; x=1768424526;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IYueof6u3LKjffd6jasQycdzzhZzGuaZ1K2N/IJAVwo=;
        b=xPCz6iTNHP4irNhluXYZ2bGynmiczfchkF3rilCa0c6AHzL8ci0wJk3ITxIWPf0iNN
         Lhyd7MUJR68RfLNyDk/J6nFvzp0pxfC/KKrHtu6eouNLo31OXvJe30X3jPMYySrpx4lf
         ZE2cvCxRhf5PPygoiF3wEVC3JVhmc9vUpHfi/mL/S5wHXG62M0HnFmJ+4GEVs/oLWjGo
         tZ6g/NZRdkIcJy7sHWStXiAnMgwqmxSPOLp571RlxQW55oEin01Cw43M+qC8cvLYQ6LW
         h5N9Phk1XY8L5hEeTTVADPapgxf17A4tkISauy+98sSXB/N5KDeaspFoXhCqAPiaDtSH
         ewoA==
X-Forwarded-Encrypted: i=1; AJvYcCUux69zeTAXv+k0TKUmb/eAyElWDbKnOVBrz0+wQIcRdT+Li7jFS9kGJ5wUod0oN7/qUJXd6GAUypMH@vger.kernel.org
X-Gm-Message-State: AOJu0YwmVb0GhdfUOoioT6Q24TAHo43YgzZaFnPP90ZyJjk+wixQFZC/
	wcnxNIfv4Sdho4YysX+OtBTTjAWgmDgIL5C0Yokfx4+82+PH/SbLwx5d
X-Gm-Gg: AY/fxX7TgSBEJSgZ+U6GroRGG7Wb+AmbgHZQcqIi74KpTy7YRFtn3HsI/v6fVmyD5qP
	ElL1GG/N72s9yzFhidaCB8b0vht9p9pjQ9EY4EtTJeYwIjo97FP/jDnsGkL6vqhWGyPRjaAO73t
	FLG6d6ZaeKpyNggpwuoCzUr6NvE8TEiP7hMILZF5nb32HCbPbGcEt3jqabwUNz7Ue2l01fqxrz5
	y+fyykb5YN3E7uzOapxAlVoBjtNRB6WvJ4h4NkDF9a1UW0Yviy4QsWcD0WD3UjXc1Y07MgvGUgt
	sS7uGCnKcfwos1Dj8ncPUlnKv7gUusLqMwisXNVAk5+yttQOQLJASnDWldRkGJmj2bgk77qN1+i
	1dWVAdCfj1rO4eVksmBzwlO1pPCIydabgnTFji39uSRj2qJnthnir0jjezzqaeX58J7Osei63U3
	VuGouWzLCfBS7actkbJyRDSYbMZn5t0T7uLl0dvBP8y3riDKfr6n0dXSBVpUDA
X-Google-Smtp-Source: AGHT+IEJZNpW0eFCEB1GlRE/3Epl/lEwHdgByHYshM2SyAYaq20/g0zOx6+ZgUv4ZbAkE9MNRbgaqA==
X-Received: by 2002:a05:7300:d194:b0:2a4:3592:c60e with SMTP id 5a478bee46e88-2b17d2d60f6mr2573058eec.31.1767819725897;
        Wed, 07 Jan 2026 13:02:05 -0800 (PST)
Received: from celestia.turtle.lan (static-23-234-115-121.cust.tzulo.com. [23.234.115.121])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-2b170673b2esm7730320eec.6.2026.01.07.13.02.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Jan 2026 13:02:05 -0800 (PST)
From: Sam Edwards <cfsworks@gmail.com>
X-Google-Original-From: Sam Edwards <CFSworks@gmail.com>
To: Xiubo Li <xiubli@redhat.com>,
	Ilya Dryomov <idryomov@gmail.com>
Cc: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>,
	Christian Brauner <brauner@kernel.org>,
	Milind Changire <mchangir@redhat.com>,
	Jeff Layton <jlayton@kernel.org>,
	ceph-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Sam Edwards <CFSworks@gmail.com>
Subject: [PATCH v2 0/6] ceph: CephFS writeback correctness and performance fixes
Date: Wed,  7 Jan 2026 13:01:33 -0800
Message-ID: <20260107210139.40554-1-CFSworks@gmail.com>
X-Mailer: git-send-email 2.51.2
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hello list,

This is v2 of my series that addresses interrelated issues in CephFS writeback,
fixing crashes, improving robustness, and correcting performance behavior,
particularly for fscrypted files. [1]

Changes v1->v2:
- Clarify patch #1's commit message to establish that failures on the first
  folio are not possible.
- Add another patch to move the "clean up page array on abort" logic to a new
  ceph_discard_page_array() function. (Thanks Slava!)
- Change the wording "grossly degraded performance" to instead read
  "correspondingly degraded performance." This makes the causal relationship
  clearer (that write throughput is limited much more significantly by write
  op/s due to the bug) without making any claims (qualitative or otherwise)
  about significance. (Thanks Slava!)
- Reset locked_pages = 0 immediately when the page array is discarded,
  simplifying patch #5 ("ceph: Assert writeback loop invariants")
- Reword "as evidenced by the previous two patches which fix oopses" to
  "as evidenced by two recent patches which fix oopses" and refer to the
  patches by subject (being in the same series, I cannot refer to them by hash)

I received several items of feedback on v1 that I have chosen not to adopt --
mostly because I believe they run contrary to kernel norms about strong
contracts, redundancy, not masking bugs, and regressions. (It is possible that
I am mistaken on these norms, and may still include them in a v3 if someone
makes good points in favor of them or consensus overrules me.)

Feedback on v1 not adopted:
- "Patch #1, which fixes a crash in unreachable code, should be reordered after
   patch #6 (#5 in v1), which fixes a bug that makes the code unreachable,
   in order to simplify crash reproduction in review"
The order of the patchset represents the canonical commit order of the series.
Committing patch #6 before patch #1 would therefore introduce a regression, in
direct violation of longstanding kernel policy.

- "Patch #1 should not swallow errors from move_dirty_folio_in_page_array() if
   they happen on the first folio."
It is not possible for move_dirty_folio_in_page_array() to encounter an error
on the first folio, and this is not likely to change in the future. Even if
such an error were to occur, the caller already expects
ceph_process_folio_batch() to "successfully" lock zero pages from time to time.
Swallowing errors in ceph_process_folio_batch() is consistent with its design.

- "Patch #1 should include the call trace and reproduction steps in the commit
   message."
The commit message already explains the execution path to the failure, which is
what people really care about (the call trace is just a means to that end).
Inlining makes the call trace completely opaque about why the oops happens.
Reproduction steps are not particularly valuable for posterity, but a curious
party in the future can always refer back to mailing list discussions to find
them.

- "Patch #2 should not exist: it removes the return code from
   ceph_process_folio_batch(), which is essential to indicate failures to the
   caller."
The caller of ceph_process_folio_batch() only cares about success/failure as a
boolean: the exact error code is discarded. This is redundant with
ceph_wbc.locked_pages, which not only indicates success/failure, but also the
degree of success (how many pages were locked). This makes
ceph_wbc.locked_pages a more appealing single source of truth than the error
code.

Further, the error return mechanism is misleading to future programmers: it
implies that it is acceptable for ceph_process_folio_batch() to abort the
operation (after already selecting some folios for write). The caller cannot
handle this. Removing the return code altogether makes the contract explicit,
which is the central point of the patch.

- "Patch #5 (#4 in v1) should not introduce BUG_ON() in the writeback path."
The writeback path already has BUG_ON(), and this is consistent with kernel
norms: check invariants, fail fast, and don't try to tolerate ambiguity. There
are already BUG_ONs that check several invariants, so rather than introducing
new failure possibilities to the writeback loop, patch #5 actually catches
invariant errors sooner. This is to tighten up the code and prevent
regressions, not fix any particular bug.

- "Patch #6 (#5 in v1) should include benchmark results to support its claim of improved performance."
My environment is not very representative of a typical Ceph deployment, and
benchmarking is tough to get right. I am not prepared to stand behind any
particular estimated/expected speedup factor. Rather, the rationale for this
patch is a simple computer science principle: increasing the amount of useful
work done per operation reduces total overhead. I have changed the phrasing
"grossly degraded performance" to "correspondingly degraded performance" to
emphasize that the performance degradation follows from the bottleneck, without
implying that I'm making some kind of claim about magnitude.

Warm regards,
Sam

[1]: https://lore.kernel.org/ceph-devel/20251231024316.4643-1-CFSworks@gmail.com/T/

Sam Edwards (6):
  ceph: Do not propagate page array emplacement errors as batch errors
  ceph: Remove error return from ceph_process_folio_batch()
  ceph: Free page array when ceph_submit_write fails
  ceph: Split out page-array discarding to a function
  ceph: Assert writeback loop invariants
  ceph: Fix write storm on fscrypted files

 fs/ceph/addr.c | 82 +++++++++++++++++++++++++++++---------------------
 1 file changed, 48 insertions(+), 34 deletions(-)

-- 
2.51.2


