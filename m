Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1DB563BF707
	for <lists+ceph-devel@lfdr.de>; Thu,  8 Jul 2021 10:43:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231382AbhGHIps (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 8 Jul 2021 04:45:48 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:45760 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231355AbhGHIps (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 8 Jul 2021 04:45:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1625733786;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=p0nvQWZ1o/sDGjWheB2cwL9+k65hUTx5BPnlMy+GzJY=;
        b=GlbICNwBt/g5322CZv5PlMfDKxmkStBMvRvBVv4t4Piu/Zs2vJkBmF6HzTGZ49ifsAfUfa
        rSdY9AuP9pcTkrymv+UBMZhkc5dGkHpwelP/h0HSqvTF6fLwG7yuwWOEQMdA+J/eoIzY4q
        xbmTZCty3wuqGGcmyvzjO7fdGxjWGsE=
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com
 [209.85.214.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-231-PeH8Ioz8OSudG__4x75lwQ-1; Thu, 08 Jul 2021 04:43:05 -0400
X-MC-Unique: PeH8Ioz8OSudG__4x75lwQ-1
Received: by mail-pl1-f198.google.com with SMTP id z10-20020a170903018ab02901108a797206so1684405plg.16
        for <ceph-devel@vger.kernel.org>; Thu, 08 Jul 2021 01:43:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=p0nvQWZ1o/sDGjWheB2cwL9+k65hUTx5BPnlMy+GzJY=;
        b=qUY37EJUwdHlGN1JITTp35+BzW5KWp8w8agP0xQr9pSd/BXKM51/0sBHmBnZkU6VRI
         NfqeTZ0NQbIISmIeA/Li5ph6QLlKzFSH1jBO+VMKwdnhcMogHpwkFjRrzve7HYowOTUu
         IDB5zGRzcNz4gyi4NbLVuUViJ5D+MLEn+50X/Um8Ab4hvIn5DpbK1iBju10kKaTICN9i
         mrk3TImLj6VfnwvSCyPmNmmrMlV/WJXPhHbOuUTD3DJ6QPItKytbDle4S2SuPw2PVGIy
         f3r0Tvm3y4UxAVdgTcnxUg4GQZsh9FOULkBRKkXgnQEycuqReJojH+QcxtRn1Dq8Xc+L
         LnKA==
X-Gm-Message-State: AOAM530YIWWF3QX5bOL90Xd6oUdco+oI+30jsbK0cPRKoSwguZ6d8c9L
        giGxuIBgSTa+X3SMcFOSIP4EQrQQ4PjcgL7upPGFB+sxxV+1IbkWg0BYUwBaPtvO0gK7eF1JkpH
        RDgwBLEp1Fxmjqe6T1mYJtw==
X-Received: by 2002:a63:4002:: with SMTP id n2mr30420184pga.124.1625733784034;
        Thu, 08 Jul 2021 01:43:04 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJy+0BTZEQPemDZ+FbtCeP+FDc3HE5RYedJLtRmbz8Alz5xkBvY18Mw1kegWgMzwq/7f9zYEZw==
X-Received: by 2002:a63:4002:: with SMTP id n2mr30420166pga.124.1625733783899;
        Thu, 08 Jul 2021 01:43:03 -0700 (PDT)
Received: from h3ckers-pride.redhat.com ([49.207.223.150])
        by smtp.gmail.com with ESMTPSA id r14sm2154588pgm.28.2021.07.08.01.43.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Jul 2021 01:43:03 -0700 (PDT)
From:   Venky Shankar <vshankar@redhat.com>
To:     jlayton@redhat.com, idryomov@gmail.com, lhenriques@suse.de
Cc:     pdonnell@redhat.com, ceph-devel@vger.kernel.org,
        Venky Shankar <vshankar@redhat.com>
Subject: [PATCH v3 4/5] ceph: record updated mon_addr on remount
Date:   Thu,  8 Jul 2021 14:12:46 +0530
Message-Id: <20210708084247.182953-5-vshankar@redhat.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210708084247.182953-1-vshankar@redhat.com>
References: <20210708084247.182953-1-vshankar@redhat.com>
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
index 5bb998da191e..083b0b4b0f25 100644
--- a/fs/ceph/super.c
+++ b/fs/ceph/super.c
@@ -1268,6 +1268,12 @@ static int ceph_reconfigure_fc(struct fs_context *fc)
 	else
 		ceph_clear_mount_opt(fsc, ASYNC_DIROPS);
 
+	if (strcmp(fsc->mount_options->mon_addr, fsopt->mon_addr)) {
+		kfree(fsc->mount_options->mon_addr);
+		fsc->mount_options->mon_addr = fsopt->mon_addr;
+		fsopt->mon_addr = NULL;
+	}
+
 	sync_filesystem(fc->root->d_sb);
 	return 0;
 }
-- 
2.27.0

