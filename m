Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 23DBA7638A7
	for <lists+ceph-devel@lfdr.de>; Wed, 26 Jul 2023 16:12:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234445AbjGZOMS (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 26 Jul 2023 10:12:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233315AbjGZOLv (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 26 Jul 2023 10:11:51 -0400
Received: from smtp-relay-internal-1.canonical.com (smtp-relay-internal-1.canonical.com [185.125.188.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 999F53C06
        for <ceph-devel@vger.kernel.org>; Wed, 26 Jul 2023 07:11:18 -0700 (PDT)
Received: from mail-lj1-f198.google.com (mail-lj1-f198.google.com [209.85.208.198])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id 765A83F171
        for <ceph-devel@vger.kernel.org>; Wed, 26 Jul 2023 14:10:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1690380648;
        bh=Srcpafr6A4NJGaRIaUNnfkHMnBPsuuDlnOMtOvEnSSA=;
        h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
         MIME-Version;
        b=sDxr2u09nBswQx+rXLQhrISBsA9cu/eZwZmdKxOp+0anlj8bp4J7iDcq9WqX/WTrU
         iafLo+QnD+IB+GQoQeTC8Wm9V2rIJEcoGbRQWGUzHq6EBJS6gZ4iyqhDEkFM/0dcBk
         QeEPsCaQIipc8CQZwrW18R3riDOkb7wc99l6U+tQzhmdqTBQHxXweE0y+hRqKcDUhv
         qxI9xvyqxQIuKr3UGwP61i3i4GYXzVfPgp7Zb+KMPGQ8XdHrb9dQzg4nrRz2/t1X2b
         ZB2AJke8ot+eLaZzmO2W6Ik7B28f9vRPdLSMW4okJe+cAGUOwJNs8OrKrHPn6MazuD
         sZfYSOX0Mjslg==
Received: by mail-lj1-f198.google.com with SMTP id 38308e7fff4ca-2b70bfc97e4so63879941fa.2
        for <ceph-devel@vger.kernel.org>; Wed, 26 Jul 2023 07:10:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690380648; x=1690985448;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Srcpafr6A4NJGaRIaUNnfkHMnBPsuuDlnOMtOvEnSSA=;
        b=Y3zo0rZIFzUr3Sf2C7/S/JHefGtMP9EBWMARSGZyRd744JK2o50PP+FdnNIgmXQ4kq
         zgOWoa7QO3BzTpUgiobcbaV3jLWji937V7BuI7JF2mMxDrY0MpBillElGhK9gk84F+Cj
         7a0AH75HAzfOyIPOirhNv6SE7Py0/KUlSnQPMChh+UaxpUtRUD6OHTh2Egq/1OsGsH05
         ZZhkOGC375kZXQwFGoVX4o7FuYawiOCJKsDISjFiCrIHMk2jA16dFaZANrOa4IuEvQX5
         Fj4bwZ/E6yZzaaKwvNvKaSHj5Q8G/QBUl8OMD1x3UkcEgrab+y3nGLB5DHjTHugosn7A
         0oHg==
X-Gm-Message-State: ABy/qLZlRmjpPoki9/WosYhoIG/5GZ2grUPZ1WKAeuCe0A29mcCPEV1z
        rOPHhm4TPUAY3Huf31qhbm7BCh+bvNLvQWS/w3Z+nC6DNqFPiY4KsDKXqz/mivSy/uI4OVPcioz
        FzrjnF0K1xR39PM+oyO+8svrKHjF7zSXTvyefx68=
X-Received: by 2002:a2e:86d7:0:b0:2b6:a7dd:e22 with SMTP id n23-20020a2e86d7000000b002b6a7dd0e22mr1518816ljj.48.1690380647892;
        Wed, 26 Jul 2023 07:10:47 -0700 (PDT)
X-Google-Smtp-Source: APBJJlGpYu9WEgj2snc3ZtgSt1ExxcGBa/VYSWFcXye2JQbmsYlosKcGQTknjlNkzD2mlntMHE7P5A==
X-Received: by 2002:a2e:86d7:0:b0:2b6:a7dd:e22 with SMTP id n23-20020a2e86d7000000b002b6a7dd0e22mr1518793ljj.48.1690380647707;
        Wed, 26 Jul 2023 07:10:47 -0700 (PDT)
Received: from amikhalitsyn.local (dslb-088-066-182-192.088.066.pools.vodafone-ip.de. [88.66.182.192])
        by smtp.gmail.com with ESMTPSA id k14-20020a7bc30e000000b003fc02219081sm2099714wmj.33.2023.07.26.07.10.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Jul 2023 07:10:47 -0700 (PDT)
From:   Alexander Mikhalitsyn <aleksandr.mikhalitsyn@canonical.com>
To:     xiubli@redhat.com
Cc:     brauner@kernel.org, stgraber@ubuntu.com,
        linux-fsdevel@vger.kernel.org, Jeff Layton <jlayton@kernel.org>,
        Ilya Dryomov <idryomov@gmail.com>, ceph-devel@vger.kernel.org,
        Christian Brauner <christian.brauner@ubuntu.com>,
        Alexander Mikhalitsyn <aleksandr.mikhalitsyn@canonical.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v7 06/11] ceph: allow idmapped permission inode op
Date:   Wed, 26 Jul 2023 16:10:21 +0200
Message-Id: <20230726141026.307690-7-aleksandr.mikhalitsyn@canonical.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230726141026.307690-1-aleksandr.mikhalitsyn@canonical.com>
References: <20230726141026.307690-1-aleksandr.mikhalitsyn@canonical.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
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
index 136b68ccdbef..9b50861bd2b5 100644
--- a/fs/ceph/inode.c
+++ b/fs/ceph/inode.c
@@ -2977,7 +2977,7 @@ int ceph_permission(struct mnt_idmap *idmap, struct inode *inode,
 	err = ceph_do_getattr(inode, CEPH_CAP_AUTH_SHARED, false);
 
 	if (!err)
-		err = generic_permission(&nop_mnt_idmap, inode, mask);
+		err = generic_permission(idmap, inode, mask);
 	return err;
 }
 
-- 
2.34.1

