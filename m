Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 39FABAEB1E
	for <lists+ceph-devel@lfdr.de>; Tue, 10 Sep 2019 15:07:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726527AbfIJNHU (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 10 Sep 2019 09:07:20 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:42402 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732884AbfIJNFY (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 10 Sep 2019 09:05:24 -0400
Received: by mail-pl1-f193.google.com with SMTP id x20so2974616plm.9
        for <ceph-devel@vger.kernel.org>; Tue, 10 Sep 2019 06:05:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=LOJ2zES3bk0QoKCPEn2hEsA+Dz8PVav4Qg38pwiXnIk=;
        b=bRMAWtrNntzaO0aYNlUKd5CcQwJiSEkys9GQ3x8hniD19SO6+0QDCcpGbi7QRz70ga
         cYhpMOjYip/Hux3o6UajbJ4iNFqjkj+Vn2oIp+sDzr9TU2g0bJVXEeQwVjbL2UThxp37
         DQaUhHE0yoAN89/owOZeWpiQLm28GEwPWbSPusiOzVKRVH5oHOJhBbCAwTCvdj2UVEFq
         9HIDQ4tz/2Gsu2+X0RaNB9tj3eL2526o5kXbP8qbVlNJdAp2AAIKReeANYWYfmDgSJXL
         LexwhvJN/gqR/wFHzc86Ft5WPw8Xcqzs1OEvzCkJabNuiTZC23o/vA8WjfHLfUhGoY8z
         Axqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=LOJ2zES3bk0QoKCPEn2hEsA+Dz8PVav4Qg38pwiXnIk=;
        b=l2OO/IcHPFzIPQdP396H4Ysf6WNJ0BJCMxr88lbJP89hdvxAUYCtpEQSqMeNXiyl+8
         FO4gPTgDCv+wS3IK3NAT5ihEbELBboUhk9YXMUdUKn4xWzuPKJ3ELCIknVm/J2KyuVkA
         AHnvDVkZrKw0Atiz1yesGS3/aacYMLu220/1VORtglueYYvvVVGmH2uWm+oGIbqnT5Ro
         AW4TuY9d0z79K+Qfeb5dgVNJ7Fvbdu48o0FvsqC4OvXMmGnx+Ky8k2kzmUxmN5AkPr6r
         raFQnmERa6NdLTsvJlHqO+mZQ3olTQpVB4sV3LbfNG3kfq/4BJHBWJlDvVethOwa8UmF
         Rj4A==
X-Gm-Message-State: APjAAAUx1xpqcKz+su69hQFBeTNdMW4fn4PBLWIFms84+WfOZ0zYwPgi
        j9IAInrjpsXkDCzT0PkmFONKkOK/
X-Google-Smtp-Source: APXvYqy7L9GRcAkZvUZP/ZtZd5J4dskiL9ktZiFlW/DCYE1VBLKR0c0JIzqDH8lk/J2huZBy1nZ9VA==
X-Received: by 2002:a17:902:b086:: with SMTP id p6mr30363875plr.315.1568120722064;
        Tue, 10 Sep 2019 06:05:22 -0700 (PDT)
Received: from localhost.localdomain ([103.112.79.192])
        by smtp.gmail.com with ESMTPSA id j18sm19911904pfh.70.2019.09.10.06.05.19
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Tue, 10 Sep 2019 06:05:21 -0700 (PDT)
From:   chenerqi@gmail.com
To:     ceph-devel@vger.kernel.org
Cc:     chenerqi@gmail.com, chenerqi <chenerqi@kuaishou.con>
Subject: [PATCH] ceph: reconnect connection if session hang in opening state
Date:   Tue, 10 Sep 2019 21:05:07 +0800
Message-Id: <20190910130507.46145-1-chenerqi@gmail.com>
X-Mailer: git-send-email 2.20.1 (Apple Git-117)
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: chenerqi <chenerqi@kuaishou.con>

If client mds session is evicted in CEPH_MDS_SESSION_OPENING state,
mds won't send session msg to client, and delayed_work skip
CEPH_MDS_SESSION_OPENING state session, the session hang forever.
ceph_con_keepalive reconnct connection for CEPH_MDS_SESSION_OPENING
session to avoid session hang.

Fixes: https://tracker.ceph.com/issues/41551
Signed-off-by: Erqi Chen chenerqi@gmail.com
---
 fs/ceph/mds_client.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
index 937e887..8f382b5 100644
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -3581,7 +3581,9 @@ static void delayed_work(struct work_struct *work)
 				pr_info("mds%d hung\n", s->s_mds);
 			}
 		}
-		if (s->s_state < CEPH_MDS_SESSION_OPEN) {
+		if (s->s_state == CEPH_MDS_SESSION_NEW ||
+		    s->s_state == CEPH_MDS_SESSION_RESTARTING ||
+		    s->s_state == CEPH_MDS_SESSION_REJECTED) {
 			/* this mds is failed or recovering, just wait */
 			ceph_put_mds_session(s);
 			continue;
-- 
1.8.3.1

