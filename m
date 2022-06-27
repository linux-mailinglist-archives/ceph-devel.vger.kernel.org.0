Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 10CEA55B50E
	for <lists+ceph-devel@lfdr.de>; Mon, 27 Jun 2022 04:03:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229986AbiF0CCs (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Sun, 26 Jun 2022 22:02:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229463AbiF0CCr (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Sun, 26 Jun 2022 22:02:47 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id CEA68EB5
        for <ceph-devel@vger.kernel.org>; Sun, 26 Jun 2022 19:02:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1656295366;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=EiUJ5AEahxnNko+dlTk6slRSm2JaM/rCGiyO8pAvOC0=;
        b=gnbsh2HfbiqsLGYqW+xlvE+RDJSgSGcaNXuNPou0pTwLk3zqsh0tpDaVbx2gbJ7NptF0yT
        S4e8zrY1RzW8Mw56yWhsY01UVu9BSU0k9yMsdBlLVo4wQNOorJtkSElMzatcaibuO12AyM
        fNLPMnVJ/0dyATFY3NxxxvKWFX0WAAM=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-673-C2ZPiM-7NguxzH1ouTcd9A-1; Sun, 26 Jun 2022 22:02:44 -0400
X-MC-Unique: C2ZPiM-7NguxzH1ouTcd9A-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 107FE101AA45;
        Mon, 27 Jun 2022 02:02:44 +0000 (UTC)
Received: from lxbceph1.gsslab.pek2.redhat.com (unknown [10.72.47.117])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3A685C2810D;
        Mon, 27 Jun 2022 02:02:40 +0000 (UTC)
From:   xiubli@redhat.com
To:     jlayton@kernel.org, idryomov@gmail.com
Cc:     vshankar@redhat.com, pdonnell@redhat.com, lhenriques@suse.de,
        ceph-devel@vger.kernel.org, Xiubo Li <xiubli@redhat.com>
Subject: [PATCH v2 2/3] ceph: switch to use CEPH_4K_BLOCK_SHIFT macro
Date:   Mon, 27 Jun 2022 10:02:02 +0800
Message-Id: <20220627020203.173293-3-xiubli@redhat.com>
In-Reply-To: <20220627020203.173293-1-xiubli@redhat.com>
References: <20220627020203.173293-1-xiubli@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: Xiubo Li <xiubli@redhat.com>

At the same time rename CEPH_BLOCK to CEPH_BLOCK_SIZE.

Signed-off-by: Xiubo Li <xiubli@redhat.com>
---
 fs/ceph/super.c | 8 ++++----
 fs/ceph/super.h | 5 +++--
 2 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/fs/ceph/super.c b/fs/ceph/super.c
index 88d7e67130b8..ba835db374a3 100644
--- a/fs/ceph/super.c
+++ b/fs/ceph/super.c
@@ -70,7 +70,7 @@ static int ceph_statfs(struct dentry *dentry, struct kstatfs *buf)
 
 	/* fill in kstatfs */
 	buf->f_type = CEPH_SUPER_MAGIC;  /* ?? */
-	buf->f_frsize = 1 << CEPH_BLOCK_SHIFT;
+	buf->f_frsize = CEPH_BLOCK_SIZE;
 
 	/*
 	 * By default use root quota for stats; fallback to overall filesystem
@@ -79,9 +79,9 @@ static int ceph_statfs(struct dentry *dentry, struct kstatfs *buf)
 	 */
 	if (ceph_test_mount_opt(fsc, NOQUOTADF) ||
 	    !ceph_quota_update_statfs(fsc, buf)) {
-		buf->f_blocks = le64_to_cpu(st.kb) >> (CEPH_BLOCK_SHIFT-10);
-		buf->f_bfree = le64_to_cpu(st.kb_avail) >> (CEPH_BLOCK_SHIFT-10);
-		buf->f_bavail = le64_to_cpu(st.kb_avail) >> (CEPH_BLOCK_SHIFT-10);
+		buf->f_blocks = le64_to_cpu(st.kb) >> CEPH_4K_BLOCK_SHIFT;
+		buf->f_bfree = le64_to_cpu(st.kb_avail) >> CEPH_4K_BLOCK_SHIFT;
+		buf->f_bavail = le64_to_cpu(st.kb_avail) >> CEPH_4K_BLOCK_SHIFT;
 	}
 
 	/*
diff --git a/fs/ceph/super.h b/fs/ceph/super.h
index 9bc34c31831b..02115ed59ff1 100644
--- a/fs/ceph/super.h
+++ b/fs/ceph/super.h
@@ -25,9 +25,10 @@
 
 /* large granularity for statfs utilization stats to facilitate
  * large volume sizes on 32-bit machines. */
-#define CEPH_BLOCK_SHIFT   22  /* 4 MB */
-#define CEPH_BLOCK         (1 << CEPH_BLOCK_SHIFT)
+#define CEPH_BLOCK_SHIFT    22  /* 4 MB */
+#define CEPH_BLOCK_SIZE     (1 << CEPH_BLOCK_SHIFT)
 #define CEPH_4K_BLOCK_SHIFT 12  /* 4 KB */
+#define CEPH_4K_BLOCK_SIZE  (1 << CEPH_4K_BLOCK_SHIFT)
 
 #define CEPH_MOUNT_OPT_CLEANRECOVER    (1<<1) /* auto reonnect (clean mode) after blocklisted */
 #define CEPH_MOUNT_OPT_DIRSTAT         (1<<4) /* `cat dirname` for stats */
-- 
2.36.0.rc1

