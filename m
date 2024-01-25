Return-Path: <ceph-devel+bounces-660-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 0FA6783B744
	for <lists+ceph-devel@lfdr.de>; Thu, 25 Jan 2024 03:42:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id A3EEBB22E29
	for <lists+ceph-devel@lfdr.de>; Thu, 25 Jan 2024 02:42:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 045406AB9;
	Thu, 25 Jan 2024 02:41:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Q0Tdwr0Z"
X-Original-To: ceph-devel@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66AC263AC
	for <ceph-devel@vger.kernel.org>; Thu, 25 Jan 2024 02:41:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706150515; cv=none; b=o/ZaaQKbbncz55Yq1WCHsg+80ggD+oBoiLQWwhMYVAyWdbrT/SA0pI7RhCIuUQgCCFwNgl+Ej1C/stZPYrqeSiISCt2eS8WKCu0T42edSpH2KRs87kaIC42RfPrNtDI/kElXQniXz0R6t3srsRkeAMYFR9n5GR+Xi4NCOnxJAng=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706150515; c=relaxed/simple;
	bh=IHYsgSOWnz3AqF1oHglM6/zKtBA+WuJ53ti9VXMbn84=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=joT4RkdmnkNpEEuk+4FLXsNG/6olZ812OIGdwSn/dFMRMbd4VmqLP9T2J6q8nWfW4Cn4UJfs/NLxc1suSrDoo8DSk4D7iC7bZdy8byXiM3LwxvOrOMzdMz/EzY819NQOZaRcbek6xRNr7giAbFmOojc5JuAFQBYJg/ambZ0pc8Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Q0Tdwr0Z; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1706150510;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=NtrCBwqyiF9ekzdXGiCcwRLv0pw+n45ALzZ7u7xYJFI=;
	b=Q0Tdwr0ZeCfXIDfJAV/yegUF47LMvPS7z/5xN6swh+a1AK65NdBUkcTGqk01XGQ4tThIlE
	vfsVbgrItRWYJVPQNCH/+KD0RXBUK9DTNYhhCKEsF1UUYaUi7MAj03/KU2pRAHsdLU7bRu
	4kjMehR11s6MzIRw3IpHa83iFWEryY0=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-363-IyWrXqBrO_eCwgivqTPzqQ-1; Wed,
 24 Jan 2024 21:41:47 -0500
X-MC-Unique: IyWrXqBrO_eCwgivqTPzqQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id F0803380627C;
	Thu, 25 Jan 2024 02:41:46 +0000 (UTC)
Received: from li-a71a4dcc-35d1-11b2-a85c-951838863c8d.ibm.com.com (unknown [10.72.112.211])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 1A3222166B33;
	Thu, 25 Jan 2024 02:41:43 +0000 (UTC)
From: xiubli@redhat.com
To: ceph-devel@vger.kernel.org
Cc: idryomov@gmail.com,
	jlayton@kernel.org,
	vshankar@redhat.com,
	mchangir@redhat.com,
	Xiubo Li <xiubli@redhat.com>
Subject: [PATCH v6 1/3] libceph: fail the sparse-read if the data length doesn't match
Date: Thu, 25 Jan 2024 10:39:18 +0800
Message-ID: <20240125023920.1287555-2-xiubli@redhat.com>
In-Reply-To: <20240125023920.1287555-1-xiubli@redhat.com>
References: <20240125023920.1287555-1-xiubli@redhat.com>
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.6

From: Xiubo Li <xiubli@redhat.com>

Once this happens that means there have bugs.

URL: https://tracker.ceph.com/issues/63586
Signed-off-by: Xiubo Li <xiubli@redhat.com>
Reviewed-by: Jeff Layton <jlayton@kernel.org>
---
 net/ceph/osd_client.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/net/ceph/osd_client.c b/net/ceph/osd_client.c
index 9be80d01c1dc..837b69541376 100644
--- a/net/ceph/osd_client.c
+++ b/net/ceph/osd_client.c
@@ -5857,8 +5857,8 @@ static int osd_sparse_read(struct ceph_connection *con,
 	struct ceph_osd *o = con->private;
 	struct ceph_sparse_read *sr = &o->o_sparse_read;
 	u32 count = sr->sr_count;
-	u64 eoff, elen;
-	int ret;
+	u64 eoff, elen, len = 0;
+	int i, ret;
 
 	switch (sr->sr_state) {
 	case CEPH_SPARSE_READ_HDR:
@@ -5909,6 +5909,13 @@ static int osd_sparse_read(struct ceph_connection *con,
 		/* Convert sr_datalen to host-endian */
 		sr->sr_datalen = le32_to_cpu((__force __le32)sr->sr_datalen);
 		sr->sr_state = CEPH_SPARSE_READ_DATA;
+		for (i = 0; i < count; i++)
+			len += sr->sr_extent[i].len;
+		if (sr->sr_datalen != len) {
+			pr_warn_ratelimited("data len %u != extent len %llu\n",
+					    sr->sr_datalen, len);
+			return -EREMOTEIO;
+		}
 		fallthrough;
 	case CEPH_SPARSE_READ_DATA:
 		if (sr->sr_index >= count) {
-- 
2.43.0


