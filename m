Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E441135D8D
	for <lists+ceph-devel@lfdr.de>; Wed,  5 Jun 2019 15:11:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727995AbfFENLH (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 5 Jun 2019 09:11:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:59444 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727749AbfFENLG (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Wed, 5 Jun 2019 09:11:06 -0400
Received: from tleilax.poochiereds.net (cpe-71-70-156-158.nc.res.rr.com [71.70.156.158])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 23DB720717;
        Wed,  5 Jun 2019 13:11:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559740265;
        bh=6akkNGTL8xzICECoOjR8XdMuLuWzUEj0wLgVC5S01M8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ARjHZ+KlTG0dLV8vQmwQW13JXnWowBh6SQK+s1cb8Fp0+OTWrdZp7NfICF8H6qHFn
         HSCCBQkO2F92MxMLGOHIpYi/B69eg65dFLIhsp0uoMaNp/BlbqekPZSRDvipyQ7fse
         QghgKCrOxWnQWiwtX0iYYfTl/egGdskKFYmfkhhg=
From:   Jeff Layton <jlayton@kernel.org>
To:     ceph-devel@vger.kernel.org
Cc:     idryomov@redhat.com, zyan@redhat.com, sage@redhat.com
Subject: [RFC PATCH 2/9] libceph: add ceph_decode_entity_addr
Date:   Wed,  5 Jun 2019 09:10:55 -0400
Message-Id: <20190605131102.13529-3-jlayton@kernel.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190605131102.13529-1-jlayton@kernel.org>
References: <20190605131102.13529-1-jlayton@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Add a way to decode an entity_addr_t. Once CEPH_FEATURE_MSG_ADDR2 is
enabled, the server daemons will start encoding entity_addr_t
differently.

Add a new helper function that can handle either format.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 include/linux/ceph/decode.h |  2 +
 net/ceph/Makefile           |  2 +-
 net/ceph/decode.c           | 75 +++++++++++++++++++++++++++++++++++++
 3 files changed, 78 insertions(+), 1 deletion(-)
 create mode 100644 net/ceph/decode.c

diff --git a/include/linux/ceph/decode.h b/include/linux/ceph/decode.h
index a6c2a48d42e0..1c0a665bfc03 100644
--- a/include/linux/ceph/decode.h
+++ b/include/linux/ceph/decode.h
@@ -230,6 +230,8 @@ static inline void ceph_decode_addr(struct ceph_entity_addr *a)
 	WARN_ON(a->in_addr.ss_family == 512);
 }
 
+extern int ceph_decode_entity_addr(void **p, void *end,
+				   struct ceph_entity_addr *addr);
 /*
  * encoders
  */
diff --git a/net/ceph/Makefile b/net/ceph/Makefile
index db09defe27d0..59d0ba2072de 100644
--- a/net/ceph/Makefile
+++ b/net/ceph/Makefile
@@ -5,7 +5,7 @@
 obj-$(CONFIG_CEPH_LIB) += libceph.o
 
 libceph-y := ceph_common.o messenger.o msgpool.o buffer.o pagelist.o \
-	mon_client.o \
+	mon_client.o decode.o \
 	cls_lock_client.o \
 	osd_client.o osdmap.o crush/crush.o crush/mapper.o crush/hash.o \
 	striper.o \
diff --git a/net/ceph/decode.c b/net/ceph/decode.c
new file mode 100644
index 000000000000..27edf5d341ec
--- /dev/null
+++ b/net/ceph/decode.c
@@ -0,0 +1,75 @@
+// SPDX-License-Identifier: GPL-2.0
+
+#include <linux/ceph/decode.h>
+
+int
+ceph_decode_entity_addr(void **p, void *end, struct ceph_entity_addr *addr)
+{
+	u8 marker, v, compat;
+	u32 len;
+
+	ceph_decode_8_safe(p, end, marker, bad);
+	if (marker == 1) {
+		ceph_decode_8_safe(p, end, v, bad);
+		ceph_decode_8_safe(p, end, compat, bad);
+		if (!v || compat != 1)
+			goto bad;
+		/* FIXME: sanity check? */
+		ceph_decode_32_safe(p, end, len, bad);
+		/* type is __le32, so we must copy into place as-is */
+		ceph_decode_copy_safe(p, end, &addr->type,
+					sizeof(addr->type), bad);
+
+		/*
+		 * TYPE_NONE == 0
+		 * TYPE_LEGACY == 1
+		 *
+		 * Clients that don't support ADDR2 always send TYPE_NONE.
+		 * For now, since all we support is msgr1, just set this to 0
+		 * when we get a TYPE_LEGACY type.
+		 */
+		if (addr->type == cpu_to_le32(1))
+			addr->type = 0;
+	} else if (marker == 0) {
+		addr->type = 0;
+		/* Skip rest of type field */
+		ceph_decode_skip_n(p, end, 3, bad);
+	} else {
+		goto bad;
+	}
+
+	ceph_decode_need(p, end, sizeof(addr->nonce), bad);
+	ceph_decode_copy(p, &addr->nonce, sizeof(addr->nonce));
+
+	/* addr length */
+	if (marker ==  1) {
+		ceph_decode_32_safe(p, end, len, bad);
+		if (len > sizeof(addr->in_addr))
+			goto bad;
+	} else  {
+		len = sizeof(addr->in_addr);
+	}
+
+	memset(&addr->in_addr, 0, sizeof(addr->in_addr));
+
+	if (len) {
+		ceph_decode_need(p, end, len, bad);
+		ceph_decode_copy(p, &addr->in_addr, len);
+
+		/*
+		 * Fix up sa_family. Legacy encoding sends it in BE, addr2
+		 * encoding uses LE.
+		 */
+		if (marker == 1)
+			addr->in_addr.ss_family =
+				le16_to_cpu((__force __le16)addr->in_addr.ss_family);
+		else
+			addr->in_addr.ss_family =
+				be16_to_cpu((__force __be16)addr->in_addr.ss_family);
+	}
+	return 0;
+bad:
+	return -EINVAL;
+}
+EXPORT_SYMBOL(ceph_decode_entity_addr);
+
-- 
2.21.0

