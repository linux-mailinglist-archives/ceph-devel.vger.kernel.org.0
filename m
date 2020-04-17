Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5DE5A1ADA19
	for <lists+ceph-devel@lfdr.de>; Fri, 17 Apr 2020 11:38:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730291AbgDQJhQ (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 17 Apr 2020 05:37:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730131AbgDQJhP (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Fri, 17 Apr 2020 05:37:15 -0400
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B80D2C061A0C;
        Fri, 17 Apr 2020 02:37:15 -0700 (PDT)
Received: by mail-pg1-x541.google.com with SMTP id p8so852847pgi.5;
        Fri, 17 Apr 2020 02:37:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=8s/oCPK4WL2hZq8jZKgDQsrUlYP9Rih4kTn1YbLdhyY=;
        b=IoD1s1Pm5TgClqU+qaJ499vn9G9Ss3sJxKlhQlqEOQ/X0SWCvAkxRdBkX6Ad/quAUy
         lOwcGmWAIbv+B/8LNvqvvTEH4ojvCd55r7OMOVZGKotEzongZBq8wedbkEGntznmXZos
         u2KQdRiJGW+phBf7Aqv3tEBHWEeUYwChH1UPgYvoXXwvsmrJ23iSRTpxhBb5wueWwAP3
         DC2YGkaWhkgqy/eWFA6E6z+FEIq8qyWgHDJVB22V2vEuu/2dC7hxE7ChHmRXAoQzPrBE
         sHXcseHzrK9ofDjDtJ81RTdUI3J0U/EoD24rElddOX3lzB8FaRhbZTHrLTh3MJA2KjUU
         ujOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=8s/oCPK4WL2hZq8jZKgDQsrUlYP9Rih4kTn1YbLdhyY=;
        b=hoUHo7/1xhpqBhPy93uQZaTcrOoWytR4eeS9HtyfkG1qiMEV1V1vRvsWkR+P5miy7L
         LDvxVwxoiiOV/2u6ttg70gbjGtEE9mBKc3la4LGFV3861Q5haIQC5s3dAy5gFveVfOJr
         3hhccmFu/EdJIdLoAYlFb2CeZwJ0Hq1Dk/8hQLUbBL3oanWK1rOtUpIsMW6HeVThet1k
         WXmgKy4td8N+tiRKpY/Ktr7w3jodGrxt3oxkDpwI3sGhG9Q8ljPa3ZK9gwfknCsWjhIu
         PxFedUZCjGVJmETV/k9bSxmeTxLDj7s8AifmXWufW9j3kQHGSM9YAuZEo7vA3I4AgAZl
         Bgcg==
X-Gm-Message-State: AGi0PuYyLd48d+0n1MJzq1aKKN9q0lMQpW4nhCy/s/Y0ywZTHNQy1EEZ
        t1GGWI1yOZAxcx8Za5DzxY4=
X-Google-Smtp-Source: APiQypLL/2ihqphswfksyAaYitVMbud/Lkf3A6TDuyBvvgwaeM4JkyVm0IcSBYciFTrzPtfK8aZReg==
X-Received: by 2002:a65:64d0:: with SMTP id t16mr2061265pgv.415.1587116235268;
        Fri, 17 Apr 2020 02:37:15 -0700 (PDT)
Received: from MacBook-Pro.mshome.net ([122.224.153.228])
        by smtp.googlemail.com with ESMTPSA id g197sm17788539pfb.54.2020.04.17.02.37.12
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 17 Apr 2020 02:37:14 -0700 (PDT)
From:   Yanhu Cao <gmayyyha@gmail.com>
To:     jlayton@kernel.org
Cc:     sage@redhat.com, idryomov@gmail.com, ceph-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org, Yanhu Cao <gmayyyha@gmail.com>
Subject: [v2] ceph: if we are blacklisted, __do_request returns directly
Date:   Fri, 17 Apr 2020 17:36:26 +0800
Message-Id: <20200417093626.10892-1-gmayyyha@gmail.com>
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
index 486f91f9685b..e6cda256b136 100644
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -2708,6 +2708,12 @@ static void __do_request(struct ceph_mds_client *mdsc,
 
 	put_request_session(req);
 
+	if (mdsc->fsc->blacklisted &&
+	    ceph_test_mount_opt(mdsc->fsc, CLEANRECOVER)) {
+		err = -EACCES;
+		goto finish;
+	}
+
 	mds = __choose_mds(mdsc, req, &random);
 	if (mds < 0 ||
 	    ceph_mdsmap_get_state(mdsc->mdsmap, mds) < CEPH_MDS_STATE_ACTIVE) {
-- 
2.24.2 (Apple Git-127)

