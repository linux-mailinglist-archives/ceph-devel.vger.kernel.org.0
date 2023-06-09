Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D730729665
	for <lists+ceph-devel@lfdr.de>; Fri,  9 Jun 2023 12:11:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240361AbjFIKKr (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 9 Jun 2023 06:10:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230134AbjFIKKV (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Fri, 9 Jun 2023 06:10:21 -0400
Received: from smtp-relay-internal-0.canonical.com (smtp-relay-internal-0.canonical.com [185.125.188.122])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9484E869F
        for <ceph-devel@vger.kernel.org>; Fri,  9 Jun 2023 02:59:18 -0700 (PDT)
Received: from mail-lj1-f200.google.com (mail-lj1-f200.google.com [209.85.208.200])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-0.canonical.com (Postfix) with ESMTPS id 3CB5A3F460
        for <ceph-devel@vger.kernel.org>; Fri,  9 Jun 2023 09:32:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1686303166;
        bh=/3eW+11n/4iCvn/s3430tPb8fe2pR8+LzRYCxQYjku8=;
        h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
         MIME-Version;
        b=oesWZssZIjW57ZWF92PWBoWu4iY32fpTt65uUzVnDdsTEkcZnEBnQ2VhxKOckiRuM
         LzF8EbIgATwmQaU3uCpXPQGZmJq/H8JuPQTuZ3GSqB94+B87CJP5IsuFbHEOAdRRoM
         5HSwMJRfEXCmHvseQ9HMnIRijIM8tQwXm0yxf9mzXytIjH6U52XCFGTN+r1m+fy0BH
         WsgzpYFwSg8ynd4DAk1xoaD9xzloUwc+Vm3Q40QG0dsqAemgJkN0TklMS+ODVfuFOT
         ZyFi6CZGTDIPgp9ero4qtB/+ahSTmroiGRkJDn3kTCfBI28aaF1ypJR2qsPsxXGFOY
         sZaAW0lFcz95A==
Received: by mail-lj1-f200.google.com with SMTP id 38308e7fff4ca-2b20220c67bso12537251fa.1
        for <ceph-devel@vger.kernel.org>; Fri, 09 Jun 2023 02:32:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686303164; x=1688895164;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/3eW+11n/4iCvn/s3430tPb8fe2pR8+LzRYCxQYjku8=;
        b=goFYhO7zUNzDGh/stwdPn1Q7exrTVGGFatC/HkV/QfDGkKaOFT4tLNS+z+BN06e10T
         oPfE/EV9j5cZiSe/qPnSYEN5HX6Q9QKdTQPuMVCWgXNIF++z409UaLMElHvrLIro5dFs
         TcOVa8LhqJgMOuN+srHK70AMTX3jRkYGvLn/cJOrdX+5q4glxEdJOeN4IAdeQfz6M6dF
         XIUX9UWMfpVfPlVtut8IxD4x4tVB40ZpAFeajo3dXlvNe2riIIMxQrTS4ncCIqLfBQub
         Ndr+J0K1XsVD0RkVk3RKPM8tQSjYQ0Gan6bm6XtMN3zWXRhB6sS0YA0TKUKahtA6j3y2
         5pTA==
X-Gm-Message-State: AC+VfDwPVR/rss356iCdl7z2RxaO+imx62GAZhkUNYeeASVjbpkcFIe8
        /1jgcAviI4tpZnQsinK5sqCSzRSc70DgB8yTKVsGMBnOEOcnOyGGFM0RgzErvbRpgfULjAVpmrV
        nC+yDt7KIS7MavuaWO2NZGWn4Nf2Dz2wad41XKzA=
X-Received: by 2002:a2e:8659:0:b0:2b2:3a4:4ebe with SMTP id i25-20020a2e8659000000b002b203a44ebemr802395ljj.48.1686303164553;
        Fri, 09 Jun 2023 02:32:44 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ6Xp6K9xKO9YEjHS2qWVmuHEJbD+pzRh3X4TI7BNImhUPEhsy5RO+Z9y84aSm4a3Lt8GGRPiw==
X-Received: by 2002:a2e:8659:0:b0:2b2:3a4:4ebe with SMTP id i25-20020a2e8659000000b002b203a44ebemr802382ljj.48.1686303164306;
        Fri, 09 Jun 2023 02:32:44 -0700 (PDT)
Received: from amikhalitsyn.local (dslb-002-205-064-187.002.205.pools.vodafone-ip.de. [2.205.64.187])
        by smtp.gmail.com with ESMTPSA id e25-20020a170906081900b0094ee3e4c934sm1031248ejd.221.2023.06.09.02.32.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Jun 2023 02:32:43 -0700 (PDT)
From:   Alexander Mikhalitsyn <aleksandr.mikhalitsyn@canonical.com>
To:     xiubli@redhat.com
Cc:     brauner@kernel.org, stgraber@ubuntu.com,
        linux-fsdevel@vger.kernel.org,
        Christian Brauner <christian.brauner@ubuntu.com>,
        Jeff Layton <jlayton@kernel.org>,
        Ilya Dryomov <idryomov@gmail.com>, ceph-devel@vger.kernel.org,
        Alexander Mikhalitsyn <aleksandr.mikhalitsyn@canonical.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v6 05/15] ceph: allow idmapped getattr inode op
Date:   Fri,  9 Jun 2023 11:31:16 +0200
Message-Id: <20230609093125.252186-6-aleksandr.mikhalitsyn@canonical.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230609093125.252186-1-aleksandr.mikhalitsyn@canonical.com>
References: <20230609093125.252186-1-aleksandr.mikhalitsyn@canonical.com>
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
index fe8adb9d67a6..533349fe542f 100644
--- a/fs/ceph/inode.c
+++ b/fs/ceph/inode.c
@@ -2979,7 +2979,7 @@ int ceph_getattr(struct mnt_idmap *idmap, const struct path *path,
 			return err;
 	}
 
-	generic_fillattr(&nop_mnt_idmap, inode, stat);
+	generic_fillattr(idmap, inode, stat);
 	stat->ino = ceph_present_inode(inode);
 
 	/*
-- 
2.34.1

