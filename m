Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E97C370FA4E
	for <lists+ceph-devel@lfdr.de>; Wed, 24 May 2023 17:35:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236619AbjEXPfJ (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 24 May 2023 11:35:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236308AbjEXPfB (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 24 May 2023 11:35:01 -0400
Received: from smtp-relay-internal-0.canonical.com (smtp-relay-internal-0.canonical.com [185.125.188.122])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1680FE43
        for <ceph-devel@vger.kernel.org>; Wed, 24 May 2023 08:34:43 -0700 (PDT)
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com [209.85.218.72])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-0.canonical.com (Postfix) with ESMTPS id F116D3F235
        for <ceph-devel@vger.kernel.org>; Wed, 24 May 2023 15:33:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1684942435;
        bh=XgKnpq4bIvhR7eBTR7Q+NdjpFwn1XJ2nSq/DTgjo3dY=;
        h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
         MIME-Version;
        b=ZTpzhbY38OV8QVISl9OcxFMQ7ML1kqinI9MnsOr1aJ07v1DqQAdstoYAEnv988FWa
         ZFrTA0XOYOCQQsYbcIYs+ld1iA2vx4DkTa69yj7wawcVyHU5IvcWh21Jpz4ISSt6gr
         g5Wy3vSBoGbWolsYr7s0CCEwgsF1iVxh5zQ54PvLSzRR0uuqwXOD079YYEMIgDWh9c
         jlAI5GyyL4szARH2NxEGIZ0S1K6iLGPnnJA54ou6sKthqSLapBLh8To4OzVTX/cMt5
         KewaViTs4smF/J6FGTZy+xJtA1a2/oGHNM0Cd1+yo/+bSp5B5tx83X9mI3kwlNfnfE
         68rjMxpguRWbA==
Received: by mail-ej1-f72.google.com with SMTP id a640c23a62f3a-96fae2a13a5so103817866b.2
        for <ceph-devel@vger.kernel.org>; Wed, 24 May 2023 08:33:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684942434; x=1687534434;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XgKnpq4bIvhR7eBTR7Q+NdjpFwn1XJ2nSq/DTgjo3dY=;
        b=R5E8GuNZ590WVsw8F9pxD3b0PQ9n3sAePYRk1/za4jZpuvbGNlRuEiUf7RzBpEDXcZ
         OACLaruwggc0Gj7vbHiOVDU7Z1OpK9cWQRPNBbSANv6LN90Im1GyiMT0a0E73zjvm2Oz
         6WYTnfsUXhRleZVdOOYEv8J8lh+sGDOyWmX+QUNyjfzQWGJkuNHWF+tuOl5TKpn4lood
         qIbAGTzROgFzcdNBSY0vECIzo6tLBoelPob3IRWnGWiR0pmP8QTMZzt3oXFHh/lz3t8P
         pR404hI4qDHtGL5Er9OFgs5rgke5Wed/pdiJrECfdfUQ2VS3CwsN0q++wFn0zDSPQ8++
         7TcA==
X-Gm-Message-State: AC+VfDxNgoWCRBgQ5jyOSULAys6rq4g6u3BB6361Y+ZkTECWTM/KRIrf
        DmFCBBwkyvrgi3AE+OgY4RqvVqyiwwfGAt/wUcOLDmiItftN/Zb2wd6Q1IsdCu8wRTagI2pZ0PZ
        DLX9hYfQV8JQ43+b2ZTwlxE5EZyUMBQDBAASUIas=
X-Received: by 2002:a17:907:7f8c:b0:96a:5e38:ba49 with SMTP id qk12-20020a1709077f8c00b0096a5e38ba49mr19196158ejc.2.1684942434314;
        Wed, 24 May 2023 08:33:54 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ6Mffvochh5YQEn/DHlzCnAsBqpPKJ0HvpBj7yTSc8OSsGh1dOxxL29MY1dSL/HnDP8qeW35A==
X-Received: by 2002:a17:907:7f8c:b0:96a:5e38:ba49 with SMTP id qk12-20020a1709077f8c00b0096a5e38ba49mr19196142ejc.2.1684942434005;
        Wed, 24 May 2023 08:33:54 -0700 (PDT)
Received: from amikhalitsyn.local (dslb-088-074-206-207.088.074.pools.vodafone-ip.de. [88.74.206.207])
        by smtp.gmail.com with ESMTPSA id p26-20020a17090664da00b0096f7105b3a6sm5986979ejn.189.2023.05.24.08.33.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 May 2023 08:33:53 -0700 (PDT)
From:   Alexander Mikhalitsyn <aleksandr.mikhalitsyn@canonical.com>
To:     xiubli@redhat.com
Cc:     brauner@kernel.org, stgraber@ubuntu.com,
        linux-fsdevel@vger.kernel.org,
        Christian Brauner <christian.brauner@ubuntu.com>,
        Jeff Layton <jlayton@kernel.org>,
        Ilya Dryomov <idryomov@gmail.com>, ceph-devel@vger.kernel.org,
        Alexander Mikhalitsyn <aleksandr.mikhalitsyn@canonical.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 02/13] ceph: stash idmapping in mdsc request
