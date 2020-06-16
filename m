Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 285991FAA42
	for <lists+ceph-devel@lfdr.de>; Tue, 16 Jun 2020 09:44:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727077AbgFPHoq (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 16 Jun 2020 03:44:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726573AbgFPHop (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 16 Jun 2020 03:44:45 -0400
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE11FC03E96A
        for <ceph-devel@vger.kernel.org>; Tue, 16 Jun 2020 00:44:44 -0700 (PDT)
Received: by mail-ej1-x643.google.com with SMTP id q19so20424023eja.7
        for <ceph-devel@vger.kernel.org>; Tue, 16 Jun 2020 00:44:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=B3M12iSdXWBB2adXOGU1Q0ONg9Z40Dwvb8wg1O/wB6E=;
        b=VRuZ+0wqcyw+9y8TlV2NaoALFqRmkJEMzsHDU8X5lIHVgXhYtJOXy/v0KlFVLLDP1M
         6DwVqAOuq3YkNFzAMi6xn2KLpeBR6qp0A92WCSciAj+nWO7IXCIPLybvY5fQDLA9aoWE
         iKqsknwse0NAUaQUof5tT3828DYfzyvTjaLPrjFrU7kzv39o8Jsy7KuTnQyoLWh7mD7N
         8v2rsN0fqSOUEwlPVC2XGMLzMEykw3NlKcFkdrjfYfXqLLE1OiopjgVGl6TFhLIZc2jm
         m/fPsj3DYInadhjmMppCCdPELPcx1UIpot8wmm7QvpMZPhBNuVulcf4ZFr79lh/8ghTn
         g6Ww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=B3M12iSdXWBB2adXOGU1Q0ONg9Z40Dwvb8wg1O/wB6E=;
        b=MmAEY8ssdFEYyf0ZRjQEeHqwb3tgtZXUHBaKMebI5FXN85G5pm5KuZqTIAyqbZiBX/
         q70Ew6WfC4jt29gyoaCeHwZCKQN15Cyz4t8q+ZzsXQJJU8eaqZZ62OLrlQLn8aUhWSPa
         jVNReoAy1aCbHjEMJ1AW0rYosj3T4mAPOvMM4WM+LP50mALKKLFWVPxUNJweTYuwVVfq
         OmhJg2YPBg0AXvJt825ooyk8YY1xBpAOSTrJyGMw3O0pLarU0KaDaSGSE44nEbid2Dy2
         Dzt0JwUHljvpuzx/X2aljiVHmTHEzopzMsrMxJovQrOjq9fcfqaU1j5eF08As9oFn7hw
         KTJA==
X-Gm-Message-State: AOAM533Kmme+bybzlWjN4HiHow+wX2GxE2vHS3yL7hEMpMhop/5/1cIM
        VNtcRycXeWXqfxrwDe4QGg/YPx8epRA=
X-Google-Smtp-Source: ABdhPJxICLfKS6+LIsndMa2tOiJcrT5vkLi0CZHqHimd0DrzQZtdoXSufM+VG4MHyXTxndwvcH1MqA==
X-Received: by 2002:a17:906:3a43:: with SMTP id a3mr1502569ejf.121.1592293483025;
        Tue, 16 Jun 2020 00:44:43 -0700 (PDT)
Received: from kwango.local (ip-94-112-129-237.net.upcbroadband.cz. [94.112.129.237])
        by smtp.gmail.com with ESMTPSA id j2sm9684562edn.30.2020.06.16.00.44.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Jun 2020 00:44:42 -0700 (PDT)
From:   Ilya Dryomov <idryomov@gmail.com>
To:     ceph-devel@vger.kernel.org
Cc:     Jeff Layton <jlayton@kernel.org>
Subject: [PATCH 1/3] libceph: don't omit recovery_deletes in target_copy()
Date:   Tue, 16 Jun 2020 09:44:13 +0200
Message-Id: <20200616074415.9989-2-idryomov@gmail.com>
X-Mailer: git-send-email 2.19.2
In-Reply-To: <20200616074415.9989-1-idryomov@gmail.com>
References: <20200616074415.9989-1-idryomov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Currently target_copy() is used only for sending linger pings, so
this doesn't come up, but generally omitting recovery_deletes can
result in unneeded resends (force_resend in calc_target()).

Fixes: ae78dd8139ce ("libceph: make RECOVERY_DELETES feature create a new interval")
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
---
 net/ceph/osd_client.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/ceph/osd_client.c b/net/ceph/osd_client.c
index a37d159019a0..8f7fbe861dff 100644
--- a/net/ceph/osd_client.c
+++ b/net/ceph/osd_client.c
@@ -445,6 +445,7 @@ static void target_copy(struct ceph_osd_request_target *dest,
 	dest->size = src->size;
 	dest->min_size = src->min_size;
 	dest->sort_bitwise = src->sort_bitwise;
+	dest->recovery_deletes = src->recovery_deletes;
 
 	dest->flags = src->flags;
 	dest->paused = src->paused;
-- 
2.19.2

