Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7DAAE1FAA45
	for <lists+ceph-devel@lfdr.de>; Tue, 16 Jun 2020 09:44:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727110AbgFPHot (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 16 Jun 2020 03:44:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726912AbgFPHos (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 16 Jun 2020 03:44:48 -0400
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51498C05BD43
        for <ceph-devel@vger.kernel.org>; Tue, 16 Jun 2020 00:44:45 -0700 (PDT)
Received: by mail-ej1-x643.google.com with SMTP id p20so20379817ejd.13
        for <ceph-devel@vger.kernel.org>; Tue, 16 Jun 2020 00:44:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=a/P8QTJOjKVdkx3hKO16CUTO3uzcZ4IlulK2ctEy8mI=;
        b=rOm2OHntY9tRBjf+WwgU9alskE8Unmtf2/oXbROZJKat86x4KTAhvcdvXgzxz4C0ci
         g3NAZt77LmW6INl+9fg19Uy+YKdboHBMCAxEG9UB89TT72VjIPP49Uz/PnxCE8hbW57Q
         kCO1/w/1d+6c915irEfG9BBEFdoRCNh5u9t1C3fMNZLtJjJMO5JHz+O22O3Glq1jq2cq
         nDaAdZcgfNb1tKLbx9xx1RMeH3+COMWGO5mu0WsAMSiinrrTUjah3kCDktAWb72BipQD
         hmQ7WAlh/pYTECfI1gF+7mVkM/6G+7ZfV3C64AkqK7w1QIloiMsiH5E4yEpSCqEw3zaQ
         EWow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=a/P8QTJOjKVdkx3hKO16CUTO3uzcZ4IlulK2ctEy8mI=;
        b=fubcOBzo67imggDYk5nHV2NYVp8AkSPKbwLmhGQUA3C54xvGLNqUPad7+cEkvyH/jy
         xONKVLVX4z2C+YgokpUAV889sSkibfvKnnJ8D3tqTKEVCgnTWEw+sHEkabXSSec1pScj
         9NElx/gDUOyufAqeDCbGXUf0Z/5BDlKKAjKTXYf73Aee/l7O5R8YvjR4MyLGlz/WEJvU
         +N0Wbzjn/tOJaHHu+VijHstNbBUWLW0SCw2ULVIHeceunpU35zozLnvmWgyu5aVbNq7D
         npMJl8qf0TLg5tp9+K5Hhen84GHxN9QcN3fz/2A0NqfB9UG56kKKyJEtffkDhLrg71nq
         2Tww==
X-Gm-Message-State: AOAM531oOgrGs9Clu9F2NDpiiGtycK25ycMU+/KqV/FUcbCo8KzDxjjy
        Wdu+vb35MdIC8JS9DV+OZRbpZd5a2xE=
X-Google-Smtp-Source: ABdhPJwDc/G7P4y0hRhyOT9Fumz0I7/TqcwaHq0ClBAPbZGUMlRTtvFlsyUoAeBrJ+qO7kl+Zfo8vg==
X-Received: by 2002:a17:907:33ce:: with SMTP id zk14mr1568011ejb.2.1592293484050;
        Tue, 16 Jun 2020 00:44:44 -0700 (PDT)
Received: from kwango.local (ip-94-112-129-237.net.upcbroadband.cz. [94.112.129.237])
        by smtp.gmail.com with ESMTPSA id j2sm9684562edn.30.2020.06.16.00.44.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Jun 2020 00:44:43 -0700 (PDT)
From:   Ilya Dryomov <idryomov@gmail.com>
To:     ceph-devel@vger.kernel.org
Cc:     Jeff Layton <jlayton@kernel.org>
Subject: [PATCH 2/3] libceph: don't omit used_replica in target_copy()
Date:   Tue, 16 Jun 2020 09:44:14 +0200
Message-Id: <20200616074415.9989-3-idryomov@gmail.com>
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
this doesn't come up, but generally omitting used_replica can hang
the client as we wouldn't notice the acting set change (legacy_change
in calc_target()) or trigger a warning in handle_reply().

Fixes: 117d96a04f00 ("libceph: support for balanced and localized reads")
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
---
 net/ceph/osd_client.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/ceph/osd_client.c b/net/ceph/osd_client.c
index 8f7fbe861dff..2db8b44e70c2 100644
--- a/net/ceph/osd_client.c
+++ b/net/ceph/osd_client.c
@@ -448,6 +448,7 @@ static void target_copy(struct ceph_osd_request_target *dest,
 	dest->recovery_deletes = src->recovery_deletes;
 
 	dest->flags = src->flags;
+	dest->used_replica = src->used_replica;
 	dest->paused = src->paused;
 
 	dest->epoch = src->epoch;
-- 
2.19.2

