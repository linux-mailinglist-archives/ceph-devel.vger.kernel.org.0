Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 48AC5444E88
	for <lists+ceph-devel@lfdr.de>; Thu,  4 Nov 2021 06:53:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230388AbhKDF40 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 4 Nov 2021 01:56:26 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:40209 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230361AbhKDF4T (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 4 Nov 2021 01:56:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1636005222;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=v4jJffICIfc1bGy7Z+qcfwnI6LK4INeb9JCPIBUsaJU=;
        b=VJxZtT2BYKgpd3Mzt/OQxuWicLaK7GL3GuXzaUeei7pL3PoR1j9X7BIqwWM2YS0j3AG/gn
        6NFjP23hJ6NGoc2qtF1bPVX5OfATS8e/eSfjeIxRkjRRk2DEfseyZkRaFk2eG0VD5HIMCs
        zw7aNhzEB70QdHLmGBHrlQFswUWOzyU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-565-aPr36QiyNrycRhi02LQkPA-1; Thu, 04 Nov 2021 01:53:38 -0400
X-MC-Unique: aPr36QiyNrycRhi02LQkPA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9760C19200C0;
        Thu,  4 Nov 2021 05:53:37 +0000 (UTC)
Received: from lxbceph1.gsslab.pek2.redhat.com (unknown [10.72.47.117])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3F8A45BAF0;
        Thu,  4 Nov 2021 05:53:34 +0000 (UTC)
From:   xiubli@redhat.com
To:     jlayton@kernel.org
Cc:     idryomov@gmail.com, vshankar@redhat.com, pdonnell@redhat.com,
        khiremat@redhat.com, ceph-devel@vger.kernel.org,
        Xiubo Li <xiubli@redhat.com>
Subject: [PATCH v6 6/9] ceph: add __ceph_get_caps helper support
Date:   Thu,  4 Nov 2021 13:52:45 +0800
Message-Id: <20211104055248.190987-7-xiubli@redhat.com>
In-Reply-To: <20211104055248.190987-1-xiubli@redhat.com>
References: <20211104055248.190987-1-xiubli@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: Xiubo Li <xiubli@redhat.com>

Signed-off-by: Xiubo Li <xiubli@redhat.com>
---
 fs/ceph/caps.c  | 19 +++++++++++++------
 fs/ceph/super.h |  2 ++
 2 files changed, 15 insertions(+), 6 deletions(-)

diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
index c9f1ac3ad2f3..c15c5dd36747 100644
--- a/fs/ceph/caps.c
+++ b/fs/ceph/caps.c
@@ -2911,10 +2911,9 @@ int ceph_try_get_caps(struct inode *inode, int need, int want,
  * due to a small max_size, make sure we check_max_size (and possibly
  * ask the mds) so we don't get hung up indefinitely.
  */
-int ceph_get_caps(struct file *filp, int need, int want, loff_t endoff, int *got)
+int __ceph_get_caps(struct inode *inode, struct ceph_file_info *fi, int need,
+		    int want, loff_t endoff, int *got)
 {
-	struct ceph_file_info *fi = filp->private_data;
-	struct inode *inode = file_inode(filp);
 	struct ceph_inode_info *ci = ceph_inode(inode);
 	struct ceph_fs_client *fsc = ceph_inode_to_client(inode);
 	int ret, _got, flags;
@@ -2923,7 +2922,7 @@ int ceph_get_caps(struct file *filp, int need, int want, loff_t endoff, int *got
 	if (ret < 0)
 		return ret;
 
-	if ((fi->fmode & CEPH_FILE_MODE_WR) &&
+	if (fi && (fi->fmode & CEPH_FILE_MODE_WR) &&
 	    fi->filp_gen != READ_ONCE(fsc->filp_gen))
 		return -EBADF;
 
@@ -2931,7 +2930,7 @@ int ceph_get_caps(struct file *filp, int need, int want, loff_t endoff, int *got
 
 	while (true) {
 		flags &= CEPH_FILE_MODE_MASK;
-		if (atomic_read(&fi->num_locks))
+		if (fi && atomic_read(&fi->num_locks))
 			flags |= CHECK_FILELOCK;
 		_got = 0;
 		ret = try_get_cap_refs(inode, need, want, endoff,
@@ -2976,7 +2975,7 @@ int ceph_get_caps(struct file *filp, int need, int want, loff_t endoff, int *got
 				continue;
 		}
 
-		if ((fi->fmode & CEPH_FILE_MODE_WR) &&
+		if (fi && (fi->fmode & CEPH_FILE_MODE_WR) &&
 		    fi->filp_gen != READ_ONCE(fsc->filp_gen)) {
 			if (ret >= 0 && _got)
 				ceph_put_cap_refs(ci, _got);
@@ -3039,6 +3038,14 @@ int ceph_get_caps(struct file *filp, int need, int want, loff_t endoff, int *got
 	return 0;
 }
 
+int ceph_get_caps(struct file *filp, int need, int want, loff_t endoff, int *got)
+{
+	struct ceph_file_info *fi = filp->private_data;
+	struct inode *inode = file_inode(filp);
+
+	return __ceph_get_caps(inode, fi, need, want, endoff, got);
+}
+
 /*
  * Take cap refs.  Caller must already know we hold at least one ref
  * on the caps in question or we don't know this is safe.
diff --git a/fs/ceph/super.h b/fs/ceph/super.h
index ea95c958202f..403918a4cdb3 100644
--- a/fs/ceph/super.h
+++ b/fs/ceph/super.h
@@ -1225,6 +1225,8 @@ extern int ceph_encode_dentry_release(void **p, struct dentry *dn,
 				      struct inode *dir,
 				      int mds, int drop, int unless);
 
+extern int __ceph_get_caps(struct inode *inode, struct ceph_file_info *fi,
+			   int need, int want, loff_t endoff, int *got);
 extern int ceph_get_caps(struct file *filp, int need, int want,
 			 loff_t endoff, int *got);
 extern int ceph_try_get_caps(struct inode *inode,
-- 
2.27.0

