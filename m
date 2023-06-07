Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 13A0172643A
	for <lists+ceph-devel@lfdr.de>; Wed,  7 Jun 2023 17:22:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241115AbjFGPWo (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 7 Jun 2023 11:22:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241364AbjFGPWB (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 7 Jun 2023 11:22:01 -0400
Received: from smtp-relay-internal-1.canonical.com (smtp-relay-internal-1.canonical.com [185.125.188.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 841FC26A5
        for <ceph-devel@vger.kernel.org>; Wed,  7 Jun 2023 08:21:41 -0700 (PDT)
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com [209.85.208.71])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id D046F3F0E8
        for <ceph-devel@vger.kernel.org>; Wed,  7 Jun 2023 15:21:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1686151298;
        bh=UUJj01wMEQ1oyKBsNssb6jfIoqp09AUl4ugwx+FKVfQ=;
        h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
         MIME-Version;
        b=TIw6UWtnr1SLhxTjMs49RToBvNaTUkQRCMvoPMPcFRbFlIJx0STyIwzHfUBWMjNqr
         0PMkD1hiBoSyaWOuwjIS8zMsp+gpScDAltaC82h2QbdkuWADNkEwlPK/tUdRGZWMkY
         OzQtkhsjbOv+2AZdS43uYVvo92AfUXJmW9WeDG71x/K+R/0zRHVDK+6ZlgbGDQswRC
         peM5rG23FWikxBeOglvDspXh/ROdWbwvaQvnKE2OlZfRTCOF4T2z4bp/u3N49MGX08
         90R0dqeETJHL8jiwwewGt8GQ65iAXuhLOZUvdRTGLOGXH6oPaI3kNlaBncn40OmxLs
         CVdKJCwL9u7mg==
Received: by mail-ed1-f71.google.com with SMTP id 4fb4d7f45d1cf-5163c33e60bso1005167a12.1
        for <ceph-devel@vger.kernel.org>; Wed, 07 Jun 2023 08:21:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686151298; x=1688743298;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=UUJj01wMEQ1oyKBsNssb6jfIoqp09AUl4ugwx+FKVfQ=;
        b=QQV6Iu/I8VEe1Lk19a1OnPEw9cTEbA5OLJvHUl7O8r6sCLbFg4FV1gjcH/34iKbJ2n
         Oj8cSqiobXccbnyweA5z4yOqMn7PSSvQ6p+dBnfLAxlD7pK21fh16IeYlZvgZrOw1st6
         xNALDEmYkpGNSSN+wXEdWYhA+Ue2h2aL7yOCJATtHoGPDov8iaAGatywP9+VFFWbW5Gg
         qpmJb7IEvaM48kg36D3MRVCkQalP8W8NLR9d5C7sjsYrTnfoMT1192ObhC5+rQz+619y
         yWaqNbQ/9/A4xl0pSMic3wtl/noCT/d1tAArp/0yYVozY4uZ9FZpPkeInjrV3NDiiJsQ
         h5dw==
X-Gm-Message-State: AC+VfDynKefdUdadiRltRZq5ROLJvUJ2Uw2QmYB2D3xu92LGe9tnuVFd
        P1X7lok1yo6wZPlidYKfLTRKfboGVMnCi6kDezrVM3Q7+2c1J4NilFPZCgwbJpXgegO59M0szmZ
        9gpuNsF4VxGL2xCi7SywafwRYmO0g3vU17nIHxjI=
X-Received: by 2002:a05:6402:40d5:b0:514:387c:930 with SMTP id z21-20020a05640240d500b00514387c0930mr17584292edb.5.1686151298003;
        Wed, 07 Jun 2023 08:21:38 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ7l6JO7AWSlX/GunI0jDchwoV1/AcewroDVdILxl58nOntYmpe+COF6muPeK4aR5QqY6js67A==
X-Received: by 2002:a05:6402:40d5:b0:514:387c:930 with SMTP id z21-20020a05640240d500b00514387c0930mr17584281edb.5.1686151297801;
        Wed, 07 Jun 2023 08:21:37 -0700 (PDT)
Received: from amikhalitsyn.local (dslb-002-205-064-187.002.205.pools.vodafone-ip.de. [2.205.64.187])
        by smtp.gmail.com with ESMTPSA id w17-20020a056402129100b005147503a238sm6263441edv.17.2023.06.07.08.21.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Jun 2023 08:21:37 -0700 (PDT)
From:   Alexander Mikhalitsyn <aleksandr.mikhalitsyn@canonical.com>
To:     xiubli@redhat.com
Cc:     brauner@kernel.org, stgraber@ubuntu.com,
        linux-fsdevel@vger.kernel.org,
        Alexander Mikhalitsyn <aleksandr.mikhalitsyn@canonical.com>,
        Jeff Layton <jlayton@kernel.org>,
        Ilya Dryomov <idryomov@gmail.com>, ceph-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v3 10/14] ceph: pass idmap to __ceph_setattr
Date:   Wed,  7 Jun 2023 17:20:34 +0200
Message-Id: <20230607152038.469739-11-aleksandr.mikhalitsyn@canonical.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230607152038.469739-1-aleksandr.mikhalitsyn@canonical.com>
References: <20230607152038.469739-1-aleksandr.mikhalitsyn@canonical.com>
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

