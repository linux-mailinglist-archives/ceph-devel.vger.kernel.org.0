Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7DFC055B512
	for <lists+ceph-devel@lfdr.de>; Mon, 27 Jun 2022 04:03:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230060AbiF0CCw (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Sun, 26 Jun 2022 22:02:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229463AbiF0CCu (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Sun, 26 Jun 2022 22:02:50 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 2FA08F4C
        for <ceph-devel@vger.kernel.org>; Sun, 26 Jun 2022 19:02:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1656295369;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/r6if8rxd+n1U8f6SehEoqxfEKRR1K6CtpATwPG9IM4=;
        b=Oy4+0uQCa8aayyzfa5dV9Cn6WT8ZIjRtaVWBdJzuJ979BqyoHdVKOow7f3Na6DoC2o807K
        O0DgNWUz/qJhdQ5hy4HSVsAYENHx/i+Yw/hn4LAEwesWofDstCX4qMWhGqGmbzPFT06RaO
        lWrtbnPyziKx2biUQxN6IwPU/HU1l8A=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-600-a-rxOKVbN0-0qeQMUO7j3w-1; Sun, 26 Jun 2022 22:02:47 -0400
X-MC-Unique: a-rxOKVbN0-0qeQMUO7j3w-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 839951C06EEC;
        Mon, 27 Jun 2022 02:02:47 +0000 (UTC)
Received: from lxbceph1.gsslab.pek2.redhat.com (unknown [10.72.47.117])
        by smtp.corp.redhat.com (Postfix) with ESMTP id AB076C2810D;
        Mon, 27 Jun 2022 02:02:44 +0000 (UTC)
From:   xiubli@redhat.com
To:     jlayton@kernel.org, idryomov@gmail.com
Cc:     vshankar@redhat.com, pdonnell@redhat.com, lhenriques@suse.de,
        ceph-devel@vger.kernel.org, Xiubo Li <xiubli@redhat.com>
Subject: [PATCH v2 3/3] ceph: switch to 4KB block size if quota size is not aligned to 4MB
Date:   Mon, 27 Jun 2022 10:02:03 +0800
Message-Id: <20220627020203.173293-4-xiubli@redhat.com>
In-Reply-To: <20220627020203.173293-1-xiubli@redhat.com>
References: <20220627020203.173293-1-xiubli@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
X-Spam-Status: No, score=-2.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: Xiubo Li <xiubli@redhat.com>

If the quota size is larger than but not aligned to 4MB, the statfs
will always set the block size to 4MB and round down the fragment
size. For exmaple if the quota size is 6MB, the `df` will always
show 4MB capacity.

Make the block size to 4KB as default if quota size is set unless
the quota size is larger than or equals to 4MB and at the same time
it aligns to 4MB.

Signed-off-by: Xiubo Li <xiubli@redhat.com>
---
 fs/ceph/quota.c | 32 ++++++++++++++++++++------------
 1 file changed, 20 insertions(+), 12 deletions(-)

diff --git a/fs/ceph/quota.c b/fs/ceph/quota.c
index 64592adfe48f..37fe86bfb919 100644
--- a/fs/ceph/quota.c
+++ b/fs/ceph/quota.c
@@ -483,6 +483,7 @@ bool ceph_quota_update_statfs(struct ceph_fs_client *fsc, struct kstatfs *buf)
 	struct inode *in;
 	u64 total = 0, used, free;
 	bool is_updated = false;
+	u32 block_shift = CEPH_4K_BLOCK_SHIFT;
 
 	down_read(&mdsc->snap_rwsem);
 	realm = get_quota_realm(mdsc, d_inode(fsc->sb->s_root),
@@ -498,25 +499,32 @@ bool ceph_quota_update_statfs(struct ceph_fs_client *fsc, struct kstatfs *buf)
 		ci = ceph_inode(in);
 		spin_lock(&ci->i_ceph_lock);
 		if (ci->i_max_bytes) {
-			total = ci->i_max_bytes >> CEPH_BLOCK_SHIFT;
-			used = ci->i_rbytes >> CEPH_BLOCK_SHIFT;
-			/* For quota size less than 4MB, use 4KB block size */
-			if (!total) {
-				total = ci->i_max_bytes >> CEPH_4K_BLOCK_SHIFT;
-				used = ci->i_rbytes >> CEPH_4K_BLOCK_SHIFT;
-	                        buf->f_frsize = 1 << CEPH_4K_BLOCK_SHIFT;
-			}
-			/* It is possible for a quota to be exceeded.
+			/*
+			 * Switch to 4MB block size if quota size is
+			 * larger than or equals to 4MB and at the
+			 * same time is aligned to 4MB.
+			 */
+			if (IS_ALIGNED(ci->i_max_bytes, CEPH_BLOCK_SIZE))
+				block_shift = CEPH_BLOCK_SHIFT;
+
+			total = ci->i_max_bytes >> block_shift;
+			used = ci->i_rbytes >> block_shift;
+			buf->f_frsize = 1 << block_shift;
+
+			/*
+			 * It is possible for a quota to be exceeded.
 			 * Report 'zero' in that case
 			 */
 			free = total > used ? total - used : 0;
-			/* For quota size less than 4KB, report the
+			/*
+			 * For quota size less than 4KB, report the
 			 * total=used=4KB,free=0 when quota is full
-			 * and total=free=4KB, used=0 otherwise */
+			 * and total=free=4KB, used=0 otherwise
+			 */
 			if (!total) {
 				total = 1;
 				free = ci->i_max_bytes > ci->i_rbytes ? 1 : 0;
-	                        buf->f_frsize = 1 << CEPH_4K_BLOCK_SHIFT;
+	                        buf->f_frsize = CEPH_4K_BLOCK_SIZE;
 			}
 		}
 		spin_unlock(&ci->i_ceph_lock);
-- 
2.36.0.rc1

