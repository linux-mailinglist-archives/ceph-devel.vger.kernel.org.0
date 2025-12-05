Return-Path: <ceph-devel+bounces-4161-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id BA1C3CA6479
	for <lists+ceph-devel@lfdr.de>; Fri, 05 Dec 2025 07:55:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 1C09C31365D5
	for <lists+ceph-devel@lfdr.de>; Fri,  5 Dec 2025 06:53:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E9DF1217722;
	Fri,  5 Dec 2025 06:53:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FHIZL+/3"
X-Original-To: ceph-devel@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A821C248881
	for <ceph-devel@vger.kernel.org>; Fri,  5 Dec 2025 06:53:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764917601; cv=none; b=ntEgF55fEKIXXSUZn40O/XDEkDofrluTqIVkNCLYKi/c8rNb/WWq4qShOvowzbUvDS0E1L0KWdTboC26vLgMB8H+o7y2ABsWuI7hs+LFFbBriwXckhknrWCymunGRQoOt+kVtedlXv8fDognLMrx7+OZgS8x0cTwa2b1k4uIXLU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764917601; c=relaxed/simple;
	bh=Bw5dEQ3A3g0qIJ4WezPuE9KqjrTeAa6Z7lhl5GUIklU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=EpNWTZOjoW2sBF79V+Na7CmPHZ7eYoZB6JKrnym8L6RG85VvzXJw9AfIXUAigv/Io+1fS0ZNePN9246I6YpOi0yoG8MehbCBr2+wCByE2krJ5BcTH/FMIL+OeTFRoio9Q/qxs2IxJSgGgsl8/hHSrWThsfGalgggwwHKCP4PUko=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FHIZL+/3; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DB3AC116D0;
	Fri,  5 Dec 2025 06:53:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764917601;
	bh=Bw5dEQ3A3g0qIJ4WezPuE9KqjrTeAa6Z7lhl5GUIklU=;
	h=From:To:Cc:Subject:Date:From;
	b=FHIZL+/38Vf5GFZ833QB8mU1wx2YO3kcUhroWtvQzYmGNKUUmXyoQbbslGdJSKuSM
	 NHz6+Kz7T3yjVicWX0NhfudQEB3uYSD8aqZoaCavMBbNMsjnpJctePdUnzgNNkrbO1
	 difHsUkMWWexfa7MBGl02AKEA5QgJY8j0NHen7Y7QvbltKEcKmD6gozgrGc42vf0A9
	 8jYEXUryNL6G1dI5R+eWad6DZC+vLHGhqxeJR4rROb+5BQ2svTS59RlHeMI86sCh6J
	 Y4Z9DDn24xl455Ql8Kl2r1X7t5nF7nHeek65HatTqLMoZfiyOCDi+Tv99DlnZWMnd9
	 y5BCwb5tit9Iw==
From: Eric Biggers <ebiggers@kernel.org>
To: Xiubo Li <xiubli@redhat.com>,
	Ilya Dryomov <idryomov@gmail.com>,
	ceph-devel@vger.kernel.org
Cc: Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH v2] ceph: stop selecting CRC32, CRYPTO, and CRYPTO_AES
Date: Thu,  4 Dec 2025 22:51:04 -0800
Message-ID: <20251205065104.103210-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.52.0
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

None of the CEPH_FS code directly requires CRC32, CRYPTO, or CRYPTO_AES.
These options do get selected indirectly anyway via CEPH_LIB, which does
need them, but there is no need for CEPH_FS to select them too.

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---

v2: also remove CRC32

 fs/ceph/Kconfig | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/fs/ceph/Kconfig b/fs/ceph/Kconfig
index 3e7def3d31c1..3d64a316ca31 100644
--- a/fs/ceph/Kconfig
+++ b/fs/ceph/Kconfig
@@ -1,13 +1,10 @@
 # SPDX-License-Identifier: GPL-2.0-only
 config CEPH_FS
 	tristate "Ceph distributed file system"
 	depends on INET
 	select CEPH_LIB
-	select CRC32
-	select CRYPTO_AES
-	select CRYPTO
 	select NETFS_SUPPORT
 	select FS_ENCRYPTION_ALGS if FS_ENCRYPTION
 	default n
 	help
 	  Choose Y or M here to include support for mounting the

base-commit: bc04acf4aeca588496124a6cf54bfce3db327039
-- 
2.52.0


