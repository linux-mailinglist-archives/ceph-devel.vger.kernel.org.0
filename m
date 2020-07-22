Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F23F52296B6
	for <lists+ceph-devel@lfdr.de>; Wed, 22 Jul 2020 12:56:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728597AbgGVKzZ (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 22 Jul 2020 06:55:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:53614 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728277AbgGVKzV (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Wed, 22 Jul 2020 06:55:21 -0400
Received: from tleilax.com (68-20-15-154.lightspeed.rlghnc.sbcglobal.net [68.20.15.154])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 63EBB20771;
        Wed, 22 Jul 2020 10:55:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595415320;
        bh=dOc715JVh7iKo4HwGuHSp6cKvvlHjVAE8oF8KIZtpH0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hj/sYtrzSpzw3I34o5B6LhUN28JzosvwRvzr/Bg9FshMOCWmRmNItqtl0FSTQHBDE
         +wt2PUEMwkW2VrwCnK9vaTjKQLfd4oF2gnoJm2X8hc7U2BAa5mG7mqsuBH36EDJh50
         10LoqueSOHSJE0bHM3XDjxogkLgeDIxQTVo+/oTg=
From:   Jeff Layton <jlayton@kernel.org>
To:     ceph-devel@vger.kernel.org
Cc:     dhowells@redhat.com, dwysocha@redhat.com, smfrench@gmail.com
Subject: [RFC PATCH 11/11] ceph: re-enable fscache support
Date:   Wed, 22 Jul 2020 06:55:11 -0400
Message-Id: <20200722105511.11187-12-jlayton@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200722105511.11187-1-jlayton@kernel.org>
References: <20200722105511.11187-1-jlayton@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/ceph/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ceph/Kconfig b/fs/ceph/Kconfig
index 734d08b57ef9..bc5656966aca 100644
--- a/fs/ceph/Kconfig
+++ b/fs/ceph/Kconfig
@@ -21,7 +21,7 @@ config CEPH_FS
 if CEPH_FS
 config CEPH_FSCACHE
 	bool "Enable Ceph client caching support"
-	depends on CEPH_FS=m && FSCACHE_OLD || CEPH_FS=y && FSCACHE_OLD=y
+	depends on CEPH_FS=m && FSCACHE || CEPH_FS=y && FSCACHE=y
 	help
 	  Choose Y here to enable persistent, read-only local
 	  caching support for Ceph clients using FS-Cache
-- 
2.26.2

