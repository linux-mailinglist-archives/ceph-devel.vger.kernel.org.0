Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 88A5ED75D6
	for <lists+ceph-devel@lfdr.de>; Tue, 15 Oct 2019 14:08:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730572AbfJOMIy (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 15 Oct 2019 08:08:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:41550 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726540AbfJOMIx (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Tue, 15 Oct 2019 08:08:53 -0400
Received: from tleilax.poochiereds.net (68-20-15-154.lightspeed.rlghnc.sbcglobal.net [68.20.15.154])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E34EC205F4;
        Tue, 15 Oct 2019 12:08:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1571141333;
        bh=FIiuMvLQBd4N732u5C4vfUfF3K7FEl2CkuvxEyqeyck=;
        h=From:To:Cc:Subject:Date:From;
        b=ka/zwXLsX/iTzif1QOUiMmCC2KmKbU0NsEItX4R31Fhf1bBYjqYyaIIZXvXmiaPIP
         20cTpWSinJ9xUQiKUSHCrx1HRy2o8btMR8bS2/WfcQ1R7icJt6B5aqBZbBIg0ro5p1
         nyIBiZZwVmb+XQgW/W+RoOC520PCNAIIO7SU8UFg=
From:   Jeff Layton <jlayton@kernel.org>
To:     ceph-devel@vger.kernel.org
Cc:     idryomov@gmail.com, sage@redhat.com, zyan@redhat.com
Subject: [PATCH] ceph: make several helper accessors take const pointers
Date:   Tue, 15 Oct 2019 08:08:51 -0400
Message-Id: <20191015120851.13788-1-jlayton@kernel.org>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

None of these helper functions change anything in memory, so we can
declare their arguments as const.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/ceph/super.h | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/fs/ceph/super.h b/fs/ceph/super.h
index e174425cf44c..3bf1a01cd536 100644
--- a/fs/ceph/super.h
+++ b/fs/ceph/super.h
@@ -406,22 +406,26 @@ struct ceph_inode_info {
 	struct inode vfs_inode; /* at end */
 };
 
-static inline struct ceph_inode_info *ceph_inode(struct inode *inode)
+static inline struct ceph_inode_info *
+ceph_inode(const struct inode *inode)
 {
 	return container_of(inode, struct ceph_inode_info, vfs_inode);
 }
 
-static inline struct ceph_fs_client *ceph_inode_to_client(struct inode *inode)
+static inline struct ceph_fs_client *
+ceph_inode_to_client(const struct inode *inode)
 {
 	return (struct ceph_fs_client *)inode->i_sb->s_fs_info;
 }
 
-static inline struct ceph_fs_client *ceph_sb_to_client(struct super_block *sb)
+static inline struct ceph_fs_client *
+ceph_sb_to_client(const struct super_block *sb)
 {
 	return (struct ceph_fs_client *)sb->s_fs_info;
 }
 
-static inline struct ceph_vino ceph_vino(struct inode *inode)
+static inline struct ceph_vino
+ceph_vino(const struct inode *inode)
 {
 	return ceph_inode(inode)->i_vino;
 }
-- 
2.21.0

