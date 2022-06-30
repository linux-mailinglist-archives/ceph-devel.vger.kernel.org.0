Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 82716560EF3
	for <lists+ceph-devel@lfdr.de>; Thu, 30 Jun 2022 04:06:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229828AbiF3CGQ (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 29 Jun 2022 22:06:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229616AbiF3CGP (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 29 Jun 2022 22:06:15 -0400
X-Greylist: delayed 335 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 29 Jun 2022 19:06:12 PDT
Received: from mail.scut.edu.cn (stumail2.scut.edu.cn [202.38.213.12])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id DA122393E0
        for <ceph-devel@vger.kernel.org>; Wed, 29 Jun 2022 19:06:12 -0700 (PDT)
Received: from IT00043538.localdomain (unknown [120.196.70.37])
        by main (Coremail) with SMTP id AQAAfwDHRqR0A71iwMd0AA--.26247S2;
        Thu, 30 Jun 2022 09:59:37 +0800 (CST)
From:   Hu Weiwen <sehuww@mail.scut.edu.cn>
To:     Xiubo Li <xiubli@redhat.com>, ceph-devel@vger.kernel.org
Cc:     Hu Weiwen <sehuww@mail.scut.edu.cn>
Subject: [PATCH] ceph: don't truncate file in atomic_open
Date:   Thu, 30 Jun 2022 10:00:10 +0800
Message-Id: <20220630020010.17148-1-sehuww@mail.scut.edu.cn>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: AQAAfwDHRqR0A71iwMd0AA--.26247S2
X-Coremail-Antispam: 1UD129KBjvJXoW7tr48tF18GFWDuw1rXw43Jrb_yoW8Gr43pF
        s3XF40qr4rGws0g392vFWUZ34FkF1SyrWxZrW0gry3Krn3Wr1ftF1ft34YyF4avr4rZw4r
        XF17KF98Wa4UtFJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUkS14x267AKxVWUJVW8JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
        rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
        1l84ACjcxK6xIIjxv20xvE14v26r1I6r4UM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4j
        6F4UM28EF7xvwVC2z280aVAFwI0_Cr0_Gr1UM28EF7xvwVC2z280aVCY1x0267AKxVW8Jr
        0_Cr1UM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj
        6xIIjxv20xvE14v26r1Y6r17McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x0Yz7v_Jr
        0_Gr1lF7xvr2IYc2Ij64vIr41lF7I21c0EjII2zVCS5cI20VAGYxC7MxkIecxEwVAFwVWk
        MxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr
        0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUXVWUAwCIc40Y0x0E
        wIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxVWUJV
        W8JwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAI
        cVC2z280aVCY1x0267AKxVWUJVW8JbIYCTnIWIevJa73UjIFyTuYvjfUY2NtUUUUU
X-CM-SenderInfo: qsqrljqqwxllyrt6zt1loo2ulxwovvfxof0/1tbiAQAKBmK4dywAVQAgs5
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Clear O_TRUNC from the flags sent in the MDS create request.

`atomic_open' is called before permission check. We should not do any
modification to the file here. The caller will do the truncation
afterward.

Fixes: 124e68e74099 ("ceph: file operations")
Signed-off-by: Hu Weiwen <sehuww@mail.scut.edu.cn>
---
 fs/ceph/file.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/fs/ceph/file.c b/fs/ceph/file.c
index da59e836a06e..a5ecb97b6f41 100644
--- a/fs/ceph/file.c
+++ b/fs/ceph/file.c
@@ -757,6 +757,11 @@ int ceph_atomic_open(struct inode *dir, struct dentry *dentry,
 		/* If it's not being looked up, it's negative */
 		return -ENOENT;
 	}
+	/*
+	 * Do not truncate the file, since atomic_open is called before the
+	 * permission check. The caller will do the truncation afterward.
+	 */
+	flags &= ~O_TRUNC;
 retry:
 	/* do the open */
 	req = prepare_open_request(dir->i_sb, flags, mode);
@@ -807,9 +812,7 @@ int ceph_atomic_open(struct inode *dir, struct dentry *dentry,
 	}

 	set_bit(CEPH_MDS_R_PARENT_LOCKED, &req->r_req_flags);
-	err = ceph_mdsc_do_request(mdsc,
-				   (flags & (O_CREAT|O_TRUNC)) ? dir : NULL,
-				   req);
+	err = ceph_mdsc_do_request(mdsc, (flags & O_CREAT) ? dir : NULL, req);
 	if (err == -ENOENT) {
 		dentry = ceph_handle_snapdir(req, dentry);
 		if (IS_ERR(dentry)) {
--
2.25.1

