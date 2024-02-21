Return-Path: <ceph-devel+bounces-893-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 81B6685D3B0
	for <lists+ceph-devel@lfdr.de>; Wed, 21 Feb 2024 10:33:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id ACBD31C20E6C
	for <lists+ceph-devel@lfdr.de>; Wed, 21 Feb 2024 09:33:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8A79D3D0DB;
	Wed, 21 Feb 2024 09:31:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="jTbH9xZ4"
X-Original-To: ceph-devel@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7A9B3CF7C
	for <ceph-devel@vger.kernel.org>; Wed, 21 Feb 2024 09:31:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708507912; cv=none; b=FZInGlvK7/Ds0cKrn55VLs8AM1kvYAeRlPwutKEeqqDdqI5ESDEZ9j2x6c9AlUgQWtRR4rLx0d7CcZIumxLxF3avM4P82EOr4dS1Pka5pfmM2l5opmiM01Mkx74GgfnV1bbkNiA30Iev2yulMNBe0Inq9kJPvv5TvffHZvqeja4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708507912; c=relaxed/simple;
	bh=Sk7OADt/GC5ZSh09AukTehOm5KyFvI3dhRXub929sg4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=HLuhRDE1jNmKdmI2jxGnUlS6f1M9UZZgti+Q587Xe/MxufOL9/kDNg1f26sgZEFmdvrrgSdjYrccRI/9XRondNIUbcRi39dMs9JTCIkNJnProTkn8fUsebbohzAKIWwZSKMEoYDoiPaBNs+NqK535SiHpLVfl9jE7O5BdpUnVdI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=jTbH9xZ4; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1708507909;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=j0DjlctYhTY4XSf/MpQKrTspHxwi6/fUJfJo1W7LjTA=;
	b=jTbH9xZ40Xj/PE2PgpY8n12HG1DqMl30vFXppcfNy1/oMFGVdIsUdlkJ4MUo0hQBiPssU6
	jPQJ1iJ2eM7EZV9Rx2LGmj3i7khvUPzgoTAtXn8VSLk6v8v45otpD0xXT3aMPzPy0a620V
	jQvbNPGeNkQnbgQrr3LOarduBvANJ44=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-263-eWh7V3cVMEKzo0AdmtJdSQ-1; Wed, 21 Feb 2024 04:31:47 -0500
X-MC-Unique: eWh7V3cVMEKzo0AdmtJdSQ-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7D00F885623;
	Wed, 21 Feb 2024 09:31:47 +0000 (UTC)
Received: from li-a71a4dcc-35d1-11b2-a85c-951838863c8d.ibm.com.com (unknown [10.72.112.141])
	by smtp.corp.redhat.com (Postfix) with ESMTP id B6410492BCA;
	Wed, 21 Feb 2024 09:31:41 +0000 (UTC)
From: xiubli@redhat.com
To: ceph-devel@vger.kernel.org
Cc: idryomov@gmail.com,
	jlayton@kernel.org,
	vshankar@redhat.com,
	mchangir@redhat.com,
	Xiubo Li <xiubli@redhat.com>,
	=?UTF-8?q?Frank=20Hsiao=20=E8=95=AD=E6=B3=95=E5=AE=A3?= <frankhsiao@qnap.com>
Subject: [PATCH] ceph: skip copying the data extends the file EOF
Date: Wed, 21 Feb 2024 17:29:25 +0800
Message-ID: <20240221092925.89408-1-xiubli@redhat.com>
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
---
 fs/ceph/file.c | 18 ++++++++----------
 1 file changed, 8 insertions(+), 10 deletions(-)

diff --git a/fs/ceph/file.c b/fs/ceph/file.c
index 71d29571712d..2b2b07a0a61b 100644
--- a/fs/ceph/file.c
+++ b/fs/ceph/file.c
@@ -1195,7 +1195,7 @@ ssize_t __ceph_sync_read(struct inode *inode, loff_t *ki_pos,
 		}
 
 		idx = 0;
-		left = ret > 0 ? ret : 0;
+		left = ret > 0 ? umin(ret, i_size) : 0;
 		while (left > 0) {
 			size_t plen, copied;
 
@@ -1224,15 +1224,13 @@ ssize_t __ceph_sync_read(struct inode *inode, loff_t *ki_pos,
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


