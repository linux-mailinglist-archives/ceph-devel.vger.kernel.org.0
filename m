Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 82B6039499
	for <lists+ceph-devel@lfdr.de>; Fri,  7 Jun 2019 20:47:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730457AbfFGSrx (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 7 Jun 2019 14:47:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:52620 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730281AbfFGSrw (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Fri, 7 Jun 2019 14:47:52 -0400
Received: from tleilax.poochiereds.net (cpe-71-70-156-158.nc.res.rr.com [71.70.156.158])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8791C208C0;
        Fri,  7 Jun 2019 18:47:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559933272;
        bh=7oH9S0TbTnZbDK147LzR9lgGhAqSaFHZu2VLepccM04=;
        h=From:To:Cc:Subject:Date:From;
        b=Ehgpg7pseOudf7jfTvPACTwH7MC4LLThMpxDoB5zIwMhTSX6v/chwld6RsLj3JLQ4
         LAn8xFqLC4tI6nCPz125xtWUAeMkkC3dldQ42SFaK6+nQKIoctbYC9zxwKiYd6prxb
         dWrnYVtQPNwpBPbcwaXDK0uSUDLW2mQ4h7aNbPpI=
From:   Jeff Layton <jlayton@kernel.org>
To:     idryomov@redhat.com, zyan@redhat.com, sage@redhat.com
Cc:     ceph-devel@vger.kernel.org, dev@ceph.io, tpetr@redhat.com,
        pdonnell@redhat.com
Subject: [PATCH v2] ceph: fix getxattr return values for vxattrs
Date:   Fri,  7 Jun 2019 14:47:49 -0400
Message-Id: <20190607184749.8333-1-jlayton@kernel.org>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

We have several virtual xattrs in cephfs which return various values as
strings. xattrs don't necessarily return strings however, so we need to
include the terminating NULL byte when we return the length.

Furthermore, the getxattr manpage says that we should return -ERANGE if
the buffer is too small to hold the resulting value. Let's start doing
that here as well.

URL: https://bugzilla.redhat.com/show_bug.cgi?id=1717454
Reported-by: Tomas Petr <tpetr@redhat.com>
Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/ceph/xattr.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/fs/ceph/xattr.c b/fs/ceph/xattr.c
index 6621d27e64f5..2a61e02e7166 100644
--- a/fs/ceph/xattr.c
+++ b/fs/ceph/xattr.c
@@ -803,8 +803,15 @@ ssize_t __ceph_getxattr(struct inode *inode, const char *name, void *value,
 		if (err)
 			return err;
 		err = -ENODATA;
-		if (!(vxattr->exists_cb && !vxattr->exists_cb(ci)))
-			err = vxattr->getxattr_cb(ci, value, size);
+		if (!(vxattr->exists_cb && !vxattr->exists_cb(ci))) {
+			/*
+			 * getxattr_cb returns strlen(value), xattr length must
+			 * include the NULL.
+			 */
+			err = vxattr->getxattr_cb(ci, value, size) + 1;
+			if (size && size < err)
+				err = -ERANGE;
+		}
 		return err;
 	}
 
-- 
2.21.0

