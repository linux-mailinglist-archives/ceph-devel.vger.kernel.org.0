Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 351C71DAC96
	for <lists+ceph-devel@lfdr.de>; Wed, 20 May 2020 09:51:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726822AbgETHvn (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 20 May 2020 03:51:43 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:33907 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726403AbgETHvn (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 20 May 2020 03:51:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589961101;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc; bh=Sn0xouer+bwLkEpD9Vt2uqzAo7gaSTOXMaShLEFMd4E=;
        b=S7Ny0BmVGDCNDIFd55GQekOywVb7AeAeY1KjzvYTE8oeJbXi6tLabB2B9Z8bk/wG4GScme
        UZx3JEa233R8nBFNm3sGABtNS+5DvpKRlfdd1eR7qMmmKXsIrL3o9+qB7/DGSTmuTyeaaF
        QJwyachhfdvO6AokMrerD1GP6tAxcYE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-260-cDoCbwtPOfSt8TSLfQ42Jw-1; Wed, 20 May 2020 03:51:26 -0400
X-MC-Unique: cDoCbwtPOfSt8TSLfQ42Jw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id AE79F1800D42;
        Wed, 20 May 2020 07:51:25 +0000 (UTC)
Received: from lxbceph0.gsslab.pek2.redhat.com (vm36-245.gsslab.pek2.redhat.com [10.72.36.245])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8FB77600E3;
        Wed, 20 May 2020 07:51:23 +0000 (UTC)
From:   xiubli@redhat.com
To:     jlayton@kernel.org, idryomov@gmail.com, zyan@redhat.com
Cc:     pdonnell@redhat.com, ceph-devel@vger.kernel.org,
        Xiubo Li <xiubli@redhat.com>
Subject: [PATCH] ceph: make sure the mdsc->mutex is nested in s->s_mutex to fix dead lock
Date:   Wed, 20 May 2020 03:51:19 -0400
Message-Id: <1589961079-27932-1-git-send-email-xiubli@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: Xiubo Li <xiubli@redhat.com>

The call trace:

<6>[15981.740583] libceph: mon2 (1)10.72.36.245:40083 session lost, hunting for new mon
<3>[16097.960293] INFO: task kworker/18:1:32111 blocked for more than 122 seconds.
<3>[16097.960860]       Tainted: G            E     5.7.0-rc5+ #80
<3>[16097.961332] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
<6>[16097.961868] kworker/18:1    D    0 32111      2 0x80004080
<6>[16097.962151] Workqueue: ceph-msgr ceph_con_workfn [libceph]
<4>[16097.962188] Call Trace:
<4>[16097.962353]  ? __schedule+0x276/0x6e0
<4>[16097.962359]  ? schedule+0x40/0xb0
<4>[16097.962364]  ? schedule_preempt_disabled+0xa/0x10
<4>[16097.962368]  ? __mutex_lock.isra.8+0x2b5/0x4a0
<4>[16097.962460]  ? kick_requests+0x21/0x100 [ceph]
<4>[16097.962485]  ? ceph_mdsc_handle_mdsmap+0x19c/0x5f0 [ceph]
<4>[16097.962503]  ? extra_mon_dispatch+0x34/0x40 [ceph]
<4>[16097.962523]  ? extra_mon_dispatch+0x34/0x40 [ceph]
<4>[16097.962580]  ? dispatch+0x77/0x930 [libceph]
<4>[16097.962602]  ? try_read+0x78b/0x11e0 [libceph]
<4>[16097.962619]  ? __switch_to_asm+0x40/0x70
<4>[16097.962623]  ? __switch_to_asm+0x34/0x70
<4>[16097.962627]  ? __switch_to_asm+0x40/0x70
<4>[16097.962631]  ? __switch_to_asm+0x34/0x70
<4>[16097.962635]  ? __switch_to_asm+0x40/0x70
<4>[16097.962654]  ? ceph_con_workfn+0x130/0x5e0 [libceph]
<4>[16097.962713]  ? process_one_work+0x1ad/0x370
<4>[16097.962717]  ? worker_thread+0x30/0x390
<4>[16097.962722]  ? create_worker+0x1a0/0x1a0
<4>[16097.962737]  ? kthread+0x112/0x130
<4>[16097.962742]  ? kthread_park+0x80/0x80
<4>[16097.962747]  ? ret_from_fork+0x35/0x40
<3>[16097.962758] INFO: task kworker/25:1:1747 blocked for more than 122 seconds.
<3>[16097.963233]       Tainted: G            E     5.7.0-rc5+ #80
<3>[16097.963792] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
<6>[16097.964298] kworker/25:1    D    0  1747      2 0x80004080
<6>[16097.964325] Workqueue: ceph-msgr ceph_con_workfn [libceph]
<4>[16097.964331] Call Trace:
<4>[16097.964340]  ? __schedule+0x276/0x6e0
<4>[16097.964344]  ? schedule+0x40/0xb0
<4>[16097.964347]  ? schedule_preempt_disabled+0xa/0x10
<4>[16097.964351]  ? __mutex_lock.isra.8+0x2b5/0x4a0
<4>[16097.964376]  ? handle_reply+0x33f/0x6f0 [ceph]
<4>[16097.964407]  ? dispatch+0xa6/0xbc0 [ceph]
<4>[16097.964429]  ? read_partial_message+0x214/0x770 [libceph]
<4>[16097.964449]  ? try_read+0x78b/0x11e0 [libceph]
<4>[16097.964454]  ? __switch_to_asm+0x40/0x70
<4>[16097.964458]  ? __switch_to_asm+0x34/0x70
<4>[16097.964461]  ? __switch_to_asm+0x40/0x70
<4>[16097.964465]  ? __switch_to_asm+0x34/0x70
<4>[16097.964470]  ? __switch_to_asm+0x40/0x70
<4>[16097.964489]  ? ceph_con_workfn+0x130/0x5e0 [libceph]
<4>[16097.964494]  ? process_one_work+0x1ad/0x370
<4>[16097.964498]  ? worker_thread+0x30/0x390
<4>[16097.964501]  ? create_worker+0x1a0/0x1a0
<4>[16097.964506]  ? kthread+0x112/0x130
<4>[16097.964511]  ? kthread_park+0x80/0x80
<4>[16097.964516]  ? ret_from_fork+0x35/0x40

URL: https://tracker.ceph.com/issues/45609
Reported-by: "Yan, Zheng" <zyan@redhat.com>
Signed-off-by: Xiubo Li <xiubli@redhat.com>
---
 fs/ceph/mds_client.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
index 6c283c5..0e0ab01 100644
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -3769,8 +3769,6 @@ static int encode_snap_realms(struct ceph_mds_client *mdsc,
  * recovering MDS might have.
  *
  * This is a relatively heavyweight operation, but it's rare.
- *
- * called with mdsc->mutex held.
  */
 static void send_mds_reconnect(struct ceph_mds_client *mdsc,
 			       struct ceph_mds_session *session)
@@ -4024,7 +4022,9 @@ static void check_new_map(struct ceph_mds_client *mdsc,
 			    oldstate != CEPH_MDS_STATE_STARTING)
 				pr_info("mds%d recovery completed\n", s->s_mds);
 			kick_requests(mdsc, i);
+			mutex_unlock(&mdsc->mutex);
 			mutex_lock(&s->s_mutex);
+			mutex_lock(&mdsc->mutex);
 			ceph_kick_flushing_caps(mdsc, s);
 			mutex_unlock(&s->s_mutex);
 			wake_up_session_caps(s, RECONNECT);
-- 
1.8.3.1

