Return-Path: <ceph-devel+bounces-845-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6B9B68523B7
	for <lists+ceph-devel@lfdr.de>; Tue, 13 Feb 2024 01:32:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 0C79BB2528D
	for <lists+ceph-devel@lfdr.de>; Tue, 13 Feb 2024 00:32:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 94B6158234;
	Tue, 13 Feb 2024 00:19:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ffpJeqQj"
X-Original-To: ceph-devel@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21D7958210;
	Tue, 13 Feb 2024 00:19:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707783596; cv=none; b=UtOoDwlGce3w0l34NPwZlOczg01nuyLnOdxySEdcKS+4fXCTdvxGj1nQgvLtqkLfh7JiWOe9bt6bTA0xq5stH29Rup95QWfBIlthWcxDHFyNmpWgHXrW5t/hhDuNueiGXnvyJzDvfspkwPZtRaZH9pxrRVFt7REVbfIQReXWKws=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707783596; c=relaxed/simple;
	bh=jERYzjosGJaO2X0l1dReBsO+AORVK2jSWCFz5Jenho0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QfdibBzVKTPjKlu7mLV5MYMXcsTtDUVJUPBdyyp3CNhMFR690AzQg4FkArYeKpFYp01IbN7cbzmBMQvAYjSqPIgfNXdl4DGw2WbyoRsyno6hf/pccn/Mg/phM9Qli4ttPuIAa7R3y096g91s4FFV/UCjAPyIDlXSMGp1yEjIKec=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ffpJeqQj; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90461C43394;
	Tue, 13 Feb 2024 00:19:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1707783596;
	bh=jERYzjosGJaO2X0l1dReBsO+AORVK2jSWCFz5Jenho0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ffpJeqQjHFUqEaCfo1PejJcLV2NEvSlQ6rcWqD+elDuHKh7TJ+mRtIrnMvUJtUVjk
	 tBC8O9bxVK+C7fnj4aN+1xieCsED5crM9gGzxL56G/arK24pDpu+jjsRwnRV8yPqon
	 HtxMYu4DBzVbESSxPkBBSOS8Zxx6d+IVwoHSxd0lOW4x5dwcSYbKLPLticDN/LKYV9
	 zJjbBXLnzee1Z7m1FQDAIWCold9ksR7FzreCYSQMW3fCZvVor/+7ZfI1G+3oJ+Imre
	 bfLLeAncaMR7pCY4CBSEc2oeoqiIX0cTqLkKhOqjZCiu0cVVE6h2PxGqiHR4PEM1rN
	 tG3VOlSsxffrw==
From: Sasha Levin <sashal@kernel.org>
To: linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Cc: Xiubo Li <xiubli@redhat.com>,
	Jeff Layton <jlayton@kernel.org>,
	Ilya Dryomov <idryomov@gmail.com>,
	Sasha Levin <sashal@kernel.org>,
	davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	ceph-devel@vger.kernel.org,
	netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 6.7 47/58] libceph: fail sparse-read if the data length doesn't match
Date: Mon, 12 Feb 2024 19:17:53 -0500
Message-ID: <20240213001837.668862-47-sashal@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240213001837.668862-1-sashal@kernel.org>
References: <20240213001837.668862-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.7.4
Content-Transfer-Encoding: 8bit

From: Xiubo Li <xiubli@redhat.com>

[ Upstream commit cd7d469c25704d414d71bf3644f163fb74e7996b ]

Once this happens that means there have bugs.

Signed-off-by: Xiubo Li <xiubli@redhat.com>
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/ceph/osd_client.h |  3 ++-
 net/ceph/osd_client.c           | 18 +++++++++++++++---
 2 files changed, 17 insertions(+), 4 deletions(-)

diff --git a/include/linux/ceph/osd_client.h b/include/linux/ceph/osd_client.h
index b8610e9d2471..5edf9fffa097 100644
--- a/include/linux/ceph/osd_client.h
+++ b/include/linux/ceph/osd_client.h
@@ -45,6 +45,7 @@ enum ceph_sparse_read_state {
 	CEPH_SPARSE_READ_HDR	= 0,
 	CEPH_SPARSE_READ_EXTENTS,
 	CEPH_SPARSE_READ_DATA_LEN,
+	CEPH_SPARSE_READ_DATA_PRE,
 	CEPH_SPARSE_READ_DATA,
 };
 
@@ -64,7 +65,7 @@ struct ceph_sparse_read {
 	u64				sr_req_len;  /* orig request length */
 	u64				sr_pos;      /* current pos in buffer */
 	int				sr_index;    /* current extent index */
-	__le32				sr_datalen;  /* length of actual data */
+	u32				sr_datalen;  /* length of actual data */
 	u32				sr_count;    /* extent count in reply */
 	int				sr_ext_len;  /* length of extent array */
 	struct ceph_sparse_extent	*sr_extent;  /* extent array */
diff --git a/net/ceph/osd_client.c b/net/ceph/osd_client.c
index d3a759e052c8..a2abfda17a24 100644
--- a/net/ceph/osd_client.c
+++ b/net/ceph/osd_client.c
@@ -5859,8 +5859,8 @@ static int osd_sparse_read(struct ceph_connection *con,
 	struct ceph_osd *o = con->private;
 	struct ceph_sparse_read *sr = &o->o_sparse_read;
 	u32 count = sr->sr_count;
-	u64 eoff, elen;
-	int ret;
+	u64 eoff, elen, len = 0;
+	int i, ret;
 
 	switch (sr->sr_state) {
 	case CEPH_SPARSE_READ_HDR:
@@ -5912,8 +5912,20 @@ static int osd_sparse_read(struct ceph_connection *con,
 		convert_extent_map(sr);
 		ret = sizeof(sr->sr_datalen);
 		*pbuf = (char *)&sr->sr_datalen;
-		sr->sr_state = CEPH_SPARSE_READ_DATA;
+		sr->sr_state = CEPH_SPARSE_READ_DATA_PRE;
 		break;
+	case CEPH_SPARSE_READ_DATA_PRE:
+		/* Convert sr_datalen to host-endian */
+		sr->sr_datalen = le32_to_cpu((__force __le32)sr->sr_datalen);
+		for (i = 0; i < count; i++)
+			len += sr->sr_extent[i].len;
+		if (sr->sr_datalen != len) {
+			pr_warn_ratelimited("data len %u != extent len %llu\n",
+					    sr->sr_datalen, len);
+			return -EREMOTEIO;
+		}
+		sr->sr_state = CEPH_SPARSE_READ_DATA;
+		fallthrough;
 	case CEPH_SPARSE_READ_DATA:
 		if (sr->sr_index >= count) {
 			sr->sr_state = CEPH_SPARSE_READ_HDR;
-- 
2.43.0


