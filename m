Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A9B8751225C
	for <lists+ceph-devel@lfdr.de>; Wed, 27 Apr 2022 21:17:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233889AbiD0TUW (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 27 Apr 2022 15:20:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233157AbiD0TTP (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 27 Apr 2022 15:19:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD3BC35275
        for <ceph-devel@vger.kernel.org>; Wed, 27 Apr 2022 12:13:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4F986619E1
        for <ceph-devel@vger.kernel.org>; Wed, 27 Apr 2022 19:13:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CBF8C385AE;
        Wed, 27 Apr 2022 19:13:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651086816;
        bh=FZyYLQc6AH9ugDOKqB0hiuOEGVhGs2E/B8b2nLDlupk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ruyj7nWVskA1eizEX70ZoXCZBQq+4Y5ltdfsm4ll1Ehr/gwAJvFLw/Sxw+cC5Kxrw
         IowCqDhqvuEd0AMzRU80NMT1uakDDQ74qQGoH4u0XSZYNmSOCgV+PWNr9QMte1KYH7
         QtFwVsxy1xWyhja8supUrGmLL2x7wjbDqiF1OMs/MSboxsR+I/kHu3SAPnCKGU7/1z
         1MPWfewpR+4IV1iePUQ15mCltvfdw50C8Hcx7J9sz1GH9xDnn4k+CK8hM7uLHkF/Gu
         z/ABxOxkhhn6VPAfiUPvquHKdQLED5JGvQNxecxsnb2GZDOK8DaKVudKwTSKdTFrpN
         qnH2C7l0+CSow==
From:   Jeff Layton <jlayton@kernel.org>
To:     ceph-devel@vger.kernel.org
Cc:     xiubli@redhat.com, lhenriques@suse.de, idryomov@gmail.com
Subject: [PATCH v14 28/64] ceph: fix base64 encoded name's length check in ceph_fname_to_usr()
Date:   Wed, 27 Apr 2022 15:12:38 -0400
Message-Id: <20220427191314.222867-29-jlayton@kernel.org>
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

From: Xiubo Li <xiubli@redhat.com>

The fname->name is based64_encoded names and the max long shouldn't
exceed the NAME_MAX.

The FSCRYPT_BASE64URL_CHARS(NAME_MAX) will be 255 * 4 / 3.

Signed-off-by: Xiubo Li <xiubli@redhat.com>
Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/ceph/crypto.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ceph/crypto.c b/fs/ceph/crypto.c
index 7e1f66b35095..6fb2fd1a8af0 100644
--- a/fs/ceph/crypto.c
+++ b/fs/ceph/crypto.c
@@ -264,7 +264,7 @@ int ceph_fname_to_usr(const struct ceph_fname *fname, struct fscrypt_str *tname,
 	}
 
 	/* Sanity check that the resulting name will fit in the buffer */
-	if (fname->name_len > FSCRYPT_BASE64URL_CHARS(NAME_MAX))
+	if (fname->name_len > NAME_MAX || fname->ctext_len > NAME_MAX)
 		return -EIO;
 
 	ret = __fscrypt_prepare_readdir(fname->dir);
-- 
2.35.1

