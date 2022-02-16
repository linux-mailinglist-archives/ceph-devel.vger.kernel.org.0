Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 399B24B7D47
	for <lists+ceph-devel@lfdr.de>; Wed, 16 Feb 2022 03:21:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343643AbiBPCTO (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 15 Feb 2022 21:19:14 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:52356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343641AbiBPCTN (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 15 Feb 2022 21:19:13 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id BC2E3C12FB
        for <ceph-devel@vger.kernel.org>; Tue, 15 Feb 2022 18:19:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1644977940;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=P6lk3qMjAMnpWBdD0058Be805lRtuttkgb51TvajY9I=;
        b=HEsij8MOwMV9lAPNbcRBp2TuaxcaumkEQZ+mMgvXk0TrqYKFgnNXYuMMxlLvhtK81HPui2
        tv3zySFUxqjbmlYG4CU41RGh7f7UFUeBCUvtE3qKvIvQNbrH/il0+Z69OZP2003+1elxi9
        DgxE0H36xErBl47TF2q90ABglq0wi1U=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-382-AOtXQZ9GNIm77q2IO-KWpg-1; Tue, 15 Feb 2022 21:18:59 -0500
X-MC-Unique: AOtXQZ9GNIm77q2IO-KWpg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7C2D12F45;
        Wed, 16 Feb 2022 02:18:58 +0000 (UTC)
Received: from lxbceph1.gsslab.pek2.redhat.com (unknown [10.72.47.117])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7800F1017CF1;
        Wed, 16 Feb 2022 02:18:53 +0000 (UTC)
From:   xiubli@redhat.com
To:     jlayton@kernel.org
Cc:     idryomov@gmail.com, vshankar@redhat.com,
        ceph-devel@vger.kernel.org, Xiubo Li <xiubli@redhat.com>
Subject: [PATCH v2 2/2] ceph: misc fix for code style and logs
Date:   Wed, 16 Feb 2022 10:18:45 +0800
Message-Id: <20220216021845.131852-3-xiubli@redhat.com>
In-Reply-To: <20220216021845.131852-1-xiubli@redhat.com>
References: <20220216021845.131852-1-xiubli@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
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
index ad992c50d7c4..6939307d41cb 100644
--- a/fs/ceph/snap.c
+++ b/fs/ceph/snap.c
@@ -132,7 +132,7 @@ static struct ceph_snap_realm *ceph_create_snap_realm(
 	__insert_snap_realm(&mdsc->snap_realms, realm);
 	mdsc->num_snap_realms++;
 
-	dout("create_snap_realm %llx %p\n", realm->ino, realm);
+	dout("%s %llx %p\n", __func__, realm->ino, realm);
 	return realm;
 }
 
@@ -156,7 +156,7 @@ static struct ceph_snap_realm *__lookup_snap_realm(struct ceph_mds_client *mdsc,
 		else if (ino > r->ino)
 			n = n->rb_right;
 		else {
-			dout("lookup_snap_realm %llx %p\n", r->ino, r);
+			dout("%s %llx %p\n", __func__, r->ino, r);
 			return r;
 		}
 	}
@@ -184,7 +184,7 @@ static void __destroy_snap_realm(struct ceph_mds_client *mdsc,
 {
 	lockdep_assert_held_write(&mdsc->snap_rwsem);
 
-	dout("__destroy_snap_realm %p %llx\n", realm, realm->ino);
+	dout("%s %p %llx\n", __func__, realm, realm->ino);
 
 	rb_erase(&realm->node, &mdsc->snap_realms);
 	mdsc->num_snap_realms--;
@@ -292,9 +292,8 @@ static int adjust_snap_realm_parent(struct ceph_mds_client *mdsc,
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
@@ -351,9 +350,8 @@ static int build_snap_context(struct ceph_snap_realm *realm,
 	if (realm->cached_context &&
 	    ((realm->cached_context->seq == realm->seq && !parent) ||
 	     (parent && realm->cached_context->seq >= parent->cached_context->seq))) {
-		dout("build_snap_context %llx %p: %p seq %lld (%u snaps)"
-		     " (unchanged)\n",
-		     realm->ino, realm, realm->cached_context,
+		dout("%s %llx %p: %p seq %lld (%u snaps) (unchanged)\n",
+		     __func__, realm->ino, realm, realm->cached_context,
 		     realm->cached_context->seq,
 		     (unsigned int)realm->cached_context->num_snaps);
 		return 0;
@@ -392,9 +390,8 @@ static int build_snap_context(struct ceph_snap_realm *realm,
 
 	sort(snapc->snaps, num, sizeof(u64), cmpu64_rev, NULL);
 	snapc->num_snaps = num;
-	dout("build_snap_context %llx %p: %p seq %lld (%u snaps)\n",
-	     realm->ino, realm, snapc, snapc->seq,
-	     (unsigned int) snapc->num_snaps);
+	dout("%s %llx %p: %p seq %lld (%u snaps)\n", __func__, realm->ino,
+	     realm, snapc, snapc->seq, (unsigned int) snapc->num_snaps);
 
 	ceph_put_snap_context(realm->cached_context);
 	realm->cached_context = snapc;
@@ -411,8 +408,7 @@ static int build_snap_context(struct ceph_snap_realm *realm,
 		ceph_put_snap_context(realm->cached_context);
 		realm->cached_context = NULL;
 	}
-	pr_err("build_snap_context %llx %p fail %d\n", realm->ino,
-	       realm, err);
+	pr_err("%s %llx %p fail %d\n", __func__, realm->ino, realm, err);
 	return err;
 }
 
@@ -424,7 +420,7 @@ static void rebuild_snap_realms(struct ceph_snap_realm *realm,
 {
 	struct ceph_snap_realm *child;
 
-	dout("rebuild_snap_realms %llx %p\n", realm->ino, realm);
+	dout("%s %llx %p\n", __func__, realm->ino, realm);
 	build_snap_context(realm, dirty_realms);
 
 	list_for_each_entry(child, &realm->children, child_item)
@@ -505,12 +501,14 @@ static void ceph_queue_cap_snap(struct ceph_inode_info *ci,
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
 
@@ -530,15 +528,15 @@ static void ceph_queue_cap_snap(struct ceph_inode_info *ci,
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
@@ -570,8 +568,8 @@ static void ceph_queue_cap_snap(struct ceph_inode_info *ci,
 	list_add_tail(&capsnap->ci_item, &ci->i_cap_snaps);
 
 	if (used & CEPH_CAP_FILE_WR) {
-		dout("queue_cap_snap %p cap_snap %p snapc %p"
-		     " seq %llu used WR, now pending\n", inode,
+		dout("%s %p %llx.%llx cap_snap %p snapc %p seq %llu used WR,"
+		     " now pending\n", __func__, inode, ceph_vinop(inode),
 		     capsnap, old_snapc, old_snapc->seq);
 		capsnap->writing = 1;
 	} else {
@@ -582,12 +580,12 @@ static void ceph_queue_cap_snap(struct ceph_inode_info *ci,
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
@@ -622,27 +620,28 @@ int __ceph_finish_cap_snap(struct ceph_inode_info *ci,
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
 
@@ -663,7 +662,7 @@ static void queue_realm_cap_snaps(struct ceph_snap_realm *realm)
 	struct inode *lastinode = NULL;
 	struct ceph_cap_snap *capsnap = NULL;
 
-	dout("queue_realm_cap_snaps %p %llx inodes\n", realm, realm->ino);
+	dout("%s %p %llx inode\n", __func__, realm, realm->ino);
 
 	spin_lock(&realm->inodes_with_caps_lock);
 	list_for_each_entry(ci, &realm->inodes_with_caps, i_snap_realm_item) {
@@ -701,7 +700,7 @@ static void queue_realm_cap_snaps(struct ceph_snap_realm *realm)
 
 	if (capsnap)
 		kmem_cache_free(ceph_cap_snap_cachep, capsnap);
-	dout("queue_realm_cap_snaps %p %llx done\n", realm, realm->ino);
+	dout("%s %p %llx done\n", __func__, realm, realm->ino);
 }
 
 /*
@@ -726,7 +725,7 @@ int ceph_update_snap_trace(struct ceph_mds_client *mdsc,
 
 	lockdep_assert_held_write(&mdsc->snap_rwsem);
 
-	dout("update_snap_trace deletion=%d\n", deletion);
+	dout("%s deletion=%d\n", __func__, deletion);
 more:
 	ceph_decode_need(&p, e, sizeof(*ri), bad);
 	ri = p;
@@ -754,7 +753,7 @@ int ceph_update_snap_trace(struct ceph_mds_client *mdsc,
 	invalidate += err;
 
 	if (le64_to_cpu(ri->seq) > realm->seq) {
-		dout("update_snap_trace updating %llx %p %lld -> %lld\n",
+		dout("%s updating %llx %p %lld -> %lld\n", __func__,
 		     realm->ino, realm, realm->seq, le64_to_cpu(ri->seq));
 		/* update realm parameters, snap lists */
 		realm->seq = le64_to_cpu(ri->seq);
@@ -778,11 +777,11 @@ int ceph_update_snap_trace(struct ceph_mds_client *mdsc,
 
 		invalidate = 1;
 	} else if (!realm->cached_context) {
-		dout("update_snap_trace %llx %p seq %lld new\n",
+		dout("%s %llx %p seq %lld new\n", __func__,
 		     realm->ino, realm, realm->seq);
 		invalidate = 1;
 	} else {
-		dout("update_snap_trace %llx %p seq %lld unchanged\n",
+		dout("%s %llx %p seq %lld unchanged\n", __func__,
 		     realm->ino, realm, realm->seq);
 	}
 
@@ -827,7 +826,7 @@ int ceph_update_snap_trace(struct ceph_mds_client *mdsc,
 		ceph_put_snap_realm(mdsc, realm);
 	if (first_realm)
 		ceph_put_snap_realm(mdsc, first_realm);
-	pr_err("update_snap_trace error %d\n", err);
+	pr_err("%s error %d\n", __func__, err);
 	return err;
 }
 
@@ -844,7 +843,7 @@ static void flush_snaps(struct ceph_mds_client *mdsc)
 	struct inode *inode;
 	struct ceph_mds_session *session = NULL;
 
-	dout("flush_snaps\n");
+	dout("%s\n", __func__);
 	spin_lock(&mdsc->snap_flush_lock);
 	while (!list_empty(&mdsc->snap_flush_list)) {
 		ci = list_first_entry(&mdsc->snap_flush_list,
@@ -859,7 +858,7 @@ static void flush_snaps(struct ceph_mds_client *mdsc)
 	spin_unlock(&mdsc->snap_flush_lock);
 
 	ceph_put_mds_session(session);
-	dout("flush_snaps done\n");
+	dout("%s done\n", __func__);
 }
 
 /**
@@ -941,8 +940,8 @@ void ceph_handle_snap(struct ceph_mds_client *mdsc,
 	trace_len = le32_to_cpu(h->trace_len);
 	p += sizeof(*h);
 
-	dout("handle_snap from mds%d op %s split %llx tracelen %d\n", mds,
-	     ceph_snap_op_name(op), split, trace_len);
+	dout("%s from mds%d op %s split %llx tracelen %d\n", __func__,
+	     mds, ceph_snap_op_name(op), split, trace_len);
 
 	mutex_lock(&session->s_mutex);
 	inc_session_sequence(session);
@@ -1002,13 +1001,13 @@ void ceph_handle_snap(struct ceph_mds_client *mdsc,
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
@@ -1051,7 +1050,7 @@ void ceph_handle_snap(struct ceph_mds_client *mdsc,
 	return;
 
 bad:
-	pr_err("corrupt snap message from mds%d\n", mds);
+	pr_err("%s corrupt snap message from mds%d\n", __func__, mds);
 	ceph_msg_dump(msg);
 out:
 	if (locked_rwsem)
@@ -1084,7 +1083,8 @@ struct ceph_snapid_map* ceph_get_snapid_map(struct ceph_mds_client *mdsc,
 	}
 	spin_unlock(&mdsc->snapid_map_lock);
 	if (exist) {
-		dout("found snapid map %llx -> %x\n", exist->snap, exist->dev);
+		dout("%s found snapid map %llx -> %x\n", __func__,
+		     exist->snap, exist->dev);
 		return exist;
 	}
 
@@ -1128,11 +1128,13 @@ struct ceph_snapid_map* ceph_get_snapid_map(struct ceph_mds_client *mdsc,
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

