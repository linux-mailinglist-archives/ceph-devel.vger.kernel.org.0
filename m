Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4014A218091
	for <lists+ceph-devel@lfdr.de>; Wed,  8 Jul 2020 09:14:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729807AbgGHHOw (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 8 Jul 2020 03:14:52 -0400
Received: from smtp21.cstnet.cn ([159.226.251.21]:47248 "EHLO cstnet.cn"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726320AbgGHHOw (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Wed, 8 Jul 2020 03:14:52 -0400
X-Greylist: delayed 664 seconds by postgrey-1.27 at vger.kernel.org; Wed, 08 Jul 2020 03:14:40 EDT
Received: from localhost (unknown [159.226.5.99])
        by APP-01 (Coremail) with SMTP id qwCowAAnCeq_bwVf4majBA--.12311S2;
        Wed, 08 Jul 2020 15:03:28 +0800 (CST)
From:   Xu Wang <vulab@iscas.ac.cn>
To:     jlayton@kernel.org, idryomov@gmail.com, ceph-devel@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, Xu Wang <vulab@iscas.ac.cn>
Subject: [PATCH] fs: ceph: Remove unnecessary cast in kfree()
Date:   Wed,  8 Jul 2020 07:03:22 +0000
Message-Id: <20200708070322.30695-1-vulab@iscas.ac.cn>
X-Mailer: git-send-email 2.17.1
X-CM-TRANSID: qwCowAAnCeq_bwVf4majBA--.12311S2
X-Coremail-Antispam: 1UD129KBjvJXoW7Aw48urykXFyrCFWfAw1fWFg_yoW8GrWxpF
        12kw48JwsxJF48Wr98J3WrZ34akayktFyDur9Fkws7uF15WryxJry8ZFyUury3Zry8Arn8
        Ja1Dtw1rJF1av3DanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUkG14x267AKxVWUJVW8JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
        rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
        1l84ACjcxK6xIIjxv20xvE14v26r4j6ryUM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4j
        6F4UM28EF7xvwVC2z280aVAFwI0_Cr1j6rxdM28EF7xvwVC2z280aVCY1x0267AKxVW0oV
        Cq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0
        I7IYx2IY67AKxVWUtVWrXwAv7VC2z280aVAFwI0_Gr1j6F4UJwAm72CE4IkC6x0Yz7v_Jr
        0_Gr1lF7xvr2IYc2Ij64vIr41lF7I21c0EjII2zVCS5cI20VAGYxC7MxkIecxEwVAFwVW8
        CwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14v26r
        1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_JF0_Jw1lIxkGc2Ij
        64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Jr
        0_Gr1lIxAIcVCF04k26cxKx2IYs7xG6rWUJVWrZr1UMIIF0xvEx4A2jsIE14v26r1j6r4U
        MIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x0JUD8n5UUU
        UU=
X-Originating-IP: [159.226.5.99]
X-CM-SenderInfo: pyxotu46lvutnvoduhdfq/1tbiCAELA102YQ+JuwAAs2
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Remove unnecassary casts in the argument to kfree.

Signed-off-by: Xu Wang <vulab@iscas.ac.cn>
---
 fs/ceph/xattr.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/fs/ceph/xattr.c b/fs/ceph/xattr.c
index 71ee34d160c3..3a733ac33d9b 100644
--- a/fs/ceph/xattr.c
+++ b/fs/ceph/xattr.c
@@ -497,10 +497,10 @@ static int __set_xattr(struct ceph_inode_info *ci,
 		kfree(*newxattr);
 		*newxattr = NULL;
 		if (xattr->should_free_val)
-			kfree((void *)xattr->val);
+			kfree(xattr->val);
 
 		if (update_xattr) {
-			kfree((void *)name);
+			kfree(name);
 			name = xattr->name;
 		}
 		ci->i_xattrs.names_size -= xattr->name_len;
@@ -566,9 +566,9 @@ static void __free_xattr(struct ceph_inode_xattr *xattr)
 	BUG_ON(!xattr);
 
 	if (xattr->should_free_name)
-		kfree((void *)xattr->name);
+		kfree(xattr->name);
 	if (xattr->should_free_val)
-		kfree((void *)xattr->val);
+		kfree(xattr->val);
 
 	kfree(xattr);
 }
@@ -582,9 +582,9 @@ static int __remove_xattr(struct ceph_inode_info *ci,
 	rb_erase(&xattr->node, &ci->i_xattrs.index);
 
 	if (xattr->should_free_name)
-		kfree((void *)xattr->name);
+		kfree(xattr->name);
 	if (xattr->should_free_val)
-		kfree((void *)xattr->val);
+		kfree(xattr->val);
 
 	ci->i_xattrs.names_size -= xattr->name_len;
 	ci->i_xattrs.vals_size -= xattr->val_len;
-- 
2.17.1

