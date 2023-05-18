Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 28CDE707799
	for <lists+ceph-devel@lfdr.de>; Thu, 18 May 2023 03:49:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229587AbjERBtm (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 17 May 2023 21:49:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229498AbjERBtl (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 17 May 2023 21:49:41 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5D0230C1
        for <ceph-devel@vger.kernel.org>; Wed, 17 May 2023 18:48:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1684374536;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=7mNItRunzXktZzmomOwmCwa87E9KiZDSCQNWYrpAb80=;
        b=KF3MKRgKISf1Mwh6poyvCvexVYoAPfk5tko2QoHM33zivJgNgeAzWsPU1vQc6JtyYg64rh
        lAzUbOOsIagIZR+JL+IJ3hKV9XVpjHntxTFjKTcsjBAMXDb3qfq8+ZqC0RRQcm3Qh9tFHi
        iIZJC1D0R8/6OjjSx4gEMFv5v+T+qLE=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-590-9BrxVHWjOdudt_oScXUJ2g-1; Wed, 17 May 2023 21:48:53 -0400
X-MC-Unique: 9BrxVHWjOdudt_oScXUJ2g-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id AFEBA381458E;
        Thu, 18 May 2023 01:48:52 +0000 (UTC)
Received: from li-a71a4dcc-35d1-11b2-a85c-951838863c8d.ibm.com.com (ovpn-12-110.pek2.redhat.com [10.72.12.110])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7E28163F8E;
        Thu, 18 May 2023 01:48:49 +0000 (UTC)
From:   xiubli@redhat.com
To:     idryomov@gmail.com, ceph-devel@vger.kernel.org
Cc:     jlayton@kernel.org, vshankar@redhat.com,
        Xiubo Li <xiubli@redhat.com>
Subject: [PATCH] ceph: try to dump the msgs when decoding fails
Date:   Thu, 18 May 2023 09:48:42 +0800
Message-Id: <20230518014842.148580-1-xiubli@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: Xiubo Li <xiubli@redhat.com>

When the msgs are corrupted we need to dump them and then it will
be easier to dig what has happened and where the issue is.

Signed-off-by: Xiubo Li <xiubli@redhat.com>
---
 fs/ceph/mds_client.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
index d6467fe7e5fa..0dd44747f5b4 100644
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -783,6 +783,7 @@ static int parse_reply_info(struct ceph_mds_session *s, struct ceph_msg *msg,
 	err = -EIO;
 out_bad:
 	pr_err("mds parse_reply err %d\n", err);
+	ceph_msg_dump(msg);
 	return err;
 }
 
@@ -3892,6 +3893,7 @@ static void handle_forward(struct ceph_mds_client *mdsc,
 
 bad:
 	pr_err("mdsc_handle_forward decode error err=%d\n", err);
+	ceph_msg_dump(msg);
 }
 
 static int __decode_session_metadata(void **p, void *end,
@@ -5620,6 +5622,7 @@ void ceph_mdsc_handle_fsmap(struct ceph_mds_client *mdsc, struct ceph_msg *msg)
 bad:
 	pr_err("error decoding fsmap %d. Shutting down mount.\n", err);
 	ceph_umount_begin(mdsc->fsc->sb);
+	ceph_msg_dump(msg);
 err_out:
 	mutex_lock(&mdsc->mutex);
 	mdsc->mdsmap_err = err;
@@ -5688,6 +5691,7 @@ void ceph_mdsc_handle_mdsmap(struct ceph_mds_client *mdsc, struct ceph_msg *msg)
 bad:
 	pr_err("error decoding mdsmap %d. Shutting down mount.\n", err);
 	ceph_umount_begin(mdsc->fsc->sb);
+	ceph_msg_dump(msg);
 	return;
 }
 
-- 
2.40.1

