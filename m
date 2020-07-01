Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B026210376
	for <lists+ceph-devel@lfdr.de>; Wed,  1 Jul 2020 07:53:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726841AbgGAFxJ (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 1 Jul 2020 01:53:09 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:53128 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726039AbgGAFxJ (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 1 Jul 2020 01:53:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1593582787;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc; bh=d27+TM8HmaTgQtqW7AGEAbiSlyMlW2w9FeJdVJpJGl4=;
        b=A9D7RiPXEiyM9OZH466j0f+sW+dGK5IdANNlJ+lsJO9iflbeEnLaueccESf78kAzYWYHIA
        hyUgWOIcy6+ch1mZgALKf46TxX68+6MWSa3CZj7BSb3zsm7UOkFkru5fshz/0qvs2Etp/d
        upZ2C3szcKezNs1ckTUSFvcJyJG2dvE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-75-4O-ysPgBOMmwXPOIX28rwg-1; Wed, 01 Jul 2020 01:53:03 -0400
X-MC-Unique: 4O-ysPgBOMmwXPOIX28rwg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DD324804003;
        Wed,  1 Jul 2020 05:53:01 +0000 (UTC)
Received: from lxbceph0.gsslab.pek2.redhat.com (vm37-55.gsslab.pek2.redhat.com [10.72.37.55])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 067285DC1E;
        Wed,  1 Jul 2020 05:52:59 +0000 (UTC)
From:   xiubli@redhat.com
To:     jlayton@kernel.org
Cc:     idryomov@gmail.com, zyan@redhat.com, pdonnell@redhat.com,
        ceph-devel@vger.kernel.org, Xiubo Li <xiubli@redhat.com>
Subject: [PATCH 1/3] ceph: fix potential mdsc use-after-free crash
Date:   Wed,  1 Jul 2020 01:52:48 -0400
Message-Id: <1593582768-2954-1-git-send-email-xiubli@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: Xiubo Li <xiubli@redhat.com>

Make sure the delayed work stopped before releasing the resources.

Because the cancel_delayed_work_sync() will only guarantee that the
work finishes executing if the work is already in the ->worklist.
That means after the cancel_delayed_work_sync() returns and in case
if the work will re-arm itself, it will leave the work requeued. And
if we release the resources before the delayed work to run again we
will hit the use-after-free bug.

URL: https://tracker.ceph.com/issues/46293
Signed-off-by: Xiubo Li <xiubli@redhat.com>
---
 fs/ceph/mds_client.c | 14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
index d5e523c..9a09d12 100644
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -4330,6 +4330,9 @@ static void delayed_work(struct work_struct *work)
 
 	dout("mdsc delayed_work\n");
 
+	if (mdsc->stopping)
+		return;
+
 	mutex_lock(&mdsc->mutex);
 	renew_interval = mdsc->mdsmap->m_session_timeout >> 2;
 	renew_caps = time_after_eq(jiffies, HZ*renew_interval +
@@ -4689,7 +4692,16 @@ void ceph_mdsc_force_umount(struct ceph_mds_client *mdsc)
 static void ceph_mdsc_stop(struct ceph_mds_client *mdsc)
 {
 	dout("stop\n");
-	cancel_delayed_work_sync(&mdsc->delayed_work); /* cancel timer */
+	/*
+	 * Make sure the delayed work stopped before releasing
+	 * the resources.
+	 *
+	 * Because the cancel_delayed_work_sync() will only
+	 * guarantee that the work finishes executing. But the
+	 * delayed work will re-arm itself again after that.
+	 */
+	flush_delayed_work(&mdsc->delayed_work);
+
 	if (mdsc->mdsmap)
 		ceph_mdsmap_destroy(mdsc->mdsmap);
 	kfree(mdsc->sessions);
-- 
1.8.3.1

