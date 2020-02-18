Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 43E371627C2
	for <lists+ceph-devel@lfdr.de>; Tue, 18 Feb 2020 15:11:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726442AbgBROLL (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 18 Feb 2020 09:11:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:51208 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726373AbgBROLK (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Tue, 18 Feb 2020 09:11:10 -0500
Received: from tleilax.poochiereds.net (68-20-15-154.lightspeed.rlghnc.sbcglobal.net [68.20.15.154])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E378D21D56;
        Tue, 18 Feb 2020 14:11:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582035070;
        bh=RjqIIjOI76L0MRNxOoXWcXcgTrDoXN8aJ2GksgNfmsM=;
        h=From:To:Cc:Subject:Date:From;
        b=VJdQMc2RDNQ/8d4arpE3k2pfdfR5GAf4wp388iTNhByl5zBigb3Ghspu9HZIfDSn8
         1TF6Q2U2vAJ8gLwKJEA2XK3IiKhMtWFpc5ep9jq843oYAxQBlh6Kp8IxJieYMamxdo
         7Xa+iocKH7HyksdOxI33pjdG2EKtqmmrC5NWS8m4=
From:   Jeff Layton <jlayton@kernel.org>
To:     ceph-devel@vger.kernel.org
Cc:     idryomov@gmail.com, sage@redhat.com, zyan@redhat.com
Subject: [PATCH] ceph: reorganize fields in ceph_mds_request
Date:   Tue, 18 Feb 2020 09:11:08 -0500
Message-Id: <20200218141108.26421-1-jlayton@kernel.org>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

This shrinks the struct size by 16 bytes.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/ceph/mds_client.h | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/ceph/mds_client.h b/fs/ceph/mds_client.h
index 27a7446e10d3..a0918d00117c 100644
--- a/fs/ceph/mds_client.h
+++ b/fs/ceph/mds_client.h
@@ -263,6 +263,7 @@ struct ceph_mds_request {
 	int r_fmode;        /* file mode, if expecting cap */
 	kuid_t r_uid;
 	kgid_t r_gid;
+	int r_request_release_offset;
 	struct timespec64 r_stamp;
 
 	/* for choosing which mds to send this request to */
@@ -280,11 +281,12 @@ struct ceph_mds_request {
 	int r_old_inode_drop, r_old_inode_unless;
 
 	struct ceph_msg  *r_request;  /* original request */
-	int r_request_release_offset;
 	struct ceph_msg  *r_reply;
 	struct ceph_mds_reply_info_parsed r_reply_info;
 	struct page *r_locked_page;
 	int r_err;
+	int r_num_caps;
+	u32               r_readdir_offset;
 
 	unsigned long r_timeout;  /* optional.  jiffies, 0 is "wait forever" */
 	unsigned long r_started;  /* start time to measure timeout against */
@@ -315,10 +317,8 @@ struct ceph_mds_request {
 	long long	  r_dir_release_cnt;
 	long long	  r_dir_ordered_cnt;
 	int		  r_readdir_cache_idx;
-	u32               r_readdir_offset;
 
 	struct ceph_cap_reservation r_caps_reservation;
-	int r_num_caps;
 };
 
 struct ceph_pool_perm {
-- 
2.24.1

