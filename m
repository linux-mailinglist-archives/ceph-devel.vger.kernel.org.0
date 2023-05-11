Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 569EC6FEFAC
	for <lists+ceph-devel@lfdr.de>; Thu, 11 May 2023 12:10:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237579AbjEKKKd (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 11 May 2023 06:10:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237262AbjEKKK3 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 11 May 2023 06:10:29 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FB4AA1
        for <ceph-devel@vger.kernel.org>; Thu, 11 May 2023 03:09:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1683799779;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=1fSg2Ackb6JWL2rlZWfVz1e57OgNdzBPKnV84Bkej3Q=;
        b=PH7vHLZSKIf7AxlQKSdOf5oNw/1SM908X4p7qt0KYHBlpkN+Dkp+srb+CWcRlBEFq0PDsm
        R7iCHAuALp3quaxlUjIfLl+6wViy1NbCaBj+0axZN3GdckKSmOxha6w2oyqJqwM0HLzcjL
        H0QWpKaknmi28p2gG/wLyCNaze44ILQ=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-433-Agf6Xv2vP8GfZAANqi5IOQ-1; Thu, 11 May 2023 06:09:34 -0400
X-MC-Unique: Agf6Xv2vP8GfZAANqi5IOQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1AD0B3C0D1A5;
        Thu, 11 May 2023 10:09:34 +0000 (UTC)
Received: from li-a71a4dcc-35d1-11b2-a85c-951838863c8d.ibm.com.com (ovpn-12-156.pek2.redhat.com [10.72.12.156])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 11B3D40C2076;
        Thu, 11 May 2023 10:09:28 +0000 (UTC)
From:   xiubli@redhat.com
To:     idryomov@gmail.com, ceph-devel@vger.kernel.org
Cc:     jlayton@kernel.org, vshankar@redhat.com,
        Xiubo Li <xiubli@redhat.com>
Subject: [PATCH] ceph: trigger to flush the buffer when making snapshot
Date:   Thu, 11 May 2023 18:09:11 +0800
Message-Id: <20230511100911.361132-1-xiubli@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
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

The 'i_wr_ref' is used to track the 'Fb' caps, while whenever the 'Fb'
caps is took the kclient will always take the 'Fw' caps at the same
time. That means it will always be a false check in __ceph_finish_cap_snap().

When writing to buffer the kclient will take both 'Fb|Fw' caps and then
write the contents to the buffer pages by increasing the 'i_wrbuffer_ref'
and then just release both 'Fb|Fw'. This is different with the user
space libcephfs, which will keep the 'Fb' being took and use 'i_wr_ref'
instead of 'i_wrbuffer_ref' to track this until the buffer is flushed
to Rados.

We need to defer flushing the capsnap until the corresponding buffer
pages are all flushed to Rados, and at the same time just trigger to
flush the buffer pages immediately.

URL: https://tracker.ceph.com/issues/59343
URL: https://tracker.ceph.com/issues/48640
Signed-off-by: Xiubo Li <xiubli@redhat.com>
---
 fs/ceph/caps.c | 6 ++++++
 fs/ceph/snap.c | 9 ++++++---
 2 files changed, 12 insertions(+), 3 deletions(-)

diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
index 2732f46532ec..feabf4cc0c4f 100644
--- a/fs/ceph/caps.c
+++ b/fs/ceph/caps.c
@@ -3168,6 +3168,12 @@ static void __ceph_put_cap_refs(struct ceph_inode_info *ci, int had,
 	}
 	if (had & CEPH_CAP_FILE_WR) {
 		if (--ci->i_wr_ref == 0) {
+			/*
+			 * The Fb caps will always be took and released
+			 * together with the Fw caps.
+			 */
+			WARN_ON_ONCE(ci->i_wb_ref);
+
 			last++;
 			check_flushsnaps = true;
 			if (ci->i_wrbuffer_ref_head == 0 &&
diff --git a/fs/ceph/snap.c b/fs/ceph/snap.c
index 23b31600ee3c..0e59e95a96d9 100644
--- a/fs/ceph/snap.c
+++ b/fs/ceph/snap.c
@@ -676,14 +676,17 @@ int __ceph_finish_cap_snap(struct ceph_inode_info *ci,
 		return 0;
 	}
 
-	/* Fb cap still in use, delay it */
-	if (ci->i_wb_ref) {
+	/*
+	 * Defer flushing the capsnap if the dirty buffer not flushed yet.
+	 * And trigger to flush the buffer immediately.
+	 */
+	if (ci->i_wrbuffer_ref) {
 		dout("%s %p %llx.%llx cap_snap %p snapc %p %llu %s s=%llu "
 		     "used WRBUFFER, delaying\n", __func__, inode,
 		     ceph_vinop(inode), capsnap, capsnap->context,
 		     capsnap->context->seq, ceph_cap_string(capsnap->dirty),
 		     capsnap->size);
-		capsnap->writing = 1;
+		ceph_queue_writeback(inode);
 		return 0;
 	}
 
-- 
2.40.0

