Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC4CA512267
	for <lists+ceph-devel@lfdr.de>; Wed, 27 Apr 2022 21:17:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233856AbiD0TUl (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 27 Apr 2022 15:20:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233762AbiD0TTW (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 27 Apr 2022 15:19:22 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2347F53A6B
        for <ceph-devel@vger.kernel.org>; Wed, 27 Apr 2022 12:13:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B4498619FC
        for <ceph-devel@vger.kernel.org>; Wed, 27 Apr 2022 19:13:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D963C385A7;
        Wed, 27 Apr 2022 19:13:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651086832;
        bh=bTGL2eTBz8WfSmM2NY3CC8x3l6rD2G+I0t/E0HV3Qts=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tIVhNS+0NNBaraJ0Gx85JwJJ+pNYlfEMS53OpjfA7cffkAVpecMoUM0KEjX2OHbga
         PZHj+V+86uEetwN/S7s9uvS3nQe1X+NFe17PHb12aasvvYaQts2Mubzzp6TS7cFSOv
         layKyZXBfQ5Xkl7ncd32eiKGScq8NGl5Hk+IfNSPs4cyjZ7vT9Su9aJW5Pe6fBQrTQ
         i+9GN5I1AS8NEC0s/U0x6AnVsKTCA+F4jgWfj+S1gGHqjnFqgxosvN+f1k0XgdKtcc
         yXcZDFRnaxpAPJKe4gXjK/KzjGGnTqM1K9+ivC7dzQro5IqMT9DfLXP/bOu6Ec5g4m
         fEDQUCHEW5FoQ==
From:   Jeff Layton <jlayton@kernel.org>
To:     ceph-devel@vger.kernel.org
Cc:     xiubli@redhat.com, lhenriques@suse.de, idryomov@gmail.com
Subject: [PATCH v14 50/64] ceph: disable fallocate for encrypted inodes
Date:   Wed, 27 Apr 2022 15:13:00 -0400
Message-Id: <20220427191314.222867-51-jlayton@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220427191314.222867-1-jlayton@kernel.org>
References: <20220427191314.222867-1-jlayton@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

...hopefully, just for now.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/ceph/file.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/ceph/file.c b/fs/ceph/file.c
index 7168cf97924b..1024dc57898d 100644
--- a/fs/ceph/file.c
+++ b/fs/ceph/file.c
@@ -2217,6 +2217,9 @@ static long ceph_fallocate(struct file *file, int mode,
 	if (!S_ISREG(inode->i_mode))
 		return -EOPNOTSUPP;
 
+	if (IS_ENCRYPTED(inode))
+		return -EOPNOTSUPP;
+
 	prealloc_cf = ceph_alloc_cap_flush();
 	if (!prealloc_cf)
 		return -ENOMEM;
-- 
2.35.1

