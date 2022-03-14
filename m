Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 63EFD4D8DD6
	for <lists+ceph-devel@lfdr.de>; Mon, 14 Mar 2022 21:07:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244932AbiCNUIt (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 14 Mar 2022 16:08:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241865AbiCNUIs (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 14 Mar 2022 16:08:48 -0400
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2EB0740A28
        for <ceph-devel@vger.kernel.org>; Mon, 14 Mar 2022 13:07:37 -0700 (PDT)
Received: by mail-ej1-x62f.google.com with SMTP id qx21so36509901ejb.13
        for <ceph-devel@vger.kernel.org>; Mon, 14 Mar 2022 13:07:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=18Jw+ZkKUsIRzWPTkwV9KvPjnCoNDMpqlNvMHml2UlI=;
        b=C8bnpxy9oUm+U8EWB8xnUrHCC7kr5eGE2mIB37aHBT0GQ+tnsxuNoMxaR7dxlEZUQO
         JN6eILjJK6+9zg1HTyBGaqzXz1mFOzBKAsTp2e4Y3tbZRu0W5kBkf9sELpR+NU7x1Pkr
         gQYQ6CZAUqEoeJb0x5ltFLhbdlRvJ30RZcQMKuuSS70Vm4+nZij4nnDtob+ZqandC/aT
         tktQr/riA30batlo53AE0kFKB+e3V1HG+MVI7TcMJnPbY2ePs21s2gZtMkl6y1fH70/e
         uZUYZYwTkV1G5XG92gTIftOyn0UnBqGKcTb3GfE8qndAStffgMKsQ9pf0qNoG1L0jB/M
         aXjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=18Jw+ZkKUsIRzWPTkwV9KvPjnCoNDMpqlNvMHml2UlI=;
        b=hXFFWboI6hUoKb9ChFAR1VrbcvzKOZM/kDBK/okgoirPzBmKzmx8Xh3/FqvmsK9/YE
         AoO9zQUDGO45tfW+cWxhITVcJohNJQ4d6dQZnxAFi7hilLLaYk+/taAV+8jYCRwlhZj1
         WrueaR02lXFDrmRvhYfQFJf80BApKaGXr0Ug0m5ecJNAURvjLrszEcbkzm/NM8SF0vr6
         oiSzQKLOTjO3l+hF8r92RjTNhN7jaVreT7gmxUilcCanAfyWsXNJw96/hG4cMDHUGW39
         IvqjBMxNmdQNpjIqa2QfQh3LaSFKT4LV5KCoCmsfPTVB8oigqW1Of96o+jtZIIIyKVHr
         qQYA==
X-Gm-Message-State: AOAM531vcY0f1u1g+oAC7nwCcwLeLP+cf2vDOYWslpTBEF44zHPhjsWN
        D10QF3ewWFo5BMesBgP3hXkv5h4hetHPUw==
X-Google-Smtp-Source: ABdhPJwoK5pCFWWByW082ior9KwQYiXCS3YFa7m1s+Fvd8wg/Q67EUc4Vd3fMJpk59JN7OwT9Gy/DA==
X-Received: by 2002:a17:907:e8e:b0:6db:472e:804a with SMTP id ho14-20020a1709070e8e00b006db472e804amr20329598ejc.529.1647288455723;
        Mon, 14 Mar 2022 13:07:35 -0700 (PDT)
Received: from nlaptop.localdomain (ptr-dtfv0poj8u7zblqwbt6.18120a2.ip6.access.telenet.be. [2a02:1811:cc83:eef0:f2b6:6987:9238:41ca])
        by smtp.gmail.com with ESMTPSA id u5-20020a170906b10500b006ce6fa4f510sm7205554ejy.165.2022.03.14.13.07.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Mar 2022 13:07:35 -0700 (PDT)
From:   Niels Dossche <dossche.niels@gmail.com>
To:     ceph-devel@vger.kernel.org
Cc:     Jeff Layton <jlayton@kernel.org>,
        Ilya Dryomov <idryomov@gmail.com>,
        Niels Dossche <dossche.niels@gmail.com>
Subject: [PATCH] ceph: get snap_rwsem read lock in handle_cap_export for ceph_add_cap
Date:   Mon, 14 Mar 2022 21:07:18 +0100
Message-Id: <20220314200717.52033-1-dossche.niels@gmail.com>
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
 fs/ceph/caps.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
index b472cd066d1c..0dd60db285b1 100644
--- a/fs/ceph/caps.c
+++ b/fs/ceph/caps.c
@@ -3903,8 +3903,10 @@ static void handle_cap_export(struct inode *inode, struct ceph_mds_caps *ex,
 		/* add placeholder for the export tagert */
 		int flag = (cap == ci->i_auth_cap) ? CEPH_CAP_FLAG_AUTH : 0;
 		tcap = new_cap;
+		down_read(&mdsc->snap_rwsem);
 		ceph_add_cap(inode, tsession, t_cap_id, issued, 0,
 			     t_seq - 1, t_mseq, (u64)-1, flag, &new_cap);
+		up_read(&mdsc->snap_rwsem);
 
 		if (!list_empty(&ci->i_cap_flush_list) &&
 		    ci->i_auth_cap == tcap) {
-- 
2.35.1

