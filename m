Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9004B72681C
	for <lists+ceph-devel@lfdr.de>; Wed,  7 Jun 2023 20:11:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232653AbjFGSL1 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 7 Jun 2023 14:11:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232731AbjFGSLH (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 7 Jun 2023 14:11:07 -0400
Received: from smtp-relay-internal-0.canonical.com (smtp-relay-internal-0.canonical.com [185.125.188.122])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F7282139
        for <ceph-devel@vger.kernel.org>; Wed,  7 Jun 2023 11:10:58 -0700 (PDT)
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com [209.85.218.72])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-0.canonical.com (Postfix) with ESMTPS id E4C903F15A
        for <ceph-devel@vger.kernel.org>; Wed,  7 Jun 2023 18:10:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1686161455;
        bh=UUJj01wMEQ1oyKBsNssb6jfIoqp09AUl4ugwx+FKVfQ=;
        h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
         MIME-Version;
        b=PD2zrpH/96Hfsg5V9OVI4R/qDxJe9QzlcEt4+KK5b/p76cnGUZRN3DO568/+GmWKN
         VI7mHX6Ur7cq8Ytvr0dUoFGzxMHpKBrKN2ehm3Qm1Y/BVSStdYw97QXARvzuewcIO1
         DE9jgbeheqF0Lc8hbVgT0EM8l8W7NCrMpgA25pg/tmj2e/2ZlRHOZyi6O6WzddEkhN
         jsmqqcn+tXZy/AtV+9L5MI7h9z7hCZKH9GgIrvjcDtEoRYRVWn9YK49zNf08PCpnlE
         U6N7O5ekdPzp0mKs1bEWPMOF3FaxA+g2af2p5LLqvgstjAOjo7fU8zUGKyaNP2OUlq
         5dJjnrgV24+8Q==
Received: by mail-ej1-f72.google.com with SMTP id a640c23a62f3a-94a34d3e5ebso572094766b.3
        for <ceph-devel@vger.kernel.org>; Wed, 07 Jun 2023 11:10:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686161455; x=1688753455;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=UUJj01wMEQ1oyKBsNssb6jfIoqp09AUl4ugwx+FKVfQ=;
        b=H8A/XOIan3LDxC+eiKu3aiOvkqSO1B5dnze5sSMJdkwgmeS81UZZGaB4vyAXeJdUqh
         mnNUVja/ykJecIrDj6SgDFPYEBExTKnTDW+G+xtgHBJ7x3HBKmBCSQTilLFpk9H6JLZI
         DXQKrGh1AjaKJYfEnRHnvCUU+ti5Xqrlw5FGyrFfIAVHdpxPdYouB5A5ABxvEw6rCbTs
         paCzFoHCwrW4w2d7fLE0LuUHwKpoYQKLc92SoMv8ArdwCjvmzK6mOOlVh6mxV3fItqvC
         Asif+t9Ec7YWX0FXnAj+igkaYG/ylN1umPsDqMXruEXw4XtkU4mT+n2CYRCTzboyzh8d
         QtQg==
X-Gm-Message-State: AC+VfDwbBnIwaZtYyD0X79fhMLYCGm17uIYZa8WMge97qq8+A+S5N2sw
        IgEViaI8Nk9CLHVamVyV7TTyr6jK6bZ85zvV+Sc6hbkW7dlxFzYLiFScE8hjyENfu9QfFWVHTNP
        axmLEx+5H/snsKp2gz/AaqnXrIbI60okISMYWXj8=
X-Received: by 2002:a17:907:7e9e:b0:974:52e6:93cb with SMTP id qb30-20020a1709077e9e00b0097452e693cbmr8404013ejc.50.1686161455769;
        Wed, 07 Jun 2023 11:10:55 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ5QyWGLJ/fh/AxvEp9QlmkvfHipFfD/nqgbmvpynD+HDDoDC1eMF5jNtJoBqxoAcOKrhPegiA==
X-Received: by 2002:a17:907:7e9e:b0:974:52e6:93cb with SMTP id qb30-20020a1709077e9e00b0097452e693cbmr8404003ejc.50.1686161455569;
        Wed, 07 Jun 2023 11:10:55 -0700 (PDT)
Received: from amikhalitsyn.local (dslb-002-205-064-187.002.205.pools.vodafone-ip.de. [2.205.64.187])
        by smtp.gmail.com with ESMTPSA id oz17-20020a170906cd1100b009745edfb7cbsm7170494ejb.45.2023.06.07.11.10.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Jun 2023 11:10:55 -0700 (PDT)
