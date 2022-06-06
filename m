Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4407453E323
	for <lists+ceph-devel@lfdr.de>; Mon,  6 Jun 2022 10:55:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231169AbiFFH30 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 6 Jun 2022 03:29:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231160AbiFFH3Y (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 6 Jun 2022 03:29:24 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 5AA0018F2CB
        for <ceph-devel@vger.kernel.org>; Mon,  6 Jun 2022 00:29:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1654500563;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=e/uwDFruTLONkMCb6cfoD1Yt9rkzFdOg9tGFvOdddkE=;
        b=GIMElgql2HZ+OnmilQW4HS4bJzkBWH39mwj0tqUW+OnwKB4xuKkTr2PMkXzhd1SPHY9p0I
        320ey8VZXVNeI7PdpBtHOTqKpO1fc+mn1Et7dj4/On807/wxGupDR/7VGsm74HjLaYj7IR
        HsoWRO7nmboj19CZcqvlDYFygNdiVi4=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-499-YoP3ocsMMBmqsBEnEtZ8cQ-1; Mon, 06 Jun 2022 03:29:20 -0400
X-MC-Unique: YoP3ocsMMBmqsBEnEtZ8cQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B01143C11043;
        Mon,  6 Jun 2022 07:29:19 +0000 (UTC)
Received: from localhost (unknown [10.72.47.117])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 10A4B40CF8EA;
        Mon,  6 Jun 2022 07:29:18 +0000 (UTC)
From:   Xiubo Li <xiubli@redhat.com>
To:     jlayton@kernel.org, idryomov@gmail.com
Cc:     vshankar@redhat.com, ceph-devel@vger.kernel.org,
        Xiubo Li <xiubli@redhat.com>
Subject: [PATCH] ceph: fix incorrectly assigning random values to peer's members
Date:   Mon,  6 Jun 2022 15:28:35 +0800
Message-Id: <20220606072835.302935-1-xiubli@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

For export the peer is empty in ceph.

URL: https://tracker.ceph.com/issues/55857
Signed-off-by: Xiubo Li <xiubli@redhat.com>
---
 fs/ceph/caps.c | 15 +++++----------
 1 file changed, 5 insertions(+), 10 deletions(-)

diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
index 0a48bf829671..8efa46ff4282 100644
--- a/fs/ceph/caps.c
+++ b/fs/ceph/caps.c
@@ -4127,16 +4127,11 @@ void ceph_handle_caps(struct ceph_mds_session *session,
 		p += flock_len;
 	}
 
-	if (msg_version >= 3) {
-		if (op == CEPH_CAP_OP_IMPORT) {
-			if (p + sizeof(*peer) > end)
-				goto bad;
-			peer = p;
-			p += sizeof(*peer);
-		} else if (op == CEPH_CAP_OP_EXPORT) {
-			/* recorded in unused fields */
-			peer = (void *)&h->size;
-		}
+	if (msg_version >= 3 && op == CEPH_CAP_OP_IMPORT) {
+		if (p + sizeof(*peer) > end)
+			goto bad;
+		peer = p;
+		p += sizeof(*peer);
 	}
 
 	if (msg_version >= 4) {
-- 
2.36.0.rc1

