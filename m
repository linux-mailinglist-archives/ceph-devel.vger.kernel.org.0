Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED12F7102FE
	for <lists+ceph-devel@lfdr.de>; Thu, 25 May 2023 04:45:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230250AbjEYCps (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 24 May 2023 22:45:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229454AbjEYCps (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 24 May 2023 22:45:48 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0DDEE6
        for <ceph-devel@vger.kernel.org>; Wed, 24 May 2023 19:45:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1684982701;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=HejaJ7XGexe5hNJN45V/67gezKvAKJV7ZsiS0kLH/Ew=;
        b=LdyxNaGQb78Oa+JAXJUuYhDvUOP+Yg3v1Sga+Kt4n2vzFMAUetw8X/axklfrcR4Wis6ci5
        E2bZHau8CqDcKcoyJ2cpxiKbdqqKOBNq5PwuR26aj8W4X8jPPTouoUhebxrHHY6WSSrpYf
        iFrezkWzbXxbn9yBSuHRYRL5t0tm2ZY=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-554-amC1qGN5NKOr_K1WwZ2xhw-1; Wed, 24 May 2023 22:44:58 -0400
X-MC-Unique: amC1qGN5NKOr_K1WwZ2xhw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id CBD0F3C0ED40;
        Thu, 25 May 2023 02:44:57 +0000 (UTC)
Received: from li-a71a4dcc-35d1-11b2-a85c-951838863c8d.ibm.com.com (ovpn-12-133.pek2.redhat.com [10.72.12.133])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B86A840CFD00;
        Thu, 25 May 2023 02:44:54 +0000 (UTC)
From:   xiubli@redhat.com
To:     idryomov@gmail.com, ceph-devel@vger.kernel.org
Cc:     jlayton@kernel.org, vshankar@redhat.com,
        Xiubo Li <xiubli@redhat.com>, stable@vger.kernel.org
Subject: [PATCH] ceph: fix use-after-free bug for inodes when flushing capsnaps
Date:   Thu, 25 May 2023 10:44:38 +0800
Message-Id: <20230525024438.507082-1-xiubli@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: Xiubo Li <xiubli@redhat.com>

There is racy between capsnaps flush and removing the inode from
'mdsc->snap_flush_list' list:

   Thread A                            Thread B
ceph_queue_cap_snap()
 -> allocate 'capsnapA'
 ->ihold('&ci->vfs_inode')
 ->add 'capsnapA' to 'ci->i_cap_snaps'
 ->add 'ci' to 'mdsc->snap_flush_list'
    ...
ceph_flush_snaps()
 ->__ceph_flush_snaps()
  ->__send_flush_snap()
                                handle_cap_flushsnap_ack()
	                         ->iput('&ci->vfs_inode')
	                           this also will release 'ci'
                                    ...
                                ceph_handle_snap()
                                 ->flush_snaps()
                                  ->iterate 'mdsc->snap_flush_list'
                                   ->get the stale 'ci'
 ->remove 'ci' from                ->ihold(&ci->vfs_inode) this
   'mdsc->snap_flush_list'           will WARNING

To fix this we will remove the 'ci' from 'mdsc->snap_flush_list'
list just before '__send_flush_snaps()' to make sure the flushsnap
'ack' will always after removing the 'ci' from 'snap_flush_list'.

Cc: stable@vger.kernel.org
URL: https://bugzilla.redhat.com/show_bug.cgi?id=2209299
Signed-off-by: Xiubo Li <xiubli@redhat.com>
---
 fs/ceph/caps.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
index feabf4cc0c4f..a8f890b3bb9a 100644
--- a/fs/ceph/caps.c
+++ b/fs/ceph/caps.c
@@ -1595,6 +1595,11 @@ static void __ceph_flush_snaps(struct ceph_inode_info *ci,
 
 	dout("__flush_snaps %p session %p\n", inode, session);
 
+	/* we will flush them all; remove this inode from the queue */
+	spin_lock(&mdsc->snap_flush_lock);
+	list_del_init(&ci->i_snap_flush_item);
+	spin_unlock(&mdsc->snap_flush_lock);
+
 	list_for_each_entry(capsnap, &ci->i_cap_snaps, ci_item) {
 		/*
 		 * we need to wait for sync writes to complete and for dirty
@@ -1726,10 +1731,6 @@ void ceph_flush_snaps(struct ceph_inode_info *ci,
 		*psession = session;
 	else
 		ceph_put_mds_session(session);
-	/* we flushed them all; remove this inode from the queue */
-	spin_lock(&mdsc->snap_flush_lock);
-	list_del_init(&ci->i_snap_flush_item);
-	spin_unlock(&mdsc->snap_flush_lock);
 }
 
 /*
-- 
2.40.1

