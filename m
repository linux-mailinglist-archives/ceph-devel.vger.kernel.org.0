Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D292B6A398E
	for <lists+ceph-devel@lfdr.de>; Mon, 27 Feb 2023 04:30:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230028AbjB0Da1 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Sun, 26 Feb 2023 22:30:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230091AbjB0DaZ (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Sun, 26 Feb 2023 22:30:25 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26CB11C329
        for <ceph-devel@vger.kernel.org>; Sun, 26 Feb 2023 19:29:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1677468566;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2RCgW+SN8rzklZa8tIzKT0RkfxPCj+mTL1vBAvZfqj4=;
        b=QQEKFbxypsUohteqmyE8q/QJC5VUdTb3k6hniLiH2Zsbgmh/pVfZafeLVp+kfpn0hOTM7K
        YgH7E1Sc3jHQgRvQKF4DzgkyHBuhZ0u75xgRn3cdw7MTdtzeplz4TPjaIEW+sMfOSmFMy/
        UZVcHsBXztP18tuPiVjuINtQVwpmBI0=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-541-wlJQxGgGMS6KorPy9Jv7QQ-1; Sun, 26 Feb 2023 22:29:25 -0500
X-MC-Unique: wlJQxGgGMS6KorPy9Jv7QQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id EEC02101A521;
        Mon, 27 Feb 2023 03:29:24 +0000 (UTC)
Received: from lxbceph1.gsslab.pek2.redhat.com (unknown [10.72.47.117])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2B62B1731B;
        Mon, 27 Feb 2023 03:29:21 +0000 (UTC)
From:   xiubli@redhat.com
To:     idryomov@gmail.com, ceph-devel@vger.kernel.org
Cc:     jlayton@kernel.org, lhenriques@suse.de, vshankar@redhat.com,
        mchangir@redhat.com, Xiubo Li <xiubli@redhat.com>
Subject: [PATCH v16 18/68] ceph: make the ioctl cmd more readable in debug log
Date:   Mon, 27 Feb 2023 11:27:23 +0800
Message-Id: <20230227032813.337906-19-xiubli@redhat.com>
In-Reply-To: <20230227032813.337906-1-xiubli@redhat.com>
References: <20230227032813.337906-1-xiubli@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
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
index 2a5c48107026..7f0e181d4329 100644
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
2.31.1

