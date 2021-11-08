Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 52E95448096
	for <lists+ceph-devel@lfdr.de>; Mon,  8 Nov 2021 14:51:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237438AbhKHNxo (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 8 Nov 2021 08:53:44 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:20044 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240119AbhKHNxh (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 8 Nov 2021 08:53:37 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1636379453;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=SkPNVG3Eg+tX4YBhDy3zVIyyWAOTg6mLj2iMt5oNomk=;
        b=bBJAgjOLdLkZn+p/wFJ4/uDGhic/rNFyHXAr87KqugBDTw994/S+usoqxVRBjd/h613Amm
        uX7o2xmoy0JE+Jx00iODxg4Hupf5nugcgxhWCCzaNGe1PyUvEzsefk5hu3cJZPU/WJU/q0
        wEPnkH1ge7r3Ni94tH8gW61I6pDlbio=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-370-QwX2d9vmPsaQCQqlKuMxRQ-1; Mon, 08 Nov 2021 08:50:49 -0500
X-MC-Unique: QwX2d9vmPsaQCQqlKuMxRQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 558FD875118;
        Mon,  8 Nov 2021 13:50:48 +0000 (UTC)
Received: from lxbceph1.gsslab.pek2.redhat.com (unknown [10.72.47.117])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 389A179458;
        Mon,  8 Nov 2021 13:50:45 +0000 (UTC)
From:   xiubli@redhat.com
To:     jlayton@kernel.org
Cc:     idryomov@gmail.com, vshankar@redhat.com, khiremat@redhat.com,
        ceph-devel@vger.kernel.org, Xiubo Li <xiubli@redhat.com>
Subject: [PATCH 2/2] ceph: there is no need to round up the sizes when new size is 0
Date:   Mon,  8 Nov 2021 21:50:12 +0800
Message-Id: <20211108135012.79941-3-xiubli@redhat.com>
In-Reply-To: <20211108135012.79941-1-xiubli@redhat.com>
References: <20211108135012.79941-1-xiubli@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: Xiubo Li <xiubli@redhat.com>

Signed-off-by: Xiubo Li <xiubli@redhat.com>
---
 fs/ceph/inode.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
index b371f596b97d..1b4ce453d397 100644
--- a/fs/ceph/inode.c
+++ b/fs/ceph/inode.c
@@ -2560,7 +2560,7 @@ int __ceph_setattr(struct inode *inode, struct iattr *attr, struct ceph_iattr *c
 			mask |= CEPH_SETATTR_SIZE;
 			release |= CEPH_CAP_FILE_SHARED | CEPH_CAP_FILE_EXCL |
 				   CEPH_CAP_FILE_RD | CEPH_CAP_FILE_WR;
-			if (IS_ENCRYPTED(inode)) {
+			if (IS_ENCRYPTED(inode) && attr->ia_size) {
 				set_bit(CEPH_MDS_R_FSCRYPT_FILE, &req->r_req_flags);
 				mask |= CEPH_SETATTR_FSCRYPT_FILE;
 				req->r_args.setattr.size =
-- 
2.27.0

