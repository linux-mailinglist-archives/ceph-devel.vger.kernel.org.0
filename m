Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 01768512248
	for <lists+ceph-devel@lfdr.de>; Wed, 27 Apr 2022 21:16:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233436AbiD0TTc (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 27 Apr 2022 15:19:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233019AbiD0TTO (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 27 Apr 2022 15:19:14 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 673B6888E2
        for <ceph-devel@vger.kernel.org>; Wed, 27 Apr 2022 12:13:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1B0C6B82951
        for <ceph-devel@vger.kernel.org>; Wed, 27 Apr 2022 19:13:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55FF8C385AF;
        Wed, 27 Apr 2022 19:13:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651086809;
        bh=Xr5WwpOdJDLAwJ1HnaAMUsOMgwdZ2fjReZF8iNdzeus=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NU64mFW6tgJlC0nRk6fTkDSk9K5bzBxjK3GS7nGT7ajR/o/3iZysxS/uwRefVjGSt
         Nqa9ND8KqkOc+RnCRAKpwT66ZqOF6RbFw7VVEFNCXeS3/7GKx9LDZc/eQMFrytk/k5
         ao3d8PzvpxnGOapqQufzegwve+kEWNlUEpqcMtaFTeQOydJnKbqSiN9N7SZJxKVm8i
         MTC7d73Wnmm/LfyroSEZAPlymRsv8o6rloec43GRh+InAOK1qC7b0CxwmX2x7MLMwO
         B4RrDgRrPGYOHHT50bBe/mFL69Euj2IlVwuExuWYnUdaVQiFGv0VLIPPwokRcYf58B
         DnFf+jugcp1uA==
From:   Jeff Layton <jlayton@kernel.org>
To:     ceph-devel@vger.kernel.org
Cc:     xiubli@redhat.com, lhenriques@suse.de, idryomov@gmail.com
Subject: [PATCH v14 18/64] ceph: make the ioctl cmd more readable in debug log
Date:   Wed, 27 Apr 2022 15:12:28 -0400
Message-Id: <20220427191314.222867-19-jlayton@kernel.org>
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

From: Xiubo Li <xiubli@redhat.com>

    ioctl file 0000000004e6b054 cmd 2148296211 arg 824635143532

The numerical cmd valye in the ioctl debug log message is too hard to
understand even when you look at it in the code. Make it more readable.

Signed-off-by: Xiubo Li <xiubli@redhat.com>
Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/ceph/ioctl.c | 39 ++++++++++++++++++++++++++++++++++++++-
 1 file changed, 38 insertions(+), 1 deletion(-)

diff --git a/fs/ceph/ioctl.c b/fs/ceph/ioctl.c
index 477ecc667aee..b9f0f4e460ab 100644
--- a/fs/ceph/ioctl.c
+++ b/fs/ceph/ioctl.c
@@ -313,11 +313,48 @@ static long ceph_set_encryption_policy(struct file *file, unsigned long arg)
 	return ret;
 }
 
+static const char *ceph_ioctl_cmd_name(const unsigned int cmd)
+{
+	switch (cmd) {
+	case CEPH_IOC_GET_LAYOUT:
+		return "get_layout";
+	case CEPH_IOC_SET_LAYOUT:
+		return "set_layout";
+	case CEPH_IOC_SET_LAYOUT_POLICY:
+		return "set_layout_policy";
+	case CEPH_IOC_GET_DATALOC:
+		return "get_dataloc";
+	case CEPH_IOC_LAZYIO:
+		return "lazyio";
+	case CEPH_IOC_SYNCIO:
+		return "syncio";
+	case FS_IOC_SET_ENCRYPTION_POLICY:
+		return "set encryption_policy";
+	case FS_IOC_GET_ENCRYPTION_POLICY:
+		return "get_encryption_policy";
+	case FS_IOC_GET_ENCRYPTION_POLICY_EX:
+		return "get_encryption_policy_ex";
+	case FS_IOC_ADD_ENCRYPTION_KEY:
+		return "add_encryption_key";
+	case FS_IOC_REMOVE_ENCRYPTION_KEY:
+		return "remove_encryption_key";
+	case FS_IOC_REMOVE_ENCRYPTION_KEY_ALL_USERS:
+		return "remove_encryption_key_all_users";
+	case FS_IOC_GET_ENCRYPTION_KEY_STATUS:
+		return "get_encryption_key_status";
+	case FS_IOC_GET_ENCRYPTION_NONCE:
+		return "get_encryption_nonce";
+	default:
+		return "unknown";
+	}
+}
+
 long ceph_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 {
 	int ret;
 
-	dout("ioctl file %p cmd %u arg %lu\n", file, cmd, arg);
+	dout("ioctl file %p cmd %s arg %lu\n", file,
+	     ceph_ioctl_cmd_name(cmd), arg);
 	switch (cmd) {
 	case CEPH_IOC_GET_LAYOUT:
 		return ceph_ioctl_get_layout(file, (void __user *)arg);
-- 
2.35.1

