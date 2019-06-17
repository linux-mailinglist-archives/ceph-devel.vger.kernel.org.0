Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7188A48773
	for <lists+ceph-devel@lfdr.de>; Mon, 17 Jun 2019 17:38:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728437AbfFQPiE (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 17 Jun 2019 11:38:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:54646 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728368AbfFQPiE (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Mon, 17 Jun 2019 11:38:04 -0400
Received: from tleilax.poochiereds.net (cpe-71-70-156-158.nc.res.rr.com [71.70.156.158])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 29C41217D4;
        Mon, 17 Jun 2019 15:38:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560785883;
        bh=TXRXgpxgBKh0S83CIzm+PHLDc5g0o5VLpJxyp5EKY1E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=e+4LPmdKDfJiLhFnuvDAsNoWl3y2tH07MSRWKHTONP/ln+7Zem5ZAXrlBkOVNA36n
         VAG/sPmsSCSWvYh84o0xAsTOWq0qWb2XOfEt+Bq9V8RidSdI8KVis23SCPO1hgCU75
         Qoz4+nqgJxb125zVq5JAHDPpN/s/yghnsebK/1LM=
From:   Jeff Layton <jlayton@kernel.org>
To:     ceph-devel@vger.kernel.org
Cc:     zyan@redhat.com, sage@redhat.com, idryomov@gmail.com
Subject: [PATCH v2 10/18] libceph: rename ceph_encode_addr to ceph_encode_banner_addr
Date:   Mon, 17 Jun 2019 11:37:45 -0400
Message-Id: <20190617153753.3611-11-jlayton@kernel.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190617153753.3611-1-jlayton@kernel.org>
References: <20190617153753.3611-1-jlayton@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

...ditto for the decode function. We only use these functions to fix
up banner addresses now, so let's name them more appropriately.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 include/linux/ceph/decode.h | 4 ++--
 net/ceph/messenger.c        | 6 +++---
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/include/linux/ceph/decode.h b/include/linux/ceph/decode.h
index ce488d95be89..450384fe487c 100644
--- a/include/linux/ceph/decode.h
+++ b/include/linux/ceph/decode.h
@@ -221,7 +221,7 @@ static inline void ceph_encode_timespec64(struct ceph_timespec *tv,
 #define CEPH_ENTITY_ADDR_TYPE_NONE	0
 #define CEPH_ENTITY_ADDR_TYPE_LEGACY	__cpu_to_le32(1)
 
-static inline void ceph_encode_addr(struct ceph_entity_addr *a)
+static inline void ceph_encode_banner_addr(struct ceph_entity_addr *a)
 {
 	__be16 ss_family = htons(a->in_addr.ss_family);
 	a->in_addr.ss_family = *(__u16 *)&ss_family;
@@ -229,7 +229,7 @@ static inline void ceph_encode_addr(struct ceph_entity_addr *a)
 	/* Banner addresses require TYPE_NONE */
 	a->type = CEPH_ENTITY_ADDR_TYPE_NONE;
 }
-static inline void ceph_decode_addr(struct ceph_entity_addr *a)
+static inline void ceph_decode_banner_addr(struct ceph_entity_addr *a)
 {
 	__be16 ss_family = *(__be16 *)&a->in_addr.ss_family;
 	a->in_addr.ss_family = ntohs(ss_family);
diff --git a/net/ceph/messenger.c b/net/ceph/messenger.c
index 57cb0554c9e2..35a2f3be43e5 100644
--- a/net/ceph/messenger.c
+++ b/net/ceph/messenger.c
@@ -222,7 +222,7 @@ EXPORT_SYMBOL(ceph_pr_addr);
 static void encode_my_addr(struct ceph_messenger *msgr)
 {
 	memcpy(&msgr->my_enc_addr, &msgr->inst.addr, sizeof(msgr->my_enc_addr));
-	ceph_encode_addr(&msgr->my_enc_addr);
+	ceph_encode_banner_addr(&msgr->my_enc_addr);
 }
 
 /*
@@ -1734,14 +1734,14 @@ static int read_partial_banner(struct ceph_connection *con)
 	ret = read_partial(con, end, size, &con->actual_peer_addr);
 	if (ret <= 0)
 		goto out;
-	ceph_decode_addr(&con->actual_peer_addr);
+	ceph_decode_banner_addr(&con->actual_peer_addr);
 
 	size = sizeof (con->peer_addr_for_me);
 	end += size;
 	ret = read_partial(con, end, size, &con->peer_addr_for_me);
 	if (ret <= 0)
 		goto out;
-	ceph_decode_addr(&con->peer_addr_for_me);
+	ceph_decode_banner_addr(&con->peer_addr_for_me);
 
 out:
 	return ret;
-- 
2.21.0

