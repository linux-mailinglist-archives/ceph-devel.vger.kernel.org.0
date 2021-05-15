Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D60EC3817AE
	for <lists+ceph-devel@lfdr.de>; Sat, 15 May 2021 12:36:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231872AbhEOKhZ (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Sat, 15 May 2021 06:37:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231583AbhEOKhZ (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Sat, 15 May 2021 06:37:25 -0400
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43704C061573
        for <ceph-devel@vger.kernel.org>; Sat, 15 May 2021 03:36:12 -0700 (PDT)
Received: by mail-ed1-x529.google.com with SMTP id l7so1362432edb.1
        for <ceph-devel@vger.kernel.org>; Sat, 15 May 2021 03:36:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ZOO5ouO4oezt8H6XIc5Z9KBaIYmBYK6PyWezHhUp+rQ=;
        b=uFZISXC+5xXI9b6wwNIMTf7wDtn8l2fZPyCvT+jJ7KdSuM9hXg+ACPotD38JMxL4eQ
         +FK67g2erB7VlHaJPefvCSkpDqiqB2aReEkT1OvNIkBXU0IhcPSJrCKkatQ0tQU4cza4
         DCnjoII1FgmUjl3tbs7aYSrH2FKBA9FXJt97y4rukglPf3kXud44ewClh/qDaMEf+5hw
         J6Ln3xa315TYxuhYiN/8UPOUPrhYl80b+/nC6D65sWAOpUgeODD228jY/EgvfzBlGwOD
         Ws08jnnKOznMzRf8Nrxl3wJUg6BPylhO5IQK3AsMTA4bRaNkRZxzU/iQqO6pKc5MSumQ
         GQaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ZOO5ouO4oezt8H6XIc5Z9KBaIYmBYK6PyWezHhUp+rQ=;
        b=AzERULWQOx6GFgGFTE2X7QDxfWEoXGfhkiXUQHtsBzXAhlBVzlrOoVu4u8B4CvkKLs
         968LxXh/Y9N3chGqgwAKDmZSwNONo6bXH9cL9WueVHgic9xFobJiTT3Gowxs4AcILk3t
         9YaGLpUF6ByJj8i41CNDMAU6wyTRJI1iVxYs7zWDPcdhKnxkxmJeKnTUOOTyD6spbpk7
         8Nwd1nO/tHYTBaToeuOTgOD30oyyWOSNA3bTWS8dsnfrMLD+ms1t4rY+I5ylH2YFSzSd
         2mP668BdEjrwYyy2IzpATzqZwIupVMHKVG8TSUW1J+u8ULHoeCdQgLFhjiCv+vyt0p1A
         6Ktw==
X-Gm-Message-State: AOAM530r9LVJOTzA2vKN3LLvMVtAtrlfIw97tmh027yFjF83MQism98A
        OqQMH6ail1Ooij1UXKc2hoZTM9zouBuXag==
X-Google-Smtp-Source: ABdhPJwhdiJ0qBKaV4/tJ6rycCA2syChC3IzLmbE4gTbMYa4bIcbzOP7RtXQkG5IsFRSl4adfu1oQg==
X-Received: by 2002:a05:6402:1a48:: with SMTP id bf8mr20598275edb.150.1621074970962;
        Sat, 15 May 2021 03:36:10 -0700 (PDT)
Received: from kwango.local (ip-94-112-132-16.net.upcbroadband.cz. [94.112.132.16])
        by smtp.gmail.com with ESMTPSA id ch30sm6441114edb.92.2021.05.15.03.36.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 15 May 2021 03:36:10 -0700 (PDT)
From:   Ilya Dryomov <idryomov@gmail.com>
To:     ceph-devel@vger.kernel.org
Cc:     "Gustavo A . R . Silva" <gustavoars@kernel.org>
Subject: [PATCH] libceph: kill ceph_none_authorizer::reply_buf
Date:   Sat, 15 May 2021 12:36:18 +0200
Message-Id: <20210515103618.5789-1-idryomov@gmail.com>
X-Mailer: git-send-email 2.19.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

We never receive authorizer replies with cephx disabled, so it is
bogus.  Also, it still uses the old zero-length array style.

Reported-by: Gustavo A. R. Silva <gustavoars@kernel.org>
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
---
 net/ceph/auth_none.c | 4 ++--
 net/ceph/auth_none.h | 1 -
 2 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/net/ceph/auth_none.c b/net/ceph/auth_none.c
index 70e86e462250..dbf22df10a85 100644
--- a/net/ceph/auth_none.c
+++ b/net/ceph/auth_none.c
@@ -111,8 +111,8 @@ static int ceph_auth_none_create_authorizer(
 	auth->authorizer = (struct ceph_authorizer *) au;
 	auth->authorizer_buf = au->buf;
 	auth->authorizer_buf_len = au->buf_len;
-	auth->authorizer_reply_buf = au->reply_buf;
-	auth->authorizer_reply_buf_len = sizeof (au->reply_buf);
+	auth->authorizer_reply_buf = NULL;
+	auth->authorizer_reply_buf_len = 0;
 
 	return 0;
 }
diff --git a/net/ceph/auth_none.h b/net/ceph/auth_none.h
index 4158f064302e..bb121539e796 100644
--- a/net/ceph/auth_none.h
+++ b/net/ceph/auth_none.h
@@ -16,7 +16,6 @@ struct ceph_none_authorizer {
 	struct ceph_authorizer base;
 	char buf[128];
 	int buf_len;
-	char reply_buf[0];
 };
 
 struct ceph_auth_none_info {
-- 
2.19.2

