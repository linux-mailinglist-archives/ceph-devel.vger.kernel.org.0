Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39FCB3EFEA5
	for <lists+ceph-devel@lfdr.de>; Wed, 18 Aug 2021 10:06:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239275AbhHRIGu (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 18 Aug 2021 04:06:50 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:55937 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238550AbhHRIGu (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Wed, 18 Aug 2021 04:06:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1629273975;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=V3RflNDLpVwgbW2+Fb6ZwEOjyzotHVmDP7rb4Fsr+D0=;
        b=VOuI7Xeu5taS1bEXf3qSJsnUWCuJtbqenHAUQFf4eI2W745qa1W+Jgqkl4L3gS6x0gx7YX
        Jnkxr1ebiF2tTcFlp/IUy0I76NZ8rWBgcAbZyBUWvI9TdiclpEa1DPAhj9G8YHh2LlGVmX
        hwaQccEnZdYrmdmyATWT7cM19kRgEIY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-543-6M99ZYAaMyadPS_xomuhhg-1; Wed, 18 Aug 2021 04:06:14 -0400
X-MC-Unique: 6M99ZYAaMyadPS_xomuhhg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 185168015C7;
        Wed, 18 Aug 2021 08:06:13 +0000 (UTC)
Received: from lxbceph1.gsslab.pek2.redhat.com (unknown [10.72.47.117])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 23C605C25A;
        Wed, 18 Aug 2021 08:06:10 +0000 (UTC)
From:   xiubli@redhat.com
To:     jlayton@kernel.org
Cc:     idryomov@gmail.com, pdonnell@redhat.com,
        ceph-devel@vger.kernel.org, Xiubo Li <xiubli@redhat.com>
Subject: [PATCH 2/3] ceph: don't WARN if we're force umounting
Date:   Wed, 18 Aug 2021 16:06:02 +0800
Message-Id: <20210818080603.195722-3-xiubli@redhat.com>
In-Reply-To: <20210818080603.195722-1-xiubli@redhat.com>
References: <20210818080603.195722-1-xiubli@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: Xiubo Li <xiubli@redhat.com>

Force umount will try to close the sessions by setting the session
state to _CLOSING, so in ceph_kill_sb after that it will warn on it.

URL: https://tracker.ceph.com/issues/52295
Signed-off-by: Xiubo Li <xiubli@redhat.com>
---
 fs/ceph/mds_client.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
index a632e1c7cef2..0302af53e079 100644
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -4558,6 +4558,8 @@ static void maybe_recover_session(struct ceph_mds_client *mdsc)
 
 bool check_session_state(struct ceph_mds_session *s)
 {
+	struct ceph_fs_client *fsc = s->s_mdsc->fsc;
+
 	switch (s->s_state) {
 	case CEPH_MDS_SESSION_OPEN:
 		if (s->s_ttl && time_after(jiffies, s->s_ttl)) {
@@ -4566,8 +4568,11 @@ bool check_session_state(struct ceph_mds_session *s)
 		}
 		break;
 	case CEPH_MDS_SESSION_CLOSING:
-		/* Should never reach this when we're unmounting */
-		WARN_ON_ONCE(s->s_ttl);
+		/*
+		 * Should never reach this when none force unmounting
+		 */
+		if (READ_ONCE(fsc->mount_state) != CEPH_MOUNT_SHUTDOWN)
+			WARN_ON_ONCE(s->s_ttl);
 		fallthrough;
 	case CEPH_MDS_SESSION_NEW:
 	case CEPH_MDS_SESSION_RESTARTING:
-- 
2.27.0

