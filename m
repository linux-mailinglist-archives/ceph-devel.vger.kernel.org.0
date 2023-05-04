Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6EDA26F67E6
	for <lists+ceph-devel@lfdr.de>; Thu,  4 May 2023 11:00:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230240AbjEDJAq (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 4 May 2023 05:00:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229900AbjEDJAp (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 4 May 2023 05:00:45 -0400
X-Greylist: delayed 2116 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 04 May 2023 02:00:38 PDT
Received: from mail.scut.edu.cn (stumail2.scut.edu.cn [202.38.213.12])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 4CA993C3D
        for <ceph-devel@vger.kernel.org>; Thu,  4 May 2023 02:00:37 -0700 (PDT)
Received: from DESKTOP-L6QKPAF.scut-smil.cn (unknown [222.201.139.83])
        by main (Coremail) with SMTP id AQAAfwAndNnla1NkowQBCw--.31400S2;
        Thu, 04 May 2023 16:25:12 +0800 (CST)
From:   Hu Weiwen <sehuww@mail.scut.edu.cn>
To:     ceph-devel@vger.kernel.org
Cc:     Xiubo Li <xiubli@redhat.com>, Ilya Dryomov <idryomov@gmail.com>,
        Jeff Layton <jlayton@kernel.org>,
        Hu Weiwen <sehuww@mail.scut.edu.cn>
Subject: [PATCH] ceph: fix excessive page cache usage
Date:   Thu,  4 May 2023 16:25:10 +0800
Message-Id: <20230504082510.247-1-sehuww@mail.scut.edu.cn>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: AQAAfwAndNnla1NkowQBCw--.31400S2
X-Coremail-Antispam: 1UD129KBjvJXoWxXF47XrW8uFW8ZrW3ZF47Jwb_yoWrJr4fp3
        y3AFWUJF4rZr48uw47Jr4Yk348Gwn7Xay3Gr1qyr45u3s0gwn2v3s0qFy5urnrXr1DGr47
        Ww1kKrW7t3WUZrUanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUkS14x267AKxVWUJVW8JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
        rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
        1l84ACjcxK6xIIjxv20xvE14v26r1I6r4UM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4j
        6F4UM28EF7xvwVC2z280aVAFwI0_Cr1j6rxdM28EF7xvwVC2z280aVCY1x0267AKxVWxJr
        0_GcWle2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E
        2Ix0cI8IcVAFwI0_Jrv_JF1lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJV
        W8JwACjcxG0xvY0x0EwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1lc2xSY4AK67AK6r43
        MxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr
        0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUAVWUtwCIc40Y0x0E
        wIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxVWUJV
        W8JwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAI
        cVC2z280aVCY1x0267AKxVWUJVW8JbIYCTnIWIevJa73UjIFyTuYvjfUnjjgUUUUU
X-CM-SenderInfo: qsqrljqqwxllyrt6zt1loo2ulxwovvfxof0/1tbiAQAIBmRBTIUEfwARsJ
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Currently, `ceph_netfs_expand_readahead()` tries to align the read
request with strip_unit, which by default is set to 4MB.  This means
that small files will require at least 4MB of page cache, leading to
inefficient usage of the page cache.

Bound `rreq->len` to the actual file size to restore the previous page
cache usage.

Fixes: 49870056005c ("ceph: convert ceph_readpages to ceph_readahead")
Signed-off-by: Hu Weiwen <sehuww@mail.scut.edu.cn>
---

We recently updated our kernel. And we are investigating the performance
regression on our machine learning jobs.  For example, one of our jobs
repeatedly read a dataset of 62GB, 100k files.  I expect all these IO
request would hit the page cache, since we have more that 100GB memory
for cache.  However, a lot of network IO is observed, and our HDD ceph
cluster is fully loaded, resulting in very bad performance.

The regression is bisected to commit
49870056005c ("ceph: convert ceph_readpages to ceph_readahead").
This commit is merged in kernel 5.13.  After this commit, we need 400GB
of memory to fully cache these 100k files, which is unacceptable.

The post-EOF page cache is populated at:
(gathered by `perf record -a -e filemap:mm_filemap_add_to_page_cache -g sleep 2`)

python 3619706 [005] 3103609.736344: filemap:mm_filemap_add_to_page_cache: dev 0:62 ino 1002245af9b page=0x7daf4c pfn=0x7daf4c ofs=1048576
        ffffffff9aca933a __add_to_page_cache_locked+0x2aa ([kernel.kallsyms])
        ffffffff9aca933a __add_to_page_cache_locked+0x2aa ([kernel.kallsyms])
        ffffffff9aca945d add_to_page_cache_lru+0x4d ([kernel.kallsyms])
        ffffffff9acb66d8 readahead_expand+0x128 ([kernel.kallsyms])
        ffffffffc0e68fbc netfs_rreq_expand+0x8c ([kernel.kallsyms])
        ffffffffc0e6a6c2 netfs_readahead+0xf2 ([kernel.kallsyms])
        ffffffffc104817c ceph_readahead+0xbc ([kernel.kallsyms])
        ffffffff9acb63c5 read_pages+0x95 ([kernel.kallsyms])
        ffffffff9acb6921 page_cache_ra_unbounded+0x161 ([kernel.kallsyms])
        ffffffff9acb6a1d do_page_cache_ra+0x3d ([kernel.kallsyms])
        ffffffff9acb6b67 ondemand_readahead+0x137 ([kernel.kallsyms])
        ffffffff9acb700f page_cache_sync_ra+0xcf ([kernel.kallsyms])
        ffffffff9acab80c filemap_get_pages+0xdc ([kernel.kallsyms])
        ffffffff9acabe4e filemap_read+0xbe ([kernel.kallsyms])
        ffffffff9acac285 generic_file_read_iter+0xe5 ([kernel.kallsyms])
        ffffffffc1041b82 ceph_read_iter+0x182 ([kernel.kallsyms])
        ffffffff9ad82bf0 new_sync_read+0x110 ([kernel.kallsyms])
        ffffffff9ad83432 vfs_read+0x102 ([kernel.kallsyms])
        ffffffff9ad858d7 ksys_read+0x67 ([kernel.kallsyms])
        ffffffff9ad8597a __x64_sys_read+0x1a ([kernel.kallsyms])
        ffffffff9b76563c do_syscall_64+0x5c ([kernel.kallsyms])
        ffffffff9b800099 entry_SYSCALL_64_after_hwframe+0x61 ([kernel.kallsyms])
            7fad6ca683cc __libc_read+0x4c (/lib/x86_64-linux-gnu/libpthread-2.31.so)

The readahead is expanded too much. 


 fs/ceph/addr.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
index 6bb251a4d613..d508901d3739 100644
--- a/fs/ceph/addr.c
+++ b/fs/ceph/addr.c
@@ -197,6 +197,8 @@ static void ceph_netfs_expand_readahead(struct netfs_io_request *rreq)
 
 	/* Now, round up the length to the next block */
 	rreq->len = roundup(rreq->len, lo->stripe_unit);
+	/* But do not exceed the file size */
+	rreq->len = min(rreq->len, (size_t)(rreq->i_size - rreq->start));
 }
 
 static bool ceph_netfs_clamp_length(struct netfs_io_subrequest *subreq)
-- 
2.25.1

