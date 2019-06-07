Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EE22A39404
	for <lists+ceph-devel@lfdr.de>; Fri,  7 Jun 2019 20:10:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730743AbfFGSKy (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 7 Jun 2019 14:10:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:39932 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730336AbfFGSKx (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Fri, 7 Jun 2019 14:10:53 -0400
Received: from tleilax.poochiereds.net (cpe-71-70-156-158.nc.res.rr.com [71.70.156.158])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AA6E820868;
        Fri,  7 Jun 2019 18:10:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559931053;
        bh=pbc0DJmYoiuxKtIRyE6eCKgvTjuQVLrqsKXkcjxHKdQ=;
        h=From:To:Cc:Subject:Date:From;
        b=QbyQKYsCbVxJdyS5DFJ2S+PFoBgDxbpngQgrWHAkiM9Y7cbBuR4Il5RQIW91/BH5V
         xX9kXdMTNK1dmW+PUl9uVSYyHE46XJvRd26W1IzyXGoEQ4wZcegNPguSFwC+y/UORu
         Dx5O/i05OnU6SFL0w3qE7D/167t7XXOaorbnk10k=
From:   Jeff Layton <jlayton@kernel.org>
To:     idryomov@redhat.com, zyan@redhat.com, sage@redhat.com
Cc:     ceph-devel@vger.kernel.org, dev@ceph.io, tpetr@redhat.com
Subject: [PATCH] ceph: fix getxattr return values for vxattrs
Date:   Fri,  7 Jun 2019 14:10:50 -0400
Message-Id: <20190607181050.28085-1-jlayton@kernel.org>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

We have several virtual xattrs in cephfs which return various values as
strings. xattrs don't necessarily return strings however, so we need to
include the terminating NULL byte in the length when we return the
length.

Furthermore, the getxattr manpage says that we should return -ERANGE if
the buffer is too small to hold the resulting value. Let's start doing
that here as well.

URL: https://bugzilla.redhat.com/show_bug.cgi?id=1717454
Reported-by: Tomas Petr <tpetr@redhat.com>
Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/ceph/xattr.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/fs/ceph/xattr.c b/fs/ceph/xattr.c
index 6621d27e64f5..57f1bd83c21c 100644
--- a/fs/ceph/xattr.c
+++ b/fs/ceph/xattr.c
@@ -803,8 +803,14 @@ ssize_t __ceph_getxattr(struct inode *inode, const char *name, void *value,
 		if (err)
 			return err;
 		err = -ENODATA;
-		if (!(vxattr->exists_cb && !vxattr->exists_cb(ci)))
-			err = vxattr->getxattr_cb(ci, value, size);
+		if (!(vxattr->exists_cb && !vxattr->exists_cb(ci))) {
+			/* Make sure result will fit in buffer */
+			if (size > 0) {
+				if (size < vxattr->getxattr_cb(ci, NULL, 0) + 1)
+					return -ERANGE;
+			}
+			err = vxattr->getxattr_cb(ci, value, size) + 1;
+		}
 		return err;
 	}
 
-- 
2.21.0

