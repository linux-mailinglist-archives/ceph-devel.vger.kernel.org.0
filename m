Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED30572D922
	for <lists+ceph-devel@lfdr.de>; Tue, 13 Jun 2023 07:29:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240125AbjFMF3n (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 13 Jun 2023 01:29:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240123AbjFMF3N (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 13 Jun 2023 01:29:13 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D46FA170C
        for <ceph-devel@vger.kernel.org>; Mon, 12 Jun 2023 22:28:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1686634083;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=zdLbGZzrG2jNbIiYz5Bsr28TntZcfhSzEyijUrg/HCI=;
        b=E63deryVJnu4eS7ElKUKtK7rDn3rvrTzT4J/XjzsmwALNCQAj7BqHtfPTReMSse2xTdFmB
        HOWgaNwYv9O5ZmjRh4GYIYKl0UYMDx5kYj4iG4hN0srWxu+7pK6UOh0kb5KDe3vkp5l7u4
        4t0RneRNvrXSmEvDGD6fba6bg5kBBlU=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-133-do1r3xTWPLyAwQmt21GLFA-1; Tue, 13 Jun 2023 01:27:59 -0400
X-MC-Unique: do1r3xTWPLyAwQmt21GLFA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 67F421C02D27;
        Tue, 13 Jun 2023 05:27:59 +0000 (UTC)
Received: from li-a71a4dcc-35d1-11b2-a85c-951838863c8d.ibm.com.com (ovpn-12-155.pek2.redhat.com [10.72.12.155])
        by smtp.corp.redhat.com (Postfix) with ESMTP id AB9901121314;
        Tue, 13 Jun 2023 05:27:55 +0000 (UTC)
From:   xiubli@redhat.com
To:     idryomov@gmail.com, ceph-devel@vger.kernel.org
Cc:     jlayton@kernel.org, vshankar@redhat.com, mchangir@redhat.com,
        lhenriques@suse.de, Xiubo Li <xiubli@redhat.com>
Subject: [PATCH v20 18/71] ceph: make the ioctl cmd more readable in debug log
Date:   Tue, 13 Jun 2023 13:23:31 +0800
Message-Id: <20230613052424.254540-19-xiubli@redhat.com>
In-Reply-To: <20230613052424.254540-1-xiubli@redhat.com>
References: <20230613052424.254540-1-xiubli@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
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

Tested-by: Luís Henriques <lhenriques@suse.de>
Tested-by: Venky Shankar <vshankar@redhat.com>
Reviewed-by: Luís Henriques <lhenriques@suse.de>
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
2.40.1

