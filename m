Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A6C854D9EB0
	for <lists+ceph-devel@lfdr.de>; Tue, 15 Mar 2022 16:30:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349628AbiCOPbS (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 15 Mar 2022 11:31:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239769AbiCOPbQ (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 15 Mar 2022 11:31:16 -0400
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09B7353B4A
        for <ceph-devel@vger.kernel.org>; Tue, 15 Mar 2022 08:30:03 -0700 (PDT)
Received: by mail-ed1-x52e.google.com with SMTP id g3so24722254edu.1
        for <ceph-devel@vger.kernel.org>; Tue, 15 Mar 2022 08:30:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=KfKrK/QJdDkpGvJWpaE7yeI/IO2My73P65+gsXPuDOg=;
        b=jbuuX9F1Zqvjetn2xrWR46whklPTVziY3wWPLN2YU8vEEYNVAmEJ8Fx+gs3G7rR8Ji
         5kiGkozCxayOEHoeLMD+r6pSWeWL3dRnCUjrAngXXpfIqpZzmuCvp8dttFpgtJfeeqtc
         2Jx0pNQcIxpVTX28Ws0eyVNe3JK+XDIVIUH/pkCnnmpKpGZobnhF07HXa26gaTuy/AkI
         RVKwEU1C2+2JtDtQDx6LKPcE6H8k2VU2YyRiBbG99TfN32R8sGjd/3dyxpXXBztB4P1L
         +OwMUdJNTO1VBf/3nUSs5SkcAOImt0inhgKHd70osUHhsGUrT35777qDjiFwy7GzNfcn
         c4jA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=KfKrK/QJdDkpGvJWpaE7yeI/IO2My73P65+gsXPuDOg=;
        b=5qJeev8Oh3gJ7TQvjAX1ozhy1BZOoabdTr7bnmKU7pZMMK760YcKLQf8p9be0vNMf2
         D3lZhE5ccgYSNzJxrUzoV4iGe1CxqPf4F6W74t/6Knm5dhMfwlQVOjK0NRT8Reb5wMFI
         gkc00hWI8Ae5z37+TwoAOXHn5MLSxR6F98HqtczpldHnaa/QXY4G/VhCI/dKrFkWBIuk
         FWLB7HWDLWN8Z6M7j/G9F8Pk02YaaTpt+PE4Jq7NdzMXn71uriK8DensCRoQqi6wb+bw
         hGLS5vV7o/wmDxtkJIRAJZvdKvclon3o7gJdZs5CKsuI9R9vyzjDK+L6prW3jBMnoJpY
         Gllg==
X-Gm-Message-State: AOAM530lF+OfDjRflF21/NwsSgKoR0sLpdqdHQ8Yw5Q5o0jQDujiKe0s
        bnNTSqbA/aZ6BU+MjcC4QW10FuiPT12Vdw==
X-Google-Smtp-Source: ABdhPJz582URHl4MVl83ag24p13t5U9gs+vO6UF2mL0Sr9XbrehfYRxLZ4a7DBIBTz3ilkeWa1d8EA==
X-Received: by 2002:a05:6402:150a:b0:416:c2f9:e287 with SMTP id f10-20020a056402150a00b00416c2f9e287mr22869545edw.192.1647358201523;
        Tue, 15 Mar 2022 08:30:01 -0700 (PDT)
Received: from nlaptop.localdomain (ptr-dtfv0poj8u7zblqwbt6.18120a2.ip6.access.telenet.be. [2a02:1811:cc83:eef0:f2b6:6987:9238:41ca])
        by smtp.gmail.com with ESMTPSA id e19-20020a056402105300b004162d0b4cbbsm9730396edu.93.2022.03.15.08.30.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Mar 2022 08:30:01 -0700 (PDT)
From:   Niels Dossche <dossche.niels@gmail.com>
To:     ceph-devel@vger.kernel.org
Cc:     Jeff Layton <jlayton@kernel.org>,
        Ilya Dryomov <idryomov@gmail.com>,
        Niels Dossche <dossche.niels@gmail.com>
Subject: [PATCH v2] ceph: get snap_rwsem read lock in handle_cap_export for ceph_add_cap
Date:   Tue, 15 Mar 2022 16:29:47 +0100
Message-Id: <20220315152946.12912-1-dossche.niels@gmail.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

ceph_add_cap says in its function documentation that the caller should
hold the read lock on the session snap_rwsem. Furthermore, not only
ceph_add_cap needs that lock, when it calls to ceph_lookup_snap_realm it
eventually calls ceph_get_snap_realm which states via lockdep that
snap_rwsem needs to be held. handle_cap_export calls ceph_add_cap
without that mdsc->snap_rwsem held. Thus, since ceph_get_snap_realm
and ceph_add_cap both need the lock, the common place to acquire that
lock is inside handle_cap_export.

Signed-off-by: Niels Dossche <dossche.niels@gmail.com>
---
 fs/ceph/caps.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
index b472cd066d1c..a23cf2a528bc 100644
--- a/fs/ceph/caps.c
+++ b/fs/ceph/caps.c
@@ -3856,6 +3856,7 @@ static void handle_cap_export(struct inode *inode, struct ceph_mds_caps *ex,
 	dout("handle_cap_export inode %p ci %p mds%d mseq %d target %d\n",
 	     inode, ci, mds, mseq, target);
 retry:
+	down_read(&mdsc->snap_rwsem);
 	spin_lock(&ci->i_ceph_lock);
 	cap = __get_cap_for_mds(ci, mds);
 	if (!cap || cap->cap_id != le64_to_cpu(ex->cap_id))
@@ -3919,6 +3920,7 @@ static void handle_cap_export(struct inode *inode, struct ceph_mds_caps *ex,
 	}
 
 	spin_unlock(&ci->i_ceph_lock);
+	up_read(&mdsc->snap_rwsem);
 	mutex_unlock(&session->s_mutex);
 
 	/* open target session */
@@ -3944,6 +3946,7 @@ static void handle_cap_export(struct inode *inode, struct ceph_mds_caps *ex,
 
 out_unlock:
 	spin_unlock(&ci->i_ceph_lock);
+	up_read(&mdsc->snap_rwsem);
 	mutex_unlock(&session->s_mutex);
 	if (tsession) {
 		mutex_unlock(&tsession->s_mutex);
-- 
2.35.1

