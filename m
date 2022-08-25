Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 51E0E5A124C
	for <lists+ceph-devel@lfdr.de>; Thu, 25 Aug 2022 15:32:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242774AbiHYNcG (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 25 Aug 2022 09:32:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242752AbiHYNbx (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 25 Aug 2022 09:31:53 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBB31B516D
        for <ceph-devel@vger.kernel.org>; Thu, 25 Aug 2022 06:31:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id AFD46CE286B
        for <ceph-devel@vger.kernel.org>; Thu, 25 Aug 2022 13:31:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1945C433D6;
        Thu, 25 Aug 2022 13:31:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661434305;
        bh=KBJ2S2qFEkiWNBVxQvFg4EYMl6kr/CYMvdycwOgH0OA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LbHKgcQEsMmvyGTEqgHZXCeNkWPx020RNyIGXL5fKGl6ZkeiIIYkm+M7nOu+mNjnD
         m44P1NWfKmzplOvDGmxqlVxjqaSpRcVeW4V/rfWn2eyCiwgRgvUCDyd1kLA6d2yKAv
         WFwYh/ln0Ug0bfFg+TPu8GFlYF62VP0ZDovBO6zXZG+gbLQxfNrCFb/ysmy82vM/4z
         z7odhVoXa1qMk41SM+avwi/5a8DUW72cQ1jxAd5PT/9YWj5a23n2Gf7NC1SHXE+vEZ
         DU9qQVbTLcRnvpxbD82VYRgVBiNRsuj4TuIZRHY0lDBBfxbAMVoMjKwyyA8kVd7Vwi
         XOc9Jj5wn5iqw==
From:   Jeff Layton <jlayton@kernel.org>
To:     xiubli@redhat.com, idryomov@gmail.com
Cc:     lhenriques@suse.de, ceph-devel@vger.kernel.org
Subject: [PATCH v15 15/29] ceph: disable copy offload on encrypted inodes
Date:   Thu, 25 Aug 2022 09:31:18 -0400
Message-Id: <20220825133132.153657-16-jlayton@kernel.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220825133132.153657-1-jlayton@kernel.org>
References: <20220825133132.153657-1-jlayton@kernel.org>
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

If we have an encrypted inode, then the client will need to re-encrypt
the contents of the new object. Disable copy offload to or from
encrypted inodes.

Reviewed-by: Xiubo Li <xiubli@redhat.com>
Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/ceph/file.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/ceph/file.c b/fs/ceph/file.c
index 64f8f668970f..bd5e04d994ac 100644
--- a/fs/ceph/file.c
+++ b/fs/ceph/file.c
@@ -2502,6 +2502,10 @@ static ssize_t __ceph_copy_file_range(struct file *src_file, loff_t src_off,
 		return -EOPNOTSUPP;
 	}
 
+	/* Every encrypted inode gets its own key, so we can't offload them */
+	if (IS_ENCRYPTED(src_inode) || IS_ENCRYPTED(dst_inode))
+		return -EOPNOTSUPP;
+
 	if (len < src_ci->i_layout.object_size)
 		return -EOPNOTSUPP; /* no remote copy will be done */
 
-- 
2.37.2

