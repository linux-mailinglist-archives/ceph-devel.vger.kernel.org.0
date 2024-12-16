Return-Path: <ceph-devel+bounces-2371-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id D0DAF9F3BEB
	for <lists+ceph-devel@lfdr.de>; Mon, 16 Dec 2024 22:00:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 24C3418887F8
	for <lists+ceph-devel@lfdr.de>; Mon, 16 Dec 2024 20:58:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6BF951D5ADB;
	Mon, 16 Dec 2024 20:44:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="UvDzA9nt"
X-Original-To: ceph-devel@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD0841DB951
	for <ceph-devel@vger.kernel.org>; Mon, 16 Dec 2024 20:44:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734381894; cv=none; b=lBfTjz7MHsfogFpYJ2ZyyA81vkaVxDnQUngShZxzLQZr34GAV/KMOa8DBTY8VpSo2aoa+7vGH7//4HP9tiF7MGzcR8B8PG4DHo0WkIK/UHsCk5gEk5n41RlgIxxxILZtyhq3lGUiTSuZJlDY5YMu4c3bgq5bUwp8bYOGy1SHaf8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734381894; c=relaxed/simple;
	bh=G9M2CdZd1/Iidbx/IRLia6b1QNESxaYg31j0RUGTiJM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F6Uorz7rw8dqA8igXbfioeBtgtUbkGnidmbrkZNtiuF64ivlYcv3XbPoQI5rY4tMxUWKeR43zvC7E4GBPY1kmPpFbe6GkAsRcDLxjUKMxsVF9qyr8OUTf2Ky/YOn1ghhzobgPBP0uNBy3B8MTtQhn36mhnTy/kusCNUNgVqIhEQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=UvDzA9nt; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1734381891;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=OD7OFhROQKelkcByNJaNSCbQEDK9VQdKlLwzfBYpReY=;
	b=UvDzA9ntHMCtwMYmvdTk/0mZs1iOaLNfMAy7f+iaNOYz3l8b9e35SrmEZf/Jg57wDvRq2m
	uF23y+CB5M8OeGJBX7HC6mPYYvCoSPU8ES2Dd9Xs67A63BKbjb8yY6gmz61w/onUCoEp7s
	/6Kpu41ChoO5p9tFPE8O8XRU774Jtc0=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-652-f8sLclnoMPWiiWVwG3_7qA-1; Mon,
 16 Dec 2024 15:44:48 -0500
X-MC-Unique: f8sLclnoMPWiiWVwG3_7qA-1
X-Mimecast-MFC-AGG-ID: f8sLclnoMPWiiWVwG3_7qA
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id C0E1719560A1;
	Mon, 16 Dec 2024 20:44:45 +0000 (UTC)
Received: from warthog.procyon.org.com (unknown [10.42.28.48])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 3908430044C1;
	Mon, 16 Dec 2024 20:44:40 +0000 (UTC)
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
	linux-kernel@vger.kernel.org
Subject: [PATCH v5 26/32] Display waited-on page index after 1min of waiting
Date: Mon, 16 Dec 2024 20:41:16 +0000
Message-ID: <20241216204124.3752367-27-dhowells@redhat.com>
In-Reply-To: <20241216204124.3752367-1-dhowells@redhat.com>
References: <20241216204124.3752367-1-dhowells@redhat.com>
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

---
 mm/filemap.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/mm/filemap.c b/mm/filemap.c
index f61cf51c2238..1b6ab9915bc8 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -1236,6 +1236,8 @@ static inline int folio_wait_bit_common(struct folio *folio, int bit_nr,
 	bool thrashing = false;
 	unsigned long pflags;
 	bool in_thrashing;
+	pgoff_t index = folio->index;
+	long timeout = 60 * HZ;
 
 	if (bit_nr == PG_locked &&
 	    !folio_test_uptodate(folio) && folio_test_workingset(folio)) {
@@ -1305,7 +1307,14 @@ static inline int folio_wait_bit_common(struct folio *folio, int bit_nr,
 			if (signal_pending_state(state, current))
 				break;
 
-			io_schedule();
+			if (timeout > 0) {
+				timeout = io_schedule_timeout(timeout);
+				if (timeout <= 0)
+					pr_warn("folio wait took too long (ix=%lx)\n",
+						index);
+			} else {
+				io_schedule();
+			}
 			continue;
 		}
 


