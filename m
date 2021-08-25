Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1FF573F7640
	for <lists+ceph-devel@lfdr.de>; Wed, 25 Aug 2021 15:46:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240397AbhHYNrB (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 25 Aug 2021 09:47:01 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:47204 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240171AbhHYNrA (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Wed, 25 Aug 2021 09:47:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1629899174;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=yAHx0psNWmaU3SNwmw8/H/1vkWxkwVorpR0qC1Lp4uE=;
        b=NzX4H7D/e39vE0lSvJfeik6Wn50qBtIRz6zEmXFzupWafPtgFPwVNST+/bOwGG2GMzmACv
        Qi7fkCh/s6A2ShiCAsldQrUj0sAzr6QEIcL8TVNx+2rftSc6M39etnANIyCQFzd6gSx6Lg
        5P5sCANDxaKbxObNHZNJdFpycrolx6Y=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-175-3n6BkIufM6OpCAzAAxmTlg-1; Wed, 25 Aug 2021 09:46:12 -0400
X-MC-Unique: 3n6BkIufM6OpCAzAAxmTlg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B7697CC626;
        Wed, 25 Aug 2021 13:46:11 +0000 (UTC)
Received: from lxbceph1.gsslab.pek2.redhat.com (unknown [10.72.47.117])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8D86F1970F;
        Wed, 25 Aug 2021 13:46:09 +0000 (UTC)
From:   xiubli@redhat.com
To:     jlayton@kernel.org
Cc:     idryomov@gmail.com, ukernel@gmail.com, pdonnell@redhat.com,
        ceph-devel@vger.kernel.org, Xiubo Li <xiubli@redhat.com>
Subject: [PATCH v3 2/3] ceph: don't WARN if we're force umounting
Date:   Wed, 25 Aug 2021 21:45:44 +0800
Message-Id: <20210825134545.117521-3-xiubli@redhat.com>
In-Reply-To: <20210825134545.117521-1-xiubli@redhat.com>
References: <20210825134545.117521-1-xiubli@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: Xiubo Li <xiubli@redhat.com>

Force umount will try to close the sessions by setting the session
state to _CLOSING, so in ceph_kill_sb after that it will warn on it.

URL: https://tracker.ceph.com/issues/52295
Signed-off-by: Xiubo Li <xiubli@redhat.com>
---
 fs/ceph/mds_client.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
index 36ad0ebb2295..8758a27e691c 100644
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -4566,6 +4566,8 @@ static void maybe_recover_session(struct ceph_mds_client *mdsc)
 
 bool check_session_state(struct ceph_mds_session *s)
 {
+	struct ceph_fs_client *fsc = s->s_mdsc->fsc;
+
 	switch (s->s_state) {
 	case CEPH_MDS_SESSION_OPEN:
 		if (s->s_ttl && time_after(jiffies, s->s_ttl)) {
@@ -4574,8 +4576,9 @@ bool check_session_state(struct ceph_mds_session *s)
 		}
 		break;
 	case CEPH_MDS_SESSION_CLOSING:
-		/* Should never reach this when we're unmounting */
-		WARN_ON_ONCE(s->s_ttl);
+		/* Should never reach this when none force unmounting */
+		WARN_ON_ONCE(s->s_ttl &&
+			     READ_ONCE(fsc->mount_state) != CEPH_MOUNT_SHUTDOWN);
 		fallthrough;
 	case CEPH_MDS_SESSION_NEW:
 	case CEPH_MDS_SESSION_RESTARTING:
-- 
2.27.0

