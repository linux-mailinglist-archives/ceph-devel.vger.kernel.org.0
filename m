Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 64BBB72642D
	for <lists+ceph-devel@lfdr.de>; Wed,  7 Jun 2023 17:22:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241243AbjFGPWE (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 7 Jun 2023 11:22:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241370AbjFGPVn (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 7 Jun 2023 11:21:43 -0400
Received: from smtp-relay-internal-1.canonical.com (smtp-relay-internal-1.canonical.com [185.125.188.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13F81211C
        for <ceph-devel@vger.kernel.org>; Wed,  7 Jun 2023 08:21:31 -0700 (PDT)
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com [209.85.208.69])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id 84A383F154
        for <ceph-devel@vger.kernel.org>; Wed,  7 Jun 2023 15:21:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1686151290;
        bh=MB2dlVGrYJEf0FHstDBST6Gse7KSG/9oFtyn7KqGZB0=;
        h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
         MIME-Version;
        b=YYsv9u0e1b+mPCkR3k9mK/3oE/Aox7728emkZ0lgzl4HUhJOHC5H//qMssRfX+W7+
         diKZC8jWww2oTa1TbB15tCSs4Dy6Mi2VoeynFJ+jAbPP1X7tAobzpK44gv3fNnPsqL
         ZkLdm/G9NOJuJ8IH8DCufUgMdirUiaUiDMHj551XJVO2aZzh2NIwF4NfaFfoYiCKAM
         5kAvWnX+/rFcaccsjpsDoLoHz/f0uE7nxnh8dAutAn5Y+It4iS099goUZ59Ga74cz6
         pxyWAWraezt7kTzVmjsehNKPHGLc+8AfnY/VwbmtFgg0sqbBS5eVuQZgUTMhDKF3td
         GYC9ppNG9vXxA==
Received: by mail-ed1-f69.google.com with SMTP id 4fb4d7f45d1cf-514abe67064so1067155a12.0
        for <ceph-devel@vger.kernel.org>; Wed, 07 Jun 2023 08:21:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686151290; x=1688743290;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=MB2dlVGrYJEf0FHstDBST6Gse7KSG/9oFtyn7KqGZB0=;
        b=ceeTX/KNLtCMP0cC8Yy5tcm29rf9mewdwY/b+tHwJEUH1Mok/XiyiwODs1iC2DWX6v
         cWAolRuVlyHggscz6GmhlUs0VZvAbIhY/yQPOyzy1yuCMNRxd5RYjHJl5mgfkJYP7UU4
         K8bmpq5JftuUXQZHJ3jB2bEpMi79JEoEn7OjGElfTpiRQZQafl8PhHCzgUx4bGGV7aRI
         MQfDjhkH9qKKwOpiUGxS+Ox7PLaCnRoeA7vO0vEXaSfW4nqyiqq6nAZv44Zu1HVpgl5Q
         KDOxRKJtM8+lSYu2PjX+nihiK5AxgIkazVQ+TgwzvZF/+7zz+X7etRd3UTfayyggunsB
         /gQQ==
X-Gm-Message-State: AC+VfDwPBVGjHKmdzpl3TY1W6CM46Lhkh4ndE7fgcbvW9pLu/vKsDep4
        qKRwQhDtl+CWn3hiK0ogvYFbxu+AFgL1L22ZGG/wuQ2CsA7MPUrD6VA3uDqHjBPD+6KE/loyFWs
        Wj0+x3pau1JD0qQ5+WmQ1eNX2IdfrHbj4OXhL6XI=
X-Received: by 2002:a05:6402:2cd:b0:514:ae18:162e with SMTP id b13-20020a05640202cd00b00514ae18162emr4253315edx.35.1686151290091;
        Wed, 07 Jun 2023 08:21:30 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ7jqqC9xVaRdu5/WUQNipAd3BmNtD1Mb5LzMQCfal+HfUkomm8HFG0027rulz8j1EMzFRM8XA==
X-Received: by 2002:a05:6402:2cd:b0:514:ae18:162e with SMTP id b13-20020a05640202cd00b00514ae18162emr4253302edx.35.1686151289897;
        Wed, 07 Jun 2023 08:21:29 -0700 (PDT)
Received: from amikhalitsyn.local (dslb-002-205-064-187.002.205.pools.vodafone-ip.de. [2.205.64.187])
        by smtp.gmail.com with ESMTPSA id w17-20020a056402129100b005147503a238sm6263441edv.17.2023.06.07.08.21.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Jun 2023 08:21:29 -0700 (PDT)
From:   Alexander Mikhalitsyn <aleksandr.mikhalitsyn@canonical.com>
To:     xiubli@redhat.com
Cc:     brauner@kernel.org, stgraber@ubuntu.com,
        linux-fsdevel@vger.kernel.org,
        Christian Brauner <christian.brauner@ubuntu.com>,
        Jeff Layton <jlayton@kernel.org>,
        Ilya Dryomov <idryomov@gmail.com>, ceph-devel@vger.kernel.org,
        Alexander Mikhalitsyn <aleksandr.mikhalitsyn@canonical.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v3 07/14] ceph: allow idmapped rename inode op
Date:   Wed,  7 Jun 2023 17:20:31 +0200
Message-Id: <20230607152038.469739-8-aleksandr.mikhalitsyn@canonical.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230607152038.469739-1-aleksandr.mikhalitsyn@canonical.com>
References: <20230607152038.469739-1-aleksandr.mikhalitsyn@canonical.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: Christian Brauner <christian.brauner@ubuntu.com>

Enable ceph_rename() to handle idmapped mounts. This is just a matter of
passing down the mount's idmapping.

Cc: Xiubo Li <xiubli@redhat.com>
Cc: Jeff Layton <jlayton@kernel.org>
Cc: Ilya Dryomov <idryomov@gmail.com>
Cc: ceph-devel@vger.kernel.org
Signed-off-by: Christian Brauner <christian.brauner@ubuntu.com>
Signed-off-by: Alexander Mikhalitsyn <aleksandr.mikhalitsyn@canonical.com>
---
 fs/ceph/dir.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/ceph/dir.c b/fs/ceph/dir.c
index a4b1ee5ce6b6..7ae02a690464 100644
--- a/fs/ceph/dir.c
+++ b/fs/ceph/dir.c
@@ -1327,6 +1327,7 @@ static int ceph_rename(struct mnt_idmap *idmap, struct inode *old_dir,
 	req->r_old_dentry_unless = CEPH_CAP_FILE_EXCL;
 	req->r_dentry_drop = CEPH_CAP_FILE_SHARED;
 	req->r_dentry_unless = CEPH_CAP_FILE_EXCL;
+	req->r_mnt_idmap = idmap;
 	/* release LINK_RDCACHE on source inode (mds will lock it) */
 	req->r_old_inode_drop = CEPH_CAP_LINK_SHARED | CEPH_CAP_LINK_EXCL;
 	if (d_really_is_positive(new_dentry)) {
-- 
2.34.1

