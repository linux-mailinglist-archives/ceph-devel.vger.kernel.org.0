Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 64FD2372937
	for <lists+ceph-devel@lfdr.de>; Tue,  4 May 2021 12:54:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230132AbhEDKy5 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 4 May 2021 06:54:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229903AbhEDKy4 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 4 May 2021 06:54:56 -0400
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25189C061574
        for <ceph-devel@vger.kernel.org>; Tue,  4 May 2021 03:54:01 -0700 (PDT)
Received: by mail-wr1-x429.google.com with SMTP id d4so8876389wru.7
        for <ceph-devel@vger.kernel.org>; Tue, 04 May 2021 03:54:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=uvqRG2lLyj0E01YCWvFf2QEH47nXMpFqDThiZzkdUmQ=;
        b=ARb5OHKK3mVE+YOSpz9dT912qCXDxx7gU8bOp0jwTy+uqBkix3c8p4zLB18/z6OvAc
         SEyveb60I3MORDgvTjGWn6ZxVCUYcIq0bsotTj1GwnPu/gUxszTGTfG7HjY9CDkKMvF9
         ibCPyxk1kZpRjvJ50EcKvy7QDQ0PNYl3FdVE1hyHyVfcBtdJFnUp3HIDiVgAS2qXRhFT
         ttWcMjCx9/oCjzmwQsQX8J9VuVkW3+zIugbWSuxUIyPsuokUc7FtSohwAjWGBPE/X0cz
         oSntrrsfibVl3S0ZeckaetNLIr9LB4kO3NzNlIqMYYXpzdStpT4IuXGBee9da0NmgEjQ
         /ugg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=uvqRG2lLyj0E01YCWvFf2QEH47nXMpFqDThiZzkdUmQ=;
        b=QVLR6jUwEgyhFN3ZYhy4RhnqmEXZqn7E1iZn3OpAmKRbYESWKovfs2idF5TRpIBoA2
         PctKN0KgylP2AuJtnWvLG/eGLZFSaN7Go5tPkDaUPJzdfRrXyr6FeogDOncW6D1T5E8+
         vVAyKAargTYDVWkdOAq0qt74KkEdlrZoTRqVmja7/bDbDAoVAPbiNRRXR+ki2daamuSx
         QHpm4nN+WW88+3FOP0EnVDDirfD+8l5c6djsMI00+afmCwt2iTD2dNu+wbDNFGNganQ1
         DqYeo3T90AL+WdVhleeT1RA3ouZKta/f0gsaRo/49ITxh5Cqg2gadBk7QoyT1KtD/DmI
         3Z9Q==
X-Gm-Message-State: AOAM532CDmV4cXim9Kb1tNYok5af/2eFlgWyrCq24XqckffmGc9dSfcL
        C6XiW+ISmCHkLzXoBc2bqaVnA4TGo+g8Kg==
X-Google-Smtp-Source: ABdhPJx+AdtN9/d42mfc+LMPZAcfuu7xNR//Ca5T4akR5G4ff5Xd8r8QDibbYwuiqOyXqhlx0gH3/g==
X-Received: by 2002:adf:f50c:: with SMTP id q12mr31057574wro.23.1620125639745;
        Tue, 04 May 2021 03:53:59 -0700 (PDT)
Received: from kwango.local (ip-94-112-132-16.net.upcbroadband.cz. [94.112.132.16])
        by smtp.gmail.com with ESMTPSA id f24sm2154028wmb.32.2021.05.04.03.53.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 May 2021 03:53:59 -0700 (PDT)
From:   Ilya Dryomov <idryomov@gmail.com>
To:     ceph-devel@vger.kernel.org
Cc:     Magnus Harlander <magnus@harlan.de>
Subject: [PATCH] libceph: allow addrvecs with a single NONE/blank address
Date:   Tue,  4 May 2021 12:54:08 +0200
Message-Id: <20210504105408.6035-1-idryomov@gmail.com>
X-Mailer: git-send-email 2.19.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Normally, an unused OSD id/slot is represented by an empty addrvec.
However, it also appears to be possible to generate an osdmap where
an unused OSD id/slot has an addrvec with a single blank address of
type NONE.  Allow such addrvecs and make the end result be exactly
the same as for the empty addrvec case -- leave addr intact.

Cc: stable@vger.kernel.org # 5.11+
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
---
 net/ceph/decode.c | 20 ++++++++++++++------
 1 file changed, 14 insertions(+), 6 deletions(-)

diff --git a/net/ceph/decode.c b/net/ceph/decode.c
index b44f7651be04..bc109a1a4616 100644
--- a/net/ceph/decode.c
+++ b/net/ceph/decode.c
@@ -4,6 +4,7 @@
 #include <linux/inet.h>
 
 #include <linux/ceph/decode.h>
+#include <linux/ceph/messenger.h>  /* for ceph_pr_addr() */
 
 static int
 ceph_decode_entity_addr_versioned(void **p, void *end,
@@ -110,6 +111,7 @@ int ceph_decode_entity_addrvec(void **p, void *end, bool msgr2,
 	}
 
 	ceph_decode_32_safe(p, end, addr_cnt, e_inval);
+	dout("%s addr_cnt %d\n", __func__, addr_cnt);
 
 	found = false;
 	for (i = 0; i < addr_cnt; i++) {
@@ -117,6 +119,7 @@ int ceph_decode_entity_addrvec(void **p, void *end, bool msgr2,
 		if (ret)
 			return ret;
 
+		dout("%s i %d addr %s\n", __func__, i, ceph_pr_addr(&tmp_addr));
 		if (tmp_addr.type == my_type) {
 			if (found) {
 				pr_err("another match of type %d in addrvec\n",
@@ -128,13 +131,18 @@ int ceph_decode_entity_addrvec(void **p, void *end, bool msgr2,
 			found = true;
 		}
 	}
-	if (!found && addr_cnt != 0) {
-		pr_err("no match of type %d in addrvec\n",
-		       le32_to_cpu(my_type));
-		return -ENOENT;
-	}
 
-	return 0;
+	if (found)
+		return 0;
+
+	if (!addr_cnt)
+		return 0;  /* normal -- e.g. unused OSD id/slot */
+
+	if (addr_cnt == 1 && !memchr_inv(&tmp_addr, 0, sizeof(tmp_addr)))
+		return 0;  /* weird but effectively the same as !addr_cnt */
+
+	pr_err("no match of type %d in addrvec\n", le32_to_cpu(my_type));
+	return -ENOENT;
 
 e_inval:
 	return -EINVAL;
-- 
2.19.2

