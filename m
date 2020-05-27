Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8BF951E3699
	for <lists+ceph-devel@lfdr.de>; Wed, 27 May 2020 05:34:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728511AbgE0Dek (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 26 May 2020 23:34:40 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:48773 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725893AbgE0Dek (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 26 May 2020 23:34:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1590550478;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc; bh=IVJzaSAzUNFLxzvj19gZAPDjU52HlXrgbnAplzbP9t4=;
        b=D6QaIR6roWmTEHjWlJ1/uaTv8i+f7jB+IKypMXrIfKltMyZBEqDBWmm3i004NDv7AlD8Td
        a8qmJ1yaBE9nAlE7yL52jEVKBROmfANoNqowkkwSLmPfZ6zyLIEO+olWlr9di7o2pDBv5m
        5qfs4z62R5HP7wIHblXRjzFQ5yE9Tgo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-186-1sCc3HsyPXSYlJYaPZTpRA-1; Tue, 26 May 2020 23:34:36 -0400
X-MC-Unique: 1sCc3HsyPXSYlJYaPZTpRA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9253C872FE1;
        Wed, 27 May 2020 03:34:35 +0000 (UTC)
Received: from lxbceph0.gsslab.pek2.redhat.com (vm36-245.gsslab.pek2.redhat.com [10.72.36.245])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B29FA12A4D;
        Wed, 27 May 2020 03:34:33 +0000 (UTC)
From:   xiubli@redhat.com
To:     jlayton@kernel.org, idryomov@gmail.com, zyan@redhat.com
Cc:     pdonnell@redhat.com, ceph-devel@vger.kernel.org,
        Xiubo Li <xiubli@redhat.com>
Subject: [PATCH] ceph: always try to flush the snaps in ceph_check_caps
Date:   Tue, 26 May 2020 23:34:30 -0400
Message-Id: <1590550470-31278-1-git-send-email-xiubli@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: Xiubo Li <xiubli@redhat.com>

The ceph_flush_snaps() will never have a change to be called and
we can do it in the ceph_check_caps().

Signed-off-by: Xiubo Li <xiubli@redhat.com>
---
 fs/ceph/caps.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
index 27c2e60..62a066e 100644
--- a/fs/ceph/caps.c
+++ b/fs/ceph/caps.c
@@ -3019,7 +3019,7 @@ static int ceph_try_drop_cap_snap(struct ceph_inode_info *ci,
 void ceph_put_cap_refs(struct ceph_inode_info *ci, int had)
 {
 	struct inode *inode = &ci->vfs_inode;
-	int last = 0, put = 0, flushsnaps = 0, wake = 0;
+	int last = 0, put = 0, wake = 0;
 
 	spin_lock(&ci->i_ceph_lock);
 	if (had & CEPH_CAP_PIN)
@@ -3052,8 +3052,8 @@ void ceph_put_cap_refs(struct ceph_inode_info *ci, int had)
 				capsnap->writing = 0;
 				if (ceph_try_drop_cap_snap(ci, capsnap))
 					put++;
-				else if (__ceph_finish_cap_snap(ci, capsnap))
-					flushsnaps = 1;
+				else
+				       __ceph_finish_cap_snap(ci, capsnap);
 				wake = 1;
 			}
 			if (ci->i_wrbuffer_ref_head == 0 &&
@@ -3074,8 +3074,6 @@ void ceph_put_cap_refs(struct ceph_inode_info *ci, int had)
 
 	if (last)
 		ceph_check_caps(ci, 0, NULL);
-	else if (flushsnaps)
-		ceph_flush_snaps(ci, NULL);
 	if (wake)
 		wake_up_all(&ci->i_cap_wq);
 	while (put-- > 0)
-- 
1.8.3.1

