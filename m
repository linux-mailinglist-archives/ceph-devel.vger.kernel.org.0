Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 242A64876C
	for <lists+ceph-devel@lfdr.de>; Mon, 17 Jun 2019 17:38:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728170AbfFQPh7 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 17 Jun 2019 11:37:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:54574 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726047AbfFQPh6 (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Mon, 17 Jun 2019 11:37:58 -0400
Received: from tleilax.poochiereds.net (cpe-71-70-156-158.nc.res.rr.com [71.70.156.158])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EF9D3208E4;
        Mon, 17 Jun 2019 15:37:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560785877;
        bh=Xa1SZzJ/N0jDOFTjFnhL4S7oWoHXWFMvgJURsztl0ww=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kpQfHFooOnKdi7vxmTF0Jm7vQGj/dKuozAvZWnT3ElMQVTxfB2FofkOvWhVQyaQ+X
         /q42xnulkwGX0l/aLMNYycPKcE5rmMUNJ7u1pnlr+h+XC5KaP6oVr5AT8lOdkPsAOB
         hlaNxzvxMJHJsd1nQ9GD2Gcy0AEP7BPrxZnzWPO4=
From:   Jeff Layton <jlayton@kernel.org>
To:     ceph-devel@vger.kernel.org
Cc:     zyan@redhat.com, sage@redhat.com, idryomov@gmail.com
Subject: [PATCH v2 02/18] libceph: add ceph_decode_entity_addr
Date:   Mon, 17 Jun 2019 11:37:37 -0400
Message-Id: <20190617153753.3611-3-jlayton@kernel.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190617153753.3611-1-jlayton@kernel.org>
References: <20190617153753.3611-1-jlayton@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Add a function for decoding an entity_addr_t. Once
CEPH_FEATURE_MSG_ADDR2 is enabled, the server daemons will start
encoding entity_addr_t differently.

Add a new helper function that can handle either format.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 include/linux/ceph/decode.h |  2 +
 net/ceph/Makefile           |  2 +-
 net/ceph/decode.c           | 90 +++++++++++++++++++++++++++++++++++++
 3 files changed, 93 insertions(+), 1 deletion(-)
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
index 000000000000..b82981199549
--- /dev/null
+++ b/net/ceph/decode.c
@@ -0,0 +1,90 @@
+// SPDX-License-Identifier: GPL-2.0
+
+#include <linux/ceph/decode.h>
+
+static int
+ceph_decode_entity_addr_versioned(void **p, void *end,
+				  struct ceph_entity_addr *addr)
+{
+	int ret;
+	u8 struct_v;
+	u32 struct_len, addr_len;
+	void *struct_end;
+
+	ret = ceph_start_decoding(p, end, 1, "entity_addr_t", &struct_v,
+				  &struct_len);
+	if (ret)
+		goto bad;
+
+	ret = -EINVAL;
+	struct_end = *p + struct_len;
+
+	ceph_decode_copy_safe(p, end, &addr->type, sizeof(addr->type), bad);
+
+	/*
+	 * TYPE_NONE == 0
+	 * TYPE_LEGACY == 1
+	 *
+	 * Clients that don't support ADDR2 always send TYPE_NONE.
+	 * For now, since all we support is msgr1, just set this to 0
+	 * when we get a TYPE_LEGACY type.
+	 */
+	if (addr->type == cpu_to_le32(1))
+		addr->type = 0;
+
+	ceph_decode_copy_safe(p, end, &addr->nonce, sizeof(addr->nonce), bad);
+
+	ceph_decode_32_safe(p, end, addr_len, bad);
+	if (addr_len > sizeof(addr->in_addr))
+		goto bad;
+
+	memset(&addr->in_addr, 0, sizeof(addr->in_addr));
+	if (addr_len) {
+		ceph_decode_copy_safe(p, end, &addr->in_addr, addr_len, bad);
+
+		addr->in_addr.ss_family =
+			le16_to_cpu((__force __le16)addr->in_addr.ss_family);
+	}
+
+	/* Advance past anything the client doesn't yet understand */
+	*p = struct_end;
+	ret = 0;
+bad:
+	return ret;
+}
+
+static int
+ceph_decode_entity_addr_legacy(void **p, void *end,
+			       struct ceph_entity_addr *addr)
+{
+	int ret = -EINVAL;
+
+	/* Skip rest of type field */
+	ceph_decode_skip_n(p, end, 3, bad);
+	addr->type = 0;
+	ceph_decode_copy_safe(p, end, &addr->nonce, sizeof(addr->nonce), bad);
+	memset(&addr->in_addr, 0, sizeof(addr->in_addr));
+	ceph_decode_copy_safe(p, end, &addr->in_addr,
+			      sizeof(addr->in_addr), bad);
+	addr->in_addr.ss_family =
+			be16_to_cpu((__force __be16)addr->in_addr.ss_family);
+	ret = 0;
+bad:
+	return ret;
+}
+
+int
+ceph_decode_entity_addr(void **p, void *end, struct ceph_entity_addr *addr)
+{
+	u8 marker;
+
+	ceph_decode_8_safe(p, end, marker, bad);
+	if (marker == 1)
+		return ceph_decode_entity_addr_versioned(p, end, addr);
+	else if (marker == 0)
+		return ceph_decode_entity_addr_legacy(p, end, addr);
+bad:
+	return -EINVAL;
+}
+EXPORT_SYMBOL(ceph_decode_entity_addr);
+
-- 
2.21.0

