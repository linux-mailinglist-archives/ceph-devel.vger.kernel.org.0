Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2E3BC7AA8F7
	for <lists+ceph-devel@lfdr.de>; Fri, 22 Sep 2023 08:26:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231370AbjIVG0Z (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 22 Sep 2023 02:26:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231532AbjIVG0U (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Fri, 22 Sep 2023 02:26:20 -0400
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2AE4C1BB
        for <ceph-devel@vger.kernel.org>; Thu, 21 Sep 2023 23:26:09 -0700 (PDT)
Received: by mail-ej1-x62c.google.com with SMTP id a640c23a62f3a-9ad8bf9bfabso214550466b.3
        for <ceph-devel@vger.kernel.org>; Thu, 21 Sep 2023 23:26:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google; t=1695363967; x=1695968767; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Hc1EfM4Ltnso0WZLWYNawQf+V2mMDzvf7BDBSh0CjLs=;
        b=Xi3hU7u3ESXKPnQypKv7hQWrvchrgwjc24rjyV9hebdbC3qHo2ymQU/g2fiYKVttl5
         dcXnxAEenT0ykxocx7998TSKHSfvqPlaLoLyJUsSm9vMVQXzUYYos1foB26VSQvsE10p
         f5vZKgpakp9najw2bSztkQ8jU6gWMjL0uhTMdZAY3dlqPRW94ZLa2SBuKsfTx1gK++ZH
         i0o5r1YHr8jmSdg04xVSvWhPCjzDGXD4y8hODAnWb/WqV5WWeFK1YcKIAC0YlhN2esWz
         3Iv/TSRbuMHer79kkzCu9IEydQOMJgK3LOY6C71SOFrfe5zWuVm30DGAnqloK8/ULkQQ
         iIRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695363967; x=1695968767;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Hc1EfM4Ltnso0WZLWYNawQf+V2mMDzvf7BDBSh0CjLs=;
        b=DlqAbUUif/nr5pERIn2+tqjVfJZwQA1qRsy+CUr4SVSXznfi+uKdBK/PODmqR6ziEX
         Lath6jlex5KMGigyV4QoHw71yn0Bccwped9vAzab1dAfBR8SCBLXjp1tOpuydU4SSeW3
         /IZ7TYiDuN+Wzon0+R14aUj2y2zDb0pnzSt1DeXfG0KBVFsEcEofRRfeXziCHZYgSop3
         nwhBWOg+0LxQXY0PUja/Q+NbueBy+pOTf3NeC5TubBnhAWxkAYrfIU5sUm///vjIuQbA
         mTA+/66/ngocVl+D9x734uGkmHVoUyPCj2FJIee3E9/q2aIbEdGBJX3C0VEVi0F0v7Vr
         4y6w==
X-Gm-Message-State: AOJu0YxXwDksFp3bqCBHWcNwSb1K1dZLBCp4MkzUpi5yl4DK7OpcynZZ
        mxchfpc8w4mYzqwDQMmQf32VeA==
X-Google-Smtp-Source: AGHT+IHshGX6wjH7dpeUCyrvBXH7IlLquPjC5dKAorG5dmp9neFw6do3Ta3KBKMZjb0B6XijMUahKw==
X-Received: by 2002:a17:906:2096:b0:9ae:1de:f4fb with SMTP id 22-20020a170906209600b009ae01def4fbmr6180280ejq.46.1695363967557;
        Thu, 21 Sep 2023 23:26:07 -0700 (PDT)
Received: from heron.intern.cm-ag (p200300dc6f209c00529a4cfffe3dd983.dip0.t-ipconnect.de. [2003:dc:6f20:9c00:529a:4cff:fe3d:d983])
        by smtp.gmail.com with ESMTPSA id gy6-20020a170906f24600b00992afee724bsm2195519ejb.76.2023.09.21.23.26.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Sep 2023 23:26:07 -0700 (PDT)
From:   Max Kellermann <max.kellermann@ionos.com>
To:     Xiubo Li <xiubli@redhat.com>, Ilya Dryomov <idryomov@gmail.com>,
        Jeff Layton <jlayton@kernel.org>
Cc:     Max Kellermann <max.kellermann@ionos.com>,
        ceph-devel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] fs/ceph/debugfs: make all files world-readable
Date:   Fri, 22 Sep 2023 08:25:57 +0200
Message-Id: <20230922062558.1739642-1-max.kellermann@ionos.com>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

I'd like to be able to run metrics collector processes without special
privileges

In the kernel, there is a mix of debugfs files being world-readable
and not world-readable is; with a naive "git grep", I found 723
world-readable debugfs_create_file() calls and 582 calls which were
only accessible to privileged processe.

From the code, I cannot derive a consistent policy for that, but the
ceph statistics seem harmless (and useful) enough.

Signed-off-by: Max Kellermann <max.kellermann@ionos.com>
---
 fs/ceph/debugfs.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/fs/ceph/debugfs.c b/fs/ceph/debugfs.c
index 3904333fa6c3..2abee7e18144 100644
--- a/fs/ceph/debugfs.c
+++ b/fs/ceph/debugfs.c
@@ -429,31 +429,31 @@ void ceph_fs_debugfs_init(struct ceph_fs_client *fsc)
 				       name);
 
 	fsc->debugfs_mdsmap = debugfs_create_file("mdsmap",
-					0400,
+					0444,
 					fsc->client->debugfs_dir,
 					fsc,
 					&mdsmap_fops);
 
 	fsc->debugfs_mds_sessions = debugfs_create_file("mds_sessions",
-					0400,
+					0444,
 					fsc->client->debugfs_dir,
 					fsc,
 					&mds_sessions_fops);
 
 	fsc->debugfs_mdsc = debugfs_create_file("mdsc",
-						0400,
+						0444,
 						fsc->client->debugfs_dir,
 						fsc,
 						&mdsc_fops);
 
 	fsc->debugfs_caps = debugfs_create_file("caps",
-						0400,
+						0444,
 						fsc->client->debugfs_dir,
 						fsc,
 						&caps_fops);
 
 	fsc->debugfs_status = debugfs_create_file("status",
-						  0400,
+						  0444,
 						  fsc->client->debugfs_dir,
 						  fsc,
 						  &status_fops);
@@ -461,13 +461,13 @@ void ceph_fs_debugfs_init(struct ceph_fs_client *fsc)
 	fsc->debugfs_metrics_dir = debugfs_create_dir("metrics",
 						      fsc->client->debugfs_dir);
 
-	debugfs_create_file("file", 0400, fsc->debugfs_metrics_dir, fsc,
+	debugfs_create_file("file", 0444, fsc->debugfs_metrics_dir, fsc,
 			    &metrics_file_fops);
-	debugfs_create_file("latency", 0400, fsc->debugfs_metrics_dir, fsc,
+	debugfs_create_file("latency", 0444, fsc->debugfs_metrics_dir, fsc,
 			    &metrics_latency_fops);
-	debugfs_create_file("size", 0400, fsc->debugfs_metrics_dir, fsc,
+	debugfs_create_file("size", 0444, fsc->debugfs_metrics_dir, fsc,
 			    &metrics_size_fops);
-	debugfs_create_file("caps", 0400, fsc->debugfs_metrics_dir, fsc,
+	debugfs_create_file("caps", 0444, fsc->debugfs_metrics_dir, fsc,
 			    &metrics_caps_fops);
 }
 
-- 
2.39.2

