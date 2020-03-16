Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A00F118675C
	for <lists+ceph-devel@lfdr.de>; Mon, 16 Mar 2020 10:03:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730375AbgCPJDO (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 16 Mar 2020 05:03:14 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:35090 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730152AbgCPJDO (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 16 Mar 2020 05:03:14 -0400
Received: by mail-wm1-f68.google.com with SMTP id m3so17045581wmi.0
        for <ceph-devel@vger.kernel.org>; Mon, 16 Mar 2020 02:03:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=4hOHtkv/5Ndb67of/xW7NxId8SSzjMZ/Y4eRUWqOFHc=;
        b=WFuSEq3TrRYuVNG/WLngy7KuKMui5Pnllke1budTAbycwD/ofAx6nmFs/ZqgqDyckx
         XloNZzJXfxYCzA+swO8L3rYcXmj3a0gavU5FTgEeMbOAvxwsK3bh04tyvuNEqUqh98Vy
         K/01b2PfiBHaYEB9SJ7uF5+2zLoBAzx5M8mwRioComt0aZ5v0ODl8GrGfo62zAqEzssj
         vC3kEt4ybRysO89gIRElrGhc5LF8lgurOAkeWe8Tnn3VT2LXjihTMDeUiPbtYOfe3CnT
         L0Mnn64wPxr7M1axH8Y+wxPitAErw0OWqZ8rfSlNMV1AyP0R9rmNJcjCSGSV/kbAhLTw
         JrGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=4hOHtkv/5Ndb67of/xW7NxId8SSzjMZ/Y4eRUWqOFHc=;
        b=eaYEHp8iCkP//29XPK3F+273c+hbmKQfT5EUTAmEtajnlu+SjqJLLRqKHbT7DrhflK
         Kt3oyM0qNrjuV8lvlZlbAQy3Yzd+0cH4oGaQhwodMlSwrI4dmlsqcszDF/dIxyYJXJ9z
         +X/brVy7lfgmjDj/teWlGGrMw50WvSw8u784lFeUOatU7GZAbU8ZzJnhjid+rHOT2vCI
         5YZOHVegO06NKyBAGOr7pkk8Lo2yDgTylteVG8Sx+oDY0JW8zZOcwAIJfj5dt3vjwcmW
         TEYlnBDb7nOSWhVDM6zFFTpAmHzWwkwwnesIL2UpE0a39xMg1LnW7458nQqutjvOcWf1
         Lp2A==
X-Gm-Message-State: ANhLgQ0oXgXDHf09jUT808ygMM3y9vY+RtqdRZyEydkJqrlh5E9UpwV1
        Th5bCIFmXmHN40ZcIjeSRIhKggZ+tik=
X-Google-Smtp-Source: ADFU+vvtH8XyGK8vIT1hDIN+WbPTAkf6rJrRrZ5nmUqC7TKsSVfbtclmIDrOLcMrKDsCKQcO2PAOzg==
X-Received: by 2002:a1c:13:: with SMTP id 19mr27695514wma.183.1584349391082;
        Mon, 16 Mar 2020 02:03:11 -0700 (PDT)
Received: from kwango.local (ip-94-112-129-237.net.upcbroadband.cz. [94.112.129.237])
        by smtp.gmail.com with ESMTPSA id f15sm77562728wru.83.2020.03.16.02.03.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Mar 2020 02:03:10 -0700 (PDT)
From:   Ilya Dryomov <idryomov@gmail.com>
To:     ceph-devel@vger.kernel.org
Cc:     Yanhu Cao <gmayyyha@gmail.com>, Jeff Layton <jlayton@kernel.org>
Subject: [PATCH] ceph: check POOL_FLAG_FULL/NEARFULL in addition to OSDMAP_FULL/NEARFULL
Date:   Mon, 16 Mar 2020 10:03:08 +0100
Message-Id: <20200316090308.29004-1-idryomov@gmail.com>
X-Mailer: git-send-email 2.19.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

CEPH_OSDMAP_FULL/NEARFULL aren't set since mimic, so we need to consult
per-pool flags as well.  Unfortunately the backwards compatibility here
is lacking:

- the change that deprecated OSDMAP_FULL/NEARFULL went into mimic, but
  was guarded by require_osd_release >= RELEASE_LUMINOUS
- it was subsequently backported to luminous in v12.2.2, but that makes
  no difference to clients that only check OSDMAP_FULL/NEARFULL because
  require_osd_release is not client-facing -- it is for OSDs

Since all kernels are affected, the best we can do here is just start
checking both map flags and pool flags and send that to stable.

These checks are best effort, so take osdc->lock and look up pool flags
just once.  Remove the FIXME, since filesystem quotas are checked above
and RADOS quotas are reflected in POOL_FLAG_FULL: when the pool reaches
its quota, both POOL_FLAG_FULL and POOL_FLAG_FULL_QUOTA are set.

Cc: stable@vger.kernel.org
Reported-by: Yanhu Cao <gmayyyha@gmail.com>
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
---
 fs/ceph/file.c              | 14 +++++++++++---
 include/linux/ceph/osdmap.h |  4 ++++
 include/linux/ceph/rados.h  |  6 ++++--
 net/ceph/osdmap.c           |  9 +++++++++
 4 files changed, 28 insertions(+), 5 deletions(-)

diff --git a/fs/ceph/file.c b/fs/ceph/file.c
index aa08fdff0d98..8e4002280c2b 100644
--- a/fs/ceph/file.c
+++ b/fs/ceph/file.c
@@ -1689,10 +1689,13 @@ static ssize_t ceph_write_iter(struct kiocb *iocb, struct iov_iter *from)
 	struct inode *inode = file_inode(file);
 	struct ceph_inode_info *ci = ceph_inode(inode);
 	struct ceph_fs_client *fsc = ceph_inode_to_client(inode);
+	struct ceph_osd_client *osdc = &fsc->client->osdc;
 	struct ceph_cap_flush *prealloc_cf;
 	ssize_t count, written = 0;
 	int err, want, got;
 	bool direct_lock = false;
+	u32 map_flags;
+	u64 pool_flags;
 	loff_t pos;
 	loff_t limit = max(i_size_read(inode), fsc->max_file_size);
 
@@ -1755,8 +1758,12 @@ static ssize_t ceph_write_iter(struct kiocb *iocb, struct iov_iter *from)
 			goto out;
 	}
 
-	/* FIXME: not complete since it doesn't account for being at quota */
-	if (ceph_osdmap_flag(&fsc->client->osdc, CEPH_OSDMAP_FULL)) {
+	down_read(&osdc->lock);
+	map_flags = osdc->osdmap->flags;
+	pool_flags = ceph_pg_pool_flags(osdc->osdmap, ci->i_layout.pool_id);
+	up_read(&osdc->lock);
+	if ((map_flags & CEPH_OSDMAP_FULL) ||
+	    (pool_flags & CEPH_POOL_FLAG_FULL)) {
 		err = -ENOSPC;
 		goto out;
 	}
@@ -1849,7 +1856,8 @@ static ssize_t ceph_write_iter(struct kiocb *iocb, struct iov_iter *from)
 	}
 
 	if (written >= 0) {
-		if (ceph_osdmap_flag(&fsc->client->osdc, CEPH_OSDMAP_NEARFULL))
+		if ((map_flags & CEPH_OSDMAP_NEARFULL) ||
+		    (pool_flags & CEPH_POOL_FLAG_NEARFULL))
 			iocb->ki_flags |= IOCB_DSYNC;
 		written = generic_write_sync(iocb, written);
 	}
diff --git a/include/linux/ceph/osdmap.h b/include/linux/ceph/osdmap.h
index e081b56f1c1d..5e601975745f 100644
--- a/include/linux/ceph/osdmap.h
+++ b/include/linux/ceph/osdmap.h
@@ -37,6 +37,9 @@ int ceph_spg_compare(const struct ceph_spg *lhs, const struct ceph_spg *rhs);
 #define CEPH_POOL_FLAG_HASHPSPOOL	(1ULL << 0) /* hash pg seed and pool id
 						       together */
 #define CEPH_POOL_FLAG_FULL		(1ULL << 1) /* pool is full */
+#define CEPH_POOL_FLAG_FULL_QUOTA	(1ULL << 10) /* pool ran out of quota,
+							will set FULL too */
+#define CEPH_POOL_FLAG_NEARFULL		(1ULL << 11) /* pool is nearfull */
 
 struct ceph_pg_pool_info {
 	struct rb_node node;
@@ -304,5 +307,6 @@ extern struct ceph_pg_pool_info *ceph_pg_pool_by_id(struct ceph_osdmap *map,
 
 extern const char *ceph_pg_pool_name_by_id(struct ceph_osdmap *map, u64 id);
 extern int ceph_pg_poolid_by_name(struct ceph_osdmap *map, const char *name);
+u64 ceph_pg_pool_flags(struct ceph_osdmap *map, u64 id);
 
 #endif
diff --git a/include/linux/ceph/rados.h b/include/linux/ceph/rados.h
index 59bdfd470100..88ed3c5c04c5 100644
--- a/include/linux/ceph/rados.h
+++ b/include/linux/ceph/rados.h
@@ -143,8 +143,10 @@ extern const char *ceph_osd_state_name(int s);
 /*
  * osd map flag bits
  */
-#define CEPH_OSDMAP_NEARFULL (1<<0)  /* sync writes (near ENOSPC) */
-#define CEPH_OSDMAP_FULL     (1<<1)  /* no data writes (ENOSPC) */
+#define CEPH_OSDMAP_NEARFULL (1<<0)  /* sync writes (near ENOSPC),
+					not set since ~luminous */
+#define CEPH_OSDMAP_FULL     (1<<1)  /* no data writes (ENOSPC),
+					not set since ~luminous */
 #define CEPH_OSDMAP_PAUSERD  (1<<2)  /* pause all reads */
 #define CEPH_OSDMAP_PAUSEWR  (1<<3)  /* pause all writes */
 #define CEPH_OSDMAP_PAUSEREC (1<<4)  /* pause recovery */
diff --git a/net/ceph/osdmap.c b/net/ceph/osdmap.c
index 4e0de14f80bb..2a6e63a8edbe 100644
--- a/net/ceph/osdmap.c
+++ b/net/ceph/osdmap.c
@@ -710,6 +710,15 @@ int ceph_pg_poolid_by_name(struct ceph_osdmap *map, const char *name)
 }
 EXPORT_SYMBOL(ceph_pg_poolid_by_name);
 
+u64 ceph_pg_pool_flags(struct ceph_osdmap *map, u64 id)
+{
+	struct ceph_pg_pool_info *pi;
+
+	pi = __lookup_pg_pool(&map->pg_pools, id);
+	return pi ? pi->flags : 0;
+}
+EXPORT_SYMBOL(ceph_pg_pool_flags);
+
 static void __remove_pg_pool(struct rb_root *root, struct ceph_pg_pool_info *pi)
 {
 	rb_erase(&pi->node, root);
-- 
2.19.2

