Return-Path: <ceph-devel+bounces-1596-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id DF2D993FAE7
	for <lists+ceph-devel@lfdr.de>; Mon, 29 Jul 2024 18:26:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0F5C51C223FF
	for <lists+ceph-devel@lfdr.de>; Mon, 29 Jul 2024 16:26:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2463B186E29;
	Mon, 29 Jul 2024 16:22:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="OeoKpfne"
X-Original-To: ceph-devel@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F474186E2A
	for <ceph-devel@vger.kernel.org>; Mon, 29 Jul 2024 16:22:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722270126; cv=none; b=nthUGNYIQsqdkDa+z46N3w6WA+N5dbzTKbVF2DqhCUyohKsJR+5kpP0Q6kunT/aCZevslQbfpZLbIi9awZmNgrgildNjsNi9fVCudKLjLd2TVL5N2KBDIGOvQxna7fH1UoR/Ve80VaRRR0V1t0OTdxeagHz1ecXj3YPve+OX7uM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722270126; c=relaxed/simple;
	bh=N+ypu3jajSUyBIo4NVSFuoKGkkplCMyzOIZ87FbnL1I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ljIYNaDNzWaaCQXu1/snAnYeu07CZTW2wyGY+Ud7gKhg7EaHV4Wu1ICtvLPiYkJhoZ77ppzo+5m757WSflz3q+/DPZ7/zTNdlVbEs3+soW8NXDOdDVOzlblSLJR/RdVtSCjdwzCU0twx9Kumzir848kWXRKmNL+NUJLnsYoftjA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=OeoKpfne; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1722270124;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=v61GO21S8pTlp0s2AWk5G5oSQ+p84Fns5OqZB2t4B40=;
	b=OeoKpfneD/j+eMp3e4n+ZBBgDbQ7PmA/o0j+FaKcQ9UiqdnAKR2EukU8PAd1hBhr8oXsmh
	tqDz9OdSYbAUThjzKyJIFblA2fYxzS2oF1FV5vwaLgpfIuBvYGGzc/1Dr37IHoJDF4i920
	cjeIXp40KLWamhVxiqTz5OkJ+BzesY4=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-67-eZ-S57SQPJGwXvgPZFdtag-1; Mon,
 29 Jul 2024 12:21:58 -0400
X-MC-Unique: eZ-S57SQPJGwXvgPZFdtag-1
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id BF40C1955F3F;
	Mon, 29 Jul 2024 16:21:51 +0000 (UTC)
Received: from warthog.procyon.org.uk.com (unknown [10.42.28.216])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id AE8611955F68;
	Mon, 29 Jul 2024 16:21:45 +0000 (UTC)
From: David Howells <dhowells@redhat.com>
To: Christian Brauner <christian@brauner.io>,
	Steve French <smfrench@gmail.com>,
	Matthew Wilcox <willy@infradead.org>
Cc: David Howells <dhowells@redhat.com>,
	Jeff Layton <jlayton@kernel.org>,
	Gao Xiang <hsiangkao@linux.alibaba.com>,
	Dominique Martinet <asmadeus@codewreck.org>,
	Marc Dionne <marc.dionne@auristor.com>,
	Paulo Alcantara <pc@manguebit.com>,
	Shyam Prasad N <sprasad@microsoft.com>,
	Tom Talpey <tom@talpey.com>,
	Eric Van Hensbergen <ericvh@kernel.org>,
	Ilya Dryomov <idryomov@gmail.com>,
	netfs@lists.linux.dev,
	linux-afs@lists.infradead.org,
	linux-cifs@vger.kernel.org,
	linux-nfs@vger.kernel.org,
	ceph-devel@vger.kernel.org,
	v9fs@lists.linux.dev,
	linux-erofs@lists.ozlabs.org,
	linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Steve French <sfrench@samba.org>,
	Enzo Matsumiya <ematsumiya@suse.de>
Subject: [PATCH 13/24] cifs: Provide the capability to extract from ITER_FOLIOQ to RDMA SGEs
Date: Mon, 29 Jul 2024 17:19:42 +0100
Message-ID: <20240729162002.3436763-14-dhowells@redhat.com>
In-Reply-To: <20240729162002.3436763-1-dhowells@redhat.com>
References: <20240729162002.3436763-1-dhowells@redhat.com>
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

Make smb_extract_iter_to_rdma() extract page fragments from an ITER_FOLIOQ
iterator into RDMA SGEs.

