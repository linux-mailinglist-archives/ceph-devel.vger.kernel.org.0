Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8F2CAF4DE9
	for <lists+ceph-devel@lfdr.de>; Fri,  8 Nov 2019 15:16:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728091AbfKHOQB (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 8 Nov 2019 09:16:01 -0500
Received: from mx2.suse.de ([195.135.220.15]:58058 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726294AbfKHOQA (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Fri, 8 Nov 2019 09:16:00 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 0696CB391;
        Fri,  8 Nov 2019 14:15:58 +0000 (UTC)
From:   Luis Henriques <lhenriques@suse.com>
To:     Jeff Layton <jlayton@kernel.org>,
        Ilya Dryomov <idryomov@gmail.com>, Sage Weil <sage@redhat.com>,
        "Yan, Zheng" <ukernel@gmail.com>
Cc:     ceph-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Luis Henriques <lhenriques@suse.com>
Subject: [RFC PATCH 1/2] ceph: add support for sending truncate_{seq,size} in 'copy-from' Op
Date:   Fri,  8 Nov 2019 14:15:54 +0000
Message-Id: <20191108141555.31176-2-lhenriques@suse.com>
In-Reply-To: <20191108141555.31176-1-lhenriques@suse.com>
References: <20191108141555.31176-1-lhenriques@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

By default, doing an object copy in Ceph will result in not only the
data being copied but also the truncate_seq and truncate_size values.
This may make sense in generic RADOS object copies, but for the specific
case of performing a file copy will result in data corruption in the
destination file.

In order to fix this, the 'copy-from' operation has been modified so
that it could receive the two extra parameters for the destination
object truncate_seq and truncate_size.  This patch adds support for
these extra parameters to the kernel client.  Unfortunately, this
operation modification is available in Ceph Octopus only, so it is
necessary to ensure that the OSD doing the copy does indeed support this
feature.

Link: https://tracker.ceph.com/issues/37378
Signed-off-by: Luis Henriques <lhenriques@suse.com>
---
 fs/ceph/file.c                     |  4 +++-
 include/linux/ceph/ceph_features.h |  6 ++++-
 include/linux/ceph/osd_client.h    |  1 +
 include/linux/ceph/rados.h         |  1 +
 net/ceph/osd_client.c              | 37 +++++++++++++++++++++++++++++-
 5 files changed, 46 insertions(+), 3 deletions(-)

diff --git a/fs/ceph/file.c b/fs/ceph/file.c
index d277f71abe0b..e21a8eaabeb1 100644
--- a/fs/ceph/file.c
+++ b/fs/ceph/file.c
@@ -2075,7 +2075,9 @@ static ssize_t __ceph_copy_file_range(struct file *src_file, loff_t src_off,
 			CEPH_OSD_OP_FLAG_FADVISE_NOCACHE,
 			&dst_oid, &dst_oloc,
 			CEPH_OSD_OP_FLAG_FADVISE_SEQUENTIAL |
-			CEPH_OSD_OP_FLAG_FADVISE_DONTNEED, 0);
+			CEPH_OSD_OP_FLAG_FADVISE_DONTNEED,
+			dst_ci->i_truncate_seq, dst_ci->i_truncate_size,
+			CEPH_OSD_COPY_FROM_FLAG_TRUNCATE_SEQ);
 		if (err) {
 			dout("ceph_osdc_copy_from returned %d\n", err);
 			if (!ret)
diff --git a/include/linux/ceph/ceph_features.h b/include/linux/ceph/ceph_features.h
index 39e6f4c57580..232257f6b60c 100644
--- a/include/linux/ceph/ceph_features.h
+++ b/include/linux/ceph/ceph_features.h
@@ -9,6 +9,7 @@
  */
 #define CEPH_FEATURE_INCARNATION_1 (0ull)
 #define CEPH_FEATURE_INCARNATION_2 (1ull<<57) // CEPH_FEATURE_SERVER_JEWEL
+#define CEPH_FEATURE_INCARNATION_3 ((1ull<<57)|(1ull<<28)) // SERVER_MIMIC
 
 #define DEFINE_CEPH_FEATURE(bit, incarnation, name)			\
 	static const uint64_t CEPH_FEATURE_##name = (1ULL<<bit);		\
@@ -76,6 +77,7 @@ DEFINE_CEPH_FEATURE( 0, 1, UID)
 DEFINE_CEPH_FEATURE( 1, 1, NOSRCADDR)
 DEFINE_CEPH_FEATURE_RETIRED( 2, 1, MONCLOCKCHECK, JEWEL, LUMINOUS)
 
+DEFINE_CEPH_FEATURE( 2, 3, SERVER_NAUTILUS)
 DEFINE_CEPH_FEATURE( 3, 1, FLOCK)
 DEFINE_CEPH_FEATURE( 4, 1, SUBSCRIBE2)
 DEFINE_CEPH_FEATURE( 5, 1, MONNAMES)
@@ -92,6 +94,7 @@ DEFINE_CEPH_FEATURE(14, 2, SERVER_KRAKEN)
 DEFINE_CEPH_FEATURE(15, 1, MONENC)
 DEFINE_CEPH_FEATURE_RETIRED(16, 1, QUERY_T, JEWEL, LUMINOUS)
 
+DEFINE_CEPH_FEATURE(16, 3, SERVER_OCTOPUS)
 DEFINE_CEPH_FEATURE_RETIRED(17, 1, INDEP_PG_MAP, JEWEL, LUMINOUS)
 
 DEFINE_CEPH_FEATURE(18, 1, CRUSH_TUNABLES)
@@ -212,7 +215,8 @@ DEFINE_CEPH_FEATURE_DEPRECATED(63, 1, RESERVED_BROKEN, LUMINOUS) // client-facin
 	 CEPH_FEATURE_CRUSH_TUNABLES5 |		\
 	 CEPH_FEATURE_NEW_OSDOPREPLY_ENCODING |	\
 	 CEPH_FEATURE_MSG_ADDR2 |		\
-	 CEPH_FEATURE_CEPHX_V2)
+	 CEPH_FEATURE_CEPHX_V2 |		\
+	 CEPH_FEATURE_SERVER_OCTOPUS)
 
 #define CEPH_FEATURES_REQUIRED_DEFAULT	0
 
diff --git a/include/linux/ceph/osd_client.h b/include/linux/ceph/osd_client.h
index eaffbdddf89a..5a62dbd3f4c2 100644
--- a/include/linux/ceph/osd_client.h
+++ b/include/linux/ceph/osd_client.h
@@ -534,6 +534,7 @@ int ceph_osdc_copy_from(struct ceph_osd_client *osdc,
 			struct ceph_object_id *dst_oid,
 			struct ceph_object_locator *dst_oloc,
 			u32 dst_fadvise_flags,
+			u32 truncate_seq, u64 truncate_size,
 			u8 copy_from_flags);
 
 /* watch/notify */
diff --git a/include/linux/ceph/rados.h b/include/linux/ceph/rados.h
index 3eb0e55665b4..fc70e68231b3 100644
--- a/include/linux/ceph/rados.h
+++ b/include/linux/ceph/rados.h
@@ -446,6 +446,7 @@ enum {
 	CEPH_OSD_COPY_FROM_FLAG_MAP_SNAP_CLONE = 8, /* map snap direct to
 						     * cloneid */
 	CEPH_OSD_COPY_FROM_FLAG_RWORDERED = 16,     /* order with write */
+	CEPH_OSD_COPY_FROM_FLAG_TRUNCATE_SEQ = 32,  /* send truncate_{seq,size} */
 };
 
 enum {
diff --git a/net/ceph/osd_client.c b/net/ceph/osd_client.c
index ba45b074a362..ade27f5fa777 100644
--- a/net/ceph/osd_client.c
+++ b/net/ceph/osd_client.c
@@ -2272,6 +2272,32 @@ static void maybe_request_map(struct ceph_osd_client *osdc)
 		ceph_monc_renew_subs(&osdc->client->monc);
 }
 
+/*
+ * This function will check, for each OSD operation in the request, if the
+ * required support features are available in the connection.
+ */
+static bool check_con_features(struct ceph_connection *con,
+			       struct ceph_osd_request *req)
+{
+	int i;
+
+	for (i = 0; i < req->r_num_ops; i++) {
+		switch (req->r_ops[i].op) {
+		case CEPH_OSD_OP_COPY_FROM:
+			/*
+			 * 'copy-from' implementation had a bug in the OSDs
+			 * before Octopus release where file data would get
+			 * corructed when truncated
+			 */
+			if (!CEPH_HAVE_FEATURE(con->peer_features,
+					       SERVER_OCTOPUS))
+				return false;
+			break;
+		}
+	}
+	return true;
+}
+
 static void complete_request(struct ceph_osd_request *req, int err);
 static void send_map_check(struct ceph_osd_request *req);
 
@@ -2336,6 +2362,10 @@ static void __submit_request(struct ceph_osd_request *req, bool wrlocked)
 	}
 
 	mutex_lock(&osd->lock);
