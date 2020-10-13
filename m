Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D0C328CC11
	for <lists+ceph-devel@lfdr.de>; Tue, 13 Oct 2020 12:58:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387804AbgJMK6z (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 13 Oct 2020 06:58:55 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:36103 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727097AbgJMK6z (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Tue, 13 Oct 2020 06:58:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1602586734;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc; bh=REmCgWYwJhHsPvepX/48qeuKG0BEbRA8uq96hiQdq0E=;
        b=U6gD2Yil7jc1d6etRXK+/JX4dmpDruMrbdTTHPViu9p5TBmAd6VKIINzlqIWV/uIXGtrHG
        wPteA3vUF2JysVYQPj4FtO4xHzGSTCQoT+CF+DyCiVxK2lWMJyZF7Dn3xhLNidu6NMwyWG
        +GcTR5P3BbjRn3ecy2El1t4tBJLj14k=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-75-VAajmguJM5-dPAgIZI7TQQ-1; Tue, 13 Oct 2020 06:58:50 -0400
X-MC-Unique: VAajmguJM5-dPAgIZI7TQQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E55771084C82;
        Tue, 13 Oct 2020 10:58:48 +0000 (UTC)
Received: from lxbceph1.gsslab.pek2.redhat.com (vm37-222.gsslab.pek2.redhat.com [10.72.37.222])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3F6C360C0F;
        Tue, 13 Oct 2020 10:58:45 +0000 (UTC)
From:   xiubli@redhat.com
To:     jlayton@kernel.org
Cc:     idryomov@gmail.com, zyan@redhat.com, pdonnell@redhat.com,
        ceph-devel@vger.kernel.org, Xiubo Li <xiubli@redhat.com>
Subject: [PATCH] ceph: add 'noshare' mount option support
Date:   Tue, 13 Oct 2020 18:31:12 +0800
Message-Id: <20201013103112.12132-1-xiubli@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: Xiubo Li <xiubli@redhat.com>

This will disable different mount points to share superblocks.

URL: https://tracker.ceph.com/issues/46883
Signed-off-by: Xiubo Li <xiubli@redhat.com>
---
 fs/ceph/super.c | 12 ++++++++++++
 fs/ceph/super.h |  1 +
 2 files changed, 13 insertions(+)

diff --git a/fs/ceph/super.c b/fs/ceph/super.c
index 2f530a111b3a..6f283e4d62ee 100644
--- a/fs/ceph/super.c
+++ b/fs/ceph/super.c
@@ -159,6 +159,7 @@ enum {
 	Opt_quotadf,
 	Opt_copyfrom,
 	Opt_wsync,
+	Opt_sharesb,
 };
 
 enum ceph_recover_session_mode {
@@ -199,6 +200,7 @@ static const struct fs_parameter_spec ceph_mount_parameters[] = {
 	fsparam_string	("source",			Opt_source),
 	fsparam_u32	("wsize",			Opt_wsize),
 	fsparam_flag_no	("wsync",			Opt_wsync),
+	fsparam_flag_no	("sharesb",			Opt_sharesb),
 	{}
 };
 
@@ -455,6 +457,12 @@ static int ceph_parse_mount_param(struct fs_context *fc,
 		else
 			fsopt->flags |= CEPH_MOUNT_OPT_ASYNC_DIROPS;
 		break;
+	case Opt_sharesb:
+		if (!result.negated)
+			fsopt->flags &= ~CEPH_MOUNT_OPT_NO_SHARE_SB;
+		else
+			fsopt->flags |= CEPH_MOUNT_OPT_NO_SHARE_SB;
+		break;
 	default:
 		BUG();
 	}
@@ -1007,6 +1015,10 @@ static int ceph_compare_super(struct super_block *sb, struct fs_context *fc)
 
 	dout("ceph_compare_super %p\n", sb);
 
+	if (fsopt->flags & CEPH_MOUNT_OPT_NO_SHARE_SB ||
+	    other->mount_options->flags & CEPH_MOUNT_OPT_NO_SHARE_SB)
+		return 0;
+
 	if (compare_mount_options(fsopt, opt, other)) {
 		dout("monitor(s)/mount options don't match\n");
 		return 0;
diff --git a/fs/ceph/super.h b/fs/ceph/super.h
index f097237a5ad3..e877c21196e5 100644
--- a/fs/ceph/super.h
+++ b/fs/ceph/super.h
@@ -44,6 +44,7 @@
 #define CEPH_MOUNT_OPT_NOQUOTADF       (1<<13) /* no root dir quota in statfs */
 #define CEPH_MOUNT_OPT_NOCOPYFROM      (1<<14) /* don't use RADOS 'copy-from' op */
 #define CEPH_MOUNT_OPT_ASYNC_DIROPS    (1<<15) /* allow async directory ops */
+#define CEPH_MOUNT_OPT_NO_SHARE_SB     (1<<16) /* disable sharing the same superblock */
 
 #define CEPH_MOUNT_OPT_DEFAULT			\
 	(CEPH_MOUNT_OPT_DCACHE |		\
-- 
2.18.4

