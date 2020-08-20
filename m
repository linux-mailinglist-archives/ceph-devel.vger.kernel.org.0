Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3EAF24ABC5
	for <lists+ceph-devel@lfdr.de>; Thu, 20 Aug 2020 02:13:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728510AbgHTAM5 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 19 Aug 2020 20:12:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:57606 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726934AbgHTABj (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Wed, 19 Aug 2020 20:01:39 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A6F932177B;
        Thu, 20 Aug 2020 00:01:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597881699;
        bh=eDdQzoVVYuY07Go3rMTk3g2JQXmPWliFOUbYPLgVjIE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1Abwj8oFSZR4JGBPLeYGQEK7yDdaEWgYk0f1Y1CLHBGkqonQg8YLOB4lKEfM543fV
         vjhaqE7S5GcBSFbtiwXaffoFj4u8+142/k3m/q8R7gPbhjNeSkZwn8yG/vSjtJhzAQ
         tb0ROeyaFOMfWaKNTM/E8PrJA3zttiyDtZ1nJgDU=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Xiubo Li <xiubli@redhat.com>,
        syzbot+b57f46d8d6ea51960b8c@syzkaller.appspotmail.com,
        Jeff Layton <jlayton@kernel.org>,
        Ilya Dryomov <idryomov@gmail.com>,
        Sasha Levin <sashal@kernel.org>, ceph-devel@vger.kernel.org
Subject: [PATCH AUTOSEL 5.8 17/27] ceph: fix use-after-free for fsc->mdsc
Date:   Wed, 19 Aug 2020 20:01:06 -0400
Message-Id: <20200820000116.214821-17-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200820000116.214821-1-sashal@kernel.org>
References: <20200820000116.214821-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: Xiubo Li <xiubli@redhat.com>

[ Upstream commit a7caa88f8b72c136f9a401f498471b8a8e35370d ]

If the ceph_mdsc_init() fails, it will free the mdsc already.

Reported-by: syzbot+b57f46d8d6ea51960b8c@syzkaller.appspotmail.com
Signed-off-by: Xiubo Li <xiubli@redhat.com>
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ceph/mds_client.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
index a50497142e598..cea7bf78c151c 100644
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -4359,7 +4359,6 @@ int ceph_mdsc_init(struct ceph_fs_client *fsc)
 		goto err_mdsc;
 	}
 
-	fsc->mdsc = mdsc;
 	init_completion(&mdsc->safe_umount_waiters);
 	init_waitqueue_head(&mdsc->session_close_wq);
 	INIT_LIST_HEAD(&mdsc->waiting_for_map);
@@ -4414,6 +4413,8 @@ int ceph_mdsc_init(struct ceph_fs_client *fsc)
 
 	strscpy(mdsc->nodename, utsname()->nodename,
 		sizeof(mdsc->nodename));
+
+	fsc->mdsc = mdsc;
 	return 0;
 
 err_mdsmap:
-- 
2.25.1

