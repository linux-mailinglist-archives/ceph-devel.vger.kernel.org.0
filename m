Return-Path: <ceph-devel+bounces-2840-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 93330A4A88F
	for <lists+ceph-devel@lfdr.de>; Sat,  1 Mar 2025 05:23:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E2E9E171E21
	for <lists+ceph-devel@lfdr.de>; Sat,  1 Mar 2025 04:23:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 67F4F1B85EE;
	Sat,  1 Mar 2025 04:23:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="Tic0cecF"
X-Original-To: ceph-devel@vger.kernel.org
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B1B8A1519BE;
	Sat,  1 Mar 2025 04:23:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740802986; cv=none; b=EGXKrEZ84nErlhBBHHNQU3nbl8WMm5yawvS0+QGnhC57+vZCX+h1LFUAIKyk+VJemveMXqwp39JyW6mfu4nwzyFytyUb1WlFVS9ydLrVQoy7suwk6qQMfItIGY7G7QDAO/WXXJ9gJp2IXYPDINJaWzS1EWpZIW0rPN8aIY2lhy4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740802986; c=relaxed/simple;
	bh=yseNamwDxaZtO0KtuMWvy0i8Osu9fsrGhdEX7PvrknE=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=JCs1hDPjygsX4YZp9RhGh8B5PiT/mlqGdc2iAB4FFeyl23n+qnB97fYOqeg7XlPcNu/4QvmTLnWip3SPHATS25bmPOG6wYCeYXmmqhpZB7gIZEPXsjrRTXcRQU1W0AocbXOP0hdj/gZCPVz4tDMbbF1Pzxn5DkinREhHEBJW1O0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=Tic0cecF; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Received: from eahariha-devbox.internal.cloudapp.net (unknown [40.91.112.99])
	by linux.microsoft.com (Postfix) with ESMTPSA id 3AA842038A25;
	Fri, 28 Feb 2025 20:23:04 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 3AA842038A25
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1740802984;
	bh=PgYb7240sgPq/L5w2oKC7klJ5k6Fow9TNpoUkzNGK1k=;
	h=From:Subject:Date:To:Cc:From;
	b=Tic0cecF/21Kg594q1CO/eg5+QgiwPz4LgD/n3MMHP2O9FfWF99KZzvmupgYjfLmY
	 kKC2iohVgVPu30uDrBrUvlKGueIlVHYFXCQHgQjO2hELzw+/4iCNbOl8VIVFWOPAzC
	 WINPoDOvtacWuCzAjkiPENuSeaZYK/qJx1E103wU=
From: Easwar Hariharan <eahariha@linux.microsoft.com>
Subject: [PATCH v4 0/2] Converge on using secs_to_jiffies() part two
Date: Sat, 01 Mar 2025 04:22:51 +0000
Message-Id: <20250301-converge-secs-to-jiffies-part-two-v4-0-c9226df9e4ed@linux.microsoft.com>
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAJuLwmcC/43OsW4DIRAE0F+xqLPWsnBwdpX/iFIQbomJ4sMCQ
 hxZ9+/h3CSNpStnijdzE4Vz5CKOu5vI3GKJae5BP+2EP7n5nSFOPQtC0pKkBZ/mxrn3hX2BmuA
 jhtAFuLhcoX4nCFqjtM6ZYKzoziVziNf7xstrz6dYaso/98km13bVB5Q0btCbBISDM+wDvpHC8
 fkzzl/X/Tn6nEoKde/TWaw7jf5sQrXFpm5PFofRoQwT8mNb/bNp2GKrbjutDsayMn588HtZll8
 Wd1FLlAEAAA==
X-Change-ID: 20241217-converge-secs-to-jiffies-part-two-f44017aa6f67
To: Andrew Morton <akpm@linux-foundation.org>, 
 Christophe JAILLET <christophe.jaillet@wanadoo.fr>, 
 Daniel Vacek <neelx@suse.com>, Ilya Dryomov <idryomov@gmail.com>, 
 Dongsheng Yang <dongsheng.yang@easystack.cn>, Jens Axboe <axboe@kernel.dk>, 
 Xiubo Li <xiubli@redhat.com>
Cc: ceph-devel@vger.kernel.org, linux-block@vger.kernel.org, 
 linux-kernel@vger.kernel.org, 
 Easwar Hariharan <eahariha@linux.microsoft.com>
X-Mailer: b4 0.14.2

This is the second series (part 1*) that converts users of msecs_to_jiffies() that
either use the multiply pattern of either of:
- msecs_to_jiffies(N*1000) or
- msecs_to_jiffies(N*MSEC_PER_SEC)

where N is a constant or an expression, to avoid the multiplication.

The conversion is made with Coccinelle with the secs_to_jiffies() script
in scripts/coccinelle/misc. Attention is paid to what the best change
can be rather than restricting to what the tool provides.

Andrew has kindly agreed to take the series through mm.git modulo the
patches maintainers want to pick through their own trees.

This series is based on next-20250225

Signed-off-by: Easwar Hariharan <eahariha@linux.microsoft.com>

* https://lore.kernel.org/all/20241210-converge-secs-to-jiffies-v3-0-ddfefd7e9f2a@linux.microsoft.com/

---
Changes in v4:
- Restore correct range checks for rbd and libceph (Christophe J)
- Link to v3: https://lore.kernel.org/r/20250225-converge-secs-to-jiffies-part-two-v3-0-a43967e36c88@linux.microsoft.com

Changes in v3:
- Change commit message prefix from libata: zpodd to ata: libata-zpodd: in patch 8 (Damien)
- Split up overly long line in patch 9 (Christoph)
- Fixup unnecessary line break in patch 14 (Ilpo)
- Combine v1 and v2
- Fix some additional hunks in patch 2 (scsi: lpfc) which the more concise script missed
- msecs_to_jiffies -> msecs_to_jiffies() in commit messages throughout
- Bug in secs_to_jiffies() uncovered by LKP merged in 6.14-rc2: bb2784d9ab4958 ("jiffies: Cast to unsigned long in secs_to_jiffies() conversion")
- Link to v2: https://lore.kernel.org/r/20250203-converge-secs-to-jiffies-part-two-v2-0-d7058a01fd0e@linux.microsoft.com

Changes in v2:
- Remove unneeded range checks in rbd and libceph. While there, convert some timeouts that should have been fixed in part 1. (Ilya)
- Fixup secs_to_jiffies.cocci to be a bit more verbose
- Link to v1: https://lore.kernel.org/r/20250128-converge-secs-to-jiffies-part-two-v1-0-9a6ecf0b2308@linux.microsoft.com

---
Easwar Hariharan (2):
      rbd: convert timeouts to secs_to_jiffies()
      libceph: convert timeouts to secs_to_jiffies()

 drivers/block/rbd.c          |  8 ++++----
 include/linux/ceph/libceph.h | 12 ++++++------
 net/ceph/ceph_common.c       | 18 ++++++++----------
 net/ceph/osd_client.c        |  3 +--
 4 files changed, 19 insertions(+), 22 deletions(-)
---
base-commit: 0226d0ce98a477937ed295fb7df4cc30b46fc304
change-id: 20241217-converge-secs-to-jiffies-part-two-f44017aa6f67

Best regards,
-- 
Easwar Hariharan <eahariha@linux.microsoft.com>


