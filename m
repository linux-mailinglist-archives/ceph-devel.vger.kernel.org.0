Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F14C7283F8
	for <lists+ceph-devel@lfdr.de>; Thu,  8 Jun 2023 17:44:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236927AbjFHPoi (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 8 Jun 2023 11:44:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237251AbjFHPoS (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 8 Jun 2023 11:44:18 -0400
Received: from smtp-relay-internal-0.canonical.com (smtp-relay-internal-0.canonical.com [185.125.188.122])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C419030D1
        for <ceph-devel@vger.kernel.org>; Thu,  8 Jun 2023 08:43:53 -0700 (PDT)
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com [209.85.218.69])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-0.canonical.com (Postfix) with ESMTPS id 8F2A93F54C
        for <ceph-devel@vger.kernel.org>; Thu,  8 Jun 2023 15:43:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1686239020;
        bh=Yx9DhBwZ0J2oRahK7SO/c3VRSYe4JEpen4id9pbwqa8=;
        h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
         MIME-Version;
        b=ZIu31rtcGkQaJQ6m9PtMuLdkYLC6zIySosyhSVOSJ0pl+rqf4LqVW+uqeg1HTtLXK
         cZYcxuRpVr0OtPrwelazSrLEB7C45gARG5tmbK830coPyw51A95VZkWkXtOr4PJtke
         KwJGqPwy8ghG3X9WcElAOq9Luj5ozGCb5HcCP3JWH88RmEdFRt0mvIiWnYWsiIjV9n
         xEALX2unNkWe4QGvQ69xSNSDC3YtWIhoYxTxInXUXb0VwI58b+sMh7m0QM//TweMSA
         8YNpeXbKvBHX5lSJF3i7adrccaST0yfdOKhI11cNxAmVHqLZps+UMFctkW1Nifp5KY
         xmfTVzu7nrTyg==
Received: by mail-ej1-f69.google.com with SMTP id a640c23a62f3a-97463348446so100774866b.2
        for <ceph-devel@vger.kernel.org>; Thu, 08 Jun 2023 08:43:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686239016; x=1688831016;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Yx9DhBwZ0J2oRahK7SO/c3VRSYe4JEpen4id9pbwqa8=;
        b=hBBhPXCu/SSQ+SYXG6GgMLSp38Lp5k8z1GD2P5kEQkwsV5amSCZnvhcJI+RQybuC7p
         cnlNV0aRbTTlndOT18NU4Bxw2dzrXOLC8IRnlPbjaAEiC0goXAGifa743FY7zSwPnTYX
         B+DhCHwr1X+rYh810Il8H8PFuaf9SkQvCsOZmwJdUbgVksrzJzge3AX1i6a9qOFLp0Q6
         yjofnTrfhg4uTvuJtYIc0+lbeZlJoQn8oZ0W0n0ikFQhEJI1I6zXmO9WcJV07IJNMvPw
         gKZesvqXLbjBjjfSgUniXChGuSpQKK2oJFzNt7YC+wJRMNLGCJWpAB0TFOwibyK5w+9O
         NsSQ==
X-Gm-Message-State: AC+VfDz90gNN2ENwFVgrC/MUYFIaJfQ9v20z+MX4fBgm2+jrvTMTfWr7
        7Oy7IVoyUI4e/7P/OVuVpyBK89cxmRsMwKbrqugewiiMCtaF0utujFS9IL4g0wpQXvQBiLyfn13
        3IBsQ/8pJvY2maNHwZCwtj43NpPOHkUeNfKAXSqI=
X-Received: by 2002:a17:906:5d14:b0:974:61dc:107c with SMTP id g20-20020a1709065d1400b0097461dc107cmr124321ejt.44.1686239016663;
        Thu, 08 Jun 2023 08:43:36 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ6ne1iCo8Tos3DO3RFYOmA4y/yhsSlWIhQ3oh+fPsJqZlkBw3DxskCMN6/mGkwdL9uWvu/RPA==
X-Received: by 2002:a17:906:5d14:b0:974:61dc:107c with SMTP id g20-20020a1709065d1400b0097461dc107cmr124301ejt.44.1686239016513;
        Thu, 08 Jun 2023 08:43:36 -0700 (PDT)
Received: from amikhalitsyn.local (dslb-002-205-064-187.002.205.pools.vodafone-ip.de. [2.205.64.187])
        by smtp.gmail.com with ESMTPSA id y8-20020aa7c248000000b005164ae1c482sm678387edo.11.2023.06.08.08.43.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Jun 2023 08:43:36 -0700 (PDT)
From:   Alexander Mikhalitsyn <aleksandr.mikhalitsyn@canonical.com>
To:     xiubli@redhat.com
Cc:     brauner@kernel.org, stgraber@ubuntu.com,
        linux-fsdevel@vger.kernel.org, Jeff Layton <jlayton@kernel.org>,
        Ilya Dryomov <idryomov@gmail.com>, ceph-devel@vger.kernel.org,
        Christian Brauner <christian.brauner@ubuntu.com>,
        Alexander Mikhalitsyn <aleksandr.mikhalitsyn@canonical.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v5 06/14] ceph: allow idmapped permission inode op
Date:   Thu,  8 Jun 2023 17:42:47 +0200
Message-Id: <20230608154256.562906-7-aleksandr.mikhalitsyn@canonical.com>
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

