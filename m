Return-Path: <ceph-devel+bounces-3729-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C5366B9EC92
	for <lists+ceph-devel@lfdr.de>; Thu, 25 Sep 2025 12:46:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A04324C6386
	for <lists+ceph-devel@lfdr.de>; Thu, 25 Sep 2025 10:46:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 44FA82FB99B;
	Thu, 25 Sep 2025 10:43:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=synology.com header.i=@synology.com header.b="BwRTTfnS"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail.synology.com (mail.synology.com [211.23.38.101])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 371652FB629
	for <ceph-devel@vger.kernel.org>; Thu, 25 Sep 2025 10:43:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.23.38.101
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758796983; cv=none; b=VTIPfCV7BZK/Lqth6TskFJOSjKUFgKasykSo1RmX6T3xb37WgCQT+PPeVeCGXUM+LGsriP9bo7sDki6FwrNftXTle4sl7PETljxWYWBTCGS/cNubEzaRsiYgDWUZsEjkUk0fr5SuilfIcnBhTSqJd3JLQmlBjSytfIWy+PX1Xwc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758796983; c=relaxed/simple;
	bh=fw9kGRn/fctMx6K555/kzAQMklsaCb2N9bXohjHROYU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=sZ4wE0o2UYG3g+vnol13PdGC54YJKPm/HgARRHSS5regfsxNgLmt9fV1D8zAv376Z+bIOcboBjvQzZO6rkkrn/pzdB66CgL33Yxnxqx5SVgQt06NbSi92yPwmPL3cvyBFWpRY7KRVRgXvZhgl+r3NFjQjg9xDni5kJwne8o22+0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=synology.com; spf=pass smtp.mailfrom=synology.com; dkim=pass (1024-bit key) header.d=synology.com header.i=@synology.com header.b=BwRTTfnS; arc=none smtp.client-ip=211.23.38.101
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=synology.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=synology.com
From: ethanwu <ethanwu@synology.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synology.com; s=123;
	t=1758796973; bh=fw9kGRn/fctMx6K555/kzAQMklsaCb2N9bXohjHROYU=;
	h=From:To:Cc:Subject:Date;
	b=BwRTTfnSeN1ovlaQGYGGJhgWtV1lJcgKGgtgdrxcifcmi7RWjheL/UK0tOz6/XBWr
	 Qh+dzw4NyBfM5mcOy15GNeIJITg7v/cwBMTVDOYhR8BOg5zouL6CpmF+T0cVKyoAOc
	 947I8lMqA8HZFei67C1cMi81G5YY0bo5aaXtktaA=
To: ceph-devel@vger.kernel.org
Cc: xiubli@redhat.com,
	idryomov@gmail.com,
	Slava.Dubeyko@ibm.com,
	Pavan.Rallabhandi@ibm.com,
	ethanwu@synology.com
Subject: [PATCH 0/2] ceph: fix missing snapshot context in write operations
Date: Thu, 25 Sep 2025 18:42:04 +0800
Message-ID: <20250925104228.95018-1-ethanwu@synology.com>
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Synology-Spam-Status: score=0, required 6, WHITELIST_FROM_ADDRESS 0
X-Synology-Spam-Flag: no
X-Synology-Virus-Status: no
X-Synology-MCP-Status: no
Content-Type: text/plain

This series addresses two instances where Ceph filesystem operations
were missing proper snapshot context handling, which could lead to
data inconsistencies in snapshots.

The issue occurs in two scenarios:
1. ceph_zero_partial_object() during fallocate punch hole operations
2. ceph_uninline_data() when converting inline data to regular objects

Both functions were passing NULL snapshot context to OSD write
operations instead of acquiring the appropriate context. This could
result in snapshot data corruption where subsequent reads from snapshots
 would return modified data instead of the original snapshot content.

The fix ensures that proper snapshot context is acquired and passed to
all OSD write operations in these code paths.

ethanwu (2):
  ceph: fix snapshot context missing in ceph_zero_partial_object
  ceph: fix snapshot context missing in ceph_uninline_data

 fs/ceph/addr.c | 24 ++++++++++++++++++++++--
 fs/ceph/file.c | 17 ++++++++++++++++-
 2 files changed, 38 insertions(+), 3 deletions(-)

-- 
2.43.0


Disclaimer: The contents of this e-mail message and any attachments are confidential and are intended solely for addressee. The information may also be legally privileged. This transmission is sent in trust, for the sole purpose of delivery to the intended recipient. If you have received this transmission in error, any use, reproduction or dissemination of this transmission is strictly prohibited. If you are not the intended recipient, please immediately notify the sender by reply e-mail or phone and delete this message and its attachments, if any.

