Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F1F184C8AC6
	for <lists+ceph-devel@lfdr.de>; Tue,  1 Mar 2022 12:31:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234546AbiCALbx (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 1 Mar 2022 06:31:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234545AbiCALbw (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 1 Mar 2022 06:31:52 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id D39D74756B
        for <ceph-devel@vger.kernel.org>; Tue,  1 Mar 2022 03:31:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646134270;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9C1ZCf8TZ57/xy4FPsEYt8M4QOifCwiy9tDGiT2myFE=;
        b=FEQ8zXLX9qxEKf2cUNkeNAGX5FxMjWKwR9JdbNGDOP423qz51ElQXU2ZSJBKlFtnsQf9IH
        Xqzr7UvnA4nQsgfjlT6tFKoqA931CMDw+FHXv3Y/qhkFRfuud9nS8FeCt0A15mCrNehPIj
        4RSFYszjmjQXwCAXAIq9ChM6BshOa0E=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-567-FbwP1oLiPZijmWXCSOn7OQ-1; Tue, 01 Mar 2022 06:31:07 -0500
X-MC-Unique: FbwP1oLiPZijmWXCSOn7OQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D6AFC824FA6;
        Tue,  1 Mar 2022 11:31:05 +0000 (UTC)
Received: from lxbceph1.gsslab.pek2.redhat.com (unknown [10.72.47.117])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4954E83195;
        Tue,  1 Mar 2022 11:30:57 +0000 (UTC)
From:   xiubli@redhat.com
To:     jlayton@kernel.org
Cc:     idryomov@gmail.com, vshankar@redhat.com, lhenriques@suse.de,
        ceph-devel@vger.kernel.org, Xiubo Li <xiubli@redhat.com>
Subject: [PATCH v2 2/7] ceph: skip the memories when received a higher version of message
Date:   Tue,  1 Mar 2022 19:30:10 +0800
Message-Id: <20220301113015.498041-3-xiubli@redhat.com>
In-Reply-To: <20220301113015.498041-1-xiubli@redhat.com>
References: <20220301113015.498041-1-xiubli@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
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
 fs/ceph/mds_client.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
index 94b4c6508044..3dea96df4769 100644
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -326,6 +326,7 @@ static int parse_reply_info_lease(void **p, void *end,
 			goto bad;
 
 		ceph_decode_32_safe(p, end, struct_len, bad);
+		end = *p + struct_len;
 	} else {
 		struct_len = sizeof(**lease);
 		*altname_len = 0;
@@ -346,6 +347,7 @@ static int parse_reply_info_lease(void **p, void *end,
 			*altname = NULL;
 			*altname_len = 0;
 		}
+		*p = end;
 	}
 	return 0;
 bad:
-- 
2.27.0

