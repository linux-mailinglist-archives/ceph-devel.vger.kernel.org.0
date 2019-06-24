Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 75991518A6
	for <lists+ceph-devel@lfdr.de>; Mon, 24 Jun 2019 18:27:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732145AbfFXQ1j (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 24 Jun 2019 12:27:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:35874 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732112AbfFXQ1b (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Mon, 24 Jun 2019 12:27:31 -0400
Received: from tleilax.poochiereds.net (cpe-71-70-156-158.nc.res.rr.com [71.70.156.158])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B4F3020674;
        Mon, 24 Jun 2019 16:27:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561393650;
        bh=PC1Tg5AS0+Xg6rrqM9JqWZimf5Eqphufa1WUi9rPCUM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=s8mZpzy7YYP1pdQDFYOl+beEyYCgieVcLHsMDvq2bMLmCYyumWP6JZM0ixIcYgDMq
         Yn2V0fCoF0MeERVLgMu20whvNaW16tgo9QavOrkV6hMKTFPS2MLPRgJWFwBb/lip5b
         NrA5WbspOjwbtB8R/jT5xyTt3TcnTD0jtN2ouDik=
From:   Jeff Layton <jlayton@kernel.org>
To:     linux-kernel@vger.kernel.org, ceph-devel@vger.kernel.org
Cc:     idryomov@gmail.com, zyan@redhat.com, sage@redhat.com,
        agruenba@redhat.com
Subject: [PATCH v4 2/3] ceph: return -ERANGE if virtual xattr value didn't fit in buffer
Date:   Mon, 24 Jun 2019 12:27:25 -0400
Message-Id: <20190624162726.17413-3-jlayton@kernel.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190624162726.17413-1-jlayton@kernel.org>
References: <20190624162726.17413-1-jlayton@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

The getxattr manpage states that we should return ERANGE if the
destination buffer size is too small to hold the value.
ceph_vxattrcb_layout does this internally, but we should be doing
this for all vxattrs.

Fix the only caller of getxattr_cb to check the returned size
against the buffer length and return -ERANGE if it doesn't fit.
Drop the same check in ceph_vxattrcb_layout and just rely on the
caller to handle it.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/ceph/xattr.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/fs/ceph/xattr.c b/fs/ceph/xattr.c
index e90e19e9660b..9b77dca0b786 100644
--- a/fs/ceph/xattr.c
+++ b/fs/ceph/xattr.c
@@ -63,7 +63,7 @@ static ssize_t ceph_vxattrcb_layout(struct ceph_inode_info *ci, char *val,
 	const char *ns_field = " pool_namespace=";
 	char buf[128];
 	size_t len, total_len = 0;
-	int ret;
+	ssize_t ret;
 
 	pool_ns = ceph_try_get_string(ci->i_layout.pool_ns);
 
@@ -87,11 +87,8 @@ static ssize_t ceph_vxattrcb_layout(struct ceph_inode_info *ci, char *val,
 	if (pool_ns)
 		total_len += strlen(ns_field) + pool_ns->len;
 
-	if (!size) {
-		ret = total_len;
-	} else if (total_len > size) {
-		ret = -ERANGE;
-	} else {
+	ret = total_len;
+	if (size >= total_len) {
 		memcpy(val, buf, len);
 		ret = len;
 		if (pool_name) {
@@ -803,8 +800,11 @@ ssize_t __ceph_getxattr(struct inode *inode, const char *name, void *value,
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

