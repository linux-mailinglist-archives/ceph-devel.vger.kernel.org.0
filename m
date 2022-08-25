Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D4F955A125C
	for <lists+ceph-devel@lfdr.de>; Thu, 25 Aug 2022 15:32:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242849AbiHYNc1 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 25 Aug 2022 09:32:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242779AbiHYNcC (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 25 Aug 2022 09:32:02 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8808B5E48
        for <ceph-devel@vger.kernel.org>; Thu, 25 Aug 2022 06:31:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1733361CFD
        for <ceph-devel@vger.kernel.org>; Thu, 25 Aug 2022 13:31:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BEEAC433D6;
        Thu, 25 Aug 2022 13:31:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661434314;
        bh=Pq76iu9VyaX8LFCOwd2o9K23lNnbzclNRdEtJAYfaWM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SPU3ZJrLm1VIcsf/fGeoGjod/EkTa779Xk6FXBBYe9IcNzOfQ+R42wtT3TE80lTz7
         AHSygZLWY24pVq2yAkB89DhgcCOsBefWh4tJbdSHfzGIUsZx6HFH/EHs9XD3+/OL1x
         ic14oK3Gs8731qQ1upsAnOeZhCES8BqpboGJOHFbNflBYHsPMsN8X5bafmmf/wJyFz
         r1s+iy2v/YoVr0owMQVwALKI3hq8vyp2QVBrUuMrXuKZ4FDNBrPdsqKdxejETfKaQp
         59bYqtBstXfpAvnaKxtBi+oxG7moQLOibR4gNHwlnzYIDMLdsIou6fTETgF7Iaqivx
         t8AQONwKyTSRg==
From:   Jeff Layton <jlayton@kernel.org>
To:     xiubli@redhat.com, idryomov@gmail.com
Cc:     lhenriques@suse.de, ceph-devel@vger.kernel.org
Subject: [PATCH v15 28/29] ceph: prevent snapshots to be created in encrypted locked directories
Date:   Thu, 25 Aug 2022 09:31:31 -0400
Message-Id: <20220825133132.153657-29-jlayton@kernel.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220825133132.153657-1-jlayton@kernel.org>
References: <20220825133132.153657-1-jlayton@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

From: Luís Henriques <lhenriques@suse.de>

With snapshot names encryption we can not allow snapshots to be created in
locked directories because the names wouldn't be encrypted.  This patch
forces the directory to be unlocked to allow a snapshot to be created.

Signed-off-by: Luís Henriques <lhenriques@suse.de>
Reviewed-by: Xiubo Li <xiubli@redhat.com>
Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/ceph/dir.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/fs/ceph/dir.c b/fs/ceph/dir.c
index 59df878a4df7..edc2bf0aab83 100644
--- a/fs/ceph/dir.c
+++ b/fs/ceph/dir.c
@@ -1084,6 +1084,11 @@ static int ceph_mkdir(struct user_namespace *mnt_userns, struct inode *dir,
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
2.37.2

