Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 76AEC512270
	for <lists+ceph-devel@lfdr.de>; Wed, 27 Apr 2022 21:17:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234004AbiD0TVG (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 27 Apr 2022 15:21:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233370AbiD0TTm (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 27 Apr 2022 15:19:42 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57EA98A315
        for <ceph-devel@vger.kernel.org>; Wed, 27 Apr 2022 12:14:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 19124B8294D
        for <ceph-devel@vger.kernel.org>; Wed, 27 Apr 2022 19:14:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68ED2C385AA;
        Wed, 27 Apr 2022 19:14:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651086841;
        bh=SaANu6zlmzyvh0EYfMkYTWrWskPuFira/Ah/I4AD80I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WIv8BJj32J7T9EBuynDwST9jcs3/8ZZQweGEGVhSzW/b1jLmdMoWKc2hyHgbnqiT7
         MnLn0tRt1KyCbzLwCG8qiFT2jX7bQD1gwgNL6gbpVwu2e34RwPQl13O/zYB3InhnMC
         ThpvmIc65keVmcl/A7pk9zkGduGYs6D5hFLS2FvOcAftcGCi/aqPZI6nhAKwvrxOGu
         nRY4ErF+5DnyjD4gmaxstPaUHBMCA82gRwIjmDGJNaawCzjo54wRalt+jORhIx6/HW
         mmWGB7dLz/cWiB3JFr1f8RFbtthPKnxdA9rHqb4MoBdzuJoSWGm0BgU9ZB4VJIYV+a
         AevPj5KsujdgQ==
From:   Jeff Layton <jlayton@kernel.org>
To:     ceph-devel@vger.kernel.org
Cc:     xiubli@redhat.com, lhenriques@suse.de, idryomov@gmail.com
Subject: [PATCH v14 64/64] ceph: prevent snapshots to be created in encrypted locked directories
Date:   Wed, 27 Apr 2022 15:13:14 -0400
Message-Id: <20220427191314.222867-65-jlayton@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220427191314.222867-1-jlayton@kernel.org>
References: <20220427191314.222867-1-jlayton@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: Luís Henriques <lhenriques@suse.de>

With snapshot names encryption we can not allow snapshots to be created in
locked directories because the names wouldn't be encrypted.  This patch
forces the directory to be unlocked to allow a snapshot to be created.

Signed-off-by: Luís Henriques <lhenriques@suse.de>
Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/ceph/dir.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/fs/ceph/dir.c b/fs/ceph/dir.c
index 544aa5e78a31..7045f0aa53cc 100644
--- a/fs/ceph/dir.c
+++ b/fs/ceph/dir.c
@@ -1071,6 +1071,11 @@ static int ceph_mkdir(struct user_namespace *mnt_userns, struct inode *dir,
 		err = -EDQUOT;
 		goto out;
 	}
+	if ((op == CEPH_MDS_OP_MKSNAP) && IS_ENCRYPTED(dir) &&
+	    !fscrypt_has_encryption_key(dir)) {
+		err = -ENOKEY;
+		goto out;
+	}
 
 
 	req = ceph_mdsc_create_request(mdsc, op, USE_AUTH_MDS);
-- 
2.35.1

