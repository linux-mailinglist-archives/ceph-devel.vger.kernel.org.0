Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 704EF6A3991
	for <lists+ceph-devel@lfdr.de>; Mon, 27 Feb 2023 04:30:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230133AbjB0Dax (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Sun, 26 Feb 2023 22:30:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230173AbjB0Dar (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Sun, 26 Feb 2023 22:30:47 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5537B772
        for <ceph-devel@vger.kernel.org>; Sun, 26 Feb 2023 19:29:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1677468578;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Q+HdHI88lruf0ejgmTE+CCdTZnfBRwPRpTjGxpPvDMQ=;
        b=a4zlyDdZUw1oy+0znRM7rfpvTxt/Cdd8E9ImWRayDN11PENwFBy/khzGp0SSlAj0mVdp9W
        IOqdkdg0x5+xBRZDvAgjxfcyxqLLC4TcYf1mbUYpgvaTluAzUZgisONfgNgWPjuAxHSfO8
        3KUlqg37nzUKp9BS0Y4GtZh5AAIBpi4=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-651-gwR_m8MwMUKass9WCydqrg-1; Sun, 26 Feb 2023 22:29:35 -0500
X-MC-Unique: gwR_m8MwMUKass9WCydqrg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3332C29AA3B1;
        Mon, 27 Feb 2023 03:29:35 +0000 (UTC)
Received: from lxbceph1.gsslab.pek2.redhat.com (unknown [10.72.47.117])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 649991731B;
        Mon, 27 Feb 2023 03:29:32 +0000 (UTC)
From:   xiubli@redhat.com
To:     idryomov@gmail.com, ceph-devel@vger.kernel.org
Cc:     jlayton@kernel.org, lhenriques@suse.de, vshankar@redhat.com,
        mchangir@redhat.com, Xiubo Li <xiubli@redhat.com>
Subject: [PATCH v16 21/68] ceph: send altname in MClientRequest
Date:   Mon, 27 Feb 2023 11:27:26 +0800
Message-Id: <20230227032813.337906-22-xiubli@redhat.com>
In-Reply-To: <20230227032813.337906-1-xiubli@redhat.com>
References: <20230227032813.337906-1-xiubli@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: Jeff Layton <jlayton@kernel.org>

In the event that we have a filename longer than CEPH_NOHASH_NAME_MAX,
we'll need to hash the tail of the filename. The client however will
still need to know the full name of the file if it has a key.

To support this, the MClientRequest field has grown a new alternate_name
field that we populate with the full (binary) crypttext of the filename.
This is then transmitted to the clients in readdir or traces as part of
the dentry lease.

Add support for populating this field when the filenames are very long.

Reviewed-by: Xiubo Li <xiubli@redhat.com>
Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/ceph/mds_client.c | 75 +++++++++++++++++++++++++++++++++++++++++---
 fs/ceph/mds_client.h |  3 ++
 2 files changed, 73 insertions(+), 5 deletions(-)

diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
index a5e5349aac38..579faa2c76a1 100644
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -1048,6 +1048,7 @@ void ceph_mdsc_release_request(struct kref *kref)
 	if (req->r_pagelist)
 		ceph_pagelist_release(req->r_pagelist);
 	kfree(req->r_fscrypt_auth);
+	kfree(req->r_altname);
 	put_request_session(req);
 	ceph_unreserve_caps(req->r_mdsc, &req->r_caps_reservation);
 	WARN_ON_ONCE(!list_empty(&req->r_wait));
@@ -2470,6 +2471,63 @@ static inline  u64 __get_oldest_tid(struct ceph_mds_client *mdsc)
 	return mdsc->oldest_tid;
 }
 
+#if IS_ENABLED(CONFIG_FS_ENCRYPTION)
+static u8 *get_fscrypt_altname(const struct ceph_mds_request *req, u32 *plen)
+{
+	struct inode *dir = req->r_parent;
+	struct dentry *dentry = req->r_dentry;
+	u8 *cryptbuf = NULL;
+	u32 len = 0;
+	int ret = 0;
+
+	/* only encode if we have parent and dentry */
+	if (!dir || !dentry)
+		goto success;
+
+	/* No-op unless this is encrypted */
+	if (!IS_ENCRYPTED(dir))
+		goto success;
+
+	ret = __fscrypt_prepare_readdir(dir);
+	if (ret)
+		return ERR_PTR(ret);
+
+	/* No key? Just ignore it. */
+	if (!fscrypt_has_encryption_key(dir))
+		goto success;
+
+	if (!fscrypt_fname_encrypted_size(dir, dentry->d_name.len, NAME_MAX, &len)) {
+		WARN_ON_ONCE(1);
+		return ERR_PTR(-ENAMETOOLONG);
+	}
+
+	/* No need to append altname if name is short enough */
+	if (len <= CEPH_NOHASH_NAME_MAX) {
+		len = 0;
+		goto success;
+	}
+
+	cryptbuf = kmalloc(len, GFP_KERNEL);
+	if (!cryptbuf)
+		return ERR_PTR(-ENOMEM);
+
+	ret = fscrypt_fname_encrypt(dir, &dentry->d_name, cryptbuf, len);
+	if (ret) {
+		kfree(cryptbuf);
+		return ERR_PTR(ret);
+	}
+success:
+	*plen = len;
+	return cryptbuf;
+}
+#else
+static u8 *get_fscrypt_altname(const struct ceph_mds_request *req, u32 *plen)
+{
+	*plen = 0;
+	return NULL;
+}
+#endif
+
 /**
  * ceph_mdsc_build_path - build a path string to a given dentry
  * @dentry: dentry to which path should be built
@@ -2690,14 +2748,15 @@ static void encode_mclientrequest_tail(void **p, const struct ceph_mds_request *
 	ceph_encode_timespec64(&ts, &req->r_stamp);
 	ceph_encode_copy(p, &ts, sizeof(ts));
 
-	/* gid_list */
+	/* v4: gid_list */
 	ceph_encode_32(p, req->r_cred->group_info->ngroups);
 	for (i = 0; i < req->r_cred->group_info->ngroups; i++)
 		ceph_encode_64(p, from_kgid(&init_user_ns,
 					    req->r_cred->group_info->gid[i]));
 
-	/* v5: altname (TODO: skip for now) */
-	ceph_encode_32(p, 0);
+	/* v5: altname */
+	ceph_encode_32(p, req->r_altname_len);
+	ceph_encode_copy(p, req->r_altname, req->r_altname_len);
 
 	/* v6: fscrypt_auth and fscrypt_file */
 	if (req->r_fscrypt_auth) {
@@ -2753,7 +2812,13 @@ static struct ceph_msg *create_request_message(struct ceph_mds_session *session,
 		goto out_free1;
 	}
 
-	/* head */
+	req->r_altname = get_fscrypt_altname(req, &req->r_altname_len);
+	if (IS_ERR(req->r_altname)) {
+		msg = ERR_CAST(req->r_altname);
+		req->r_altname = NULL;
+		goto out_free2;
+	}
+
 	len = legacy ? sizeof(*head) : sizeof(struct ceph_mds_request_head);
 
 	/* filepaths */
@@ -2779,7 +2844,7 @@ static struct ceph_msg *create_request_message(struct ceph_mds_session *session,
 	len += sizeof(u32) + (sizeof(u64) * req->r_cred->group_info->ngroups);
 
 	/* alternate name */
-	len += sizeof(u32);	// TODO
+	len += sizeof(u32) + req->r_altname_len;
 
 	/* fscrypt_auth */
 	len += sizeof(u32); // fscrypt_auth
diff --git a/fs/ceph/mds_client.h b/fs/ceph/mds_client.h
index b3e3fcefef4a..e7af8090b760 100644
--- a/fs/ceph/mds_client.h
+++ b/fs/ceph/mds_client.h
@@ -290,6 +290,9 @@ struct ceph_mds_request {
 
 	struct ceph_fscrypt_auth *r_fscrypt_auth;
 
+	u8 *r_altname;		    /* fscrypt binary crypttext for long filenames */
+	u32 r_altname_len;	    /* length of r_altname */
+
 	int r_fmode;        /* file mode, if expecting cap */
 	int r_request_release_offset;
 	const struct cred *r_cred;
-- 
2.31.1

