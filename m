Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB37626AEBB
	for <lists+ceph-devel@lfdr.de>; Tue, 15 Sep 2020 22:35:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727821AbgIOUfk (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 15 Sep 2020 16:35:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726485AbgIOUde (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 15 Sep 2020 16:33:34 -0400
Received: from mail-wm1-x344.google.com (mail-wm1-x344.google.com [IPv6:2a00:1450:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C275C061788
        for <ceph-devel@vger.kernel.org>; Tue, 15 Sep 2020 13:33:34 -0700 (PDT)
Received: by mail-wm1-x344.google.com with SMTP id x23so725956wmi.3
        for <ceph-devel@vger.kernel.org>; Tue, 15 Sep 2020 13:33:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=6q40jXYRukB/kOmVupz0cPd0C1jNU88sdb03fntszPQ=;
        b=Y6X1r7esrhXtuaJqSDQ+9jDuUEi9n1ou8kY396tA2AmyDRd7scHC0Sji/n9KKRzXj8
         vySMul4SinMGEZ1c5tCy4A4wnUbQ6rfAzKpfqjcx8fYFhwaQZSCu+dF99Ot2qoVXF7C1
         rjB1JRiuIhkcB3ibVB90PrZN5IkMwxA6DVFPLyfFem9WkzdQXjhbg4Qh1jDe8WULrs6c
         NulVwpPdzkBfIovX2Sva7LyPKpf6MhFgtyYB2JqCsh3wu+ICjRJ5IbtF/562XgJ9xN1j
         AXckqBtvxM4PKTr1aSi+9KpkaaKF1mNST45PzI70b6Iw5MEYOQxUQS3kwPvb5XPHUJSw
         o9UA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=6q40jXYRukB/kOmVupz0cPd0C1jNU88sdb03fntszPQ=;
        b=A1pjHDR/z++TNx45zor/IkK+AhRWu6avI8Zape2HpHXIXdIsQ5NnNtEmQCTchgJFnq
         AyFnHVkmUrSZPRU9ojwvd+jodUmSPAz/7SKGhFjVEDCJCuYI/6xytJk5pOV2lmRZcMsL
         3xrtzvpaS3wrQOfr31OcYw82JliO9pD4c7/TGNv5keuqWuTqr5An9hJdcnUHSkDWX2nW
         OjSJPAr74TneEiaC3mb8sU+GbkdFVG/hBHyp6HXCiTyglsg2rUEYiw5poh13qVoBx34q
         hxj6IUQs/I72LMAxY7WJv/vgYXBSgH+1dP0hqqQZ9v8aEEzDAyo43guvRO37uKy6JPla
         hbOQ==
X-Gm-Message-State: AOAM533KoKpg8w06rWVORJTpOCKBMvze9jhovzH0azLGuY34yUv/ou79
        hdA2U8nfn2k7cLUQq2BmV5LjbTWp2PwSwQ==
X-Google-Smtp-Source: ABdhPJxuNNghRSv4PKmOHxeUepcd8qCSqfT167P34AkmIabre/dsMwu+nCwv9qP8UgGMtfEg7959IQ==
X-Received: by 2002:a1c:9e0e:: with SMTP id h14mr1117824wme.18.1600202012217;
        Tue, 15 Sep 2020 13:33:32 -0700 (PDT)
Received: from kwango.redhat.com (ip-94-112-132-16.net.upcbroadband.cz. [94.112.132.16])
        by smtp.gmail.com with ESMTPSA id q12sm27487250wrs.48.2020.09.15.13.33.31
        for <ceph-devel@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Sep 2020 13:33:31 -0700 (PDT)
From:   Ilya Dryomov <idryomov@gmail.com>
To:     ceph-devel@vger.kernel.org
Subject: [PATCH 1/3] libceph, rbd, ceph: "blacklist" -> "blocklist"
Date:   Tue, 15 Sep 2020 22:33:21 +0200
Message-Id: <20200915203323.4688-2-idryomov@gmail.com>
X-Mailer: git-send-email 2.19.2
In-Reply-To: <20200915203323.4688-1-idryomov@gmail.com>
References: <20200915203323.4688-1-idryomov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
---
 Documentation/filesystems/ceph.rst |  6 +++---
 drivers/block/rbd.c                |  8 ++++----
 fs/ceph/addr.c                     | 24 ++++++++++++------------
 fs/ceph/file.c                     |  4 ++--
 fs/ceph/mds_client.c               | 16 ++++++++--------
 fs/ceph/super.c                    |  4 ++--
 fs/ceph/super.h                    |  4 ++--
 include/linux/ceph/mon_client.h    |  2 +-
 include/linux/ceph/rados.h         |  2 +-
 net/ceph/mon_client.c              |  8 ++++----
 10 files changed, 39 insertions(+), 39 deletions(-)

diff --git a/Documentation/filesystems/ceph.rst b/Documentation/filesystems/ceph.rst
index 0aa70750df0f..7d2ef4e27273 100644
--- a/Documentation/filesystems/ceph.rst
+++ b/Documentation/filesystems/ceph.rst
@@ -163,14 +163,14 @@ Mount Options
         to the default VFS implementation if this option is used.
 
   recover_session=<no|clean>
-	Set auto reconnect mode in the case where the client is blacklisted. The
+	Set auto reconnect mode in the case where the client is blocklisted. The
 	available modes are "no" and "clean". The default is "no".
 
 	* no: never attempt to reconnect when client detects that it has been
-	  blacklisted. Operations will generally fail after being blacklisted.
+	  blocklisted. Operations will generally fail after being blocklisted.
 
 	* clean: client reconnects to the ceph cluster automatically when it
-	  detects that it has been blacklisted. During reconnect, client drops
+	  detects that it has been blocklisted. During reconnect, client drops
 	  dirty data/metadata, invalidates page caches and writable file handles.
 	  After reconnect, file locks become stale because the MDS loses track
 	  of them. If an inode contains any stale file locks, read/write on the
diff --git a/drivers/block/rbd.c b/drivers/block/rbd.c
index 180587ce606c..d21fecfe3eba 100644
--- a/drivers/block/rbd.c
+++ b/drivers/block/rbd.c
@@ -4010,10 +4010,10 @@ static int rbd_try_lock(struct rbd_device *rbd_dev)
 		rbd_warn(rbd_dev, "breaking header lock owned by %s%llu",
 			 ENTITY_NAME(lockers[0].id.name));
 
-		ret = ceph_monc_blacklist_add(&client->monc,
+		ret = ceph_monc_blocklist_add(&client->monc,
 					      &lockers[0].info.addr);
 		if (ret) {
-			rbd_warn(rbd_dev, "blacklist of %s%llu failed: %d",
+			rbd_warn(rbd_dev, "blocklist of %s%llu failed: %d",
 				 ENTITY_NAME(lockers[0].id.name), ret);
 			goto out;
 		}
@@ -4077,7 +4077,7 @@ static int rbd_try_acquire_lock(struct rbd_device *rbd_dev)
 	ret = rbd_try_lock(rbd_dev);
 	if (ret < 0) {
 		rbd_warn(rbd_dev, "failed to lock header: %d", ret);
-		if (ret == -EBLACKLISTED)
+		if (ret == -EBLOCKLISTED)
 			goto out;
 
 		ret = 1; /* request lock anyway */
@@ -4613,7 +4613,7 @@ static void rbd_reregister_watch(struct work_struct *work)
 	ret = __rbd_register_watch(rbd_dev);
 	if (ret) {
 		rbd_warn(rbd_dev, "failed to reregister watch: %d", ret);
-		if (ret != -EBLACKLISTED && ret != -ENOENT) {
+		if (ret != -EBLOCKLISTED && ret != -ENOENT) {
 			queue_delayed_work(rbd_dev->task_wq,
 					   &rbd_dev->watch_dwork,
 					   RBD_RETRY_DELAY);
diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
index b03dbaa9d345..7b1f3dad576f 100644
--- a/fs/ceph/addr.c
+++ b/fs/ceph/addr.c
@@ -271,8 +271,8 @@ static int ceph_do_readpage(struct file *filp, struct page *page)
 	if (err < 0) {
 		SetPageError(page);
 		ceph_fscache_readpage_cancel(inode, page);
-		if (err == -EBLACKLISTED)
-			fsc->blacklisted = true;
+		if (err == -EBLOCKLISTED)
+			fsc->blocklisted = true;
 		goto out;
 	}
 	if (err < PAGE_SIZE)
@@ -312,8 +312,8 @@ static void finish_read(struct ceph_osd_request *req)
 	int i;
 
 	dout("finish_read %p req %p rc %d bytes %d\n", inode, req, rc, bytes);
-	if (rc == -EBLACKLISTED)
-		ceph_inode_to_client(inode)->blacklisted = true;
+	if (rc == -EBLOCKLISTED)
+		ceph_inode_to_client(inode)->blocklisted = true;
 
 	/* unlock all pages, zeroing any data we didn't read */
 	osd_data = osd_req_op_extent_osd_data(req, 0);
@@ -737,8 +737,8 @@ static int writepage_nounlock(struct page *page, struct writeback_control *wbc)
 			end_page_writeback(page);
 			return err;
 		}
-		if (err == -EBLACKLISTED)
-			fsc->blacklisted = true;
+		if (err == -EBLOCKLISTED)
+			fsc->blocklisted = true;
 		dout("writepage setting page/mapping error %d %p\n",
 		     err, page);
 		mapping_set_error(&inode->i_data, err);
@@ -801,8 +801,8 @@ static void writepages_finish(struct ceph_osd_request *req)
 	if (rc < 0) {
 		mapping_set_error(mapping, rc);
 		ceph_set_error_write(ci);
-		if (rc == -EBLACKLISTED)
-			fsc->blacklisted = true;
+		if (rc == -EBLOCKLISTED)
+			fsc->blocklisted = true;
 	} else {
 		ceph_clear_error_write(ci);
 	}
@@ -2038,16 +2038,16 @@ static int __ceph_pool_perm_get(struct ceph_inode_info *ci,
 	if (err >= 0 || err == -ENOENT)
 		have |= POOL_READ;
 	else if (err != -EPERM) {
-		if (err == -EBLACKLISTED)
-			fsc->blacklisted = true;
+		if (err == -EBLOCKLISTED)
+			fsc->blocklisted = true;
 		goto out_unlock;
 	}
 
 	if (err2 == 0 || err2 == -EEXIST)
 		have |= POOL_WRITE;
 	else if (err2 != -EPERM) {
-		if (err2 == -EBLACKLISTED)
-			fsc->blacklisted = true;
+		if (err2 == -EBLOCKLISTED)
+			fsc->blocklisted = true;
 		err = err2;
 		goto out_unlock;
 	}
diff --git a/fs/ceph/file.c b/fs/ceph/file.c
index 762a280b7037..209535d5b8d3 100644
--- a/fs/ceph/file.c
+++ b/fs/ceph/file.c
@@ -933,8 +933,8 @@ static ssize_t ceph_sync_read(struct kiocb *iocb, struct iov_iter *to,
 		ceph_release_page_vector(pages, num_pages);
 
 		if (ret < 0) {
-			if (ret == -EBLACKLISTED)
-				fsc->blacklisted = true;
+			if (ret == -EBLOCKLISTED)
+				fsc->blocklisted = true;
 			break;
 		}
 
diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
index 76d8d9495d1d..bb2d938a17ac 100644
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -3303,7 +3303,7 @@ static void handle_forward(struct ceph_mds_client *mdsc,
 }
 
 static int __decode_session_metadata(void **p, void *end,
-				     bool *blacklisted)
+				     bool *blocklisted)
 {
 	/* map<string,string> */
 	u32 n;
@@ -3318,7 +3318,7 @@ static int __decode_session_metadata(void **p, void *end,
 		ceph_decode_32_safe(p, end, len, bad);
 		ceph_decode_need(p, end, len, bad);
 		if (err_str && strnstr(*p, "blacklisted", len))
-			*blacklisted = true;
+			*blocklisted = true;
 		*p += len;
 	}
 	return 0;
@@ -3341,7 +3341,7 @@ static void handle_session(struct ceph_mds_session *session,
 	u32 op;
 	u64 seq, features = 0;
 	int wake = 0;
-	bool blacklisted = false;
+	bool blocklisted = false;
 
 	/* decode */
 	ceph_decode_need(&p, end, sizeof(*h), bad);
@@ -3354,7 +3354,7 @@ static void handle_session(struct ceph_mds_session *session,
 	if (msg_version >= 3) {
 		u32 len;
 		/* version >= 2, metadata */
-		if (__decode_session_metadata(&p, end, &blacklisted) < 0)
+		if (__decode_session_metadata(&p, end, &blocklisted) < 0)
 			goto bad;
 		/* version >= 3, feature bits */
 		ceph_decode_32_safe(&p, end, len, bad);
@@ -3445,8 +3445,8 @@ static void handle_session(struct ceph_mds_session *session,
 		session->s_state = CEPH_MDS_SESSION_REJECTED;
 		cleanup_session_requests(mdsc, session);
 		remove_session_caps(session);
-		if (blacklisted)
-			mdsc->fsc->blacklisted = true;
+		if (blocklisted)
+			mdsc->fsc->blocklisted = true;
 		wake = 2; /* for good measure */
 		break;
 
@@ -4367,14 +4367,14 @@ static void maybe_recover_session(struct ceph_mds_client *mdsc)
 	if (READ_ONCE(fsc->mount_state) != CEPH_MOUNT_MOUNTED)
 		return;
 
-	if (!READ_ONCE(fsc->blacklisted))
+	if (!READ_ONCE(fsc->blocklisted))
 		return;
 
 	if (fsc->last_auto_reconnect &&
 	    time_before(jiffies, fsc->last_auto_reconnect + HZ * 60 * 30))
 		return;
 
-	pr_info("auto reconnect after blacklisted\n");
+	pr_info("auto reconnect after blocklisted\n");
 	fsc->last_auto_reconnect = jiffies;
 	ceph_force_reconnect(fsc->sb);
 }
diff --git a/fs/ceph/super.c b/fs/ceph/super.c
index b3fc9bb61afc..2516304379d3 100644
--- a/fs/ceph/super.c
+++ b/fs/ceph/super.c
@@ -1241,13 +1241,13 @@ int ceph_force_reconnect(struct super_block *sb)
 	 * see remove_session_caps_cb() */
 	flush_workqueue(fsc->inode_wq);
 
-	/* In case that we were blacklisted. This also reset
+	/* In case that we were blocklisted. This also reset
 	 * all mon/osd connections */
 	ceph_reset_client_addr(fsc->client);
 
 	ceph_osdc_clear_abort_err(&fsc->client->osdc);
 
-	fsc->blacklisted = false;
+	fsc->blocklisted = false;
 	fsc->mount_state = CEPH_MOUNT_MOUNTED;
 
 	if (sb->s_root) {
diff --git a/fs/ceph/super.h b/fs/ceph/super.h
index 483a52d281cd..582694899130 100644
--- a/fs/ceph/super.h
+++ b/fs/ceph/super.h
@@ -32,7 +32,7 @@
 #define CEPH_BLOCK_SHIFT   22  /* 4 MB */
 #define CEPH_BLOCK         (1 << CEPH_BLOCK_SHIFT)
 
-#define CEPH_MOUNT_OPT_CLEANRECOVER    (1<<1) /* auto reonnect (clean mode) after blacklisted */
+#define CEPH_MOUNT_OPT_CLEANRECOVER    (1<<1) /* auto reonnect (clean mode) after blocklisted */
 #define CEPH_MOUNT_OPT_DIRSTAT         (1<<4) /* `cat dirname` for stats */
 #define CEPH_MOUNT_OPT_RBYTES          (1<<5) /* dir st_bytes = rbytes */
 #define CEPH_MOUNT_OPT_NOASYNCREADDIR  (1<<7) /* no dcache readdir */
@@ -109,7 +109,7 @@ struct ceph_fs_client {
 	unsigned long mount_state;
 
 	unsigned long last_auto_reconnect;
-	bool blacklisted;
+	bool blocklisted;
 
 	bool have_copy_from2;
 
diff --git a/include/linux/ceph/mon_client.h b/include/linux/ceph/mon_client.h
index ce4ffeb384d7..b658961156a0 100644
--- a/include/linux/ceph/mon_client.h
+++ b/include/linux/ceph/mon_client.h
@@ -142,7 +142,7 @@ int ceph_monc_get_version(struct ceph_mon_client *monc, const char *what,
 int ceph_monc_get_version_async(struct ceph_mon_client *monc, const char *what,
 				ceph_monc_callback_t cb, u64 private_data);
 
-int ceph_monc_blacklist_add(struct ceph_mon_client *monc,
+int ceph_monc_blocklist_add(struct ceph_mon_client *monc,
 			    struct ceph_entity_addr *client_addr);
 
 extern int ceph_monc_open_session(struct ceph_mon_client *monc);
diff --git a/include/linux/ceph/rados.h b/include/linux/ceph/rados.h
index 3a518fd0eaad..43a7a1573b51 100644
--- a/include/linux/ceph/rados.h
+++ b/include/linux/ceph/rados.h
@@ -424,7 +424,7 @@ enum {
 };
 
 #define EOLDSNAPC    ERESTART  /* ORDERSNAP flag set; writer has old snapc*/
-#define EBLACKLISTED ESHUTDOWN /* blacklisted */
+#define EBLOCKLISTED ESHUTDOWN /* blocklisted */
 
 /* xattr comparison */
 enum {
diff --git a/net/ceph/mon_client.c b/net/ceph/mon_client.c
index d633a0aeaa55..efcdde471278 100644
--- a/net/ceph/mon_client.c
+++ b/net/ceph/mon_client.c
@@ -896,7 +896,7 @@ static void handle_command_ack(struct ceph_mon_client *monc,
 	ceph_msg_dump(msg);
 }
 
-int ceph_monc_blacklist_add(struct ceph_mon_client *monc,
+int ceph_monc_blocklist_add(struct ceph_mon_client *monc,
 			    struct ceph_entity_addr *client_addr)
 {
 	struct ceph_mon_generic_request *req;
@@ -936,9 +936,9 @@ int ceph_monc_blacklist_add(struct ceph_mon_client *monc,
 	ret = wait_generic_request(req);
 	if (!ret)
 		/*
-		 * Make sure we have the osdmap that includes the blacklist
+		 * Make sure we have the osdmap that includes the blocklist
 		 * entry.  This is needed to ensure that the OSDs pick up the
-		 * new blacklist before processing any future requests from
+		 * new blocklist before processing any future requests from
 		 * this client.
 		 */
 		ret = ceph_wait_for_latest_osdmap(monc->client, 0);
@@ -947,7 +947,7 @@ int ceph_monc_blacklist_add(struct ceph_mon_client *monc,
 	put_generic_request(req);
 	return ret;
 }
-EXPORT_SYMBOL(ceph_monc_blacklist_add);
+EXPORT_SYMBOL(ceph_monc_blocklist_add);
 
 /*
  * Resend pending generic requests.
-- 
2.19.2

