Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 32ECC6206D4
	for <lists+ceph-devel@lfdr.de>; Tue,  8 Nov 2022 03:33:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232495AbiKHCdd (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 7 Nov 2022 21:33:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232588AbiKHCdI (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 7 Nov 2022 21:33:08 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BBE3275D6
        for <ceph-devel@vger.kernel.org>; Mon,  7 Nov 2022 18:32:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1667874726;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=q4FyHvXGvjlDBDM7EMjKZyMA0RCajf8DZMa0Uy8qGX8=;
        b=V7xveBv+jbmlIol0+Ajaa99sYPv23kzqfIcYPdRGKR4T6zlis50aBSBjs2kH4lNueK/NXe
        nMQXc13a2wOWDTQ+nHh4mzXl0KU92M0VUiXuqxBK9uUKkZw1y999IrEeL60TM/e6ddALwy
        yyFg7+tnS5N5p3y5HvSinfSuuK1GPkQ=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-324-jypIA28zOSmwtPTS34TnDA-1; Mon, 07 Nov 2022 21:32:03 -0500
X-MC-Unique: jypIA28zOSmwtPTS34TnDA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9CAD2185A794;
        Tue,  8 Nov 2022 02:32:02 +0000 (UTC)
Received: from lxbceph1.gsslab.pek2.redhat.com (unknown [10.72.47.117])
        by smtp.corp.redhat.com (Postfix) with ESMTP id BC639C15BB5;
        Tue,  8 Nov 2022 02:31:59 +0000 (UTC)
From:   xiubli@redhat.com
To:     ceph-devel@vger.kernel.org, idryomov@gmail.com
Cc:     lhenriques@suse.de, jlayton@kernel.org, mchangir@redhat.com,
        Xiubo Li <xiubli@redhat.com>, stable@vger.kernel.org
Subject: [PATCH v2] ceph: avoid putting the realm twice when decoding snaps fails
Date:   Tue,  8 Nov 2022 10:31:41 +0800
Message-Id: <20221108023141.64972-1-xiubli@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: Xiubo Li <xiubli@redhat.com>

When decoding the snaps fails it maybe leaving the 'first_realm'
and 'realm' pointing to the same snaprealm memory. And then it'll
put it twice and could cause random use-after-free, BUG_ON, etc
issues.

Cc: stable@vger.kernel.org
URL: https://tracker.ceph.com/issues/57686
Reviewed-by: Luís Henriques <lhenriques@suse.de>
Signed-off-by: Xiubo Li <xiubli@redhat.com>
---
 fs/ceph/snap.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/ceph/snap.c b/fs/ceph/snap.c
index 9bceed2ebda3..77b948846d4d 100644
--- a/fs/ceph/snap.c
+++ b/fs/ceph/snap.c
@@ -854,6 +854,8 @@ int ceph_update_snap_trace(struct ceph_mds_client *mdsc,
 	else
 		ceph_put_snap_realm(mdsc, realm);
 
+	realm = NULL;
+
 	if (p < e)
 		goto more;
 
-- 
2.31.1

