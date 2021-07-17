Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B4643CC261
	for <lists+ceph-devel@lfdr.de>; Sat, 17 Jul 2021 12:07:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232993AbhGQKJw (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Sat, 17 Jul 2021 06:09:52 -0400
Received: from zg8tmty1ljiyny4xntqumjca.icoremail.net ([165.227.154.27]:42175
        "HELO zg8tmty1ljiyny4xntqumjca.icoremail.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with SMTP id S229674AbhGQKJv (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Sat, 17 Jul 2021 06:09:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fudan.edu.cn; s=dkim; h=Received:From:To:Cc:Subject:Date:
        Message-Id; bh=ppnGd8K3Eo197MKg0B5ZiUSXW6KjSbRWhwFFXmq90b0=; b=T
        g+i1kpcBRFe4eKgPKpgbWpkjHZaDpYePlMR0u+tNXcRMku6GZ/pEwNA3PylxK1a6
        BU+n9GXk5x/bHyzdt0X4hu1ChcY22pH8WETunMoDik1l5FQhRuSNlxmOUGOitqhC
        FweAytGLumKVdXvjidewnFWJfC+cqptcAMMxxnKL7I=
Received: from localhost.localdomain (unknown [39.144.44.130])
        by app1 (Coremail) with SMTP id XAUFCgCnyZ2rq_JgCk98AA--.32408S3;
        Sat, 17 Jul 2021 18:06:36 +0800 (CST)
From:   Xiyu Yang <xiyuyang19@fudan.edu.cn>
To:     Jeff Layton <jlayton@kernel.org>,
        Ilya Dryomov <idryomov@gmail.com>, ceph-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     yuanxzhang@fudan.edu.cn, Xiyu Yang <xiyuyang19@fudan.edu.cn>,
        Xin Tan <tanxin.ctf@gmail.com>
Subject: [PATCH] ceph: Convert from atomic_t to refcount_t on ceph_snap_realm->nref
Date:   Sat, 17 Jul 2021 18:06:20 +0800
Message-Id: <1626516381-40440-1-git-send-email-xiyuyang19@fudan.edu.cn>
X-Mailer: git-send-email 2.7.4
X-CM-TRANSID: XAUFCgCnyZ2rq_JgCk98AA--.32408S3
X-Coremail-Antispam: 1UD129KBjvJXoWxAFWkXrWUGF1DGw4kKw47twb_yoW5CF1fpr
        WYkayktrWkJr1xu34kta1UuaySy3yxCa43JrW5CFsxZa43Ww1avr18KFy5KryrJryxJa98
        XF4vg3y2yF4YvFUanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUvl14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
        rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
        1l84ACjcxK6xIIjxv20xvE14v26w1j6s0DM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4U
        JVWxJr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gc
        CE3s1lnxkEFVAIw20F6cxK64vIFxWle2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xv
        F2IEw4CE5I8CrVC2j2WlYx0E2Ix0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r1j6r
        4UMcvjeVCFs4IE7xkEbVWUJVW8JwACjcxG0xvY0x0EwIxGrwACjI8F5VA0II8E6IAqYI8I
        648v4I1lc2xSY4AK67AK6r4DMxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r
        4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF
        67AKxVWUAVWUtwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2I
        x0cI8IcVCY1x0267AKxVWUJVW8JwCI42IY6xAIw20EY4v20xvaj40_WFyUJVCq3wCI42IY
        6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r1j6r4UYxBIdaVFxhVjvj
        DU0xZFpf9x0JUQvtAUUUUU=
X-CM-SenderInfo: irzsiiysuqikmy6i3vldqovvfxof0/
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

refcount_t type and corresponding API can protect refcounters from
accidental underflow and overflow and further use-after-free situations.

Signed-off-by: Xiyu Yang <xiyuyang19@fudan.edu.cn>
Signed-off-by: Xin Tan <tanxin.ctf@gmail.com>
---
 fs/ceph/snap.c  | 15 ++++++++-------
 fs/ceph/super.h |  3 ++-
 2 files changed, 10 insertions(+), 8 deletions(-)

diff --git a/fs/ceph/snap.c b/fs/ceph/snap.c
index 4ac0606dcbd4..d4ec9c5118bd 100644
--- a/fs/ceph/snap.c
+++ b/fs/ceph/snap.c
@@ -68,14 +68,15 @@ void ceph_get_snap_realm(struct ceph_mds_client *mdsc,
 	lockdep_assert_held(&mdsc->snap_rwsem);
 
 	dout("get_realm %p %d -> %d\n", realm,
-	     atomic_read(&realm->nref), atomic_read(&realm->nref)+1);
+	     refcount_read(&realm->nref), refcount_read(&realm->nref)+1);
 	/*
 	 * since we _only_ increment realm refs or empty the empty
 	 * list with snap_rwsem held, adjusting the empty list here is
 	 * safe.  we do need to protect against concurrent empty list
 	 * additions, however.
 	 */
-	if (atomic_inc_return(&realm->nref) == 1) {
+	refcount_inc(&realm->nref);
+	if (refcount_read(&realm->nref) == 1) {
 		spin_lock(&mdsc->snap_empty_lock);
 		list_del_init(&realm->empty_item);
 		spin_unlock(&mdsc->snap_empty_lock);
@@ -121,7 +122,7 @@ static struct ceph_snap_realm *ceph_create_snap_realm(
 	if (!realm)
 		return ERR_PTR(-ENOMEM);
 
-	atomic_set(&realm->nref, 1);    /* for caller */
+	refcount_set(&realm->nref, 1);    /* for caller */
 	realm->ino = ino;
 	INIT_LIST_HEAD(&realm->children);
 	INIT_LIST_HEAD(&realm->child_item);
@@ -209,8 +210,8 @@ static void __put_snap_realm(struct ceph_mds_client *mdsc,
 	lockdep_assert_held_write(&mdsc->snap_rwsem);
 
 	dout("__put_snap_realm %llx %p %d -> %d\n", realm->ino, realm,
-	     atomic_read(&realm->nref), atomic_read(&realm->nref)-1);
-	if (atomic_dec_and_test(&realm->nref))
+	     refcount_read(&realm->nref), refcount_read(&realm->nref)-1);
+	if (refcount_dec_and_test(&realm->nref))
 		__destroy_snap_realm(mdsc, realm);
 }
 
@@ -221,8 +222,8 @@ void ceph_put_snap_realm(struct ceph_mds_client *mdsc,
 			 struct ceph_snap_realm *realm)
 {
 	dout("put_snap_realm %llx %p %d -> %d\n", realm->ino, realm,
-	     atomic_read(&realm->nref), atomic_read(&realm->nref)-1);
-	if (!atomic_dec_and_test(&realm->nref))
+	     refcount_read(&realm->nref), refcount_read(&realm->nref)-1);
+	if (!refcount_dec_and_test(&realm->nref))
 		return;
 
 	if (down_write_trylock(&mdsc->snap_rwsem)) {
diff --git a/fs/ceph/super.h b/fs/ceph/super.h
index 6b6332a5c113..3abb00d7a0eb 100644
--- a/fs/ceph/super.h
+++ b/fs/ceph/super.h
@@ -2,6 +2,7 @@
 #ifndef _FS_CEPH_SUPER_H
 #define _FS_CEPH_SUPER_H
 
+#include <linux/refcount.h>
 #include <linux/ceph/ceph_debug.h>
 
 #include <asm/unaligned.h>
@@ -859,7 +860,7 @@ struct ceph_readdir_cache_control {
 struct ceph_snap_realm {
 	u64 ino;
 	struct inode *inode;
-	atomic_t nref;
+	refcount_t nref;
 	struct rb_node node;
 
 	u64 created, seq;
-- 
2.7.4

