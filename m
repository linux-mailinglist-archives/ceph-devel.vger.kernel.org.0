Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 567DD4ED433
	for <lists+ceph-devel@lfdr.de>; Thu, 31 Mar 2022 08:53:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231470AbiCaGyp (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 31 Mar 2022 02:54:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231465AbiCaGyo (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 31 Mar 2022 02:54:44 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 3B58E1753B7
        for <ceph-devel@vger.kernel.org>; Wed, 30 Mar 2022 23:52:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1648709577;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=PdMRW5jJuzbSrJJdoPtxOeEryd6q0veXZXJ8FBCpSSE=;
        b=GRHCXckxgAuPdoINlAZrnOcuHr8RFM8hvhUgOhSUuSP4yJYANny3WCAWLOyVnr0JxWLR3B
        JVCIMoWXVRwQyc03jWZbk2Zuobjro2LorMbbPFFrktcL5uQ2n7I/JwtMSsNQ85mUbsMOy0
        vl4mLPBFS2BSdDNujlYC33FT9ULsfZ0=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-610-l6cKkASROD6AglWkvJKZsA-1; Thu, 31 Mar 2022 02:52:54 -0400
X-MC-Unique: l6cKkASROD6AglWkvJKZsA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A04671C0690B;
        Thu, 31 Mar 2022 06:52:53 +0000 (UTC)
Received: from lxbceph1.gsslab.pek2.redhat.com (unknown [10.72.47.117])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5E4767AC3;
        Thu, 31 Mar 2022 06:52:51 +0000 (UTC)
From:   xiubli@redhat.com
To:     jlayton@kernel.org
Cc:     idryomov@gmail.com, vshankar@redhat.com,
        ceph-devel@vger.kernel.org, Xiubo Li <xiubli@redhat.com>
Subject: [PATCH 1/3] ceph: add the Octopus,Pacific,Quency feature bits
Date:   Thu, 31 Mar 2022 14:52:39 +0800
Message-Id: <20220331065241.27370-2-xiubli@redhat.com>
In-Reply-To: <20220331065241.27370-1-xiubli@redhat.com>
References: <20220331065241.27370-1-xiubli@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,UPPERCASE_50_75 autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: Xiubo Li <xiubli@redhat.com>

URL: https://tracker.ceph.com/issues/54411
Signed-off-by: Xiubo Li <xiubli@redhat.com>
---
 fs/ceph/mds_client.h | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/fs/ceph/mds_client.h b/fs/ceph/mds_client.h
index 33497846e47e..32107c26f50d 100644
--- a/fs/ceph/mds_client.h
+++ b/fs/ceph/mds_client.h
@@ -27,10 +27,13 @@ enum ceph_feature_type {
 	CEPHFS_FEATURE_RECLAIM_CLIENT,
 	CEPHFS_FEATURE_LAZY_CAP_WANTED,
 	CEPHFS_FEATURE_MULTI_RECONNECT,
-	CEPHFS_FEATURE_DELEG_INO,
-	CEPHFS_FEATURE_METRIC_COLLECT,
+	CEPHFS_FEATURE_OCTOPUS,
+	CEPHFS_FEATURE_DELEG_INO = CEPHFS_FEATURE_OCTOPUS,
+	CEPHFS_FEATURE_PACIFIC,
+	CEPHFS_FEATURE_METRIC_COLLECT = CEPHFS_FEATURE_PACIFIC,
+	CEPHFS_FEATURE_QUINCY,
 
-	CEPHFS_FEATURE_MAX = CEPHFS_FEATURE_METRIC_COLLECT,
+	CEPHFS_FEATURE_MAX = CEPHFS_FEATURE_QUINCY,
 };
 
 /*
-- 
2.27.0

