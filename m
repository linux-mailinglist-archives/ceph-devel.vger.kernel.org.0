Return-Path: <ceph-devel+bounces-2755-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 55503A404BC
	for <lists+ceph-devel@lfdr.de>; Sat, 22 Feb 2025 02:35:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 516FF7A9F07
	for <lists+ceph-devel@lfdr.de>; Sat, 22 Feb 2025 01:34:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7E02D3BBD8;
	Sat, 22 Feb 2025 01:35:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=treblig.org header.i=@treblig.org header.b="G91BkJTC"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mx.treblig.org (mx.treblig.org [46.235.229.95])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F286C2F37;
	Sat, 22 Feb 2025 01:35:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.235.229.95
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740188136; cv=none; b=IxVlSVO7xzQpcA/EPjMEpEq8XWuiNAADi3LuaKt2uZa4+no4YnL/nJHzTPkB8jSmvwjn6AnpTW55YylpmRnHENXXG0HffBpV6A23L92NWhyDE2TQjBQ+LgUaPxLPOiUC3jxRip9+eRmdEd6SlTsti3Sl0tK7ZCIp88ZoGQ3KOnQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740188136; c=relaxed/simple;
	bh=+Y3nR6KOk00kptJvAX3izRRNzFgAnL/1ZVJtiELgKNU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=mOfjlB0N6tmY89/EV2hAiD8tEkaKMA04RTH0U+WRr6bT6iMYiG2dxqZGcdylcCwbCFsgCLJuRT4dw3dUGgbyeCytes/l2TiEVQzHaUav94eOLOxS1RYzj/dNCJ0nYdeGMOtfA1OmIMYeR4SlWzdfrHgNrVIjr1bm5r0qQuK77wQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=treblig.org; spf=pass smtp.mailfrom=treblig.org; dkim=pass (2048-bit key) header.d=treblig.org header.i=@treblig.org header.b=G91BkJTC; arc=none smtp.client-ip=46.235.229.95
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=treblig.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=treblig.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=treblig.org
	; s=bytemarkmx; h=MIME-Version:Message-ID:Date:Subject:From:Content-Type:From
	:Subject; bh=TAfZdMkdNZxHnDf3cV6Uyw2GXMut+94aHZJKX1tLc7U=; b=G91BkJTCPOJ6lmK/
	oeoXr+HM/sJcbSY/ddaN+1K4BRMeePhxg5IaVn1BGrK22mb6uFc/9yTziGynodNcFab8FOGezgHTk
	XZnvDxPbMUkbG6gkHuVm4m1IJtrBT+eJrMkuM5lkL5XI8SaHdEHoBByh0XHdpqjrMeL2DeUxqXF7V
	k2ZT18EtxQO/sS0bU/eQcCF5Lg+0Y4GbIYs6wbwheEaHp0DtAfLMGelSXF8H9J1CorQB1vQnZopEW
	r0eb7urqZLAW6CvEtepnFttY96QtVWyFfIq8r+7hxt1xp4ppFrfmCJi4fjqqRi8YycsVypBs4rQbA
	7OoO7TZcSXGWMVebIw==;
Received: from localhost ([127.0.0.1] helo=dalek.home.treblig.org)
	by mx.treblig.org with esmtp (Exim 4.96)
	(envelope-from <linux@treblig.org>)
	id 1tleQU-0001zj-2b;
	Sat, 22 Feb 2025 01:35:30 +0000
From: linux@treblig.org
To: idryomov@gmail.com,
	xiubli@redhat.com,
	ceph-devel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	"Dr. David Alan Gilbert" <linux@treblig.org>
Subject: [PATCH] ceph: osd_client deadcode
Date: Sat, 22 Feb 2025 01:35:30 +0000
Message-ID: <20250222013530.171376-1-linux@treblig.org>
X-Mailer: git-send-email 2.48.1
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: "Dr. David Alan Gilbert" <linux@treblig.org>

osd_req_op_extent_osd_data_pagelist() was added in 2013 as part of
commit a4ce40a9a7c1 ("libceph: combine initializing and setting osd data")
but never used.

