Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CA654723443
	for <lists+ceph-devel@lfdr.de>; Tue,  6 Jun 2023 03:00:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233238AbjFFBAt (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 5 Jun 2023 21:00:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233008AbjFFBAs (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 5 Jun 2023 21:00:48 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1242C10B
        for <ceph-devel@vger.kernel.org>; Mon,  5 Jun 2023 18:00:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1686013201;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=bfvPgpwo3DQNkGIY8UrPyzUg+11AXjYQY7oUraqKH64=;
        b=HdqV/0EY3o3t8iNQzqa6nYmOcXOYPP4inet6kqHLcOsMW//mpsE/NY2EAvC6cmxYxGszWz
        BpD2rwa5QerqkfNHRFwfJHwKOrX8SXtGGai4KlbA0u+xP1QK7qtEe3y6ErpcHt8I07z5N6
        XAsYlKt763RezslUw+6PF85oEBuziAk=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-451-WlWjQZqvP_iLvdyyUp6u8w-1; Mon, 05 Jun 2023 20:59:59 -0400
X-MC-Unique: WlWjQZqvP_iLvdyyUp6u8w-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 465C0101A52C;
        Tue,  6 Jun 2023 00:59:59 +0000 (UTC)
Received: from li-a71a4dcc-35d1-11b2-a85c-951838863c8d.ibm.com.com (ovpn-12-128.pek2.redhat.com [10.72.12.128])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 196C549BB98;
        Tue,  6 Jun 2023 00:59:54 +0000 (UTC)
From:   xiubli@redhat.com
To:     idryomov@gmail.com, ceph-devel@vger.kernel.org
Cc:     jlayton@kernel.org, vshankar@redhat.com, mchangir@redhat.com,
        Xiubo Li <xiubli@redhat.com>
Subject: [PATCH v2] ceph: only send metrics when the MDS rank is ready
Date:   Tue,  6 Jun 2023 08:57:32 +0800
Message-Id: <20230606005732.1056361-1-xiubli@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: Xiubo Li <xiubli@redhat.com>

When the MDS rank is in clientreplay state, the metrics requests
will be discarded directly. Also, when there are a lot of known
client requests to recover from, the metrics requests will slow
down the MDS rank from getting to the active state sooner.

With this patch, we will send the metrics requests only when the
MDS rank is in active state.

URL: https://tracker.ceph.com/issues/61524
Reviewed-by: Milind Changire <mchangir@redhat.com>
Signed-off-by: Xiubo Li <xiubli@redhat.com>
---

V2:
- rephrase the commit comment from Milind's comments.


 fs/ceph/metric.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/fs/ceph/metric.c b/fs/ceph/metric.c
index c47347d2e84e..cce78d769f55 100644
--- a/fs/ceph/metric.c
+++ b/fs/ceph/metric.c
@@ -36,6 +36,14 @@ static bool ceph_mdsc_send_metrics(struct ceph_mds_client *mdsc,
 	s32 items = 0;
 	s32 len;
 
+	/* Do not send the metrics until the MDS rank is ready */
+	mutex_lock(&mdsc->mutex);
+	if (ceph_mdsmap_get_state(mdsc->mdsmap, s->s_mds) != CEPH_MDS_STATE_ACTIVE) {
+		mutex_unlock(&mdsc->mutex);
+		return false;
+	}
+	mutex_unlock(&mdsc->mutex);
+
 	len = sizeof(*head) + sizeof(*cap) + sizeof(*read) + sizeof(*write)
 	      + sizeof(*meta) + sizeof(*dlease) + sizeof(*files)
 	      + sizeof(*icaps) + sizeof(*inodes) + sizeof(*rsize)
-- 
2.40.1

