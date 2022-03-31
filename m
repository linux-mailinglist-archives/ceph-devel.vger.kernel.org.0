Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 424774ED769
	for <lists+ceph-devel@lfdr.de>; Thu, 31 Mar 2022 11:59:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234085AbiCaKBX (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 31 Mar 2022 06:01:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233926AbiCaKBW (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 31 Mar 2022 06:01:22 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9B0D3BA43
        for <ceph-devel@vger.kernel.org>; Thu, 31 Mar 2022 02:59:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4C76B60BAD
        for <ceph-devel@vger.kernel.org>; Thu, 31 Mar 2022 09:59:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D8DFC340ED;
        Thu, 31 Mar 2022 09:59:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648720773;
        bh=0w/YLNGAt5yTTQg9FtKI466AVpOgZPDQtoDvR+xPpIY=;
        h=From:To:Cc:Subject:Date:From;
        b=e40im5qiCOC/8+hV/hicGl/c6GfBdIDd1YN2Nzg6R1vjhr5iSpv52fALxOGZQRQuQ
         b0xw2iBlLLBN/32fG4mSfKaxgjA3oKakDwV4541o/59oZpyZnucZ81LRyPADmH6cW7
         0qi6YAXQl+u2gOx/Bh4ZPAQGhawlAxUX91onmzrYdaP+x0Ymm782bXUGsoOpeeuKrv
         6CCNHBim+7p9fGrMMtJibSiSnlbMf7FZg8mNnU4SxCypEwTrWmyHamhZu85qBYyxGV
         pVAHutAF6RsUapBn5jzTwFu8TXqF2FGXtQ/yxJkRhMO/MRLgMot8zu7RMtKqbbwANW
         DQm0YrYwqebzg==
From:   Jeff Layton <jlayton@kernel.org>
To:     ceph-devel@vger.kernel.org
Cc:     idryomov@gmail.com, xiubli@redhat.com,
        =?UTF-8?q?Lu=C3=ADs=20Henriques?= <lhenriques@suse.de>
Subject: [PATCH v2] ceph: discard r_new_inode if open O_CREAT opened existing inode
Date:   Thu, 31 Mar 2022 05:59:31 -0400
Message-Id: <20220331095931.6261-1-jlayton@kernel.org>
X-Mailer: git-send-email 2.35.1
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

When we do an unchecked create, we optimistically pre-create an inode
and populate it, including its fscrypt context. It's possible though
that we'll end up opening an existing inode, in which case the
precreated inode will have a crypto context that doesn't match the
existing data.

If we're issuing an O_CREAT open and find an existing inode, just
discard the precreated inode and create a new one to ensure the context
is properly set.

Also, we should never end up opening an existing file on an async
create, since we should know that the dentry doesn't exist. Throw a
warning if that ever does occur.

Cc: Luís Henriques <lhenriques@suse.de>
Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/ceph/mds_client.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

v2: WARN if this ever happens on an async create

diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
index 840a60b812fc..b3cf3a22fa2a 100644
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -3504,13 +3504,21 @@ static void handle_reply(struct ceph_mds_session *session, struct ceph_msg *msg)
 	/* Must find target inode outside of mutexes to avoid deadlocks */
 	rinfo = &req->r_reply_info;
 	if ((err >= 0) && rinfo->head->is_target) {
-		struct inode *in;
+		struct inode *in = xchg(&req->r_new_inode, NULL);
 		struct ceph_vino tvino = {
 			.ino  = le64_to_cpu(rinfo->targeti.in->ino),
 			.snap = le64_to_cpu(rinfo->targeti.in->snapid)
 		};
 
-		in = ceph_get_inode(mdsc->fsc->sb, tvino, xchg(&req->r_new_inode, NULL));
+		/* If we ended up opening an existing inode, discard r_new_inode */
+		if (req->r_op == CEPH_MDS_OP_CREATE && !req->r_reply_info.has_create_ino) {
+			/* This should never happen on an async create */
+			WARN_ON_ONCE(req->r_deleg_ino);
+			iput(in);
+			in = NULL;
+		}
+
+		in = ceph_get_inode(mdsc->fsc->sb, tvino, in);
 		if (IS_ERR(in)) {
 			err = PTR_ERR(in);
 			mutex_lock(&session->s_mutex);
-- 
2.35.1

