Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0348E16F412
	for <lists+ceph-devel@lfdr.de>; Wed, 26 Feb 2020 01:09:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729203AbgBZAJe (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 25 Feb 2020 19:09:34 -0500
Received: from gateway34.websitewelcome.com ([192.185.148.109]:45248 "EHLO
        gateway34.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728865AbgBZAJd (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Tue, 25 Feb 2020 19:09:33 -0500
X-Greylist: delayed 1423 seconds by postgrey-1.27 at vger.kernel.org; Tue, 25 Feb 2020 19:09:33 EST
Received: from cm14.websitewelcome.com (cm14.websitewelcome.com [100.42.49.7])
        by gateway34.websitewelcome.com (Postfix) with ESMTP id 8A6891209B20
        for <ceph-devel@vger.kernel.org>; Tue, 25 Feb 2020 17:45:49 -0600 (CST)
Received: from gator4166.hostgator.com ([108.167.133.22])
        by cmsmtp with SMTP
        id 6jtdjq3MPXVkQ6jtdjBSPE; Tue, 25 Feb 2020 17:45:49 -0600
X-Authority-Reason: nr=8
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=embeddedor.com; s=default; h=Content-Type:MIME-Version:Message-ID:Subject:
        Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=8kpppuVxEfbw1HY9gBs/P7x/njX6QXOO1jMPxsNR6sQ=; b=LdFi92iGDpBZAOEsGks8AdD4mT
        auLnIL2SJ/JwRgBeofSCcegK3Uv5sAHC2DZfOZ2k2yOpHIy8hWmokqXZojvcnp5U5t5C18ared7y4
        fH2sRDUIpzmxnyX/j2/hnOOcik3PohMovNqK/m2+9LZve2J6y71A7vYqydRumrArUNyeeiZ8k+gUX
        uGUwCFc0WJH2XLrMxyivzrz6wLTpe81q2ysj3PJv4emwPEmXQFMKNZqtHBF7iwdfZfOCfztLJPwzt
        ErqJagG72z1hQ/8Nx5Rj/HvJgsLQJLBqmtKcW47hVisLRS2ET9m5tGNkUYyb3VU1gTMnzPvHiH2UT
        0cwKBDeQ==;
Received: from [201.162.241.105] (port=30500 helo=embeddedor)
        by gator4166.hostgator.com with esmtpa (Exim 4.92)
        (envelope-from <gustavo@embeddedor.com>)
        id 1j6jtb-001yzF-GN; Tue, 25 Feb 2020 17:45:48 -0600
Date:   Tue, 25 Feb 2020 17:48:37 -0600
From:   "Gustavo A. R. Silva" <gustavo@embeddedor.com>
To:     "Richard Russon (FlatCap)" <ldm@flatcap.org>,
        Jens Axboe <axboe@kernel.dk>,
        Philipp Reisner <philipp.reisner@linbit.com>,
        Lars Ellenberg <lars.ellenberg@linbit.com>,
        Ilya Dryomov <idryomov@gmail.com>, Sage Weil <sage@redhat.com>,
        Dongsheng Yang <dongsheng.yang@easystack.cn>
Cc:     linux-ntfs-dev@lists.sourceforge.net, linux-block@vger.kernel.org,
        linux-kernel@vger.kernel.org, drbd-dev@lists.linbit.com,
        ceph-devel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Subject: [PATCH][next] block: Replace zero-length array with flexible-array
 member
Message-ID: <20200225234836.GA31741@embeddedor>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.9.4 (2018-02-28)
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - gator4166.hostgator.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - embeddedor.com
X-BWhitelist: no
X-Source-IP: 201.162.241.105
X-Source-L: No
X-Exim-ID: 1j6jtb-001yzF-GN
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: (embeddedor) [201.162.241.105]:30500
X-Source-Auth: gustavo@embeddedor.com
X-Email-Count: 12
X-Source-Cap: Z3V6aWRpbmU7Z3V6aWRpbmU7Z2F0b3I0MTY2Lmhvc3RnYXRvci5jb20=
X-Local-Domain: yes
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

The current codebase makes use of the zero-length array language
extension to the C90 standard, but the preferred mechanism to declare
variable-length types such as these ones is a flexible array member[1][2],
introduced in C99:

struct foo {
        int stuff;
        struct boo array[];
};

By making use of the mechanism above, we will get a compiler warning
in case the flexible array does not occur last in the structure, which
will help us prevent some kind of undefined behavior bugs from being
inadvertently introduced[3] to the codebase from now on.

Also, notice that, dynamic memory allocations won't be affected by
this change:

"Flexible array members have incomplete type, and so the sizeof operator
may not be applied. As a quirk of the original implementation of
zero-length arrays, sizeof evaluates to zero."[1]

This issue was found with the help of Coccinelle.

[1] https://gcc.gnu.org/onlinedocs/gcc/Zero-Length.html
[2] https://github.com/KSPP/linux/issues/21
[3] commit 76497732932f ("cxgb3/l2t: Fix undefined behaviour")

Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
---
 block/partitions/ldm.h             | 2 +-
 drivers/block/drbd/drbd_int.h      | 2 +-
 drivers/block/drbd/drbd_protocol.h | 8 ++++----
 drivers/block/rbd_types.h          | 2 +-
 4 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/block/partitions/ldm.h b/block/partitions/ldm.h
index 1ca63e97bccc..172432ce5c0f 100644
--- a/block/partitions/ldm.h
+++ b/block/partitions/ldm.h
@@ -93,7 +93,7 @@ struct frag {				/* VBLK Fragment handling */
 	u8		num;		/* Total number of records */
 	u8		rec;		/* This is record number n */
 	u8		map;		/* Which portions are in use */
-	u8		data[0];
+	u8		data[];
 };
 
 /* In memory LDM database structures. */
diff --git a/drivers/block/drbd/drbd_int.h b/drivers/block/drbd/drbd_int.h
index aae99a2d7bd4..a3314dd781a7 100644
--- a/drivers/block/drbd/drbd_int.h
+++ b/drivers/block/drbd/drbd_int.h
@@ -620,7 +620,7 @@ struct fifo_buffer {
 	unsigned int head_index;
 	unsigned int size;
 	int total; /* sum of all values */
-	int values[0];
+	int values[];
 };
 extern struct fifo_buffer *fifo_alloc(unsigned int fifo_size);
 
diff --git a/drivers/block/drbd/drbd_protocol.h b/drivers/block/drbd/drbd_protocol.h
index e6fc5ad72501..dea59c92ecc1 100644
--- a/drivers/block/drbd/drbd_protocol.h
+++ b/drivers/block/drbd/drbd_protocol.h
@@ -271,7 +271,7 @@ struct p_rs_param {
 	u32 resync_rate;
 
 	      /* Since protocol version 88 and higher. */
-	char verify_alg[0];
+	char verify_alg[];
 } __packed;
 
 struct p_rs_param_89 {
@@ -305,7 +305,7 @@ struct p_protocol {
 	u32 two_primaries;
 
 	/* Since protocol version 87 and higher. */
-	char integrity_alg[0];
+	char integrity_alg[];
 
 } __packed;
 
@@ -360,7 +360,7 @@ struct p_sizes {
 	u16	    dds_flags; /* use enum dds_flags here. */
 
 	/* optional queue_limits if (agreed_features & DRBD_FF_WSAME) */
-	struct o_qlim qlim[0];
+	struct o_qlim qlim[];
 } __packed;
 
 struct p_state {
@@ -409,7 +409,7 @@ struct p_compressed_bm {
 	 */
 	u8 encoding;
 
-	u8 code[0];
+	u8 code[];
 } __packed;
 
 struct p_delay_probe93 {
diff --git a/drivers/block/rbd_types.h b/drivers/block/rbd_types.h
index ac98ab6ccd3b..a600e0eb6b6f 100644
--- a/drivers/block/rbd_types.h
+++ b/drivers/block/rbd_types.h
@@ -93,7 +93,7 @@ struct rbd_image_header_ondisk {
 	__le32 snap_count;
 	__le32 reserved;
 	__le64 snap_names_len;
-	struct rbd_image_snap_ondisk snaps[0];
+	struct rbd_image_snap_ondisk snaps[];
 } __attribute__((packed));
 
 
-- 
2.25.0

