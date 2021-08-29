Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA5123FADAC
	for <lists+ceph-devel@lfdr.de>; Sun, 29 Aug 2021 20:18:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235709AbhH2STc (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Sun, 29 Aug 2021 14:19:32 -0400
Received: from smtp-relay-canonical-0.canonical.com ([185.125.188.120]:51934
        "EHLO smtp-relay-canonical-0.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234080AbhH2STT (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Sun, 29 Aug 2021 14:19:19 -0400
Received: from localhost (1.general.cking.uk.vpn [10.172.193.212])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-canonical-0.canonical.com (Postfix) with ESMTPSA id C5B413F045;
        Sun, 29 Aug 2021 18:18:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1630261104;
        bh=vtkJ21NZ5st7A9TNC1m9k0qYl+hOlEeJL7XpCm/xgCY=;
        h=From:To:Cc:Subject:Date:Message-Id:MIME-Version;
        b=n5Gdta2xWHAf2lVWJZlToICeRn9N8LKE7cGo3s8RYytWs/f/HRT3eZG+s2Bs2RCsi
         mvEoKXzOA0Kqkbe5ZMob+i2kZEhZ+EskpSF12M5cdpJtJYQ6zeEMaWMDsFJMI00+d4
         FQPMR+9X0sZGPU2pqcolNp+oVIt2PqokyoXkpibKN0Lze7pUh5fDi3jMaHb5xRmmcj
         G59t77FMNRIoRA95SCP7KkvymYLW/sRyYFm43TKAyqSx7uJy56ptKJs6lwnk+budNf
         GHH/+4acq9FQ0I4IXOBAEpihCIme6MkzihPPUfkomW5vctpIGU+VMCZUB9lpweDCYG
         hczhQxHixvV3A==
From:   Colin King <colin.king@canonical.com>
To:     Jeff Layton <jlayton@kernel.org>,
        Ilya Dryomov <idryomov@gmail.com>,
        Xiubo Li <xiubli@redhat.com>, ceph-devel@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH][next] ceph: Fix dereference of null pointer cf
Date:   Sun, 29 Aug 2021 19:18:24 +0100
Message-Id: <20210829181824.534447-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

Currently in the case where kmem_cache_alloc fails the null pointer
cf is dereferenced when assigning cf->is_capsnap = false. Fix this
by adding a null pointer check and return path.

Addresses-Coverity: ("Dereference null return")
Fixes: b2f9fa1f3bd8 ("ceph: correctly handle releasing an embedded cap flush")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 fs/ceph/caps.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
index 39db97f149b9..eceb3ceaac48 100644
--- a/fs/ceph/caps.c
+++ b/fs/ceph/caps.c
@@ -1746,6 +1746,8 @@ struct ceph_cap_flush *ceph_alloc_cap_flush(void)
 	struct ceph_cap_flush *cf;
 
 	cf = kmem_cache_alloc(ceph_cap_flush_cachep, GFP_KERNEL);
+	if (!cf)
+		return NULL;
 	cf->is_capsnap = false;
 	return cf;
 }
-- 
2.32.0

