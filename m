Return-Path: <ceph-devel+bounces-1140-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D95C28C4C97
	for <lists+ceph-devel@lfdr.de>; Tue, 14 May 2024 09:09:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 943DD2824C4
	for <lists+ceph-devel@lfdr.de>; Tue, 14 May 2024 07:09:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DE6EC101CA;
	Tue, 14 May 2024 07:09:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="fwlHLOZy"
X-Original-To: ceph-devel@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32008171C2
	for <ceph-devel@vger.kernel.org>; Tue, 14 May 2024 07:09:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715670552; cv=none; b=iI3MWh0R4kAzv24jPnesNZqtzMJxehND08xA8koqz+5IstCumOEQGlpuQtPEGB5SlpHgiot2eO+KhTCKciaqrI+W3qUNTLBV4Bw52bclfqcAnPyzb/5zLyK5FhN0ekR9jwZCBXdS1pWrOTGh5Cz9sOoSUiHnr0txHo0xsSdr5OE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715670552; c=relaxed/simple;
	bh=WpL+CR6AfvXYj0lRMNFI/29t7gTkRMlOdAPdRlncLlQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=SKgq5NEok2jf+dWSfjSNnhKeYZJpEKaeHLwk6eOGIT1bG4eYsnGEtDtCpuqWs0KiUgAx+TmWDbi4TAO3TkwXiNhH0X4nWT2+CvQ5nATjMlulOS/B7KYUDjDaasJS2JUj+SnEQSTg2l2xKSo/lF63DdIwlxw8v8JONkKyWHUuR3o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=fwlHLOZy; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1715670550;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=0ZIQbOFDMSm6n034QsJIWhtCrHouktEi7A5jDH8SbyE=;
	b=fwlHLOZySBaoiL4mZ0eEwM93f3HiS1F2TGzgGbkvTlnk+d4m1FqB9awDFisFG+qN68vMXH
	2KWrt0uYIXQNmcymAyY8CeMwP5yeXmF6rJbclTrB5f+9SEoOn6x/BoejSPVsg25sGzGhy0
	VHTS9jQmykDMeh+s1QadiFeCc6u2r1w=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-460-akb6LilRNl6pL1ZnJaFVBg-1; Tue, 14 May 2024 03:09:06 -0400
X-MC-Unique: akb6LilRNl6pL1ZnJaFVBg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 25C4C185A78E;
	Tue, 14 May 2024 07:09:06 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.72.116.29])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 5EB8340C6EB7;
	Tue, 14 May 2024 07:09:02 +0000 (UTC)
From: xiubli@redhat.com
To: ceph-devel@vger.kernel.org,
	idryomov@gmail.com
Cc: vshankar@redhat.com,
	mchangir@redhat.com,
	Xiubo Li <xiubli@redhat.com>
Subject: [PATCH] ceph: stop reconnecting to MDS after connection being closed
Date: Tue, 14 May 2024 15:08:56 +0800
Message-ID: <20240514070856.194701-1-xiubli@redhat.com>
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.2

From: Xiubo Li <xiubli@redhat.com>

The reconnect feature never been supported by MDS in mds non-RECONNECT
state. This reconnect requests will incorrectly close the just reopened
sessions when the MDS kills them during the "mds_session_blocklist_on_evict"
option is disabled.

Remove it for now.

Fixes: 7e70f0ed9f3e ("ceph: attempt mds reconnect if mds closes our session")
URL: https://tracker.ceph.com/issues/65647
Signed-off-by: Xiubo Li <xiubli@redhat.com>
---
 fs/ceph/mds_client.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
index f5b25d178118..97a126c54578 100644
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -6241,9 +6241,6 @@ static void mds_peer_reset(struct ceph_connection *con)
 
 	pr_warn_client(mdsc->fsc->client, "mds%d closed our session\n",
 		       s->s_mds);
-	if (READ_ONCE(mdsc->fsc->mount_state) != CEPH_MOUNT_FENCE_IO &&
-	    ceph_mdsmap_get_state(mdsc->mdsmap, s->s_mds) >= CEPH_MDS_STATE_RECONNECT)
-		send_mds_reconnect(mdsc, s);
 }
 
 static void mds_dispatch(struct ceph_connection *con, struct ceph_msg *msg)
-- 
2.44.0


