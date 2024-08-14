Return-Path: <ceph-devel+bounces-1660-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1960A95187C
	for <lists+ceph-devel@lfdr.de>; Wed, 14 Aug 2024 12:18:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id A5D7BB21DD1
	for <lists+ceph-devel@lfdr.de>; Wed, 14 Aug 2024 10:18:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9CF7D1AD9C0;
	Wed, 14 Aug 2024 10:18:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="bnB73+uC"
X-Original-To: ceph-devel@vger.kernel.org
Received: from out-171.mta0.migadu.com (out-171.mta0.migadu.com [91.218.175.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D214039879
	for <ceph-devel@vger.kernel.org>; Wed, 14 Aug 2024 10:18:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723630686; cv=none; b=ho2p9Gx1InpPyTDQi38EQ4Tt4jBGjrs/WRqZQHDZuwYkf4sm4IpWZOY5xhgY1CZLtOe5gr1RItqOPPhrVKl7WJa95msBA6SSPELZmqEncj9B0FRVqwhAX/C3Ay0jqCq7oH8yXqYEjZrphJIXMQ0HVU8TKZKv93XzyH5p8sPGv0A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723630686; c=relaxed/simple;
	bh=dO+V3Q4mP5ciW1bskPsfNP/iO06+JgIWP+/xapvpFuU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=UsxW8dDsBbxAxSmfVfwaqHDa5lpG62+2+/hGMl4cbOs4rDi5crudppJoiOzCgdeVT0zQnTYyPojBVdCCCWX5InClS2n9fbmErAi7pgsBEiQA5olehnJGd3FforHNGtk3OxsXLmAprIPpcxl2WUIdv0ojSHXEde24bPoEsLIG/dY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=bnB73+uC; arc=none smtp.client-ip=91.218.175.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1723630680;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=kvi/W8gOyyklHrp/rAIiYdjJk0RXfYfHnh/CvWe1Mpg=;
	b=bnB73+uC8YaUXiP1QvbZ43ueP4gSV5uMMrv5clNaQAlIngqwu2M8OeUJ2ehBq/Fa7/gGD5
	Ml1MK0ufFq/abZeihTeJ5pCiWf7dnyE826yZWpayw6uZlMQtuV7SyT1j8AjCWVu3B6B0Ts
	mXuzbn/PjnrWrLeL26XOll2n+HEodNM=
From: "Luis Henriques (SUSE)" <luis.henriques@linux.dev>
To: Xiubo Li <xiubli@redhat.com>,
	Ilya Dryomov <idryomov@gmail.com>,
	Milind Changire <mchangir@redhat.com>
Cc: ceph-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	"Luis Henriques (SUSE)" <luis.henriques@linux.dev>
Subject: [PATCH] ceph: fix memory in MDS client cap_auths
Date: Wed, 14 Aug 2024 11:17:50 +0100
Message-ID: <20240814101750.13293-1-luis.henriques@linux.dev>
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
 fs/ceph/mds_client.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
index 276e34ab3e2c..d798d0a5b2b1 100644
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -6015,6 +6015,20 @@ static void ceph_mdsc_stop(struct ceph_mds_client *mdsc)
 		ceph_mdsmap_destroy(mdsc->mdsmap);
 	kfree(mdsc->sessions);
 	ceph_caps_finalize(mdsc);
+
+	if (mdsc->s_cap_auths) {
+		int i;
+
+		mutex_lock(&mdsc->mutex);
+		for (i = 0; i < mdsc->s_cap_auths_num; i++) {
+			kfree(mdsc->s_cap_auths[i].match.gids);
+			kfree(mdsc->s_cap_auths[i].match.path);
+			kfree(mdsc->s_cap_auths[i].match.fs_name);
+		}
+		kfree(mdsc->s_cap_auths);
+		mutex_unlock(&mdsc->mutex);
+	}
+
 	ceph_pool_perm_destroy(mdsc);
 }
 

