Return-Path: <ceph-devel+bounces-1890-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id B5713991BB7
	for <lists+ceph-devel@lfdr.de>; Sun,  6 Oct 2024 03:20:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C6F831C20DCD
	for <lists+ceph-devel@lfdr.de>; Sun,  6 Oct 2024 01:20:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1199B1E504;
	Sun,  6 Oct 2024 01:20:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=treblig.org header.i=@treblig.org header.b="ZvvWimPh"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mx.treblig.org (mx.treblig.org [46.235.229.95])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36EE3D53C;
	Sun,  6 Oct 2024 01:20:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.235.229.95
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728177603; cv=none; b=eXwkvKrv3a4sn+2nXo9ZxZfyZ+PXjsJNOo+/Nj5ewpXb1k2Xu5gfzzYoEypzFp0dTwfSQRlx0BMFpYefIUOMZsuDHmGNZKNUoI3eRd/wiCkr/RJUXsYBFhoqgR4W4+xOQjq0elzExZe50NUd1am4yaqATHgVhWIkrb2jZXhtIfM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728177603; c=relaxed/simple;
	bh=UDdkxw6HQ51u3bf5tDI5NuNzl8upRcwGmhPHjzjkBZ4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FYsgyHVluWiVlOzK9jJ09xkv/i5H3n5vvI7XNaLiT6y2VgP9LDPVLtJjUM4IOLgWyBt6XI07cezeKLznQF5a+PybdVXGC3u6dupRQT7ZvSyoZedQpkxba+PtREB2Yvb5iu+XkV1uN4C0n8tPGFyxVv7udK62+XxksnyTgQk3J2w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=treblig.org; spf=pass smtp.mailfrom=treblig.org; dkim=pass (2048-bit key) header.d=treblig.org header.i=@treblig.org header.b=ZvvWimPh; arc=none smtp.client-ip=46.235.229.95
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=treblig.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=treblig.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=treblig.org
	; s=bytemarkmx; h=MIME-Version:Message-ID:Date:Subject:From:Content-Type:From
	:Subject; bh=N+JA47qrmeJoilUAFUOqrc7+xRDDquESIIZMwmvis50=; b=ZvvWimPh0xVtjpnG
	qNnIOisxjzgRwsUs8Ba4sTXGYTMthYa4X4srT/oc2d/hQZM5Fyce97cwzkvbGijntXjAHH8jzDHts
	v+0Yh1HKhAoXkWfunKy345Dcm4Y4gN9mvDAESzk344R+YRMJCoTLNndpSzNVVu575xY5mzULuqt7o
	MnFbx/AR1szgxEcq0mlAPVDlTpj2rRq526rhNeuEz3GKRcbaYzPa+MLKhqQxAVg4s5XnyG4QoAQJA
	RsA03YFqOStg6vKAXT/tlMnj+UKJmtubLjABlcRuJhXzpXAhau0p6uqQEw6XqyICv8XlkFDEsAYoT
	C+olBSvvmkeSL/C43Q==;
Received: from localhost ([127.0.0.1] helo=dalek.home.treblig.org)
	by mx.treblig.org with esmtp (Exim 4.96)
	(envelope-from <linux@treblig.org>)
	id 1sxFwF-009DsK-1E;
	Sun, 06 Oct 2024 01:19:59 +0000
From: linux@treblig.org
To: xiubli@redhat.com,
	idryomov@gmail.com,
	ceph-devel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	"Dr. David Alan Gilbert" <linux@treblig.org>
Subject: [PATCH 3/5] libceph: Remove unused ceph_osdc_watch_check
Date: Sun,  6 Oct 2024 02:19:54 +0100
Message-ID: <20241006011956.373622-4-linux@treblig.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241006011956.373622-1-linux@treblig.org>
References: <20241006011956.373622-1-linux@treblig.org>
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: "Dr. David Alan Gilbert" <linux@treblig.org>

ceph_osdc_watch_check() has been unused since it was added in commit
b07d3c4bd727 ("libceph: support for checking on status of watch")

Remove it.

Signed-off-by: Dr. David Alan Gilbert <linux@treblig.org>
---
 include/linux/ceph/osd_client.h |  2 --
 net/ceph/osd_client.c           | 34 ---------------------------------
 2 files changed, 36 deletions(-)

diff --git a/include/linux/ceph/osd_client.h b/include/linux/ceph/osd_client.h
index d7941478158c..d55b30057a45 100644
--- a/include/linux/ceph/osd_client.h
+++ b/include/linux/ceph/osd_client.h
@@ -626,8 +626,6 @@ int ceph_osdc_notify(struct ceph_osd_client *osdc,
 		     u32 timeout,
 		     struct page ***preply_pages,
 		     size_t *preply_len);
-int ceph_osdc_watch_check(struct ceph_osd_client *osdc,
-			  struct ceph_osd_linger_request *lreq);
 int ceph_osdc_list_watchers(struct ceph_osd_client *osdc,
 			    struct ceph_object_id *oid,
 			    struct ceph_object_locator *oloc,
diff --git a/net/ceph/osd_client.c b/net/ceph/osd_client.c
index 9d078b37fe0b..9b1168eb77ab 100644
--- a/net/ceph/osd_client.c
+++ b/net/ceph/osd_client.c
@@ -4999,40 +4999,6 @@ int ceph_osdc_notify(struct ceph_osd_client *osdc,
 }
 EXPORT_SYMBOL(ceph_osdc_notify);
 
-/*
- * Return the number of milliseconds since the watch was last
- * confirmed, or an error.  If there is an error, the watch is no
- * longer valid, and should be destroyed with ceph_osdc_unwatch().
- */
-int ceph_osdc_watch_check(struct ceph_osd_client *osdc,
-			  struct ceph_osd_linger_request *lreq)
-{
-	unsigned long stamp, age;
-	int ret;
-
-	down_read(&osdc->lock);
-	mutex_lock(&lreq->lock);
-	stamp = lreq->watch_valid_thru;
-	if (!list_empty(&lreq->pending_lworks)) {
-		struct linger_work *lwork =
-		    list_first_entry(&lreq->pending_lworks,
-				     struct linger_work,
-				     pending_item);
-
-		if (time_before(lwork->queued_stamp, stamp))
-			stamp = lwork->queued_stamp;
-	}
-	age = jiffies - stamp;
-	dout("%s lreq %p linger_id %llu age %lu last_error %d\n", __func__,
-	     lreq, lreq->linger_id, age, lreq->last_error);
-	/* we are truncating to msecs, so return a safe upper bound */
-	ret = lreq->last_error ?: 1 + jiffies_to_msecs(age);
-
-	mutex_unlock(&lreq->lock);
-	up_read(&osdc->lock);
-	return ret;
-}
-
 static int decode_watcher(void **p, void *end, struct ceph_watch_item *item)
 {
 	u8 struct_v;
-- 
2.46.2


