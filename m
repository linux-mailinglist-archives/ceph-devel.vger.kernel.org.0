Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D07A8729659
	for <lists+ceph-devel@lfdr.de>; Fri,  9 Jun 2023 12:10:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239213AbjFIKKi (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 9 Jun 2023 06:10:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240999AbjFIKKK (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Fri, 9 Jun 2023 06:10:10 -0400
Received: from smtp-relay-internal-0.canonical.com (smtp-relay-internal-0.canonical.com [185.125.188.122])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B3928684
        for <ceph-devel@vger.kernel.org>; Fri,  9 Jun 2023 02:59:14 -0700 (PDT)
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com [209.85.218.69])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-0.canonical.com (Postfix) with ESMTPS id DEC3C3F484
        for <ceph-devel@vger.kernel.org>; Fri,  9 Jun 2023 09:33:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1686303190;
        bh=2hwztFxZhmRTBhQzcOpavHgJ6h9g0DydFvSzqcbHOs4=;
        h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
         MIME-Version;
        b=gnIAQkU5IQwVZT/mb4HqZ/A0yOpNhVz5GmtWYTjNRRoq+7mZNRaAkR7XplOF7bvM8
         LObbxLfaLRX2iVz7q+46V63+KFzXOymSMcoTl2g5wceo8kDkxeI7qhpWKnOklalskU
         zhmMjuz4U3UZDVO2eOtVLAz425t265ejn/z6gHUVm7MVrozyaT03eznZw6oYSRswNv
         6DKNMbg4IzaumociTwxq84FaxmFuAST9GyT9X4JOc8GPC9hBG/0Dc41jQR68vZUTFT
         TXAPRq552NELtnqaRgM4yzGeRVhL3TOlCD9JBnHUt4IXxeenLMuYwj04FAd5YmeLZl
         ODSNyX9BB8kgg==
Received: by mail-ej1-f69.google.com with SMTP id a640c23a62f3a-94a355cf318so207579766b.2
        for <ceph-devel@vger.kernel.org>; Fri, 09 Jun 2023 02:33:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686303190; x=1688895190;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2hwztFxZhmRTBhQzcOpavHgJ6h9g0DydFvSzqcbHOs4=;
        b=TzKuTBspYLoDIdzUQ+u8H+vihpVCl6Z3xJoCjFCHrMl+q9d/QZ+RsU/RKpfSMw612u
         L++Ftv8XSjNlAzM7ITtyjbRO6nfUyM3Iq10JKBdYo+L3v9ADQVsiI6En+RmFOFNeDYwG
         AnmsZoFYyvF2hCjlJgnpdkc6E4Dsl4yYYNzSEdbvNjvsfke55/ZooVOUM0Ud7KaQHzCo
         Fe5J+pCQC4W91Jbjeg+FZwEte9y8zMJNMCmkA6DAQDempih0wcnfUO/otF60eCur1/SS
         CsRa8w2QnfRnccxJqpN6dbQW5fPvQ1VkSnL7T3KeGZstu5DNHNtjFTmiQpSdsynqPGRg
         SMtA==
X-Gm-Message-State: AC+VfDwuvDI8xbJj2sgJ2FRtA+Mzl4Yjq9N6PGoKyd/TBVE8Btm+c2yX
        fvfZ6Cv8+rnsgjZRPUHWNM8bml5NsRV5nenSzo5kc0qDmij9vjjY9EHgMjA7wy88FEIZTMKWiyK
        8FeC0Zeog9BuPuXdbkfJO232Ej+pQ8RTTmSVK1z0=
X-Received: by 2002:a17:907:3d93:b0:94f:2a13:4e01 with SMTP id he19-20020a1709073d9300b0094f2a134e01mr1371735ejc.74.1686303190608;
        Fri, 09 Jun 2023 02:33:10 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ4MsL6zC8MBPYxx1/IN/olzX93IyA3TrvCsZrn7wnZMo+W05KzTTK8rzx2rV8d5frIVKKWmuA==
X-Received: by 2002:a17:907:3d93:b0:94f:2a13:4e01 with SMTP id he19-20020a1709073d9300b0094f2a134e01mr1371717ejc.74.1686303190365;
        Fri, 09 Jun 2023 02:33:10 -0700 (PDT)
Received: from amikhalitsyn.local (dslb-002-205-064-187.002.205.pools.vodafone-ip.de. [2.205.64.187])
        by smtp.gmail.com with ESMTPSA id e25-20020a170906081900b0094ee3e4c934sm1031248ejd.221.2023.06.09.02.33.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Jun 2023 02:33:10 -0700 (PDT)
From:   Alexander Mikhalitsyn <aleksandr.mikhalitsyn@canonical.com>
To:     xiubli@redhat.com
Cc:     brauner@kernel.org, stgraber@ubuntu.com,
        linux-fsdevel@vger.kernel.org,
        Alexander Mikhalitsyn <aleksandr.mikhalitsyn@canonical.com>,
        Jeff Layton <jlayton@kernel.org>,
        Ilya Dryomov <idryomov@gmail.com>, ceph-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v6 14/15] ceph: pass idmap to ceph_netfs_issue_op_inline
