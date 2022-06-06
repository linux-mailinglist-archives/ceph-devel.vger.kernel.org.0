Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C6EF053E6EA
	for <lists+ceph-devel@lfdr.de>; Mon,  6 Jun 2022 19:07:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236848AbiFFMYn (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 6 Jun 2022 08:24:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236829AbiFFMYf (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 6 Jun 2022 08:24:35 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 0267224AC9C
        for <ceph-devel@vger.kernel.org>; Mon,  6 Jun 2022 05:24:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1654518274;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=cQ5JMDcnJPi7L1orfn5mtONr1ovTguioAYIMzxFIXNw=;
        b=WAWcGaWQCL2dhdkahVQGFmMwmeS8lKpa+8W5HYSSkQxwELYlrkA8LBlop7qFvs9Thr5iOo
        tU6IuvzLl0Ol85gJbId1ORXtMkb8DhwrihTWxFZ5jkGJBxijPD/mOeJJc4MIWIEaVKXJvJ
        QGfnbi3PYPr75L/US/NimrZtC5Bf+jI=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-642-CJDsyWkHPkSC6IjX_DzzIA-1; Mon, 06 Jun 2022 08:24:30 -0400
X-MC-Unique: CJDsyWkHPkSC6IjX_DzzIA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8F503185A7BA;
        Mon,  6 Jun 2022 12:24:29 +0000 (UTC)
Received: from localhost (unknown [10.72.47.117])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E66A61121315;
        Mon,  6 Jun 2022 12:24:28 +0000 (UTC)
From:   Xiubo Li <xiubli@redhat.com>
To:     jlayton@kernel.org, idryomov@gmail.com
Cc:     lhenriques@suse.de, vshankar@redhat.com,
        ceph-devel@vger.kernel.org, Xiubo Li <xiubli@redhat.com>
Subject: [PATCH] ceph: fix the incorrect comment for the ceph_mds_caps struct
Date:   Mon,  6 Jun 2022 20:24:25 +0800
Message-Id: <20220606122425.316004-1-xiubli@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

The incorrect comment is misleading. Acutally the last members
in ceph_mds_caps strcut is a union for none export and export
bodies.

Signed-off-by: Xiubo Li <xiubli@redhat.com>
---
 include/linux/ceph/ceph_fs.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/ceph/ceph_fs.h b/include/linux/ceph/ceph_fs.h
index 86bf82dbd8b8..24622ecb9900 100644
--- a/include/linux/ceph/ceph_fs.h
+++ b/include/linux/ceph/ceph_fs.h
@@ -768,7 +768,7 @@ struct ceph_mds_caps {
 	__le32 xattr_len;
 	__le64 xattr_version;
 
-	/* filelock */
+	/* a union of none export and export bodies. */
 	__le64 size, max_size, truncate_size;
 	__le32 truncate_seq;
 	struct ceph_timespec mtime, atime, ctime;
-- 
2.36.0.rc1

