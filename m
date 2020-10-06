Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AAE80284E5B
	for <lists+ceph-devel@lfdr.de>; Tue,  6 Oct 2020 16:55:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726398AbgJFOzh (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 6 Oct 2020 10:55:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:38200 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725943AbgJFOzc (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Tue, 6 Oct 2020 10:55:32 -0400
Received: from tleilax.com (68-20-15-154.lightspeed.rlghnc.sbcglobal.net [68.20.15.154])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F405A20782;
        Tue,  6 Oct 2020 14:55:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601996131;
        bh=gF3voaBm2copooG2glx9EOo01/CXMpMjhX84fpOBpdQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0D4KvxfRBCJzH2Erpr4RO9Nl38IlZi5bTbi/7lx4vi30lacUoh9X9SyQ4GD3+PVB9
         iIrXvu7ZznUbNfo5Y6/VD4FTagZzTFBGi2fTczoDuzHldgBjoTYjnYpScrV9CmFrxw
         HbSUiz7f6dnbhQKaNlpoHdciTpdhud7fgaaJK5Bg=
From:   Jeff Layton <jlayton@kernel.org>
To:     ceph-devel@vger.kernel.org
Cc:     idryomov@gmail.com, ukernel@gmail.com, pdonnell@redhat.com
Subject: [PATCH v3 2/5] ceph: make fsc->mount_state an int
Date:   Tue,  6 Oct 2020 10:55:23 -0400
Message-Id: <20201006145526.313151-3-jlayton@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201006145526.313151-1-jlayton@kernel.org>
References: <20201006145526.313151-1-jlayton@kernel.org>
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

