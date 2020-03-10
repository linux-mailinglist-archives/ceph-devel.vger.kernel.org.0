Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1544B17F2C7
	for <lists+ceph-devel@lfdr.de>; Tue, 10 Mar 2020 10:09:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726268AbgCJJJi (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 10 Mar 2020 05:09:38 -0400
Received: from mx2.suse.de ([195.135.220.15]:34376 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726195AbgCJJJi (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Tue, 10 Mar 2020 05:09:38 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id B7605AE79;
        Tue, 10 Mar 2020 09:09:36 +0000 (UTC)
From:   Roman Penyaev <rpenyaev@suse.de>
Cc:     Roman Penyaev <rpenyaev@suse.de>,
        Ilya Dryomov <idryomov@gmail.com>,
        Jeff Layton <jlayton@kernel.org>, Sage Weil <sage@redhat.com>,
        ceph-devel@vger.kernel.org
Subject: [PATCH 1/1] libceph: fix memory leak for messages allocated with CEPH_MSG_DATA_PAGES
Date:   Tue, 10 Mar 2020 10:09:24 +0100
Message-Id: <20200310090924.49788-1-rpenyaev@suse.de>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To:     unlisted-recipients:; (no To-header on input)
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

OSD client allocates a message with a page vector for OSD_MAP, OSD_BACKOFF
and WATCH_NOTIFY message types (see alloc_msg_with_page_vector() caller),
but pages vector release is never called.

Signed-off-by: Roman Penyaev <rpenyaev@suse.de>
Cc: Ilya Dryomov <idryomov@gmail.com>
Cc: Jeff Layton <jlayton@kernel.org>
Cc: Sage Weil <sage@redhat.com>
Cc: ceph-devel@vger.kernel.org
---
 net/ceph/messenger.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/net/ceph/messenger.c b/net/ceph/messenger.c
index 5b4bd8261002..28cbd55ec2e3 100644
--- a/net/ceph/messenger.c
+++ b/net/ceph/messenger.c
@@ -3248,8 +3248,15 @@ static struct ceph_msg_data *ceph_msg_data_add(struct ceph_msg *msg)
 
 static void ceph_msg_data_destroy(struct ceph_msg_data *data)
 {
-	if (data->type == CEPH_MSG_DATA_PAGELIST)
+	if (data->type == CEPH_MSG_DATA_PAGES) {
+		int num_pages;
+
+		num_pages = calc_pages_for(data->alignment,
+					   data->length);
+		ceph_release_page_vector(data->pages, num_pages);
+	} else if (data->type == CEPH_MSG_DATA_PAGELIST) {
 		ceph_pagelist_release(data->pagelist);
+	}
 }
 
 void ceph_msg_data_add_pages(struct ceph_msg *msg, struct page **pages,
-- 
2.24.1

