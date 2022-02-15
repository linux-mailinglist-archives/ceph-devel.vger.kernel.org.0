Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4E6DF4B706B
	for <lists+ceph-devel@lfdr.de>; Tue, 15 Feb 2022 17:39:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239402AbiBOOwO (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 15 Feb 2022 09:52:14 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:33962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239274AbiBOOvw (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 15 Feb 2022 09:51:52 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3CBA10335B
        for <ceph-devel@vger.kernel.org>; Tue, 15 Feb 2022 06:50:46 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6533A61465
        for <ceph-devel@vger.kernel.org>; Tue, 15 Feb 2022 14:50:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9349C340ED;
        Tue, 15 Feb 2022 14:50:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644936646;
        bh=Y1UepD996ZVBQeXTYQkVW8UOJyx2GCaPuAI4XzeJAsA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AIPUou5n6UR/EVKG91WTyB3gaLf26Jo+n8x6h96nYsNyvO/bw5+W+XeSxmnY9Ga7o
         BF3NQzRUy6DTATPHgEOiOlR+ID/bHFfvYOiMltOwnM1EDhM0TO3fn3KsJJ3X4cxpeg
         TGHHCAUahIpdm0pdNo1t9WBQRHnrlQ92oH2b/kRoXo+YhBO7bCKtwjhcyZBIuzI3Qk
         qiiR0F68S4/5BUhkD6dGoLesntM7u/jJV5grWdwY4kQNc/6RFfI1FVNGVrG7qg0T9A
         g7rBnypBhaK0o6kW57aOjPYGc8kPEq7U97yXcgtDgbR47TCXyI7oA8Fsp8+og8+pYK
         II2QiGhahKjBA==
From:   Jeff Layton <jlayton@kernel.org>
To:     ceph-devel@vger.kernel.org
Cc:     idryomov@gmail.com
Subject: [RFC PATCH 5/5] ceph: switch to sparse reads
Date:   Tue, 15 Feb 2022 09:50:41 -0500
Message-Id: <20220215145041.26065-6-jlayton@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220215145041.26065-1-jlayton@kernel.org>
References: <20220215145041.26065-1-jlayton@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Switch the cephfs client to use sparse reads instead of normal ones.

XXX: doesn't currently work since OSD doesn't support truncate_seq
     on a sparse read. See: https://tracker.ceph.com/issues/54280

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/ceph/addr.c | 2 +-
 fs/ceph/file.c | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
index 46e0881ae8b2..565cc2197dd1 100644
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
2.34.1

