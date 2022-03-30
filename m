Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 353A14ECCE4
	for <lists+ceph-devel@lfdr.de>; Wed, 30 Mar 2022 21:05:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350512AbiC3TGv (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 30 Mar 2022 15:06:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350534AbiC3TGt (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 30 Mar 2022 15:06:49 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B32C8237DB
        for <ceph-devel@vger.kernel.org>; Wed, 30 Mar 2022 12:05:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6E820B81B72
        for <ceph-devel@vger.kernel.org>; Wed, 30 Mar 2022 19:05:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9801DC340EE;
        Wed, 30 Mar 2022 19:04:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648667100;
        bh=gzpoRQwho9A487LicQ8rWOy7USu64LLV6p0eytlxm1s=;
        h=From:To:Cc:Subject:Date:From;
        b=o/cHse9/d4a3i0BHo+JwccCsxjaOLzEEgToB1zfepZWEofEmDCc9NwwkCo9VclRKm
         XHL8/R3zF8MyOacSZ6BcvxQmwwqavTHcrSNnY6bgsSQZTnBfQkd4XLR9I6s5L1GPcP
         eBf6glgYvPLQKdKTyJPvBfkOfj+5MYxmNvSNwn7kA0yKVSUocgrrRUEjPE2tGa71hL
         5EhwsjHA4p17EfwKlkuh2VHikq26y74QTG9rK/bkvzW6xB+PqvClmh7T9tEzMpWxSm
         DbIAabCLCMyySyJMhUXHjBSlIfSyKg+sxUSht5qRELDq5Tij7OPfzwvRRugEzxOylh
         h4OEHJUdmqnvA==
From:   Jeff Layton <jlayton@kernel.org>
To:     ceph-devel@vger.kernel.org
Cc:     idryomov@gmail.com, xiubli@redhat.com,
        =?UTF-8?q?Lu=C3=ADs=20Henriques?= <lhenriques@suse.de>
Subject: [PATCH] ceph: discard r_new_inode if open O_CREAT opened existing inode
Date:   Wed, 30 Mar 2022 15:04:57 -0400
Message-Id: <20220330190457.73279-1-jlayton@kernel.org>
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

Cc: Luís Henriques <lhenriques@suse.de>
Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/ceph/mds_client.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
index 840a60b812fc..b03128fdbb07 100644
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -3504,13 +3504,19 @@ static void handle_reply(struct ceph_mds_session *session, struct ceph_msg *msg)
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

