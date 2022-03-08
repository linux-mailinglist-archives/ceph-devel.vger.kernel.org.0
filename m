Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE79C4D1414
	for <lists+ceph-devel@lfdr.de>; Tue,  8 Mar 2022 11:00:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345571AbiCHKAz (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 8 Mar 2022 05:00:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345540AbiCHKAy (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 8 Mar 2022 05:00:54 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 1886E396AF
        for <ceph-devel@vger.kernel.org>; Tue,  8 Mar 2022 01:59:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646733597;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=/1icThg4dFaZfRIGm0Ft8ElR3BXSzYYYmrRl5K4eMiw=;
        b=IqjMb3PuHLJb5ZUXV7kpbv+1NI7xkCG0h8uwNb8OiTvf2MDPPM6tSOXKLjM8YDabFOpBj8
        U/XRoRaCsxOHtXn6YYOy2x57rdsogz17rtIsvQaXWnyXRL8BJcXjJ4akSVPW3P4MafAOxY
        MFurSoZYgs1EIRKQ9gTObtisapx+OFU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-490-zsQx6uWtND2HHiKNplnYKQ-1; Tue, 08 Mar 2022 04:59:53 -0500
X-MC-Unique: zsQx6uWtND2HHiKNplnYKQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D4E53801AFE;
        Tue,  8 Mar 2022 09:59:52 +0000 (UTC)
Received: from lxbceph1.gsslab.pek2.redhat.com (unknown [10.72.47.117])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1C76F21ECB;
        Tue,  8 Mar 2022 09:59:50 +0000 (UTC)
From:   xiubli@redhat.com
To:     jlayton@kernel.org, idryomov@gmail.com
Cc:     vshankar@redhat.com, ceph-devel@vger.kernel.org,
        Xiubo Li <xiubli@redhat.com>
Subject: [RFC PATCH] libceph: wait for con->work to finish when cancelling con
Date:   Tue,  8 Mar 2022 17:59:48 +0800
Message-Id: <20220308095948.1294468-1-xiubli@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: Xiubo Li <xiubli@redhat.com>

When reconnecting MDS it will reopen the con with new ip address,
but the when opening the con with new address it couldn't be sure
that the stale work has finished. So it's possible that the stale
work queued will use the new data.

This will use cancel_delayed_work_sync() instead.

URL: https://tracker.ceph.com/issues/54461
Signed-off-by: Xiubo Li <xiubli@redhat.com>
---
 net/ceph/messenger.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ceph/messenger.c b/net/ceph/messenger.c
index d3bb656308b4..32eb5dc00583 100644
--- a/net/ceph/messenger.c
+++ b/net/ceph/messenger.c
@@ -1416,7 +1416,7 @@ static void queue_con(struct ceph_connection *con)
 
 static void cancel_con(struct ceph_connection *con)
 {
-	if (cancel_delayed_work(&con->work)) {
+	if (cancel_delayed_work_sync(&con->work)) {
 		dout("%s %p\n", __func__, con);
 		con->ops->put(con);
 	}
-- 
2.27.0

