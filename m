Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 17D3D728405
	for <lists+ceph-devel@lfdr.de>; Thu,  8 Jun 2023 17:45:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237203AbjFHPpE (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 8 Jun 2023 11:45:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237343AbjFHPoh (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 8 Jun 2023 11:44:37 -0400
Received: from smtp-relay-internal-1.canonical.com (smtp-relay-internal-1.canonical.com [185.125.188.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A444730E5
        for <ceph-devel@vger.kernel.org>; Thu,  8 Jun 2023 08:44:08 -0700 (PDT)
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com [209.85.218.71])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id C0BA83F13F
        for <ceph-devel@vger.kernel.org>; Thu,  8 Jun 2023 15:43:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1686239033;
        bh=hMEKg4eGVgDXkovGDpYWIZx/H1D1uxAjXSI9jX8bPYQ=;
        h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
         MIME-Version;
        b=NZTbyJX/dfJjYfoQbRzUwXtPcO7bh4rnISUnC1ZcLPB/RBRabXRMh0S7HOfWYvISx
         JatKKDLD3YtukfbIKXYbQ1PDtv+4Tbgjzp41YCp2iZRw/qlNoInJ4nh1ZKuXHXg4fK
         wsnkkLri6EhtLv9psEe8pa0FAhlddGJoqxiYrJkv7AejfID1bThNSR8UeJIavrn8mp
         9DQFSFqG4AVH5TeojLndHYf/Qhh3OdP+ZCbrftQtVvYMgvaM6jrcxL4IbkQKjDSrnS
         1hZfxXxc5eNS8TbWXylfimrUjCwYjDgwPPSBI5bT613JMABvhwEykTaQ/aTSbYXnUM
         jO3CfO5sQNbPQ==
Received: by mail-ej1-f71.google.com with SMTP id a640c23a62f3a-9715654ab36so87028766b.0
        for <ceph-devel@vger.kernel.org>; Thu, 08 Jun 2023 08:43:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686239032; x=1688831032;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=hMEKg4eGVgDXkovGDpYWIZx/H1D1uxAjXSI9jX8bPYQ=;
        b=YEk67rK9rJhDSYQRwKYvs0zqDRMwPA3vTiuwGfHLA1QlwtOxmbIsIijNuhnA6DjtFw
         /QW9HJd0hp7NUmf7D9JfWLmGLAYIUxEZ+Hpu9hF8YV+Nq5/Aud8JbwnyKwqbqnFZrDul
         UrSX93TNIHnRaueIyYfOkozZv6IKYPTiBB59HisAHZXJo3ozkinu4om6b2BIfNZhC8sy
         TbVLOIPrx+TTmkyenw9y4kur2duoq7/2vVnqcjkQ2fYcCLRKafzOayLAEWPcCy1ojQwL
         C7tBWTWC6p7abYXIi7o1eWoZsz5Y6pH2WwW5Hh75USX+wRbpzegTOt8BYtzTvSZxO3ub
         4DIA==
X-Gm-Message-State: AC+VfDyGN8nulfQ/L7Jzpsn0mVwxx9IDOClyz0sqDS5E4/ZM/03AoZBI
        blYP8PqiEt7vbUZ5L6L0GgwC4ZKysExJ1Gd8Qb2MMdauZwZogwQRjcymmUvsgD2+SRwnZEOXBj6
        kyBnugjLINDNrOjY66AMn5hA4Bow3FQuKvHrVwzQ=
X-Received: by 2002:a05:6402:147:b0:514:9c05:819e with SMTP id s7-20020a056402014700b005149c05819emr7682638edu.0.1686239032690;
        Thu, 08 Jun 2023 08:43:52 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ47f/M3Pn0HYOzhFIP9nhAo5elf7zfS/8PYInY9g89YRrer/rMZF1pnuQSZX3FuSKqLLPPkhg==
X-Received: by 2002:a05:6402:147:b0:514:9c05:819e with SMTP id s7-20020a056402014700b005149c05819emr7682624edu.0.1686239032523;
        Thu, 08 Jun 2023 08:43:52 -0700 (PDT)
Received: from amikhalitsyn.local (dslb-002-205-064-187.002.205.pools.vodafone-ip.de. [2.205.64.187])
        by smtp.gmail.com with ESMTPSA id y8-20020aa7c248000000b005164ae1c482sm678387edo.11.2023.06.08.08.43.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Jun 2023 08:43:52 -0700 (PDT)
From:   Alexander Mikhalitsyn <aleksandr.mikhalitsyn@canonical.com>
To:     xiubli@redhat.com
Cc:     brauner@kernel.org, stgraber@ubuntu.com,
        linux-fsdevel@vger.kernel.org, Jeff Layton <jlayton@kernel.org>,
        Ilya Dryomov <idryomov@gmail.com>, ceph-devel@vger.kernel.org,
        Alexander Mikhalitsyn <aleksandr.mikhalitsyn@canonical.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v5 12/14] ceph: pass idmap to __ceph_setxattr
Date:   Thu,  8 Jun 2023 17:42:53 +0200
Message-Id: <20230608154256.562906-13-aleksandr.mikhalitsyn@canonical.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230608154256.562906-1-aleksandr.mikhalitsyn@canonical.com>
References: <20230608154256.562906-1-aleksandr.mikhalitsyn@canonical.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Just pass down the mount's idmapping to __ceph_setxattr.

Cc: Xiubo Li <xiubli@redhat.com>
Cc: Jeff Layton <jlayton@kernel.org>
Cc: Ilya Dryomov <idryomov@gmail.com>
Cc: brauner@kernel.org
Cc: ceph-devel@vger.kernel.org
Signed-off-by: Alexander Mikhalitsyn <aleksandr.mikhalitsyn@canonical.com>
---
 fs/ceph/acl.c   |  2 +-
 fs/ceph/super.h |  3 ++-
 fs/ceph/xattr.c | 12 +++++++-----
 3 files changed, 10 insertions(+), 7 deletions(-)

diff --git a/fs/ceph/acl.c b/fs/ceph/acl.c
index d0ca5a0060d8..bb02776e3df2 100644
--- a/fs/ceph/acl.c
+++ b/fs/ceph/acl.c
@@ -145,7 +145,7 @@ int ceph_set_acl(struct mnt_idmap *idmap, struct dentry *dentry,
 			goto out_free;
 	}
 
-	ret = __ceph_setxattr(inode, name, value, size, 0);
+	ret = __ceph_setxattr(idmap, inode, name, value, size, 0);
 	if (ret) {
 		if (new_mode != old_mode) {
 			newattrs.ia_ctime = old_ctime;
diff --git a/fs/ceph/super.h b/fs/ceph/super.h
index ccef4a6bac52..e23aec9554b3 100644
--- a/fs/ceph/super.h
+++ b/fs/ceph/super.h
@@ -1073,7 +1073,8 @@ static inline bool ceph_inode_is_shutdown(struct inode *inode)
 }
 
 /* xattr.c */
-int __ceph_setxattr(struct inode *, const char *, const void *, size_t, int);
+int __ceph_setxattr(struct mnt_idmap *, struct inode *,
+		    const char *, const void *, size_t, int);
 int ceph_do_getvxattr(struct inode *inode, const char *name, void *value, size_t size);
 ssize_t __ceph_getxattr(struct inode *, const char *, void *, size_t);
 extern ssize_t ceph_listxattr(struct dentry *, char *, size_t);
diff --git a/fs/ceph/xattr.c b/fs/ceph/xattr.c
index d3ac854bc11f..0acb292f600d 100644
--- a/fs/ceph/xattr.c
+++ b/fs/ceph/xattr.c
@@ -1064,7 +1064,8 @@ ssize_t ceph_listxattr(struct dentry *dentry, char *names, size_t size)
 	return err;
 }
 
-static int ceph_sync_setxattr(struct inode *inode, const char *name,
+static int ceph_sync_setxattr(struct mnt_idmap *idmap,
+			      struct inode *inode, const char *name,
 			      const char *value, size_t size, int flags)
 {
 	struct ceph_fs_client *fsc = ceph_sb_to_client(inode->i_sb);
@@ -1118,6 +1119,7 @@ static int ceph_sync_setxattr(struct inode *inode, const char *name,
 
 	req->r_inode = inode;
 	ihold(inode);
+	req->r_mnt_idmap = mnt_idmap_get(idmap);
 	req->r_num_caps = 1;
 	req->r_inode_drop = CEPH_CAP_XATTR_SHARED;
 
@@ -1132,8 +1134,8 @@ static int ceph_sync_setxattr(struct inode *inode, const char *name,
 	return err;
 }
 
-int __ceph_setxattr(struct inode *inode, const char *name,
-			const void *value, size_t size, int flags)
+int __ceph_setxattr(struct mnt_idmap *idmap, struct inode *inode,
+		    const char *name, const void *value, size_t size, int flags)
 {
 	struct ceph_vxattr *vxattr;
 	struct ceph_inode_info *ci = ceph_inode(inode);
@@ -1262,7 +1264,7 @@ int __ceph_setxattr(struct inode *inode, const char *name,
 				    "during filling trace\n", inode);
 		err = -EBUSY;
 	} else {
-		err = ceph_sync_setxattr(inode, name, value, size, flags);
+		err = ceph_sync_setxattr(idmap, inode, name, value, size, flags);
 		if (err >= 0 && check_realm) {
 			/* check if snaprealm was created for quota inode */
 			spin_lock(&ci->i_ceph_lock);
@@ -1298,7 +1300,7 @@ static int ceph_set_xattr_handler(const struct xattr_handler *handler,
 {
 	if (!ceph_is_valid_xattr(name))
 		return -EOPNOTSUPP;
-	return __ceph_setxattr(inode, name, value, size, flags);
+	return __ceph_setxattr(idmap, inode, name, value, size, flags);
 }
 
 static const struct xattr_handler ceph_other_xattr_handler = {
-- 
2.34.1

