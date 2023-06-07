Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A7A59726434
	for <lists+ceph-devel@lfdr.de>; Wed,  7 Jun 2023 17:22:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241388AbjFGPWY (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 7 Jun 2023 11:22:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241387AbjFGPV6 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 7 Jun 2023 11:21:58 -0400
Received: from smtp-relay-internal-1.canonical.com (smtp-relay-internal-1.canonical.com [185.125.188.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42FEF2137
        for <ceph-devel@vger.kernel.org>; Wed,  7 Jun 2023 08:21:37 -0700 (PDT)
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com [209.85.218.72])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id EAA463F1B1
        for <ceph-devel@vger.kernel.org>; Wed,  7 Jun 2023 15:21:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1686151295;
        bh=Yx9DhBwZ0J2oRahK7SO/c3VRSYe4JEpen4id9pbwqa8=;
        h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
         MIME-Version;
        b=X9R0mgs06C1Gk2+anYw8kNZDpb5tRPWIghtL4PrsomqyLbHxWqU1194+mHRvi7T/k
         Iu0suS19pA22bYmPvt/KPPSi9CKE/R3aDYyGTYfyvOjbmY8SFmGnh/A2oEdx1Mj3Ue
         6UVUMo+JxNYy19cRt/lV6FEfcureUVPiElJay9oCyT6jfS2Di2Mr8N4vJj6cVsbDJd
         2JxtmpSvrXAUS0d2SoWjaqVVacA2thOsSAAUg27AmuMpURk+wywG3GhZvG1s3C0B59
         Y1KDNMuEgi85234LflbxZ5mZ1vR1RMv6kRUTtENu/HKYDbBT797pw3JWmqxU+/AJOk
         9BqRqAwy7KTYw==
Received: by mail-ej1-f72.google.com with SMTP id a640c23a62f3a-977c8170b52so471138166b.0
        for <ceph-devel@vger.kernel.org>; Wed, 07 Jun 2023 08:21:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686151295; x=1688743295;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Yx9DhBwZ0J2oRahK7SO/c3VRSYe4JEpen4id9pbwqa8=;
        b=JCUuyDYSKEAIMSUQ2EsyOS1GZ9q8U8kEVpSIh4XfKPzCWZ0d5BzdlTSlMQ+4Xr1Oep
         S8UBWRuEsMsEuT0mf3GD/geuMPGrLwVpOsKm2JCBpm1+asSgI0E6cl/DusegBNbYqy5z
         +fBR1e4dr1VK2HxhLwixXLCJUjN0qwJtt0/HlwxF/V14aidCTdJtyVmEXQaCPIiqtmmA
         X8qgzp3OPgkHu3yyLI/Lfuu9RF370cXPZUjw6zNZxnfGpYaiD29vm+CBGuUGpryAcYsK
         uPAPlihdoMqPgrt7OaRxjnMIfwR6g0VCtHckxvk6tAMOaX9slbL1sXsS3Zv5iaXMWJSv
         xThg==
X-Gm-Message-State: AC+VfDy3vjvqJR+bSNSLciE2iUNIXVKoZPPmeFVC7PsO106jxlSX5KqA
        cKvRCB7M6gECXNPmjbrYGZcKufy2pITwOyNCpWwUrGzIO7fwUyq3xf2/EeNe0E1C5mgTzO4aRDC
        RmsgYHhlg21Nt/KibcaYreoekA2Cx0sVhDCrJxms=
X-Received: by 2002:a17:907:6e0d:b0:974:c32c:b485 with SMTP id sd13-20020a1709076e0d00b00974c32cb485mr5976945ejc.45.1686151295586;
        Wed, 07 Jun 2023 08:21:35 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ6Gb+vPiTJYMK/PKy7sRlG+qMD2Drcvffo1BNqJTZGhd9gTAGPZVitdUPSJ4nHcuH8eYNfmdA==
X-Received: by 2002:a17:907:6e0d:b0:974:c32c:b485 with SMTP id sd13-20020a1709076e0d00b00974c32cb485mr5976932ejc.45.1686151295416;
        Wed, 07 Jun 2023 08:21:35 -0700 (PDT)
Received: from amikhalitsyn.local (dslb-002-205-064-187.002.205.pools.vodafone-ip.de. [2.205.64.187])
        by smtp.gmail.com with ESMTPSA id w17-20020a056402129100b005147503a238sm6263441edv.17.2023.06.07.08.21.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Jun 2023 08:21:35 -0700 (PDT)
From:   Alexander Mikhalitsyn <aleksandr.mikhalitsyn@canonical.com>
To:     xiubli@redhat.com
Cc:     brauner@kernel.org, stgraber@ubuntu.com,
        linux-fsdevel@vger.kernel.org,
        Christian Brauner <christian.brauner@ubuntu.com>,
        Jeff Layton <jlayton@kernel.org>,
        Ilya Dryomov <idryomov@gmail.com>, ceph-devel@vger.kernel.org,
        Alexander Mikhalitsyn <aleksandr.mikhalitsyn@canonical.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v3 09/14] ceph: allow idmapped permission inode op
Date:   Wed,  7 Jun 2023 17:20:33 +0200
Message-Id: <20230607152038.469739-10-aleksandr.mikhalitsyn@canonical.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230607152038.469739-1-aleksandr.mikhalitsyn@canonical.com>
References: <20230607152038.469739-1-aleksandr.mikhalitsyn@canonical.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: Christian Brauner <christian.brauner@ubuntu.com>

Enable ceph_permission() to handle idmapped mounts. This is just a
matter of passing down the mount's idmapping.

Cc: Xiubo Li <xiubli@redhat.com>
Cc: Jeff Layton <jlayton@kernel.org>
Cc: Ilya Dryomov <idryomov@gmail.com>
Cc: ceph-devel@vger.kernel.org
Signed-off-by: Christian Brauner <christian.brauner@ubuntu.com>
Signed-off-by: Alexander Mikhalitsyn <aleksandr.mikhalitsyn@canonical.com>
---
 fs/ceph/inode.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
index 2e988612ed6c..37e1cbfc7c89 100644
--- a/fs/ceph/inode.c
+++ b/fs/ceph/inode.c
@@ -2408,7 +2408,7 @@ int ceph_permission(struct mnt_idmap *idmap, struct inode *inode,
 	err = ceph_do_getattr(inode, CEPH_CAP_AUTH_SHARED, false);
 
 	if (!err)
-		err = generic_permission(&nop_mnt_idmap, inode, mask);
+		err = generic_permission(idmap, inode, mask);
 	return err;
 }
 
-- 
2.34.1

