Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 69B967725C0
	for <lists+ceph-devel@lfdr.de>; Mon,  7 Aug 2023 15:30:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234023AbjHGNaG (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 7 Aug 2023 09:30:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234021AbjHGN3U (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 7 Aug 2023 09:29:20 -0400
Received: from smtp-relay-internal-0.canonical.com (smtp-relay-internal-0.canonical.com [185.125.188.122])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C67182125
        for <ceph-devel@vger.kernel.org>; Mon,  7 Aug 2023 06:28:59 -0700 (PDT)
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com [209.85.218.70])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-0.canonical.com (Postfix) with ESMTPS id D324B4427D
        for <ceph-devel@vger.kernel.org>; Mon,  7 Aug 2023 13:28:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1691414906;
        bh=EnTEEZ7+oa3hM+NWnyW7RuhD3+Wjh3nw4+rmmgyNCZM=;
        h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
         MIME-Version;
        b=ovghgD12bm8Jm/QhqbujjFl6/X/qqYdXZX6HxCO57azpNFahRgYaRszemN5OdNQAN
         nsA0ii9zvDlVaQWVpITX7r13JGBBkg0gTgtxITxGi6A2eihxedWLUKGcoEFWtgCr/T
         7gt+0bAg7C3w0kukiQz0ljbwjgGOnE5FzW+GqyaqNClR7HbAhRv3yIElyXOP6lgynN
         jOu8S9nIWL4GPYvIS1Bs+E9mCDY+a4geHGoP2a6UX5YyO+zEdsVr3jcHSy/jjnDfnU
         nrmrIhCmfn+M1WNPUVUkLd+KcyRxeJpCyqJY8GAGb9jb93Y4K0n95Ob9zCkwjUzZZx
         p37Wh5VHuuZbA==
Received: by mail-ej1-f70.google.com with SMTP id a640c23a62f3a-94a355cf318so362497566b.2
        for <ceph-devel@vger.kernel.org>; Mon, 07 Aug 2023 06:28:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691414905; x=1692019705;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=EnTEEZ7+oa3hM+NWnyW7RuhD3+Wjh3nw4+rmmgyNCZM=;
        b=BgAq0Y/jKTA4/NUTlgl/+R5BIKl1Vm70Eu2uu11oUZwcu4Kx5d3weKBhAbdzrU8C9R
         duWVGviwbHfQ3hky6TaYSyhCj/ylnhEubhw7R8l26Bx8uuxKzkaXSI34v747+5qq+H6e
         0zONnY7G7kP4JyeSuJB8YgxEwBdZZWweBIMUgb+XzND4kQN0yRix8mX5wVm00RCx02Hy
         qWs/CmBLukI5WBiBeddH0TBjBzz1tiofweWUbD++ZKiu7ENHWVg7Eogn0iJ05DlQQZ/L
         F0PFrru2dncEfaEZ+hiHXwk9wndg29erJPS4qsmoABlDh1PTThQbYwANEm6vSiEgKKcl
         sk+g==
X-Gm-Message-State: AOJu0YyMyc0BW0Gz5fjAWW143xK8ac9RWoeHTkMSyaHdBZGiGLj1Khku
        kzPXx4jIxoh8j375hEu1RE6qFMCBLa0kmhWdzKLnpzliXH9hinECzYSJpy9ecLsPmP9+OJEykiY
        ApZrXED1+M9nExgF3aQigd3atIrwI1Xk4QyCo83Y=
X-Received: by 2002:a17:906:d6:b0:99b:ed8f:551d with SMTP id 22-20020a17090600d600b0099bed8f551dmr8792969eji.55.1691414905241;
        Mon, 07 Aug 2023 06:28:25 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHPYr2Sn/4wtYZpvSbkMFiW8P3TR0v/BNNt8ZkylTWoSaA6YpZQj1j2zTP+kTyapQ44F3q4cQ==
X-Received: by 2002:a17:906:d6:b0:99b:ed8f:551d with SMTP id 22-20020a17090600d600b0099bed8f551dmr8792958eji.55.1691414905079;
        Mon, 07 Aug 2023 06:28:25 -0700 (PDT)
Received: from amikhalitsyn.local (dslb-088-066-182-192.088.066.pools.vodafone-ip.de. [88.66.182.192])
        by smtp.gmail.com with ESMTPSA id lg12-20020a170906f88c00b00992ca779f42sm5175257ejb.97.2023.08.07.06.28.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Aug 2023 06:28:24 -0700 (PDT)
From:   Alexander Mikhalitsyn <aleksandr.mikhalitsyn@canonical.com>
To:     xiubli@redhat.com
Cc:     brauner@kernel.org, stgraber@ubuntu.com,
        linux-fsdevel@vger.kernel.org, Jeff Layton <jlayton@kernel.org>,
        Ilya Dryomov <idryomov@gmail.com>, ceph-devel@vger.kernel.org,
        Alexander Mikhalitsyn <aleksandr.mikhalitsyn@canonical.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v10 08/12] ceph: pass idmap to __ceph_setattr
