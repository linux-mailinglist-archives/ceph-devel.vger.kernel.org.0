Return-Path: <ceph-devel+bounces-4156-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 66456CA279D
	for <lists+ceph-devel@lfdr.de>; Thu, 04 Dec 2025 07:13:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id D89B5304C2BE
	for <lists+ceph-devel@lfdr.de>; Thu,  4 Dec 2025 06:13:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 49E7C281504;
	Thu,  4 Dec 2025 06:13:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HqAKruEJ"
X-Original-To: ceph-devel@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09E35F513
	for <ceph-devel@vger.kernel.org>; Thu,  4 Dec 2025 06:13:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764828832; cv=none; b=k9mvXf0p791bHs4vnVZ++GimzzxC+EvJGydGuRlz/mjYWgX8+r+JHp9DRP1fCzjl57ZAyU9Yb+fEAJZcNcmNgeLsXX4Z3YRDNzrEejwXOQUTWfdLYMIlNpvBvY74bH8zA2Oj9WDPthUi+pG1nCqBfDA92O/8OYpFE7vLs4Pe7nk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764828832; c=relaxed/simple;
	bh=4iWM+RalKFlnsFGGE0HlLOqVYnKGyTMxfBEzI4y7R5g=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=YVjAz6IfpzyNbb2oNhOL9extr2m91TjZxw5mP97NK0uvaelhFfbCLzV8uzAYy/DkAHDCcC17GDcjy5/4zoUN4/iXQoai2ZNKPoNwLzHKMWJkLLcargyaZebtP+23ZIbp5+1lR3rJ2F7JCrGVSnWEhmZsjTdjGJ7Tekut4SFkB/o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HqAKruEJ; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71F70C113D0;
	Thu,  4 Dec 2025 06:13:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764828831;
	bh=4iWM+RalKFlnsFGGE0HlLOqVYnKGyTMxfBEzI4y7R5g=;
	h=From:To:Cc:Subject:Date:From;
	b=HqAKruEJDImR03niZGXyWN/WSd5VwI7lQZF5d0JGxixWdL4UkrpqD8fg0G4m3duZU
	 RLSaI5mSccHI7bo+qi0wA8YgaVYHhCS7WEk3pw9TXngAXYra0ru/qtCUxGBeJ6NmuY
	 icnn3WwZSYeCR1x8iA7VW+10nBNsWBWTAZYIvrkM27XaM/aUfJlNr0JwOYVb28Gcbt
	 vXhYoCkgcTzdXPc7ikJA2FdxVtiroUhggAWepEaup9OnZAjY2hR/y3zYWxxN54f9Rr
	 A3i5oUNm5rQTKTiIF/C/6hlVtfCMtBS1EihF/YmzhxO+4m6Q4j3z1ExfZCdDz7oP8z
	 MPZJjG1LGn+aA==
From: Eric Biggers <ebiggers@kernel.org>
To: Xiubo Li <xiubli@redhat.com>,
	Ilya Dryomov <idryomov@gmail.com>,
	ceph-devel@vger.kernel.org
Cc: Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH] ceph: stop selecting CRYPTO and CRYPTO_AES
Date: Wed,  3 Dec 2025 22:11:18 -0800
Message-ID: <20251204061118.498220-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.52.0
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

None of the CEPH_FS code directly requires CRYPTO or CRYPTO_AES.  These
options do get selected indirectly anyway via CEPH_LIB, which does need
them, but there is no need for CEPH_FS to select them too.

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 fs/ceph/Kconfig | 2 --
 1 file changed, 2 deletions(-)

diff --git a/fs/ceph/Kconfig b/fs/ceph/Kconfig
index 3e7def3d31c1..01a3e9a3a4fe 100644
--- a/fs/ceph/Kconfig
+++ b/fs/ceph/Kconfig
@@ -2,12 +2,10 @@
 config CEPH_FS
 	tristate "Ceph distributed file system"
 	depends on INET
 	select CEPH_LIB
 	select CRC32
-	select CRYPTO_AES
-	select CRYPTO
 	select NETFS_SUPPORT
 	select FS_ENCRYPTION_ALGS if FS_ENCRYPTION
 	default n
 	help
 	  Choose Y or M here to include support for mounting the

base-commit: b2c27842ba853508b0da00187a7508eb3a96c8f7
-- 
2.52.0


