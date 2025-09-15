Return-Path: <ceph-devel+bounces-3609-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2C1A8B56E74
	for <lists+ceph-devel@lfdr.de>; Mon, 15 Sep 2025 04:52:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 674D27ACC42
	for <lists+ceph-devel@lfdr.de>; Mon, 15 Sep 2025 02:50:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DEA04215F42;
	Mon, 15 Sep 2025 02:51:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QHLoIWMf"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-qv1-f54.google.com (mail-qv1-f54.google.com [209.85.219.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0041D20296E
	for <ceph-devel@vger.kernel.org>; Mon, 15 Sep 2025 02:51:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757904714; cv=none; b=WC94IH8qp8VfQpkyewU4LW7DunbB8QRlpPGKlOifiypnkJUYIA0ejmmMF3eJlLhXcZwE4bdTSMPc0BegNxWZ2e3/OO31nEXmRBce9+JWx307i8DGQGcHj5Hg/IMDHZ5/BzgGCSldtUutll7APUgvyL8JdQkgt6ymvBZfU8tu03A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757904714; c=relaxed/simple;
	bh=EHCSfQ2XnebCHi96Y4dD+dNrHULC6WpUjEi9/5mfeAs=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=dankivrtt8crbfrVOrFmdW4yeneOk0bQOzkXHFIAin2qqxC/vTg+Q4+72xkx6rIUuq7i31+q+dXSuBbbIDI6hHWymNxubW982xISveD4aoY/P7UJBTQEabRlfsmb7diKDs1Le542pVQbSfuYHs/6uujVECx0Fvkpm80OWr0Cq/I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=QHLoIWMf; arc=none smtp.client-ip=209.85.219.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-qv1-f54.google.com with SMTP id 6a1803df08f44-76b8fd4ba2cso19648396d6.3
        for <ceph-devel@vger.kernel.org>; Sun, 14 Sep 2025 19:51:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757904712; x=1758509512; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=EHCSfQ2XnebCHi96Y4dD+dNrHULC6WpUjEi9/5mfeAs=;
        b=QHLoIWMfVplcun/lEerfYdg/bUv0X5hCUd/1WvfoqWyjD+DD7EByyKr9BIgS2w3tLu
         cUa3eF/zO1fZQ45n4VsIojB9YAw0fnCzEtFaABgm1r5y2kDFy9VSe15779sgE3n4dj68
         KxErNSoCdCdNt+2WRZOmVXAGuog9F2z44HJEoKq/qcN5+IzlaN7QU0aVjEmUZNsU8TL8
         2F/P56uKAj/YcpNocJ8PYz2IjqVaNO5HXe5L1Mt9YB+GuBINAP6KV6UGpN1LhGG5QwkC
         lWrTgXFGLwbq8JQmyl/t7sHPqGjk0JK84OJq3b8uzWzkcN/lhc8eNONutc3Sc3Rp1/rn
         /HFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757904712; x=1758509512;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=EHCSfQ2XnebCHi96Y4dD+dNrHULC6WpUjEi9/5mfeAs=;
        b=mQJpPsXpZ3BGk66c0rnbkv6ubs0xi0OCMYDZsWJh1pn767H2VrQTgflNeerRO5VVtW
         5kQIWftenOYPgTB7U1t9vMDM065QEofXvlzJrRCn51AMCKG2kp9C0qsXGCR3hV9xllvV
         XAuIPOjUuQv+xtMEqOngWvwsNNqL1E50r0ZTj6Z2mnWh0hW2kk1uaG1Lu8aEzVCdNtYW
         juVWapMLMWi+sD5MtJTs9E/+xQmCB+5oFqqLWCPlrjr/rY2N1x44zgkS4IzCcJmrtChC
         Wv+pu6tn9xxttl3rnm00VB/ZilrwIB7dJFBSbtrmLzlOMmGkFhXQPlNt0KoF1J2jTI+O
         mQ6g==
X-Forwarded-Encrypted: i=1; AJvYcCV7Rqib6FBOvpiGDE+I/GHPMeGHJACtREuVJNxWQVHJS5tIaGVz7E3D9M6JcYEDGewB4QKLVE080qW3@vger.kernel.org
X-Gm-Message-State: AOJu0YzUjuNbjhNqumo2nQ7qKW3/tovdU5pA9z+S1e7lxedVU2nkATZs
	+gZkZN71kftoV0An/AVM0NAB4V/Of2QnWGGO+lB7SbkLXszolRfjf4d2MCj6MzpAcAolQKioUwF
	J9gpAb+tKPtuB2jNqw3i/55rXmRB2zww=
X-Gm-Gg: ASbGncvv3iDg2oTyl7owxNaL2RUmORrESVfe6LhDa+6mhMneMBh94VSA+QAHOzl5/J3
	Ocdam0OnEeym2fsZNna+cL2i/4R/fudJf9txYcpqgxZQrP/sriJdvh6yumWcdkNs1+6x/aGjAYI
	XHcxxD6Ib4HnkDR2lrFp44CXYFzMNYIOS0jHd163yGmnAV6YKmxdUNpaBA8efVtwCgJh3f1+IB6
	Vt2GxybA0aJ9TcBb5g0
