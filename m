Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9DC8B5A123D
	for <lists+ceph-devel@lfdr.de>; Thu, 25 Aug 2022 15:31:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239879AbiHYNbs (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 25 Aug 2022 09:31:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242708AbiHYNbl (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 25 Aug 2022 09:31:41 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C044B14DD
        for <ceph-devel@vger.kernel.org>; Thu, 25 Aug 2022 06:31:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 7B0C7CE286B
        for <ceph-devel@vger.kernel.org>; Thu, 25 Aug 2022 13:31:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E306C433D6;
        Thu, 25 Aug 2022 13:31:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661434298;
        bh=JUbps6WhScdG4ogDZHupzh/QCqB+s08fsl6NLWoH+08=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IjQ1CbVda5nlXrlF5PMnQ85BioWXA6zCpdxw8S7T+RcV9Wp60p476v8U3gwQe+uXX
         fFnxYt4w0gRWxHnGMtj0ZFzje7tLCK8SWZXmw/Q6XXiY1GobJpO9wUc4PUAZ6/ZSGo
         yvehnSEJPvLVG8tNxFpG0b2D4jYdK1Ze3zPvg45Jm3G5N2PBA64fASYY75SJ21x5M1
         2TXO9/FroE30qKlR+cRM91zm4KuUjBSpp+ZcXq/uhiXaw+xa5QprSbvYjsdoG0ueap
         XPXu8GiRnHqdekIYwD1pfNXbZOAqhnWtvvQ2f99kB5qtjB5h12ylQHe8FTkwS7Oabq
         YGlAo50ChGUFQ==
From:   Jeff Layton <jlayton@kernel.org>
To:     xiubli@redhat.com, idryomov@gmail.com
Cc:     lhenriques@suse.de, ceph-devel@vger.kernel.org
Subject: [PATCH v15 05/29] ceph: get file size from fscrypt_file when present in inode traces
Date:   Thu, 25 Aug 2022 09:31:08 -0400
Message-Id: <20220825133132.153657-6-jlayton@kernel.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220825133132.153657-1-jlayton@kernel.org>
References: <20220825133132.153657-1-jlayton@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

When we get an inode trace from the MDS, grab the fscrypt_file field if
the inode is encrypted, and use it to populate the i_size field instead
of the regular inode size field.

Reviewed-by: Xiubo Li <xiubli@redhat.com>
Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/ceph/inode.c | 15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
index 67a2421ed092..4db19fc341a4 100644
--- a/fs/ceph/inode.c
+++ b/fs/ceph/inode.c
@@ -1036,6 +1036,7 @@ int ceph_fill_inode(struct inode *inode, struct page *locked_page,
 
 	if (new_version ||
 	    (new_issued & (CEPH_CAP_ANY_FILE_RD | CEPH_CAP_ANY_FILE_WR))) {
+		u64 size = le64_to_cpu(info->size);
 		s64 old_pool = ci->i_layout.pool_id;
 		struct ceph_string *old_ns;
 
@@ -1049,11 +1050,21 @@ int ceph_fill_inode(struct inode *inode, struct page *locked_page,
 
 		pool_ns = old_ns;
 
+		if (IS_ENCRYPTED(inode) && size && (iinfo->fscrypt_file_len == sizeof(__le64))) {
+			u64 fsize = __le64_to_cpu(*(__le64 *)iinfo->fscrypt_file);
+
+			if (size == round_up(fsize, CEPH_FSCRYPT_BLOCK_SIZE)) {
+				size = fsize;
+			} else {
+				pr_warn("fscrypt size mismatch: size=%llu fscrypt_file=%llu, discarding fscrypt_file size.\n",
+					info->size, size);
+			}
+		}
+
 		queue_trunc = ceph_fill_file_size(inode, issued,
 					le32_to_cpu(info->truncate_seq),
 					le64_to_cpu(info->truncate_size),
-					le64_to_cpu(info->size),
-					info_caps);
+					size, info_caps);
 		/* only update max_size on auth cap */
 		if ((info->cap.flags & CEPH_CAP_FLAG_AUTH) &&
 		    ci->i_max_size != le64_to_cpu(info->max_size)) {
-- 
2.37.2

