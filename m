Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 96A837ACF7F
	for <lists+ceph-devel@lfdr.de>; Mon, 25 Sep 2023 07:31:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231915AbjIYFbh (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 25 Sep 2023 01:31:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231922AbjIYFbe (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 25 Sep 2023 01:31:34 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D48C6DA
        for <ceph-devel@vger.kernel.org>; Sun, 24 Sep 2023 22:30:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1695619845;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=R5LIkF2/0hCwA84weq+iv5yAtFIJRmfwxJdVZ0dOy68=;
        b=bAYgQ6muHorWa5Y4OOX1l0vPzPvOFwq1ReObHrSt0mKPfl9+mSslUOGpgy2RbGVzqKxZPD
        YYfthL12t64RGmOkPS36HaVuJ9HNvkaXU78XFJE+Z90Q+WftSmL+Pznjwfy6P9/qoLnztK
        1Zv8ylFNJ21FvTxRiQqCoH6mSaOEqqo=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-158-lymyRr6XPIyGjs76dUMSHw-1; Mon, 25 Sep 2023 01:30:43 -0400
X-MC-Unique: lymyRr6XPIyGjs76dUMSHw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0BDFB811E7D;
        Mon, 25 Sep 2023 05:30:43 +0000 (UTC)
Received: from li-a71a4dcc-35d1-11b2-a85c-951838863c8d.ibm.com.com (unknown [10.72.112.123])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4C08051E3;
        Mon, 25 Sep 2023 05:30:39 +0000 (UTC)
From:   xiubli@redhat.com
To:     ceph-devel@vger.kernel.org
Cc:     idryomov@gmail.com, jlayton@kernel.org, vshankar@redhat.com,
        mchangir@redhat.com, Xiubo Li <xiubli@redhat.com>
Subject: [PATCH 1/3] ceph: do not break the loop if CEPH_I_FLUSH is set
Date:   Mon, 25 Sep 2023 13:28:08 +0800
Message-ID: <20230925052810.21914-2-xiubli@redhat.com>
In-Reply-To: <20230925052810.21914-1-xiubli@redhat.com>
References: <20230925052810.21914-1-xiubli@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: Xiubo Li <xiubli@redhat.com>

For the unlink case we do not want it to be delayed. Else it will
be trigger 5 seconds later. Because the MDS maybe stuck waiting
for cap revocation.

URL: https://tracker.ceph.com/issues/50223
Signed-off-by: Xiubo Li <xiubli@redhat.com>
---
 fs/ceph/caps.c | 19 +++++++++++--------
 1 file changed, 11 insertions(+), 8 deletions(-)

diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
index dc0402258384..efa036e7619f 100644
--- a/fs/ceph/caps.c
+++ b/fs/ceph/caps.c
@@ -4624,7 +4624,7 @@ unsigned long ceph_check_delayed_caps(struct ceph_mds_client *mdsc)
 	struct ceph_inode_info *ci;
 	struct ceph_mount_options *opt = mdsc->fsc->mount_options;
 	unsigned long delay_max = opt->caps_wanted_delay_max * HZ;
-	unsigned long loop_start = jiffies;
+	unsigned long loop_start = jiffies, end;
 	unsigned long delay = 0;
 
 	doutc(cl, "begin\n");
@@ -4633,14 +4633,17 @@ unsigned long ceph_check_delayed_caps(struct ceph_mds_client *mdsc)
 		ci = list_first_entry(&mdsc->cap_delay_list,
 				      struct ceph_inode_info,
 				      i_cap_delay_list);
-		if (time_before(loop_start, ci->i_hold_caps_max - delay_max)) {
-			doutc(cl, "caps added recently.  Exiting loop");
-			delay = ci->i_hold_caps_max;
-			break;
+		/* Do not break the loop if CEPH_I_FLUSH is set. */
+		if (!(ci->i_ceph_flags & CEPH_I_FLUSH)) {
+			end = ci->i_hold_caps_max - delay_max;
+			if (time_before(loop_start, end)) {
+				doutc(cl, "caps added recently.  Exiting loop");
+				delay = ci->i_hold_caps_max;
+				break;
+			}
+			if (time_before(jiffies, ci->i_hold_caps_max))
+				break;
 		}
-		if ((ci->i_ceph_flags & CEPH_I_FLUSH) == 0 &&
-		    time_before(jiffies, ci->i_hold_caps_max))
-			break;
 		list_del_init(&ci->i_cap_delay_list);
 
 		inode = igrab(&ci->netfs.inode);
-- 
2.39.1

