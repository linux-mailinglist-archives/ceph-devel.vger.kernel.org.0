Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 25294FC4D6
	for <lists+ceph-devel@lfdr.de>; Thu, 14 Nov 2019 11:57:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727126AbfKNK54 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 14 Nov 2019 05:57:56 -0500
Received: from mx2.suse.de ([195.135.220.15]:33340 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726923AbfKNK5l (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Thu, 14 Nov 2019 05:57:41 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 014F4AD07;
        Thu, 14 Nov 2019 10:57:40 +0000 (UTC)
From:   Luis Henriques <lhenriques@suse.com>
To:     Jeff Layton <jlayton@kernel.org>, Sage Weil <sage@redhat.com>,
        Ilya Dryomov <idryomov@gmail.com>,
        "Yan, Zheng" <zyan@redhat.com>
Cc:     ceph-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Luis Henriques <lhenriques@suse.com>
Subject: [RFC PATCH v2 2/4] ceph: get the require_osd_release field from the osdmap
Date:   Thu, 14 Nov 2019 10:57:34 +0000
Message-Id: <20191114105736.8636-3-lhenriques@suse.com>
In-Reply-To: <20191114105736.8636-1-lhenriques@suse.com>
References: <20191114105736.8636-1-lhenriques@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Since Ceph Octopus, OSDs are encoding require_osd_release into the client
data part of the osdmap.  This patch adds code to pick this extra field.

Signed-off-by: Luis Henriques <lhenriques@suse.com>
---
 include/linux/ceph/ceph_features.h | 10 ++++++++--
 include/linux/ceph/osdmap.h        |  1 +
 net/ceph/osdmap.c                  | 21 +++++++++++++++++++++
 3 files changed, 30 insertions(+), 2 deletions(-)

diff --git a/include/linux/ceph/ceph_features.h b/include/linux/ceph/ceph_features.h
index 39e6f4c57580..f329d1907dd7 100644
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
@@ -114,7 +117,7 @@ DEFINE_CEPH_FEATURE(25, 1, CRUSH_TUNABLES2)
 DEFINE_CEPH_FEATURE(26, 1, CREATEPOOLID)
 DEFINE_CEPH_FEATURE(27, 1, REPLY_CREATE_INODE)
 DEFINE_CEPH_FEATURE_RETIRED(28, 1, OSD_HBMSGS, HAMMER, JEWEL)
-DEFINE_CEPH_FEATURE(28, 2, SERVER_M)
+DEFINE_CEPH_FEATURE(28, 2, SERVER_MIMIC)
 DEFINE_CEPH_FEATURE(29, 1, MDSENC)
 DEFINE_CEPH_FEATURE(30, 1, OSDHASHPSPOOL)
 DEFINE_CEPH_FEATURE(31, 1, MON_SINGLE_PAXOS)  // deprecate me
@@ -212,7 +215,10 @@ DEFINE_CEPH_FEATURE_DEPRECATED(63, 1, RESERVED_BROKEN, LUMINOUS) // client-facin
 	 CEPH_FEATURE_CRUSH_TUNABLES5 |		\
 	 CEPH_FEATURE_NEW_OSDOPREPLY_ENCODING |	\
 	 CEPH_FEATURE_MSG_ADDR2 |		\
-	 CEPH_FEATURE_CEPHX_V2)
+	 CEPH_FEATURE_CEPHX_V2 |		\
+	 CEPH_FEATURE_SERVER_MIMIC |		\
+	 CEPH_FEATURE_SERVER_NAUTILUS |		\
+	 CEPH_FEATURE_SERVER_OCTOPUS)
 
 #define CEPH_FEATURES_REQUIRED_DEFAULT	0
 
diff --git a/include/linux/ceph/osdmap.h b/include/linux/ceph/osdmap.h
index e081b56f1c1d..0d8e7f5e3478 100644
--- a/include/linux/ceph/osdmap.h
+++ b/include/linux/ceph/osdmap.h
@@ -160,6 +160,7 @@ struct ceph_osdmap {
 
 	u32 flags;         /* CEPH_OSDMAP_* */
 
+	u8 require_osd_release;
 	u32 max_osd;       /* size of osd_state, _offload, _addr arrays */
 	u32 *osd_state;    /* CEPH_OSD_* */
 	u32 *osd_weight;   /* 0 = failed, 0x10000 = 100% normal */
diff --git a/net/ceph/osdmap.c b/net/ceph/osdmap.c
index 4e0de14f80bb..29526fd61983 100644
--- a/net/ceph/osdmap.c
+++ b/net/ceph/osdmap.c
@@ -1582,6 +1582,27 @@ static int osdmap_decode(void **p, void *end, struct ceph_osdmap *map)
 		WARN_ON(!RB_EMPTY_ROOT(&map->pg_upmap_items));
 	}
 
+	if (struct_v >= 6)
+		/* crush version */
+		ceph_decode_skip_32(p, end, e_inval);
+	if (struct_v >= 7) {
+		/*
+		 * skip removed_snaps and purged_snaps
+		 * (snap_interval_set_t = 8 + 8)
+		 */
+		ceph_decode_skip_set(p, end, 16, e_inval);
+		ceph_decode_skip_set(p, end, 16, e_inval);
+	}
+	if (struct_v >= 9) {
+		struct ceph_timespec ts;
+
+		/* last_up_change and last_in_change */
+		ceph_decode_copy_safe(p, end, &ts, sizeof(ts), e_inval);
+		ceph_decode_copy_safe(p, end, &ts, sizeof(ts), e_inval);
+	}
+	if (struct_v >= 10)
+		ceph_decode_8_safe(p, end, map->require_osd_release, e_inval);
+
 	/* ignore the rest */
 	*p = end;
 
