Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3EAFE3E17B1
	for <lists+ceph-devel@lfdr.de>; Thu,  5 Aug 2021 17:15:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241817AbhHEPP7 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 5 Aug 2021 11:15:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233196AbhHEPP6 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 5 Aug 2021 11:15:58 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54190C061765;
        Thu,  5 Aug 2021 08:15:42 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id dw2-20020a17090b0942b0290177cb475142so15585804pjb.2;
        Thu, 05 Aug 2021 08:15:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=m1E0Vz2zYUe2a6xBjsmkpxdjVocPM+t+MvTQpXM4T2Q=;
        b=CDZnwnqv/iklGJI//xgOAGalDkpOK/1OZ/Y5yBaKyBTuDTg+T/VGL+OW0vXKSec+If
         ZZlZFEU2e5K9eTIObjdOe+2N68+iFCqQUiBwiKdp2iyIEE9sjQDobIxHmB4YkTycI0tM
         XXtJrD+7XdI78OyAYbWDa3dOU+aHWGq0lZzKtEoSh0FVsFYJnWWXymgDvwgOGWTZt7D/
         G1KYm7LJ5nwRJpW2ILxUoAU6bPiQg0scDbLZTC+MJe8mZuIqH7U8c4Dkbs8odLp8TOb9
         1G/PF6RP4kVXbLftKxLXRaNdzics/pxl0w3svq4wbJx/sKb5hEMo7MIuhZEZDDQsYyHz
         8uCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=m1E0Vz2zYUe2a6xBjsmkpxdjVocPM+t+MvTQpXM4T2Q=;
        b=F4VtdMjdk26PCfkvjKvENhY55epUd+WGRq5OXPcXyb5F0/ArRlRdziHVNf4KaRHMnt
         DQENVv/PBRGLbtDNLEyc/hzNESegOGa4+K8ZUgemjPRD7DlZT+8oLVaxRhKB0qg/m3RH
         SHLtZpFw+PJ8ZP8QXTOBPAKtLnDRQlfVY/8VAk1Aj8Yt2ijlJcJb5CNM8v0DDIY7KFHA
         +urj5wswIcI4Qqn3Ou4qBrulQLrYVgjcciykFpJCWWpI9WiioatYCAaiMlSFWRgCl2fn
         XknOpyNJPO5YnBuTH5JRe3c5R4TXytvrYmKwYLDFwh0b9Jj+4Gg9OzYot77Lk0UfRs91
         W1ew==
X-Gm-Message-State: AOAM533I6rUcYkYBBopm1YpHXyC3KRfDkgezT1LVglx9QtNSmexe5tyd
        ZQw9BuvqB7V9YL6LqGyiNlc=
X-Google-Smtp-Source: ABdhPJzgEng28x3Rp+fU+Mr/Qm+y+cJxzZMjBx4q+nTTy4Wiecivn5MHgqDhEgSsbFqh1bk1b/e0Mg==
X-Received: by 2002:a63:5606:: with SMTP id k6mr934510pgb.21.1628176541912;
        Thu, 05 Aug 2021 08:15:41 -0700 (PDT)
Received: from localhost.localdomain ([45.135.186.81])
        by smtp.gmail.com with ESMTPSA id h5sm7074138pfv.145.2021.08.05.08.15.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Aug 2021 08:15:41 -0700 (PDT)
From:   Tuo Li <islituo@gmail.com>
To:     jlayton@kernel.org, idryomov@gmail.com
Cc:     ceph-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
        baijiaju1990@gmail.com, Tuo Li <islituo@gmail.com>,
        TOTE Robot <oslab@tsinghua.edu.cn>
Subject: [PATCH v2] ceph: fix possible null-pointer dereference in ceph_mdsmap_decode()
Date:   Thu,  5 Aug 2021 08:14:34 -0700
Message-Id: <20210805151434.142619-1-islituo@gmail.com>
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

To fix this possible null-pointer dereference, check m->m_info before the 
for loop to free m->m_info[i].export_targets.

Reported-by: TOTE Robot <oslab@tsinghua.edu.cn>
Signed-off-by: Tuo Li <islituo@gmail.com>
---
v2:
* Put an "if (m->m_info)" around the for loop in ceph_mdsmap_destroy()
instead of freeing m and returning -ENOMEM in ceph_mdsmap_decode().
  Thank Jeff Layton for helpful advice.
---
 fs/ceph/mdsmap.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/fs/ceph/mdsmap.c b/fs/ceph/mdsmap.c
index abd9af7727ad..26d6fa049b44 100644
--- a/fs/ceph/mdsmap.c
+++ b/fs/ceph/mdsmap.c
@@ -393,9 +393,11 @@ struct ceph_mdsmap *ceph_mdsmap_decode(void **p, void *end, bool msgr2)
 void ceph_mdsmap_destroy(struct ceph_mdsmap *m)
 {
 	int i;
-
-	for (i = 0; i < m->possible_max_rank; i++)
-		kfree(m->m_info[i].export_targets);
+	
+	if (m->m_info) {
+		for (i = 0; i < m->possible_max_rank; i++)
+			kfree(m->m_info[i].export_targets);
+	}
 	kfree(m->m_info);
 	kfree(m->m_data_pg_pools);
 	kfree(m);
-- 
2.25.1

