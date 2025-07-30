Return-Path: <ceph-devel+bounces-3331-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 5CB45B15D26
	for <lists+ceph-devel@lfdr.de>; Wed, 30 Jul 2025 11:51:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7AF191889BAA
	for <lists+ceph-devel@lfdr.de>; Wed, 30 Jul 2025 09:50:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5B47A26FA50;
	Wed, 30 Jul 2025 09:49:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=kuaishou.com header.i=@kuaishou.com header.b="jv/UEKRp"
X-Original-To: ceph-devel@vger.kernel.org
Received: from bjy-spam.kuaishou.com (bjy-spam.kuaishou.com [162.219.34.252])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 903EA20E6
	for <ceph-devel@vger.kernel.org>; Wed, 30 Jul 2025 09:49:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=162.219.34.252
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753868980; cv=none; b=L8ysMoRzXQBsNKfiWqaPvzGSjJO3oSU/fOuRXQzZnRLLxUZs+SfxiCip9Dp23ldQVYRjidDVRyd6Oz8tuWUnhySae6sUBE7qmJ0BsECYGjF0OOgOURMK/mzvIk6NHMbzwgxcMKQpIlSVkwq70ZbAWiuv6SCOk9WH8Lil+SwYW2k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753868980; c=relaxed/simple;
	bh=D6YoFPQVoT4c7jK479/V9E/Y0tYZYbp+UuEErbUMVTs=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=FgJqRz4VY/Va90u0Djy+0RnjOgehV/1QMcF5KytnpJmBjC+nFeaNKuXRTcSOKvDA52wT27rjfQnRGscY/+Kk8kMillpcUxzgTLwlCcTTWC+KHnyYxndsI/Dy+v82/FjUpHcbtWDwJiOfS0aAryfHqnmjPA9S73/WTzvHWnNh/pI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=kuaishou.com; spf=pass smtp.mailfrom=kuaishou.com; dkim=pass (1024-bit key) header.d=kuaishou.com header.i=@kuaishou.com header.b=jv/UEKRp; arc=none smtp.client-ip=162.219.34.252
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=kuaishou.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kuaishou.com
Received: from m7-spam02.kuaishou.com (unknown [172.28.1.162])
	by bjy-spam.kuaishou.com (Postfix) with ESMTP id 045482C000048;
	Wed, 30 Jul 2025 17:41:32 +0800 (CST)
Received: from bjm7-pm-mail03.kuaishou.com (unknown [172.28.1.3])
	by m7-spam02.kuaishou.com (Postfix) with ESMTPS id F3E01180097F6;
	Wed, 30 Jul 2025 17:41:30 +0800 (CST)
DKIM-Signature: v=1; a=rsa-sha256; d=kuaishou.com; s=dkim; c=relaxed/relaxed;
	t=1753868490; h=from:subject:to:date:message-id;
	bh=9xtIdO0P8xjUjacpuxbIuqGw0aXQZPBlGa2j166DxEk=;
	b=jv/UEKRpeMzHm5uz/veaeZFlD+17f4neBAxt1mN+jal6EL7XysnuVlB/slnAyyQnKuyOMV2gupd
	BNf/wfD7ANcOt77cyGMK3/0T/kK3jk7FZZOD8ILxjGha8+jcj9omELbF8oQaogEJ5L/myxXMIxFRb
	tMCzjT3rBe4iQQQ4AAU=
Received: from localhost.localdomain (172.28.1.32) by
 bjm7-pm-mail03.kuaishou.com (172.28.1.3) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.20; Wed, 30 Jul 2025 17:41:30 +0800
From: Zhao Sun <sunzhao03@kuaishou.com>
To: <xiubli@redhat.com>, <idryomov@gmail.com>
CC: <ceph-devel@vger.kernel.org>, <linux-kernel@vger.kernel.org>, Zhao Sun
	<sunzhao03@kuaishou.com>
Subject: [PATCH] ceph: fix deadlock in ceph_readdir_prepopulate
Date: Wed, 30 Jul 2025 17:41:23 +0800
Message-ID: <20250730094123.30540-1-sunzhao03@kuaishou.com>
X-Mailer: git-send-email 2.39.2 (Apple Git-143)
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: bjxm-pm-mail01.kuaishou.com (172.28.128.1) To
 bjm7-pm-mail03.kuaishou.com (172.28.1.3)

When ceph_readdir_prepopulate calls ceph_get_inode while holding
mdsc->snap_rwsem, a deadlock may occur, blocking all subsequent
requests of the current session.

Fix by release the mds->snap_rwsem read lock before calling the
ceph_get_inode function.

Link: https://tracker.ceph.com/issues/72307
Signed-off-by: Zhao Sun <sunzhao03@kuaishou.com>
---
 fs/ceph/inode.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
index 06cd2963e41e..3d7fb045ba76 100644
--- a/fs/ceph/inode.c
+++ b/fs/ceph/inode.c
@@ -1900,6 +1900,7 @@ static int fill_readdir_cache(struct inode *dir, struct dentry *dn,
 int ceph_readdir_prepopulate(struct ceph_mds_request *req,
 			     struct ceph_mds_session *session)
 {
+	struct ceph_mds_client *mdsc = session->s_mdsc;
 	struct dentry *parent = req->r_dentry;
 	struct inode *inode = d_inode(parent);
 	struct ceph_inode_info *ci = ceph_inode(inode);
@@ -2029,7 +2030,10 @@ int ceph_readdir_prepopulate(struct ceph_mds_request *req,
 		if (d_really_is_positive(dn)) {
 			in = d_inode(dn);
 		} else {
+			/* Release mdsc->snap_rwsem in advance to avoid deadlock */
+			up_read(&mdsc->snap_rwsem);
 			in = ceph_get_inode(parent->d_sb, tvino, NULL);
+			down_read(&mdsc->snap_rwsem);
 			if (IS_ERR(in)) {
 				doutc(cl, "new_inode badness\n");
 				d_drop(dn);
-- 
2.39.2 (Apple Git-143)


