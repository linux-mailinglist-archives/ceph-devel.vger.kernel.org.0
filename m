Return-Path: <ceph-devel+bounces-4233-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 6378BCEB1EA
	for <lists+ceph-devel@lfdr.de>; Wed, 31 Dec 2025 03:55:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 21E20301A1F9
	for <lists+ceph-devel@lfdr.de>; Wed, 31 Dec 2025 02:55:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3A02D2E265A;
	Wed, 31 Dec 2025 02:55:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="R8CpJqMD"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-pf1-f169.google.com (mail-pf1-f169.google.com [209.85.210.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 981502BCF45
	for <ceph-devel@vger.kernel.org>; Wed, 31 Dec 2025 02:55:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767149728; cv=none; b=RC+raMnV82BpF8Y/VnpfykJmyNPU3hDGvOGCfWzFURhZ3iSXcvN2s5Yl0fm/25Krj6AhgSP6fFOm/XKTOGumUTPSi6gfo1wEeP7nFv+GcuIX6ZY4JgvYhzkf+T+l7a1syotgv6c/XTztvu0RoZWejvuaPSP8uPc1bw/fg8CIFlc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767149728; c=relaxed/simple;
	bh=Zorh6RDiWXFx7n1uq6Eunja7kW8xgLmN/y3XdftI94A=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=cyRk/XyCQV2QDki7JYToFQNNLJ14cnv08lDy7PgZqP/+C6CgdjJ2InIvGl0OqyneeYV4usHbwwZknIMsR9/teF1eANekr8A2UIdfcDHb+wc4t6YeNoE27+JTvOIo3bsN5L8gZYVSTCS4hzrErjHB+noEQi+38pTOJv2q1PL3+SE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=R8CpJqMD; arc=none smtp.client-ip=209.85.210.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f169.google.com with SMTP id d2e1a72fcca58-7acd9a03ba9so10951111b3a.1
        for <ceph-devel@vger.kernel.org>; Tue, 30 Dec 2025 18:55:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1767149726; x=1767754526; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=S4GTZxO1uyRXJwq1paEZPsZtu4eJgyeWyJzjBUHckVg=;
        b=R8CpJqMD8chA2rY/XBr66Z84s01Qm2nFBGPVqoFm1o/eZEi/fls7AFp4ZITVIY9vvG
         cTn5+Jit4OgW27Y7WL96rsyzAHoVtk6UFxkorP/d89Qe989smYq10pcYxuqDRen03JUo
         0MwhSJ6/esfXVYFvitaBWWEzdTZBL5yc4AxrkuL+fKV/qDLc4ZG4WSmyPI2mJOWndbq9
         kCwuhb4DeBvb7XfHwb6O2tvJDHDsSKHUnTi6Q+opS2TW6BgE06PSWWZRV9iTju4kMosp
         1X1/JGDsIfOuLlnqZ8ROw3wChOotNAdi6GjoVDx8wt8T1EfujtxK1e99gx28c0Qdpy/1
         WBbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767149726; x=1767754526;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=S4GTZxO1uyRXJwq1paEZPsZtu4eJgyeWyJzjBUHckVg=;
        b=G31GYvxHXsFzUxeqP68lGvqlkvOIGTQU2V5LcLe1P82gu14ZxHCkSqgBU0GbLIvCto
         gR2xd7TfvNhhGhQQnoWgIda+u12AT7HU9x0uNmdE2tHHKAhi0HbB1OfzABAfPfDFN3ez
         PwLwqH+5vhfwFhYuOc1qV4P/S14MEi3JvKAy7y657wAQnXk+htEUj0n8Y1AsKCREuTj6
         y4Un4MH4nmESdiUbhjbWxny69puwsS6bsWiiy4UY3LEBXTn3D0cF9k8fxns5W8nYH1JM
         4+GtYD8c0T0JH/SSpJUmD9IwEZWgObF4SGcHmLapAtfSZ5hSqTNwREbDMPLNm7UW4Xlb
         wT/Q==
X-Forwarded-Encrypted: i=1; AJvYcCW6W6q5HAlV+aporcBrs4ZAT5+ZL2YEDcWCwnUarLxDWFB+WOoKNDFiHFBAEhw4w/k+RH9z33VQV/n5@vger.kernel.org
X-Gm-Message-State: AOJu0Yx0DV+jmYDL+3b3cuns7VjlRgOTItpdLnu0hvPsaWMcERqHCLmw
	eDPltIayAFgRFsOd7sbP1Su0YkaM352VHGqi4utETTYpJG0Fd6Bb59Qp
X-Gm-Gg: AY/fxX44BpzdLIHHmrG/HNgdFVCuFReJIRWSjvUm+ob7hP6GKMlnVL0tjmGtR4PNWqU
	Gt6hijEPs1gQcBo0ywi+PZgQ3fM1F1Ln2BnaeApE1g63YJM55ALA31WuEaIzxuYKJ0Zwjep3s+b
	NSYKg0S9QRkSjCkQ3Emqav+66vUSHAu1Kl97jk38xlEzOiWaxXl7vM7IsSoheZyskYG1PNlwFnc
	ckElq2IoM9reOTs1eQhZ4j7qH38LUd8up1grKuYv7ir27RRKTkhal0ITaH8xqQva3dYIjS5B9NV
	Ly96RqRqRGydgr/ewtQmsTUpN7MJVMWqKHy8OJi73GTfNIo1J1fHqkmU4wUIQuN/kujVuvsiRzS
	TD9LGlv88TVy1rCW1hij2W6lLodlSvjCpJmlOKYtQn03acvFRTFnVy7OWJdhyFJ3CzhpAVS4Vjc
	vI6Q==
X-Google-Smtp-Source: AGHT+IHIkmqmRrGCLBKZvBbVdd6zUHkLIRD/E+oRXUHK8Ex5ZIyBH+1YOzgk1LR9mate3HbDtaJYlw==
X-Received: by 2002:a05:6a00:6e87:b0:7ff:97b3:59bb with SMTP id d2e1a72fcca58-7ff97c29c6dmr25379340b3a.16.1767149725837;
        Tue, 30 Dec 2025 18:55:25 -0800 (PST)
Received: from celestia ([69.9.135.12])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7ff7e892926sm33623646b3a.66.2025.12.30.18.55.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Dec 2025 18:55:24 -0800 (PST)
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
Subject: [PATCH 0/5] ceph: CephFS writeback correctness and performance fixes
Date: Tue, 30 Dec 2025 18:43:11 -0800
Message-ID: <20251231024316.4643-1-CFSworks@gmail.com>
X-Mailer: git-send-email 2.51.2
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hello list,

This series addresses several interrelated CephFS writeback issues,
particularly for fscrypted files. My work began with a performance problem:
encrypted files caused a write storm during writeback because the writeback
code was inadvertently selecting the crypto block instead of the stripe unit as
the maximum write unit size.

While testing that fix, I encountered a correctness bug: failures to allocate
bounce pages during writeback were incorrectly propagated as batch errors,
which trigger kernel oopses/panics due to poor handling in the writeback loop.
While investigating that, I discovered that the same oopses could be triggered
by a failure in ceph_submit_write() as well.

The patches in this series:

1. Prevent bounce page allocation failures from aborting the writeback batch
   and causing a kernel oops/panic due to the page array not being freed.
2. Remove the now-redundant error return from ceph_process_folio_batch().
3. Free page arrays during failure in ceph_submit_write(), preventing another
   path to the same kernel oops/panic. This was not an issue I encountered in
   testing, and it is tricky to trigger organically. I used the fault injection
   framework to confirm it and verify the fix.
4. Assert writeback loop invariants explicitly to help prevent regressions and
   aid debugging should the problem reappear.
5. Fix the write storm on fscrypted files by using the correct stripe unit.

Note that this series follows a "fix-then-refactor" cadence: patches 1, 3, and
5 fix bugs and are intended for stable, while patches 2 and 4 represent code
cleanup and are intended only for next.

Wishing you all a prosperous 2026 ahead,
Sam

Sam Edwards (5):
  ceph: Do not propagate page array emplacement errors as batch errors
  ceph: Remove error return from ceph_process_folio_batch()
  ceph: Free page array when ceph_submit_write fails
  ceph: Assert writeback loop invariants
  ceph: Fix write storm on fscrypted files

 fs/ceph/addr.c | 35 +++++++++++++++++++----------------
 1 file changed, 19 insertions(+), 16 deletions(-)

-- 
2.51.2


