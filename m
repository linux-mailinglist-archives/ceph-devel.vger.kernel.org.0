Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8481FA0310
	for <lists+ceph-devel@lfdr.de>; Wed, 28 Aug 2019 15:23:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726430AbfH1NW7 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 28 Aug 2019 09:22:59 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:41259 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726415AbfH1NW7 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 28 Aug 2019 09:22:59 -0400
Received: by mail-pg1-f195.google.com with SMTP id x15so1467912pgg.8
        for <ceph-devel@vger.kernel.org>; Wed, 28 Aug 2019 06:22:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=3gMt7j8eb66mbOEJC5iYPpeLQLnIod8UQNiHgqs210o=;
        b=hcI1ih6+ehxJFa+K7+Gg1lGKhqUrVL4vwncqdbBQt+73mpfhHVcEIreniZ0f/7T4OW
         V9oCWTgvDJfzbhOgWx7NxJ+VPXSeKslMM+jVDW9jQk0Y5G64ND/K9JXd8DlAyRUY3ywK
         +avrc98AiV/oQzqyhXElzDEAm2AhkbSwBROxKrYGFAINCnFtQm+pM0bUaisxaMofoweW
         EBD5GqMB9CdbV1zOfpoElw5vP+1jffd3DyIPOc5kY/g+zyX93n8tt+3g+gP1bVZ8OYhi
         x+oDwFYh/0yDk2MmAB+ViXf4lSR2c1eH5Ian7Dl7z982ls+o1uwN2uQnkGuBoX+38qAL
         y1kw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=3gMt7j8eb66mbOEJC5iYPpeLQLnIod8UQNiHgqs210o=;
        b=LP4KjdLBsHKxhuFFfdQEENtbHWDbZDXrf67RRX3chNYfik1FXLG36RLTtJaVZno4d3
         miVRYkP/XoeUGiu15g5Q3mhHdcayQPhaR9D5ZJyoUTZONBTMOWWQdKKGpJn3mRaWsr3v
         /5BDHmOQF5yyxtuqAvybG0RZ0hR7bO4XRgz4RLNRuS/oDUfCACmxp0RX6ML6NwuF+Di5
         wRO+Q7Z3TIG5X/ard6uPHokGQ5EupWW9Vrd0OlDzsyRW4pY2we/4ovln+N08jbWoCRqM
         OgIqDUUbkeY06rgfzI1XkVQPWR4I/Y1/o8kipuM0Y0N/Ro0azYrEVCJ58hEQGronjKQF
         3kGw==
X-Gm-Message-State: APjAAAXgQVALxjBpAQ31ROHecuRS/ps+RRTzsIDo7oxRuvb5WFlQwJia
        2toHEM5dq/1xKAKCYUQbr9fsqkdS
X-Google-Smtp-Source: APXvYqxudlSg4TnrMx1sOIPN+vPGrsJJ34XR1Nd+4F59qRY/i470a/wyAELzu0tx5uWnFaNfOZNJYA==
X-Received: by 2002:a17:90a:eb05:: with SMTP id j5mr4330109pjz.102.1566998577876;
        Wed, 28 Aug 2019 06:22:57 -0700 (PDT)
Received: from localhost.localdomain ([103.112.79.192])
        by smtp.gmail.com with ESMTPSA id 1sm3039659pfy.169.2019.08.28.06.22.55
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Wed, 28 Aug 2019 06:22:56 -0700 (PDT)
From:   chenerqi@gmail.com
To:     ceph-devel@vger.kernel.org
Cc:     chenerqi@gmail.com
Subject: [PATCH] ceph: reconnect connection if session hang in opening state
Date:   Wed, 28 Aug 2019 21:22:45 +0800
Message-Id: <20190828132245.53155-1-chenerqi@gmail.com>
X-Mailer: git-send-email 2.20.1 (Apple Git-117)
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: Erqi Chen <chenerqi@gmail.com>

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
index 920e9f0..3d589c0 100644
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -4044,7 +4044,9 @@ static void delayed_work(struct work_struct *work)
 				pr_info("mds%d hung\n", s->s_mds);
 			}
 		}
-		if (s->s_state < CEPH_MDS_SESSION_OPEN) {
+		if (s->s_state == CEPH_MDS_SESSION_NEW ||
+		    s->s_state == CEPH_MDS_SESSION_RESTARTING ||
+		    s->s_state == CEPH_MDS_SESSION_REJECTED)
 			/* this mds is failed or recovering, just wait */
 			ceph_put_mds_session(s);
 			continue;
-- 
1.8.3.1

