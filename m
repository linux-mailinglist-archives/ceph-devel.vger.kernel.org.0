Return-Path: <ceph-devel+bounces-1513-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 01DD392D188
	for <lists+ceph-devel@lfdr.de>; Wed, 10 Jul 2024 14:27:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8C9F428581B
	for <lists+ceph-devel@lfdr.de>; Wed, 10 Jul 2024 12:27:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 44F2519046D;
	Wed, 10 Jul 2024 12:27:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="X8xSf07I"
X-Original-To: ceph-devel@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D122848E
	for <ceph-devel@vger.kernel.org>; Wed, 10 Jul 2024 12:27:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720614447; cv=none; b=OQx+ZlmHDPdpzcWQqbkYPSUPYw+MYYmPFt4wPyaamud/vagIXLHY0kvxHIvuVawuL9bhGig7vc/7BzsTdQkukCqoEzn4vZx0NWVXwhp/y1yCAdR4fIp9RP95wucfmqLuHH2ikUDe5KjX1LGnE7RIABBuc2AIVeGgzksrNNA/+o4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720614447; c=relaxed/simple;
	bh=3vUMdEEWAN4Rp1ZhdcZstKBrOV5MatVgcRaJch4jrsc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=t46fdiNX/7sBFMRrfUy3NIF21xSBgd2d47LwAGX0ivS1ID2kgKDvi9DrNGMrXRnZzwMEH23TwJpOZ95ktwLjOgouwyFT+j6QlVWe6Fz/E5T/ppkUnAWhJeOWkf5fLkNmdMTqk+QfOsaPK7r4OhCHcZCFh8QSNfQQa6jU6OMprjA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=X8xSf07I; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1720614445;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=qWYsjQxr7PHOx6b8bVbBc58Ii9azthjC8ICRvA97tFo=;
	b=X8xSf07IP0Ve8wXHPN2IsBhdOI7ZBYHtaHk2//3n7xlniFB39C56nlYQ/r7xwuFa6xiz6s
	6S80KHlySaMBGvydbHsH9ToOTEL64NnqEHfFrsxzt3jhCjlytM0w3Wjvbax+3+R0+c33FC
	kzGaFtmQZcxJ6mqSdBT6Hfiga+sLGCI=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-680-tmaFNHTWMjmeM31lYX_TuA-1; Wed,
 10 Jul 2024 08:27:23 -0400
X-MC-Unique: tmaFNHTWMjmeM31lYX_TuA-1
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 9022A1956064;
	Wed, 10 Jul 2024 12:27:22 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.72.116.145])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id BC5E51955F68;
	Wed, 10 Jul 2024 12:27:19 +0000 (UTC)
From: xiubli@redhat.com
To: ceph-devel@vger.kernel.org
Cc: jlayton@kernel.org,
	vshankar@redhat.com,
	Xiubo Li <xiubli@redhat.com>
Subject: [PATCH] ceph: periodically flush the cap releases
Date: Wed, 10 Jul 2024 20:27:08 +0800
Message-ID: <20240710122708.900897-1-xiubli@redhat.com>
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

From: Xiubo Li <xiubli@redhat.com>

The MDS could be waiting the caps releases infinitely in some corner
case and then reporting the caps revoke stuck warning. To fix this
we should periodically flush the cap releases.

URL: https://tracker.ceph.com/issues/57244
Signed-off-by: Xiubo Li <xiubli@redhat.com>
---
 fs/ceph/mds_client.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
index c750ebcad972..b7fcaa6e28b4 100644
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -5474,6 +5474,8 @@ static void delayed_work(struct work_struct *work)
 		}
 		mutex_unlock(&mdsc->mutex);
 
+		ceph_flush_cap_releases(mdsc, s);
+
 		mutex_lock(&s->s_mutex);
 		if (renew_caps)
 			send_renew_caps(mdsc, s);
-- 
2.43.0


