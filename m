Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B3C1349D0E2
	for <lists+ceph-devel@lfdr.de>; Wed, 26 Jan 2022 18:36:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243812AbiAZRg4 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 26 Jan 2022 12:36:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237183AbiAZRgy (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 26 Jan 2022 12:36:54 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4075FC06161C
        for <ceph-devel@vger.kernel.org>; Wed, 26 Jan 2022 09:36:54 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F09AEB81CAE
        for <ceph-devel@vger.kernel.org>; Wed, 26 Jan 2022 17:36:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 269B0C340E3;
        Wed, 26 Jan 2022 17:36:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643218611;
        bh=uieEgkR4lrhfnp7wL5YsHWwIzgRBXF8M5/vQsaa9PC0=;
        h=From:To:Cc:Subject:Date:From;
        b=msd2FjQFS6HocWp6dwH+G8uUDX1wY3j7WFomdZix/oasUOLcbWNLjX6OxmyHwDIBm
         PeFW/sSb6JAsrlz8TgzJbaKyr+WmHmrm8fsl7JjSSrueR1+C5pWm2xXofUCGqCs2kX
         40jIri7IQQM9Z5GBXPuonLksELUCcsC63LpgU9kXUByOfBF6/yX7WzACbRV0m3fsZ3
         Grc2BwdY+c6Kwqw0ImeEyZb9sgNVZ9D71sWgGSAmNwvU5E8q4WMSrndznteFhXMVbt
         SW0K01jb9XvsYjwxx14SdBTjDWaYCA7/I3qsk3GCUNYJ2t/htlPjo04nc9mqS/zIni
         +BEEq68UnnZaQ==
From:   Jeff Layton <jlayton@kernel.org>
To:     ceph-devel@vger.kernel.org
Cc:     idryomov@gmail.com, Dan van der Ster <dan@vanderster.com>
Subject: [PATCH v2] ceph: set pool_ns in new inode layout for async creates
Date:   Wed, 26 Jan 2022 12:36:49 -0500
Message-Id: <20220126173649.163500-1-jlayton@kernel.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Dan reported that he was unable to write to files that had been
asynchronously created when the client's OSD caps are restricted to a
particular namespace.

The issue is that the layout for the new inode is only partially being
filled. Ensure that we populate the pool_ns_data and pool_ns_len in the
iinfo before calling ceph_fill_inode.

URL: https://tracker.ceph.com/issues/54013
Reported-by: Dan van der Ster <dan@vanderster.com>
Fixes: 9a8d03ca2e2c ("ceph: attempt to do async create when possible")
Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/ceph/file.c | 7 +++++++
 1 file changed, 7 insertions(+)

v2: don't take extra reference, just use rcu_dereference_raw

diff --git a/fs/ceph/file.c b/fs/ceph/file.c
index cbe4d5a5cde5..22ca724aef36 100644
--- a/fs/ceph/file.c
+++ b/fs/ceph/file.c
@@ -599,6 +599,7 @@ static int ceph_finish_async_create(struct inode *dir, struct dentry *dentry,
 	struct ceph_inode_info *ci = ceph_inode(dir);
 	struct inode *inode;
 	struct timespec64 now;
+	struct ceph_string *pool_ns;
 	struct ceph_mds_client *mdsc = ceph_sb_to_mdsc(dir->i_sb);
 	struct ceph_vino vino = { .ino = req->r_deleg_ino,
 				  .snap = CEPH_NOSNAP };
@@ -648,6 +649,12 @@ static int ceph_finish_async_create(struct inode *dir, struct dentry *dentry,
 	in.max_size = cpu_to_le64(lo->stripe_unit);
 
 	ceph_file_layout_to_legacy(lo, &in.layout);
+	/* lo is private, so pool_ns can't change */
+	pool_ns = rcu_dereference_raw(lo->pool_ns);
+	if (pool_ns) {
+		iinfo.pool_ns_len = pool_ns->len;
+		iinfo.pool_ns_data = pool_ns->str;
+	}
 
 	down_read(&mdsc->snap_rwsem);
 	ret = ceph_fill_inode(inode, NULL, &iinfo, NULL, req->r_session,
-- 
2.34.1

