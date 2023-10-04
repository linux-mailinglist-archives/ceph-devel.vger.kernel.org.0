Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 041977B98C2
	for <lists+ceph-devel@lfdr.de>; Thu,  5 Oct 2023 01:40:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236818AbjJDXkE (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 4 Oct 2023 19:40:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233418AbjJDXkD (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 4 Oct 2023 19:40:03 -0400
Received: from mail-ot1-x34a.google.com (mail-ot1-x34a.google.com [IPv6:2607:f8b0:4864:20::34a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7AFCCE
        for <ceph-devel@vger.kernel.org>; Wed,  4 Oct 2023 16:39:59 -0700 (PDT)
Received: by mail-ot1-x34a.google.com with SMTP id 46e09a7af769-6c49eec318aso520140a34.2
        for <ceph-devel@vger.kernel.org>; Wed, 04 Oct 2023 16:39:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1696462799; x=1697067599; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=AmDqm4rQtpNyDmMaNDTRTb/F7GEAJTZGgDpU+ccwZEQ=;
        b=RHg4HTjO5w4Gl/H8wwDwzUXwAmpkSvYnjPMKBIDTvgMxmbGjXUGVnd65DWevq5KzTf
         ivV9ym1u1d+vWeBmnO+xj0S2ydp37OosUU++7NLR3fld/YKec/mAd/scf0rKGLv9sWCw
         St4MfIO0nff1uSSoZL/i7jKFH60d7QHnKFVt4h8tdaCys/INOR1TJmZ1GxZ9moXVegFT
         KYKE49MVUyDcYAtnNXtgS4v9RHtOMLaLOF4VFNkijPcGYhDjFODuHBwpKmjSEYgBqvns
         N6cCwvQ8zqEjFahEI8KbqRsWG1VTfXDlWNh1LvbN4BKQHH2yRX4vtdOsrhrSY2VyGlAL
         MKwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696462799; x=1697067599;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=AmDqm4rQtpNyDmMaNDTRTb/F7GEAJTZGgDpU+ccwZEQ=;
        b=nlyX0X5g93l2VfcDC794JWooN2isqxbBHES//WgGI7PLt4DyR7J+H+4Wz/pp55DMHe
         aum7qDGuJW5ZWhsMxH3IAboBRg4U0ziTdJEtnMgysNilOshbTkFz5YeZCDVzGOjPhK2m
         10vCbZYc05ri0KmCdF45jZobcNE6Ie5zD1IuMlQ60MbnaVqGVZcBnVA09eOz9hZrQEjv
         51XKZykc9fDvgX8EtkxZpvyyL5gKDCjsd6k52TtQGjkdXO/QV2EWeUtzflysPBHLSb6r
         27wfrSK4ZrN/JHIkIHab1ZtJ7gVxG5q5a1X9tNypIQpDQ0WabvVWk1hGWn6kZ577nBK8
         8uXg==
X-Gm-Message-State: AOJu0YxPGX9wLl31XsN5kloqCYDwQooQIot4c1YVRkoQzUc4q02N45y9
        KkgcVuNFm9gsK9Z5mHrKmL81uEse7GQRE3cuJDRXjUbKkBYJf+YzY/DLhMCVJPNuN8RXeddrwFU
        2mqbBlwBV33kzJn6Y+WQzeQvUOrD8TZKuR4DjXC8lQ6tP6EgrS4nmEx3zaC4o+4t9
X-Google-Smtp-Source: AGHT+IH2IvELyaJYyWZbLcyvTFHh6ueK+8/Jiphpfq9ynf5I9ByGcCwPPVxbitIMTbduVDPsRXRRHt/GUQ==
X-Received: from jrife.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:9f])
 (user=jrife job=sendgmr) by 2002:a9d:7ace:0:b0:6c6:42ca:ed46 with SMTP id
 m14-20020a9d7ace000000b006c642caed46mr983846otn.0.1696462799212; Wed, 04 Oct
 2023 16:39:59 -0700 (PDT)
Date:   Wed,  4 Oct 2023 18:38:27 -0500
Mime-Version: 1.0
X-Mailer: git-send-email 2.42.0.582.g8ccd20d70d-goog
Message-ID: <20231004233827.1274148-1-jrife@google.com>
Subject: [PATCH] ceph: use kernel_connect()
From:   Jordan Rife <jrife@google.com>
To:     ceph-devel@vger.kernel.org
Cc:     idryomov@gmail.com, xiubli@redhat.com, jlayton@kernel.org,
        Jordan Rife <jrife@google.com>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Direct calls to ops->connect() can overwrite the address parameter when
used in conjunction with BPF SOCK_ADDR hooks. Recent changes to
kernel_connect() ensure that callers are insulated from such side
effects. This patch wraps the direct call to ops->connect() with
kernel_connect() to prevent unexpected changes to the address passed to
ceph_tcp_connect().

This change was originally part of a larger patch targeting the net tree
addressing all instances of unprotected calls to ops->connect()
throughout the kernel, but this change was split up into several patches
targeting various trees.

Link: https://lore.kernel.org/netdev/20230821100007.559638-1-jrife@google.com/
Link: https://lore.kernel.org/netdev/9944248dba1bce861375fcce9de663934d933ba9.camel@redhat.com/
Fixes: d74bad4e74ee ("bpf: Hooks for sys_connect")
Cc: stable@vger.kernel.org
Signed-off-by: Jordan Rife <jrife@google.com>
---
 net/ceph/messenger.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/ceph/messenger.c b/net/ceph/messenger.c
index 10a41cd9c5235..3c8b78d9c4d1c 100644
--- a/net/ceph/messenger.c
+++ b/net/ceph/messenger.c
@@ -459,8 +459,8 @@ int ceph_tcp_connect(struct ceph_connection *con)
 	set_sock_callbacks(sock, con);
 
 	con_sock_state_connecting(con);
-	ret = sock->ops->connect(sock, (struct sockaddr *)&ss, sizeof(ss),
-				 O_NONBLOCK);
+	ret = kernel_connect(sock, (struct sockaddr *)&ss, sizeof(ss),
+			     O_NONBLOCK);
 	if (ret == -EINPROGRESS) {
 		dout("connect %s EINPROGRESS sk_state = %u\n",
 		     ceph_pr_addr(&con->peer_addr),
-- 
2.42.0.582.g8ccd20d70d-goog

