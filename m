Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5FB7372F1FF
	for <lists+ceph-devel@lfdr.de>; Wed, 14 Jun 2023 03:34:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233375AbjFNBeP (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 13 Jun 2023 21:34:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234588AbjFNBeN (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 13 Jun 2023 21:34:13 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CC0010D5
        for <ceph-devel@vger.kernel.org>; Tue, 13 Jun 2023 18:33:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1686706404;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Iu0QIFvh6AY9w7BVEscPsl2WKWMrN62TfYSyX1+0gYo=;
        b=cujI9NFQjaFmJh9+hsBm+EUezQbYnIragRDTbF03Ak1aJ9jASwc+/Jo2DLNJqb/qgnmFDU
        5isY1y+pVf8MPXACwygMzDx4LYlq3r2Z7b6+alChy9rJ4hFIVQntzlZyDjtUQGnmvBZi3s
        Of6mxurVB/bBbccCnIJ93HVjN8uUUHc=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-26-aQzF1a9NPBOYk6KSnQhkxQ-1; Tue, 13 Jun 2023 21:33:21 -0400
X-MC-Unique: aQzF1a9NPBOYk6KSnQhkxQ-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E44653806729;
        Wed, 14 Jun 2023 01:33:20 +0000 (UTC)
Received: from li-a71a4dcc-35d1-11b2-a85c-951838863c8d.ibm.com.com (ovpn-12-155.pek2.redhat.com [10.72.12.155])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 90C02492CA6;
        Wed, 14 Jun 2023 01:33:11 +0000 (UTC)
From:   xiubli@redhat.com
To:     idryomov@gmail.com, ceph-devel@vger.kernel.org
Cc:     jlayton@kernel.org, vshankar@redhat.com, mchangir@redhat.com,
        khiremat@redhat.com, pdonnell@redhat.com,
        Xiubo Li <xiubli@redhat.com>
Subject: [PATCH v3 4/6] ceph: move mdsmap.h to fs/ceph/
Date:   Wed, 14 Jun 2023 09:30:23 +0800
Message-Id: <20230614013025.291314-5-xiubli@redhat.com>
In-Reply-To: <20230614013025.291314-1-xiubli@redhat.com>
References: <20230614013025.291314-1-xiubli@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
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

