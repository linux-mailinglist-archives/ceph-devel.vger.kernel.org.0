Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E15A1D6D56
	for <lists+ceph-devel@lfdr.de>; Tue, 15 Oct 2019 04:53:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727316AbfJOCw7 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 14 Oct 2019 22:52:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:42266 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726430AbfJOCw6 (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Mon, 14 Oct 2019 22:52:58 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id CC1F310DCC8C;
        Tue, 15 Oct 2019 02:52:58 +0000 (UTC)
Received: from lxbfd30.lab.eng.blr.redhat.com (unknown [10.70.39.249])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8029060127;
        Tue, 15 Oct 2019 02:52:54 +0000 (UTC)
From:   xiubli@redhat.com
To:     idryomov@gmail.com, jlayton@kernel.org
Cc:     sage@redhat.com, ceph-devel@vger.kernel.org,
        Xiubo Li <xiubli@redhat.com>
Subject: [PATCH RFC] libceph: remove the useless monc check
Date:   Tue, 15 Oct 2019 08:22:42 +0530
Message-Id: <20191015025242.5729-1-xiubli@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.6.2 (mx1.redhat.com [10.5.110.64]); Tue, 15 Oct 2019 02:52:58 +0000 (UTC)
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: Xiubo Li <xiubli@redhat.com>

There is no reason that the con->private will be NULL for mon client,
once it is here in dispatch() routine the con->monc->private should
already correctly set done. And also just before the dispatch() in
try_read() it will also reference the con->monc->private to allocate
memory for in_msg.

Signed-off-by: Xiubo Li <xiubli@redhat.com>
---
 net/ceph/mon_client.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/net/ceph/mon_client.c b/net/ceph/mon_client.c
index 7256c402ebaa..9d9e4e4ea600 100644
--- a/net/ceph/mon_client.c
+++ b/net/ceph/mon_client.c
@@ -1233,9 +1233,6 @@ static void dispatch(struct ceph_connection *con, struct ceph_msg *msg)
 	struct ceph_mon_client *monc = con->private;
 	int type = le16_to_cpu(msg->hdr.type);
 
-	if (!monc)
-		return;
-
 	switch (type) {
 	case CEPH_MSG_AUTH_REPLY:
 		handle_auth_reply(monc, msg);
-- 
2.21.0

