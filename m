Return-Path: <ceph-devel+bounces-1698-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id EACD4956788
	for <lists+ceph-devel@lfdr.de>; Mon, 19 Aug 2024 11:52:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9E68C1F223B4
	for <lists+ceph-devel@lfdr.de>; Mon, 19 Aug 2024 09:52:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 542AF15D5B8;
	Mon, 19 Aug 2024 09:52:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="L4EMZDPZ"
X-Original-To: ceph-devel@vger.kernel.org
Received: from out-176.mta0.migadu.com (out-176.mta0.migadu.com [91.218.175.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AECC13C81B
	for <ceph-devel@vger.kernel.org>; Mon, 19 Aug 2024 09:52:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724061150; cv=none; b=OF+T9KR2vjRNux4C7U7C6gD+SIsN6TSfhu7BHUnL72BO3q2jAEyUVRcWCBYG37LfdifvgsGbi1EIBG85c7BGTP90TzNI/PexA1tCN8OPoTz8hnpcEhZJPUxNMT+CV4JR0avKLa6szQB7OUdt3BvrDSwPPP8NKVzsmLAwyACx2Bs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724061150; c=relaxed/simple;
	bh=4BN2Ul/ProVikPdBhbEcsEIXJ7jcB8IUaOeJDhhh7VQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=lcsXLV1E5HlKUfZ5jH7tuBUYwlSPLStTwkHxyxOM1yoQ/7ItSxTyt6xWTBR6EFq69Npi6T/We1Fzi1KfFe2/mv+9iJOSlADKK6SHhzNWpuX6MXOlEgfTTG2Nz84GojtD+4mFjUS2OBvOVziMyW+n7ugsiZsZqfAoCpCjh/fZ96s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=L4EMZDPZ; arc=none smtp.client-ip=91.218.175.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1724061146;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=tqrN5CJi6NpTChGvwEbegOzVx3UaFOTDcMpyKEfmAB4=;
	b=L4EMZDPZ6r54KD0ST93Epem3R2vBzFeH1ragumTt6IBfmLD9G06d/c4KMHy6bvtYwLkTZ9
	5O3TpHgOkIursqHX3LALvughQb1aqJhuS+Wm3AV7d8hxEs9k1p5o/XdW8DW2HSoGXDftlr
	vr/J7ESw1TiR6jL535mlZ6WwuhjRct4=
From: "Luis Henriques (SUSE)" <luis.henriques@linux.dev>
To: Xiubo Li <xiubli@redhat.com>,
	Ilya Dryomov <idryomov@gmail.com>,
	Milind Changire <mchangir@redhat.com>
Cc: ceph-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	"Luis Henriques (SUSE)" <luis.henriques@linux.dev>
Subject: [PATCH v2] ceph: fix memory in MDS client cap_auths
Date: Mon, 19 Aug 2024 10:52:17 +0100
Message-ID: <20240819095217.6415-1-luis.henriques@linux.dev>
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

The cap_auths that are allocated during an MDS session opening are never
released, causing a memory leak detected by kmemleak.  Fix this by freeing
the memory allocated when shutting down the mds client.

Fixes: 1d17de9534cb ("ceph: save cap_auths in MDS client when session is opened")
Signed-off-by: Luis Henriques (SUSE) <luis.henriques@linux.dev>
---
Changes since v1:
 * dropped mdsc->mutex locking as we don't need it at this point

 fs/ceph/mds_client.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
index 276e34ab3e2c..2e4b3ee7446c 100644
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -6015,6 +6015,18 @@ static void ceph_mdsc_stop(struct ceph_mds_client *mdsc)
 		ceph_mdsmap_destroy(mdsc->mdsmap);
 	kfree(mdsc->sessions);
 	ceph_caps_finalize(mdsc);
+
+	if (mdsc->s_cap_auths) {
+		int i;
+
+		for (i = 0; i < mdsc->s_cap_auths_num; i++) {
+			kfree(mdsc->s_cap_auths[i].match.gids);
+			kfree(mdsc->s_cap_auths[i].match.path);
+			kfree(mdsc->s_cap_auths[i].match.fs_name);
+		}
+		kfree(mdsc->s_cap_auths);
+	}
+
 	ceph_pool_perm_destroy(mdsc);
 }
 

