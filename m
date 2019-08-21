Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 296B9978C5
	for <lists+ceph-devel@lfdr.de>; Wed, 21 Aug 2019 14:04:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726762AbfHUME4 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 21 Aug 2019 08:04:56 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:38589 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726353AbfHUME4 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 21 Aug 2019 08:04:56 -0400
Received: by mail-wm1-f66.google.com with SMTP id m125so1865530wmm.3
        for <ceph-devel@vger.kernel.org>; Wed, 21 Aug 2019 05:04:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=KYo4pY2fYjvzt8bKk4xleobI1ydhqkDfHUZZSoTQ5ss=;
        b=VgudGZk2VfuL6cKVlI8xT1Yoh0FOR07YEVkFYdH61KzqfQp+bAdF7eVnWAXupojEme
         O4DH9rHEv261Q8Fpy5Mhb0yYVmo8NVEYa6ZSaYHcpFFsx2hguhf+l4AZb+PXp5vnCvQD
         mGRifNM2kQHzjga81EzvRsvJkXKFfMqtH2Qd0AwdkaTAC8yhfY70Kl3z6WrETN7ovjsN
         R0tzEMGPX5EMVDkCpoy62Qll4YNG0k8rXMuxL5IGcBTtikVAJTId+iJ4vaVqQ0SB71eu
         uNnG0XrPGnSSV44dKnRqHBID9wQAQAMoawKThPyRH7mCrQQOv6NMtsMOL0VeRogwLraP
         bizg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=KYo4pY2fYjvzt8bKk4xleobI1ydhqkDfHUZZSoTQ5ss=;
        b=ZEefmWlj3MufaZKbcN2iQhP2kUpNJBg4y80kSqA8uF73zunf5jjC56ucSCeVU3WSRR
         lxJlxSt5JGw/apXQeev2RpjuYq/G69rbwAqEN396/RBj+8I/I9fiinH/gxFuQP+Qr5w7
         q2OXVgHNpQB9/zndlvuE225OFGv5LScG+uchqFbwN/EcUKKC84noVgslA0EwTmShMNDZ
         inu9+Ya+2MIDHivipKPlebayYSjoq3xoO7qvB7WnLjiTo/O2o7DbL/j0+ykCYQDuZk0g
         O9qpjO2D0v7/qK1l3Yr6SzbIchYxKELqZBE0HAyI3oN04HDLMqY2imtI+isdkdzrPyfP
         6XPw==
X-Gm-Message-State: APjAAAWe4v2HnlCO1p1/JP9wP/yJRY+O/vS+YvmvKb8C2UdZGvNDBUA6
        rMVtmHCg9tcZ3azwtBeaFCdPn+nb
X-Google-Smtp-Source: APXvYqy4i6i1zCga64XUdDPCU1U8d6NkK9NNOaUy5jOu5r9QqmyVTIcZVQbVrFoiIjTibzXOdwaPzA==
X-Received: by 2002:a7b:c091:: with SMTP id r17mr5372956wmh.74.1566389093012;
        Wed, 21 Aug 2019 05:04:53 -0700 (PDT)
Received: from kwango.redhat.com (ip-94-112-128-92.net.upcbroadband.cz. [94.112.128.92])
        by smtp.gmail.com with ESMTPSA id a18sm24360173wrt.18.2019.08.21.05.04.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Aug 2019 05:04:52 -0700 (PDT)
From:   Ilya Dryomov <idryomov@gmail.com>
To:     ceph-devel@vger.kernel.org
Cc:     Sage Weil <sage@redhat.com>, Jerry Lee <leisurelysw24@gmail.com>
Subject: [PATCH] libceph: fix PG split vs OSD (re)connect race
Date:   Wed, 21 Aug 2019 14:07:24 +0200
Message-Id: <20190821120724.23614-1-idryomov@gmail.com>
X-Mailer: git-send-email 2.19.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

We can't rely on ->peer_features in calc_target() because it may be
called both when the OSD session is established and open and when it's
not.  ->peer_features is not valid unless the OSD session is open.  If
this happens on a PG split (pg_num increase), that could mean we don't
resend a request that should have been resent, hanging the client
indefinitely.

In userspace this was fixed by looking at require_osd_release and
get_xinfo[osd].features fields of the osdmap.  However these fields
belong to the OSD section of the osdmap, which the kernel doesn't
decode (only the client section is decoded).

Instead, let's drop this feature check.  It effectively checks for
luminous, so only pre-luminous OSDs would be affected in that on a PG
split the kernel might resend a request that should not have been
resent.  Duplicates can occur in other scenarios, so both sides should
already be prepared for them: see dup/replay logic on the OSD side and
retry_attempt check on the client side.

Cc: stable@vger.kernel.org
Fixes: 7de030d6b10a ("libceph: resend on PG splits if OSD has RESEND_ON_SPLIT")
Reported-by: Jerry Lee <leisurelysw24@gmail.com>
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
---
 net/ceph/osd_client.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/net/ceph/osd_client.c b/net/ceph/osd_client.c
index fed6b0334609..4e78d1ddd441 100644
--- a/net/ceph/osd_client.c
+++ b/net/ceph/osd_client.c
@@ -1514,7 +1514,7 @@ static enum calc_target_result calc_target(struct ceph_osd_client *osdc,
 	struct ceph_osds up, acting;
 	bool force_resend = false;
 	bool unpaused = false;
-	bool legacy_change;
+	bool legacy_change = false;
 	bool split = false;
 	bool sort_bitwise = ceph_osdmap_flag(osdc, CEPH_OSDMAP_SORTBITWISE);
 	bool recovery_deletes = ceph_osdmap_flag(osdc,
@@ -1602,15 +1602,14 @@ static enum calc_target_result calc_target(struct ceph_osd_client *osdc,
 		t->osd = acting.primary;
 	}
 
-	if (unpaused || legacy_change || force_resend ||
-	    (split && con && CEPH_HAVE_FEATURE(con->peer_features,
-					       RESEND_ON_SPLIT)))
+	if (unpaused || legacy_change || force_resend || split)
 		ct_res = CALC_TARGET_NEED_RESEND;
 	else
 		ct_res = CALC_TARGET_NO_ACTION;
 
 out:
-	dout("%s t %p -> ct_res %d osd %d\n", __func__, t, ct_res, t->osd);
+	dout("%s t %p -> %d%d%d%d ct_res %d osd%d\n", __func__, t, unpaused,
+	     legacy_change, force_resend, split, ct_res, t->osd);
 	return ct_res;
 }
 
-- 
2.19.2

