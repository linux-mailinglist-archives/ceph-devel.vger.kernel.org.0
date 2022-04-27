Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 03B02512259
	for <lists+ceph-devel@lfdr.de>; Wed, 27 Apr 2022 21:17:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233570AbiD0TUQ (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 27 Apr 2022 15:20:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233264AbiD0TTT (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 27 Apr 2022 15:19:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCB7549277
        for <ceph-devel@vger.kernel.org>; Wed, 27 Apr 2022 12:13:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6347B619E1
        for <ceph-devel@vger.kernel.org>; Wed, 27 Apr 2022 19:13:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B921C385AF;
        Wed, 27 Apr 2022 19:13:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651086825;
        bh=vJLDHbtT13mhryEotWQYEflQwUADw6c3JX3gik+rhUQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=P/UGaeXk3ZHT18BRDBmb9Apws2XP5YgW+ViaD9Wr8qwKdMvPXPJKiCv9vygwMLcC5
         AJzZfcRVBnEAmVqWQihxlvxgtD8ror4w7Twzb9HK+qkbFBWCHAw/+N2jbH9B0ulwKo
         o7iO1UpJYXkI6wOQ0ZSM3H65wX/lCstJEDXJ/nd9ZDCfkg/PFrPBYn42U3T2fwhxCh
         JZ08t3uujW9fOJ9ENgSYvZR/ybS4vTdahUlt+uQtzzrZirwGUMsSijP5BQOuny/tRQ
         nv0/RNonQWjTgKpF8tCkd8H+mUORpFKZCf1hzv+SV5ike3IqLH8FrTO35NRhouALiK
         CSf1x5ma7QwXg==
From:   Jeff Layton <jlayton@kernel.org>
To:     ceph-devel@vger.kernel.org
Cc:     xiubli@redhat.com, lhenriques@suse.de, idryomov@gmail.com
Subject: [PATCH v14 41/64] ceph: get file size from fscrypt_file when present in inode traces
Date:   Wed, 27 Apr 2022 15:12:51 -0400
Message-Id: <20220427191314.222867-42-jlayton@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220427191314.222867-1-jlayton@kernel.org>
References: <20220427191314.222867-1-jlayton@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

When we get an inode trace from the MDS, grab the fscrypt_file field if
the inode is encrypted, and use it to populate the i_size field instead
of the regular inode size field.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/ceph/inode.c | 18 +++++++++++++++---
 1 file changed, 15 insertions(+), 3 deletions(-)

diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
index 4fa4e206e8f4..d606dd7c093b 100644
--- a/fs/ceph/inode.c
+++ b/fs/ceph/inode.c
@@ -1024,6 +1024,7 @@ int ceph_fill_inode(struct inode *inode, struct page *locked_page,
 
 	if (new_version ||
 	    (new_issued & (CEPH_CAP_ANY_FILE_RD | CEPH_CAP_ANY_FILE_WR))) {
+		u64 size = le64_to_cpu(info->size);
 		s64 old_pool = ci->i_layout.pool_id;
 		struct ceph_string *old_ns;
 
@@ -1037,10 +1038,21 @@ int ceph_fill_inode(struct inode *inode, struct page *locked_page,
 
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
-					le32_to_cpu(info->truncate_seq),
-					le64_to_cpu(info->truncate_size),
-					le64_to_cpu(info->size));
+						  le32_to_cpu(info->truncate_seq),
+						  le64_to_cpu(info->truncate_size),
+						  size);
 		/* only update max_size on auth cap */
 		if ((info->cap.flags & CEPH_CAP_FLAG_AUTH) &&
 		    ci->i_max_size != le64_to_cpu(info->max_size)) {
-- 
2.35.1

