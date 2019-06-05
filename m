Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CC18C35D8F
	for <lists+ceph-devel@lfdr.de>; Wed,  5 Jun 2019 15:11:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728010AbfFENLJ (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 5 Jun 2019 09:11:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:59452 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727941AbfFENLH (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Wed, 5 Jun 2019 09:11:07 -0400
Received: from tleilax.poochiereds.net (cpe-71-70-156-158.nc.res.rr.com [71.70.156.158])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DF79A20872;
        Wed,  5 Jun 2019 13:11:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559740266;
        bh=jN4Nd0DgRTJzBR2hdGQM1XAVgCysmLa1W1f+b3ABosE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1aJLNeHmNUZB6Ztg5Vkt69dh/C6jI+kVAVidICoKaaFga3C/KsSpdifaKwBHqSlVy
         nwmQOcxdWlxh2TjhnJcRGH0XJS4uKL+o9P2pmv9WlyyzARxRucDUx3JYJkTpniAgJz
         +NUuqHlwMNEcYBg34Zowy0yGULnlPcp1KB0Dxk4Q=
From:   Jeff Layton <jlayton@kernel.org>
To:     ceph-devel@vger.kernel.org
Cc:     idryomov@redhat.com, zyan@redhat.com, sage@redhat.com
Subject: [RFC PATCH 3/9] libceph: ADDR2 support for monmap
Date:   Wed,  5 Jun 2019 09:10:56 -0400
Message-Id: <20190605131102.13529-4-jlayton@kernel.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190605131102.13529-1-jlayton@kernel.org>
References: <20190605131102.13529-1-jlayton@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Switch the MonMap decoder to use the new decoding routine for
entity_addr_t's.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 include/linux/ceph/mon_client.h |  1 -
 net/ceph/mon_client.c           | 21 +++++++++++++--------
 2 files changed, 13 insertions(+), 9 deletions(-)

diff --git a/include/linux/ceph/mon_client.h b/include/linux/ceph/mon_client.h
index 3a4688af7455..b4d134d3312a 100644
--- a/include/linux/ceph/mon_client.h
+++ b/include/linux/ceph/mon_client.h
@@ -104,7 +104,6 @@ struct ceph_mon_client {
 #endif
 };
 
-extern struct ceph_monmap *ceph_monmap_decode(void *p, void *end);
 extern int ceph_monmap_contains(struct ceph_monmap *m,
 				struct ceph_entity_addr *addr);
 
diff --git a/net/ceph/mon_client.c b/net/ceph/mon_client.c
index 895679d3529b..0520bf9825aa 100644
--- a/net/ceph/mon_client.c
+++ b/net/ceph/mon_client.c
@@ -39,7 +39,7 @@ static int __validate_auth(struct ceph_mon_client *monc);
 /*
  * Decode a monmap blob (e.g., during mount).
  */
-struct ceph_monmap *ceph_monmap_decode(void *p, void *end)
+static struct ceph_monmap *ceph_monmap_decode(void *p, void *end)
 {
 	struct ceph_monmap *m = NULL;
 	int i, err = -EINVAL;
@@ -50,7 +50,7 @@ struct ceph_monmap *ceph_monmap_decode(void *p, void *end)
 	ceph_decode_32_safe(&p, end, len, bad);
 	ceph_decode_need(&p, end, len, bad);
 
-	dout("monmap_decode %p %p len %d\n", p, end, (int)(end-p));
+	dout("monmap_decode %p %p len %d (%d)\n", p, end, len, (int)(end-p));
 	p += sizeof(u16);  /* skip version */
 
 	ceph_decode_need(&p, end, sizeof(fsid) + 2*sizeof(u32), bad);
@@ -58,7 +58,6 @@ struct ceph_monmap *ceph_monmap_decode(void *p, void *end)
 	epoch = ceph_decode_32(&p);
 
 	num_mon = ceph_decode_32(&p);
-	ceph_decode_need(&p, end, num_mon*sizeof(m->mon_inst[0]), bad);
 
 	if (num_mon > CEPH_MAX_MON)
 		goto bad;
@@ -68,17 +67,22 @@ struct ceph_monmap *ceph_monmap_decode(void *p, void *end)
 	m->fsid = fsid;
 	m->epoch = epoch;
 	m->num_mon = num_mon;
-	ceph_decode_copy(&p, m->mon_inst, num_mon*sizeof(m->mon_inst[0]));
-	for (i = 0; i < num_mon; i++)
-		ceph_decode_addr(&m->mon_inst[i].addr);
-
+	for (i = 0; i < num_mon; ++i) {
+		struct ceph_entity_inst *inst = &m->mon_inst[i];
+
+		/* copy name portion */
+		ceph_decode_copy_safe(&p, end, &inst->name,
+					sizeof(inst->name), bad);
+		err = ceph_decode_entity_addr(&p, end, &inst->addr);
+		if (err)
+			goto bad;
+	}
 	dout("monmap_decode epoch %d, num_mon %d\n", m->epoch,
 	     m->num_mon);
 	for (i = 0; i < m->num_mon; i++)
 		dout("monmap_decode  mon%d is %s\n", i,
 		     ceph_pr_addr(&m->mon_inst[i].addr));
 	return m;
-
 bad:
 	dout("monmap_decode failed with %d\n", err);
 	kfree(m);
@@ -469,6 +473,7 @@ static void ceph_monc_handle_map(struct ceph_mon_client *monc,
 	if (IS_ERR(monmap)) {
 		pr_err("problem decoding monmap, %d\n",
 		       (int)PTR_ERR(monmap));
+		ceph_msg_dump(msg);
 		goto out;
 	}
 
-- 
2.21.0

