Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B1FDF7283E7
	for <lists+ceph-devel@lfdr.de>; Thu,  8 Jun 2023 17:43:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237129AbjFHPnc (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 8 Jun 2023 11:43:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237142AbjFHPnb (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 8 Jun 2023 11:43:31 -0400
Received: from smtp-relay-internal-1.canonical.com (smtp-relay-internal-1.canonical.com [185.125.188.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16D0426B2
        for <ceph-devel@vger.kernel.org>; Thu,  8 Jun 2023 08:43:28 -0700 (PDT)
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com [209.85.208.69])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id CDCA23F33C
        for <ceph-devel@vger.kernel.org>; Thu,  8 Jun 2023 15:43:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1686239005;
        bh=PnimYtsU8L1wziru+PbLo9AAv92Qytxkfm0LOSGrer8=;
        h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
         MIME-Version;
        b=CvTapLYwYU6+j2zGj0+69m+ot7YodTRJ+5pzKEZRV6XeT1aosffwoPehZ02vcDQRA
         RML6lROgrl1CU6yaW2asSOLM1CElbiwc6P2OvnAzbejPVlHzTkqa8edhXJ3rzX8Xsu
         tHkNhB6+IqH+W7qYuYtThZ+Cv0+WS8bl/JW3yxhqwCTo2B8a/NgyoR+EjhtriadnoQ
         NmhrJpGM/hoM41o/0a5HCLaqHhyf7MIuRWG9yVne+/dFxP3/cKZoXF3DEvvTMeQJlA
         7fYCXSvQWrb9IZKTHUKfeb+OYtZpIC7nO4g3hKR4vyxUI5t4QQQrv20/cDEeIfv5I6
         AalCJMAJiDdSw==
Received: by mail-ed1-f69.google.com with SMTP id 4fb4d7f45d1cf-506b21104faso766572a12.1
        for <ceph-devel@vger.kernel.org>; Thu, 08 Jun 2023 08:43:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686239005; x=1688831005;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=PnimYtsU8L1wziru+PbLo9AAv92Qytxkfm0LOSGrer8=;
        b=ZKxoBEH/VuxAEzNY+VJ5ydmqy3AtkGwMTD+yo0GBH2DEJ7T6B3vieVb/cPU2Ym8qRt
         7rGH/qaH4foOtivNAeGn1KCVX7M1rl5rNUVfVnMesGUwBs/FH+XT0i61mol2nk9mSkFC
         JR5fXdiD5n8yT+dko/XueBRcr/DGsObQAQys3bGdJCZxdL3LAU72aLw/sBlsNmA42g0D
         Sk5JdjTBaNkucIs1ckfnoRK/KJbMHmBWIswDsseN7c0HQ550wEloXfpDswqnIr4oRNrW
         vVsuBPpNf4liKczHuaxh5RGlhPE9yuEcOjpl/SGLcv8MmRxYu4M/v17SIRYYCDT/Anba
         VpDA==
X-Gm-Message-State: AC+VfDyvObrTESmXz55FkcU8U2kb0NKZUpU1i7vHF6eUFyoyecDly9zM
        UHKfBYjxHy7ow8/3pWbkrLwqJ0T7F02oVKnq9i5ER4aAT5TeABGwQyNR2hkDnJHCAZczLgRZKNU
        UCHE7AEtqvLCl2MLb2Yh3nRotLlpK/7SsZNTAUrMNee4J/v8=
X-Received: by 2002:aa7:c30c:0:b0:514:9e61:e7b8 with SMTP id l12-20020aa7c30c000000b005149e61e7b8mr6336301edq.40.1686239005206;
        Thu, 08 Jun 2023 08:43:25 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ428Ky4b2SF1PG2wMyWsEazOGW/rlbctHmYfe0//BeE4mQV4gnb+YnP44CwXFQOVf1dkIVDfA==
X-Received: by 2002:aa7:c30c:0:b0:514:9e61:e7b8 with SMTP id l12-20020aa7c30c000000b005149e61e7b8mr6336286edq.40.1686239005041;
        Thu, 08 Jun 2023 08:43:25 -0700 (PDT)
Received: from amikhalitsyn.local (dslb-002-205-064-187.002.205.pools.vodafone-ip.de. [2.205.64.187])
        by smtp.gmail.com with ESMTPSA id y8-20020aa7c248000000b005164ae1c482sm678387edo.11.2023.06.08.08.43.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Jun 2023 08:43:24 -0700 (PDT)
From:   Alexander Mikhalitsyn <aleksandr.mikhalitsyn@canonical.com>
To:     xiubli@redhat.com
Cc:     brauner@kernel.org, stgraber@ubuntu.com,
        linux-fsdevel@vger.kernel.org, Jeff Layton <jlayton@kernel.org>,
        Ilya Dryomov <idryomov@gmail.com>, ceph-devel@vger.kernel.org,
        Christian Brauner <christian.brauner@ubuntu.com>,
        Alexander Mikhalitsyn <aleksandr.mikhalitsyn@canonical.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v5 02/14] ceph: stash idmapping in mdsc request
Date:   Thu,  8 Jun 2023 17:42:43 +0200
Message-Id: <20230608154256.562906-3-aleksandr.mikhalitsyn@canonical.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230608154256.562906-1-aleksandr.mikhalitsyn@canonical.com>
References: <20230608154256.562906-1-aleksandr.mikhalitsyn@canonical.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
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

Cc: Xiubo Li <xiubli@redhat.com>
Cc: Jeff Layton <jlayton@kernel.org>
Cc: Ilya Dryomov <idryomov@gmail.com>
Cc: ceph-devel@vger.kernel.org
Signed-off-by: Christian Brauner <christian.brauner@ubuntu.com>
Signed-off-by: Alexander Mikhalitsyn <aleksandr.mikhalitsyn@canonical.com>
---
v4:
	- don't call mnt_idmap_get(..) in __register_request
---
 fs/ceph/mds_client.c | 5 +++++
 fs/ceph/mds_client.h | 1 +
 2 files changed, 6 insertions(+)

diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
index 4c0f22acf53d..05a99a8eb292 100644
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
+	if (req->r_mnt_idmap)
+		mnt_idmap_put(req->r_mnt_idmap);
 	if (req->r_pagelist)
 		ceph_pagelist_release(req->r_pagelist);
 	put_request_session(req);
@@ -1018,6 +1021,8 @@ static void __register_request(struct ceph_mds_client *mdsc,
 	insert_request(&mdsc->request_tree, req);
 
 	req->r_cred = get_current_cred();
+	if (!req->r_mnt_idmap)
+		req->r_mnt_idmap = &nop_mnt_idmap;
 
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