Date:   Wed, 24 May 2023 17:33:04 +0200
Message-Id: <20230524153316.476973-3-aleksandr.mikhalitsyn@canonical.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230524153316.476973-1-aleksandr.mikhalitsyn@canonical.com>
References: <20230524153316.476973-1-aleksandr.mikhalitsyn@canonical.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: Christian Brauner <christian.brauner@ubuntu.com>

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

Cc: Jeff Layton <jlayton@kernel.org>
Cc: Ilya Dryomov <idryomov@gmail.com>
Cc: ceph-devel@vger.kernel.org
Signed-off-by: Christian Brauner <christian.brauner@ubuntu.com>
Signed-off-by: Alexander Mikhalitsyn <aleksandr.mikhalitsyn@canonical.com>
---
v2:
	- added "r_" prefix to the field name to make it consistent with others
---
 fs/ceph/mds_client.c | 7 +++++++
 fs/ceph/mds_client.h | 1 +
 2 files changed, 8 insertions(+)

diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
index 4c0f22acf53d..810c3db2e369 100644
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -12,6 +12,7 @@
 #include <linux/bits.h>
 #include <linux/ktime.h>
 #include <linux/bitmap.h>
+#include <linux/mnt_idmapping.h>
 
 #include "super.h"
 #include "mds_client.h"
@@ -962,6 +963,8 @@ void ceph_mdsc_release_request(struct kref *kref)
 	kfree(req->r_path1);
 	kfree(req->r_path2);
 	put_cred(req->r_cred);
+	if (req->r_mnt_idmap != &nop_mnt_idmap)
+		mnt_idmap_put(req->r_mnt_idmap);
 	if (req->r_pagelist)
 		ceph_pagelist_release(req->r_pagelist);
 	put_request_session(req);
@@ -1018,6 +1021,10 @@ static void __register_request(struct ceph_mds_client *mdsc,
 	insert_request(&mdsc->request_tree, req);
 
 	req->r_cred = get_current_cred();
+	if (!req->r_mnt_idmap)
+		req->r_mnt_idmap = &nop_mnt_idmap;
+	else
+		mnt_idmap_get(req->r_mnt_idmap);
 
 	if (mdsc->oldest_tid == 0 && req->r_op != CEPH_MDS_OP_SETFILELOCK)
 		mdsc->oldest_tid = req->r_tid;
diff --git a/fs/ceph/mds_client.h b/fs/ceph/mds_client.h
index 724307ff89cd..32001ade1ea7 100644
--- a/fs/ceph/mds_client.h
+++ b/fs/ceph/mds_client.h
@@ -280,6 +280,7 @@ struct ceph_mds_request {
 	int r_fmode;        /* file mode, if expecting cap */
 	int r_request_release_offset;
 	const struct cred *r_cred;
+	struct mnt_idmap *r_mnt_idmap;
 	struct timespec64 r_stamp;
 
 	/* for choosing which mds to send this request to */
-- 
2.34.1

