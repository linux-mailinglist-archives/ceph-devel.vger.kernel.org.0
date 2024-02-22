Return-Path: <ceph-devel+bounces-897-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id ACD6685F97F
	for <lists+ceph-devel@lfdr.de>; Thu, 22 Feb 2024 14:21:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 685F9286680
	for <lists+ceph-devel@lfdr.de>; Thu, 22 Feb 2024 13:21:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5579B12FF74;
	Thu, 22 Feb 2024 13:21:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="gA3eyYCJ"
X-Original-To: ceph-devel@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7520C133296
	for <ceph-devel@vger.kernel.org>; Thu, 22 Feb 2024 13:21:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708608076; cv=none; b=H0WaYpSNQ17VfBFF6ML/HJ+cnaQnd8/XH8MXothm/RCZyPWG1NuKuXIjsNGTb4qg9nnEvgaYEsnL1xrcXLrlbJVa9x9Wrhzr7aPbGhQAR6HDwqrTyRn9THTX13Q+e7kJP0mIqoBYV9QgW1SOQjLTECuw6NGQHWjMfySfAJPhnoM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708608076; c=relaxed/simple;
	bh=Sk7OADt/GC5ZSh09AukTehOm5KyFvI3dhRXub929sg4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qXD7tIxtQotT+a4ilKdp9gfgq6MQkPVCU+qpign5HR2/0TgSbEyIZX4mMpy8KKwW9S54gM0CoakEY0781qYn3P2VvyYVGm7iq7cJywWQtf6lHhjh8XCqcOdJe017TUe8mjhoDiYIj5X8hOavc+9zgkVvAqibnBZlXPKTMUdL8G0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=gA3eyYCJ; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1708608073;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=j0DjlctYhTY4XSf/MpQKrTspHxwi6/fUJfJo1W7LjTA=;
	b=gA3eyYCJr6hFngUj3osmZ0s+CW6pM3hX50DH+CuohS894xBcT2+nvpB7mBU1CQheFdmYva
	oYoZzL5bWFuPLrgfPNy9DF0moxd0yegtqK8KO2yqNVZJcqFfvxS83jMYotfApq54a9xgci
	2sUeZRtfZ4EqiBWX4mczXntu879p1HU=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-403-249EfvOpNnSQ-gZvkLjWBA-1; Thu,
 22 Feb 2024 08:21:10 -0500
X-MC-Unique: 249EfvOpNnSQ-gZvkLjWBA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id BB17A1C04187;
	Thu, 22 Feb 2024 13:21:09 +0000 (UTC)
Received: from li-a71a4dcc-35d1-11b2-a85c-951838863c8d.ibm.com.com (unknown [10.72.112.112])
	by smtp.corp.redhat.com (Postfix) with ESMTP id AF5718CED;
	Thu, 22 Feb 2024 13:21:06 +0000 (UTC)
From: xiubli@redhat.com
To: ceph-devel@vger.kernel.org
Cc: idryomov@gmail.com,
	jlayton@kernel.org,
	vshankar@redhat.com,
	mchangir@redhat.com,
	Xiubo Li <xiubli@redhat.com>,
	=?UTF-8?q?Frank=20Hsiao=20=E8=95=AD=E6=B3=95=E5=AE=A3?= <frankhsiao@qnap.com>
Subject: [PATCH v2 1/2] ceph: skip copying the data extends the file EOF
Date: Thu, 22 Feb 2024 21:18:59 +0800
Message-ID: <20240222131900.179717-2-xiubli@redhat.com>
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


