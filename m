Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4AD9013CE74
	for <lists+ceph-devel@lfdr.de>; Wed, 15 Jan 2020 21:59:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729615AbgAOU7Z (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 15 Jan 2020 15:59:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:58200 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729532AbgAOU7W (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Wed, 15 Jan 2020 15:59:22 -0500
Received: from tleilax.poochiereds.net (68-20-15-154.lightspeed.rlghnc.sbcglobal.net [68.20.15.154])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 38B0A2467C;
        Wed, 15 Jan 2020 20:59:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579121961;
        bh=lYVZaX3aUHdiBFm5O2+l1y3sGcHPJ+pD/kmc0cDjArU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Lsp9QvNUmqJjBX4sWM/DYO2IPDlujSHyLV/UcvrF3XE4DcMRtEvxXQPANY5YwrM2m
         5gTjlV73dbGvnYsGxAsy6nBZalxP5isEgUiUQHyN9c9T5GPg+of/J0bmPZl7F9Tfhy
         u0rohy5lhYW3NkI13H3YH8Dqn6N9jgWa2GxfIlaA=
From:   Jeff Layton <jlayton@kernel.org>
To:     ceph-devel@vger.kernel.org
Cc:     zyan@redhat.com, sage@redhat.com, idryomov@gmail.com,
        pdonnell@redhat.com, xiubli@redhat.com
Subject: [RFC PATCH v2 08/10] ceph: add new MDS req field to hold delegated inode number
Date:   Wed, 15 Jan 2020 15:59:10 -0500
Message-Id: <20200115205912.38688-9-jlayton@kernel.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200115205912.38688-1-jlayton@kernel.org>
References: <20200115205912.38688-1-jlayton@kernel.org>
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
index e49ca0533df1..b8070e8c4686 100644
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -2466,7 +2466,7 @@ static struct ceph_msg *create_request_message(struct ceph_mds_client *mdsc,
 	head->op = cpu_to_le32(req->r_op);
 	head->caller_uid = cpu_to_le32(from_kuid(&init_user_ns, req->r_uid));
 	head->caller_gid = cpu_to_le32(from_kgid(&init_user_ns, req->r_gid));
-	head->ino = 0;
+	head->ino = cpu_to_le64(req->r_deleg_ino);
 	head->args = req->r_args;
 
 	ceph_encode_filepath(&p, end, ino1, path1);
@@ -2627,7 +2627,6 @@ static int __prepare_send_request(struct ceph_mds_client *mdsc,
 	rhead->flags = cpu_to_le32(flags);
 	rhead->num_fwd = req->r_num_fwd;
 	rhead->num_retry = req->r_attempts - 1;
-	rhead->ino = 0;
 
 	dout(" r_parent = %p\n", req->r_parent);
 	return 0;
diff --git a/fs/ceph/mds_client.h b/fs/ceph/mds_client.h
index 2a32afa15eb6..0811543ffd79 100644
--- a/fs/ceph/mds_client.h
+++ b/fs/ceph/mds_client.h
@@ -308,6 +308,7 @@ struct ceph_mds_request {
 	int               r_num_fwd;    /* number of forward attempts */
 	int               r_resend_mds; /* mds to resend to next, if any*/
 	u32               r_sent_on_mseq; /* cap mseq request was sent at*/
+	unsigned long	  r_deleg_ino;
 
 	struct list_head  r_wait;
 	struct completion r_completion;
-- 
2.24.1

