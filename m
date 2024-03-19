Return-Path: <ceph-devel+bounces-981-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1C83587F4A0
	for <lists+ceph-devel@lfdr.de>; Tue, 19 Mar 2024 01:32:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CC04F282E08
	for <lists+ceph-devel@lfdr.de>; Tue, 19 Mar 2024 00:32:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A9C77257D;
	Tue, 19 Mar 2024 00:32:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="duoiTs2h"
X-Original-To: ceph-devel@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDD1C1C3E
	for <ceph-devel@vger.kernel.org>; Tue, 19 Mar 2024 00:32:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710808348; cv=none; b=ExpUXuGwt/WzHyXTM7MF5JLIIWfrOdgb/tT6Nl77xmmSiXmBNcHnbEwvoXaZHythRuGqUFr8vp0TFf8IqjPuD99VvcrJzRr0tVKfuUlhWRrpMGyDvpkksqUQBZ91VDV5b2La9s+bbSRsU9poh7xlgTX2pdVlobM8r2lDj59BSQw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710808348; c=relaxed/simple;
	bh=+ozlqxGhnhUJ1STxwXtWx/sVKL+KQbmbdFEEZc4PEt0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=gWv3hb+KFT48p2Iaa9RTzTHToLIerbbWCD9dR9iqWwfuN/939Oa0wic6p9UcNIibBFNUpQpObwVgnnJkse1YVdBEzdC+NT5TI6F2f9TOj2NyrL6EFhnZyrWBvlrgPwS6Gl8km/BLOKMcDfMZ36CdjrbnBt63L228uTpEOCXe6E0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=duoiTs2h; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1710808346;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9AlHctE9hUf91KsACfc49Cjs2K+t5QwQ3PaHe1QAgoA=;
	b=duoiTs2hcC4IyntiQx0tWqPdkx9c7HGWVAXULWGBqGH/ev6oB7EfxRiRQ0aK6HyhxeS6Tv
	6/eb7xdef/He1hDyO0QCagtFXK4HIDOs0NQ6iIcgxqSL+OFmeEbhJQwoU8DOGKd1A3u2Uo
	1jHClZerN/Htlzqw5G+8b9puYpUux6g=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-505-ve75TuTCMkW13vqKH-0Ytw-1; Mon, 18 Mar 2024 20:32:23 -0400
X-MC-Unique: ve75TuTCMkW13vqKH-0Ytw-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 18BA3101A552;
	Tue, 19 Mar 2024 00:32:23 +0000 (UTC)
Received: from li-a71a4dcc-35d1-11b2-a85c-951838863c8d.ibm.com.com (unknown [10.72.112.45])
	by smtp.corp.redhat.com (Postfix) with ESMTP id AB8E1492BDC;
	Tue, 19 Mar 2024 00:32:19 +0000 (UTC)
From: xiubli@redhat.com
To: ceph-devel@vger.kernel.org
Cc: idryomov@gmail.com,
	jlayton@kernel.org,
	vshankar@redhat.com,
	mchangir@redhat.com,
	frankhsiao@qnap.com,
	Xiubo Li <xiubli@redhat.com>
Subject: [PATCH v3 2/2] ceph: set the correct mask for getattr reqeust for read
Date: Tue, 19 Mar 2024 08:29:25 +0800
Message-ID: <20240319002925.1228063-3-xiubli@redhat.com>
In-Reply-To: <20240319002925.1228063-1-xiubli@redhat.com>
References: <20240319002925.1228063-1-xiubli@redhat.com>
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.9

From: Xiubo Li <xiubli@redhat.com>

In case of hitting the file EOF the ceph_read_iter() needs to
retrieve the file size from MDS, and the Fr caps is not a neccessary.

URL: https://patchwork.kernel.org/project/ceph-devel/list/?series=819323
Reported-by: Frank Hsiao 蕭法宣 <frankhsiao@qnap.com>
Signed-off-by: Xiubo Li <xiubli@redhat.com>
Tested-by: Frank Hsiao 蕭法宣 <frankhsiao@qnap.com>
---
 fs/ceph/file.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/fs/ceph/file.c b/fs/ceph/file.c
index c35878427985..a85f95c941fc 100644
--- a/fs/ceph/file.c
+++ b/fs/ceph/file.c
@@ -2191,14 +2191,16 @@ static ssize_t ceph_read_iter(struct kiocb *iocb, struct iov_iter *to)
 		int statret;
 		struct page *page = NULL;
 		loff_t i_size;
+		int mask = CEPH_STAT_CAP_SIZE;
 		if (retry_op == READ_INLINE) {
 			page = __page_cache_alloc(GFP_KERNEL);
 			if (!page)
 				return -ENOMEM;
 		}
 
-		statret = __ceph_do_getattr(inode, page,
-					    CEPH_STAT_CAP_INLINE_DATA, !!page);
+		if (retry_op == READ_INLINE)
+			mask = CEPH_STAT_CAP_INLINE_DATA;
+		statret = __ceph_do_getattr(inode, page, mask, !!page);
 		if (statret < 0) {
 			if (page)
 				__free_page(page);
@@ -2239,7 +2241,7 @@ static ssize_t ceph_read_iter(struct kiocb *iocb, struct iov_iter *to)
 		/* hit EOF or hole? */
 		if (retry_op == CHECK_EOF && iocb->ki_pos < i_size &&
 		    ret < len) {
-			doutc(cl, "hit hole, ppos %lld < size %lld, reading more\n",
+			doutc(cl, "may hit hole, ppos %lld < size %lld, reading more\n",
 			      iocb->ki_pos, i_size);
 
 			read += ret;
-- 
2.43.0


