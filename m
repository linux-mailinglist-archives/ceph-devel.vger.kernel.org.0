Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7AB65717D8B
	for <lists+ceph-devel@lfdr.de>; Wed, 31 May 2023 13:03:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233199AbjEaLDx (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 31 May 2023 07:03:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234808AbjEaLDY (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 31 May 2023 07:03:24 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86D42135
        for <ceph-devel@vger.kernel.org>; Wed, 31 May 2023 04:02:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1685530946;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=K3Fe41fcV9/oQHF+5yTJ7VJpeT4qI3fhV/hFm2MZeYY=;
        b=bhV8oA+XNVGjpx9Ifv8Zn/iGbMhnwq/UTZpciqnq9JmBEH5ugDoQtBcLFdgVDeIcOXZBGK
        x6rosiml/TcCuglSZshtkARwP0DhTMgeZT1cFJllHDu9lrkHu4iCnztAXna9jpP2dbkUz8
        8T45Cjx4sMsWYecQw8kctKFUZTu6QHU=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-622-CS1Let1nMJeb5hqIf2PqGQ-1; Wed, 31 May 2023 07:02:20 -0400
X-MC-Unique: CS1Let1nMJeb5hqIf2PqGQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 93E9A811E8E;
        Wed, 31 May 2023 11:02:20 +0000 (UTC)
Received: from li-a71a4dcc-35d1-11b2-a85c-951838863c8d.ibm.com.com (ovpn-12-188.pek2.redhat.com [10.72.12.188])
        by smtp.corp.redhat.com (Postfix) with ESMTP id AD6A1140E963;
        Wed, 31 May 2023 11:02:15 +0000 (UTC)
From:   xiubli@redhat.com
To:     idryomov@gmail.com, ceph-devel@vger.kernel.org
Cc:     jlayton@kernel.org, vshankar@redhat.com, mchangir@redhat.com,
        Xiubo Li <xiubli@redhat.com>
Subject: [PATCH] ceph: only send metrics when the MDS rank is ready
Date:   Wed, 31 May 2023 19:02:01 +0800
Message-Id: <20230531110201.826061-1-xiubli@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: Xiubo Li <xiubli@redhat.com>

When the MDS rank is in clientreplay state these metrics requests
will be discard directly. Especially when there are a lot of known
client requests need to replay these useless metrics requests will
slow down the MDS rank.

With this we will send the metrics requests only when the MDS rank
is in active state.

URL: https://tracker.ceph.com/issues/61524
Signed-off-by: Xiubo Li <xiubli@redhat.com>
---
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

