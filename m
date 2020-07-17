Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A3543223C67
	for <lists+ceph-devel@lfdr.de>; Fri, 17 Jul 2020 15:25:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726113AbgGQNZe (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 17 Jul 2020 09:25:34 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:24493 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726071AbgGQNZe (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Fri, 17 Jul 2020 09:25:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594992333;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=J5nHmQVvFPESRmc9bWUI8V4RaLpldNFl+iFNrb8g3ow=;
        b=KQ3WHMx+TXwR1ZjtZ+8RhooKxAEJ+2GaLwLj7VebnH025Xn9KKWBRreB6iSSAogQUN9YQ1
        cYnD5I2Rd4U+1YSuE3X7Sha8X3zKk6UXK/Y9tgtSV4xjVnxYXwy0FY9h7zCIVMMHQ41PkT
        Qpf3nRCB8fod53uDmz42LD9p3aQM5Rk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-301-MD0QBqUgMPmU3Agjg7veuw-1; Fri, 17 Jul 2020 09:25:29 -0400
X-MC-Unique: MD0QBqUgMPmU3Agjg7veuw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 43FA9107B7ED;
        Fri, 17 Jul 2020 13:25:28 +0000 (UTC)
Received: from lxbceph0.gsslab.pek2.redhat.com (vm37-55.gsslab.pek2.redhat.com [10.72.37.55])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 046BE72AC7;
        Fri, 17 Jul 2020 13:25:24 +0000 (UTC)
From:   xiubli@redhat.com
To:     jlayton@kernel.org
Cc:     idryomov@gmail.com, ceph-devel@vger.kernel.org, zyan@redhat.com,
        pdonnell@redhat.com, vshankar@redhat.com,
        Xiubo Li <xiubli@redhat.com>
Subject: [PATCH] ceph: check the sesion state and return false in case it is closed
Date:   Fri, 17 Jul 2020 09:25:13 -0400
Message-Id: <20200717132513.8845-1-xiubli@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: Xiubo Li <xiubli@redhat.com>

If the session is already in closed state, we should skip it.

Signed-off-by: Xiubo Li <xiubli@redhat.com>
---
 fs/ceph/mds_client.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
index 887874f8ad2c..2af773168a0a 100644
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -4302,6 +4302,7 @@ bool check_session_state(struct ceph_mds_session *s)
 	}
 	if (s->s_state == CEPH_MDS_SESSION_NEW ||
 	    s->s_state == CEPH_MDS_SESSION_RESTARTING ||
+	    s->s_state == CEPH_MDS_SESSION_CLOSED ||
 	    s->s_state == CEPH_MDS_SESSION_REJECTED)
 		/* this mds is failed or recovering, just wait */
 		return false;
-- 
2.27.0.221.ga08a83d.dirty

