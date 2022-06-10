Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2906D545B20
	for <lists+ceph-devel@lfdr.de>; Fri, 10 Jun 2022 06:32:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239248AbiFJEcD (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 10 Jun 2022 00:32:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236110AbiFJEcB (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Fri, 10 Jun 2022 00:32:01 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C83094B1D5
        for <ceph-devel@vger.kernel.org>; Thu,  9 Jun 2022 21:31:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1654835518;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=TSSF18RsKWmmYBsA1m01nT4CaojqMnzrFHHAmtGV+hw=;
        b=R4vDCZueSiFcvry5Q5lZB8ebAOLLAGPC67dK9XpJN7NrFZIZn2UdgIy+xHkLb8Gju5QYoG
        NggO6UeLjGdaJ0iT55vS7yRllJluvOddZ/2A5ULoqpQGiKtJwjbNHoz5zITL5uGictZyfR
        wTImnMtKT0p82qhZWl0JL9xZSJwSxLA=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-157-tPgjZpHKNve71Bv8AErrjg-1; Fri, 10 Jun 2022 00:31:54 -0400
X-MC-Unique: tPgjZpHKNve71Bv8AErrjg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8356F101A54E;
        Fri, 10 Jun 2022 04:31:54 +0000 (UTC)
Received: from localhost (unknown [10.72.47.117])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D6C6A1730C;
        Fri, 10 Jun 2022 04:31:53 +0000 (UTC)
From:   Xiubo Li <xiubli@redhat.com>
To:     jlayton@kernel.org, idryomov@gmail.com
Cc:     lhenriques@suse.de, vshankar@redhat.com,
        ceph-devel@vger.kernel.org, Xiubo Li <xiubli@redhat.com>
Subject: [PATCH 2/2] ceph: update the auth cap when the async create req is forwarded
Date:   Fri, 10 Jun 2022 12:31:40 +0800
Message-Id: <20220610043140.642501-3-xiubli@redhat.com>
In-Reply-To: <20220610043140.642501-1-xiubli@redhat.com>
References: <20220610043140.642501-1-xiubli@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

For async create we will always try to choose the auth MDS of frag
the dentry belonged to of the parent directory to send the request
and ususally this works fine, but if the MDS migrated the directory
to another MDS before it could be handled the request will be
forwarded. And then the auth cap will be changed.

We need to update the auth cap in this case before the request is
forwarded.

URL: https://tracker.ceph.com/issues/55857
Signed-off-by: Xiubo Li <xiubli@redhat.com>
---
 fs/ceph/file.c       | 12 +++++++++
 fs/ceph/mds_client.c | 58 ++++++++++++++++++++++++++++++++++++++++++++
 fs/ceph/super.h      |  2 ++
 3 files changed, 72 insertions(+)

diff --git a/fs/ceph/file.c b/fs/ceph/file.c
index 0e82a1c383ca..54acf76c5e9b 100644
--- a/fs/ceph/file.c
+++ b/fs/ceph/file.c
@@ -613,6 +613,7 @@ static int ceph_finish_async_create(struct inode *dir, struct inode *inode,
 	struct ceph_mds_reply_inode in = { };
 	struct ceph_mds_reply_info_in iinfo = { .in = &in };
 	struct ceph_inode_info *ci = ceph_inode(dir);
+	struct ceph_dentry_info *di = ceph_dentry(dentry);
 	struct timespec64 now;
 	struct ceph_string *pool_ns;
 	struct ceph_mds_client *mdsc = ceph_sb_to_mdsc(dir->i_sb);
@@ -709,6 +710,12 @@ static int ceph_finish_async_create(struct inode *dir, struct inode *inode,
 		file->f_mode |= FMODE_CREATED;
 		ret = finish_open(file, dentry, ceph_open);
 	}
+
+	spin_lock(&dentry->d_lock);
+	di->flags &= ~CEPH_DENTRY_ASYNC_CREATE;
+	wake_up_bit(&di->flags, CEPH_DENTRY_ASYNC_CREATE_BIT);
+	spin_unlock(&dentry->d_lock);
+
 	return ret;
 }
 
@@ -786,6 +793,7 @@ int ceph_atomic_open(struct inode *dir, struct dentry *dentry,
 				  try_prep_async_create(dir, dentry, &lo, &req->r_deleg_ino))) {
 			struct ceph_vino vino = { .ino = req->r_deleg_ino,
 						  .snap = CEPH_NOSNAP };
+			struct ceph_dentry_info *di = ceph_dentry(dentry);
 
 			set_bit(CEPH_MDS_R_ASYNC, &req->r_req_flags);
 			req->r_args.open.flags |= cpu_to_le32(CEPH_O_EXCL);
@@ -800,6 +808,10 @@ int ceph_atomic_open(struct inode *dir, struct dentry *dentry,
 			}
 			WARN_ON_ONCE(!(new_inode->i_state & I_NEW));
 
+			spin_lock(&dentry->d_lock);
+			di->flags |= CEPH_DENTRY_ASYNC_CREATE;
+			spin_unlock(&dentry->d_lock);
+
 			err = ceph_mdsc_submit_request(mdsc, dir, req);
 			if (!err) {
 				err = ceph_finish_async_create(dir, new_inode, dentry,
diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
index fa7f719807d9..a413b389a535 100644
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -2993,6 +2993,64 @@ static void __do_request(struct ceph_mds_client *mdsc,
 	if (req->r_request_started == 0)   /* note request start time */
 		req->r_request_started = jiffies;
 
+	/*
+	 * For async create we will choose the auth MDS of frag in parent
+	 * directory to send the request and ususally this works fine, but
+	 * if the migrated the dirtory to another MDS before it could handle
+	 * it the request will be forwarded.
+	 *
+	 * And then the auth cap will be changed.
+	 */
+	if (test_bit(CEPH_MDS_R_ASYNC, &req->r_req_flags) && req->r_num_fwd) {
+		struct ceph_dentry_info *di = ceph_dentry(req->r_dentry);
+		struct ceph_inode_info *ci;
+		struct ceph_cap *cap;
+
+		/*
+		 * The request maybe handled very fast and the new inode
+		 * hasn't been linked to the dentry yet. We need to wait
+		 * for the ceph_finish_async_create(), which shouldn't be
+		 * stuck too long or fail in thoery, to finish when forwarding
+		 * the request.
+		 */
+		if (!d_inode(req->r_dentry)) {
+			err = wait_on_bit(&di->flags, CEPH_DENTRY_ASYNC_CREATE_BIT,
+					  TASK_KILLABLE);
+			if (err) {
+				mutex_lock(&req->r_fill_mutex);
+				set_bit(CEPH_MDS_R_ABORTED, &req->r_req_flags);
+				mutex_unlock(&req->r_fill_mutex);
+				goto out_session;
+			}
+		}
+
+		ci = ceph_inode(d_inode(req->r_dentry));
+
+		spin_lock(&ci->i_ceph_lock);
+		cap = ci->i_auth_cap;
+		if (ci->i_ceph_flags & CEPH_I_ASYNC_CREATE && mds != cap->mds) {
+			dout("do_request session changed for auth cap %d -> %d\n",
+			     cap->session->s_mds, session->s_mds);
+
+			/* Remove the auth cap from old session */
+			spin_lock(&cap->session->s_cap_lock);
+			cap->session->s_nr_caps--;
+			list_del_init(&cap->session_caps);
+			spin_unlock(&cap->session->s_cap_lock);
+
+			/* Add the auth cap to the new session */
+			cap->mds = mds;
+			cap->session = session;
+			spin_lock(&session->s_cap_lock);
+			session->s_nr_caps++;
+			list_add_tail(&cap->session_caps, &session->s_caps);
+			spin_unlock(&session->s_cap_lock);
+
+			change_auth_cap_ses(ci, session);
+		}
+		spin_unlock(&ci->i_ceph_lock);
+	}
+
 	err = __send_request(session, req, false);
 
 out_session:
diff --git a/fs/ceph/super.h b/fs/ceph/super.h
index 3bdd60a3e680..5ccafab21bbb 100644
--- a/fs/ceph/super.h
+++ b/fs/ceph/super.h
@@ -304,6 +304,8 @@ struct ceph_dentry_info {
 #define CEPH_DENTRY_PRIMARY_LINK	(1 << 3)
 #define CEPH_DENTRY_ASYNC_UNLINK_BIT	(4)
 #define CEPH_DENTRY_ASYNC_UNLINK	(1 << CEPH_DENTRY_ASYNC_UNLINK_BIT)
+#define CEPH_DENTRY_ASYNC_CREATE_BIT	(5)
+#define CEPH_DENTRY_ASYNC_CREATE	(1 << CEPH_DENTRY_ASYNC_CREATE_BIT)
 
 struct ceph_inode_xattrs_info {
 	/*
-- 
2.36.0.rc1

