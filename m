Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B2677512253
	for <lists+ceph-devel@lfdr.de>; Wed, 27 Apr 2022 21:16:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234077AbiD0TUE (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 27 Apr 2022 15:20:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233519AbiD0TTS (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 27 Apr 2022 15:19:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 344953E5F8
        for <ceph-devel@vger.kernel.org>; Wed, 27 Apr 2022 12:13:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9A3CE619D0
        for <ceph-devel@vger.kernel.org>; Wed, 27 Apr 2022 19:13:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F85DC385A9;
        Wed, 27 Apr 2022 19:13:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651086823;
        bh=055bRGvY8Rd9//uY4MNk52HNCIW2YMD+cbIrSeHBb+4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UIkuPKZqIQ3M7JV2O39PNLsFcE1uRZmyNf2t+q6yz40y8/Oo+ZVYkkmVdy9PiMxIO
         q/YlWMgpLNvm2PN3Pj0rYQ+k+yqsl69VmMBh1B7mMdn8J6sRF9oVj8NHb1CpK9Wq0Z
         m4BAJ7twv9eLPQUphs7S0KGsxGx6yDKy6utjlaGJOCr9dDy0ZWpoqDfloAAQiJ2gTs
         OTEruhSFe0/nDEY1a1ox5B0CnaH63xfVDXukpS3KGhB3TCpt7ieBKwNztdOxcN/CuU
         nEggBpKcanumMfArofuAKnUhAtBFoo0yrbMGJExWCmVxec2aN6Rq9CoDgVXHOGISBE
         Jk1K5g1KR3Y5g==
From:   Jeff Layton <jlayton@kernel.org>
To:     ceph-devel@vger.kernel.org
Cc:     xiubli@redhat.com, lhenriques@suse.de, idryomov@gmail.com
Subject: [PATCH v14 37/64] ceph: don't allow changing layout on encrypted files/directories
Date:   Wed, 27 Apr 2022 15:12:47 -0400
Message-Id: <20220427191314.222867-38-jlayton@kernel.org>
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

Encryption is currently only supported on files/directories with layouts
where stripe_count=1.  Forbid changing layouts when encryption is involved.

Signed-off-by: Luis Henriques <lhenriques@suse.de>
Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/ceph/ioctl.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/ceph/ioctl.c b/fs/ceph/ioctl.c
index b9f0f4e460ab..9675ef3a6c47 100644
--- a/fs/ceph/ioctl.c
+++ b/fs/ceph/ioctl.c
@@ -294,6 +294,10 @@ static long ceph_set_encryption_policy(struct file *file, unsigned long arg)
 	struct inode *inode = file_inode(file);
 	struct ceph_inode_info *ci = ceph_inode(inode);
 
+	/* encrypted directories can't have striped layout */
+	if (ci->i_layout.stripe_count > 1)
+		return -EINVAL;
+
 	ret = vet_mds_for_fscrypt(file);
 	if (ret)
 		return ret;
-- 
2.35.1

