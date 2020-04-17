Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D1B321ADBDB
	for <lists+ceph-devel@lfdr.de>; Fri, 17 Apr 2020 13:09:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730095AbgDQLHb (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 17 Apr 2020 07:07:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729468AbgDQLHa (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Fri, 17 Apr 2020 07:07:30 -0400
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFAC5C061A0C;
        Fri, 17 Apr 2020 04:07:29 -0700 (PDT)
Received: by mail-pl1-x643.google.com with SMTP id k18so851192pll.6;
        Fri, 17 Apr 2020 04:07:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=qNf9by9mVcx85HZ3Z+9xf1bxw2bCzaI4yFqKMgY25eU=;
        b=vECTsvEYtCiUnyh0jrR2BP47JKSMnXSneOq8aE+ziAeoBultIAJ9SDL6puyx2jvJiV
         NUzONw91rE2WxcTpdbJqDEosmKReV2pO7jDNw+nN10Xqn6mLqkiqist5rs6+Z6PXJ//E
         IriYo9AoMojrVc9xERoXFm2dwlte/y1RVLiIp5e+JuAKVVBEWuPmYjvB0OTUHv9ICczo
         Lc2ryHpaeuNWqSW6O+In3y/kK920Y3z4M1ULJp2XOnCpCAkSbhZe7oHUIEmHnehITapW
         XTUcy9KiAXg+fjMKesbp1y6Oe8BXtAKobO3mJu55bQQ4p33NdVUIHhP2plp9R/rYwrlD
         h83A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=qNf9by9mVcx85HZ3Z+9xf1bxw2bCzaI4yFqKMgY25eU=;
        b=rnPqG01RGnoqBWIAhWwfPgyedaHHhhJGSu5akoedQUvFObBZ10XE10o6hAMfJLfyCi
         2IlzzocCG5aI2j7bCdZmh3IbDFZLGPnXCLwR37LYpU1Skg6B8mmYZOtknMdEG6eSiO0h
         hs+cZ7ExnlRxItK1BYnB2dTreS1v7u+90VNeh5Qih+cIcb9yWm1ZHDsCpjKUGsgxSzZI
         9ydedhufc+odD6qO84cRC0ps0xgVYBjZ4GPJymiO1EFiNfkM+gXTaT8HIcms0ryMZDKy
         RR32KrsQHBkOcuqW1VN21pLT2WV3CTZK34tbIaWf4uv+T2i2Vsdk+B0Z3WVB9l7JJLmh
         ihBA==
X-Gm-Message-State: AGi0PuagntJwmoloWsEdWEmefF+hUGlFkr41LqmlEYFBM3TE6MGV9pnU
        x8lJccRkBZFIudZR5AOpgS4=
X-Google-Smtp-Source: APiQypK1myE3GOJyq4yhBXF+vSOhsaxqBAupzLHb28bW+kLmdZfh+X3lJzkCXKorMSM8GpuJgc45+w==
X-Received: by 2002:a17:902:8a88:: with SMTP id p8mr2953777plo.134.1587121649228;
        Fri, 17 Apr 2020 04:07:29 -0700 (PDT)
Received: from MacBook-Pro.mshome.net ([122.224.153.228])
        by smtp.googlemail.com with ESMTPSA id g3sm18011395pgd.64.2020.04.17.04.07.27
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 17 Apr 2020 04:07:28 -0700 (PDT)
From:   Yanhu Cao <gmayyyha@gmail.com>
To:     jlayton@kernel.org
Cc:     sage@redhat.com, idryomov@gmail.com, ceph-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org, Yanhu Cao <gmayyyha@gmail.com>
Subject: [v3] ceph: if we are blacklisted, __do_request returns directly
Date:   Fri, 17 Apr 2020 19:07:23 +0800
Message-Id: <20200417110723.12235-1-gmayyyha@gmail.com>
X-Mailer: git-send-email 2.24.2 (Apple Git-127)
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

If we mount cephfs by the recover_session option,
__do_request can return directly until the client automatically reconnects.

Signed-off-by: Yanhu Cao <gmayyyha@gmail.com>
---
 fs/ceph/mds_client.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
index 486f91f9685b..16ac5e5f7f79 100644
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -2708,6 +2708,12 @@ static void __do_request(struct ceph_mds_client *mdsc,
 
 	put_request_session(req);
 
+	if (mdsc->fsc->blacklisted &&
+	    ceph_test_mount_opt(mdsc->fsc, CLEANRECOVER)) {
+		err = -EBLACKLISTED;
+		goto finish;
+	}
+
 	mds = __choose_mds(mdsc, req, &random);
 	if (mds < 0 ||
 	    ceph_mdsmap_get_state(mdsc->mdsmap, mds) < CEPH_MDS_STATE_ACTIVE) {
-- 
2.24.2 (Apple Git-127)