The last use of osd_req_op_cls_request_data_pagelist() was removed in
2017's
commit ecd4a68a26a2 ("rbd: switch rbd_obj_method_sync() to
ceph_osdc_call()")

Remove them.

Signed-off-by: Dr. David Alan Gilbert <linux@treblig.org>
---
 include/linux/ceph/osd_client.h |  6 ------
 net/ceph/osd_client.c           | 23 -----------------------
 2 files changed, 29 deletions(-)

diff --git a/include/linux/ceph/osd_client.h b/include/linux/ceph/osd_client.h
index d55b30057a45..50b14a5661c7 100644
--- a/include/linux/ceph/osd_client.h
+++ b/include/linux/ceph/osd_client.h
@@ -490,9 +490,6 @@ extern void osd_req_op_extent_osd_data_pages(struct ceph_osd_request *,
 					struct page **pages, u64 length,
 					u32 alignment, bool pages_from_pool,
 					bool own_pages);
-extern void osd_req_op_extent_osd_data_pagelist(struct ceph_osd_request *,
-					unsigned int which,
-					struct ceph_pagelist *pagelist);
 #ifdef CONFIG_BLOCK
 void osd_req_op_extent_osd_data_bio(struct ceph_osd_request *osd_req,
 				    unsigned int which,
@@ -509,9 +506,6 @@ void osd_req_op_extent_osd_data_bvec_pos(struct ceph_osd_request *osd_req,
 void osd_req_op_extent_osd_iter(struct ceph_osd_request *osd_req,
 				unsigned int which, struct iov_iter *iter);
 
-extern void osd_req_op_cls_request_data_pagelist(struct ceph_osd_request *,
-					unsigned int which,
-					struct ceph_pagelist *pagelist);
 extern void osd_req_op_cls_request_data_pages(struct ceph_osd_request *,
 					unsigned int which,
 					struct page **pages, u64 length,
diff --git a/net/ceph/osd_client.c b/net/ceph/osd_client.c
index b24afec24138..6664ea73ccf8 100644
--- a/net/ceph/osd_client.c
+++ b/net/ceph/osd_client.c
@@ -220,16 +220,6 @@ void osd_req_op_extent_osd_data_pages(struct ceph_osd_request *osd_req,
 }
 EXPORT_SYMBOL(osd_req_op_extent_osd_data_pages);
 
-void osd_req_op_extent_osd_data_pagelist(struct ceph_osd_request *osd_req,
-			unsigned int which, struct ceph_pagelist *pagelist)
-{
-	struct ceph_osd_data *osd_data;
-
-	osd_data = osd_req_op_data(osd_req, which, extent, osd_data);
-	ceph_osd_data_pagelist_init(osd_data, pagelist);
-}
-EXPORT_SYMBOL(osd_req_op_extent_osd_data_pagelist);
-
 #ifdef CONFIG_BLOCK
 void osd_req_op_extent_osd_data_bio(struct ceph_osd_request *osd_req,
 				    unsigned int which,
@@ -297,19 +287,6 @@ static void osd_req_op_cls_request_info_pagelist(
 	ceph_osd_data_pagelist_init(osd_data, pagelist);
 }
 
-void osd_req_op_cls_request_data_pagelist(
-			struct ceph_osd_request *osd_req,
-			unsigned int which, struct ceph_pagelist *pagelist)
-{
-	struct ceph_osd_data *osd_data;
-
-	osd_data = osd_req_op_data(osd_req, which, cls, request_data);
-	ceph_osd_data_pagelist_init(osd_data, pagelist);
-	osd_req->r_ops[which].cls.indata_len += pagelist->length;
-	osd_req->r_ops[which].indata_len += pagelist->length;
-}
-EXPORT_SYMBOL(osd_req_op_cls_request_data_pagelist);
-
 void osd_req_op_cls_request_data_pages(struct ceph_osd_request *osd_req,
 			unsigned int which, struct page **pages, u64 length,
 			u32 alignment, bool pages_from_pool, bool own_pages)
-- 
2.48.1


