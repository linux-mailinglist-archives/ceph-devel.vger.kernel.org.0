Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DCFFE4EA6B
	for <lists+ceph-devel@lfdr.de>; Fri, 21 Jun 2019 16:18:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726287AbfFUOSj (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 21 Jun 2019 10:18:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:48338 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726032AbfFUOSi (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Fri, 21 Jun 2019 10:18:38 -0400
Received: from tleilax.poochiereds.net (cpe-71-70-156-158.nc.res.rr.com [71.70.156.158])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 523262089E;
        Fri, 21 Jun 2019 14:18:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561126718;
        bh=O+JyAbE7gzuZFVR1B/RarBWiVxRT8VXQTKJYS6wMfCw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UjxiQvSWZhLqAuGD0i+m4OlOiB+HVbzoEeVWsoUgMilW9vrX3l+LpeldEYj8s0AtF
         528kIHJ/cLIrtr7MqTHYYVTsLxudCFmRDmUGrlI8cTEE5DJWXgb69GC9zry7b7+Jea
         yHcOY+vcUd8innAsaPnCo4S5qy3RB3bvbnYFnM68=
From:   Jeff Layton <jlayton@kernel.org>
To:     linux-kernel@vger.kernel.org, ceph-devel@vger.kernel.org
Cc:     idryomov@gmail.com, zyan@redhat.com, sage@redhat.com,
        agruenba@redhat.com, joe@perches.com, geert+renesas@glider.be,
        andriy.shevchenko@linux.intel.com
Subject: [PATCH v3 2/2] ceph: fix return of ceph_vxattrcb_layout
Date:   Fri, 21 Jun 2019 10:18:33 -0400
Message-Id: <20190621141833.17551-3-jlayton@kernel.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190621141833.17551-1-jlayton@kernel.org>
References: <20190621141833.17551-1-jlayton@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Currently it returns -ERANGE if it thinks that the buffer won't fit, but
the function returns size_t which is unsigned. Fix it to just return the
length in this case like the other xattrs do, and rely on the caller to
handle the case where it won't fit in the destination buffer.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/ceph/xattr.c | 10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

diff --git a/fs/ceph/xattr.c b/fs/ceph/xattr.c
index 359d3cbbb37b..23687e3819f5 100644
--- a/fs/ceph/xattr.c
+++ b/fs/ceph/xattr.c
@@ -62,8 +62,7 @@ static size_t ceph_vxattrcb_layout(struct ceph_inode_info *ci, char *val,
 	const char *pool_name;
 	const char *ns_field = " pool_namespace=";
 	char buf[128];
-	size_t len, total_len = 0;
-	int ret;
+	size_t ret, len, total_len = 0;
 
 	pool_ns = ceph_try_get_string(ci->i_layout.pool_ns);
 
@@ -87,11 +86,8 @@ static size_t ceph_vxattrcb_layout(struct ceph_inode_info *ci, char *val,
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
-- 
2.21.0

