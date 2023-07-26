Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A75C7638A8
	for <lists+ceph-devel@lfdr.de>; Wed, 26 Jul 2023 16:12:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233176AbjGZOMR (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 26 Jul 2023 10:12:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232434AbjGZOLv (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 26 Jul 2023 10:11:51 -0400
Received: from smtp-relay-internal-1.canonical.com (smtp-relay-internal-1.canonical.com [185.125.188.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C98E3C02
        for <ceph-devel@vger.kernel.org>; Wed, 26 Jul 2023 07:11:18 -0700 (PDT)
Received: from mail-lj1-f199.google.com (mail-lj1-f199.google.com [209.85.208.199])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id D5867413CE
        for <ceph-devel@vger.kernel.org>; Wed, 26 Jul 2023 14:10:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1690380646;
        bh=ohgjgBD3cKcnIyJjD+KXey+VVqMnSRq4bkvBBBDC3os=;
        h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
         MIME-Version;
        b=cYAFBucB5A5zYp8Qf96c2qLSG09RWqtjDtr+TAjaleTATAAxkjhbV4TTEUQFAbq7b
         5JD5CsbHvktT1BOvL3vnjgI03X7oy0Fm1qe62aXF6sDjqmfbXoDdf0pYQgEyruZM03
         6WxAu696aBu60bjTpukyza7wUrRmhAwT+Qjc45LTtwfl73esqj9J8idspv0+kKMSPE
         cGAisiIffaoe88rudkzlsZPNIop18W6zhMQ6/fye7B9smeWeZwF4WrcPeAMQ83KI3h
         +2YZDFWrfHBfJc/RNCLUVWEmFqe/Ip2gDTBvVP8bNpi3VROQY0WcoEk4MiR3f7WUpu
         bwNFsjGYXQ6Ng==
Received: by mail-lj1-f199.google.com with SMTP id 38308e7fff4ca-2b701c82e83so58877501fa.1
        for <ceph-devel@vger.kernel.org>; Wed, 26 Jul 2023 07:10:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690380646; x=1690985446;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ohgjgBD3cKcnIyJjD+KXey+VVqMnSRq4bkvBBBDC3os=;
        b=HvMUv/29Z8AFBxrZ+Z0ybxIMafg2SuxN6gbMNHJl58DCNlzmgsAY2IYjEk9cRJE2De
         2NDJgnYR26/ozknwJc6+sUQX5HQNr8qBGdLJn6WIYrUGs26AtGCLnPU7SSdeDp6DAabN
         2/ZWV9TkbkJNR/rSuYovNKzeGgl6klbsP0BB0oa+0TVYyGLRBFSyuZ65j+bPUonL1OAK
         sbE2pgK7S1PxUgRGjTinh+HHN5YTPR6YUykeAF07kYySy7QFXcKTrM5ISB+GDQz5BxQe
         nTQWYp4bE/gwvWRix0H9AcdvubRULFeFsKV9GxJnPNO0VRvFlKfcTJJFneDsKP/Iq5xu
         VlBQ==
X-Gm-Message-State: ABy/qLachl21fPlkGBHo4W5uiG/6/NMj6Fgi4Q4vMadFvg5bOeLcZ2DG
        aEmxyTqa/BIdS9HdjmDtz32mPNjwNgUSL0WO3fzNcVrg3myQ5MIi16AR7W7DgGgnQfpb1k1x75O
        r5Pfs8TAK/kxUQUjdwNQlhff1y08QoPzYXnOjxRk=
X-Received: by 2002:a2e:b04c:0:b0:2b6:e292:85ab with SMTP id d12-20020a2eb04c000000b002b6e29285abmr1537990ljl.25.1690380645932;
        Wed, 26 Jul 2023 07:10:45 -0700 (PDT)
X-Google-Smtp-Source: APBJJlHjzzs2yes8HeiVNPDXX4N2hJrs8Ktc9SJJ6ywzY4b/f8BHmmRmZgH59CuUg0VsaN9+mCvkrA==
X-Received: by 2002:a2e:b04c:0:b0:2b6:e292:85ab with SMTP id d12-20020a2eb04c000000b002b6e29285abmr1537979ljl.25.1690380645680;
        Wed, 26 Jul 2023 07:10:45 -0700 (PDT)
Received: from amikhalitsyn.local (dslb-088-066-182-192.088.066.pools.vodafone-ip.de. [88.66.182.192])
        by smtp.gmail.com with ESMTPSA id k14-20020a7bc30e000000b003fc02219081sm2099714wmj.33.2023.07.26.07.10.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Jul 2023 07:10:45 -0700 (PDT)
From:   Alexander Mikhalitsyn <aleksandr.mikhalitsyn@canonical.com>
To:     xiubli@redhat.com
Cc:     brauner@kernel.org, stgraber@ubuntu.com,
        linux-fsdevel@vger.kernel.org, Jeff Layton <jlayton@kernel.org>,
        Ilya Dryomov <idryomov@gmail.com>, ceph-devel@vger.kernel.org,
        Christian Brauner <christian.brauner@ubuntu.com>,
        Alexander Mikhalitsyn <aleksandr.mikhalitsyn@canonical.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v7 05/11] ceph: allow idmapped getattr inode op
Date:   Wed, 26 Jul 2023 16:10:20 +0200
Message-Id: <20230726141026.307690-6-aleksandr.mikhalitsyn@canonical.com>
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
index 3ff4f57f223f..136b68ccdbef 100644
--- a/fs/ceph/inode.c
+++ b/fs/ceph/inode.c
@@ -3034,7 +3034,7 @@ int ceph_getattr(struct mnt_idmap *idmap, const struct path *path,
 			return err;
 	}
 
-	generic_fillattr(&nop_mnt_idmap, inode, stat);
+	generic_fillattr(idmap, inode, stat);
 	stat->ino = ceph_present_inode(inode);
 
 	/*
-- 
2.34.1

