Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5857876EB93
	for <lists+ceph-devel@lfdr.de>; Thu,  3 Aug 2023 16:01:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236628AbjHCOBa (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 3 Aug 2023 10:01:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234321AbjHCOBV (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 3 Aug 2023 10:01:21 -0400
Received: from smtp-relay-internal-0.canonical.com (smtp-relay-internal-0.canonical.com [185.125.188.122])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F9432D43
        for <ceph-devel@vger.kernel.org>; Thu,  3 Aug 2023 07:00:43 -0700 (PDT)
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com [209.85.208.72])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-0.canonical.com (Postfix) with ESMTPS id 0B83542479
        for <ceph-devel@vger.kernel.org>; Thu,  3 Aug 2023 14:00:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1691071221;
        bh=9W3amFuCFaMdLEZWgVp07pDZ7km3dCVDUs8gQZd55IA=;
        h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
         MIME-Version:Content-Type;
        b=ZfLQ7d/coFIGTAiabuzKvyh3jTxGGdSP6hTasz+TsZZyZzVB81Os76ZVo+5a5/fMr
         hPyvjFYHBC85tbd6bE0EnniQL/x89N/gQS7Iraayrp4V+PVE/kAt3REiA3gBvV/jO7
         0vVxvIK1nV/3fP30/m4btNFvH/CeFtfXb76LVeclv8IP1ADgbry+Lt4PXXZ5UE1E9l
         5objCIIQeiuq1yWrKmNO3HnpOP3CJQfezFh3WIoUBebnCx0jDaIiT27JagFAjNivHs
         BBdtCEc70vBWU9kz873R2lWp8pfYWriYgFnezd1xdRt0S3X2qDrxTCl5NR7gxOo1sM
         NNbu+kDHs9OaA==
Received: by mail-ed1-f72.google.com with SMTP id 4fb4d7f45d1cf-5218b9647a8so681754a12.1
        for <ceph-devel@vger.kernel.org>; Thu, 03 Aug 2023 07:00:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691071220; x=1691676020;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9W3amFuCFaMdLEZWgVp07pDZ7km3dCVDUs8gQZd55IA=;
        b=IjbujXEtDpM+Jf0FrP6PaAUo8XnUx+pBB5bm0pOM984HMV5yWy9fY6zn1YeunN/8Ur
         idvqJMRV8Qu6XPOEep/SjF1UmIa7p678pynoniybs3+2GhZV1Yi2ZGjNYd/x/NXMRMAK
         xd8vifH2HILilMq6695TTCklyPC9btyG/s1hKAKEqJWfvxBu9Ddj8Luzpw+uUe9OVhoq
         jEkGGzrEdgS+PlmWAg475fO+dh9HRON4TOXI8i4KPc+FP0jub4F0avGquMTr/f3KWY5u
         wSMsOa3pceXhM1CmsYQLogQp/V01MH4PjQZMv4ZWNNyNKOKwW6VZ6g7pC7zJLGaO+cUM
         wqMg==
X-Gm-Message-State: ABy/qLahRL/f0aWtMcVjKKbV0TGN3cE9g3N2vJWI/loSO7w/1LXviYvU
        kyhVOTngvJjz9VHutLVtYsu5A+mpeoA2e+wIWcJQpdAV72ymAbRZuIUIAh/PMQ7C6XQvkE/mXcM
        NKukKE7OEESQl2XmRt9ga3GCOpm15oKm6G3uouLc=
X-Received: by 2002:a50:fa8d:0:b0:522:38cb:d8cb with SMTP id w13-20020a50fa8d000000b0052238cbd8cbmr6675508edr.20.1691071220747;
        Thu, 03 Aug 2023 07:00:20 -0700 (PDT)
X-Google-Smtp-Source: APBJJlFSUBGl00xYVgZu1n5QXjWGAchYdp2zZyXd+HoKtwgE5xEvzgdLvZUVhlHU8FZGINndDOCSng==
X-Received: by 2002:a50:fa8d:0:b0:522:38cb:d8cb with SMTP id w13-20020a50fa8d000000b0052238cbd8cbmr6675499edr.20.1691071220564;
        Thu, 03 Aug 2023 07:00:20 -0700 (PDT)
Received: from amikhalitsyn.local (dslb-088-066-182-192.088.066.pools.vodafone-ip.de. [88.66.182.192])
        by smtp.gmail.com with ESMTPSA id bc21-20020a056402205500b0052229882fb0sm10114822edb.71.2023.08.03.07.00.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Aug 2023 07:00:20 -0700 (PDT)
From:   Alexander Mikhalitsyn <aleksandr.mikhalitsyn@canonical.com>
To:     xiubli@redhat.com
Cc:     brauner@kernel.org, stgraber@ubuntu.com,
        linux-fsdevel@vger.kernel.org, Jeff Layton <jlayton@kernel.org>,
        Ilya Dryomov <idryomov@gmail.com>, ceph-devel@vger.kernel.org,
        Alexander Mikhalitsyn <aleksandr.mikhalitsyn@canonical.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v8 04/12] ceph: add enable_unsafe_idmap module parameter
Date:   Thu,  3 Aug 2023 15:59:47 +0200
Message-Id: <20230803135955.230449-5-aleksandr.mikhalitsyn@canonical.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230803135955.230449-1-aleksandr.mikhalitsyn@canonical.com>
References: <20230803135955.230449-1-aleksandr.mikhalitsyn@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

This parameter is used to decide if we allow
to perform IO on idmapped mount in case when MDS lacks
support of CEPHFS_FEATURE_HAS_OWNER_UIDGID feature.

