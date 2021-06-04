Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B32439B1D0
	for <lists+ceph-devel@lfdr.de>; Fri,  4 Jun 2021 07:05:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230018AbhFDFHY (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 4 Jun 2021 01:07:24 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:39433 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229826AbhFDFHY (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Fri, 4 Jun 2021 01:07:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1622783138;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=DQOpmgYL0YZz/sjPt291XR/3p7tdkaX2wbNx75U0skI=;
        b=CXt7Yh1jHNfzK5ih8At1lX2mqQLUfe246/l1GWFsCyo/xY/4Udb/wHIMTFccnzzBI/Fghq
        koEcu12smjTSFWbCCnmbKZIY9XwN6+qga0NWqJxrsk4H6roo3ERcrAbmlQcXcVKl/jYR87
        NY+GSbjseM+3b+fqWp7FtFz7Iasqrro=
Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com
 [209.85.214.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-413-erJcYFRtN3KxO2vaQ5kaSQ-1; Fri, 04 Jun 2021 01:05:36 -0400
X-MC-Unique: erJcYFRtN3KxO2vaQ5kaSQ-1
Received: by mail-pl1-f197.google.com with SMTP id b15-20020a1709027e0fb02900fef41cdedfso3666872plm.3
        for <ceph-devel@vger.kernel.org>; Thu, 03 Jun 2021 22:05:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=DQOpmgYL0YZz/sjPt291XR/3p7tdkaX2wbNx75U0skI=;
        b=K+TjyxPkavpWtsXWdUzNNthLv0T3+8ReMME9REpMafzQvMu7+uqIbBoc8FJF0V6m6Z
         v+dDSd/WsL0jB6zZnkTVwOe098eFin9Silm4wnGrzS5LTbIQpcvxL11cx4IDQqNkJruG
         IFC/3UKoN2BvhtWM1VaakMs7jy9jNWe2JDI2qmSwby5yo2hPM0njUJ36rX4oun04LNBQ
         1+RpFpJNJI7pZqkgzL1tnu+/t/t0k4mEQYtkX17ZOeB3NCdjJQFC1EIT1/wV7Q98AHg8
         Z/TW3Gm1ahfeQbRrRnijeq0tEgKM178w6DkBn5s1MTz1xFMaVAyQ0Fx6QPD8dVdXb/Dj
         DbVQ==
X-Gm-Message-State: AOAM5318NUzrQFhI3XxDpoEX3z29t40EhFtw47208hLOAzy/QlV6sk6f
        c9cN4YQ0sBtSUw1nQKj7WJ/V+6Y/6OTUNJFYQ32UND7uxkJJ8BAmf+pnIEyYb8+EY7QZpZvElsP
        N8F0TGdiFcpXJtG6kJt4qxA==
X-Received: by 2002:aa7:8e5a:0:b029:2e9:10d3:376f with SMTP id d26-20020aa78e5a0000b02902e910d3376fmr2851243pfr.19.1622783135872;
        Thu, 03 Jun 2021 22:05:35 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxqink9jKuw6nLNpajs/wpuIDw3rB62tIwzF8NvufjwIk2AmXmA2Bii8uBfvOuX6qHU+PePuw==
X-Received: by 2002:aa7:8e5a:0:b029:2e9:10d3:376f with SMTP id d26-20020aa78e5a0000b02902e910d3376fmr2851234pfr.19.1622783135714;
        Thu, 03 Jun 2021 22:05:35 -0700 (PDT)
Received: from h3ckers-pride.redhat.com ([49.207.207.151])
        by smtp.gmail.com with ESMTPSA id s20sm3634897pjn.23.2021.06.03.22.05.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Jun 2021 22:05:35 -0700 (PDT)
From:   Venky Shankar <vshankar@redhat.com>
To:     jlayton@kernel.org
Cc:     ceph-devel@vger.kernel.org, Venky Shankar <vshankar@redhat.com>
Subject: [PATCH 2/3] ceph: record updated mon_addr on remount
Date:   Fri,  4 Jun 2021 10:35:11 +0530
Message-Id: <20210604050512.552649-3-vshankar@redhat.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210604050512.552649-1-vshankar@redhat.com>
References: <20210604050512.552649-1-vshankar@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Note that the new monitors are just shown in /proc/mounts.
Ceph does not (re)connect to new monitors yet.

Signed-off-by: Venky Shankar <vshankar@redhat.com>
---
 fs/ceph/super.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/fs/ceph/super.c b/fs/ceph/super.c
index e273eabb0397..ccbd72e53998 100644
--- a/fs/ceph/super.c
+++ b/fs/ceph/super.c
@@ -1169,6 +1169,12 @@ static int ceph_reconfigure_fc(struct fs_context *fc)
 	else
 		ceph_clear_mount_opt(fsc, ASYNC_DIROPS);
 
+	if (strcmp(fsc->mount_options->mon_addr, fsopt->mon_addr)) {
+		kfree(fsc->mount_options->mon_addr);
+		fsc->mount_options->mon_addr = kstrdup(fsopt->mon_addr,
+						       GFP_KERNEL);
+	}
+
 	sync_filesystem(fc->root->d_sb);
 	return 0;
 }
-- 
2.27.0