From:   Alexander Mikhalitsyn <aleksandr.mikhalitsyn@canonical.com>
To:     xiubli@redhat.com
Cc:     brauner@kernel.org, stgraber@ubuntu.com,
        linux-fsdevel@vger.kernel.org,
        Alexander Mikhalitsyn <aleksandr.mikhalitsyn@canonical.com>,
        Jeff Layton <jlayton@kernel.org>,
        Ilya Dryomov <idryomov@gmail.com>, ceph-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v4 10/14] ceph: pass idmap to __ceph_setattr
Date:   Wed,  7 Jun 2023 20:09:53 +0200
Message-Id: <20230607180958.645115-11-aleksandr.mikhalitsyn@canonical.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230607180958.645115-1-aleksandr.mikhalitsyn@canonical.com>
References: <20230607180958.645115-1-aleksandr.mikhalitsyn@canonical.com>
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

Just pass down the mount's idmapping to __ceph_setattr,
because we will need it later.

Cc: Xiubo Li <xiubli@redhat.com>
Cc: Jeff Layton <jlayton@kernel.org>
Cc: Ilya Dryomov <idryomov@gmail.com>
Cc: brauner@kernel.org
Cc: ceph-devel@vger.kernel.org
Signed-off-by: Alexander Mikhalitsyn <aleksandr.mikhalitsyn@canonical.com>
---
 fs/ceph/acl.c   | 4 ++--
 fs/ceph/inode.c | 5 +++--
 fs/ceph/super.h | 3 ++-
 3 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/fs/ceph/acl.c b/fs/ceph/acl.c
index 6945a938d396..51ffef848429 100644
--- a/fs/ceph/acl.c
+++ b/fs/ceph/acl.c
@@ -140,7 +140,7 @@ int ceph_set_acl(struct mnt_idmap *idmap, struct dentry *dentry,
 		newattrs.ia_ctime = current_time(inode);
 		newattrs.ia_mode = new_mode;
 		newattrs.ia_valid = ATTR_MODE | ATTR_CTIME;
-		ret = __ceph_setattr(inode, &newattrs);
+		ret = __ceph_setattr(idmap, inode, &newattrs);
 		if (ret)
 			goto out_free;
 	}
@@ -151,7 +151,7 @@ int ceph_set_acl(struct mnt_idmap *idmap, struct dentry *dentry,
 			newattrs.ia_ctime = old_ctime;
 			newattrs.ia_mode = old_mode;
 			newattrs.ia_valid = ATTR_MODE | ATTR_CTIME;
-			__ceph_setattr(inode, &newattrs);
+			__ceph_setattr(idmap, inode, &newattrs);
 		}
 		goto out_free;
 	}
diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
index 37e1cbfc7c89..bcd9b506ec3b 100644
--- a/fs/ceph/inode.c
+++ b/fs/ceph/inode.c
@@ -2009,7 +2009,8 @@ static const struct inode_operations ceph_symlink_iops = {
 	.listxattr = ceph_listxattr,
 };
 
-int __ceph_setattr(struct inode *inode, struct iattr *attr)
+int __ceph_setattr(struct mnt_idmap *idmap, struct inode *inode,
+		   struct iattr *attr)
 {
 	struct ceph_inode_info *ci = ceph_inode(inode);
 	unsigned int ia_valid = attr->ia_valid;
@@ -2252,7 +2253,7 @@ int ceph_setattr(struct mnt_idmap *idmap, struct dentry *dentry,
 	    ceph_quota_is_max_bytes_exceeded(inode, attr->ia_size))
 		return -EDQUOT;
 
-	err = __ceph_setattr(inode, attr);
+	err = __ceph_setattr(idmap, inode, attr);
 
 	if (err >= 0 && (attr->ia_valid & ATTR_MODE))
 		err = posix_acl_chmod(&nop_mnt_idmap, dentry, attr->ia_mode);
diff --git a/fs/ceph/super.h b/fs/ceph/super.h
index d24bf0db5234..d9cc27307cb7 100644
--- a/fs/ceph/super.h
+++ b/fs/ceph/super.h
@@ -1052,7 +1052,8 @@ static inline int ceph_do_getattr(struct inode *inode, int mask, bool force)
 }
 extern int ceph_permission(struct mnt_idmap *idmap,
 			   struct inode *inode, int mask);
-extern int __ceph_setattr(struct inode *inode, struct iattr *attr);
+extern int __ceph_setattr(struct mnt_idmap *idmap, struct inode *inode,
+			  struct iattr *attr);
 extern int ceph_setattr(struct mnt_idmap *idmap,
 			struct dentry *dentry, struct iattr *attr);
 extern int ceph_getattr(struct mnt_idmap *idmap,
-- 
2.34.1