In this case we can't properly handle MDS permission
checks and if UID/GID-based restrictions are enabled
on the MDS side then IO requests which go through an
idmapped mount may fail with -EACCESS/-EPERM.
Fortunately, for most of users it's not a case and
everything should work fine. But we put work "unsafe"
in the module parameter name to warn users about
possible problems with this feature and encourage
update of cephfs MDS.

Cc: Xiubo Li <xiubli@redhat.com>
Cc: Jeff Layton <jlayton@kernel.org>
Cc: Ilya Dryomov <idryomov@gmail.com>
Cc: ceph-devel@vger.kernel.org
Suggested-by: Stéphane Graber <stgraber@ubuntu.com>
Signed-off-by: Alexander Mikhalitsyn <aleksandr.mikhalitsyn@canonical.com>
---
 fs/ceph/mds_client.c | 28 +++++++++++++++++++++-------
 fs/ceph/mds_client.h |  2 ++
 fs/ceph/super.c      |  5 +++++
 3 files changed, 28 insertions(+), 7 deletions(-)

diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
index 7d3106d3b726..d8097e84a5ee 100644
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -2949,6 +2949,8 @@ static struct ceph_msg *create_request_message(struct ceph_mds_session *session,
 	int ret;
 	bool legacy = !(session->s_con.peer_features & CEPH_FEATURE_FS_BTIME);
 	u16 request_head_version = mds_supported_head_version(session);
+	kuid_t caller_fsuid = req->r_cred->fsuid;
+	kgid_t caller_fsgid = req->r_cred->fsgid;
 
 	ret = set_request_path_attr(mdsc, req->r_inode, req->r_dentry,
 			      req->r_parent, req->r_path1, req->r_ino1.ino,
@@ -3044,12 +3046,24 @@ static struct ceph_msg *create_request_message(struct ceph_mds_session *session,
 
 	if ((req->r_mnt_idmap != &nop_mnt_idmap) &&
 	    !test_bit(CEPHFS_FEATURE_HAS_OWNER_UIDGID, &session->s_features)) {
-		pr_err_ratelimited_client(cl,
-			"idmapped mount is used and CEPHFS_FEATURE_HAS_OWNER_UIDGID"
-			" is not supported by MDS. Fail request with -EIO.\n");
+		if (enable_unsafe_idmap) {
+			pr_warn_once_client(cl,
+				"idmapped mount is used and CEPHFS_FEATURE_HAS_OWNER_UIDGID"
+				" is not supported by MDS. UID/GID-based restrictions may"
+				" not work properly.\n");
+
+			caller_fsuid = from_vfsuid(req->r_mnt_idmap, &init_user_ns,
+						   VFSUIDT_INIT(req->r_cred->fsuid));
+			caller_fsgid = from_vfsgid(req->r_mnt_idmap, &init_user_ns,
+						   VFSGIDT_INIT(req->r_cred->fsgid));
+		} else {
+			pr_err_ratelimited_client(cl,
+				"idmapped mount is used and CEPHFS_FEATURE_HAS_OWNER_UIDGID"
+				" is not supported by MDS. Fail request with -EIO.\n");
 
-		ret = -EIO;
-		goto out_err;
+			ret = -EIO;
+			goto out_err;
+		}
 	}
 
 	/*
@@ -3094,9 +3108,9 @@ static struct ceph_msg *create_request_message(struct ceph_mds_session *session,
 	lhead->mdsmap_epoch = cpu_to_le32(mdsc->mdsmap->m_epoch);
 	lhead->op = cpu_to_le32(req->r_op);
 	lhead->caller_uid = cpu_to_le32(from_kuid(&init_user_ns,
-						  req->r_cred->fsuid));
+						  caller_fsuid));
 	lhead->caller_gid = cpu_to_le32(from_kgid(&init_user_ns,
-						  req->r_cred->fsgid));
+						  caller_fsgid));
 	lhead->ino = cpu_to_le64(req->r_deleg_ino);
 	lhead->args = req->r_args;
 
diff --git a/fs/ceph/mds_client.h b/fs/ceph/mds_client.h
index 8f683e8203bd..0945ae4cf3c5 100644
--- a/fs/ceph/mds_client.h
+++ b/fs/ceph/mds_client.h
@@ -619,4 +619,6 @@ static inline int ceph_wait_on_async_create(struct inode *inode)
 extern int ceph_wait_on_conflict_unlink(struct dentry *dentry);
 extern u64 ceph_get_deleg_ino(struct ceph_mds_session *session);
 extern int ceph_restore_deleg_ino(struct ceph_mds_session *session, u64 ino);
+
+extern bool enable_unsafe_idmap;
 #endif
diff --git a/fs/ceph/super.c b/fs/ceph/super.c
index 49fd17fbba9f..18bfdfd48cef 100644
--- a/fs/ceph/super.c
+++ b/fs/ceph/super.c
@@ -1680,6 +1680,11 @@ static const struct kernel_param_ops param_ops_mount_syntax = {
 module_param_cb(mount_syntax_v1, &param_ops_mount_syntax, &mount_support, 0444);
 module_param_cb(mount_syntax_v2, &param_ops_mount_syntax, &mount_support, 0444);
 
+bool enable_unsafe_idmap = false;
+module_param(enable_unsafe_idmap, bool, 0644);
+MODULE_PARM_DESC(enable_unsafe_idmap,
+		 "Allow to use idmapped mounts with MDS without CEPHFS_FEATURE_HAS_OWNER_UIDGID");
+
 module_init(init_ceph);
 module_exit(exit_ceph);
 
-- 
2.34.1

