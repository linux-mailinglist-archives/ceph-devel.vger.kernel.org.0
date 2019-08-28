Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CD46C9FEE0
	for <lists+ceph-devel@lfdr.de>; Wed, 28 Aug 2019 11:49:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726315AbfH1JtQ (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 28 Aug 2019 05:49:16 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:45443 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726272AbfH1JtQ (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 28 Aug 2019 05:49:16 -0400
Received: by mail-pf1-f196.google.com with SMTP id w26so1355089pfq.12
        for <ceph-devel@vger.kernel.org>; Wed, 28 Aug 2019 02:49:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=T3dmgzRR7QP/aiUdjtA8loQcHBFOm8p3qiAP/UYbiGg=;
        b=YLWk0zY9VccG4+Qz/vE+1lf3uw5EVYKfHtMM3w/3nWAmV/8gZSOB6vqCfaYBplDqnd
         IdTRTAElvnXbbOt8hR51xXRqZKBFsfBeo/B9dkuaEAjh0hQQW+SFfNhlWPA8bXCu1Uee
         jD/L/MYYXz1pdJXK5OAdIQdftf4w0bEjuXYEHOpFubz+3gLCz9HGx+K2Zl+Ox9po8Z9z
         j8ig5vJ24HpGgxdU6YxTDHpayAOwImgWJdwAkJVZaMGnzQum0rkmmfzGAaBfG5B/5bMZ
         SifbJOm1tHyykVkH92+YMcBwDqDYXNl2ihMZC0vgB3O/+ESjQyVyejZFH4fGcg+PI4Ah
         AK6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=T3dmgzRR7QP/aiUdjtA8loQcHBFOm8p3qiAP/UYbiGg=;
        b=Gr2mEUInOd3yS9MdmjJnDsfgahYrVeaXu2eS+lYqL6PxXGgkev1LK9U8hytXC/SuGR
         97hCul7CHfcHDjKePIzR5Kj6jpcNoOI5jevnHDmT1E8+ju6RQADM0TeCVfyKiIzDuL3C
         dc7KrP32T+DAJiofENogcTopfRWMubYCRuYQyUprAzrsNiQF5QzAJnmEh4H5qxdeOkEb
         E9/vAqeglXs/+/YBxB0X7pxeYFHbftXlHpLgUvSXFKCZYh7ups0zIzHwS4hH5VwvG9OZ
         4fARN7fj+vwW+knXkGDahjUnCefSM1UlSdTs5Xgpgp5IWL3yZ03ourRer15DmO9Wbfr5
         TYcA==
X-Gm-Message-State: APjAAAWorEsfNpkQpOVWEtntuu0lYcc12U/FWWC7KdPoiWazG8D/gfZh
        RVeETJITWKn38FEXMJ20J7LtEV68
X-Google-Smtp-Source: APXvYqzcRlVn3Kdaa34lDA2AANz3erj3VURyg+TvqY/r09D5ZCNsEVULTM27KaecdPDVDQzH90Sbbg==
X-Received: by 2002:a65:6406:: with SMTP id a6mr2591740pgv.393.1566985755099;
        Wed, 28 Aug 2019 02:49:15 -0700 (PDT)
Received: from localhost.localdomain ([103.112.79.192])
        by smtp.gmail.com with ESMTPSA id 185sm2429980pff.54.2019.08.28.02.49.12
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Wed, 28 Aug 2019 02:49:14 -0700 (PDT)
From:   chenerqi@gmail.com
To:     ceph-devel@vger.kernel.org
Cc:     chenerqi@gmail.com
Subject: [PATCH] ceph: reconnect connection if session hang in opening state
Date:   Wed, 28 Aug 2019 17:48:55 +0800
Message-Id: <20190828094855.49918-1-chenerqi@gmail.com>
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
 fs/ceph/mds_client.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
index 920e9f0..eee4b63 100644
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -4044,7 +4044,7 @@ static void delayed_work(struct work_struct *work)
 				pr_info("mds%d hung\n", s->s_mds);
 			}
 		}
-		if (s->s_state < CEPH_MDS_SESSION_OPEN) {
+		if (s->s_state < CEPH_MDS_SESSION_OPENING) {
 			/* this mds is failed or recovering, just wait */
 			ceph_put_mds_session(s);
 			continue;
-- 
1.8.3.1

