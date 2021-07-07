Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2EF973BECF5
	for <lists+ceph-devel@lfdr.de>; Wed,  7 Jul 2021 19:19:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230106AbhGGRWY (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 7 Jul 2021 13:22:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:42296 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230082AbhGGRWY (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Wed, 7 Jul 2021 13:22:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 52A7F61C93;
        Wed,  7 Jul 2021 17:19:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625678383;
        bh=y35S4/rHpdNzwA5tll3j0RuT3jZaM/a7R1nr6acYBAU=;
        h=From:To:Cc:Subject:Date:From;
        b=aoXHIUmiOMjtJ0pwbdNdDTTOg80ra9Zz1lkYT7BRFDmXAjxEYNHDyP0qdNns40nvK
         0xv67edVVC3w2eLAb8VpgOZIbodDwFcTVuDYaLVgQjjr5xOOspL3XaIz57ZXQPzi7t
         Jit7c3CHv+ow8aagennskWtUvWupYYb019ZmgC+gAq8gB4h+zLXoXMeCOY0qFsfEsy
         F5NVF5F3kjTzaqh4bK/pk5PF33ZjT7lH5PjWSNlvkgBfzeHyDFSlL/BInohG1x24I8
         Kh78jTQYo+Vi9qKKa54nPIgOeWeZrb5Ut5TDliregMdIsI/KdTldZjylAP0bQFotTV
         /0q5p4NA5rqZA==
From:   Jeff Layton <jlayton@kernel.org>
To:     ceph-devel@vger.kernel.org
Cc:     idryomov@gmail.com, Patrick Donnelly <pdonnell@redhat.com>
Subject: [PATCH] ceph: dump info about cap flushes when we're waiting too long for them
Date:   Wed,  7 Jul 2021 13:19:42 -0400
Message-Id: <20210707171942.38428-1-jlayton@kernel.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

We've had some cases of hung umounts in teuthology testing. It looks
like client is waiting for cap flushes to complete, but they aren't.

Change wait_caps_flush to wait 60s, and then dump info about the
condition of the list after that point.

Reported-by: Patrick Donnelly <pdonnell@redhat.com>
URL: https://tracker.ceph.com/issues/51279
Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/ceph/mds_client.c | 30 ++++++++++++++++++++++++++++--
 1 file changed, 28 insertions(+), 2 deletions(-)

I'm planning to drop this into the testing kernel to help us track down
the cause. I'm not sure if we'll want to keep it long term so I'll plan
to add a [DO NOT MERGE] tag when I do.

diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
index 7fc9432feece..b0fe5df7ef17 100644
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -2064,6 +2064,23 @@ static int check_caps_flush(struct ceph_mds_client *mdsc,
 	return ret;
 }
 
+static void dump_cap_flushes(struct ceph_mds_client *mdsc, u64 want_tid)
+{
+	int index = 0;
+	struct ceph_cap_flush *cf;
+
+	pr_info("%s: still waiting for cap flushes through %llu\n:\n",
+		__func__, want_tid);
+	spin_lock(&mdsc->cap_dirty_lock);
+	list_for_each_entry(cf, &mdsc->cap_flush_list, g_list) {
+		if (cf->tid > want_tid)
+			break;
+		pr_info("%d: %llu %s %d\n", index++, cf->tid,
+			ceph_cap_string(cf->caps), cf->wake);
+	}
+	spin_unlock(&mdsc->cap_dirty_lock);
+}
+
 /*
  * flush all dirty inode data to disk.
  *
@@ -2072,10 +2089,19 @@ static int check_caps_flush(struct ceph_mds_client *mdsc,
 static void wait_caps_flush(struct ceph_mds_client *mdsc,
 			    u64 want_flush_tid)
 {
+	long ret;
+
 	dout("check_caps_flush want %llu\n", want_flush_tid);
 
-	wait_event(mdsc->cap_flushing_wq,
-		   check_caps_flush(mdsc, want_flush_tid));
+	do {
+		ret = wait_event_timeout(mdsc->cap_flushing_wq,
+			   check_caps_flush(mdsc, want_flush_tid), 60 * HZ);
+		if (ret == 0)
+			dump_cap_flushes(mdsc, want_flush_tid);
+		else if (ret == 1)
+			pr_info("%s: condition evaluated to true after timeout!\n",
+				  __func__);
+	} while (ret == 0);
 
 	dout("check_caps_flush ok, flushed thru %llu\n", want_flush_tid);
 }
-- 
2.31.1

