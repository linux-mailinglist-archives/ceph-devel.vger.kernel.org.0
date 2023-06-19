Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EE937734C40
	for <lists+ceph-devel@lfdr.de>; Mon, 19 Jun 2023 09:18:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229503AbjFSHSb (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 19 Jun 2023 03:18:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229478AbjFSHSa (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 19 Jun 2023 03:18:30 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49603E4E
        for <ceph-devel@vger.kernel.org>; Mon, 19 Jun 2023 00:17:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1687159064;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Iu0QIFvh6AY9w7BVEscPsl2WKWMrN62TfYSyX1+0gYo=;
        b=aigzRW6qQ7slxvNY7eE85v+3+/Oc9oCBLVlrfdF96nXfgtn/4tZr7wYqRwCMVkd32t4SOd
        L14BOQWx59oKzlMUku7+0w6EbfsTjpVAoJhE87z/ei5MUJENNYIhMX8mdC7qutNsI8dDh3
        Y3rdAv4KS3DBJ3T52VKtawp7Yi8rZws=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-662-xm6qK2h1Namrfn7_wR-aYg-1; Mon, 19 Jun 2023 03:17:40 -0400
X-MC-Unique: xm6qK2h1Namrfn7_wR-aYg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 70D91858EEC;
        Mon, 19 Jun 2023 07:17:40 +0000 (UTC)
Received: from li-a71a4dcc-35d1-11b2-a85c-951838863c8d.ibm.com.com (ovpn-13-217.pek2.redhat.com [10.72.13.217])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D1D84C1603B;
        Mon, 19 Jun 2023 07:17:35 +0000 (UTC)
From:   xiubli@redhat.com
To:     idryomov@gmail.com, ceph-devel@vger.kernel.org
Cc:     jlayton@kernel.org, vshankar@redhat.com, mchangir@redhat.com,
        Xiubo Li <xiubli@redhat.com>,
        Patrick Donnelly <pdonnell@redhat.com>
Subject: [PATCH v4 4/6] ceph: move mdsmap.h to fs/ceph/
Date:   Mon, 19 Jun 2023 15:14:36 +0800
Message-Id: <20230619071438.7000-5-xiubli@redhat.com>
In-Reply-To: <20230619071438.7000-1-xiubli@redhat.com>
References: <20230619071438.7000-1-xiubli@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: Xiubo Li <xiubli@redhat.com>

The mdsmap.h is only used by the kcephfs and move it to fs/ceph/

URL: https://tracker.ceph.com/issues/61590
Cc: Patrick Donnelly <pdonnell@redhat.com>
Reviewed-by: Patrick Donnelly <pdonnell@redhat.com>
Signed-off-by: Xiubo Li <xiubli@redhat.com>
---
 fs/ceph/mds_client.h                | 2 +-
 fs/ceph/mdsmap.c                    | 2 +-
 {include/linux => fs}/ceph/mdsmap.h | 0
 3 files changed, 2 insertions(+), 2 deletions(-)
 rename {include/linux => fs}/ceph/mdsmap.h (100%)

diff --git a/fs/ceph/mds_client.h b/fs/ceph/mds_client.h
index 20bcf8d5322e..5d02c8c582fd 100644
--- a/fs/ceph/mds_client.h
+++ b/fs/ceph/mds_client.h
@@ -14,9 +14,9 @@
 
 #include <linux/ceph/types.h>
 #include <linux/ceph/messenger.h>
-#include <linux/ceph/mdsmap.h>
 #include <linux/ceph/auth.h>
 
+#include "mdsmap.h"
 #include "metric.h"
 #include "super.h"
 
diff --git a/fs/ceph/mdsmap.c b/fs/ceph/mdsmap.c
index 6cbec7aed5a0..d1bc81eecc18 100644
--- a/fs/ceph/mdsmap.c
+++ b/fs/ceph/mdsmap.c
@@ -7,11 +7,11 @@
 #include <linux/slab.h>
 #include <linux/types.h>
 
-#include <linux/ceph/mdsmap.h>
 #include <linux/ceph/messenger.h>
 #include <linux/ceph/decode.h>
 
 #include "super.h"
+#include "mdsmap.h"
 
 #define CEPH_MDS_IS_READY(i, ignore_laggy) \
 	(m->m_info[i].state > 0 && ignore_laggy ? true : !m->m_info[i].laggy)
diff --git a/include/linux/ceph/mdsmap.h b/fs/ceph/mdsmap.h
similarity index 100%
rename from include/linux/ceph/mdsmap.h
rename to fs/ceph/mdsmap.h
-- 
2.40.1

