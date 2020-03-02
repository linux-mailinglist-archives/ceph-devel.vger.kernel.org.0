Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A3F70175CB7
	for <lists+ceph-devel@lfdr.de>; Mon,  2 Mar 2020 15:14:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727249AbgCBOOr (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 2 Mar 2020 09:14:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:39110 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727213AbgCBOOp (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Mon, 2 Mar 2020 09:14:45 -0500
Received: from tleilax.com (68-20-15-154.lightspeed.rlghnc.sbcglobal.net [68.20.15.154])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1ADB924676;
        Mon,  2 Mar 2020 14:14:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583158484;
        bh=qlx20cFK2R+EUGja4u7fE22u+CLpYM8N1NcdMrUKhAw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2i+MktSOBRvgVBMOPFBUYYX4UePyO9Qez54i4F8o+m630H+Y/bd/gJQzv5ZylPIqj
         uRuUXIgH+v3ClcZvbaHNz3BXRRFE0niqFeq/Q8aRizGrvn7hqWhA36i7QuQN1Jh/Jn
         wNJlKlC8Il9xPoxpgeubOjH3suI470CHwOQo0Tek=
From:   Jeff Layton <jlayton@kernel.org>
To:     ceph-devel@vger.kernel.org
Cc:     idryomov@gmail.com, sage@redhat.com, zyan@redhat.com,
        pdonnell@redhat.com
Subject: [PATCH v6 11/13] ceph: add new MDS req field to hold delegated inode number
Date:   Mon,  2 Mar 2020 09:14:32 -0500
Message-Id: <20200302141434.59825-12-jlayton@kernel.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200302141434.59825-1-jlayton@kernel.org>
References: <20200302141434.59825-1-jlayton@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Add new request field to hold the delegated inode number. Encode that
into the message when it's set.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/ceph/mds_client.c | 3 +--
 fs/ceph/mds_client.h | 1 +
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
index 87f75d05b004..e4ef3b47e2db 100644
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -2472,7 +2472,7 @@ static struct ceph_msg *create_request_message(struct ceph_mds_client *mdsc,
 	head->op = cpu_to_le32(req->r_op);
 	head->caller_uid = cpu_to_le32(from_kuid(&init_user_ns, req->r_uid));
 	head->caller_gid = cpu_to_le32(from_kgid(&init_user_ns, req->r_gid));
-	head->ino = 0;
+	head->ino = cpu_to_le64(req->r_deleg_ino);
 	head->args = req->r_args;
 
 	ceph_encode_filepath(&p, end, ino1, path1);
@@ -2633,7 +2633,6 @@ static int __prepare_send_request(struct ceph_mds_client *mdsc,
 	rhead->flags = cpu_to_le32(flags);
 	rhead->num_fwd = req->r_num_fwd;
 	rhead->num_retry = req->r_attempts - 1;
-	rhead->ino = 0;
 
 	dout(" r_parent = %p\n", req->r_parent);
 	return 0;
diff --git a/fs/ceph/mds_client.h b/fs/ceph/mds_client.h
index 4c3b71707470..4e5be79bf080 100644
--- a/fs/ceph/mds_client.h
+++ b/fs/ceph/mds_client.h
@@ -313,6 +313,7 @@ struct ceph_mds_request {
 	int               r_num_fwd;    /* number of forward attempts */
 	int               r_resend_mds; /* mds to resend to next, if any*/
 	u32               r_sent_on_mseq; /* cap mseq request was sent at*/
+	u64		  r_deleg_ino;
 
 	struct list_head  r_wait;
 	struct completion r_completion;
-- 
2.24.1

