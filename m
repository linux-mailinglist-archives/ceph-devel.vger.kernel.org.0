Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8FBF91AD8BB
	for <lists+ceph-devel@lfdr.de>; Fri, 17 Apr 2020 10:38:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729799AbgDQIgA (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 17 Apr 2020 04:36:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729749AbgDQIgA (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Fri, 17 Apr 2020 04:36:00 -0400
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A0F8C061A0C;
        Fri, 17 Apr 2020 01:36:00 -0700 (PDT)
Received: by mail-pl1-x642.google.com with SMTP id ay1so729613plb.0;
        Fri, 17 Apr 2020 01:36:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=4QLRhq6ncbx33txx+lUViw8XofjfiGIYfFDkLE6el/g=;
        b=YVgpdYoiePmKpjkxliGptstAUcntBCNcszJR4qwGZQTaLz/TeDVK+uCgOqvkKgBshz
         4aXtaWtvivVpQdrRYXNVxAIRDU+C1oa+F5f0pihUBgxsINbo5zi4vsPOP7Syx0e0NA7u
         aM2GVtro1ThlIhW1LZxc0DvrgYh2gjurdWQwFS/8/n1ATtkHivQQyeIcXtf2ZNDpw+FT
         ACtDGHsHAvV5fq9aVRzmSMncXOTsKtAq9l3tFp02efakUxXXTZ0pvc0y7Bp5gaqnp9+N
         mbrFnBlrEBnerUATsfirA5y5XBa4ySPfPCYLsR5OAXynyVVzUMjjSREOEaWrJa9HZ+Dp
         gxkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=4QLRhq6ncbx33txx+lUViw8XofjfiGIYfFDkLE6el/g=;
        b=H+o71ORluC6oWIhq6lH9nu4vAbs27lGQN+FvQGumr9JV9SCr+uc9kjivY/kvNOQeLI
         GnnSqYlAgE+wQve5eoyhD12R9WcTgySiRgOx5HpwWm7CNRahvSGZ5DVXRnbe9CrG9vGP
         nvJxYuUEq2btASYWPdDOLXlQJUbiS2dQ+Qou7EDpOXUHCFjBHrSgGz+wwgU3Pv+e4roe
         S85NY9CBPSrrZTIUaSpCmIS0u5UByJ4l/1hslSpOskEUUgIm+Kuf/5VB66+qzIEz2R+J
         a4NzDqzLHvNVPTSANyOceLZ3vFjAW+1xancUPSt4GJV1MsSocLn/l3u8aIuqakx3KmYN
         vqtA==
X-Gm-Message-State: AGi0PuYqwXluFRPebJcNlVzAGW3EefkBCH5tbpw3HwSlKhpII1e71wjZ
        S9tNS3zGJL4FCjZPf2TUVDFSbu9b
X-Google-Smtp-Source: APiQypJioufUW7TEzYboWDBC3g+W2H1t4WIJr8JpXuTGtM3FNYBy6u4DU/LQafZmo5+wXrkf0vEQ7A==
X-Received: by 2002:a17:902:9a82:: with SMTP id w2mr2445787plp.117.1587112559701;
        Fri, 17 Apr 2020 01:35:59 -0700 (PDT)
Received: from MacBook-Pro.mshome.net ([122.224.153.228])
        by smtp.googlemail.com with ESMTPSA id ev5sm2690522pjb.1.2020.04.17.01.35.56
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 17 Apr 2020 01:35:59 -0700 (PDT)
From:   Yanhu Cao <gmayyyha@gmail.com>
To:     jlayton@kernel.org
Cc:     sage@redhat.com, idryomov@gmail.com, ceph-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org, Yanhu Cao <gmayyyha@gmail.com>
Subject: [PATCH] ceph: if we are blacklisted, __do_request returns directly
Date:   Fri, 17 Apr 2020 16:34:48 +0800
Message-Id: <20200417083448.9122-1-gmayyyha@gmail.com>
X-Mailer: git-send-email 2.24.2 (Apple Git-127)
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Signed-off-by: Yanhu Cao <gmayyyha@gmail.com>
---
 fs/ceph/mds_client.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
index 486f91f9685b..d2ea755b7c02 100644
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -2708,6 +2708,11 @@ static void __do_request(struct ceph_mds_client *mdsc,
 
 	put_request_session(req);
 
+	if (mdsc->fsc->blacklisted) {
+		err = -EACCES;
+		goto finish;
+	}
+
 	mds = __choose_mds(mdsc, req, &random);
 	if (mds < 0 ||
 	    ceph_mdsmap_get_state(mdsc->mdsmap, mds) < CEPH_MDS_STATE_ACTIVE) {
-- 
2.24.2 (Apple Git-127)

