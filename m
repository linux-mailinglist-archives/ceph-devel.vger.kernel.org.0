Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C02D4EA193
	for <lists+ceph-devel@lfdr.de>; Mon, 28 Mar 2022 22:34:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345062AbiC1UgU (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 28 Mar 2022 16:36:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346663AbiC1Ufg (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 28 Mar 2022 16:35:36 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7714030F6C
        for <ceph-devel@vger.kernel.org>; Mon, 28 Mar 2022 13:33:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2C39BB81213
        for <ceph-devel@vger.kernel.org>; Mon, 28 Mar 2022 20:33:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A71CC340ED;
        Mon, 28 Mar 2022 20:33:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648499632;
        bh=FENCWwYjL1xc76hPvsKB9kB9RshvINQJSU8gQpus9zg=;
        h=From:To:Cc:Subject:Date:From;
        b=dInTWAXHtQRxJgrs4NMqs4dTxO1JDrsSIQlVGDdwRzrJloeOs62Jc9tFKNmHcuFqH
         OKF0Zj1A6JSAjY8LR4VW7dPrWBM6Y1m6f0XyV7LdLn5y+tNcSeU79R8s4KvxQyBKGS
         AzF+MjuoFE1Jnd5a0etN4hUbivLXF1OVrX+Rg1iQjPDZDeXdvJgIAQpvMR01RYCYCx
         9QzqphUc/pktDc3mamEJGl+GcUvGhfpICzz3K/gSb9RPFtuXk8urbk0ezoVDW7dWq2
         TUEmb6oltKp5Ha22aJ4yvaeNNtfsgCUEHFh6SRlENeT7E7x88baLI4AA6e5NNk4kCF
         1va/iCfumiTng==
From:   Jeff Layton <jlayton@kernel.org>
To:     ceph-devel@vger.kernel.org
Cc:     idryomov@gmail.com, xiubli@redhat.com, lhenriques@suse.de
Subject: [PATCH] ceph: set DCACHE_NOKEY_NAME in atomic open
Date:   Mon, 28 Mar 2022 16:33:51 -0400
Message-Id: <20220328203351.79603-1-jlayton@kernel.org>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Atomic open can act as a lookup if handed a dentry that is negative on
the MDS. Ensure that we set DCACHE_NOKEY_NAME on the dentry in
atomic_open, if we don't have the key for the parent. Otherwise, we can
end up validating the dentry inappropriately if someone later adds a
key.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/ceph/file.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

Another patch for the fscrypt series.

A much less heavy-handed fix for generic/580 and generic/593. I'll
probably fold this into an earlier patch in the series since it appears
to be a straightforward bug.

diff --git a/fs/ceph/file.c b/fs/ceph/file.c
index eb04dc8f1f93..5072570c2203 100644
--- a/fs/ceph/file.c
+++ b/fs/ceph/file.c
@@ -765,8 +765,14 @@ int ceph_atomic_open(struct inode *dir, struct dentry *dentry,
 	req->r_args.open.mask = cpu_to_le32(mask);
 	req->r_parent = dir;
 	ihold(dir);
-	if (IS_ENCRYPTED(dir))
+	if (IS_ENCRYPTED(dir)) {
 		set_bit(CEPH_MDS_R_FSCRYPT_FILE, &req->r_req_flags);
+		if (!fscrypt_has_encryption_key(dir)) {
+			spin_lock(&dentry->d_lock);
+			dentry->d_flags |= DCACHE_NOKEY_NAME;
+			spin_unlock(&dentry->d_lock);
+		}
+	}
 
 	if (flags & O_CREAT) {
 		struct ceph_file_layout lo;
-- 
2.35.1

