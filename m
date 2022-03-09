Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D69EC4D2F1D
	for <lists+ceph-devel@lfdr.de>; Wed,  9 Mar 2022 13:34:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232544AbiCIMea (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 9 Mar 2022 07:34:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232224AbiCIMe3 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 9 Mar 2022 07:34:29 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4A304ECED
        for <ceph-devel@vger.kernel.org>; Wed,  9 Mar 2022 04:33:29 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 88374B8213D
        for <ceph-devel@vger.kernel.org>; Wed,  9 Mar 2022 12:33:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3B3FC340F3;
        Wed,  9 Mar 2022 12:33:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646829207;
        bh=4zk2LXcmz1QzsAbCIhW8VVj7sn/kHrQZ1DFlEWSRjqs=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=ghFjVEU1uq0uiWJeuPz47lX6h6u58gqH98KAWkG90bkBipE1rXYsEJybSvxw+Z8R6
         dnrjQSXvOhly3EOL9irqwvz0JmoH7DwnMqDEukOae+mVVUcYJdNIzxK+2iCniAQgob
         jGo0hJa6N/OXIte2K0VoHJCJTv57gCJxNIg0iozwrZCZEKX5rmSgn/SE7XiTAZxlzJ
         1g10ECeuh2kbla7mRZfoOGszw1Eyl915+JvFSUbYoW8Rs7/q8yWp7ppYdLYAUWoFK0
         hmp066re1xZpqD02HVVZNWXFUicPLR47pVxJML2XbUGb7RxQDIu9x8fancVWBU/Fia
         U0d0HazEd/5Bw==
From:   Jeff Layton <jlayton@kernel.org>
To:     ceph-devel@vger.kernel.org, idryomov@gmail.com
Subject: [PATCH 3/3] ceph: convert to sparse reads
Date:   Wed,  9 Mar 2022 07:33:23 -0500
Message-Id: <20220309123323.20593-4-jlayton@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220309123323.20593-1-jlayton@kernel.org>
References: <20220309123323.20593-1-jlayton@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/ceph/addr.c | 2 +-
 fs/ceph/file.c | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
index 752c421c9922..f42440d7102b 100644
--- a/fs/ceph/addr.c
+++ b/fs/ceph/addr.c
@@ -317,7 +317,7 @@ static void ceph_netfs_issue_op(struct netfs_read_subrequest *subreq)
 		return;
 
 	req = ceph_osdc_new_request(&fsc->client->osdc, &ci->i_layout, vino, subreq->start, &len,
-			0, 1, CEPH_OSD_OP_READ,
+			0, 1, CEPH_OSD_OP_SPARSE_READ,
 			CEPH_OSD_FLAG_READ | fsc->client->osdc.client->options->read_from_replica,
 			NULL, ci->i_truncate_seq, ci->i_truncate_size, false);
 	if (IS_ERR(req)) {
diff --git a/fs/ceph/file.c b/fs/ceph/file.c
index feb75eb1cd82..d1956a20c627 100644
--- a/fs/ceph/file.c
+++ b/fs/ceph/file.c
@@ -934,7 +934,7 @@ static ssize_t ceph_sync_read(struct kiocb *iocb, struct iov_iter *to,
 
 		req = ceph_osdc_new_request(osdc, &ci->i_layout,
 					ci->i_vino, off, &len, 0, 1,
-					CEPH_OSD_OP_READ, CEPH_OSD_FLAG_READ,
+					CEPH_OSD_OP_SPARSE_READ, CEPH_OSD_FLAG_READ,
 					NULL, ci->i_truncate_seq,
 					ci->i_truncate_size, false);
 		if (IS_ERR(req)) {
@@ -1291,7 +1291,7 @@ ceph_direct_read_write(struct kiocb *iocb, struct iov_iter *iter,
 					    vino, pos, &size, 0,
 					    1,
 					    write ? CEPH_OSD_OP_WRITE :
-						    CEPH_OSD_OP_READ,
+						    CEPH_OSD_OP_SPARSE_READ,
 					    flags, snapc,
 					    ci->i_truncate_seq,
 					    ci->i_truncate_size,
-- 
2.35.1

