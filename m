Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2DEAC7283F3
	for <lists+ceph-devel@lfdr.de>; Thu,  8 Jun 2023 17:44:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237244AbjFHPoR (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 8 Jun 2023 11:44:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237153AbjFHPoK (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 8 Jun 2023 11:44:10 -0400
Received: from smtp-relay-internal-0.canonical.com (smtp-relay-internal-0.canonical.com [185.125.188.122])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FA4D2D73
        for <ceph-devel@vger.kernel.org>; Thu,  8 Jun 2023 08:43:44 -0700 (PDT)
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com [209.85.208.70])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-0.canonical.com (Postfix) with ESMTPS id B259C3F462
        for <ceph-devel@vger.kernel.org>; Thu,  8 Jun 2023 15:43:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1686239015;
        bh=U9FNme5iBEpufhowdmn6D6u4P9E81AUlwyvYSH4GMyo=;
        h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
         MIME-Version;
        b=nXEpBLY25uGlswDTSF7+yXtJxiY9OwrEtmJLmgwjg/Oo59EbJaUOK2vhQSm74loZa
         FCODoM1TQBmmbteEHWTQe9Uz1dPt/LrlOGThyjSmuUnXmmasEHCRSbUzriLZOHg80t
         onJim6o8miaXTgd7HqKRWVDJZgDD0nRQbxCS2kJYcJiBadzy8FVYH9cQRe/eG6Ni1I
         XPricqkktgfX0Wf3Xb44Oj5oNdWXWn2D3j1mjIlh1k8l8sZM3O7iCmgudltqPmC08J
         hF21HTH3zFO7TeKhLgLrH+xkni+D13q9/ayUglCR1i7j8oqoAYCeV8kUHVo67F4kyD
         3TBtVQcuReAtA==
Received: by mail-ed1-f70.google.com with SMTP id 4fb4d7f45d1cf-5128dcbdfc1so758529a12.1
        for <ceph-devel@vger.kernel.org>; Thu, 08 Jun 2023 08:43:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686239013; x=1688831013;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=U9FNme5iBEpufhowdmn6D6u4P9E81AUlwyvYSH4GMyo=;
        b=h0cciUxLN7JCiKuC/KA14NaHwtBZgGw8SHK4yn+aSv/EVo+vgKPWptHyiF8/E/Cw+r
         BhldiXhDREAl79VeXECuKzFQUeS3DIo6O53PHfJ/Rs80tcr4du20U5IAHhoE3Fyk+LAM
         FvGxSLc2cWeciQEe9RpiTubLstebl0cMxRTbUOsxRNxdfUl5wf68IwLleG4TeUwPt0fj
         L2M/lZ2ey4JiDMKk8hj2GHzytVquGycBap9pyIEUwbyQPws6+XYse89cSl76z/la8hgr
         HgTT3qR2Ad1jXYN10sXeIjzBDR34bJ19LI8se9/UuPaUPUfX4XXrDeWVvJDWi6lOJo7Y
         MsRA==
X-Gm-Message-State: AC+VfDztv+q9pboACeGNSfoLm5OdNUpz8QrQCSaALbMA39h67GkgZDE8
        nxWeigJT1EzCnmg//YXhNVo+dhNwWX7xR7ch1gjExiP4pDHijVr0349rln9wC406cR+31cQCgvx
        xIopDN8frrigRIbdMPZDSZ0q/gMyKzUrJeM7fDpw=
X-Received: by 2002:a05:6402:147:b0:514:9c05:819e with SMTP id s7-20020a056402014700b005149c05819emr7681650edu.0.1686239013829;
        Thu, 08 Jun 2023 08:43:33 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ735DyjETywLYDs+jXXCutddOvsHT2twFvkzH160wtul6aVFuOgt/4u3yyoBsAtPQpaf211Jg==
X-Received: by 2002:a05:6402:147:b0:514:9c05:819e with SMTP id s7-20020a056402014700b005149c05819emr7681635edu.0.1686239013667;
        Thu, 08 Jun 2023 08:43:33 -0700 (PDT)
Received: from amikhalitsyn.local (dslb-002-205-064-187.002.205.pools.vodafone-ip.de. [2.205.64.187])
        by smtp.gmail.com with ESMTPSA id y8-20020aa7c248000000b005164ae1c482sm678387edo.11.2023.06.08.08.43.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Jun 2023 08:43:33 -0700 (PDT)
From:   Alexander Mikhalitsyn <aleksandr.mikhalitsyn@canonical.com>
To:     xiubli@redhat.com
Cc:     brauner@kernel.org, stgraber@ubuntu.com,
        linux-fsdevel@vger.kernel.org, Jeff Layton <jlayton@kernel.org>,
        Ilya Dryomov <idryomov@gmail.com>, ceph-devel@vger.kernel.org,
        Christian Brauner <christian.brauner@ubuntu.com>,
        Alexander Mikhalitsyn <aleksandr.mikhalitsyn@canonical.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v5 05/14] ceph: allow idmapped getattr inode op
Date:   Thu,  8 Jun 2023 17:42:46 +0200
Message-Id: <20230608154256.562906-6-aleksandr.mikhalitsyn@canonical.com>
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

