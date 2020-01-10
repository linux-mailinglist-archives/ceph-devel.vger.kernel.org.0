Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 861A2137830
	for <lists+ceph-devel@lfdr.de>; Fri, 10 Jan 2020 21:57:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727226AbgAJU45 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 10 Jan 2020 15:56:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:49050 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727185AbgAJU4y (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Fri, 10 Jan 2020 15:56:54 -0500
Received: from tleilax.com (68-20-15-154.lightspeed.rlghnc.sbcglobal.net [68.20.15.154])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6FB0520880;
        Fri, 10 Jan 2020 20:56:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578689814;
        bh=z1+2TMd15ZH6VDkhDq88yLRvwba/YhR1dXmQkvUF/dc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MEBFeYFplkWEuUFeShlx55Byf0uMo7DhU4Mpl06GUz1BbGjTrUMzFlOCp7fdPSkPE
         EYzSB2uJXZWUbmLmYg5U769VkAsT33m4fedxxPKafhnElEnsCfApQP9hCHD4mkAwaA
         rYTSXICrNVal2QQAx3bMgd02BCBpvc7YEr04Dz/8=
From:   Jeff Layton <jlayton@kernel.org>
To:     ceph-devel@vger.kernel.org
Cc:     zyan@redhat.com, sage@redhat.com, idryomov@gmail.com,
        pdonnell@redhat.com
Subject: [RFC PATCH 5/9] libceph: export ceph_file_layout_is_valid
Date:   Fri, 10 Jan 2020 15:56:43 -0500
Message-Id: <20200110205647.311023-6-jlayton@kernel.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200110205647.311023-1-jlayton@kernel.org>
References: <20200110205647.311023-1-jlayton@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 net/ceph/ceph_fs.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/ceph/ceph_fs.c b/net/ceph/ceph_fs.c
index 756a2dc10d27..11a2e3c61b04 100644
--- a/net/ceph/ceph_fs.c
+++ b/net/ceph/ceph_fs.c
@@ -27,6 +27,7 @@ int ceph_file_layout_is_valid(const struct ceph_file_layout *layout)
 		return 0;
 	return 1;
 }
+EXPORT_SYMBOL(ceph_file_layout_is_valid);
 
 void ceph_file_layout_from_legacy(struct ceph_file_layout *fl,
 				  struct ceph_file_layout_legacy *legacy)
-- 
2.24.1

