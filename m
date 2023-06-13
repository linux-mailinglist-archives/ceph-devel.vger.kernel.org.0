Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 780C572D956
	for <lists+ceph-devel@lfdr.de>; Tue, 13 Jun 2023 07:36:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240212AbjFMFgF (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 13 Jun 2023 01:36:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240220AbjFMFfa (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 13 Jun 2023 01:35:30 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 646BC2942
        for <ceph-devel@vger.kernel.org>; Mon, 12 Jun 2023 22:32:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1686634294;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=m9uvyr60tHJXqNG2wRmLNZtpcEp45k0noIwguO30UdQ=;
        b=PSxOHrB0ULx+EmH2f5o52x4H1QPgaT3T2cl+dP4zyNKSJiCHaQj58fHq1dpFUNM0UALxv2
        ccubxiUvEbLjkpfJUF4zrzKA6ofO6y7BBobV+zWs6j3WsL5+rYDfuduAOvJkIUWvO/ImiZ
        Fbl4uqHBL7uuANDwFUDaIWIUOoyh9cg=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-538-h4mvsuLpO4-ZzayLApwFGg-1; Tue, 13 Jun 2023 01:31:28 -0400
X-MC-Unique: h4mvsuLpO4-ZzayLApwFGg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id EE7A180120A;
        Tue, 13 Jun 2023 05:31:27 +0000 (UTC)
Received: from li-a71a4dcc-35d1-11b2-a85c-951838863c8d.ibm.com.com (ovpn-12-155.pek2.redhat.com [10.72.12.155])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 35ECD1121314;
        Tue, 13 Jun 2023 05:31:22 +0000 (UTC)
From:   xiubli@redhat.com
To:     idryomov@gmail.com, ceph-devel@vger.kernel.org
Cc:     jlayton@kernel.org, vshankar@redhat.com, mchangir@redhat.com,
        lhenriques@suse.de, Xiubo Li <xiubli@redhat.com>
Subject: [PATCH v20 65/71] ceph: prevent snapshots to be created in encrypted locked directories
Date:   Tue, 13 Jun 2023 13:24:18 +0800
Message-Id: <20230613052424.254540-66-xiubli@redhat.com>
In-Reply-To: <20230613052424.254540-1-xiubli@redhat.com>
References: <20230613052424.254540-1-xiubli@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: Luís Henriques <lhenriques@suse.de>

With snapshot names encryption we can not allow snapshots to be created in
locked directories because the names wouldn't be encrypted.  This patch
forces the directory to be unlocked to allow a snapshot to be created.

Tested-by: Luís Henriques <lhenriques@suse.de>
Tested-by: Venky Shankar <vshankar@redhat.com>
Reviewed-by: Xiubo Li <xiubli@redhat.com>
Signed-off-by: Luís Henriques <lhenriques@suse.de>
Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/ceph/dir.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/fs/ceph/dir.c b/fs/ceph/dir.c
index 0ca5dd36e414..bac2397e0fc9 100644
--- a/fs/ceph/dir.c
+++ b/fs/ceph/dir.c
@@ -1084,6 +1084,11 @@ static int ceph_mkdir(struct mnt_idmap *idmap, struct inode *dir,
 		err = -EDQUOT;
 		goto out;
 	}
+	if ((op == CEPH_MDS_OP_MKSNAP) && IS_ENCRYPTED(dir) &&
+	    !fscrypt_has_encryption_key(dir)) {
+		err = -ENOKEY;
+		goto out;
+	}
 
 
 	req = ceph_mdsc_create_request(mdsc, op, USE_AUTH_MDS);
-- 
2.40.1

