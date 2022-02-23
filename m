Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5EA8D4C077E
	for <lists+ceph-devel@lfdr.de>; Wed, 23 Feb 2022 02:59:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235476AbiBWCAV (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 22 Feb 2022 21:00:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236581AbiBWCAT (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 22 Feb 2022 21:00:19 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 0F81F3BFBD
        for <ceph-devel@vger.kernel.org>; Tue, 22 Feb 2022 17:59:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1645581591;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=SbeUbeV98WNkgae45cSRVW1SvargcuBoUxZcP35p7F8=;
        b=AvNzFWfBge+3fVyINwDzcbuimuVjC41EaaKro9oqm6Dr1nHAjkxMjrxOPmkgNbVykl9tMZ
        tfBN0spmZpCUZcYayJTkKW1IMVmv+ER28BqeeQrFwnPoykVMsSAtdrmalkSdZwp/3C4dKG
        7C3HSgzcq9Lb1nCVZdJXoF1tUHgWZ9M=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-605-vblloLNIPFenmHzhL72_3g-1; Tue, 22 Feb 2022 20:59:49 -0500
X-MC-Unique: vblloLNIPFenmHzhL72_3g-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C0FE9801AAD;
        Wed, 23 Feb 2022 01:59:48 +0000 (UTC)
Received: from lxbceph1.gsslab.pek2.redhat.com (unknown [10.72.47.117])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C32635F51D;
        Wed, 23 Feb 2022 01:59:46 +0000 (UTC)
From:   xiubli@redhat.com
To:     jlayton@kernel.org
Cc:     idryomov@gmail.com, vshankar@redhat.com,
        ceph-devel@vger.kernel.org, Xiubo Li <xiubli@redhat.com>
Subject: [PATCH v3 2/2] ceph: misc fix for code style and logs
Date:   Wed, 23 Feb 2022 09:59:34 +0800
Message-Id: <20220223015934.37379-3-xiubli@redhat.com>
In-Reply-To: <20220223015934.37379-1-xiubli@redhat.com>
References: <20220223015934.37379-1-xiubli@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: Xiubo Li <xiubli@redhat.com>

To make the logs more readable such as for log likes:

ceph: will move 00000000a42b796b to split realm 100000003ed 000000007146df45

With this it will always show the inode numbers instead the inode
addresses.

Signed-off-by: Xiubo Li <xiubli@redhat.com>
---
 fs/ceph/snap.c | 122 +++++++++++++++++++++++++------------------------
 1 file changed, 62 insertions(+), 60 deletions(-)

diff --git a/fs/ceph/snap.c b/fs/ceph/snap.c
index b75dcc9a36b6..322ee5add942 100644
--- a/fs/ceph/snap.c
+++ b/fs/ceph/snap.c
@@ -137,7 +137,7 @@ static struct ceph_snap_realm *ceph_create_snap_realm(
 	__insert_snap_realm(&mdsc->snap_realms, realm);
 	mdsc->num_snap_realms++;
 
-	dout("create_snap_realm %llx %p\n", realm->ino, realm);
+	dout("%s %llx %p\n", __func__, realm->ino, realm);
 	return realm;
 }
 
@@ -161,7 +161,7 @@ static struct ceph_snap_realm *__lookup_snap_realm(struct ceph_mds_client *mdsc,
 		else if (ino > r->ino)
 			n = n->rb_right;
 		else {
-			dout("lookup_snap_realm %llx %p\n", r->ino, r);
+			dout("%s %llx %p\n", __func__, r->ino, r);
 			return r;
 		}
 	}
@@ -189,7 +189,7 @@ static void __destroy_snap_realm(struct ceph_mds_client *mdsc,
 {
 	lockdep_assert_held_write(&mdsc->snap_rwsem);
 
-	dout("__destroy_snap_realm %p %llx\n", realm, realm->ino);
+	dout("%s %p %llx\n", __func__, realm, realm->ino);
 
 	rb_erase(&realm->node, &mdsc->snap_realms);
 	mdsc->num_snap_realms--;
@@ -302,9 +302,8 @@ static int adjust_snap_realm_parent(struct ceph_mds_client *mdsc,
 		if (IS_ERR(parent))
 			return PTR_ERR(parent);
 	}
-	dout("adjust_snap_realm_parent %llx %p: %llx %p -> %llx %p\n",
-	     realm->ino, realm, realm->parent_ino, realm->parent,
-	     parentino, parent);
+	dout("%s %llx %p: %llx %p -> %llx %p\n", __func__, realm->ino,
+	     realm, realm->parent_ino, realm->parent, parentino, parent);
 	if (realm->parent) {
 		list_del_init(&realm->child_item);
 		ceph_put_snap_realm(mdsc, realm->parent);
@@ -360,9 +359,8 @@ static int build_snap_context(struct ceph_snap_realm *realm,
 	    realm->cached_context->seq == realm->seq &&
 	    (!parent ||
 	     realm->cached_context->seq >= parent->cached_context->seq)) {
-		dout("build_snap_context %llx %p: %p seq %lld (%u snaps)"
-		     " (unchanged)\n",
-		     realm->ino, realm, realm->cached_context,
+		dout("%s %llx %p: %p seq %lld (%u snaps) (unchanged)\n",
+		     __func__, realm->ino, realm, realm->cached_context,
 		     realm->cached_context->seq,
 		     (unsigned int)realm->cached_context->num_snaps);
 		return 0;
@@ -401,9 +399,8 @@ static int build_snap_context(struct ceph_snap_realm *realm,
 
 	sort(snapc->snaps, num, sizeof(u64), cmpu64_rev, NULL);
 	snapc->num_snaps = num;
-	dout("build_snap_context %llx %p: %p seq %lld (%u snaps)\n",
-	     realm->ino, realm, snapc, snapc->seq,
-	     (unsigned int) snapc->num_snaps);
+	dout("%s %llx %p: %p seq %lld (%u snaps)\n", __func__, realm->ino,
+	     realm, snapc, snapc->seq, (unsigned int) snapc->num_snaps);
 
 	ceph_put_snap_context(realm->cached_context);
 	realm->cached_context = snapc;
@@ -420,8 +417,7 @@ static int build_snap_context(struct ceph_snap_realm *realm,
 		ceph_put_snap_context(realm->cached_context);
 		realm->cached_context = NULL;
 	}
-	pr_err("build_snap_context %llx %p fail %d\n", realm->ino,
-	       realm, err);
+	pr_err("%s %llx %p fail %d\n", __func__, realm->ino, realm, err);
 	return err;
 }
 
@@ -455,7 +451,7 @@ static void rebuild_snap_realms(struct ceph_snap_realm *realm,
 		}
 
 		last = build_snap_context(_realm, &realm_queue, dirty_realms);
-		dout("rebuild_snap_realms %llx %p, %s\n", _realm->ino, _realm,
+		dout("%s %llx %p, %s\n", __func__, _realm->ino, _realm,
 		     last > 0 ? "is deferred" : !last ? "succeeded" : "failed");
 
 		/* is any child in the list ? */
@@ -551,12 +547,14 @@ static void ceph_queue_cap_snap(struct ceph_inode_info *ci,
 		   as no new writes are allowed to start when pending, so any
 		   writes in progress now were started before the previous
 		   cap_snap.  lucky us. */
-		dout("queue_cap_snap %p already pending\n", inode);
+		dout("%s %p %llx.%llx already pending\n",
+		     __func__, inode, ceph_vinop(inode));
 		goto update_snapc;
 	}
 	if (ci->i_wrbuffer_ref_head == 0 &&
 	    !(dirty & (CEPH_CAP_ANY_EXCL|CEPH_CAP_FILE_WR))) {
-		dout("queue_cap_snap %p nothing dirty|writing\n", inode);
+		dout("%s %p %llx.%llx nothing dirty|writing\n",
+		     __func__, inode, ceph_vinop(inode));
 		goto update_snapc;
 	}
 
@@ -576,15 +574,15 @@ static void ceph_queue_cap_snap(struct ceph_inode_info *ci,
 	} else {
 		if (!(used & CEPH_CAP_FILE_WR) &&
 		    ci->i_wrbuffer_ref_head == 0) {
-			dout("queue_cap_snap %p "
-			     "no new_snap|dirty_page|writing\n", inode);
+			dout("%s %p %llx.%llx no new_snap|dirty_page|writing\n",
+			     __func__, inode, ceph_vinop(inode));
 			goto update_snapc;
 		}
 	}
 
-	dout("queue_cap_snap %p cap_snap %p queuing under %p %s %s\n",
-	     inode, capsnap, old_snapc, ceph_cap_string(dirty),
-	     capsnap->need_flush ? "" : "no_flush");
+	dout("%s %p %llx.%llx cap_snap %p queuing under %p %s %s\n",
+	     __func__, inode, ceph_vinop(inode), capsnap, old_snapc,
+	     ceph_cap_string(dirty), capsnap->need_flush ? "" : "no_flush");
 	ihold(inode);
 
 	capsnap->follows = old_snapc->seq;
@@ -616,8 +614,8 @@ static void ceph_queue_cap_snap(struct ceph_inode_info *ci,
 	list_add_tail(&capsnap->ci_item, &ci->i_cap_snaps);
 
 	if (used & CEPH_CAP_FILE_WR) {
-		dout("queue_cap_snap %p cap_snap %p snapc %p"
-		     " seq %llu used WR, now pending\n", inode,
+		dout("%s %p %llx.%llx cap_snap %p snapc %p seq %llu used WR,"
+		     " now pending\n", __func__, inode, ceph_vinop(inode),
 		     capsnap, old_snapc, old_snapc->seq);
 		capsnap->writing = 1;
 	} else {
@@ -628,12 +626,12 @@ static void ceph_queue_cap_snap(struct ceph_inode_info *ci,
 	old_snapc = NULL;
 
 update_snapc:
-       if (ci->i_wrbuffer_ref_head == 0 &&
-           ci->i_wr_ref == 0 &&
-           ci->i_dirty_caps == 0 &&
-           ci->i_flushing_caps == 0) {
-               ci->i_head_snapc = NULL;
-       } else {
+	if (ci->i_wrbuffer_ref_head == 0 &&
+	    ci->i_wr_ref == 0 &&
+	    ci->i_dirty_caps == 0 &&
+	    ci->i_flushing_caps == 0) {
+		ci->i_head_snapc = NULL;
+	} else {
 		ci->i_head_snapc = ceph_get_snap_context(new_snapc);
 		dout(" new snapc is %p\n", new_snapc);
 	}
@@ -668,27 +666,28 @@ int __ceph_finish_cap_snap(struct ceph_inode_info *ci,
 	capsnap->truncate_size = ci->i_truncate_size;
 	capsnap->truncate_seq = ci->i_truncate_seq;
 	if (capsnap->dirty_pages) {
-		dout("finish_cap_snap %p cap_snap %p snapc %p %llu %s s=%llu "
-		     "still has %d dirty pages\n", inode, capsnap,
-		     capsnap->context, capsnap->context->seq,
-		     ceph_cap_string(capsnap->dirty), capsnap->size,
-		     capsnap->dirty_pages);
+		dout("%s %p %llx.%llx cap_snap %p snapc %p %llu %s s=%llu "
+		     "still has %d dirty pages\n", __func__, inode,
+		     ceph_vinop(inode), capsnap, capsnap->context,
+		     capsnap->context->seq, ceph_cap_string(capsnap->dirty),
+		     capsnap->size, capsnap->dirty_pages);
 		return 0;
 	}
 
 	/* Fb cap still in use, delay it */
 	if (ci->i_wb_ref) {
-		dout("finish_cap_snap %p cap_snap %p snapc %p %llu %s s=%llu "
-		     "used WRBUFFER, delaying\n", inode, capsnap,
-		     capsnap->context, capsnap->context->seq,
-		     ceph_cap_string(capsnap->dirty), capsnap->size);
+		dout("%s %p %llx.%llx cap_snap %p snapc %p %llu %s s=%llu "
+		     "used WRBUFFER, delaying\n", __func__, inode,
+		     ceph_vinop(inode), capsnap, capsnap->context,
+		     capsnap->context->seq, ceph_cap_string(capsnap->dirty),
+		     capsnap->size);
 		capsnap->writing = 1;
 		return 0;
 	}
 
 	ci->i_ceph_flags |= CEPH_I_FLUSH_SNAPS;
-	dout("finish_cap_snap %p cap_snap %p snapc %p %llu %s s=%llu\n",
-	     inode, capsnap, capsnap->context,
+	dout("%s %p %llx.%llx cap_snap %p snapc %p %llu %s s=%llu\n",
+	     __func__, inode, ceph_vinop(inode), capsnap, capsnap->context,
 	     capsnap->context->seq, ceph_cap_string(capsnap->dirty),
 	     capsnap->size);
 
@@ -709,7 +708,7 @@ static void queue_realm_cap_snaps(struct ceph_snap_realm *realm)
 	struct inode *lastinode = NULL;
 	struct ceph_cap_snap *capsnap = NULL;
 
-	dout("queue_realm_cap_snaps %p %llx inodes\n", realm, realm->ino);
+	dout("%s %p %llx inode\n", __func__, realm, realm->ino);
 
 	spin_lock(&realm->inodes_with_caps_lock);
 	list_for_each_entry(ci, &realm->inodes_with_caps, i_snap_realm_item) {
@@ -747,7 +746,7 @@ static void queue_realm_cap_snaps(struct ceph_snap_realm *realm)
 
 	if (capsnap)
 		kmem_cache_free(ceph_cap_snap_cachep, capsnap);
-	dout("queue_realm_cap_snaps %p %llx done\n", realm, realm->ino);
+	dout("%s %p %llx done\n", __func__, realm, realm->ino);
 }
 
 /*
@@ -773,7 +772,7 @@ int ceph_update_snap_trace(struct ceph_mds_client *mdsc,
 
 	lockdep_assert_held_write(&mdsc->snap_rwsem);
 
-	dout("update_snap_trace deletion=%d\n", deletion);
+	dout("%s deletion=%d\n", __func__, deletion);
 more:
 	rebuild_snapcs = 0;
 	ceph_decode_need(&p, e, sizeof(*ri), bad);
@@ -802,7 +801,7 @@ int ceph_update_snap_trace(struct ceph_mds_client *mdsc,
 	rebuild_snapcs += err;
 
 	if (le64_to_cpu(ri->seq) > realm->seq) {
-		dout("update_snap_trace updating %llx %p %lld -> %lld\n",
+		dout("%s updating %llx %p %lld -> %lld\n", __func__,
 		     realm->ino, realm, realm->seq, le64_to_cpu(ri->seq));
 		/* update realm parameters, snap lists */
 		realm->seq = le64_to_cpu(ri->seq);
@@ -826,11 +825,11 @@ int ceph_update_snap_trace(struct ceph_mds_client *mdsc,
 
 		rebuild_snapcs = 1;
 	} else if (!realm->cached_context) {
-		dout("update_snap_trace %llx %p seq %lld new\n",
+		dout("%s %llx %p seq %lld new\n", __func__,
 		     realm->ino, realm, realm->seq);
 		rebuild_snapcs = 1;
 	} else {
-		dout("update_snap_trace %llx %p seq %lld unchanged\n",
+		dout("%s %llx %p seq %lld unchanged\n", __func__,
 		     realm->ino, realm, realm->seq);
 	}
 
@@ -883,7 +882,7 @@ int ceph_update_snap_trace(struct ceph_mds_client *mdsc,
 		ceph_put_snap_realm(mdsc, realm);
 	if (first_realm)
 		ceph_put_snap_realm(mdsc, first_realm);
-	pr_err("update_snap_trace error %d\n", err);
+	pr_err("%s error %d\n", __func__, err);
 	return err;
 }
 
@@ -900,7 +899,7 @@ static void flush_snaps(struct ceph_mds_client *mdsc)
 	struct inode *inode;
 	struct ceph_mds_session *session = NULL;
 
-	dout("flush_snaps\n");
+	dout("%s\n", __func__);
 	spin_lock(&mdsc->snap_flush_lock);
 	while (!list_empty(&mdsc->snap_flush_list)) {
 		ci = list_first_entry(&mdsc->snap_flush_list,
@@ -915,7 +914,7 @@ static void flush_snaps(struct ceph_mds_client *mdsc)
 	spin_unlock(&mdsc->snap_flush_lock);
 
 	ceph_put_mds_session(session);
-	dout("flush_snaps done\n");
+	dout("%s done\n", __func__);
 }
 
 /**
@@ -997,8 +996,8 @@ void ceph_handle_snap(struct ceph_mds_client *mdsc,
 	trace_len = le32_to_cpu(h->trace_len);
 	p += sizeof(*h);
 
-	dout("handle_snap from mds%d op %s split %llx tracelen %d\n", mds,
-	     ceph_snap_op_name(op), split, trace_len);
+	dout("%s from mds%d op %s split %llx tracelen %d\n", __func__,
+	     mds, ceph_snap_op_name(op), split, trace_len);
 
 	mutex_lock(&session->s_mutex);
 	inc_session_sequence(session);
@@ -1058,13 +1057,13 @@ void ceph_handle_snap(struct ceph_mds_client *mdsc,
 			 */
 			if (ci->i_snap_realm->created >
 			    le64_to_cpu(ri->created)) {
-				dout(" leaving %p in newer realm %llx %p\n",
-				     inode, ci->i_snap_realm->ino,
+				dout(" leaving %p %llx.%llx in newer realm %llx %p\n",
+				     inode, ceph_vinop(inode), ci->i_snap_realm->ino,
 				     ci->i_snap_realm);
 				goto skip_inode;
 			}
-			dout(" will move %p to split realm %llx %p\n",
-			     inode, realm->ino, realm);
+			dout(" will move %p %llx.%llx to split realm %llx %p\n",
+			     inode, ceph_vinop(inode), realm->ino, realm);
 
 			ceph_get_snap_realm(mdsc, realm);
 			ceph_change_snap_realm(inode, realm);
@@ -1107,7 +1106,7 @@ void ceph_handle_snap(struct ceph_mds_client *mdsc,
 	return;
 
 bad:
-	pr_err("corrupt snap message from mds%d\n", mds);
+	pr_err("%s corrupt snap message from mds%d\n", __func__, mds);
 	ceph_msg_dump(msg);
 out:
 	if (locked_rwsem)
@@ -1140,7 +1139,8 @@ struct ceph_snapid_map* ceph_get_snapid_map(struct ceph_mds_client *mdsc,
 	}
 	spin_unlock(&mdsc->snapid_map_lock);
 	if (exist) {
-		dout("found snapid map %llx -> %x\n", exist->snap, exist->dev);
+		dout("%s found snapid map %llx -> %x\n", __func__,
+		     exist->snap, exist->dev);
 		return exist;
 	}
 
@@ -1184,11 +1184,13 @@ struct ceph_snapid_map* ceph_get_snapid_map(struct ceph_mds_client *mdsc,
 	if (exist) {
 		free_anon_bdev(sm->dev);
 		kfree(sm);
-		dout("found snapid map %llx -> %x\n", exist->snap, exist->dev);
+		dout("%s found snapid map %llx -> %x\n", __func__,
+		     exist->snap, exist->dev);
 		return exist;
 	}
 
-	dout("create snapid map %llx -> %x\n", sm->snap, sm->dev);
+	dout("%s create snapid map %llx -> %x\n", __func__,
+	     sm->snap, sm->dev);
 	return sm;
 }
 
-- 
2.27.0