Signed-off-by: David Howells <dhowells@redhat.com>
cc: Steve French <sfrench@samba.org>
cc: Paulo Alcantara <pc@manguebit.com>
cc: Tom Talpey <tom@talpey.com>
cc: Enzo Matsumiya <ematsumiya@suse.de>
cc: linux-cifs@vger.kernel.org
---
 fs/smb/client/smbdirect.c | 71 +++++++++++++++++++++++++++++++++++++--
 1 file changed, 68 insertions(+), 3 deletions(-)

diff --git a/fs/smb/client/smbdirect.c b/fs/smb/client/smbdirect.c
index d74e829de51c..52acead63d9d 100644
--- a/fs/smb/client/smbdirect.c
+++ b/fs/smb/client/smbdirect.c
@@ -6,6 +6,7 @@
  */
 #include <linux/module.h>
 #include <linux/highmem.h>
+#include <linux/folio_queue.h>
 #include "smbdirect.h"
 #include "cifs_debug.h"
 #include "cifsproto.h"
@@ -2463,6 +2464,8 @@ static ssize_t smb_extract_bvec_to_rdma(struct iov_iter *iter,
 		start = 0;
 	}
 
+	if (ret > 0)
+		iov_iter_advance(iter, ret);
 	return ret;
 }
 
@@ -2519,6 +2522,65 @@ static ssize_t smb_extract_kvec_to_rdma(struct iov_iter *iter,
 		start = 0;
 	}
 
+	if (ret > 0)
+		iov_iter_advance(iter, ret);
+	return ret;
+}
+
+/*
+ * Extract folio fragments from a FOLIOQ-class iterator and add them to an RDMA
+ * list.  The folios are not pinned.
+ */
+static ssize_t smb_extract_folioq_to_rdma(struct iov_iter *iter,
+					  struct smb_extract_to_rdma *rdma,
+					  ssize_t maxsize)
+{
+	const struct folio_queue *folioq = iter->folioq;
+	unsigned int slot = iter->folioq_slot;
+	ssize_t ret = 0;
+	size_t offset = iter->iov_offset;
+
+	BUG_ON(!folioq);
+
+	if (slot >= folioq_nr_slots(folioq)) {
+		folioq = folioq->next;
+		if (WARN_ON_ONCE(!folioq))
+			return -EIO;
+		slot = 0;
+	}
+
+	do {
+		struct folio *folio = folioq_folio(folioq, slot);
+		size_t fsize = folioq_folio_size(folioq, slot);
+
+		if (offset < fsize) {
+			size_t part = umin(maxsize - ret, fsize - offset);
+
+			if (!smb_set_sge(rdma, folio_page(folio, 0), offset, part))
+				return -EIO;
+
+			offset += part;
+			ret += part;
+		}
+
+		if (offset >= fsize) {
+			offset = 0;
+			slot++;
+			if (slot >= folioq_nr_slots(folioq)) {
+				if (!folioq->next) {
+					WARN_ON_ONCE(ret < iter->count);
+					break;
+				}
+				folioq = folioq->next;
+				slot = 0;
+			}
+		}
+	} while (rdma->nr_sge < rdma->max_sge || maxsize > 0);
+
+	iter->folioq = folioq;
+	iter->folioq_slot = slot;
+	iter->iov_offset = offset;
+	iter->count -= ret;
 	return ret;
 }
 
@@ -2563,6 +2625,8 @@ static ssize_t smb_extract_xarray_to_rdma(struct iov_iter *iter,
 	}
 
 	rcu_read_unlock();
+	if (ret > 0)
+		iov_iter_advance(iter, ret);
 	return ret;
 }
 
@@ -2590,6 +2654,9 @@ static ssize_t smb_extract_iter_to_rdma(struct iov_iter *iter, size_t len,
 	case ITER_KVEC:
 		ret = smb_extract_kvec_to_rdma(iter, rdma, len);
 		break;
+	case ITER_FOLIOQ:
+		ret = smb_extract_folioq_to_rdma(iter, rdma, len);
+		break;
 	case ITER_XARRAY:
 		ret = smb_extract_xarray_to_rdma(iter, rdma, len);
 		break;
@@ -2598,9 +2665,7 @@ static ssize_t smb_extract_iter_to_rdma(struct iov_iter *iter, size_t len,
 		return -EIO;
 	}
 
-	if (ret > 0) {
-		iov_iter_advance(iter, ret);
-	} else if (ret < 0) {
+	if (ret < 0) {
 		while (rdma->nr_sge > before) {
 			struct ib_sge *sge = &rdma->sge[rdma->nr_sge--];
 


