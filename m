Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 18B7572D947
	for <lists+ceph-devel@lfdr.de>; Tue, 13 Jun 2023 07:33:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240243AbjFMFdo (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 13 Jun 2023 01:33:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240239AbjFMFc5 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 13 Jun 2023 01:32:57 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E12EA30D6
        for <ceph-devel@vger.kernel.org>; Mon, 12 Jun 2023 22:30:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1686634231;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=851fdttRuJmk1R1CrphAfuxJeKM7NicsvmRFozTthtk=;
        b=B/tJHfQ0ETtI6OLedrrOkUkyejmiMpC4U+aqZevbnvc9YK5lpIFh7f3J/060jKX+fW6C+X
        VtCYvOBKdh6CSO6owYYt+rPcnlGTQfdkvho21+MvB1hC4mUSkx8M86Qe421zggo61KlAE7
        ovlIiGovDEK4pAuATNpA/NgsMtHh3Do=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-401-t3Q0iwZcOtGMlmRO9lMM4A-1; Tue, 13 Jun 2023 01:30:29 -0400
X-MC-Unique: t3Q0iwZcOtGMlmRO9lMM4A-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id F21A8858EEB;
        Tue, 13 Jun 2023 05:30:28 +0000 (UTC)
Received: from li-a71a4dcc-35d1-11b2-a85c-951838863c8d.ibm.com.com (ovpn-12-155.pek2.redhat.com [10.72.12.155])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7383B1121314;
        Tue, 13 Jun 2023 05:30:25 +0000 (UTC)
From:   xiubli@redhat.com
To:     idryomov@gmail.com, ceph-devel@vger.kernel.org
Cc:     jlayton@kernel.org, vshankar@redhat.com, mchangir@redhat.com,
        lhenriques@suse.de, Xiubo Li <xiubli@redhat.com>
Subject: [PATCH v20 52/71] ceph: disable copy offload on encrypted inodes
Date:   Tue, 13 Jun 2023 13:24:05 +0800
Message-Id: <20230613052424.254540-53-xiubli@redhat.com>
In-Reply-To: <20230613052424.254540-1-xiubli@redhat.com>
References: <20230613052424.254540-1-xiubli@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: Jeff Layton <jlayton@kernel.org>

If we have an encrypted inode, then the client will need to re-encrypt
the contents of the new object. Disable copy offload to or from
encrypted inodes.

Tested-by: Luís Henriques <lhenriques@suse.de>
Tested-by: Venky Shankar <vshankar@redhat.com>
Reviewed-by: Luís Henriques <lhenriques@suse.de>
Reviewed-by: Xiubo Li <xiubli@redhat.com>
Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/ceph/file.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/ceph/file.c b/fs/ceph/file.c
index e3d07f4049df..f621f733898e 100644
--- a/fs/ceph/file.c
+++ b/fs/ceph/file.c
@@ -2519,6 +2519,10 @@ static ssize_t __ceph_copy_file_range(struct file *src_file, loff_t src_off,
 		return -EOPNOTSUPP;
 	}
 
+	/* Every encrypted inode gets its own key, so we can't offload them */
+	if (IS_ENCRYPTED(src_inode) || IS_ENCRYPTED(dst_inode))
+		return -EOPNOTSUPP;
+
 	if (len < src_ci->i_layout.object_size)
 		return -EOPNOTSUPP; /* no remote copy will be done */
 
-- 
2.40.1

