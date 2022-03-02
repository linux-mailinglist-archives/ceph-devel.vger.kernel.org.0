Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C93E4C9FF2
	for <lists+ceph-devel@lfdr.de>; Wed,  2 Mar 2022 09:54:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235752AbiCBIzG (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 2 Mar 2022 03:55:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231660AbiCBIzF (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 2 Mar 2022 03:55:05 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id F2FC35FF12
        for <ceph-devel@vger.kernel.org>; Wed,  2 Mar 2022 00:54:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646211261;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=J/5yevSOCXz94WPZ10ux99lzPrDEpIwpkCvyTJd4pLs=;
        b=IBNmF25Zye9lW+ysWPtXxsIrofOuxhiqGpbiNhhnxuntez97B/IVuk+TJ206A/e2fVXBRG
        efsk4LzOtt4ISX1k6bCAWbv9ukob1hbsdYdUvSggrz0pZb6CZJqE4hOh8l5Zn4H65/PM35
        m72zjX4CwjE08m6WmnTZssbV7W3GfXc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-416-IYUtJD6vOQ2M3yjxHiSz7A-1; Wed, 02 Mar 2022 03:54:20 -0500
X-MC-Unique: IYUtJD6vOQ2M3yjxHiSz7A-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E9A0A1854E21;
        Wed,  2 Mar 2022 08:54:19 +0000 (UTC)
Received: from lxbceph1.gsslab.pek2.redhat.com (unknown [10.72.47.117])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2F3704D727;
        Wed,  2 Mar 2022 08:54:17 +0000 (UTC)
From:   xiubli@redhat.com
To:     jlayton@kernel.org
Cc:     idryomov@gmail.com, vshankar@redhat.com,
        ceph-devel@vger.kernel.org, Xiubo Li <xiubli@redhat.com>
Subject: [PATCH 1/2] ceph: fix inode reference leakage in ceph_get_snapdir()
Date:   Wed,  2 Mar 2022 16:54:01 +0800
Message-Id: <20220302085402.64740-2-xiubli@redhat.com>
In-Reply-To: <20220302085402.64740-1-xiubli@redhat.com>
References: <20220302085402.64740-1-xiubli@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: Xiubo Li <xiubli@redhat.com>

The ceph_get_inode() will search for or insert a new inode into the
hash for the given vino, and return a reference to it. If new is
non-NULL, its reference is consumed.

We should release the reference when in error handing cases.

Signed-off-by: Xiubo Li <xiubli@redhat.com>
---
 fs/ceph/inode.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
index 8b0832271fdf..cbeba8a93a07 100644
--- a/fs/ceph/inode.c
+++ b/fs/ceph/inode.c
@@ -164,13 +164,13 @@ struct inode *ceph_get_snapdir(struct inode *parent)
 	if (!S_ISDIR(parent->i_mode)) {
 		pr_warn_once("bad snapdir parent type (mode=0%o)\n",
 			     parent->i_mode);
-		return ERR_PTR(-ENOTDIR);
+		goto err;
 	}
 
 	if (!(inode->i_state & I_NEW) && !S_ISDIR(inode->i_mode)) {
 		pr_warn_once("bad snapdir inode type (mode=0%o)\n",
 			     inode->i_mode);
-		return ERR_PTR(-ENOTDIR);
+		goto err;
 	}
 
 	inode->i_mode = parent->i_mode;
@@ -190,6 +190,12 @@ struct inode *ceph_get_snapdir(struct inode *parent)
 	}
 
 	return inode;
+err:
+	if ((inode->i_state & I_NEW))
+		discard_new_inode(inode);
+	else
+		iput(inode);
+	return ERR_PTR(-ENOTDIR);
 }
 
 const struct inode_operations ceph_file_iops = {
-- 
2.27.0

