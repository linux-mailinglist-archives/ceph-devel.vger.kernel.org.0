Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C5F59459067
	for <lists+ceph-devel@lfdr.de>; Mon, 22 Nov 2021 15:41:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239772AbhKVOob (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 22 Nov 2021 09:44:31 -0500
Received: from aliyun-cloud.icoremail.net ([47.90.88.91]:44935 "HELO
        aliyun-sdnproxy-2.icoremail.net" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with SMTP id S239770AbhKVOoa (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Mon, 22 Nov 2021 09:44:30 -0500
X-Greylist: delayed 718 seconds by postgrey-1.27 at vger.kernel.org; Mon, 22 Nov 2021 09:44:30 EST
Received: from DESKTOP-L6QKPAF.scut-smil.cn (unknown [222.201.139.83])
        by main (Coremail) with SMTP id AQAAfwD31+B6p5thgWzhAQ--.49788S2;
        Mon, 22 Nov 2021 22:21:47 +0800 (CST)
From:   Hu Weiwen <sehuww@mail.scut.edu.cn>
To:     ceph-devel@vger.kernel.org
Cc:     Xiubo Li <xiubli@redhat.com>, Hu Weiwen <sehuww@mail.scut.edu.cn>
Subject: [PATCH] ceph: fix duplicate increment of opened_inodes metric
Date:   Mon, 22 Nov 2021 22:22:12 +0800
Message-Id: <20211122142212.1621-1-sehuww@mail.scut.edu.cn>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: AQAAfwD31+B6p5thgWzhAQ--.49788S2
X-Coremail-Antispam: 1UD129KBjvJXoW7ZFWrKFy3Xr4xCF1fWF4Durg_yoW8Ww4rpF
        4fGa4FgF4rJFZ7WF40yw15u3sakF1fCFZrCrZ3tryakFn5Wr1agry09345Xry7Cr4fZw1j
        gF1qqw47ZF4fGwUanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUkG14x267AKxVWUJVW8JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
        rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
        1l84ACjcxK6xIIjxv20xvE14v26r1j6r1xM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r1j
        6r4UM28EF7xvwVC2z280aVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gr
        1j6F4UJwAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv
        7VC0I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r
        1j6r4UM4x0Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwCY02Avz4vE14v_
        Xryl42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxV
        WUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r1Y6r17MIIYrxkI
        7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r
        1j6r4UMIIF0xvE42xK8VAvwI8IcIk0rVWrJr0_WFyUJwCI42IY6I8E87Iv67AKxVWUJVW8
        JwCI42IY6I8E87Iv6xkF7I0E14v26r1j6r4UYxBIdaVFxhVjvjDU0xZFpf9x0JU6WlgUUU
        UU=
X-CM-SenderInfo: qsqrljqqwxllyrt6zt1loo2ulxwovvfxof0/1tbiAQAIBlepTBr7SQAss5
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

opened_inodes is incremented twice when the same inode is opened twice
with O_RDONLY and O_WRONLY respectively.

To reproduce, run this python script, then check the metrics:

import os
for _ in range(10000):
    fd_r = os.open('a', os.O_RDONLY)
    fd_w = os.open('a', os.O_WRONLY)
    os.close(fd_r)
    os.close(fd_w)

Fixes: 1dd8d4708136 ("ceph: metrics for opened files, pinned caps and opened inodes")
Signed-off-by: Hu Weiwen <sehuww@mail.scut.edu.cn>
---
 fs/ceph/caps.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
index b9460b6fb76f..c447fa2e2d1f 100644
--- a/fs/ceph/caps.c
+++ b/fs/ceph/caps.c
@@ -4350,7 +4350,7 @@ void ceph_get_fmode(struct ceph_inode_info *ci, int fmode, int count)
 {
 	struct ceph_mds_client *mdsc = ceph_sb_to_mdsc(ci->vfs_inode.i_sb);
 	int bits = (fmode << 1) | 1;
-	bool is_opened = false;
+	bool already_opened = false;
 	int i;
 
 	if (count == 1)
@@ -4358,19 +4358,19 @@ void ceph_get_fmode(struct ceph_inode_info *ci, int fmode, int count)
 
 	spin_lock(&ci->i_ceph_lock);
 	for (i = 0; i < CEPH_FILE_MODE_BITS; i++) {
-		if (bits & (1 << i))
-			ci->i_nr_by_mode[i] += count;
-
 		/*
-		 * If any of the mode ref is larger than 1,
+		 * If any of the mode ref is larger than 0,
 		 * that means it has been already opened by
 		 * others. Just skip checking the PIN ref.
 		 */
-		if (i && ci->i_nr_by_mode[i] > 1)
-			is_opened = true;
+		if (i && ci->i_nr_by_mode[i])
+			already_opened = true;
+
+		if (bits & (1 << i))
+			ci->i_nr_by_mode[i] += count;
 	}
 
-	if (!is_opened)
+	if (!already_opened)
 		percpu_counter_inc(&mdsc->metric.opened_inodes);
 	spin_unlock(&ci->i_ceph_lock);
 }
-- 
2.25.1

