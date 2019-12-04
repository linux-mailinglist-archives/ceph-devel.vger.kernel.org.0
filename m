Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4A31C1121C6
	for <lists+ceph-devel@lfdr.de>; Wed,  4 Dec 2019 04:10:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726917AbfLDDKQ (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 3 Dec 2019 22:10:16 -0500
Received: from mail-pf1-f196.google.com ([209.85.210.196]:36607 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726804AbfLDDKQ (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 3 Dec 2019 22:10:16 -0500
Received: by mail-pf1-f196.google.com with SMTP id b19so2868376pfd.3;
        Tue, 03 Dec 2019 19:10:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=yiyDDHELLu91Yg2Toujn+sD7fMeLzTV+cltZc+zA9ok=;
        b=SgPTXfpx0nRKHkWNSTnPfkqt1Fe1WuYLfr7WaWvijqmGsmRMtpgYhZiKRNgy0Hn1Gk
         FQa/Wx0lCd+jkf0YkIrTxpAzzIR2EqpFU5yyAen4IuNsDtPF8uMxKG8rgdXJhKZNF9ut
         MMW1QnmvSmoANhn/j+iCewDFoyHFHp8lNSWbPXy6BkLaydzBKx4eg+aKwHQOacKrMtBN
         FRig1GHyhem4ReVJOQ6E9LhmCVc2Fix0PDjuaaq3JgeeWbVjNcr/t8Cc2K+Bfynme90F
         QfaHitLStq8ykhrzw1XE0cmXg4Eb++qXaPsXiKvg8dnfdNIMtGLSUOmup7BLJMF+Yh5p
         9vuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=yiyDDHELLu91Yg2Toujn+sD7fMeLzTV+cltZc+zA9ok=;
        b=njkokoFItxH4BuEChU/hz+qiqSAXzHlCMwd6M4dhJ0t/zFYzePUg5bTT+zBDuHfa4O
         h0fdldxRJUzJ402DOHDb39eUfiEAQw3mFWVMg1vwncbC5nSHVYmwAzz4dyFsQv4FOCfT
         O0QN3cTzyioroxFqH0f0iGrwti6THqwI0Cv9bpxQu+9pCdwsCFy/6xp38oeiXdBnV6qW
         ip9yrfzNZI6THHEZODiAO2RKUfp3kZJwYSqCA4BSwF+tpKIxTJmmE4NOd9fuGcoJhhc+
         T2x01vsFdtbVpV6FkFsGMhy8IULzAkLIHFE0Og6Zsw+wFf4gaIAn/M9ZCdW33x1WZiel
         ZM7Q==
X-Gm-Message-State: APjAAAWtTzn5eSkLhfC6JPIqhMsEjBGK7KaVPvgjGGn9bCDdnrhefhWb
        PJlbnmreuIWeNbY955Jafjs=
X-Google-Smtp-Source: APXvYqxeIQRBA0Yrk5XUXzy4fTVh5A8rdb4VMC9xb46PwQWepX1G479M+lHNy330e96tMuCMNr4NKw==
X-Received: by 2002:aa7:8a8b:: with SMTP id a11mr1306022pfc.207.1575429015536;
        Tue, 03 Dec 2019 19:10:15 -0800 (PST)
Received: from MacBook-Pro.jd.com ([111.200.23.19])
        by smtp.googlemail.com with ESMTPSA id 20sm4747289pgw.71.2019.12.03.19.10.12
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 03 Dec 2019 19:10:15 -0800 (PST)
From:   Yanhu Cao <gmayyyha@gmail.com>
To:     jlayton@kernel.org
Cc:     sage@redhat.com, idryomov@gmail.com, ceph-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org, Yanhu Cao <gmayyyha@gmail.com>
Subject: [PATCH] ceph: check set quota operation support before syncing setxattr.
Date:   Wed,  4 Dec 2019 11:10:05 +0800
Message-Id: <20191204031005.2638-1-gmayyyha@gmail.com>
X-Mailer: git-send-email 2.21.0 (Apple Git-122.2)
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Environment
-----------
ceph version: 12.2.*
kernel version: 4.19+

setfattr quota operation actually sends op to MDS, and settings
effective. but kclient outputs 'Operation not supported'. This may confuse
users' understandings.

If the kernel version and ceph version are not compatible, should check
quota operations are supported first, then do sync_setxattr.

reference: https://docs.ceph.com/docs/master/cephfs/quota/

Signed-off-by: Yanhu Cao <gmayyyha@gmail.com>
---
 fs/ceph/xattr.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/ceph/xattr.c b/fs/ceph/xattr.c
index cb18ee637cb7..189aace75186 100644
--- a/fs/ceph/xattr.c
+++ b/fs/ceph/xattr.c
@@ -1132,8 +1132,8 @@ int __ceph_setxattr(struct inode *inode, const char *name,
 				    "during filling trace\n", inode);
 		err = -EBUSY;
 	} else {
-		err = ceph_sync_setxattr(inode, name, value, size, flags);
-		if (err >= 0 && check_realm) {
+		err = 0;
+		if (check_realm) {
 			/* check if snaprealm was created for quota inode */
 			spin_lock(&ci->i_ceph_lock);
 			if ((ci->i_max_files || ci->i_max_bytes) &&
@@ -1142,6 +1142,8 @@ int __ceph_setxattr(struct inode *inode, const char *name,
 				err = -EOPNOTSUPP;
 			spin_unlock(&ci->i_ceph_lock);
 		}
+		if (err == 0)
+			err = ceph_sync_setxattr(inode, name, value, size, flags);
 	}
 out:
 	ceph_free_cap_flush(prealloc_cf);
-- 
2.21.0 (Apple Git-122.2)

