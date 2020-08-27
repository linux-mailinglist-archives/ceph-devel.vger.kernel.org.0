Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1ABD32540E1
	for <lists+ceph-devel@lfdr.de>; Thu, 27 Aug 2020 10:31:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727972AbgH0Ia7 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 27 Aug 2020 04:30:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726395AbgH0Ia5 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 27 Aug 2020 04:30:57 -0400
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78DE1C061264;
        Thu, 27 Aug 2020 01:30:57 -0700 (PDT)
Received: by mail-pj1-x1044.google.com with SMTP id kx11so2221377pjb.5;
        Thu, 27 Aug 2020 01:30:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=tm5UyWFyhKPtuv3cWQrYQMoHEt8xl5m5RQNN6i1Hdws=;
        b=RWRAKdEtzJXdCfFt/TgZnRjFh/MtUqq6ka6vfUrC6BLyjEeXCztTrFXj2iRm3qdBO8
         PbsZmq7O4Qg163Ln0PLdRPFGr/iamWqrdU0+A0DVJYDd1yfhq+DKEeFdkx2+VqOudkqI
         d9bnPOdot2M6hlM8+O3VWGN5SuqStxM/ahvymM2PAyUHKvoh7oaSTf/IzgBw4DvL2uhU
         F7RgBbCVn2rUxJt1zJu5e2c8ksZfOempfObxue6ftX4iC+/JAdYW/7NG1Z3YIJ3ytN84
         BVbKhtcu4nYaWmgf3HSaBFicUT2u/+ARKF5RNc9jILNN7dhG/4lOH4yHzMjNF0slUi0i
         oxQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=tm5UyWFyhKPtuv3cWQrYQMoHEt8xl5m5RQNN6i1Hdws=;
        b=jfU37++vI+nYEAVOlnNoFBI6ucPwhQedTPPFswtsOUx+VaJyeZHeWyf/aTvqNuGAv9
         ITHzE+ILQ+Cun5ZFEQBnzndGlshdje9mqktwMhh8l5+fMdAbfAB05FumzaOTXMcMk1XL
         Cm2WpEqTxAJBZKVBRGlOc2uBRr/KcTPXE6LPMiur6Q8MPdNNhwCEYT2h5eFLGPVVcvbM
         Rp20ERapBFrgQQMiBBN0tIWi8NWpgk0aSYxw8bcgZy+24y7dd4hTB9JgCTEZULIMX+pC
         /Ir5mp7kLvEDVLV9XUfKsZD7nRy6EnkTG6BuKodP0MR96Ddk2/tgfWvw6gKfh29FA77Y
         L0mg==
X-Gm-Message-State: AOAM530Z8bmSa6IEBDyBBpbkyIZ0JwnVBXKyzn3IQnsSGUZuxpLHmbc3
        kB9iKWRaipIlb0sBhZGFHNVVTsN7q5uMcA==
X-Google-Smtp-Source: ABdhPJyqinOe9Iy+KegRclSEt8DWA2/+13Ip+X015ifKPrrLe8XLUgJMHWHeJtvxNtUKgGL1RMhMKQ==
X-Received: by 2002:a17:90a:f48e:: with SMTP id bx14mr9233135pjb.233.1598517056869;
        Thu, 27 Aug 2020 01:30:56 -0700 (PDT)
Received: from localhost.localdomain ([122.224.153.227])
        by smtp.gmail.com with ESMTPSA id l13sm1529068pgq.33.2020.08.27.01.30.53
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 27 Aug 2020 01:30:56 -0700 (PDT)
From:   Yanhu Cao <gmayyyha@gmail.com>
To:     jlayton@kernel.org
Cc:     idryomov@gmail.com, ceph-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org, Yanhu Cao <gmayyyha@gmail.com>
Subject: [PATCH] ceph: support getting ceph.dir.rsnaps vxattr
Date:   Thu, 27 Aug 2020 16:30:47 +0800
Message-Id: <20200827083047.9478-1-gmayyyha@gmail.com>
X-Mailer: git-send-email 2.24.3 (Apple Git-128)
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

It's easy to know how many snapshots have been created.

Signed-off-by: Yanhu Cao <gmayyyha@gmail.com>
---
 fs/ceph/inode.c      | 1 +
 fs/ceph/mds_client.c | 4 +++-
 fs/ceph/mds_client.h | 1 +
 fs/ceph/super.h      | 2 +-
 fs/ceph/xattr.c      | 7 +++++++
 5 files changed, 13 insertions(+), 2 deletions(-)

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
index 4a26862d7667..35fdbefa676e 100644
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -172,8 +172,10 @@ static int parse_reply_info_in(void **p, void *end,
 			ceph_decode_need(p, end, sizeof(info->snap_btime), bad);
 			ceph_decode_copy(p, &info->snap_btime,
 					 sizeof(info->snap_btime));
+			ceph_decode_64_safe(p, end, info->rsnaps, bad);
 		} else {
 			memset(&info->snap_btime, 0, sizeof(info->snap_btime));
+			info->rsnaps = 0;
 		}
 
 		*p = end;
@@ -214,7 +216,7 @@ static int parse_reply_info_in(void **p, void *end,
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

