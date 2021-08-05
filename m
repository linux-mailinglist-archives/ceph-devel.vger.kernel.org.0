Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E1E63E149D
	for <lists+ceph-devel@lfdr.de>; Thu,  5 Aug 2021 14:21:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233079AbhHEMV1 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 5 Aug 2021 08:21:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232651AbhHEMV0 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 5 Aug 2021 08:21:26 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C927DC061765;
        Thu,  5 Aug 2021 05:21:12 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id ca5so8235620pjb.5;
        Thu, 05 Aug 2021 05:21:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=tYBF8AEB6pEKaPxKkV8X26OAKJGE7C1okpQvpGTHpTk=;
        b=sM+v16BJipcZPwUEp0bc1yXGQ/eA1OixqBY4UxpJRE5Ees4ur4ojvRdPKkaOxZSSn3
         pYAVu/77PYrr9vvqd0ILP1TL6YAA9CwXQTxWqLPv4fV11evhVpEt+EryMnZ8kF7TDUnx
         Fm4D6rcY1jBi5ZceUDM6h225eGIbCa9lRcLDh2hvtu1gay1TJHpoVkmQQwyFheI6NBzN
         D9e/3VFPlQRGbCjCHXyDAZ1/+2GZIciLXcJs/DeIkz+qdf49Ju34pdlghI1DTH2Wf4V7
         QSqr++IWczUqmde3Aeb3GfkXtdbm9SDGcMoS9yzpSNdYhQIwznES3WtpJ5r7d54MID3E
         csFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=tYBF8AEB6pEKaPxKkV8X26OAKJGE7C1okpQvpGTHpTk=;
        b=QEO3wAeAnXhdoRtYq32Xc/fXcUOsnC3sM/oQB2KIar+MNYQhlKpoEgHDLl3tZUGVUz
         IhgTev4j0ZuscJowTAuPxd43Wz6ODPXtFMY5Og3dh+KZtUHzQM8qUcXta4QUCUtlPPRq
         rD8QioapbT5Bp3K/HaWE+ekImObA0T3iiN4u3OtD3CRQNjl2PZCWZa2cGPwut8mkzstY
         GO8KZx6+OYMicsxZPSM97SQC5UXk5qaBKr+zz2l14pnmuo5anAfOAapI7n4Vk5SvLBWh
         wqhxcFvcA4+rYBzh5N63FvKpcsO87ranvhPWOOjXcpfu1uNCh7TtgS/bn5kv2w3qykGp
         28JA==
X-Gm-Message-State: AOAM532w6n0rjHdlWIk+ZRmOXwnJx/M7lx2eDpTQOc5h8dN3lF/v3SLc
        ucpijvLVu/0Ss1MzI07uUWM=
X-Google-Smtp-Source: ABdhPJz3m6j6FhZYgKYRxuhcoQoOtpc8w1ZkA1wXlB2LMAxmBUj/euM+/zqxS9cB5ZtS+jSU9j1x0A==
X-Received: by 2002:a17:90a:394c:: with SMTP id n12mr14802546pjf.45.1628166072403;
        Thu, 05 Aug 2021 05:21:12 -0700 (PDT)
Received: from localhost.localdomain ([45.135.186.81])
        by smtp.gmail.com with ESMTPSA id e13sm6576725pfi.210.2021.08.05.05.21.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Aug 2021 05:21:11 -0700 (PDT)
From:   Tuo Li <islituo@gmail.com>
To:     jlayton@kernel.org, idryomov@gmail.com
Cc:     ceph-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
        baijiaju1990@gmail.com, Tuo Li <islituo@gmail.com>,
        TOTE Robot <oslab@tsinghua.edu.cn>
Subject: [PATCH] ceph: fix possible null-pointer dereference in ceph_mdsmap_decode()
Date:   Thu,  5 Aug 2021 05:20:15 -0700
Message-Id: <20210805122015.129824-1-islituo@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

kcalloc() is called to allocate memory for m->m_info, and if it fails, 
ceph_mdsmap_destroy() behind the label out_err will be called:
  ceph_mdsmap_destroy(m);

In ceph_mdsmap_destroy(), m->m_info is dereferenced through:
  kfree(m->m_info[i].export_targets);

To fix this possible null-pointer dereference, if memory allocation
for m->m_info fails, free m and return -ENOMEM.

Reported-by: TOTE Robot <oslab@tsinghua.edu.cn>
Signed-off-by: Tuo Li <islituo@gmail.com>
---
 fs/ceph/mdsmap.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/ceph/mdsmap.c b/fs/ceph/mdsmap.c
index abd9af7727ad..7d73e4b64b12 100644
--- a/fs/ceph/mdsmap.c
+++ b/fs/ceph/mdsmap.c
@@ -166,8 +166,10 @@ struct ceph_mdsmap *ceph_mdsmap_decode(void **p, void *end, bool msgr2)
 	m->possible_max_rank = max(m->m_num_active_mds, m->m_max_mds);
 
 	m->m_info = kcalloc(m->possible_max_rank, sizeof(*m->m_info), GFP_NOFS);
-	if (!m->m_info)
-		goto nomem;
+	if (!m->m_info) {
+		kfree(m);
+		return ERR_PTR(-ENOMEM);
+	}
 
 	/* pick out active nodes from mds_info (state > 0) */
 	for (i = 0; i < n; i++) {
-- 
2.25.1

