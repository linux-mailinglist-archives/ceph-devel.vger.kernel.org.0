Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4A734AEB23
	for <lists+ceph-devel@lfdr.de>; Tue, 10 Sep 2019 15:09:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726859AbfIJNJ3 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 10 Sep 2019 09:09:29 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:44624 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726535AbfIJNJ3 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 10 Sep 2019 09:09:29 -0400
Received: by mail-pl1-f193.google.com with SMTP id k1so8578958pls.11
        for <ceph-devel@vger.kernel.org>; Tue, 10 Sep 2019 06:09:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=8sni81AAeDy7+V1TUtysDTOU0ORh19ZqGGNWhUGKNZw=;
        b=DuI7GodqHPOGu+WwwGU6rwFB1/B7g3jb7Vlzt0MSD8+chIKanEgB+zWDE8r+iLXKIq
         zdLlUhmDJeFKFBBhfSnjh2zrOO7Wfirn3yz2hlylIjFhNGuJyswRvWA1hWRErIfPj3nb
         5Y6jnMwy0fI72y0V8F3CKclExQzLGqpSbUzM0YN43Iqfw+iwn6pc6TpsRk6mxMqIVzbI
         fD0PQ/QtzTA4963whn7XNsPt8KIb9I6DexRodam6NFa0muSphgvhg6aKQqRq0oSqoZrj
         6GjFOln+raFLm9w6nuBzf410MrceqRQg28RKU+iKXOzYDKGjGLKgO0ftbRu8nQeaAoHh
         1Pxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=8sni81AAeDy7+V1TUtysDTOU0ORh19ZqGGNWhUGKNZw=;
        b=T54/PwxQwgiuI5rSnedRLlHcsytgeJfCSW5jqUsX3Db2jvsNtNCZPjTVVEohIvsooo
         3lB+UaLU8pro8FCnE5gT83c/iE7GwauOA9PKpXOxTX89MgWpruj/xJNO9gQe4PAxRYzT
         ZXQYd2HfH6aPEyqufs9r91fOEKtJcp/iET3FVDbMDxtOWq/9+05t2YbR9EKxsbXPImN1
         DTK+lHiaf1ldacD8mHh7U8ApH5E8rIvAF8nFdKfjw6+o7n5zYFV6TVCsrUc3IFuiHkEL
         fyPESd7mGbFtmcTCPY4EPVabjJLecOgocg67JxE9ZUydRTq9gNP25hviM0WVG88K9Jal
         neZQ==
X-Gm-Message-State: APjAAAWzJuUMAFSIfW6s/Zakqm9bxzE24FVpwEJVmYC62OryXGjKopwt
        8aqVH/Oj0/O/UnjIfP7qrXsx7jgK
X-Google-Smtp-Source: APXvYqwSDtLRgv6S6cNp7fScd4chIq7wjGGumEzmQ0L9+GsiMQIx8QcS2GH1jPWxbASFexxgRkv5gg==
X-Received: by 2002:a17:902:7b84:: with SMTP id w4mr30924918pll.21.1568120967678;
        Tue, 10 Sep 2019 06:09:27 -0700 (PDT)
Received: from localhost.localdomain ([103.112.79.192])
        by smtp.gmail.com with ESMTPSA id j10sm2311736pjn.3.2019.09.10.06.09.25
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Tue, 10 Sep 2019 06:09:26 -0700 (PDT)
From:   chenerqi@gmail.com
To:     ceph-devel@vger.kernel.org
Cc:     chenerqi@gmail.com
Subject: [PATCH] ceph: reconnect connection if session hang in opening state
Date:   Tue, 10 Sep 2019 21:09:12 +0800
Message-Id: <20190910130912.46277-1-chenerqi@gmail.com>
X-Mailer: git-send-email 2.20.1 (Apple Git-117)
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: chenerqi <chenerqi@gmail.com>

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

