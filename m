Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A6D06FC4D5
	for <lists+ceph-devel@lfdr.de>; Thu, 14 Nov 2019 11:57:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726997AbfKNK5m (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 14 Nov 2019 05:57:42 -0500
Received: from mx2.suse.de ([195.135.220.15]:33316 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726142AbfKNK5l (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Thu, 14 Nov 2019 05:57:41 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 25E9CAD00;
        Thu, 14 Nov 2019 10:57:39 +0000 (UTC)
From:   Luis Henriques <lhenriques@suse.com>
To:     Jeff Layton <jlayton@kernel.org>, Sage Weil <sage@redhat.com>,
        Ilya Dryomov <idryomov@gmail.com>,
        "Yan, Zheng" <zyan@redhat.com>
Cc:     ceph-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Luis Henriques <lhenriques@suse.com>
Subject: [RFC PATCH v2 1/4] ceph: add support for TYPE_MSGR2 address decode
Date:   Thu, 14 Nov 2019 10:57:33 +0000
Message-Id: <20191114105736.8636-2-lhenriques@suse.com>
In-Reply-To: <20191114105736.8636-1-lhenriques@suse.com>
References: <20191114105736.8636-1-lhenriques@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

The new format actually includes two addresses: one the new messenger v2,
and other for the legacy v1, which is the only one currently understood
by kernel clients.  Add code to pick the legacy address and ignore the v2
one.

Signed-off-by: Luis Henriques <lhenriques@suse.com>
---
 include/linux/ceph/decode.h |  3 ++-
 net/ceph/decode.c           | 33 +++++++++++++++++++++++++++++++--
 2 files changed, 33 insertions(+), 3 deletions(-)

diff --git a/include/linux/ceph/decode.h b/include/linux/ceph/decode.h
index 450384fe487c..2a2f07dfb39c 100644
--- a/include/linux/ceph/decode.h
+++ b/include/linux/ceph/decode.h
@@ -219,7 +219,8 @@ static inline void ceph_encode_timespec64(struct ceph_timespec *tv,
  * sockaddr_storage <-> ceph_sockaddr
  */
 #define CEPH_ENTITY_ADDR_TYPE_NONE	0
-#define CEPH_ENTITY_ADDR_TYPE_LEGACY	__cpu_to_le32(1)
+#define CEPH_ENTITY_ADDR_TYPE_LEGACY	__cpu_to_le32(1) /* legacy msgr1 */
+#define CEPH_ENTITY_ADDR_TYPE_MSGR2	__cpu_to_le32(2) /* msgr2 protocol */
 
 static inline void ceph_encode_banner_addr(struct ceph_entity_addr *a)
 {
diff --git a/net/ceph/decode.c b/net/ceph/decode.c
index eea529595a7a..613a2bc6f805 100644
--- a/net/ceph/decode.c
+++ b/net/ceph/decode.c
@@ -67,16 +67,45 @@ ceph_decode_entity_addr_legacy(void **p, void *end,
 	return ret;
 }
 
+static int
+ceph_decode_entity_addr_versioned_msgr2(void **p, void *end,
+					struct ceph_entity_addr *addr)
+{
+	struct ceph_entity_addr tmp_addr;
+	struct ceph_entity_addr *paddr = addr;
+	int ret = -EINVAL;
+
+	ceph_decode_skip_32(p, end, bad); /* hard-coded '2' */
+	ceph_decode_skip_8(p, end, bad);  /* hard-coded '1' */
+
+	ret = ceph_decode_entity_addr_versioned(p, end, paddr);
+	if (ret)
+		goto bad;
+	/* If we already have a v1 address, simply skip over the other address */
+	if (paddr->type == CEPH_ENTITY_ADDR_TYPE_LEGACY)
+		paddr = &tmp_addr;
+
+	ceph_decode_skip_8(p, end, bad);  /* hard-coded '1' */
+
+	ret = ceph_decode_entity_addr_versioned(p, end, paddr);
+
+bad:
+	return ret;
+}
+
 int
 ceph_decode_entity_addr(void **p, void *end, struct ceph_entity_addr *addr)
 {
 	u8 marker;
 
 	ceph_decode_8_safe(p, end, marker, bad);
-	if (marker == 1)
+	if (marker == CEPH_ENTITY_ADDR_TYPE_MSGR2)
+		return ceph_decode_entity_addr_versioned_msgr2(p, end, addr);
+	else if (marker == CEPH_ENTITY_ADDR_TYPE_LEGACY)
 		return ceph_decode_entity_addr_versioned(p, end, addr);
-	else if (marker == 0)
+	else if (marker == CEPH_ENTITY_ADDR_TYPE_NONE)
 		return ceph_decode_entity_addr_legacy(p, end, addr);
+
 bad:
 	return -EINVAL;
 }
