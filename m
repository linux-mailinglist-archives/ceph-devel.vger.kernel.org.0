Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 617924C8E02
	for <lists+ceph-devel@lfdr.de>; Tue,  1 Mar 2022 15:39:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233858AbiCAOk3 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 1 Mar 2022 09:40:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232719AbiCAOk2 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 1 Mar 2022 09:40:28 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id DD636558A
        for <ceph-devel@vger.kernel.org>; Tue,  1 Mar 2022 06:39:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646145584;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=ymwi8w8ML5ROe8FU4MSwr6xhhJlqeCGt1w7TkZcIS0g=;
        b=SQRU56OaetZf342g3XGBbwDKbA5vQciIpuw2zG543HAuPJmMe4ldTWC5N9B8nf5nQ2EUS+
        64q/0BdCka8V+sf/Yf+Buau4HPlSCYG/03HT7Cv0YQLcej0lk27+fkkJkkp1axWUsF12Vk
        r66OM2cBNQj1zqAZioFClna/XKjMvdY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-424-R_NqSa6KMSyHYhCoNj63eQ-1; Tue, 01 Mar 2022 09:39:43 -0500
X-MC-Unique: R_NqSa6KMSyHYhCoNj63eQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6EF571091DA0;
        Tue,  1 Mar 2022 14:39:42 +0000 (UTC)
Received: from lxbceph1.gsslab.pek2.redhat.com (unknown [10.72.47.117])
        by smtp.corp.redhat.com (Postfix) with ESMTP id AA675105913B;
        Tue,  1 Mar 2022 14:39:40 +0000 (UTC)
From:   xiubli@redhat.com
To:     jlayton@kernel.org
Cc:     idryomov@gmail.com, vshankar@redhat.com,
        ceph-devel@vger.kernel.org, Xiubo Li <xiubli@redhat.com>
Subject: [PATCH v3] ceph: skip the memories when received a higher version of message
Date:   Tue,  1 Mar 2022 22:39:27 +0800
Message-Id: <20220301143927.513492-1-xiubli@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: Xiubo Li <xiubli@redhat.com>

We should skip the extra memories which are from the higher version
just likes the libcephfs client does.

URL: https://tracker.ceph.com/issues/54430
Signed-off-by: Xiubo Li <xiubli@redhat.com>
---
 fs/ceph/mds_client.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
index 94b4c6508044..608d077f2eeb 100644
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -313,6 +313,7 @@ static int parse_reply_info_lease(void **p, void *end,
 {
 	u8 struct_v;
 	u32 struct_len;
+	void *lend;
 
 	if (features == (u64)-1) {
 		u8 struct_compat;
@@ -332,6 +333,7 @@ static int parse_reply_info_lease(void **p, void *end,
 		*altname = NULL;
 	}
 
+	lend = *p + struct_len;
 	ceph_decode_need(p, end, struct_len, bad);
 	*lease = *p;
 	*p += sizeof(**lease);
@@ -347,6 +349,7 @@ static int parse_reply_info_lease(void **p, void *end,
 			*altname_len = 0;
 		}
 	}
+	*p = lend;
 	return 0;
 bad:
 	return -EIO;
-- 
2.27.0

