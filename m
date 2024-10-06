Return-Path: <ceph-devel+bounces-1892-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 24BAF991BBB
	for <lists+ceph-devel@lfdr.de>; Sun,  6 Oct 2024 03:21:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 40A871C20FBA
	for <lists+ceph-devel@lfdr.de>; Sun,  6 Oct 2024 01:21:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A434713633F;
	Sun,  6 Oct 2024 01:20:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=treblig.org header.i=@treblig.org header.b="dBKnlPGp"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mx.treblig.org (mx.treblig.org [46.235.229.95])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5659C125;
	Sun,  6 Oct 2024 01:20:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.235.229.95
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728177606; cv=none; b=sGOPIb17PQB8dSv/PubYw/OR9LrSqUbJ1E1bL5Mkk8aBE/mZ6PKDWiBQ4QvioKbclaIenSdcbhcCFdvPGVjuncp3hYQeNtQpnEiZ/qO9mRDLBk542CFaKLzMSPnFDeUTu2v8RwGWv9kWljL2ub3ViF9ISdn5ViBXqqtZhzVzAbg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728177606; c=relaxed/simple;
	bh=K5QznJ7oLJq0CHCu1m0LWOUpKLw/YOlJ7Q+ZHactze8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=LAXQ2vdhePQCI4m1sTQzEkp61MzsAbWje2J3m0Law6mDh0J9NbIQwo5Wy6B1iPdSENEpGRIp/+55isyFKwIFWFl7wCjs6ppdSZ2kBKMW26uy5wQlcgFdCeRn0E494QuRPwx4DGeYkhDG6tnhGA8Nz79zxE7ARYqRmvp3gljApC8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=treblig.org; spf=pass smtp.mailfrom=treblig.org; dkim=pass (2048-bit key) header.d=treblig.org header.i=@treblig.org header.b=dBKnlPGp; arc=none smtp.client-ip=46.235.229.95
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=treblig.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=treblig.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=treblig.org
	; s=bytemarkmx; h=MIME-Version:Message-ID:Date:Subject:From:Content-Type:From
	:Subject; bh=zOmjNsQeGB4gYpz+P8xM7+JLeAOzJIzD4/EaLpDFxLM=; b=dBKnlPGpwTOaOJ5j
	rG+6ndepMBFdUKMltOTg8395YbJWBik5wvnXyuTBIeibl8VMdmAAxE1dGJqQcAlNHy79mD/iRBwPg
	JfuU+9MEMUg+q1qjrN8KYGwR0zbYwO56jN44TksVolrMX+ZoWDJ4avWr04eKwOjcGeMAjxHaGavPh
	zrCjGTF9a3NGEN/kk/E/4kbeQ0P7nxbTiadBZkKOFtK5OuBujlrXaBRegV/bzwpaQytX6pMMTOlef
	NAJHbt5IEygigZSz+JgxBmELBc5zhCZbSWeGo2lPuVyYY4PjkAmAcYmNhfDyrJTmOGH+1VDNtWdlj
	H/frKNzc/IICNLiK/Q==;
Received: from localhost ([127.0.0.1] helo=dalek.home.treblig.org)
	by mx.treblig.org with esmtp (Exim 4.96)
	(envelope-from <linux@treblig.org>)
	id 1sxFwD-009DsK-27;
	Sun, 06 Oct 2024 01:19:57 +0000
From: linux@treblig.org
To: xiubli@redhat.com,
	idryomov@gmail.com,
	ceph-devel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	"Dr. David Alan Gilbert" <linux@treblig.org>
Subject: [PATCH 0/5] Ceph deadcoding
Date: Sun,  6 Oct 2024 02:19:51 +0100
Message-ID: <20241006011956.373622-1-linux@treblig.org>
X-Mailer: git-send-email 2.46.2
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: "Dr. David Alan Gilbert" <linux@treblig.org>

Hi,
  This series is a set of deadcoding in fs/ceph and net/ceph.
It's strictly function deletion so should have no change
in behaviour.

(get_maintainer was suggesting the netdev team as well
as ceph? Is that correct???)

Build & boot tested on x86-64.

Dave

Dr. David Alan Gilbert (5):
  libceph: Remove unused ceph_pagelist functions
  libceph: Remove unused pagevec functions
  libceph: Remove unused ceph_osdc_watch_check
  libceph: Remove unused ceph_crypto_key_encode
  ceph: Remove fs/ceph deadcode

 fs/ceph/caps.c                  | 14 ---------
 fs/ceph/mds_client.c            |  8 -----
 fs/ceph/mds_client.h            |  2 --
 fs/ceph/super.h                 |  1 -
 include/linux/ceph/libceph.h    |  6 ----
 include/linux/ceph/osd_client.h |  2 --
 include/linux/ceph/pagelist.h   | 12 --------
 net/ceph/crypto.c               | 12 --------
 net/ceph/crypto.h               |  1 -
 net/ceph/osd_client.c           | 34 ---------------------
 net/ceph/pagelist.c             | 38 ------------------------
 net/ceph/pagevec.c              | 52 ---------------------------------
 12 files changed, 182 deletions(-)

-- 
2.46.2


