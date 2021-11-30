Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51837463234
	for <lists+ceph-devel@lfdr.de>; Tue, 30 Nov 2021 12:21:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238708AbhK3LYV (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 30 Nov 2021 06:24:21 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:41841 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236283AbhK3LYU (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Tue, 30 Nov 2021 06:24:20 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1638271261;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=w+t99MP4NEPM0+hVBHLAIF3yi5XG8XshRFmq867KXrY=;
        b=TAaQQGsk8OFuzmyjgugYbE/fUT7ADYGSPM/tvxk3TcEH6NEjq2Pg5Q+jpQFFDP7exySw7J
        PWQ8yWoOTuxsaMcMwpgzb1OJ5SjHSm26EoKqznfszT/HGgC3HXpRKHsD8NYpnjICxA55/A
        NkGlrq6h2t5dMu7UthJ3WFxxC7vLhTs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-243-bARH7NkzNH2BsQjTcwnYyw-1; Tue, 30 Nov 2021 06:20:59 -0500
X-MC-Unique: bARH7NkzNH2BsQjTcwnYyw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5B1E384B9A2;
        Tue, 30 Nov 2021 11:20:58 +0000 (UTC)
Received: from fedora.redhat.com (ovpn-12-65.pek2.redhat.com [10.72.12.65])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6A1626060F;
        Tue, 30 Nov 2021 11:20:50 +0000 (UTC)
From:   xiubli@redhat.com
To:     jlayton@kernel.org
Cc:     idryomov@gmail.com, vshankar@redhat.com, ukernel@gmail.com,
        ceph-devel@vger.kernel.org, Xiubo Li <xiubli@redhat.com>
Subject: [PATCH] ceph: initialize pathlen variable in reconnect_caps_cb
Date:   Tue, 30 Nov 2021 19:20:34 +0800
Message-Id: <20211130112034.2711318-1-xiubli@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: Xiubo Li <xiubli@redhat.com>

Silence the potential compiler warning.

Fixes: a33f6432b3a6 (ceph: encode inodes' parent/d_name in cap reconnect message)
Signed-off-by: Xiubo Li <xiubli@redhat.com>
---
 fs/ceph/mds_client.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
index 87f20ed16c6e..2fc2b0a023e4 100644
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -3711,7 +3711,7 @@ static int reconnect_caps_cb(struct inode *inode, struct ceph_cap *cap,
 	struct ceph_pagelist *pagelist = recon_state->pagelist;
 	struct dentry *dentry;
 	char *path;
-	int pathlen, err;
+	int pathlen = 0, err;
 	u64 pathbase;
 	u64 snap_follows;
 
-- 
2.31.1

