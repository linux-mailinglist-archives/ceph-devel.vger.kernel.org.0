Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 83474726813
	for <lists+ceph-devel@lfdr.de>; Wed,  7 Jun 2023 20:11:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229742AbjFGSLW (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 7 Jun 2023 14:11:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232663AbjFGSLD (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 7 Jun 2023 14:11:03 -0400
Received: from smtp-relay-internal-1.canonical.com (smtp-relay-internal-1.canonical.com [185.125.188.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2AE082118
        for <ceph-devel@vger.kernel.org>; Wed,  7 Jun 2023 11:10:54 -0700 (PDT)
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com [209.85.208.71])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id BBAFD3F19A
        for <ceph-devel@vger.kernel.org>; Wed,  7 Jun 2023 18:10:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1686161451;
        bh=U9FNme5iBEpufhowdmn6D6u4P9E81AUlwyvYSH4GMyo=;
        h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
         MIME-Version;
        b=Tbzw2iEYOGaykfz+CHs4otX32ABoUa4aOXiNJWE/cvovRCndVcL3wgazA63ztKE3U
         OpFG23mG40xWCvrwVPbNiVlbId705nqEK9i2p/5h6QJvEE////AmyANhkrCwOdB2qt
         1cbgTb9X8+n+gluZOsEAINFc9tvck6Q0kCyjbIstBPq//DsEKU8QuuDqHXNb1pxwYx
         ZgR64KWLHFCvywt4RsqZye06pbfX0kvyaMRzZin028c10Fq9Q9h+oS/MyIbjxxzKFq
         8fZC2sYzwts9lPnwyw7w3uxiVsvSdwybtk7u/dTmjH2mqksCJRqVcRWidb3ZLhWl0D
         Pq1IxEpA7fuSg==
Received: by mail-ed1-f71.google.com with SMTP id 4fb4d7f45d1cf-50daa85e940so1276765a12.0
        for <ceph-devel@vger.kernel.org>; Wed, 07 Jun 2023 11:10:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686161451; x=1688753451;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=U9FNme5iBEpufhowdmn6D6u4P9E81AUlwyvYSH4GMyo=;
        b=aF4pwF5adFqTtTq908jptOvCw++rKgrJ3jveUxKetoo1p0dafG4pFtir3i06CHrYXP
         8F+xGJXpQg1U7Z/JWAqgHYXRkmMDDlFuYWlKb8H/lwkbu5XDmmQsGQJLMhP7kEvzIsDh
         m+ypkmV/nvXjaSmGNbaIjZ2APWCsSI1o0O25nrpmTfqH1U78mVcQ9xVvUKDItEYKdtyR
         daiCQ1zar01hH90gHymcXA/0+G3xk67BS9dbSajwEkroM2FJ0Pi2OYV4yeEGbG6loaRT
         JEfGO7Hg05Un/MSvCwmWrY8DJ/oiTxJzRD/WrsbrkOQ1VxMt6swTwE5gIjSmj/xGlouT
         ej5w==
X-Gm-Message-State: AC+VfDxUi2KsBfnfUstAbsjwBX80rmVVxHyFHm1oOcR3PBBrh6d51GKa
        y0ED3KbeSIIx40i4JefZMnxChRzHb/IKaDMXOSfTxAGThfQFHTxPYTVW2LtpcmvpsNCQXz743mQ
        wHbDkMa4gJSCVQVtOX7pf0fdw73lGpyeHbJcZktc=
X-Received: by 2002:a17:906:6a16:b0:96f:9963:81ee with SMTP id qw22-20020a1709066a1600b0096f996381eemr7607929ejc.50.1686161451087;
        Wed, 07 Jun 2023 11:10:51 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ7l7SHHgw+BU8rxXq08zQ4nhoIK2xRQlwDq8P8dpBDsOnwGZn+4CtqqsfCxYAnOQGLg07QwYA==
X-Received: by 2002:a17:906:6a16:b0:96f:9963:81ee with SMTP id qw22-20020a1709066a1600b0096f996381eemr7607913ejc.50.1686161450893;
        Wed, 07 Jun 2023 11:10:50 -0700 (PDT)
Received: from amikhalitsyn.local (dslb-002-205-064-187.002.205.pools.vodafone-ip.de. [2.205.64.187])
        by smtp.gmail.com with ESMTPSA id oz17-20020a170906cd1100b009745edfb7cbsm7170494ejb.45.2023.06.07.11.10.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Jun 2023 11:10:50 -0700 (PDT)
From:   Alexander Mikhalitsyn <aleksandr.mikhalitsyn@canonical.com>
To:     xiubli@redhat.com
Cc:     brauner@kernel.org, stgraber@ubuntu.com,
        linux-fsdevel@vger.kernel.org,
        Christian Brauner <christian.brauner@ubuntu.com>,
        Jeff Layton <jlayton@kernel.org>,
        Ilya Dryomov <idryomov@gmail.com>, ceph-devel@vger.kernel.org,
        Alexander Mikhalitsyn <aleksandr.mikhalitsyn@canonical.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v4 08/14] ceph: allow idmapped getattr inode op
Date:   Wed,  7 Jun 2023 20:09:51 +0200
Message-Id: <20230607180958.645115-9-aleksandr.mikhalitsyn@canonical.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230607180958.645115-1-aleksandr.mikhalitsyn@canonical.com>
References: <20230607180958.645115-1-aleksandr.mikhalitsyn@canonical.com>
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

Enable ceph_getattr() to handle idmapped mounts. This is just a matter
of passing down the mount's idmapping.

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
index 8e5f41d45283..2e988612ed6c 100644
--- a/fs/ceph/inode.c
+++ b/fs/ceph/inode.c
@@ -2465,7 +2465,7 @@ int ceph_getattr(struct mnt_idmap *idmap, const struct path *path,
 			return err;
 	}
 
-	generic_fillattr(&nop_mnt_idmap, inode, stat);
+	generic_fillattr(idmap, inode, stat);
 	stat->ino = ceph_present_inode(inode);
 
 	/*
-- 
2.34.1