+	if (!check_con_features(&osd->o_con, req)) {
+		err = -EOPNOTSUPP;
+		need_send = false;
+	}
 	/*
 	 * Assign the tid atomically with send_request() to protect
 	 * multiple writes to the same object from racing with each
@@ -5315,6 +5345,7 @@ static int osd_req_op_copy_from_init(struct ceph_osd_request *req,
 				     struct ceph_object_locator *src_oloc,
 				     u32 src_fadvise_flags,
 				     u32 dst_fadvise_flags,
+				     u32 truncate_seq, u64 truncate_size,
 				     u8 copy_from_flags)
 {
 	struct ceph_osd_req_op *op;
@@ -5335,6 +5366,8 @@ static int osd_req_op_copy_from_init(struct ceph_osd_request *req,
 	end = p + PAGE_SIZE;
 	ceph_encode_string(&p, end, src_oid->name, src_oid->name_len);
 	encode_oloc(&p, end, src_oloc);
+	ceph_encode_32(&p, truncate_seq);
+	ceph_encode_64(&p, truncate_size);
 	op->indata_len = PAGE_SIZE - (end - p);
 
 	ceph_osd_data_pages_init(&op->copy_from.osd_data, pages,
@@ -5350,6 +5383,7 @@ int ceph_osdc_copy_from(struct ceph_osd_client *osdc,
 			struct ceph_object_id *dst_oid,
 			struct ceph_object_locator *dst_oloc,
 			u32 dst_fadvise_flags,
+			u32 truncate_seq, u64 truncate_size,
 			u8 copy_from_flags)
 {
 	struct ceph_osd_request *req;
@@ -5366,7 +5400,8 @@ int ceph_osdc_copy_from(struct ceph_osd_client *osdc,
 
 	ret = osd_req_op_copy_from_init(req, src_snapid, src_version, src_oid,
 					src_oloc, src_fadvise_flags,
-					dst_fadvise_flags, copy_from_flags);
+					dst_fadvise_flags, truncate_seq,
+					truncate_size, copy_from_flags);
 	if (ret)
 		goto out;
 
