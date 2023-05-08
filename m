Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD1AF6FA03C
	for <lists+ceph-devel@lfdr.de>; Mon,  8 May 2023 08:55:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232997AbjEHGyz (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 8 May 2023 02:54:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232632AbjEHGyu (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 8 May 2023 02:54:50 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6B27A5F2
        for <ceph-devel@vger.kernel.org>; Sun,  7 May 2023 23:54:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1683528840;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=gMb0AoRmaPvYQLl9yiY9LbV8VSQy18FpswPbUKOd9Kk=;
        b=XApf/MSgt94sKWYye8kcjgs5AkQscDpfgMEUZdbsrg97ef6bD8wCwMpxQClbFuuGrT+HKz
        UldpCy7MtOU5DBWrri/7eApqNA8qXgpKMeOToJZYdGRsF6fANptLxEWdYewgwUcVIOmwjJ
        2qZ6ILw3zprIyB4aGbDWQfX+63WFIh4=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-620-kfqL9DrRMDuTqI-xhjtpig-1; Mon, 08 May 2023 02:53:57 -0400
X-MC-Unique: kfqL9DrRMDuTqI-xhjtpig-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3FDA8811E7C;
        Mon,  8 May 2023 06:53:57 +0000 (UTC)
Received: from li-a71a4dcc-35d1-11b2-a85c-951838863c8d.ibm.com.com (ovpn-12-156.pek2.redhat.com [10.72.12.156])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C1DB8492B00;
        Mon,  8 May 2023 06:53:53 +0000 (UTC)
From:   xiubli@redhat.com
To:     idryomov@gmail.com, ceph-devel@vger.kernel.org
Cc:     jlayton@kernel.org, Xiubo Li <xiubli@redhat.com>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@linaro.org>
Subject: [PATCH] ceph: fix the Smatch static checker warning in reconnect_caps_cb()
Date:   Mon,  8 May 2023 14:53:35 +0800
Message-Id: <20230508065335.114409-1-xiubli@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: Xiubo Li <xiubli@redhat.com>

Smatch static checker warning:

  fs/ceph/mds_client.c:3968 reconnect_caps_cb()
  warn: missing error code here? '__get_cap_for_mds()' failed. 'err' = '0'

Cc: stable@vger.kernel.org
Fixes: aaf67de78807 ("ceph: fix potential use-after-free bug when trimming caps")
Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
Signed-off-by: Xiubo Li <xiubli@redhat.com>
---
 fs/ceph/mds_client.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
index 36521bd4b78b..d6467fe7e5fa 100644
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -4296,7 +4296,7 @@ static int reconnect_caps_cb(struct inode *inode, int mds, void *arg)
 	struct dentry *dentry;
 	struct ceph_cap *cap;
 	char *path;
-	int pathlen = 0, err = 0;
+	int pathlen = 0, err;
 	u64 pathbase;
 	u64 snap_follows;
 
@@ -4319,6 +4319,7 @@ static int reconnect_caps_cb(struct inode *inode, int mds, void *arg)
 	cap = __get_cap_for_mds(ci, mds);
 	if (!cap) {
 		spin_unlock(&ci->i_ceph_lock);
+		err = 0;
 		goto out_err;
 	}
 	dout(" adding %p ino %llx.%llx cap %p %lld %s\n",
-- 
2.40.0

