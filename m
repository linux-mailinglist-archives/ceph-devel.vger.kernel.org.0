Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 57A79448095
	for <lists+ceph-devel@lfdr.de>; Mon,  8 Nov 2021 14:50:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238814AbhKHNxd (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 8 Nov 2021 08:53:33 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:29385 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237427AbhKHNxd (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 8 Nov 2021 08:53:33 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1636379448;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=eFYo0RG28cXYzxhHaOlkbQQtkP65DbmE44xGtW5rJvc=;
        b=iVNjtPZA6StfTVukUoac5MvmPgqHO9acfdyPz2ewYaoTcpJnziuZwZh+xJ6W0XNtKNz7nt
        3xdEJQewE201/SqlsesSypTScxqC/4xQ8bCZRhM5JTzsr8abfNv5hWaJU+SIMUsO70i9w+
        3e5r6TcghQtc80qMgNjQQsEppgHZjM8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-220-_o2iKtHpN4CjFgf_8XaYQQ-1; Mon, 08 Nov 2021 08:50:47 -0500
X-MC-Unique: _o2iKtHpN4CjFgf_8XaYQQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B1AD010247DB;
        Mon,  8 Nov 2021 13:50:45 +0000 (UTC)
Received: from lxbceph1.gsslab.pek2.redhat.com (unknown [10.72.47.117])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 96BD677E26;
        Mon,  8 Nov 2021 13:50:43 +0000 (UTC)
From:   xiubli@redhat.com
To:     jlayton@kernel.org
Cc:     idryomov@gmail.com, vshankar@redhat.com, khiremat@redhat.com,
        ceph-devel@vger.kernel.org, Xiubo Li <xiubli@redhat.com>
Subject: [PATCH 1/2] ceph: fix possible crash and data corrupt bugs
Date:   Mon,  8 Nov 2021 21:50:11 +0800
Message-Id: <20211108135012.79941-2-xiubli@redhat.com>
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
 fs/ceph/inode.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
index cb0ad0faee45..b371f596b97d 100644
--- a/fs/ceph/inode.c
+++ b/fs/ceph/inode.c
@@ -2281,7 +2281,7 @@ static int fill_fscrypt_truncate(struct inode *inode,
 
 	/* Try to writeback the dirty pagecaches */
 	if (issued & (CEPH_CAP_FILE_BUFFER))
-		filemap_fdatawrite(&inode->i_data);
+		filemap_write_and_wait(inode->i_mapping);
 
 	page = __page_cache_alloc(GFP_KERNEL);
 	if (page == NULL) {
@@ -2393,6 +2393,7 @@ int __ceph_setattr(struct inode *inode, struct iattr *attr, struct ceph_iattr *c
 	bool fill_fscrypt;
 	int truncate_retry = 20; /* The RMW will take around 50ms */
 
+retry:
 	prealloc_cf = ceph_alloc_cap_flush();
 	if (!prealloc_cf)
 		return -ENOMEM;
@@ -2404,7 +2405,6 @@ int __ceph_setattr(struct inode *inode, struct iattr *attr, struct ceph_iattr *c
 		return PTR_ERR(req);
 	}
 
-retry:
 	fill_fscrypt = false;
 	spin_lock(&ci->i_ceph_lock);
 	issued = __ceph_caps_issued(ci, NULL);
@@ -2667,6 +2667,8 @@ int __ceph_setattr(struct inode *inode, struct iattr *attr, struct ceph_iattr *c
 		if (err == -EAGAIN && truncate_retry--) {
 			dout("setattr %p result=%d (%s locally, %d remote), retry it!\n",
 			     inode, err, ceph_cap_string(dirtied), mask);
+			ceph_mdsc_put_request(req);
+			ceph_free_cap_flush(prealloc_cf);
 			goto retry;
 		}
 	}
-- 
2.27.0

