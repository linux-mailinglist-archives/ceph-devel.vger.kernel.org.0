Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F4DB1BF011
	for <lists+ceph-devel@lfdr.de>; Thu, 30 Apr 2020 08:14:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726539AbgD3GN6 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 30 Apr 2020 02:13:58 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:47542 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726378AbgD3GN6 (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Thu, 30 Apr 2020 02:13:58 -0400
Received: from DGGEMS406-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id A3665E8AE37DF678951F;
        Thu, 30 Apr 2020 14:13:54 +0800 (CST)
Received: from huawei.com (10.175.105.27) by DGGEMS406-HUB.china.huawei.com
 (10.3.19.206) with Microsoft SMTP Server id 14.3.487.0; Thu, 30 Apr 2020
 14:13:47 +0800
From:   Wu Bo <wubo40@huawei.com>
To:     <jlayton@kernel.org>, <ukernel@gmail.com>, <sage@redhat.com>,
        <idryomov@gmail.com>
CC:     <ceph-devel@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <liuzhiqiang26@huawei.com>, <linfeilong@huawei.com>,
        <wubo40@huawei.com>
Subject: [PATCH V3] fs/ceph:fix double unlock in handle_cap_export()
Date:   Thu, 30 Apr 2020 14:12:49 +0800
Message-ID: <1588227169-83237-1-git-send-email-wubo40@huawei.com>
X-Mailer: git-send-email 1.8.3.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.105.27]
X-CFilter-Loop: Reflected
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

If the ceph_mdsc_open_export_target_session() return fails,
we should add mutex_lock(&session->s_mutex) on IS_ERR(tsession) block 
to avoid twice unlocking. because the session->s_mutex will be unlock
at the out_unlock lable.

--
v2 -> v3:
  - Rewrite solution, adding a mutex_lock(&session->s_mutex) 
    to the IS_ERR(tsession) block.
  - Modify the comment more clearly.
v1 -> v2:
  - add spin_lock(&ci->i_ceph_lock) before goto out_unlock lable
     

Signed-off-by: Wu Bo <wubo40@huawei.com>
---
 fs/ceph/caps.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
index 185db76..d27d778 100644
--- a/fs/ceph/caps.c
+++ b/fs/ceph/caps.c
@@ -3746,6 +3746,7 @@ static void handle_cap_export(struct inode *inode, struct ceph_mds_caps *ex,
 		WARN_ON(1);
 		tsession = NULL;
 		target = -1;
+		mutex_lock(&session->s_mutex);
 	}
 	goto retry;
 
-- 
1.8.3.1

