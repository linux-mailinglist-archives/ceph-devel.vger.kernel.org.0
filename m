Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1565B76FCA6
	for <lists+ceph-devel@lfdr.de>; Fri,  4 Aug 2023 10:52:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229502AbjHDIwM (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 4 Aug 2023 04:52:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229844AbjHDIul (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Fri, 4 Aug 2023 04:50:41 -0400
Received: from smtp-relay-internal-1.canonical.com (smtp-relay-internal-1.canonical.com [185.125.188.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B144A49D6
        for <ceph-devel@vger.kernel.org>; Fri,  4 Aug 2023 01:49:52 -0700 (PDT)
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com [209.85.218.70])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id 9856E417B7
        for <ceph-devel@vger.kernel.org>; Fri,  4 Aug 2023 08:49:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1691138990;
        bh=3z9qgb9ifPvjMsignbqopXQPiRZw936kb1zQwGNpHt4=;
        h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
         MIME-Version;
        b=WqKaNn5vMWGuf+gCUX57wGzRG4rRHPbXZ67y2V7SIx3Vj9PnLlD8b0D/dgfIGIJAk
         S46ZkJTkjp7WU31inOLNLwVNXTE5YXRPvL5JSWy90b96d/xSBqjR9Xr03s/PnnX7x3
         PaASTOUGnru9aWvORtVqO8P1umjGF3PDbRoQ2lhMUEq7zjN3dcgTvwnkZhVtn7szYn
         h44yw+c8wq+vV7LmLTZs6drWeGX3sBI4iWlenLK0GfJfSEF4T9vw2t90K27WS7C9Au
         x46xRugQmIsliiTVy6azH9SzZuOAVpBmazumQvDihqdfx8oKzYOx1A8+w9e4DRMpSb
         ebQn8R2oLUi6A==
Received: by mail-ej1-f70.google.com with SMTP id a640c23a62f3a-94a34e35f57so118544666b.3
        for <ceph-devel@vger.kernel.org>; Fri, 04 Aug 2023 01:49:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691138989; x=1691743789;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=3z9qgb9ifPvjMsignbqopXQPiRZw936kb1zQwGNpHt4=;
        b=U0seHqdqLllPZjB2YNqqs+4WTV9xL2LkkulbMaathUZ715Pn3qEoLXNyBbUQsHXGSc
         DJl1Te/JpyL6WpGPUcCyYDWizju0tc8dhA25OfgywV59jvMqauTM54R2cYxRUhiEF2UK
         P7ud1KngDBuVg6qkvBMG5uGiVjLjD9iBS1XYj2FjLd3kH2lbGERyFf44Xkp0iym/V6qi
         Tq4QCvrQonj+hA3kGDGS4LraV3N95e6V/RzGGPrItPhoPe39fPW1tgm2JzK3R6uDE4hg
         aKQXRQ+c5SriLflWyM7KyjPHYYI8UX41WlB90jnHnWyd+ajepovBbDuQDELvBZOYM/C+
         iB5g==
X-Gm-Message-State: AOJu0YxI9rmInSH1OCQaVJyQMlVNmmY+Tb+/tN1PRTc04e21GxQcYi21
        hag4d5VWH7gL/uaFhsiJD0fZe/+WcSmaxVGXRXiy+l2ym1mF5ejPSoIUxdeCLQy8DTnFpX5xX7+
        QpA6p+7S+1U4YZkaXHsk1uZARJdP3V5EnWxm+5x8=
X-Received: by 2002:a17:906:76c8:b0:99c:524d:5052 with SMTP id q8-20020a17090676c800b0099c524d5052mr947634ejn.0.1691138989329;
        Fri, 04 Aug 2023 01:49:49 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGTym5TfzlHG1lZSavhyqmoZ0wMSQV6UssfY2G4oAk1V8i7SJ+uZP+Mld/WvvtmdYlgx9LngQ==
X-Received: by 2002:a17:906:76c8:b0:99c:524d:5052 with SMTP id q8-20020a17090676c800b0099c524d5052mr947623ejn.0.1691138989153;
        Fri, 04 Aug 2023 01:49:49 -0700 (PDT)
Received: from amikhalitsyn.local (dslb-088-066-182-192.088.066.pools.vodafone-ip.de. [88.66.182.192])
        by smtp.gmail.com with ESMTPSA id k25-20020a17090646d900b00992e94bcfabsm979279ejs.167.2023.08.04.01.49.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Aug 2023 01:49:48 -0700 (PDT)
From:   Alexander Mikhalitsyn <aleksandr.mikhalitsyn@canonical.com>
To:     xiubli@redhat.com
Cc:     brauner@kernel.org, stgraber@ubuntu.com,
        linux-fsdevel@vger.kernel.org, Jeff Layton <jlayton@kernel.org>,
        Ilya Dryomov <idryomov@gmail.com>, ceph-devel@vger.kernel.org,
        Alexander Mikhalitsyn <aleksandr.mikhalitsyn@canonical.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v9 11/12] ceph/file: allow idmapped atomic_open inode op
Date:   Fri,  4 Aug 2023 10:48:57 +0200
Message-Id: <20230804084858.126104-12-aleksandr.mikhalitsyn@canonical.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230804084858.126104-1-aleksandr.mikhalitsyn@canonical.com>
References: <20230804084858.126104-1-aleksandr.mikhalitsyn@canonical.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: Christian Brauner <brauner@kernel.org>

Enable ceph_atomic_open() to handle idmapped mounts. This is just a
matter of passing down the mount's idmapping.

Cc: Xiubo Li <xiubli@redhat.com>
Cc: Jeff Layton <jlayton@kernel.org>
Cc: Ilya Dryomov <idryomov@gmail.com>
Cc: ceph-devel@vger.kernel.org
Signed-off-by: Christian Brauner <brauner@kernel.org>
[ adapted to 5fadbd9929 ("ceph: rely on vfs for setgid stripping") ]
Signed-off-by: Alexander Mikhalitsyn <aleksandr.mikhalitsyn@canonical.com>
---
v4:
	- call mnt_idmap_get
---
 fs/ceph/file.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/fs/ceph/file.c b/fs/ceph/file.c
index 7470daafe595..f73d8b760682 100644
--- a/fs/ceph/file.c
+++ b/fs/ceph/file.c
@@ -668,7 +668,9 @@ static int ceph_finish_async_create(struct inode *dir, struct inode *inode,
 	in.truncate_seq = cpu_to_le32(1);
 	in.truncate_size = cpu_to_le64(-1ULL);
 	in.xattr_version = cpu_to_le64(1);
-	in.uid = cpu_to_le32(from_kuid(&init_user_ns, current_fsuid()));
+	in.uid = cpu_to_le32(from_kuid(&init_user_ns,
+				       mapped_fsuid(req->r_mnt_idmap,
+						    &init_user_ns)));
 	if (dir->i_mode & S_ISGID) {
 		in.gid = cpu_to_le32(from_kgid(&init_user_ns, dir->i_gid));
 
@@ -676,7 +678,9 @@ static int ceph_finish_async_create(struct inode *dir, struct inode *inode,
 		if (S_ISDIR(mode))
 			mode |= S_ISGID;
 	} else {
-		in.gid = cpu_to_le32(from_kgid(&init_user_ns, current_fsgid()));
+		in.gid = cpu_to_le32(from_kgid(&init_user_ns,
+				     mapped_fsgid(req->r_mnt_idmap,
+						  &init_user_ns)));
 	}
 	in.mode = cpu_to_le32((u32)mode);
 
@@ -743,6 +747,7 @@ static int ceph_finish_async_create(struct inode *dir, struct inode *inode,
 int ceph_atomic_open(struct inode *dir, struct dentry *dentry,
 		     struct file *file, unsigned flags, umode_t mode)
 {
+	struct mnt_idmap *idmap = file_mnt_idmap(file);
 	struct ceph_fs_client *fsc = ceph_sb_to_fs_client(dir->i_sb);
 	struct ceph_client *cl = fsc->client;
 	struct ceph_mds_client *mdsc = fsc->mdsc;
@@ -802,6 +807,7 @@ int ceph_atomic_open(struct inode *dir, struct dentry *dentry,
 		mask |= CEPH_CAP_XATTR_SHARED;
 	req->r_args.open.mask = cpu_to_le32(mask);
 	req->r_parent = dir;
+	req->r_mnt_idmap = mnt_idmap_get(idmap);
 	ihold(dir);
 	if (IS_ENCRYPTED(dir)) {
 		set_bit(CEPH_MDS_R_FSCRYPT_FILE, &req->r_req_flags);
-- 
2.34.1

