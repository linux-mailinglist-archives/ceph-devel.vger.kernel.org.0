Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE2EA255289
	for <lists+ceph-devel@lfdr.de>; Fri, 28 Aug 2020 03:29:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727972AbgH1B3E (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 27 Aug 2020 21:29:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726147AbgH1B3C (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 27 Aug 2020 21:29:02 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 449A1C061264;
        Thu, 27 Aug 2020 18:29:02 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id o68so1067432pfg.2;
        Thu, 27 Aug 2020 18:29:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Rnno2/T7wXNQk8LQzZCrOzlnI6hdthPrV/zV4qtrmt8=;
        b=MPj+EbW1lhUSca2A5cNXiwKkMgiFGKouf0AYN6Mrq3tqOJPsenpfSYALWqEQ2N3a/E
         IZkW0t5bTDDxdBmxTaXBFbdw2ETaKWh5/N6RBRot107qPV4rMqMNNnJiJZdlvkjkGh+0
         EMrWR14frsWLJYNX5MWODFeT04pWq3kpBbK0BPdh4urOgBtBc6P+SNNlWRN9nStYOF9c
         xcAEw6vZLSFgnk//ScMeb8z1DbXAvuaD4Kr7O7EY0yggkvGtHAtRNcd+XI1InE1LU4DP
         VnahHGU1egrOogI1NL/j4X5097LTX636BKfcHvDU9w3Gqi4/efdn///hgCZFClUvkcZD
         NXUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Rnno2/T7wXNQk8LQzZCrOzlnI6hdthPrV/zV4qtrmt8=;
        b=PQwlWLQsLVBv/4MSn/1N6lg8xpi2Q+S2DuuHHKN5mabaZSdZAlL07AneJ2kRBEshYl
         +iOdoMwx7YwpxGR+g75aXDhMrMIaxwKovvIL86NJsS8iNARuFipL4MLvDf3peelKfC7L
         SHYCudzUQ/EoYNPZyzQ/pg0STxWaV75B346I50+2qEG9QR7Dl+K2gubF8/DLCImFOg2w
         FNX8nzY5qSHP3O2ER/ON8QBPSjZrW69O5r9fcpB+99oIqAsinKWNvsQ0xW0wCptS0c9s
         NA7Hd3scx4cirNKZZ2+xodMj9UPEhJxffdwcRYd4FxY4IPz/WyuKBSRjP8q1JRahTNQ3
         9xaA==
X-Gm-Message-State: AOAM532BLu5SwTa8DeHv4EzigOfaJA6A4KB7xZnkMQQ3Yxey4ZUAsILt
        VJHaHtzPkzlAuFXwpVhDMn1k6nouF43gpQ==
X-Google-Smtp-Source: ABdhPJwLIO8/F4+zfjENIhbPR96oB4UTud2Dx8+j1bEmApg/0JQ2VOJYQuRHxEKCK5fCH04WrprYyw==
X-Received: by 2002:a17:902:b282:: with SMTP id u2mr12741468plr.47.1598578141662;
        Thu, 27 Aug 2020 18:29:01 -0700 (PDT)
Received: from localhost.localdomain ([122.224.153.227])
        by smtp.gmail.com with ESMTPSA id i11sm3730715pjg.50.2020.08.27.18.28.59
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 27 Aug 2020 18:29:00 -0700 (PDT)
From:   Yanhu Cao <gmayyyha@gmail.com>
To:     jlayton@kernel.org
Cc:     idryomov@gmail.com, ceph-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org, Yanhu Cao <gmayyyha@gmail.com>
Subject: [v2] ceph: support getting ceph.dir.rsnaps vxattr
Date:   Fri, 28 Aug 2020 09:28:44 +0800
Message-Id: <20200828012844.18937-1-gmayyyha@gmail.com>
X-Mailer: git-send-email 2.24.3 (Apple Git-128)
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

It's easy to know how many snapshots have been created.

Link: https://tracker.ceph.com/issues/47168
Signed-off-by: Yanhu Cao <gmayyyha@gmail.com>
---
 fs/ceph/inode.c      | 1 +
 fs/ceph/mds_client.c | 9 ++++++++-
 fs/ceph/mds_client.h | 1 +
 fs/ceph/super.h      | 2 +-
 fs/ceph/xattr.c      | 7 +++++++
 5 files changed, 18 insertions(+), 2 deletions(-)

diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
index 357c937699d5..650cad4b3ecb 100644
--- a/fs/ceph/inode.c
+++ b/fs/ceph/inode.c
@@ -891,6 +891,7 @@ int ceph_fill_inode(struct inode *inode, struct page *locked_page,
 			ci->i_rfiles = le64_to_cpu(info->rfiles);
 			ci->i_rsubdirs = le64_to_cpu(info->rsubdirs);
 			ci->i_dir_pin = iinfo->dir_pin;
+			ci->i_rsnaps = iinfo->rsnaps;
 			ceph_decode_timespec64(&ci->i_rctime, &info->rctime);
 		}
 	}
diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
index 4a26862d7667..3466845c0179 100644
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -176,6 +176,13 @@ static int parse_reply_info_in(void **p, void *end,
 			memset(&info->snap_btime, 0, sizeof(info->snap_btime));
 		}
 
+		/* snapshot count, remains zero for v<=3 */
+		if (struct_v >= 4) {
+			ceph_decode_64_safe(p, end, info->rsnaps, bad);
+		} else {
+			info->rsnaps = 0;
+		}
+
 		*p = end;
 	} else {
 		if (features & CEPH_FEATURE_MDS_INLINE_DATA) {
@@ -214,7 +221,7 @@ static int parse_reply_info_in(void **p, void *end,
 		}
 
 		info->dir_pin = -ENODATA;
-		/* info->snap_btime remains zero */
+		/* info->snap_btime and info->rsnaps remain zero */
 	}
 	return 0;
 bad:
diff --git a/fs/ceph/mds_client.h b/fs/ceph/mds_client.h
index bc9e95937d7c..76f2ed1a7cbf 100644
--- a/fs/ceph/mds_client.h
+++ b/fs/ceph/mds_client.h
@@ -88,6 +88,7 @@ struct ceph_mds_reply_info_in {
 	s32 dir_pin;
 	struct ceph_timespec btime;
 	struct ceph_timespec snap_btime;
+	u64 rsnaps;
 	u64 change_attr;
 };
 
diff --git a/fs/ceph/super.h b/fs/ceph/super.h
index 4c3c964b1c54..eb108b69da71 100644
--- a/fs/ceph/super.h
+++ b/fs/ceph/super.h
@@ -332,7 +332,7 @@ struct ceph_inode_info {
 
 	/* for dirs */
 	struct timespec64 i_rctime;
-	u64 i_rbytes, i_rfiles, i_rsubdirs;
+	u64 i_rbytes, i_rfiles, i_rsubdirs, i_rsnaps;
 	u64 i_files, i_subdirs;
 
 	/* quotas */
diff --git a/fs/ceph/xattr.c b/fs/ceph/xattr.c
index 3a733ac33d9b..c7d8ecc3d04b 100644
--- a/fs/ceph/xattr.c
+++ b/fs/ceph/xattr.c
@@ -231,6 +231,12 @@ static ssize_t ceph_vxattrcb_dir_rsubdirs(struct ceph_inode_info *ci, char *val,
 	return ceph_fmt_xattr(val, size, "%lld", ci->i_rsubdirs);
 }
 
+static ssize_t ceph_vxattrcb_dir_rsnaps(struct ceph_inode_info *ci, char *val,
+					  size_t size)
+{
+	return ceph_fmt_xattr(val, size, "%lld", ci->i_rsnaps);
+}
+
 static ssize_t ceph_vxattrcb_dir_rbytes(struct ceph_inode_info *ci, char *val,
 					size_t size)
 {
@@ -352,6 +358,7 @@ static struct ceph_vxattr ceph_dir_vxattrs[] = {
 	XATTR_RSTAT_FIELD(dir, rentries),
 	XATTR_RSTAT_FIELD(dir, rfiles),
 	XATTR_RSTAT_FIELD(dir, rsubdirs),
+	XATTR_RSTAT_FIELD(dir, rsnaps),
 	XATTR_RSTAT_FIELD(dir, rbytes),
 	XATTR_RSTAT_FIELD(dir, rctime),
 	{
-- 
2.24.3 (Apple Git-128)