X-Google-Smtp-Source: AGHT+IFP8eaILsH9go5zyLSWkPywDlTf0zFbEuxeMo96jyMKBC6y8FwuOWf/q4q8WZnK3lNGYAepz88m6iC+xXZJxTk=
X-Received: by 2002:a05:6214:5f81:b0:767:c73e:88d4 with SMTP id
 6a1803df08f44-767c73e8a77mr124152186d6.8.1757904711760; Sun, 14 Sep 2025
 19:51:51 -0700 (PDT)
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: =?UTF-8?B?6ZmI5Y2O5pit?= <lyican53@gmail.com>
Date: Mon, 15 Sep 2025 10:51:38 +0800
X-Gm-Features: AS18NWCYV1ejkfb-hhHGxKG9Jq-ZiN_AIhYVPE02h-fdGA1vS5JP9-9rQn3NWAQ
Message-ID: <CAN53R8HxFvf9fAiF1vacCAdsx+m+Zcv1_vxEiq4CwoHLu17hNg@mail.gmail.com>
Subject: [RFC] Fix potential undefined behavior in __builtin_clz usage with
 GCC 11.1.0
To: linux-kernel@vger.kernel.org
Cc: idryomov@gmail.com, xiubli@redhat.com, ceph-devel@vger.kernel.org, 
	jejb@linux.ibm.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, 
	pbonzini@redhat.com, seanjc@google.com, kvm@vger.kernel.org, 
	mturquette@baylibre.com, sboyd@kernel.org, linux-clk@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Hi all,

I've identified several instances in the Linux kernel where __builtin_clz()
is used without proper zero-value checking, which may trigger undefined
behavior when compiled with GCC 11.1.0 using -march=x86-64-v3 -O1 optimization.

PROBLEM DESCRIPTION:
===================

GCC bug 101175 (https://gcc.gnu.org/bugzilla/show_bug.cgi?id=101175) causes
__builtin_clz() to generate BSR instructions without proper zero handling when
compiled with specific optimization flags. The BSR instruction has undefined
behavior when the source operand is zero, potentially causing incorrect results.

The issue manifests when:
- GCC version: 11.1.0 (potentially other versions)
- Compilation flags: -march=x86-64-v3 -O1
- Code pattern: __builtin_clz(value) where value might be 0

AFFECTED LOCATIONS:
==================

1. HIGH RISK: net/ceph/crush/mapper.c:265
Problem: __builtin_clz(x & 0x1FFFF) when (x & 0x1FFFF) could be 0
Impact: CRUSH hash algorithm corruption in Ceph storage

2. HIGH RISK: drivers/scsi/elx/libefc_sli/sli4.h:3796
Problem: __builtin_clz(mask) in sli_convert_mask_to_count() with no zero check
Impact: Incorrect count calculations in SCSI operations

3. HIGH RISK: tools/testing/selftests/kvm/dirty_log_test.c:314
Problem: Two __builtin_clz() calls without zero validation
Impact: KVM selftest framework reliability

4. MEDIUM RISK: drivers/clk/clk-versaclock7.c:322
Problem: __builtin_clzll(den) but prior checks likely prevent den=0
Impact: Clock driver calculations (lower risk due to existing checks)

COMPARISON WITH SAFE PATTERNS:
=============================

The kernel already implements safe patterns in many places:

// Safe pattern from include/asm-generic/bitops/builtin-fls.h
return x ? sizeof(x) * 8 - __builtin_clz(x) : 0;

// Safe pattern from arch/powerpc/lib/sstep.c
op->val = (val ? __builtin_clz(val) : 32);

PROPOSED FIXES:
==============

1. net/ceph/crush/mapper.c:
- int bits = __builtin_clz(x & 0x1FFFF) - 16;
+ u32 masked = x & 0x1FFFF;
+ int bits = masked ? __builtin_clz(masked) - 16 : 16;

2. drivers/scsi/elx/libefc_sli/sli4.h:
if (method) {
- count = 1 << (31 - __builtin_clz(mask));
+ count = mask ? 1 << (31 - __builtin_clz(mask)) : 0;
count *= 16;

3. tools/testing/selftests/kvm/dirty_log_test.c:
- limit = 1 << (31 - __builtin_clz(pages));
- test_dirty_ring_count = 1 << (31 - __builtin_clz(test_dirty_ring_count));
+ limit = pages ? 1 << (31 - __builtin_clz(pages)) : 1;
+ test_dirty_ring_count = test_dirty_ring_count ?
+ 1 << (31 - __builtin_clz(test_dirty_ring_count)) : 1;

REPRODUCTION:
============

Based on the GCC bug report and analysis of the kernel code patterns, this
issue can be reproduced by:

1. Compiling affected code with: gcc -march=x86-64-v3 -O1
2. Examining generated assembly for BSR instructions
3. Triggering code paths where the __builtin_clz argument could be zero

QUESTIONS:
=========

1. Should I prepare formal patches for each affected subsystem?
2. Are there other instances I should investigate?
3. Would adding a kernel-wide safe wrapper for __builtin_clz be appropriate?
4. Would the maintainers like me to create a proof-of-concept test case?

This analysis is based on static code review and comparison with the known
GCC bug behavior. Further testing by the respective subsystem maintainers
would be valuable to confirm the impact.

Best regards,
Huazhao Chen
lyican53@gmail.com

---

This analysis affects multiple subsystems and should be addressed to ensure
deterministic behavior across different GCC versions and optimization levels.
I'm happy to assist with testing or patch development if the maintainers
confirm this is indeed an issue worth addressing.

