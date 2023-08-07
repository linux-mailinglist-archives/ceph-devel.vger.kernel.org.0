Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B0177725C5
	for <lists+ceph-devel@lfdr.de>; Mon,  7 Aug 2023 15:30:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234198AbjHGNax (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 7 Aug 2023 09:30:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234106AbjHGNal (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 7 Aug 2023 09:30:41 -0400
Received: from smtp-relay-internal-0.canonical.com (smtp-relay-internal-0.canonical.com [185.125.188.122])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2BDBB199B
        for <ceph-devel@vger.kernel.org>; Mon,  7 Aug 2023 06:29:46 -0700 (PDT)
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com [209.85.218.72])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-0.canonical.com (Postfix) with ESMTPS id BBF2B44280
        for <ceph-devel@vger.kernel.org>; Mon,  7 Aug 2023 13:28:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1691414913;
        bh=ARhwDsiPa3Ci/G2xteJutduXCGuj42UUR3o8sfJhjpo=;
        h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
         MIME-Version;
        b=tASI92dghztMQQ32j5Aclvvn1dHF17vXAKXK0AYsxbS+rPMsmMjB7wllx9U4vA2LE
         0adXRhYHOADfpGCofTO5CbHdQ8XgrnW3tKftCYM0e6nn4PKNi6sfmdVUZMKIeno9Mi
         xbQvbbBAarTVnJYCwSj84ejTrRIZWgLJBrvSHTXD1p/ZlmXniI7UkN9aISfRJkl/iA
         Mt7BNqrvpes8I+d/tn7Fr3RwJydHuy2VxfBcaMglBrnJt+dqaabPKoWNHAs7Md5uAm
         3zxktNfhfX9T3P/8fiSqoK13xsAIiMGq1QW1n/8sWAl4gNvDLEWufpn3Qe/Czo+vRg
         OWOCltjln2USA==
Received: by mail-ej1-f72.google.com with SMTP id a640c23a62f3a-99beea69484so344973266b.0
        for <ceph-devel@vger.kernel.org>; Mon, 07 Aug 2023 06:28:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691414913; x=1692019713;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ARhwDsiPa3Ci/G2xteJutduXCGuj42UUR3o8sfJhjpo=;
        b=Un8FUudZBdKAOn25fP3Fnl0DghTqidSQS82eQZ5Bx+HA9hgIIpEekaDNARHmULPjKa
         kfR5929zFU421BT1PgYC+MART6WhDBcsUFKwa72VgTXHLDOhZkppijQuaLOn7rA4CwXT
         +bXM5KvPPc/QzPZfmiLs3swHxczWjoqsSPGsjN1+AgG3YSMoLvAccbUknfTIrC33EAxq
         R2x6Z/KQwY4up0m1TSQPEE+H/Hc2/xfQiEW2A8CYJ76NbzWbCKfIX+cwtnijGlBkymAG
         IxvGPf3r/vYrOIuLSy8Xu4vq5axsamS0rWljnojZ/AL9ODiQYtbBJG49Elco3ZcLcwHY
         YJWQ==
X-Gm-Message-State: AOJu0YxcHgt2k38FlV1BhyGCnPhCU1+MJpqNHYpDBNtA0JFAak8dyf+k
        Ai3r8qJIrq/A//FB80FmsHlaK27A0m4K3YmlfmJvoB434onNLFgP0MV6gIywUlc2tIMPJQNKyea
        L8kVvF3nejKyCKPm/QZuQ89xZnOl2lLnlXfxCsyE=
X-Received: by 2002:a17:906:10cc:b0:98e:2097:f23e with SMTP id v12-20020a17090610cc00b0098e2097f23emr7419784ejv.77.1691414913482;
        Mon, 07 Aug 2023 06:28:33 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGltB/ZZoCQVwgCS4UTRIz0u73a/bCvTNvfAJknZZvuyuqC87rnvtadbkCLyDzGWG1RAK7amQ==
X-Received: by 2002:a17:906:10cc:b0:98e:2097:f23e with SMTP id v12-20020a17090610cc00b0098e2097f23emr7419770ejv.77.1691414913267;
        Mon, 07 Aug 2023 06:28:33 -0700 (PDT)
Received: from amikhalitsyn.local (dslb-088-066-182-192.088.066.pools.vodafone-ip.de. [88.66.182.192])
        by smtp.gmail.com with ESMTPSA id lg12-20020a170906f88c00b00992ca779f42sm5175257ejb.97.2023.08.07.06.28.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Aug 2023 06:28:33 -0700 (PDT)
From:   Alexander Mikhalitsyn <aleksandr.mikhalitsyn@canonical.com>
To:     xiubli@redhat.com
Cc:     brauner@kernel.org, stgraber@ubuntu.com,
        linux-fsdevel@vger.kernel.org, Jeff Layton <jlayton@kernel.org>,
        Ilya Dryomov <idryomov@gmail.com>, ceph-devel@vger.kernel.org,
        Alexander Mikhalitsyn <aleksandr.mikhalitsyn@canonical.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v10 10/12] ceph/acl: allow idmapped set_acl inode op
Date:   Mon,  7 Aug 2023 15:26:24 +0200
Message-Id: <20230807132626.182101-11-aleksandr.mikhalitsyn@canonical.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230807132626.182101-1-aleksandr.mikhalitsyn@canonical.com>
References: <20230807132626.182101-1-aleksandr.mikhalitsyn@canonical.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: Christian Brauner <brauner@kernel.org>

Enable ceph_set_acl() to handle idmapped mounts. This is just a matter
of passing down the mount's idmapping.

Cc: Xiubo Li <xiubli@redhat.com>
Cc: Jeff Layton <jlayton@kernel.org>
Cc: Ilya Dryomov <idryomov@gmail.com>
Cc: ceph-devel@vger.kernel.org
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Alexander Mikhalitsyn <aleksandr.mikhalitsyn@canonical.com>
---
 fs/ceph/acl.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ceph/acl.c b/fs/ceph/acl.c
index 89280c168acb..ffc6a1c02388 100644
--- a/fs/ceph/acl.c
+++ b/fs/ceph/acl.c
@@ -107,7 +107,7 @@ int ceph_set_acl(struct mnt_idmap *idmap, struct dentry *dentry,
 	case ACL_TYPE_ACCESS:
 		name = XATTR_NAME_POSIX_ACL_ACCESS;
 		if (acl) {
-			ret = posix_acl_update_mode(&nop_mnt_idmap, inode,
+			ret = posix_acl_update_mode(idmap, inode,
 						    &new_mode, &acl);
 			if (ret)
 				goto out;
-- 
2.34.1

