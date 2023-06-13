Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3CF1572D937
	for <lists+ceph-devel@lfdr.de>; Tue, 13 Jun 2023 07:31:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240147AbjFMFbL (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 13 Jun 2023 01:31:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240178AbjFMFaq (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 13 Jun 2023 01:30:46 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB30F1BD9
        for <ceph-devel@vger.kernel.org>; Mon, 12 Jun 2023 22:29:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1686634170;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=CKjuhqJd92a7mmAZq3evqt5k4d/0ycaYS2Mjm8QJ3vM=;
        b=DJq+ugiLd8HRS5bWzBWzOdHr6tA834H2J+Qz4OgzlYwxQ7nHqhlym+NeGsHadrJSjiizqw
        diMu0EoGYwtDgmRVvD2OD6xeoA8AS3A/ZVMR97fF+pbW4Kgvv6WRScYwziMb+Ex0cxfMHW
        wmPnfZY+pPY4qLdkSr2quOxs0UUH9GI=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-36-sE2kOhmXMCCKlj8i_7TwWQ-1; Tue, 13 Jun 2023 01:29:28 -0400
X-MC-Unique: sE2kOhmXMCCKlj8i_7TwWQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 87BC328EC102;
        Tue, 13 Jun 2023 05:29:28 +0000 (UTC)
Received: from li-a71a4dcc-35d1-11b2-a85c-951838863c8d.ibm.com.com (ovpn-12-155.pek2.redhat.com [10.72.12.155])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2892E1121315;
        Tue, 13 Jun 2023 05:29:24 +0000 (UTC)
From:   xiubli@redhat.com
To:     idryomov@gmail.com, ceph-devel@vger.kernel.org
Cc:     jlayton@kernel.org, vshankar@redhat.com, mchangir@redhat.com,
        lhenriques@suse.de, Xiubo Li <xiubli@redhat.com>
Subject: [PATCH v20 39/71] libceph: add CEPH_OSD_OP_ASSERT_VER support
Date:   Tue, 13 Jun 2023 13:23:52 +0800
Message-Id: <20230613052424.254540-40-xiubli@redhat.com>
In-Reply-To: <20230613052424.254540-1-xiubli@redhat.com>
References: <20230613052424.254540-1-xiubli@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: Jeff Layton <jlayton@kernel.org>

...and record the user_version in the reply in a new field in
ceph_osd_request, so we can populate the assert_ver appropriately.
Shuffle the fields a bit too so that the new field fits in an
existing hole on x86_64.

Tested-by: Luís Henriques <lhenriques@suse.de>
Tested-by: Venky Shankar <vshankar@redhat.com>
Reviewed-by: Luís Henriques <lhenriques@suse.de>
Reviewed-by: Xiubo Li <xiubli@redhat.com>
Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 include/linux/ceph/osd_client.h | 6 +++++-
 include/linux/ceph/rados.h      | 4 ++++
 net/ceph/osd_client.c           | 5 +++++
 3 files changed, 14 insertions(+), 1 deletion(-)

diff --git a/include/linux/ceph/osd_client.h b/include/linux/ceph/osd_client.h
index 680b4a70f6d4..41bcd71cfa7a 100644
--- a/include/linux/ceph/osd_client.h
+++ b/include/linux/ceph/osd_client.h
@@ -198,6 +198,9 @@ struct ceph_osd_req_op {
 			u32 src_fadvise_flags;
 			struct ceph_osd_data osd_data;
 		} copy_from;
+		struct {
+			u64 ver;
+		} assert_ver;
 	};
 };
 
@@ -252,6 +255,7 @@ struct ceph_osd_request {
 	struct ceph_osd_client *r_osdc;
 	struct kref       r_kref;
 	bool              r_mempool;
+	bool		  r_linger;           /* don't resend on failure */
 	struct completion r_completion;       /* private to osd_client.c */
 	ceph_osdc_callback_t r_callback;
 
@@ -264,9 +268,9 @@ struct ceph_osd_request {
 	struct ceph_snap_context *r_snapc;    /* for writes */
 	struct timespec64 r_mtime;            /* ditto */
 	u64 r_data_offset;                    /* ditto */
-	bool r_linger;                        /* don't resend on failure */
 
 	/* internal */
+	u64 r_version;			      /* data version sent in reply */
 	unsigned long r_stamp;                /* jiffies, send or check time */
 	unsigned long r_start_stamp;          /* jiffies */
 	ktime_t r_start_latency;              /* ktime_t */
diff --git a/include/linux/ceph/rados.h b/include/linux/ceph/rados.h
index 43a7a1573b51..73c3efbec36c 100644
--- a/include/linux/ceph/rados.h
+++ b/include/linux/ceph/rados.h
@@ -523,6 +523,10 @@ struct ceph_osd_op {
 		struct {
 			__le64 cookie;
 		} __attribute__ ((packed)) notify;
+		struct {
+			__le64 unused;
+			__le64 ver;
+		} __attribute__ ((packed)) assert_ver;
 		struct {
 			__le64 offset, length;
 			__le64 src_offset;
diff --git a/net/ceph/osd_client.c b/net/ceph/osd_client.c
index 9138abc07f45..2dcb1140ed21 100644
--- a/net/ceph/osd_client.c
+++ b/net/ceph/osd_client.c
@@ -1048,6 +1048,10 @@ static u32 osd_req_encode_op(struct ceph_osd_op *dst,
 		dst->copy_from.src_fadvise_flags =
 			cpu_to_le32(src->copy_from.src_fadvise_flags);
 		break;
+	case CEPH_OSD_OP_ASSERT_VER:
+		dst->assert_ver.unused = cpu_to_le64(0);
+		dst->assert_ver.ver = cpu_to_le64(src->assert_ver.ver);
+		break;
 	default:
 		pr_err("unsupported osd opcode %s\n",
 			ceph_osd_op_name(src->op));
@@ -3852,6 +3856,7 @@ static void handle_reply(struct ceph_osd *osd, struct ceph_msg *msg)
 	 * one (type of) reply back.
 	 */
 	WARN_ON(!(m.flags & CEPH_OSD_FLAG_ONDISK));
+	req->r_version = m.user_version;
 	req->r_result = m.result ?: data_len;
 	finish_request(req);
 	mutex_unlock(&osd->lock);
-- 
2.40.1

