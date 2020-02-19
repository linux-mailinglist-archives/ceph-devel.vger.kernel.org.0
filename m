Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 05E9B164553
	for <lists+ceph-devel@lfdr.de>; Wed, 19 Feb 2020 14:25:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727857AbgBSNZh (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 19 Feb 2020 08:25:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:33680 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727786AbgBSNZg (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Wed, 19 Feb 2020 08:25:36 -0500
Received: from tleilax.poochiereds.net (68-20-15-154.lightspeed.rlghnc.sbcglobal.net [68.20.15.154])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E7BB024654;
        Wed, 19 Feb 2020 13:25:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582118736;
        bh=H4mnYf1ncJe3Ch2XBOtYNHZ/ACL8WNG/2eYwkEyy7qs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Wqc+1mMgHFfEqpk9XVsjTvYlFjLHhejCngAjw8eLHSlW9X0RL7568ZJgCtVkA0xdI
         mjQ4RPih7IOkLRvXR1rguQS0zvtdZnjKHXF/88xvzLGBSg0I9AskO4oXcjuW1J1YpM
         IMJryYHYFaH1Ar7Twq9rdJSyNou1LgzWTZWo8FZQ=
From:   Jeff Layton <jlayton@kernel.org>
To:     ceph-devel@vger.kernel.org
Cc:     idryomov@gmail.com, sage@redhat.com, zyan@redhat.com,
        pdonnell@redhat.com, xiubli@redhat.com
Subject: [PATCH v5 10/12] ceph: add new MDS req field to hold delegated inode number
Date:   Wed, 19 Feb 2020 08:25:24 -0500
Message-Id: <20200219132526.17590-11-jlayton@kernel.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200219132526.17590-1-jlayton@kernel.org>
References: <20200219132526.17590-1-jlayton@kernel.org>
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
index 831578798b6e..925f6ca334b9 100644
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -2477,7 +2477,7 @@ static struct ceph_msg *create_request_message(struct ceph_mds_client *mdsc,
 	head->op = cpu_to_le32(req->r_op);
 	head->caller_uid = cpu_to_le32(from_kuid(&init_user_ns, req->r_uid));
 	head->caller_gid = cpu_to_le32(from_kgid(&init_user_ns, req->r_gid));
-	head->ino = 0;
+	head->ino = cpu_to_le64(req->r_deleg_ino);
 	head->args = req->r_args;
 
 	ceph_encode_filepath(&p, end, ino1, path1);
@@ -2638,7 +2638,6 @@ static int __prepare_send_request(struct ceph_mds_client *mdsc,
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

