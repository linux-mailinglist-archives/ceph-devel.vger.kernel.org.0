Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 26C08725243
	for <lists+ceph-devel@lfdr.de>; Wed,  7 Jun 2023 04:57:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240826AbjFGC5v (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 6 Jun 2023 22:57:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240816AbjFGC5t (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 6 Jun 2023 22:57:49 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86C1D1990
        for <ceph-devel@vger.kernel.org>; Tue,  6 Jun 2023 19:57:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1686106623;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=W6ifqNbzhiVB+sXugcXPHJCtGlHwF8tB9EcH3C1JuZg=;
        b=iJlY2u2D9cb/BDQ30coAxG7ulVdthmGiWDOfu4QWxxxdsIKdBYup++WflcTTZGGN27xbJn
        q5xeO0PrsGVHmxprnjfhEpk9as4WSU64kar+PFZ5bvzR30rRh1auKmMxzpVnBodvq70Q+Q
        3ZVYlySJC2jUzcQlNmJ3zOubQuDzERg=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-646-SlQ0TdLaPmGRKIE9Zpj5Ng-1; Tue, 06 Jun 2023 22:57:00 -0400
X-MC-Unique: SlQ0TdLaPmGRKIE9Zpj5Ng-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B5BF2101A53A;
        Wed,  7 Jun 2023 02:56:59 +0000 (UTC)
Received: from li-a71a4dcc-35d1-11b2-a85c-951838863c8d.ibm.com.com (ovpn-12-128.pek2.redhat.com [10.72.12.128])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5709340D1B68;
        Wed,  7 Jun 2023 02:56:55 +0000 (UTC)
From:   xiubli@redhat.com
To:     idryomov@gmail.com, ceph-devel@vger.kernel.org
Cc:     jlayton@kernel.org, vshankar@redhat.com, mchangir@redhat.com,
        Xiubo Li <xiubli@redhat.com>, stable@vger.kernel.org
Subject: [PATCH v4] ceph: fix use-after-free bug for inodes when flushing capsnaps
Date:   Wed,  7 Jun 2023 10:54:34 +0800
Message-Id: <20230607025434.1119867-1-xiubli@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: Xiubo Li <xiubli@redhat.com>

There is a race between capsnaps flush and removing the inode from
'mdsc->snap_flush_list' list:

   == Thread A ==                     == Thread B ==
ceph_queue_cap_snap()
 -> allocate 'capsnapA'
 ->ihold('&ci->vfs_inode')
 ->add 'capsnapA' to 'ci->i_cap_snaps'
 ->add 'ci' to 'mdsc->snap_flush_list'
    ...
   == Thread C ==
ceph_flush_snaps()
 ->__ceph_flush_snaps()
  ->__send_flush_snap()
                                handle_cap_flushsnap_ack()
                                 ->iput('&ci->vfs_inode')
                                   this also will release 'ci'
                                    ...
				      == Thread D ==
                                ceph_handle_snap()
                                 ->flush_snaps()
                                  ->iterate 'mdsc->snap_flush_list'
                                   ->get the stale 'ci'
 ->remove 'ci' from                ->ihold(&ci->vfs_inode) this
   'mdsc->snap_flush_list'           will WARNING

To fix this we will increase the inode's i_count ref when adding 'ci'
to the 'mdsc->snap_flush_list' list.

Cc: stable@vger.kernel.org
URL: https://bugzilla.redhat.com/show_bug.cgi?id=2209299
Reviewed-by: Milind Changire <mchangir@redhat.com>
Signed-off-by: Xiubo Li <xiubli@redhat.com>
---

V4:
- s/put/need_put/


 fs/ceph/caps.c | 6 ++++++
 fs/ceph/snap.c | 4 +++-
 2 files changed, 9 insertions(+), 1 deletion(-)

diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
index 8c1fc64b290c..bb78d0fbfa62 100644
--- a/fs/ceph/caps.c
+++ b/fs/ceph/caps.c
@@ -1684,6 +1684,7 @@ void ceph_flush_snaps(struct ceph_inode_info *ci,
 	struct inode *inode = &ci->netfs.inode;
 	struct ceph_mds_client *mdsc = ceph_inode_to_client(inode)->mdsc;
 	struct ceph_mds_session *session = NULL;
+	int need_put = 0;
 	int mds;
 
 	dout("ceph_flush_snaps %p\n", inode);
@@ -1728,8 +1729,13 @@ void ceph_flush_snaps(struct ceph_inode_info *ci,
 		ceph_put_mds_session(session);
 	/* we flushed them all; remove this inode from the queue */
 	spin_lock(&mdsc->snap_flush_lock);
+	if (!list_empty(&ci->i_snap_flush_item))
+		need_put++;
 	list_del_init(&ci->i_snap_flush_item);
 	spin_unlock(&mdsc->snap_flush_lock);
+
+	if (need_put)
+		iput(inode);
 }
 
 /*
diff --git a/fs/ceph/snap.c b/fs/ceph/snap.c
index 7943981914cf..e03b020d87d7 100644
--- a/fs/ceph/snap.c
+++ b/fs/ceph/snap.c
@@ -697,8 +697,10 @@ int __ceph_finish_cap_snap(struct ceph_inode_info *ci,
 	     capsnap->size);
 
 	spin_lock(&mdsc->snap_flush_lock);
-	if (list_empty(&ci->i_snap_flush_item))
+	if (list_empty(&ci->i_snap_flush_item)) {
+		ihold(inode);
 		list_add_tail(&ci->i_snap_flush_item, &mdsc->snap_flush_list);
+	}
 	spin_unlock(&mdsc->snap_flush_lock);
 	return 1;  /* caller may want to ceph_flush_snaps */
 }
-- 
2.40.1

