Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 80099285EE9
	for <lists+ceph-devel@lfdr.de>; Wed,  7 Oct 2020 14:17:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728165AbgJGMRG (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 7 Oct 2020 08:17:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:41386 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728159AbgJGMRG (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Wed, 7 Oct 2020 08:17:06 -0400
Received: from tleilax.com (68-20-15-154.lightspeed.rlghnc.sbcglobal.net [68.20.15.154])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DC5712080A;
        Wed,  7 Oct 2020 12:17:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602073025;
        bh=gF3voaBm2copooG2glx9EOo01/CXMpMjhX84fpOBpdQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YoyXaPDt5X2XCEGsCKSngXi91Yf2woIgCFklhibQCmUsZ+L++OB2OkyP9IXGdbTIG
         SqObnrflHkYlLl32HFFMvmi5ewAgoK77ecoMu5HobpHgXbGNtwZft6npdbYChhmx0K
         qXaIsLttMXr5RUUTJBdgis5AaZ53CT1BYTjp78MQ=
From:   Jeff Layton <jlayton@kernel.org>
To:     ceph-devel@vger.kernel.org
Cc:     idryomov@gmail.com, ukernel@gmail.com, pdonnell@redhat.com
Subject: [PATCH v4 2/5] ceph: make fsc->mount_state an int
Date:   Wed,  7 Oct 2020 08:16:57 -0400
Message-Id: <20201007121700.10489-3-jlayton@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201007121700.10489-1-jlayton@kernel.org>
References: <20201007121700.10489-1-jlayton@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

This field is an unsigned long currently, which is a bit of a waste on
most arches since this just holds an enum. Make it (signed) int instead.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/ceph/super.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ceph/super.h b/fs/ceph/super.h
index 582694899130..d0cb6a51c6a4 100644
--- a/fs/ceph/super.h
+++ b/fs/ceph/super.h
@@ -106,7 +106,7 @@ struct ceph_fs_client {
 	struct ceph_mount_options *mount_options;
 	struct ceph_client *client;
 
-	unsigned long mount_state;
+	int mount_state;
 
 	unsigned long last_auto_reconnect;
 	bool blocklisted;
-- 
2.26.2

