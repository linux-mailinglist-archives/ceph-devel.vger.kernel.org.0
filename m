Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A949745EC4
	for <lists+ceph-devel@lfdr.de>; Fri, 14 Jun 2019 15:46:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728486AbfFNNqd (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 14 Jun 2019 09:46:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:41998 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728467AbfFNNqb (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Fri, 14 Jun 2019 09:46:31 -0400
Received: from tleilax.poochiereds.net (cpe-71-70-156-158.nc.res.rr.com [71.70.156.158])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 99FE821744;
        Fri, 14 Jun 2019 13:46:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560519990;
        bh=5B3ZAjA7gOsgPJfhSPrsXHeb6ZPgy7neIaABFDQJVWI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PEF60wV5RZE/wH/xodj6n79XiNZOV5arIxxiyGabEGOSpHi7CGGBaeIBKrnYVi9go
         ZUZe+lb3cDwJZm3yYaGbkRaY3TYbd1Mq28nFlZp7HXDYhB+ymmZtLtyd2zQaduN50p
         3vbdiTjDT+zB/lUtHyCI6t2XinzwhhvGPMXRcMko=
From:   Jeff Layton <jlayton@kernel.org>
To:     linux-kernel@vger.kernel.org, ceph-devel@vger.kernel.org
Cc:     akpm@linux-foundation.org, idryomov@gmail.com, zyan@redhat.com,
        sage@redhat.com, agruenba@redhat.com
Subject: [PATCH 3/3] ceph: return -ERANGE if virtual xattr value didn't fit in buffer
Date:   Fri, 14 Jun 2019 09:46:25 -0400
Message-Id: <20190614134625.6870-4-jlayton@kernel.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190614134625.6870-1-jlayton@kernel.org>
References: <20190614134625.6870-1-jlayton@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

The getxattr manpage states that we should return ERANGE if the
destination buffer size is too small to hold the value.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/ceph/xattr.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/fs/ceph/xattr.c b/fs/ceph/xattr.c
index a1cd9613be98..e3246c27f2da 100644
--- a/fs/ceph/xattr.c
+++ b/fs/ceph/xattr.c
@@ -805,8 +805,11 @@ ssize_t __ceph_getxattr(struct inode *inode, const char *name, void *value,
 		if (err)
 			return err;
 		err = -ENODATA;
-		if (!(vxattr->exists_cb && !vxattr->exists_cb(ci)))
+		if (!(vxattr->exists_cb && !vxattr->exists_cb(ci))) {
 			err = vxattr->getxattr_cb(ci, value, size);
+			if (size && size < err)
+				err = -ERANGE;
+		}
 		return err;
 	}
 
-- 
2.21.0

