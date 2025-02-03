Return-Path: <ceph-devel+bounces-2625-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C66E2A26806
	for <lists+ceph-devel@lfdr.de>; Tue,  4 Feb 2025 00:50:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 379D43A3E43
	for <lists+ceph-devel@lfdr.de>; Mon,  3 Feb 2025 23:50:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4E292211490;
	Mon,  3 Feb 2025 23:50:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="Vpzh0KjO"
X-Original-To: ceph-devel@vger.kernel.org
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B74B9433D9;
	Mon,  3 Feb 2025 23:50:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738626625; cv=none; b=iWEEKB5p/0MgWR2ysfxC4iQnlWenyywTARSq7tfdJgEODf/Me2ye1zhzWp90vGCQcU9+/PSNuCmRAV5OR9V6ma9LcLGlfqSvMX02OWKd/7FKx7Ve7cHjqcLw8RbgelGsZo86bvtB/IOfhsRvZqELlP3gg1SNpMnIfhJ3WF1hUjo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738626625; c=relaxed/simple;
	bh=V1zYPzGueN+w/UKJ5mEsfpaYH+SQsfrEcQEPBiKrnBI=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=UDVJgLP4lhLlH8poBBaq1g0q5rnk1Y09qKRvL9xd7QLsJIgFz15Pzm7mEZAZBEhyAqMdVZnM7ILWe6LNZscHfKzd7+PY9jLSsn74kmXxt68aLE7LXWMbxxWJ8BMPNq5QDyWRq/PVynViSC9G80SM2Jx+NQA30jeX7rrnu/FsKh8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=Vpzh0KjO; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Received: from eahariha-devbox.internal.cloudapp.net (unknown [40.91.112.99])
	by linux.microsoft.com (Postfix) with ESMTPSA id 35FE8205493B;
	Mon,  3 Feb 2025 15:50:23 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 35FE8205493B
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1738626623;
	bh=gtZ0uRvYix6ly8XDRmesOsmv2XN8dAoX2BWiSw+KLT8=;
	h=From:Subject:Date:To:Cc:From;
	b=Vpzh0KjOSAKXQeC03cgO2ZTKONQBCN6XsU3FjRXdjgI9v53FjtiKquz73hy/MwohZ
	 fBbkRQcqUvulJnQRpCI2+93+tSTaZ1i9fCVxDCyWUb3aJk4qWWU/5pCGnOXwh9zlHu
	 qbWUq+nGbMQtVUKyHF8lVdtdVDBJsna5HEBtUrFA=
From: Easwar Hariharan <eahariha@linux.microsoft.com>
Subject: [PATCH v2 0/3] Converge on using secs_to_jiffies() part two
Date: Mon, 03 Feb 2025 23:50:21 +0000
Message-Id: <20250203-converge-secs-to-jiffies-part-two-v2-0-d7058a01fd0e@linux.microsoft.com>
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAD1WoWcC/42NQQ6CMBAAv0J6dklbEdCT/zAcat3KGumStiKG8
 HcrL/A4c5hZRMRAGMWpWETAiSKxz6B3hbC98XcEumUWWupKadWAZT9hyD6ijZAYHuRcLsBoQoL
 0ZnBVJVVjTO3qRuTOGNDRvD0uXeaeYuLw2ZaT+tlf/SCVbv+oTwokHE2N1smr3sv2/CT/msuBb
 ODILpWWB9Gt6/oFrQTphtwAAAA=
X-Change-ID: 20241217-converge-secs-to-jiffies-part-two-f44017aa6f67
To: Andrew Morton <akpm@linux-foundation.org>, 
 Julia Lawall <Julia.Lawall@inria.fr>, Nicolas Palix <nicolas.palix@imag.fr>, 
 Ilya Dryomov <idryomov@gmail.com>, 
 Dongsheng Yang <dongsheng.yang@easystack.cn>, Jens Axboe <axboe@kernel.dk>, 
 Xiubo Li <xiubli@redhat.com>
Cc: cocci@inria.fr, linux-kernel@vger.kernel.org, 
 ceph-devel@vger.kernel.org, linux-block@vger.kernel.org, 
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

This series is based on next-20250203

Signed-off-by: Easwar Hariharan <eahariha@linux.microsoft.com>

* https://lore.kernel.org/all/20241210-converge-secs-to-jiffies-v3-0-ddfefd7e9f2a@linux.microsoft.com/

---
Changes in v2:
- Remove unneeded range checks in rbd and libceph. While there, convert
  some timeouts that should have been fixed in part 1. (Ilya)
- Fixup secs_to_jiffies.cocci to be a bit more verbose
- Link to v1: https://lore.kernel.org/r/20250128-converge-secs-to-jiffies-part-two-v1-0-9a6ecf0b2308@linux.microsoft.com

---
Easwar Hariharan (3):
      coccinelle: misc: secs_to_jiffies: Patch expressions too
      rbd: convert timeouts to secs_to_jiffies()
      libceph: convert timeouts to secs_to_jiffies()

 drivers/block/rbd.c                           |  8 +++-----
 include/linux/ceph/libceph.h                  | 12 ++++++------
 net/ceph/ceph_common.c                        | 18 ++++++------------
 net/ceph/osd_client.c                         |  3 +--
 scripts/coccinelle/misc/secs_to_jiffies.cocci | 10 ++++++++++
 5 files changed, 26 insertions(+), 25 deletions(-)
---
base-commit: 00f3246adeeacbda0bd0b303604e46eb59c32e6e
change-id: 20241217-converge-secs-to-jiffies-part-two-f44017aa6f67

Best regards,
-- 
Easwar Hariharan <eahariha@linux.microsoft.com>


