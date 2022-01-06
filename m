Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A7B0A485E2A
	for <lists+ceph-devel@lfdr.de>; Thu,  6 Jan 2022 02:36:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344410AbiAFBgE (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 5 Jan 2022 20:36:04 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:51373 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1344399AbiAFBgD (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 5 Jan 2022 20:36:03 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1641432962;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=hlSNBPSc3Aj9WFsIZj5OycGyZx+Qf3Kz/iGxM3CsfIs=;
        b=ZBs3SyS6iy2Ukm4745Rs5eVNd6Jp8UoFrPqpRL72esVc1uCOfYKU+FB0Zv1jQlWxc+ii/f
        wbNA5LGnHHPYx7I+DAbhefVE1BjvtsQbApM2HWj1WjgfBIctyf3prIHD2JDEgRXy93fPaZ
        LYZq4BYj1Xj1aiAByQkaftYCpXuvEco=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-435-4J_yKTD-MAePVNExG8ZnQQ-1; Wed, 05 Jan 2022 20:35:59 -0500
X-MC-Unique: 4J_yKTD-MAePVNExG8ZnQQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 30102100CCC0;
        Thu,  6 Jan 2022 01:35:58 +0000 (UTC)
Received: from lxbceph1.gsslab.pek2.redhat.com (unknown [10.72.47.117])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3DAAC5BE08;
        Thu,  6 Jan 2022 01:35:55 +0000 (UTC)
From:   xiubli@redhat.com
To:     jlayton@kernel.org
Cc:     idryomov@gmail.com, vshankar@redhat.com,
        ceph-devel@vger.kernel.org, Xiubo Li <xiubli@redhat.com>
Subject: [PATCH] ceph: remove redundant Lsx caps check
Date:   Thu,  6 Jan 2022 09:35:52 +0800
Message-Id: <20220106013552.1141633-1-xiubli@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: Xiubo Li <xiubli@redhat.com>

The newcaps has already included the Ls, no need to check it again.

Signed-off-by: Xiubo Li <xiubli@redhat.com>
---
 fs/ceph/caps.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
index 1f1a1c6987ce..d68f04ec147d 100644
--- a/fs/ceph/caps.c
+++ b/fs/ceph/caps.c
@@ -3451,8 +3451,7 @@ static void handle_cap_grant(struct inode *inode,
 	if ((newcaps & CEPH_CAP_LINK_SHARED) &&
 	    (extra_info->issued & CEPH_CAP_LINK_EXCL) == 0) {
 		set_nlink(inode, le32_to_cpu(grant->nlink));
-		if (inode->i_nlink == 0 &&
-		    (newcaps & (CEPH_CAP_LINK_SHARED | CEPH_CAP_LINK_EXCL)))
+		if (inode->i_nlink == 0)
 			deleted_inode = true;
 	}
 
-- 
2.27.0

