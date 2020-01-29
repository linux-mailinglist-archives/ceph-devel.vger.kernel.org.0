Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7EFE614C77A
	for <lists+ceph-devel@lfdr.de>; Wed, 29 Jan 2020 09:28:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726251AbgA2I2A (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 29 Jan 2020 03:28:00 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:57188 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726246AbgA2I17 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Wed, 29 Jan 2020 03:27:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580286479;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2eHit3CkVZuOqMCE8IObfEo3PPjXAINOXoY0VUMqcQE=;
        b=PwN8JD5U0bBG8jxWAx4IN6dx/9UW5Lq5hfRO9qfdhxdMUpambIij6JXcCyL/W96pPSlol7
        /ajK65E7h++xeqHxqrkjt+E6/wub+0xn5eQxp5tT7v4Eh3v6VVRvvObm+/xTxTUQJvONeH
        MD9cCZmJ9O9vf2ChR7FY/ZZfPtU0A5o=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-353-U39aXxhzMt6IHFG9Z4Zeaw-1; Wed, 29 Jan 2020 03:27:56 -0500
X-MC-Unique: U39aXxhzMt6IHFG9Z4Zeaw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A1CFFDB60;
        Wed, 29 Jan 2020 08:27:55 +0000 (UTC)
Received: from localhost.localdomain (ovpn-12-34.pek2.redhat.com [10.72.12.34])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C0EBA5C548;
        Wed, 29 Jan 2020 08:27:50 +0000 (UTC)
From:   xiubli@redhat.com
To:     jlayton@kernel.org, idryomov@gmail.com, zyan@redhat.com
Cc:     sage@redhat.com, pdonnell@redhat.com, ceph-devel@vger.kernel.org,
        Xiubo Li <xiubli@redhat.com>
Subject: [PATCH resend v5 04/11] ceph: add r_end_stamp for the osdc request
Date:   Wed, 29 Jan 2020 03:27:08 -0500
Message-Id: <20200129082715.5285-5-xiubli@redhat.com>
In-Reply-To: <20200129082715.5285-1-xiubli@redhat.com>
References: <20200129082715.5285-1-xiubli@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Content-Transfer-Encoding: quoted-printable
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: Xiubo Li <xiubli@redhat.com>

Grab the osdc requests' end time stamp.

Signed-off-by: Xiubo Li <xiubli@redhat.com>
---
 include/linux/ceph/osd_client.h | 1 +
 net/ceph/osd_client.c           | 2 ++
 2 files changed, 3 insertions(+)

diff --git a/include/linux/ceph/osd_client.h b/include/linux/ceph/osd_cli=
ent.h
index 9d9f745b98a1..00a449cfc478 100644
--- a/include/linux/ceph/osd_client.h
+++ b/include/linux/ceph/osd_client.h
@@ -213,6 +213,7 @@ struct ceph_osd_request {
 	/* internal */
 	unsigned long r_stamp;                /* jiffies, send or check time */
 	unsigned long r_start_stamp;          /* jiffies */
+	unsigned long r_end_stamp;          /* jiffies */
 	int r_attempts;
 	u32 r_map_dne_bound;
=20
diff --git a/net/ceph/osd_client.c b/net/ceph/osd_client.c
index 8ff2856e2d52..108c9457d629 100644
--- a/net/ceph/osd_client.c
+++ b/net/ceph/osd_client.c
@@ -2389,6 +2389,8 @@ static void finish_request(struct ceph_osd_request =
*req)
 	WARN_ON(lookup_request_mc(&osdc->map_checks, req->r_tid));
 	dout("%s req %p tid %llu\n", __func__, req, req->r_tid);
=20
+	req->r_end_stamp =3D jiffies;
+
 	if (req->r_osd)
 		unlink_request(req->r_osd, req);
 	atomic_dec(&osdc->num_requests);
--=20
2.21.0

