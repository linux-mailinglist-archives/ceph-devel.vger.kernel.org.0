Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 33C2C76FC7B
	for <lists+ceph-devel@lfdr.de>; Fri,  4 Aug 2023 10:50:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229821AbjHDIuQ (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 4 Aug 2023 04:50:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229738AbjHDIti (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Fri, 4 Aug 2023 04:49:38 -0400
Received: from smtp-relay-internal-0.canonical.com (smtp-relay-internal-0.canonical.com [185.125.188.122])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 325314C0E
        for <ceph-devel@vger.kernel.org>; Fri,  4 Aug 2023 01:49:35 -0700 (PDT)
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com [209.85.218.69])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-0.canonical.com (Postfix) with ESMTPS id A555A44273
        for <ceph-devel@vger.kernel.org>; Fri,  4 Aug 2023 08:49:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1691138972;
        bh=StxqveXF5moq9iJU4D0IjENKfN6jaIfCw60woBc2a1E=;
        h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
         MIME-Version;
        b=dV95e+C6a8+U9YNmwYyII74LQQbMgCqRI2qE7d4jbZ8XgNEPoftl2N8GyUbCXIBdv
         gJ79USRnE/uMQtTg+//vj1HJ7ACh6h5wsiQrls2ehb6TZdxLyu4SZGZoO+UALGGIg1
         oCQSAmBBtE/dRBAKqwtT9AxXKak6L4cv/ne1OGOvYFPMaiwaG435V0UP/ySBvwcmYw
         26aTldcnxGaOoGb2O2Omk5P2h0tSDAgnfb26lgV9FG8SrbW0J8Zg99CA4A22MBlq7F
         3Sbd/wGrhewOcfM9yifdT60aHednsSDpzb8bTV8c0B1DuOmZ6szcyPJsOzM1zPS8GZ
         88hlgEj6ij2jg==
Received: by mail-ej1-f69.google.com with SMTP id a640c23a62f3a-99c8bbc902eso58343766b.1
        for <ceph-devel@vger.kernel.org>; Fri, 04 Aug 2023 01:49:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691138972; x=1691743772;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=StxqveXF5moq9iJU4D0IjENKfN6jaIfCw60woBc2a1E=;
        b=C61JVAQBm4+GWljy0N6zXjZgN52KkjVnB1cS5Gltmt7AClCRgGZoC00JQ5lUZNY3Bz
         hGqyKVQ75SGvW4luOLwHqt9Xb70tw1lXkpXlICfNYeGj/ixpCWn3/WPoORkBdGYDOjbg
         m6cs4fszY5Oo09Hfm4jzliqkb48rdFzs6gbdWGERV2awfbLhgqy+z85NnbIUmrPINGrY
         TTyge/L7cSgi3tfdC1PdfhZYEiRu81PD+fSzMGpXuTS3b5Zutkc7qJyC9nyYkrHL2NMC
         pmtZsIH1ySl2K2iV6eVFBP/FxqPDWrMhCVDmYCc2z80LJE2DplcI/j/8C8anx+Lnc977
         +z9A==
X-Gm-Message-State: AOJu0YzQqccJIi9pzn075OisjwadPHoN8NrqmVa0eDi7eN+lkMIGB5MQ
        GbYrwriIi0HqVTcTcj6Y5PM4YLi4TzC3Poqn1FGuEGbOftSK/cCvnoucJkZAhR/Miq92OOKGobe
        6MBujUG+o2AJ9X5e0Zq0MfpZHwR8evLsbVYAutw8=
X-Received: by 2002:a17:907:2c4d:b0:99b:bf8d:b7e1 with SMTP id hf13-20020a1709072c4d00b0099bbf8db7e1mr863830ejc.17.1691138971899;
        Fri, 04 Aug 2023 01:49:31 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHt0cJxyxNVN8MFBPcovFv21DNeI/vcPblkJxrD4B89INifTjeigoUO/zvfSlO7YIYpAZQAKA==
X-Received: by 2002:a17:907:2c4d:b0:99b:bf8d:b7e1 with SMTP id hf13-20020a1709072c4d00b0099bbf8db7e1mr863822ejc.17.1691138971748;
        Fri, 04 Aug 2023 01:49:31 -0700 (PDT)
Received: from amikhalitsyn.local (dslb-088-066-182-192.088.066.pools.vodafone-ip.de. [88.66.182.192])
        by smtp.gmail.com with ESMTPSA id k25-20020a17090646d900b00992e94bcfabsm979279ejs.167.2023.08.04.01.49.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Aug 2023 01:49:31 -0700 (PDT)
From:   Alexander Mikhalitsyn <aleksandr.mikhalitsyn@canonical.com>
To:     xiubli@redhat.com
Cc:     brauner@kernel.org, stgraber@ubuntu.com,
        linux-fsdevel@vger.kernel.org, Jeff Layton <jlayton@kernel.org>,
        Ilya Dryomov <idryomov@gmail.com>, ceph-devel@vger.kernel.org,
        Alexander Mikhalitsyn <aleksandr.mikhalitsyn@canonical.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v9 02/12] ceph: stash idmapping in mdsc request
