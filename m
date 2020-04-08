Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4A4B91A23F1
	for <lists+ceph-devel@lfdr.de>; Wed,  8 Apr 2020 16:21:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728568AbgDHOV3 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 8 Apr 2020 10:21:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:46754 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727486AbgDHOV3 (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Wed, 8 Apr 2020 10:21:29 -0400
Received: from tleilax.poochiereds.net (68-20-15-154.lightspeed.rlghnc.sbcglobal.net [68.20.15.154])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 526A420857;
        Wed,  8 Apr 2020 14:21:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586355688;
        bh=MVgQ/zfcKvN2INdj0qt5axdnSVv+K7sV5pB7sBXnZtg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=U9HqXeqW0yhUGEULu9vhmayBD70lK2Cps7jMu+72VJZaXi6JUOFbGJd022ISSpeHr
         qNCZaKDZZDycSNXML7CQA8eyEvudX15C6J0aY2Xyg5rPM3XesaXYmlJhfKjhBiPGCH
         kh0+6sjjYa9fDQ6DqhyqbCXNSo+p/ApfTh8si/9c=
From:   Jeff Layton <jlayton@kernel.org>
To:     ceph-devel@vger.kernel.org
Cc:     idryomov@gmail.com, dan.carpenter@oracle.com, sage@redhat.com
Subject: [PATCH 2/2] ceph: initialize base and pathlen variables in async dirops cb's
Date:   Wed,  8 Apr 2020 10:21:25 -0400
Message-Id: <20200408142125.52908-3-jlayton@kernel.org>
X-Mailer: git-send-email 2.25.2
In-Reply-To: <20200408142125.52908-1-jlayton@kernel.org>
References: <20200408142125.52908-1-jlayton@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Ensure that the pr_warn messages look sane even if ceph_mdsc_build_path
fails.

Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/ceph/dir.c  | 4 ++--
 fs/ceph/file.c | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/ceph/dir.c b/fs/ceph/dir.c
index 10d528a455d5..93476d447a4b 100644
--- a/fs/ceph/dir.c
+++ b/fs/ceph/dir.c
@@ -1057,8 +1057,8 @@ static void ceph_async_unlink_cb(struct ceph_mds_client *mdsc,
 
 	/* If op failed, mark everyone involved for errors */
 	if (result) {
-		int pathlen;
-		u64 base;
+		int pathlen = 0;
+		u64 base = 0;
 		char *path = ceph_mdsc_build_path(req->r_dentry, &pathlen,
 						  &base, 0);
 
diff --git a/fs/ceph/file.c b/fs/ceph/file.c
index 3a1bd13de84f..160644ddaeed 100644
--- a/fs/ceph/file.c
+++ b/fs/ceph/file.c
@@ -529,8 +529,8 @@ static void ceph_async_create_cb(struct ceph_mds_client *mdsc,
 
 	if (result) {
 		struct dentry *dentry = req->r_dentry;
-		int pathlen;
-		u64 base;
+		int pathlen = 0;
+		u64 base = 0;
 		char *path = ceph_mdsc_build_path(req->r_dentry, &pathlen,
 						  &base, 0);
 
-- 
2.25.2

