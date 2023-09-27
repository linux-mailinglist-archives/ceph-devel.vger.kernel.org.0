Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8BEB17AF857
	for <lists+ceph-devel@lfdr.de>; Wed, 27 Sep 2023 04:58:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235865AbjI0C61 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 26 Sep 2023 22:58:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229567AbjI0C40 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 26 Sep 2023 22:56:26 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B76F3C27
        for <ceph-devel@vger.kernel.org>; Tue, 26 Sep 2023 18:32:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1695778350;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=TvDOj3juH9ERDVkQgw5YGbYXiSy1AKROdMfOyyE9Qxo=;
        b=iiEYm370+EicfXaedjlic5mVsoy+S+wAVqaGq5Dax2YfS12oboBAGd7EY2RItSb1cBbkH9
        PpXlIpVmqz7ZJwQKB1qaj6kF4CFFAsfNkOLYpPrkytunYU1irhYFHPk311/fErEB5TKfds
        1+YqBeopYSWPiJn4g5aS+OaY/5TsbEY=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-593-XeXCLGT0O7uEUdO-fjP39w-1; Tue, 26 Sep 2023 21:32:27 -0400
X-MC-Unique: XeXCLGT0O7uEUdO-fjP39w-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C3BBD8007A4;
        Wed, 27 Sep 2023 01:32:26 +0000 (UTC)
Received: from li-a71a4dcc-35d1-11b2-a85c-951838863c8d.ibm.com.com (unknown [10.72.112.122])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0BC96492C37;
        Wed, 27 Sep 2023 01:32:23 +0000 (UTC)
From:   xiubli@redhat.com
To:     ceph-devel@vger.kernel.org
Cc:     idryomov@gmail.com, jlayton@kernel.org, vshankar@redhat.com,
        mchangir@redhat.com, Xiubo Li <xiubli@redhat.com>
Subject: [PATCH] Revert "ceph: enable async dirops by default"
Date:   Wed, 27 Sep 2023 09:30:09 +0800
Message-ID: <20230927013009.151922-1-xiubli@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: Xiubo Li <xiubli@redhat.com>

This reverts commit f7a67b463fb83a4b9b11ceaa8ec4950b8fb7f902.

The async dirop is buggy and introduce several bugs in MDS side
and not stable yet. Let's disable it for now and enable it later
when it's ready.

Signed-off-by: Xiubo Li <xiubli@redhat.com>
---
 fs/ceph/super.c | 4 ++--
 fs/ceph/super.h | 3 +--
 2 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/fs/ceph/super.c b/fs/ceph/super.c
index 5ec102f6b1ac..2bf6ccc9887b 100644
--- a/fs/ceph/super.c
+++ b/fs/ceph/super.c
@@ -742,8 +742,8 @@ static int ceph_show_options(struct seq_file *m, struct dentry *root)
 	if (fsopt->flags & CEPH_MOUNT_OPT_CLEANRECOVER)
 		seq_show_option(m, "recover_session", "clean");
 
-	if (!(fsopt->flags & CEPH_MOUNT_OPT_ASYNC_DIROPS))
-		seq_puts(m, ",wsync");
+	if (fsopt->flags & CEPH_MOUNT_OPT_ASYNC_DIROPS)
+		seq_puts(m, ",nowsync");
 	if (fsopt->flags & CEPH_MOUNT_OPT_NOPAGECACHE)
 		seq_puts(m, ",nopagecache");
 	if (fsopt->flags & CEPH_MOUNT_OPT_SPARSEREAD)
diff --git a/fs/ceph/super.h b/fs/ceph/super.h
index 7f4b62182a5d..a5476892896c 100644
--- a/fs/ceph/super.h
+++ b/fs/ceph/super.h
@@ -47,8 +47,7 @@
 
 #define CEPH_MOUNT_OPT_DEFAULT			\
 	(CEPH_MOUNT_OPT_DCACHE |		\
-	 CEPH_MOUNT_OPT_NOCOPYFROM |		\
-	 CEPH_MOUNT_OPT_ASYNC_DIROPS)
+	 CEPH_MOUNT_OPT_NOCOPYFROM)
 
 #define ceph_set_mount_opt(fsc, opt) \
 	(fsc)->mount_options->flags |= CEPH_MOUNT_OPT_##opt
-- 
2.41.0