Date:   Fri,  9 Jun 2023 11:31:25 +0200
Message-Id: <20230609093125.252186-15-aleksandr.mikhalitsyn@canonical.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230609093125.252186-1-aleksandr.mikhalitsyn@canonical.com>
References: <20230609093125.252186-1-aleksandr.mikhalitsyn@canonical.com>
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

Just pass down the mount's idmapping to ceph_netfs_issue_op_inline.

Cc: Xiubo Li <xiubli@redhat.com>
Cc: Jeff Layton <jlayton@kernel.org>
Cc: Ilya Dryomov <idryomov@gmail.com>
Cc: brauner@kernel.org
Cc: ceph-devel@vger.kernel.org
Signed-off-by: Alexander Mikhalitsyn <aleksandr.mikhalitsyn@canonical.com>
---
 fs/ceph/addr.c  | 12 ++++++++++++
 fs/ceph/super.h |  2 ++
 2 files changed, 14 insertions(+)

diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
index 0a32475ed034..2759a0cf2381 100644
--- a/fs/ceph/addr.c
+++ b/fs/ceph/addr.c
@@ -291,6 +291,8 @@ static bool ceph_netfs_issue_op_inline(struct netfs_io_subrequest *subreq)
 {
 	struct netfs_io_request *rreq = subreq->rreq;
 	struct inode *inode = rreq->inode;
+	struct ceph_netfs_request_data *priv = rreq->netfs_priv;
+	struct mnt_idmap *idmap = priv->mnt_idmap;
 	struct ceph_mds_reply_info_parsed *rinfo;
 	struct ceph_mds_reply_info_in *iinfo;
 	struct ceph_mds_request *req;
@@ -318,6 +320,8 @@ static bool ceph_netfs_issue_op_inline(struct netfs_io_subrequest *subreq)
 	req->r_args.getattr.mask = cpu_to_le32(CEPH_STAT_CAP_INLINE_DATA);
 	req->r_num_caps = 2;
 
+	req->r_mnt_idmap = mnt_idmap_get(idmap);
+
 	err = ceph_mdsc_do_request(mdsc, NULL, req);
 	if (err < 0)
 		goto out;
@@ -443,13 +447,18 @@ static int ceph_init_request(struct netfs_io_request *rreq, struct file *file)
 	if (!priv)
 		return -ENOMEM;
 
+	priv->mnt_idmap = &nop_mnt_idmap;
+
 	if (file) {
 		struct ceph_rw_context *rw_ctx;
 		struct ceph_file_info *fi = file->private_data;
+		struct mnt_idmap *idmap = file_mnt_idmap(file);
 
 		priv->file_ra_pages = file->f_ra.ra_pages;
 		priv->file_ra_disabled = file->f_mode & FMODE_RANDOM;
 
+		priv->mnt_idmap = mnt_idmap_get(idmap);
+
 		rw_ctx = ceph_find_rw_context(fi);
 		if (rw_ctx) {
 			rreq->netfs_priv = priv;
@@ -496,6 +505,9 @@ static void ceph_netfs_free_request(struct netfs_io_request *rreq)
 
 	if (priv->caps)
 		ceph_put_cap_refs(ceph_inode(rreq->inode), priv->caps);
+
+	mnt_idmap_put(priv->mnt_idmap);
+
 	kfree(priv);
 	rreq->netfs_priv = NULL;
 }
diff --git a/fs/ceph/super.h b/fs/ceph/super.h
index d89e7b99ac5f..0badf58fb5fc 100644
--- a/fs/ceph/super.h
+++ b/fs/ceph/super.h
@@ -481,6 +481,8 @@ struct ceph_netfs_request_data {
 
 	/* Set it if fadvise disables file readahead entirely */
 	bool file_ra_disabled;
+
+	struct mnt_idmap *mnt_idmap;
 };
 
 static inline struct ceph_inode_info *
-- 
2.34.1

