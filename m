Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F65D70FA58
	for <lists+ceph-devel@lfdr.de>; Wed, 24 May 2023 17:35:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236808AbjEXPfw (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 24 May 2023 11:35:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236423AbjEXPfG (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 24 May 2023 11:35:06 -0400
Received: from smtp-relay-internal-1.canonical.com (smtp-relay-internal-1.canonical.com [185.125.188.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CE9AE77
        for <ceph-devel@vger.kernel.org>; Wed, 24 May 2023 08:34:45 -0700 (PDT)
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com [209.85.218.70])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id 4F0F241D47
        for <ceph-devel@vger.kernel.org>; Wed, 24 May 2023 15:34:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1684942452;
        bh=lZbP4iiEH03HfqTDqSU+Hv1fOneGFOzGKwUObj1rpGo=;
        h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
         MIME-Version;
        b=GR+CUNIAtExfmj/W35+rrFjTPXtQU0Z0On/VaNbDxGI3p3TG6LH2U1KPb63+7u02E
         44FpxYzOdcrCd+SmcxFX3gmrNa85laQJvg6gAEglzJkNm9BrMpGVi07LhnEzaV91Rl
         Ozwc88FuuGX4mt4nMsNOYa7rRuYnd7IPShYi0x/3yt1/5SNIdRzFuhVI5XPGK7Ce+4
         Y/ndYwwtxMV5koaKnmzOuEyuHBwXkgxYMsX5xx6npiO70ljCPjl58oHdnnYdHUqqwf
         2KDLhV+zRx94lLtuUcyTph9WBx0qcgwcwWOB9Sgh/higlH0ZZ8gJuDPDoPkGQ9pkv2
         8AzHCY3TAzcYg==
Received: by mail-ej1-f70.google.com with SMTP id a640c23a62f3a-96fb396ee3dso106869466b.1
        for <ceph-devel@vger.kernel.org>; Wed, 24 May 2023 08:34:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684942449; x=1687534449;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=lZbP4iiEH03HfqTDqSU+Hv1fOneGFOzGKwUObj1rpGo=;
        b=Z97Q7mIoTpDR/eXbeA/9Sct4ZlXyJLkGOtUJZFFMvh/SrlgvZoZZ0Gf+JVwbdxyPk3
         R0VLDLM1pql6s6ZLEowStB7Wg0Ba0SWd9TRs4gdm65oHJvzCM2R2nrsijgu6rY7hu6kZ
         ccasmz0JkvM3V+S8ic6dO3gYdkr9kEJ65UMI0DS8BWcpmH8bVzpGLUb+bl0YLiZ5r8JJ
         h7IxkySBQ+UFdbQmGEw6c2rvNCyrxX/iQAIG8sEQHhE7pZafQDLFilXHWgUiosq/85Kx
         ZmecxR4MpEfIzi0ySSFDzNvm4uQCdSRaTilG7s+xr7jpISI6liZqiysHVaCIhyPGn/14
         g3dw==
X-Gm-Message-State: AC+VfDzee2lHI5AXfJSjmC/RS4+zJgTrPCFI/iF5lLb0cX6WhxZ1DGr3
        /cPJ+xLdDMOYwnvzW/KQmhfBLID+yzgsOtsPE01mCdQbyWElA1IF/Ka767Vq/MgEvz95T1K8fGH
        CVRuFZQRIo+J+eD7HCIPVgxxeR8ovNQXRt8GcJPg=
X-Received: by 2002:a17:907:26c6:b0:969:f677:11b4 with SMTP id bp6-20020a17090726c600b00969f67711b4mr16979968ejc.37.1684942448867;
        Wed, 24 May 2023 08:34:08 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ6GkqD2mx9edhZF+fiZhPW/iOs1zLB2TI7gEZMH8nbEv37OBHOLISYOfgzS57PLOIkRd9L02g==
X-Received: by 2002:a17:907:26c6:b0:969:f677:11b4 with SMTP id bp6-20020a17090726c600b00969f67711b4mr16979950ejc.37.1684942448627;
        Wed, 24 May 2023 08:34:08 -0700 (PDT)
Received: from amikhalitsyn.local (dslb-088-074-206-207.088.074.pools.vodafone-ip.de. [88.74.206.207])
        by smtp.gmail.com with ESMTPSA id p26-20020a17090664da00b0096f7105b3a6sm5986979ejn.189.2023.05.24.08.34.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 May 2023 08:34:08 -0700 (PDT)
From:   Alexander Mikhalitsyn <aleksandr.mikhalitsyn@canonical.com>
To:     xiubli@redhat.com
Cc:     brauner@kernel.org, stgraber@ubuntu.com,
        linux-fsdevel@vger.kernel.org,
        Christian Brauner <christian.brauner@ubuntu.com>,
        Jeff Layton <jlayton@kernel.org>,
        Ilya Dryomov <idryomov@gmail.com>, ceph-devel@vger.kernel.org,
        Alexander Mikhalitsyn <aleksandr.mikhalitsyn@canonical.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 07/13] ceph: allow idmapped rename inode op
Date:   Wed, 24 May 2023 17:33:09 +0200
Message-Id: <20230524153316.476973-8-aleksandr.mikhalitsyn@canonical.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230524153316.476973-1-aleksandr.mikhalitsyn@canonical.com>
References: <20230524153316.476973-1-aleksandr.mikhalitsyn@canonical.com>
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

From: Christian Brauner <christian.brauner@ubuntu.com>

Enable ceph_rename() to handle idmapped mounts. This is just a matter of
passing down the mount's idmapping.

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

