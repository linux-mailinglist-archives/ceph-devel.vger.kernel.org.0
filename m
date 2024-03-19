Return-Path: <ceph-devel+bounces-980-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2AFFE87F49F
	for <lists+ceph-devel@lfdr.de>; Tue, 19 Mar 2024 01:32:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D4F44282E3C
	for <lists+ceph-devel@lfdr.de>; Tue, 19 Mar 2024 00:32:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C9AB3A40;
	Tue, 19 Mar 2024 00:32:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="PFZrJ5lT"
X-Original-To: ceph-devel@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDFDCA34
	for <ceph-devel@vger.kernel.org>; Tue, 19 Mar 2024 00:32:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710808345; cv=none; b=EuuN4oe4CoRl+b/bTZtgvDY64XGAagsNrvGWyov1vwI1r2MtR/T2H5QdRzIfAQQ6v7diKr4Y12XbBfd9H215RwJgaMf55zuSngtKPZkFLre84/QwSkbuy7QJLvGYq9Kv3C2cSl0so3ehpeasHmukMmUqj0UPoN3uK63sCKXaqS4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710808345; c=relaxed/simple;
	bh=eixFatOG9hxxMNaiiRSJ4UmHxbb0d09Km4z10CzPjgc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=h9TypRczMy5Fq5K3vhdNWtqGCwKy3aPYKxEHtt/5ldlS6bQ2WTZn+zce4OgPYU6URfQ05LZcySTVPIISCJJiHc5bdNPaRHQeBjIZW7tom4ciJyBFfRKDoASG1nHKktKR60DziHgHqV6fHaemQ5M269lTJ1aFCkH89HBMHpeaIvc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=PFZrJ5lT; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1710808342;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=MGFk2DXdMbeQg3XMZJB7jsv8X67Bj6zraEBOuK6oql8=;
	b=PFZrJ5lT/w0z9CCJkhZlUYADhcdLjL5L5Ee9HjL47k3rxciILNKIMau2QS2qqa1PndUHKQ
	jgBmLb5HLDfi/bluLv0q+kuF1h3fUlCjf2+ixPaWo/04yrGyzD/Edyq57Ec1VlRBJ3rjcx
	tKFFCH+W1Kbx1/5AfdLlLvbKMbWCMDk=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-144-zZummcDsN_CxDrVR0J7Iwg-1; Mon, 18 Mar 2024 20:32:19 -0400
X-MC-Unique: zZummcDsN_CxDrVR0J7Iwg-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 08F37185A789;
	Tue, 19 Mar 2024 00:32:19 +0000 (UTC)
Received: from li-a71a4dcc-35d1-11b2-a85c-951838863c8d.ibm.com.com (unknown [10.72.112.45])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 7AA5D492BC8;
	Tue, 19 Mar 2024 00:32:15 +0000 (UTC)
From: xiubli@redhat.com
To: ceph-devel@vger.kernel.org
Cc: idryomov@gmail.com,
	jlayton@kernel.org,
	vshankar@redhat.com,
	mchangir@redhat.com,
	frankhsiao@qnap.com,
	Xiubo Li <xiubli@redhat.com>
Subject: [PATCH v3 1/2] ceph: skip copying the data extends the file EOF
Date: Tue, 19 Mar 2024 08:29:24 +0800
Message-ID: <20240319002925.1228063-2-xiubli@redhat.com>
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

If hits the EOF it will revise the return value to the i_size
instead of the real length read, but it will advance the offset
of iovc, then for the next try it may be incorrectly skipped.

This will just skip advancing the iovc's offset more than i_size.

URL: https://patchwork.kernel.org/project/ceph-devel/list/?series=819323
Reported-by: Frank Hsiao 蕭法宣 <frankhsiao@qnap.com>
Signed-off-by: Xiubo Li <xiubli@redhat.com>
Tested-by: Frank Hsiao 蕭法宣 <frankhsiao@qnap.com>
---
 fs/ceph/file.c | 23 +++++++++++++----------
 1 file changed, 13 insertions(+), 10 deletions(-)

diff --git a/fs/ceph/file.c b/fs/ceph/file.c
index 24a003eaa5e0..c35878427985 100644
--- a/fs/ceph/file.c
+++ b/fs/ceph/file.c
@@ -1200,7 +1200,12 @@ ssize_t __ceph_sync_read(struct inode *inode, loff_t *ki_pos,
 		}
 
 		idx = 0;
-		left = ret > 0 ? ret : 0;
+		if (ret <= 0)
+			left = 0;
+		else if (off + ret > i_size)
+			left = i_size - off;
+		else
+			left = ret;
 		while (left > 0) {
 			size_t plen, copied;
 
@@ -1229,15 +1234,13 @@ ssize_t __ceph_sync_read(struct inode *inode, loff_t *ki_pos,
 	}
 
 	if (ret > 0) {
-		if (off > *ki_pos) {
-			if (off >= i_size) {
-				*retry_op = CHECK_EOF;
-				ret = i_size - *ki_pos;
-				*ki_pos = i_size;
-			} else {
-				ret = off - *ki_pos;
-				*ki_pos = off;
-			}
+		if (off >= i_size) {
+			*retry_op = CHECK_EOF;
+			ret = i_size - *ki_pos;
+			*ki_pos = i_size;
+		} else {
+			ret = off - *ki_pos;
+			*ki_pos = off;
 		}
 
 		if (last_objver)
-- 
2.43.0


