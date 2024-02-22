Return-Path: <ceph-devel+bounces-898-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 9AA0F85F983
	for <lists+ceph-devel@lfdr.de>; Thu, 22 Feb 2024 14:21:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 386BC1F220E3
	for <lists+ceph-devel@lfdr.de>; Thu, 22 Feb 2024 13:21:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3A2EF133298;
	Thu, 22 Feb 2024 13:21:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="hZWKkL45"
X-Original-To: ceph-devel@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 297D112F393
	for <ceph-devel@vger.kernel.org>; Thu, 22 Feb 2024 13:21:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708608080; cv=none; b=mZaAXVBHjGV/J00Wz1tVGwIYgCRiL2HnCHPVnXCS10WY5CUbO2rZF0Sbs1zPgS1AAnygGwKO9C97C4caath8kVEvtsfIuv2k/pMs0vOLWPU6JRUzBIvaU0XNv5oY+WQpd21jJLL+fRSJcqBflmn7eFgJYvlTUCtqiZeJdcCBY60=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708608080; c=relaxed/simple;
	bh=EZfPCs3uSfSQcZM6BQ6GsT0U8rqUbYDESBMbId3GIsc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=dCjHilxEbcq1gaBP8/kR+bLmJ8pq3uCyhlzdYXlf+txDih1LSU5nQwzEqsB47OXUq64zu5duTONy6YtQZuMGZDpajOIYhDCcofEa14XM3EKekiqdLvMSoKFbGptdOSXgZlnmvEO/NKYQlPepBBdZb2m5lgyiP7XiSpUrzklvEW4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=hZWKkL45; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1708608076;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=0W5uMywicfJJ54oTtYWVOfeAcckBg6lOCwgKKGkLYa8=;
	b=hZWKkL45GBnp+CXn8ppgwsfiqrNNciENvzBBnFd/Oae2lhos70ZCkv+VgD+ZJ05UkO/3gE
	TdfYFi3BPWY4+DIMqYfvD3tujFhjW0DtksYuhzi1L8dQsGXyN8U7SOAJsduhQNUC6crYmE
	CI4G20/2s9/uP7+cgPDJo8O4OOFeiJw=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-176-4F3KmrSAPTOHITGGQfs3kg-1; Thu, 22 Feb 2024 08:21:13 -0500
X-MC-Unique: 4F3KmrSAPTOHITGGQfs3kg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 764EC800074;
	Thu, 22 Feb 2024 13:21:13 +0000 (UTC)
Received: from li-a71a4dcc-35d1-11b2-a85c-951838863c8d.ibm.com.com (unknown [10.72.112.112])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 6905B1BDD1;
	Thu, 22 Feb 2024 13:21:10 +0000 (UTC)
From: xiubli@redhat.com
To: ceph-devel@vger.kernel.org
Cc: idryomov@gmail.com,
	jlayton@kernel.org,
	vshankar@redhat.com,
	mchangir@redhat.com,
	Xiubo Li <xiubli@redhat.com>,
	=?UTF-8?q?Frank=20Hsiao=20=E8=95=AD=E6=B3=95=E5=AE=A3?= <frankhsiao@qnap.com>
Subject: [PATCH v2 2/2] ceph: set the correct mask for getattr reqeust for read
Date: Thu, 22 Feb 2024 21:19:00 +0800
Message-ID: <20240222131900.179717-3-xiubli@redhat.com>
In-Reply-To: <20240222131900.179717-1-xiubli@redhat.com>
References: <20240222131900.179717-1-xiubli@redhat.com>
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.5

From: Xiubo Li <xiubli@redhat.com>

In case of hitting the file EOF the ceph_read_iter() needs to
retrieve the file size from MDS, and the Fr caps is not a neccessary.

URL: https://patchwork.kernel.org/project/ceph-devel/list/?series=819323
Reported-by: Frank Hsiao 蕭法宣 <frankhsiao@qnap.com>
Signed-off-by: Xiubo Li <xiubli@redhat.com>
---
 fs/ceph/file.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/fs/ceph/file.c b/fs/ceph/file.c
index 2b2b07a0a61b..08c918aa403e 100644
--- a/fs/ceph/file.c
+++ b/fs/ceph/file.c
@@ -2181,14 +2181,16 @@ static ssize_t ceph_read_iter(struct kiocb *iocb, struct iov_iter *to)
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
@@ -2229,7 +2231,7 @@ static ssize_t ceph_read_iter(struct kiocb *iocb, struct iov_iter *to)
 		/* hit EOF or hole? */
 		if (retry_op == CHECK_EOF && iocb->ki_pos < i_size &&
 		    ret < len) {
-			doutc(cl, "hit hole, ppos %lld < size %lld, reading more\n",
+			doutc(cl, "may hit hole, ppos %lld < size %lld, reading more\n",
 			      iocb->ki_pos, i_size);
 
 			read += ret;
-- 
2.43.0


