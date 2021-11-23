Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2FA8345A000
	for <lists+ceph-devel@lfdr.de>; Tue, 23 Nov 2021 11:20:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235134AbhKWKX3 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 23 Nov 2021 05:23:29 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:54520 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231221AbhKWKX2 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Tue, 23 Nov 2021 05:23:28 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1637662820;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=+/ajp+78DKNzF4w+MssKWcU4vZcPICLEnBhn5xFzKrQ=;
        b=OhGdhDbFStLt67wPRW90qQYhgSt7HW/RqNBgihFbRCz9GMnP3laE+r7U8JFjYhL5z9LNxm
        vSVDnkfMLwnvll5+aALL9Kc2tmh1skk/vs57PUKqaYYbRXnQVBOfIN93jnTQoogo0GBsHg
        dcpkCVIbGl5bsHPUez4QEO7y1l3yuVg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-269-7NF0jxmDPBW7_ZFfZZ8GGg-1; Tue, 23 Nov 2021 05:20:16 -0500
X-MC-Unique: 7NF0jxmDPBW7_ZFfZZ8GGg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A690481CBDB;
        Tue, 23 Nov 2021 10:20:15 +0000 (UTC)
Received: from lxbceph1.gsslab.pek2.redhat.com (unknown [10.72.47.117])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 89DF579448;
        Tue, 23 Nov 2021 10:20:13 +0000 (UTC)
From:   xiubli@redhat.com
To:     jlayton@kernel.org
Cc:     idryomov@gmail.com, vshankar@redhat.com, khiremat@redhat.com,
        ceph-devel@vger.kernel.org, Xiubo Li <xiubli@redhat.com>
Subject: [PATCH] ceph: fscrypt always set the header.block_size to CEPH_FSCRYPT_BLOCK_SIZE
Date:   Tue, 23 Nov 2021 18:20:04 +0800
Message-Id: <20211123102004.40149-1-xiubli@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: Xiubo Li <xiubli@redhat.com>

When hit a file hole, will keep the header.assert_ver as 0, and
in MDS side it will check it to decide whether should it do a
RMW.

And always set the header.block_size to CEPH_FSCRYPT_BLOCK_SIZE,
because even in the hole case, the MDS will need to use this to
do the filer.truncate().

Signed-off-by: Xiubo Li <xiubli@redhat.com>
---


Hi Jeff, 

Please squash this patch to the previous "ceph: add truncate size handling support for fscrypt" commit in ceph-client/wip-fscrypt-size branch.

And also please sync the ceph PR, I have updated it too.





 fs/ceph/inode.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
index 53b8e2ff3678..b4f7a4b4f15c 100644
--- a/fs/ceph/inode.c
+++ b/fs/ceph/inode.c
@@ -2312,6 +2312,12 @@ static int fill_fscrypt_truncate(struct inode *inode,
 	header.ver = 1;
 	header.compat = 1;
 
+	/*
+	 * Always set the block_size to CEPH_FSCRYPT_BLOCK_SIZE,
+	 * because in MDS it may need this to do the truncate.
+	 */
+	header.block_size = cpu_to_le32(CEPH_FSCRYPT_BLOCK_SIZE);
+
 	/*
 	 * If we hit a hole here, we should just skip filling
 	 * the fscrypt for the request, because once the fscrypt
@@ -2327,15 +2333,19 @@ static int fill_fscrypt_truncate(struct inode *inode,
 		     pos, i_size);
 
 		header.data_len = cpu_to_le32(8 + 8 + 4);
+
+		/*
+		 * If the "assert_ver" is 0 means hitting a hole, and
+		 * the MDS will use the it to check whether hitting a
+		 * hole or not.
+		 */
 		header.assert_ver = 0;
 		header.file_offset = 0;
-		header.block_size = 0;
 		ret = 0;
 	} else {
 		header.data_len = cpu_to_le32(8 + 8 + 4 + CEPH_FSCRYPT_BLOCK_SIZE);
 		header.assert_ver = cpu_to_le64(objvers.objvers[0].objver);
 		header.file_offset = cpu_to_le64(orig_pos);
-		header.block_size = cpu_to_le32(CEPH_FSCRYPT_BLOCK_SIZE);
 
 		/* truncate and zero out the extra contents for the last block */
 		memset(iov.iov_base + boff, 0, PAGE_SIZE - boff);
-- 
2.27.0

