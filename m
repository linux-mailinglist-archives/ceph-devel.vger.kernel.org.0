Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4ECAEF31AE
	for <lists+ceph-devel@lfdr.de>; Thu,  7 Nov 2019 15:39:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727480AbfKGOjf (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 7 Nov 2019 09:39:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:47518 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727166AbfKGOjf (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Thu, 7 Nov 2019 09:39:35 -0500
Received: from tleilax.com (68-20-15-154.lightspeed.rlghnc.sbcglobal.net [68.20.15.154])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 88B81214D8;
        Thu,  7 Nov 2019 14:39:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573137574;
        bh=65g68sDl0FtiNZOsZ6mli1g1mqzRomNYFS15rB7rwjI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gplkApToggZR+P8Ul4xaA3Kw7bHX/dOUaeiycc07HZq72U61jVXlbOoj4ie8QMgDc
         8CFraSxd8afck5p4r/o+BteNpd8KYJ0k3EfV/mQQvZ+iO641Fo+8hfFp+ArOZ0xq4n
         u5UxhOjJ+El5cG5175Hzz/OO3bHEaAdFmhnlC/4g=
From:   Jeff Layton <jlayton@kernel.org>
To:     ceph-devel@vger.kernel.org
Cc:     idryomov@gmail.com, sage@redhat.com
Subject: [PATCH v2] ceph: return -EINVAL if given fsc mount option on kernel w/o support
Date:   Thu,  7 Nov 2019 09:39:32 -0500
Message-Id: <20191107143932.65798-1-jlayton@kernel.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191107140451.44991-1-jlayton@kernel.org>
References: <20191107140451.44991-1-jlayton@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

If someone requests fscache on the mount, and the kernel doesn't
support it, it should fail the mount.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/ceph/super.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

I sent a previous version of this patch, but it was based on top of the
mount API rework. I think we're better off reordering this patch before
that though, for easier backports.

diff --git a/fs/ceph/super.c b/fs/ceph/super.c
index edfd643a8205..e75b6b82267d 100644
--- a/fs/ceph/super.c
+++ b/fs/ceph/super.c
@@ -268,6 +268,7 @@ static int parse_fsopt_token(char *c, void *private)
 		}
 		break;
 	case Opt_fscache_uniq:
+#ifdef CONFIG_CEPH_FSCACHE
 		kfree(fsopt->fscache_uniq);
 		fsopt->fscache_uniq = kstrndup(argstr[0].from,
 					       argstr[0].to-argstr[0].from,
@@ -276,7 +277,10 @@ static int parse_fsopt_token(char *c, void *private)
 			return -ENOMEM;
 		fsopt->flags |= CEPH_MOUNT_OPT_FSCACHE;
 		break;
-		/* misc */
+#else
+		pr_err("ceph: fscache support is disabled\n");
+		return -EINVAL;
+#endif
 	case Opt_wsize:
 		if (intval < (int)PAGE_SIZE || intval > CEPH_MAX_WRITE_SIZE)
 			return -EINVAL;
@@ -353,10 +357,15 @@ static int parse_fsopt_token(char *c, void *private)
 		fsopt->flags &= ~CEPH_MOUNT_OPT_INO32;
 		break;
 	case Opt_fscache:
+#ifdef CONFIG_CEPH_FSCACHE
 		fsopt->flags |= CEPH_MOUNT_OPT_FSCACHE;
 		kfree(fsopt->fscache_uniq);
 		fsopt->fscache_uniq = NULL;
 		break;
+#else
+		pr_err("ceph: fscache support is disabled\n");
+		return -EINVAL;
+#endif
 	case Opt_nofscache:
 		fsopt->flags &= ~CEPH_MOUNT_OPT_FSCACHE;
 		kfree(fsopt->fscache_uniq);
-- 
2.23.0

