Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E741F13782E
	for <lists+ceph-devel@lfdr.de>; Fri, 10 Jan 2020 21:56:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727189AbgAJU4x (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 10 Jan 2020 15:56:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:48984 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726836AbgAJU4w (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Fri, 10 Jan 2020 15:56:52 -0500
Received: from tleilax.com (68-20-15-154.lightspeed.rlghnc.sbcglobal.net [68.20.15.154])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3FBF520882;
        Fri, 10 Jan 2020 20:56:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578689811;
        bh=shGHWJYrA+WffrdpwOREKmqXBZR4jT8CTbDAvidsUec=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sNxcTUPq7ceXKNPGJS1VcRMTRJesQdwsq89b6TK5xSBo49kaoPWqk9Tg13WJG9iZl
         rmKCi4nhsOIOD3WXU8M7ixE/ekIm6JrcQqpTy5cRsnG7EOsGK/y3zWG1bWJ/qRrNFP
         smqtg+76j+xp/ZwZu2vAZYLer/maU7BGEK6iSf/U=
From:   Jeff Layton <jlayton@kernel.org>
To:     ceph-devel@vger.kernel.org
Cc:     zyan@redhat.com, sage@redhat.com, idryomov@gmail.com,
        pdonnell@redhat.com
Subject: [RFC PATCH 2/9] ceph: print name of xattr being set in set/getxattr dout message
Date:   Fri, 10 Jan 2020 15:56:40 -0500
Message-Id: <20200110205647.311023-3-jlayton@kernel.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200110205647.311023-1-jlayton@kernel.org>
References: <20200110205647.311023-1-jlayton@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/ceph/xattr.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/ceph/xattr.c b/fs/ceph/xattr.c
index 98a9a3101cda..d58fa14c1f01 100644
--- a/fs/ceph/xattr.c
+++ b/fs/ceph/xattr.c
@@ -851,7 +851,7 @@ ssize_t __ceph_getxattr(struct inode *inode, const char *name, void *value,
 	req_mask = __get_request_mask(inode);
 
 	spin_lock(&ci->i_ceph_lock);
-	dout("getxattr %p ver=%lld index_ver=%lld\n", inode,
+	dout("getxattr %p name=%s ver=%lld index_ver=%lld\n", inode, name,
 	     ci->i_xattrs.version, ci->i_xattrs.index_version);
 
 	if (ci->i_xattrs.version == 0 ||
@@ -1078,7 +1078,8 @@ int __ceph_setxattr(struct inode *inode, const char *name,
 		}
 	}
 
-	dout("setxattr %p issued %s\n", inode, ceph_cap_string(issued));
+	dout("setxattr %p name %s issued %s\n", inode, name,
+			ceph_cap_string(issued));
 	__build_xattrs(inode);
 
 	required_blob_size = __get_required_blob_size(ci, name_len, val_len);
-- 
2.24.1

