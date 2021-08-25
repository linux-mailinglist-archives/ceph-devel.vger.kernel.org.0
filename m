Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C48333F6EB7
	for <lists+ceph-devel@lfdr.de>; Wed, 25 Aug 2021 07:14:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231802AbhHYFO4 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 25 Aug 2021 01:14:56 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:53731 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231669AbhHYFOz (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Wed, 25 Aug 2021 01:14:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1629868450;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=AeyphV/O4f8lbq1YETsZPEj+kz2sgNvejkT3Jw3AD/M=;
        b=Qp0qE1RdBIz9GsyzJKYtiKfOMXeDfjugobiKIteyVQnh4riz/A0LuzvYMAO1uHztBfifQV
        nMw94SLlORyFntl98GW8pv2dNZpuby+0b5NXd3YZSAXwTf9WDiJCnBgGIOBgBn/diLXDas
        Txj0rDEXTv896wik9yJkx9Vlbd3FMjs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-555-5oIBz9gBO-GxoTP5Df5kmw-1; Wed, 25 Aug 2021 01:14:06 -0400
X-MC-Unique: 5oIBz9gBO-GxoTP5Df5kmw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 005E11835AC7;
        Wed, 25 Aug 2021 05:14:05 +0000 (UTC)
Received: from lxbceph1.gsslab.pek2.redhat.com (unknown [10.72.47.117])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C886618649;
        Wed, 25 Aug 2021 05:14:02 +0000 (UTC)
From:   xiubli@redhat.com
To:     jlayton@kernel.org
Cc:     idryomov@gmail.com, ukernel@gmail.com, pdonnell@redhat.com,
        ceph-devel@vger.kernel.org, Xiubo Li <xiubli@redhat.com>
Subject: [PATCH v2 2/3] ceph: don't WARN if we're force umounting
Date:   Wed, 25 Aug 2021 13:13:54 +0800
Message-Id: <20210825051355.5820-3-xiubli@redhat.com>
In-Reply-To: <20210825051355.5820-1-xiubli@redhat.com>
References: <20210825051355.5820-1-xiubli@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
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
index df10f9b33660..5831c7e137ee 100644
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -4560,6 +4560,8 @@ static void maybe_recover_session(struct ceph_mds_client *mdsc)
 
 bool check_session_state(struct ceph_mds_session *s)
 {
+	struct ceph_fs_client *fsc = s->s_mdsc->fsc;
+
 	switch (s->s_state) {
 	case CEPH_MDS_SESSION_OPEN:
 		if (s->s_ttl && time_after(jiffies, s->s_ttl)) {
@@ -4568,8 +4570,9 @@ bool check_session_state(struct ceph_mds_session *s)
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

