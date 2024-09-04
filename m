Return-Path: <ceph-devel+bounces-1787-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0205196CA74
	for <lists+ceph-devel@lfdr.de>; Thu,  5 Sep 2024 00:30:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3554A1C224EE
	for <lists+ceph-devel@lfdr.de>; Wed,  4 Sep 2024 22:30:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A2D4415B56E;
	Wed,  4 Sep 2024 22:30:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Q51cqhWj"
X-Original-To: ceph-devel@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07E7215B0FF
	for <ceph-devel@vger.kernel.org>; Wed,  4 Sep 2024 22:30:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725489006; cv=none; b=ijSK20soRGA21kOKrrN1nC0PQihaYLLVHOzsJthVcah19jVwNi6UsF6sO1POhM4IvMMuaCFZuPL7tBlSw+SKBZOQYsTySw8ButIOvYSrnhdreiLyEsVZhmP70MT4ZTzFwHsycgI0rkiLx2MI49hJdZPva7p/n3L7MvbIkfl63lI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725489006; c=relaxed/simple;
	bh=5mFmEuWk1s7KjvrUh9V1P9Pytd1Z5tvRRPnoMxfIe48=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=JCllPZH59ZTPldjlcVb6jhR0a2T1AfohoXI/4EYjFJa5K2HQMZ5hyQ7IqbZ3DsjurbJgLjwBZQbZBwQGgskpOX/HZKCkQsWE++Fyqga4JorA8W4g6KmK9kabh9hMvOdjIKkBOpwAAQuFKFRqUn9cGoXLh/wevgsjjdMuVoMlPeQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Q51cqhWj; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1725489004;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=vacV9jI5IqY5bHcu2IexRKJ1d7tsZr4x/4sOj29hEyU=;
	b=Q51cqhWjALnfmdRorAdAdmqO2D0gK0TcrSLECwxQJD1HQatsHXsQGqlstsvIyEI8VPO3Sr
	sDpFoSqmh5niEDT3pYwwyV/nXcyBx1YTapfuol2RcnDUDyZlyes71jFjla3sRTwnnxT1YL
	hosQb7bNVllj8XwjmHrKvxDleMgcuWo=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-13-Ep68t4hPN1y4KeytYPKKxQ-1; Wed,
 04 Sep 2024 18:30:02 -0400
X-MC-Unique: Ep68t4hPN1y4KeytYPKKxQ-1
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 840251955F41;
	Wed,  4 Sep 2024 22:30:00 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.72.116.17])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 9DE641955F44;
	Wed,  4 Sep 2024 22:29:56 +0000 (UTC)
From: xiubli@redhat.com
To: ceph-devel@vger.kernel.org,
	idryomov@gmail.com
Cc: vshankar@redhat.com,
	gfarnum@redhat.com,
	pdonnell@redhat.com,
	Xiubo Li <xiubli@redhat.com>
Subject: [PATCH] ceph: remove the incorrect Fw reference check when dirtying pages
Date: Thu,  5 Sep 2024 06:29:52 +0800
Message-ID: <20240904222952.937201-1-xiubli@redhat.com>
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.40

From: Xiubo Li <xiubli@redhat.com>

When doing the direct-io reads it will also try to mark pages dirty,
but for the read path it won't hold the Fw caps and there is case
will it get the Fw reference.

Fixes: 5dda377cf0a6 ("ceph: set i_head_snapc when getting CEPH_CAP_FILE_WR reference")
Signed-off-by: Xiubo Li <xiubli@redhat.com>
---
 fs/ceph/addr.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
index c4744a02db75..0df4623785dd 100644
--- a/fs/ceph/addr.c
+++ b/fs/ceph/addr.c
@@ -95,7 +95,6 @@ static bool ceph_dirty_folio(struct address_space *mapping, struct folio *folio)
 
 	/* dirty the head */
 	spin_lock(&ci->i_ceph_lock);
-	BUG_ON(ci->i_wr_ref == 0); // caller should hold Fw reference
 	if (__ceph_have_pending_cap_snap(ci)) {
 		struct ceph_cap_snap *capsnap =
 				list_last_entry(&ci->i_cap_snaps,
-- 
2.45.1


