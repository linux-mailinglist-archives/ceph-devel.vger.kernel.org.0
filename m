Return-Path: <ceph-devel+bounces-1791-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 985DF96E9E6
	for <lists+ceph-devel@lfdr.de>; Fri,  6 Sep 2024 08:16:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C4D231C2365C
	for <lists+ceph-devel@lfdr.de>; Fri,  6 Sep 2024 06:16:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8362413D2BE;
	Fri,  6 Sep 2024 06:15:17 +0000 (UTC)
X-Original-To: ceph-devel@vger.kernel.org
Received: from szxga07-in.huawei.com (szxga07-in.huawei.com [45.249.212.35])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96BFA13E3EF
	for <ceph-devel@vger.kernel.org>; Fri,  6 Sep 2024 06:15:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.35
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725603317; cv=none; b=lGceYvJardauGc4nsGFnuZawgUbc+NPsJeg8uXiBSIXVEN1OaDVxhlHPSzlwFK1AOFbm2e3ai4y7xtXwdf+fnxUqHbqfSnNp7H5354BZrBBgIFx4Ts0BZxJc6ta/oa7G5EdMc9sJYrA3IIyVComW7afNeEhd3x7tT+k9PyDxnkg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725603317; c=relaxed/simple;
	bh=R1bErVVlsa4zohE+Vzc5OBmwaqGxSq0aIdPCtjDTfkM=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=QRoS8b/tVPBouDbP9RM9wesamE2qwtAGOdWq5IdOXLHYUEo3MY6q7zND/bl4LkUMY5gR6/KSrdA69ZpexWvANWYnoerHHumivWmschJzHx6r0r82yUk+0GhB0rY2AZQdvJmNhnIPm2JeZyugJQBwjzLn1UjqaaL7mDVXAqEWBHE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.35
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.162.112])
	by szxga07-in.huawei.com (SkyGuard) with ESMTP id 4X0Qtc4yDyz1S9tf;
	Fri,  6 Sep 2024 14:14:48 +0800 (CST)
Received: from kwepemf500003.china.huawei.com (unknown [7.202.181.241])
	by mail.maildlp.com (Postfix) with ESMTPS id E8D071400DB;
	Fri,  6 Sep 2024 14:15:11 +0800 (CST)
Received: from huawei.com (10.175.112.208) by kwepemf500003.china.huawei.com
 (7.202.181.241) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Fri, 6 Sep
 2024 14:15:11 +0800
From: Zhang Zekun <zhangzekun11@huawei.com>
To: <xiubli@redhat.com>, <idryomov@gmail.com>, <ceph-devel@vger.kernel.org>
CC: <chenjun102@huawei.com>, <zhangzekun11@huawei.com>
Subject: [PATCH] ceph: Remove empty definition in header file
Date: Fri, 6 Sep 2024 14:01:34 +0800
Message-ID: <20240906060134.129970-1-zhangzekun11@huawei.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 kwepemf500003.china.huawei.com (7.202.181.241)

The real definition of ceph_acl_chmod() has been removed since
commit 4db658ea0ca2 ("ceph: Fix up after semantic merge conflict"),
remain the empty definition untouched in the header files. Let's
remove the empty definition.

Signed-off-by: Zhang Zekun <zhangzekun11@huawei.com>
---
 fs/ceph/super.h | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/fs/ceph/super.h b/fs/ceph/super.h
index c88bf53f68e9..384eac22db57 100644
--- a/fs/ceph/super.h
+++ b/fs/ceph/super.h
@@ -1206,10 +1206,6 @@ static inline void ceph_init_inode_acls(struct inode *inode,
 					struct ceph_acl_sec_ctx *as_ctx)
 {
 }
-static inline int ceph_acl_chmod(struct dentry *dentry, struct inode *inode)
-{
-	return 0;
-}
 
 static inline void ceph_forget_all_cached_acls(struct inode *inode)
 {
-- 
2.17.1


