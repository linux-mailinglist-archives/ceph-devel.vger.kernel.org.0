Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 60ACE76FC8E
	for <lists+ceph-devel@lfdr.de>; Fri,  4 Aug 2023 10:51:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229915AbjHDIvO (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 4 Aug 2023 04:51:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229566AbjHDItq (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Fri, 4 Aug 2023 04:49:46 -0400
Received: from smtp-relay-internal-1.canonical.com (smtp-relay-internal-1.canonical.com [185.125.188.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0E614ED3
        for <ceph-devel@vger.kernel.org>; Fri,  4 Aug 2023 01:49:43 -0700 (PDT)
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com [209.85.218.70])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id A5DB5417B7
        for <ceph-devel@vger.kernel.org>; Fri,  4 Aug 2023 08:49:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1691138979;
        bh=dbq6NgAMN4t7wxNwyddA+VrJjiC20GkONqywDZDeteI=;
        h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
         MIME-Version;
        b=edXdGDcEtsqo8doV8kunlQD0coNauOaZVaUTViowv+QcRw+CVs1fZojjFCTALl84e
         Dy4VIouV/7PIzHeiRU1pkGewYL/EeBCU513DzJoZwbOFb0gSr3sJQMUdHfuaelygzO
         hBz3BIEGL6AujCjvuzD6MA37w/ZVOrWOltPo6e7XK+h9uFk994w7CzRyiNZ1cmddXf
         jLzonDlrVp4GM1WQGp3Mg9FzjG4NxPLVyQduc1dBzWwJtMz4gVSGIzeh/lum3B1Teo
         7YwJ4wryXuhE9A+fQ3gru7APn+CURcSgcoFS5PIs41qEJ9pJjxgVZmcF5GtB7Lk0z2
         VhvxQZcS1kU1A==
Received: by mail-ej1-f70.google.com with SMTP id a640c23a62f3a-94a34e35f57so118537966b.3
        for <ceph-devel@vger.kernel.org>; Fri, 04 Aug 2023 01:49:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691138979; x=1691743779;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=dbq6NgAMN4t7wxNwyddA+VrJjiC20GkONqywDZDeteI=;
        b=by96bSPVO8lah7Lj0UaFf0j5BsXs8rrFZTqtF30mJPYQNm9+ad8DIuqH32MAijXCi0
         B2rR+XImUExXHQ73WwiYl7jHyJqgseolMtEMvx1GWAPOtBt8L5YuFUY7Q072nsTEPKGd
         3fJqxEGeH2dum09E0L9PYRrX0vW6zdZw3a4aBA/LOYU2UDtxdKgEKL7Eu/4wC5e1Y406
         J/JlaZiVpjzhCqhMufeAoYIqU6NoyGBfMWm6+hsYf7MsRakx+s25Njjx3es7aTo31qX9
         Unn8X9/i9/PwiLA+caHy6BA3Pz3Tu8h5WJTpvx6lA+TWbeIXAHvx3vhYg7VbQYZNdCsi
         hteQ==
X-Gm-Message-State: AOJu0Yy367ArlEfxiXwyDMUpA7/cDhz87dPZ38yGdv1wiajwCXeKcmj/
        EtXY1ZpM38rPY4MEHPS/QwYctylZRoko98tvkhF2OEQHwUhpR2cuenA9ieNB9ZYSS/akExn3V+k
        EjFKg9LnnyA4vvI4vT4ZAxUWoPn5THYo9zITU0f8=
X-Received: by 2002:a17:907:2c75:b0:99c:331:4194 with SMTP id ib21-20020a1709072c7500b0099c03314194mr876525ejc.45.1691138979381;
        Fri, 04 Aug 2023 01:49:39 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IESWXoXKkpSChoFK7yg9A+13bbRcRctLrscoYkM2GH7k6ZkVluHa/bbcpxuaBSQemmgRG6ytQ==
X-Received: by 2002:a17:907:2c75:b0:99c:331:4194 with SMTP id ib21-20020a1709072c7500b0099c03314194mr876517ejc.45.1691138979203;
        Fri, 04 Aug 2023 01:49:39 -0700 (PDT)
Received: from amikhalitsyn.local (dslb-088-066-182-192.088.066.pools.vodafone-ip.de. [88.66.182.192])
        by smtp.gmail.com with ESMTPSA id k25-20020a17090646d900b00992e94bcfabsm979279ejs.167.2023.08.04.01.49.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Aug 2023 01:49:38 -0700 (PDT)
From:   Alexander Mikhalitsyn <aleksandr.mikhalitsyn@canonical.com>
To:     xiubli@redhat.com
Cc:     brauner@kernel.org, stgraber@ubuntu.com,
        linux-fsdevel@vger.kernel.org, Jeff Layton <jlayton@kernel.org>,
        Ilya Dryomov <idryomov@gmail.com>, ceph-devel@vger.kernel.org,
        Alexander Mikhalitsyn <aleksandr.mikhalitsyn@canonical.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v9 06/12] ceph: allow idmapped getattr inode op
Date:   Fri,  4 Aug 2023 10:48:52 +0200
Message-Id: <20230804084858.126104-7-aleksandr.mikhalitsyn@canonical.com>
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

Enable ceph_getattr() to handle idmapped mounts. This is just a matter
of passing down the mount's idmapping.

Cc: Xiubo Li <xiubli@redhat.com>
Cc: Jeff Layton <jlayton@kernel.org>
Cc: Ilya Dryomov <idryomov@gmail.com>
Cc: ceph-devel@vger.kernel.org
Signed-off-by: Christian Brauner <brauner@kernel.org>
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