Date:   Fri,  4 Aug 2023 10:48:48 +0200
Message-Id: <20230804084858.126104-3-aleksandr.mikhalitsyn@canonical.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230804084858.126104-1-aleksandr.mikhalitsyn@canonical.com>
References: <20230804084858.126104-1-aleksandr.mikhalitsyn@canonical.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: Christian Brauner <brauner@kernel.org>

When sending a mds request cephfs will send relevant data for the
requested operation. For creation requests the caller's fs{g,u}id is
used to set the ownership of the newly created filesystem object. For
setattr requests the caller can pass in arbitrary {g,u}id values to
which the relevant filesystem object is supposed to be changed.

If the caller is performing the relevant operation via an idmapped mount
cephfs simply needs to take the idmapping into account when it sends the
relevant mds request.

In order to support idmapped mounts for cephfs we stash the idmapping
whenever they are relevant for the operation for the duration of the
request. Since mds requests can be queued and performed asynchronously
we make sure to keep the idmapping around and release it once the
request has finished.

In follow-up patches we will use this to send correct ownership
information over the wire. This patch just adds the basic infrastructure
to keep the idmapping around. The actual conversion patches are all
fairly minimal.

Cc: Xiubo Li <xiubli@redhat.com>
Cc: Jeff Layton <jlayton@kernel.org>
Cc: Ilya Dryomov <idryomov@gmail.com>
Cc: ceph-devel@vger.kernel.org
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Alexander Mikhalitsyn <aleksandr.mikhalitsyn@canonical.com>
---
v4:
	- don't call mnt_idmap_get(..) in __register_request
---
 fs/ceph/mds_client.c | 5 +++++
 fs/ceph/mds_client.h | 1 +
 2 files changed, 6 insertions(+)

diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
index 9aae39289b43..8829f55103da 100644
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -12,6 +12,7 @@
 #include <linux/bits.h>
 #include <linux/ktime.h>
 #include <linux/bitmap.h>
+#include <linux/mnt_idmapping.h>
 
 #include "super.h"
 #include "crypto.h"
@@ -1121,6 +1122,8 @@ void ceph_mdsc_release_request(struct kref *kref)
 	kfree(req->r_path1);
 	kfree(req->r_path2);
 	put_cred(req->r_cred);
+	if (req->r_mnt_idmap)
+		mnt_idmap_put(req->r_mnt_idmap);
 	if (req->r_pagelist)
 		ceph_pagelist_release(req->r_pagelist);
 	kfree(req->r_fscrypt_auth);
@@ -1180,6 +1183,8 @@ static void __register_request(struct ceph_mds_client *mdsc,
 	insert_request(&mdsc->request_tree, req);
 
 	req->r_cred = get_current_cred();
+	if (!req->r_mnt_idmap)
+		req->r_mnt_idmap = &nop_mnt_idmap;
 
 	if (mdsc->oldest_tid == 0 && req->r_op != CEPH_MDS_OP_SETFILELOCK)
 		mdsc->oldest_tid = req->r_tid;
diff --git a/fs/ceph/mds_client.h b/fs/ceph/mds_client.h
index 717a7399bacb..e3bbf3ba8ee8 100644
--- a/fs/ceph/mds_client.h
+++ b/fs/ceph/mds_client.h
@@ -300,6 +300,7 @@ struct ceph_mds_request {
 	int r_fmode;        /* file mode, if expecting cap */
 	int r_request_release_offset;
 	const struct cred *r_cred;
+	struct mnt_idmap *r_mnt_idmap;
 	struct timespec64 r_stamp;
 
 	/* for choosing which mds to send this request to */
-- 
2.34.1

