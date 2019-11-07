Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 24B54F30CB
	for <lists+ceph-devel@lfdr.de>; Thu,  7 Nov 2019 15:05:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389009AbfKGOE4 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 7 Nov 2019 09:04:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:50230 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731026AbfKGOE4 (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Thu, 7 Nov 2019 09:04:56 -0500
Received: from tleilax.com (68-20-15-154.lightspeed.rlghnc.sbcglobal.net [68.20.15.154])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8F575214D8;
        Thu,  7 Nov 2019 14:04:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573135495;
        bh=LLmCV+99s2blOioahdMWPHKhK15Ab9DIWjsX8N53Khs=;
        h=From:To:Cc:Subject:Date:From;
        b=in3wvF8U/X+LZdZLFYYoiGBahcdQX8CaCVA11YpLn4gr+P61VjdRZczWMjhqLU8nf
         3m7LlqgQnJOJI7FPVa3031fXRIHBaARaUdxPTbHew3SZHMTAyz3PoCTIOj6VNYo5jP
         tV2z/zswPKd2lZasfULi5kyjnDMCKBEiyD1Ta2/U=
From:   Jeff Layton <jlayton@kernel.org>
To:     ceph-devel@vger.kernel.org
Cc:     idryomov@gmail.com, sage@redhat.com
Subject: [PATCH] ceph: return error on fsc mount option on kernel without support
Date:   Thu,  7 Nov 2019 09:04:51 -0500
Message-Id: <20191107140451.44991-1-jlayton@kernel.org>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

If the kernel was built without fscache support, then we should have it
return an error when someone attempts to mount with -o fsc. Also, prefix
the similar message with POSIX ACL support with "ceph:" to make it clear
which driver doesn't have that support.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/ceph/super.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/fs/ceph/super.c b/fs/ceph/super.c
index d68d6aad6d57..cdd3073acbac 100644
--- a/fs/ceph/super.c
+++ b/fs/ceph/super.c
@@ -373,6 +373,7 @@ static int ceph_parse_param(struct fs_context *fc, struct fs_parameter *param)
 		break;
 
 	case Opt_fscache:
+#ifdef CONFIG_CEPH_FSCACHE
 		kfree(fsopt->fscache_uniq);
 		fsopt->fscache_uniq = NULL;
 		if (result.negated) {
@@ -383,6 +384,9 @@ static int ceph_parse_param(struct fs_context *fc, struct fs_parameter *param)
 			param->string = NULL;
 		}
 		break;
+#else
+		return invalf(fc, "ceph: fscache support is disabled");
+#endif
 
 	case Opt_poolperm:
 		if (!result.negated)
@@ -413,7 +417,7 @@ static int ceph_parse_param(struct fs_context *fc, struct fs_parameter *param)
 #ifdef CONFIG_CEPH_FS_POSIX_ACL
 			fc->sb_flags |= SB_POSIXACL;
 #else
-			return invalf(fc, "POSIX ACL support is disabled");
+			return invalf(fc, "ceph: POSIX ACL support is disabled");
 #endif
 		} else {
 			fc->sb_flags &= ~SB_POSIXACL;
-- 
2.23.0

