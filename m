Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 72F342330E2
	for <lists+ceph-devel@lfdr.de>; Thu, 30 Jul 2020 13:22:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726951AbgG3LWv (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 30 Jul 2020 07:22:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726367AbgG3LWu (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 30 Jul 2020 07:22:50 -0400
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F614C061794;
        Thu, 30 Jul 2020 04:22:49 -0700 (PDT)
Received: by mail-pj1-x1041.google.com with SMTP id e22so4215400pjt.3;
        Thu, 30 Jul 2020 04:22:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=IwjGvmHYj5CwlmD5GYkZzUlslsm23kbi+AR0fiLStwE=;
        b=F2kDh3qK24YMvm0UIFUHs0oJeGnSx1evitnSLdEc4wCp4My/XY/gWcjDpepy6i7aAr
         +8Q4o9H3WCTovoZg4EjjWXR1CDlZ5cQvHzmmacQz2aK4wEbJqcpYMp5NAFqkxZ1iTgqG
         S58omo0hZLudRuScRY1JOq4F9mZ/U22nBLDt7amC4eaCqTb8VdeysD5VHT5epWSfoZrO
         jWc5n8SCpg8m+GzDDmeYPWYGsb8vk42IICG+4P0UKvQYqk6ZbO34Jmq5+4pyWBwpxmQy
         syDofhr9aKFyThw+oOSv5AGcq3Vw9+DJ6NIuJTyX/g4hzzEITwC2fOdlkrJlb5pBcxfB
         3hDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=IwjGvmHYj5CwlmD5GYkZzUlslsm23kbi+AR0fiLStwE=;
        b=lTbD4w2FnBUwUmhxn+uoOWv2ZMq4Cm8im2Po7ZOE4pyy/mJb2ZeNsh2QNCdfL36H2t
         RKS9tE6V7vgePbZn77VGSfv6kVk9oqCZbRrnWjc/ZCmHNAEu72wXBjQbBp6U4CYjqsII
         EwqK6WNsuTlyNWqrcfNvAdlPfleC6v4dIBpe7MVsLHh+T++pFTGjjDV+cSyssa9wSZ8Z
         d+MmGxRAT7+Bwdn8Gsi58d7yu8fJg4zAa1rSOGZj91pPScbKWXUtxGihDycicfY/ufH1
         rDF7x2E6pgp8DDeKoz+9udPns8U7gBmtHb2gih1atCNLEoX32Gc8hCTTcm9iLjIw/0US
         tzgg==
X-Gm-Message-State: AOAM530a8rXjfXp+hfF9yDwVO4TW/H3meQKCGr0/NlI1smJ9fkvnAC08
        jdTyrn+6SyvWkhqz1EDcZPzxuQ9/aQc=
X-Google-Smtp-Source: ABdhPJzTziGmekPWyfescjKyJeiO2PR5tcws6T0uYoASSTkChMWbCnIJguIFL05p9WI6j/3pXu3YeQ==
X-Received: by 2002:a17:902:bd8a:: with SMTP id q10mr33500723pls.236.1596108168933;
        Thu, 30 Jul 2020 04:22:48 -0700 (PDT)
Received: from localhost.localdomain ([122.224.153.227])
        by smtp.gmail.com with ESMTPSA id s22sm351176pfh.16.2020.07.30.04.22.46
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 30 Jul 2020 04:22:48 -0700 (PDT)
From:   Yanhu Cao <gmayyyha@gmail.com>
To:     jlayton@kernel.org
Cc:     idryomov@gmail.com, ceph-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org, Yanhu Cao <gmayyyha@gmail.com>
Subject: [PATCH] ceph: use frag's MDS in either mode
Date:   Thu, 30 Jul 2020 19:22:42 +0800
Message-Id: <20200730112242.31648-1-gmayyyha@gmail.com>
X-Mailer: git-send-email 2.24.3 (Apple Git-128)
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

if frag.mds != cap->session->s_mds, the client's req will be resent.

e.g.

file: mnt/cephfs/dir03/dir003 (0x10000000003)
ceph.dir.pin="1"

echo 'aaa' > /mnt/cephfs/dir03/dir003/file29

kernel: ceph:  __choose_mds 00000000ca362c7a is_hash=1 (0x7c768b89) mode 2
kernel: ceph:  __choose_mds 00000000ca362c7a 10000000003.fffffffffffffffe frag 0 mds1 (auth)
kernel: ceph:  __choose_mds 00000000ca362c7a 10000000003.fffffffffffffffe mds0 (auth cap 00000000679c38e2)
kernel: ceph:  __choose_mds using resend_mds mds1

Signed-off-by: Yanhu Cao <gmayyyha@gmail.com>
---
 fs/ceph/mds_client.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
index a50497142e59..b2255a9be7c0 100644
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -1103,8 +1103,7 @@ static int __choose_mds(struct ceph_mds_client *mdsc,
 				     frag.frag, mds);
 				if (ceph_mdsmap_get_state(mdsc->mdsmap, mds) >=
 				    CEPH_MDS_STATE_ACTIVE) {
-					if (mode == USE_ANY_MDS &&
-					    !ceph_mdsmap_is_laggy(mdsc->mdsmap,
+					if (!ceph_mdsmap_is_laggy(mdsc->mdsmap,
 								  mds))
 						goto out;
 				}
-- 
2.24.3 (Apple Git-128)

