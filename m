Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 887E272C37B
	for <lists+ceph-devel@lfdr.de>; Mon, 12 Jun 2023 13:52:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234148AbjFLLwZ (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 12 Jun 2023 07:52:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233710AbjFLLwD (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 12 Jun 2023 07:52:03 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D61B3AAC
        for <ceph-devel@vger.kernel.org>; Mon, 12 Jun 2023 04:46:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1686570403;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=24nhNbnZHt6pg+9AG4b4PXbqLGwcBs3GkFIAcUK1X90=;
        b=ihqMKa4Qfy0SRtyNXFGaeoWgF14snlk4Pkv4dBqQq00XF/KP5YOS9NtrkkferBy1u3yXix
        VItk/ErAmh7IvJW0EstSZRMT1yPwAWnavt89KPZszw6A6iUsPlua430hag/xgkdW2oxhft
        qPXFdyNffdwWYRRiTiUSUoZY+nU2Ev0=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-668-gH5wy411NQOeez689BL0Tw-1; Mon, 12 Jun 2023 07:46:40 -0400
X-MC-Unique: gH5wy411NQOeez689BL0Tw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id F38428030D0;
        Mon, 12 Jun 2023 11:46:38 +0000 (UTC)
Received: from li-a71a4dcc-35d1-11b2-a85c-951838863c8d.ibm.com.com (ovpn-12-125.pek2.redhat.com [10.72.12.125])
        by smtp.corp.redhat.com (Postfix) with ESMTP id AD5971121315;
        Mon, 12 Jun 2023 11:46:34 +0000 (UTC)
From:   xiubli@redhat.com
To:     idryomov@gmail.com, ceph-devel@vger.kernel.org
Cc:     jlayton@kernel.org, vshankar@redhat.com, khiremat@redhat.com,
        mchangir@redhat.com, pdonnell@redhat.com,
        Xiubo Li <xiubli@redhat.com>
Subject: [PATCH v2 4/6] ceph: move mdsmap.h to fs/ceph/
Date:   Mon, 12 Jun 2023 19:43:57 +0800
Message-Id: <20230612114359.220895-5-xiubli@redhat.com>
In-Reply-To: <20230612114359.220895-1-xiubli@redhat.com>
References: <20230612114359.220895-1-xiubli@redhat.com>
MIME-Version: 1.0
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

From: Xiubo Li <xiubli@redhat.com>

The mdsmap.h is only used by the kcephfs and move it to fs/ceph/

URL: https://tracker.ceph.com/issues/61590
Cc: Patrick Donnelly <pdonnell@redhat.com>
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

