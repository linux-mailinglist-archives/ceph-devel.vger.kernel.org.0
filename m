Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ACDD8FB952
	for <lists+ceph-devel@lfdr.de>; Wed, 13 Nov 2019 21:03:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726210AbfKMUDu (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 13 Nov 2019 15:03:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:46826 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726066AbfKMUDu (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Wed, 13 Nov 2019 15:03:50 -0500
Received: from tleilax.poochiereds.net (68-20-15-154.lightspeed.rlghnc.sbcglobal.net [68.20.15.154])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 95417206E6;
        Wed, 13 Nov 2019 20:03:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573675430;
        bh=X74zquzncDkiZCDGdv26cs1YnPzFaYwj+R/CBo2Ww1g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VeTJuvXDYyfaKRSNsPmxELONcSScMkvxrKhMYAs7NVf+buN5CuBrkY3/nT7h4aIVU
         YOUbWKYzAHF142MmRCnJNAMdnty27q39X/oYjopwjLJv8uSn/MlcfoUOAe9Zp9j+2f
         eB3ZE33n93BsIHjNQnMDYPNVvu+XHllkKDIsD6Bo=
From:   Jeff Layton <jlayton@kernel.org>
To:     ceph-devel@vger.kernel.org
Cc:     sage@redhat.com, idryomov@gmail.com
Subject: [PATCH] ceph: don't leave ino field in ceph_mds_request_head uninitialized
Date:   Wed, 13 Nov 2019 15:03:48 -0500
Message-Id: <20191113200348.141572-2-jlayton@kernel.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191113200348.141572-1-jlayton@kernel.org>
References: <20191113200348.141572-1-jlayton@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

We currently just pass junk in this field unless we're retransmitting a
create, but in later patches, we'll need a mechanism to pass a delegated
inode number on an initial create request. Prepare for this by ensuring
this field is zeroed out.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/ceph/mds_client.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
index e6a5a07a65e5..8f9f8b8a225a 100644
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -2348,6 +2348,7 @@ static struct ceph_msg *create_request_message(struct ceph_mds_client *mdsc,
 	head->op = cpu_to_le32(req->r_op);
 	head->caller_uid = cpu_to_le32(from_kuid(&init_user_ns, req->r_uid));
 	head->caller_gid = cpu_to_le32(from_kgid(&init_user_ns, req->r_gid));
+	head->ino = 0;
 	head->args = req->r_args;
 
 	ceph_encode_filepath(&p, end, ino1, path1);
-- 
2.23.0

