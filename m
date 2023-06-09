Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B329C7295B3
	for <lists+ceph-devel@lfdr.de>; Fri,  9 Jun 2023 11:43:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241771AbjFIJnJ (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 9 Jun 2023 05:43:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241858AbjFIJmb (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Fri, 9 Jun 2023 05:42:31 -0400
Received: from smtp-relay-internal-1.canonical.com (smtp-relay-internal-1.canonical.com [185.125.188.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98622525E
        for <ceph-devel@vger.kernel.org>; Fri,  9 Jun 2023 02:37:13 -0700 (PDT)
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com [209.85.208.70])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id 5E9BD3F363
        for <ceph-devel@vger.kernel.org>; Fri,  9 Jun 2023 09:33:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1686303194;
        bh=QbGnheXMoUoU7EuOckcncmKJSqs6BTa9rIJEwkbRpgw=;
        h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
         MIME-Version;
        b=SMkADP4rtQrKd+6OxRtNi7rFAyRCRl1JahkMRhQfvfyByEw/OYotF8hGree+L96tf
         lhvJQzbqaqxEHUwOOQcxVhqR4bTOfjcwJcFpX5SFvhqRhyYaMWvy/Bp0sZM0sw/2ch
         L90jJW3uVqeouT4fy/KJ/xMM+ywMgj4LZ7O4LuI/lYmVUDXfR1V6Rx0Pnn8+owBx4j
         K165u8mgSQzQvUrlRUhgiL+qnzcopUpIyQgzsw5wkGdsFTHu3kHqUEAwvMH3zwuVb+
         T4lFvER3BmULV5EtINcG15Sfiack56kp3Z4u2s85Aw8jVnQKMCIP8yqeF4GZHEptMl
         HKOx7t0GhqwZQ==
Received: by mail-ed1-f70.google.com with SMTP id 4fb4d7f45d1cf-5149ab05081so1265698a12.2
        for <ceph-devel@vger.kernel.org>; Fri, 09 Jun 2023 02:33:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686303193; x=1688895193;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=QbGnheXMoUoU7EuOckcncmKJSqs6BTa9rIJEwkbRpgw=;
        b=J3gmD5sJNiNlAf+PMatVzOs8nMkdyHiTa8Ua8W3/d+6LNn9LoszTCBL/8sI+lRmh9O
         oT5aI+GP7SSKrbUXvi44eYSdc3xeq8lcAohh6wSP8zlGFsRY1YODl4BPX3D9m5bShAF8
         g9u17uvde3jXvYMPsW4r2t9Gq+ij83rVHjYSFsn6L7Rmn6BxPELcT4nPDrCcfZes2tTc
         E8uwgc3FNfJSxvwSFtDkVgg2IHIU+v1J/X02nf5snYHMAvJBnd37JnX8BlXSGwPGiRMM
         wYlhqVBTlffRyGD0+4/mvqEz67lf4922L8utdZCz9PhVpd2AWse+ch8oDF13oTKUpKcD
         HJEg==
X-Gm-Message-State: AC+VfDyR/2jqYB8Pqct2k+5sXobAjl9vZtwc16qXo6yqajmmhHq5ZUiG
        XMfXxFQIv9vRU2rYZkWGZp+9DolZizQ07OWAXrvUeyXQcq154weIo+q4k7SIXWdVVdpaWCNnVUu
        VF0wn/vd53CRduZ9C3elAiQ2rdVyBxkVv4Vk4KADsiun48i4=
X-Received: by 2002:a17:906:99c4:b0:977:4b64:f5e8 with SMTP id s4-20020a17090699c400b009774b64f5e8mr1032567ejn.57.1686303193181;
        Fri, 09 Jun 2023 02:33:13 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ5HU2v6WmrkMOTn6GRljmiRk69Tjcu7+OG5pBD1+ECabkYx/wfa5G2bflaMx7onYF4L2fcwKA==
X-Received: by 2002:a17:906:99c4:b0:977:4b64:f5e8 with SMTP id s4-20020a17090699c400b009774b64f5e8mr1032559ejn.57.1686303193039;
        Fri, 09 Jun 2023 02:33:13 -0700 (PDT)
Received: from amikhalitsyn.local (dslb-002-205-064-187.002.205.pools.vodafone-ip.de. [2.205.64.187])
        by smtp.gmail.com with ESMTPSA id e25-20020a170906081900b0094ee3e4c934sm1031248ejd.221.2023.06.09.02.33.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Jun 2023 02:33:12 -0700 (PDT)
From:   Alexander Mikhalitsyn <aleksandr.mikhalitsyn@canonical.com>
To:     xiubli@redhat.com
Cc:     brauner@kernel.org, stgraber@ubuntu.com,
        linux-fsdevel@vger.kernel.org,
        Christian Brauner <christian.brauner@ubuntu.com>,
        Jeff Layton <jlayton@kernel.org>,
        Ilya Dryomov <idryomov@gmail.com>, ceph-devel@vger.kernel.org,
        Alexander Mikhalitsyn <aleksandr.mikhalitsyn@canonical.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v6 15/15] ceph: allow idmapped mounts
Date:   Fri,  9 Jun 2023 11:31:26 +0200
Message-Id: <20230609093125.252186-16-aleksandr.mikhalitsyn@canonical.com>
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

Now that we converted cephfs internally to account for idmapped mounts
allow the creation of idmapped mounts on by setting the FS_ALLOW_IDMAP
flag.

Cc: Xiubo Li <xiubli@redhat.com>
Cc: Jeff Layton <jlayton@kernel.org>
Cc: Ilya Dryomov <idryomov@gmail.com>
Cc: ceph-devel@vger.kernel.org
Signed-off-by: Christian Brauner <christian.brauner@ubuntu.com>
Signed-off-by: Alexander Mikhalitsyn <aleksandr.mikhalitsyn@canonical.com>
---
 fs/ceph/super.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ceph/super.c b/fs/ceph/super.c
index 3d6d0010d638..aabc8ac90ead 100644
--- a/fs/ceph/super.c
+++ b/fs/ceph/super.c
@@ -1581,7 +1581,7 @@ static struct file_system_type ceph_fs_type = {
 	.name		= "ceph",
 	.init_fs_context = ceph_init_fs_context,
 	.kill_sb	= ceph_kill_sb,
-	.fs_flags	= FS_RENAME_DOES_D_MOVE,
+	.fs_flags	= FS_RENAME_DOES_D_MOVE | FS_ALLOW_IDMAP,
 };
 MODULE_ALIAS_FS("ceph");
 
-- 
2.34.1