Date:   Mon,  7 Aug 2023 15:26:22 +0200
Message-Id: <20230807132626.182101-9-aleksandr.mikhalitsyn@canonical.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230807132626.182101-1-aleksandr.mikhalitsyn@canonical.com>
References: <20230807132626.182101-1-aleksandr.mikhalitsyn@canonical.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
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
Cc: Christian Brauner <brauner@kernel.org>
Cc: ceph-devel@vger.kernel.org
Signed-off-by: Alexander Mikhalitsyn <aleksandr.mikhalitsyn@canonical.com>
Acked-by: Christian Brauner <brauner@kernel.org>
---
 fs/ceph/acl.c    | 4 ++--
 fs/ceph/crypto.c | 2 +-
 fs/ceph/inode.c  | 5 +++--
 fs/ceph/super.h  | 3 ++-
 4 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/fs/ceph/acl.c b/fs/ceph/acl.c
index 32b26deb1741..89280c168acb 100644
--- a/fs/ceph/acl.c
+++ b/fs/ceph/acl.c
@@ -142,7 +142,7 @@ int ceph_set_acl(struct mnt_idmap *idmap, struct dentry *dentry,
 		newattrs.ia_ctime = current_time(inode);
 		newattrs.ia_mode = new_mode;
 		newattrs.ia_valid = ATTR_MODE | ATTR_CTIME;
-		ret = __ceph_setattr(inode, &newattrs, NULL);
+		ret = __ceph_setattr(idmap, inode, &newattrs, NULL);
 		if (ret)
 			goto out_free;
 	}
@@ -153,7 +153,7 @@ int ceph_set_acl(struct mnt_idmap *idmap, struct dentry *dentry,
 			newattrs.ia_ctime = old_ctime;
 			newattrs.ia_mode = old_mode;
 			newattrs.ia_valid = ATTR_MODE | ATTR_CTIME;
-			__ceph_setattr(inode, &newattrs, NULL);
+			__ceph_setattr(idmap, inode, &newattrs, NULL);
 		}
 		goto out_free;
 	}
diff --git a/fs/ceph/crypto.c b/fs/ceph/crypto.c
index b9071bba3b08..8cf32e7f59bf 100644
--- a/fs/ceph/crypto.c
+++ b/fs/ceph/crypto.c
@@ -112,7 +112,7 @@ static int ceph_crypt_set_context(struct inode *inode, const void *ctx, size_t l
 
 	cia.fscrypt_auth = cfa;
 
-	ret = __ceph_setattr(inode, &attr, &cia);
+	ret = __ceph_setattr(&nop_mnt_idmap, inode, &attr, &cia);
 	if (ret == 0)
 		inode_set_flags(inode, S_ENCRYPTED, S_ENCRYPTED);
 	kfree(cia.fscrypt_auth);
diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
index 9b50861bd2b5..6c4cc009d819 100644
--- a/fs/ceph/inode.c
+++ b/fs/ceph/inode.c
@@ -2466,7 +2466,8 @@ static int fill_fscrypt_truncate(struct inode *inode,
 	return ret;
 }
 
-int __ceph_setattr(struct inode *inode, struct iattr *attr, struct ceph_iattr *cia)
+int __ceph_setattr(struct mnt_idmap *idmap, struct inode *inode,
+		   struct iattr *attr, struct ceph_iattr *cia)
 {
 	struct ceph_inode_info *ci = ceph_inode(inode);
 	unsigned int ia_valid = attr->ia_valid;
@@ -2818,7 +2819,7 @@ int ceph_setattr(struct mnt_idmap *idmap, struct dentry *dentry,
 	    ceph_quota_is_max_bytes_exceeded(inode, attr->ia_size))
 		return -EDQUOT;
 
-	err = __ceph_setattr(inode, attr, NULL);
+	err = __ceph_setattr(idmap, inode, attr, NULL);
 
 	if (err >= 0 && (attr->ia_valid & ATTR_MODE))
 		err = posix_acl_chmod(&nop_mnt_idmap, dentry, attr->ia_mode);
diff --git a/fs/ceph/super.h b/fs/ceph/super.h
index 4e78de1be23e..e729cde7b4a0 100644
--- a/fs/ceph/super.h
+++ b/fs/ceph/super.h
@@ -1101,7 +1101,8 @@ struct ceph_iattr {
 	struct ceph_fscrypt_auth	*fscrypt_auth;
 };
 
-extern int __ceph_setattr(struct inode *inode, struct iattr *attr, struct ceph_iattr *cia);
+extern int __ceph_setattr(struct mnt_idmap *idmap, struct inode *inode,
+			  struct iattr *attr, struct ceph_iattr *cia);
 extern int ceph_setattr(struct mnt_idmap *idmap,
 			struct dentry *dentry, struct iattr *attr);
 extern int ceph_getattr(struct mnt_idmap *idmap,
-- 
2.34.1

