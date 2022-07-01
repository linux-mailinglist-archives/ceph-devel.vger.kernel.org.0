Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 94067562949
	for <lists+ceph-devel@lfdr.de>; Fri,  1 Jul 2022 04:53:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233736AbiGACxT (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 30 Jun 2022 22:53:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233716AbiGACxR (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 30 Jun 2022 22:53:17 -0400
Received: from mail.scut.edu.cn (stumail2.scut.edu.cn [202.38.213.12])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 38CEF18399
        for <ceph-devel@vger.kernel.org>; Thu, 30 Jun 2022 19:53:13 -0700 (PDT)
Received: from IT00043538.localdomain (unknown [120.196.70.37])
        by main (Coremail) with SMTP id AQAAfwCH6H1WYb5iao+OAA--.64930S2;
        Fri, 01 Jul 2022 10:52:06 +0800 (CST)
From:   Hu Weiwen <sehuww@mail.scut.edu.cn>
To:     Xiubo Li <xiubli@redhat.com>, ceph-devel@vger.kernel.org
Cc:     Hu Weiwen <sehuww@mail.scut.edu.cn>
Subject: [RESEND PATCH] ceph: don't truncate file in atomic_open
Date:   Fri,  1 Jul 2022 10:52:27 +0800
Message-Id: <20220701025227.21636-1-sehuww@mail.scut.edu.cn>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <59d7c10f-7419-971b-c13c-71865f897953@redhat.com>
References: <59d7c10f-7419-971b-c13c-71865f897953@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: AQAAfwCH6H1WYb5iao+OAA--.64930S2
X-Coremail-Antispam: 1UD129KBjvJXoW7tr48tF18GFW8ArW5Xr1fWFg_yoW8GF4DpF
        4fXF1jqF4rG39Ig397Za18u34FkFn7CrW7ZrWIgr13KrnxWr15trn2q34YyF13Ar4rZw10
        q3W7tFZ8uryUtFJanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUkv14x267AKxVWUJVW8JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
        rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
        1l84ACjcxK6xIIjxv20xvE14v26r1I6r4UM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r1j
        6r4UM28EF7xvwVC2z280aVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gr
        1j6F4UJwAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv
        7VC0I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r
        1j6r4UM4x0Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwCY02Avz4vE14v_
        Gr1l42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxV
        WUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r1Y6r17MIIYrxkI
        7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r
        1j6r4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWUJVW8JwCI
        42IY6I8E87Iv6xkF7I0E14v26r1j6r4UYxBIdaVFxhVjvjDU0xZFpf9x0JUgVyxUUUUU=
X-CM-SenderInfo: qsqrljqqwxllyrt6zt1loo2ulxwovvfxof0/1tbiAQAOBmK9vS0A3QACsZ
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
rebased onto ceph_client repo testing branch

 fs/ceph/file.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/fs/ceph/file.c b/fs/ceph/file.c
index 296fd1c7ece8..289e66e9cbb0 100644
--- a/fs/ceph/file.c
+++ b/fs/ceph/file.c
@@ -745,6 +745,11 @@ int ceph_atomic_open(struct inode *dir, struct dentry *dentry,
 	err = ceph_wait_on_conflict_unlink(dentry);
 	if (err)
 		return err;
+	/*
+	 * Do not truncate the file, since atomic_open is called before the
+	 * permission check. The caller will do the truncation afterward.
+	 */
+	flags &= ~O_TRUNC;
 
 retry:
 	if (flags & O_CREAT) {
@@ -836,9 +841,7 @@ int ceph_atomic_open(struct inode *dir, struct dentry *dentry,
 	set_bit(CEPH_MDS_R_PARENT_LOCKED, &req->r_req_flags);
 	req->r_new_inode = new_inode;
 	new_inode = NULL;
-	err = ceph_mdsc_do_request(mdsc,
-				   (flags & (O_CREAT|O_TRUNC)) ? dir : NULL,
-				   req);
+	err = ceph_mdsc_do_request(mdsc, (flags & O_CREAT) ? dir : NULL, req);
 	if (err == -ENOENT) {
 		dentry = ceph_handle_snapdir(req, dentry);
 		if (IS_ERR(dentry)) {
-- 
2.25.1

