Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3FAB1786C7B
	for <lists+ceph-devel@lfdr.de>; Thu, 24 Aug 2023 12:00:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240386AbjHXJ7w (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 24 Aug 2023 05:59:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240796AbjHXJ7Y (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 24 Aug 2023 05:59:24 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E49D8198E
        for <ceph-devel@vger.kernel.org>; Thu, 24 Aug 2023 02:58:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1692871113;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=0MEY1Vb3oskcmUZahePIrqq7M7VvRNVNxGxyyZRttnA=;
        b=b0+t+puMwuRPH6soh9sa1H2TDFkPVKM17Tli0z/SZ62CJG0lJONA97zPMm58Tuwm9lxgrw
        hvnKnUL7+McjdMQhpSUwzjUPxkyvt6bPGxmNZOm8F1FwT2OFIMls7phouuvdkqcUmbH4C0
        y1i1e9YBNL921v9yR6sYMci3p2u4uRc=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-18-XOWE00PBO_OkjUL_wIvX7A-1; Thu, 24 Aug 2023 05:58:31 -0400
X-MC-Unique: XOWE00PBO_OkjUL_wIvX7A-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 477E58D40A2;
        Thu, 24 Aug 2023 09:58:31 +0000 (UTC)
Received: from li-a71a4dcc-35d1-11b2-a85c-951838863c8d.ibm.com.com (unknown [10.72.112.84])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0C7A5492C13;
        Thu, 24 Aug 2023 09:58:19 +0000 (UTC)
From:   xiubli@redhat.com
To:     ceph-devel@vger.kernel.org
Cc:     pdonnell@redhat.com, idryomov@gmail.com, jlayton@kernel.org,
        vshankar@redhat.com, mchangir@redhat.com,
        Xiubo Li <xiubli@redhat.com>
Subject: [PATCH] ceph: skip reconnecting if MDS is not ready
Date:   Thu, 24 Aug 2023 17:55:51 +0800
Message-ID: <20230824095551.134118-1-xiubli@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: Xiubo Li <xiubli@redhat.com>

When MDS closed the session the kclient will send to reconnect to
it immediately, but if the MDS just restarted and still not ready
yet, such as still in the up:replay state and the sessionmap journal
logs hasn't be replayed, the MDS will close the session.

And then the kclient could remove the session and later when the
mdsmap is in RECONNECT phrase it will skip reconnecting. But the
will wait until timeout and then evicts the kclient.

Just skip sending the reconnection request until the MDS is ready.

URL: https://tracker.ceph.com/issues/62489
Signed-off-by: Xiubo Li <xiubli@redhat.com>
---
 fs/ceph/mds_client.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
index 9aae39289b43..a9ef93411679 100644
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -5809,7 +5809,8 @@ static void mds_peer_reset(struct ceph_connection *con)
 
 	pr_warn_client(mdsc->fsc->client, "mds%d closed our session\n",
 		       s->s_mds);
-	if (READ_ONCE(mdsc->fsc->mount_state) != CEPH_MOUNT_FENCE_IO)
+	if (READ_ONCE(mdsc->fsc->mount_state) != CEPH_MOUNT_FENCE_IO &&
+	    ceph_mdsmap_get_state(mdsc->mdsmap, s->s_mds) >= CEPH_MDS_STATE_RECONNECT)
 		send_mds_reconnect(mdsc, s);
 }
 
-- 
2.39.1

