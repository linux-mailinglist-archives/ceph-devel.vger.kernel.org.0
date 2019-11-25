Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 55E191090E6
	for <lists+ceph-devel@lfdr.de>; Mon, 25 Nov 2019 16:17:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728496AbfKYPRf (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 25 Nov 2019 10:17:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:44960 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728172AbfKYPRe (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Mon, 25 Nov 2019 10:17:34 -0500
Received: from tleilax.poochiereds.net (68-20-15-154.lightspeed.rlghnc.sbcglobal.net [68.20.15.154])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9184E20740;
        Mon, 25 Nov 2019 15:17:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574695054;
        bh=zYdbRlAIEyZT1f0cAHYiooDi5kgIJDCEwU2Bx7r1UlY=;
        h=From:To:Cc:Subject:Date:From;
        b=AZD4fSLcQfAaS7vIqVRic4CbHwC2Cpt6N49fE3BJ82AgU+CFld+h/9gUwwnwt5B36
         iIrB8V5+V9jw05MxibZOu+7Ioys/r4r1w9IBqFSgGWRazE94aRsa0vFVGHcBo6vP8e
         g52sgmPIv6vLMn2ostfMPtmfd42LCRvD8PPr78wA=
From:   Jeff Layton <jlayton@kernel.org>
To:     ceph-devel@vger.kernel.org
Cc:     pdonnell@redhat.com, idryomov@gmail.com, sage@redhat.com
Subject: [PATCH] ceph: show tasks waiting on caps in debugfs caps file
Date:   Mon, 25 Nov 2019 10:17:32 -0500
Message-Id: <20191125151732.139754-1-jlayton@kernel.org>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Display the tgid of the waiting task, plus inode number, and the
caps we need and want.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/ceph/caps.c       | 17 +++++++++++++++++
 fs/ceph/debugfs.c    | 13 +++++++++++++
 fs/ceph/mds_client.c |  1 +
 fs/ceph/mds_client.h |  9 +++++++++
 4 files changed, 40 insertions(+)

diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
index f5a38910a82b..271d8283d263 100644
--- a/fs/ceph/caps.c
+++ b/fs/ceph/caps.c
@@ -2764,7 +2764,19 @@ int ceph_get_caps(struct file *filp, int need, int want,
 		if (ret == -EAGAIN)
 			continue;
 		if (!ret) {
+			struct ceph_mds_client *mdsc = fsc->mdsc;
+			struct cap_wait cw;
 			DEFINE_WAIT_FUNC(wait, woken_wake_function);
+
+			cw.ino = inode->i_ino;
+			cw.tgid = current->tgid;
+			cw.need = need;
+			cw.want = want;
+
+			spin_lock(&mdsc->caps_list_lock);
+			list_add(&cw.list, &mdsc->cap_wait_list);
+			spin_unlock(&mdsc->caps_list_lock);
+
 			add_wait_queue(&ci->i_cap_wq, &wait);
 
 			flags |= NON_BLOCKING;
@@ -2778,6 +2790,11 @@ int ceph_get_caps(struct file *filp, int need, int want,
 			}
 
 			remove_wait_queue(&ci->i_cap_wq, &wait);
+
+			spin_lock(&mdsc->caps_list_lock);
+			list_del(&cw.list);
+			spin_unlock(&mdsc->caps_list_lock);
+
 			if (ret == -EAGAIN)
 				continue;
 		}
diff --git a/fs/ceph/debugfs.c b/fs/ceph/debugfs.c
index facb387c2735..c281f32b54f7 100644
--- a/fs/ceph/debugfs.c
+++ b/fs/ceph/debugfs.c
@@ -139,6 +139,7 @@ static int caps_show(struct seq_file *s, void *p)
 	struct ceph_fs_client *fsc = s->private;
 	struct ceph_mds_client *mdsc = fsc->mdsc;
 	int total, avail, used, reserved, min, i;
+	struct cap_wait	*cw;
 
 	ceph_reservation_status(fsc, &total, &avail, &used, &reserved, &min);
 	seq_printf(s, "total\t\t%d\n"
@@ -166,6 +167,18 @@ static int caps_show(struct seq_file *s, void *p)
 	}
 	mutex_unlock(&mdsc->mutex);
 
+	seq_printf(s, "\n\nWaiters:\n--------\n");
+	seq_printf(s, "tgid         ino                need             want\n");
+	seq_printf(s, "-----------------------------------------------------\n");
+
+	spin_lock(&mdsc->caps_list_lock);
+	list_for_each_entry(cw, &mdsc->cap_wait_list, list) {
+		seq_printf(s, "%-13d0x%-17lx%-17s%-17s\n", cw->tgid, cw->ino,
+				ceph_cap_string(cw->need),
+				ceph_cap_string(cw->want));
+	}
+	spin_unlock(&mdsc->caps_list_lock);
+
 	return 0;
 }
 
diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
index 890f7f613390..40f9a640481d 100644
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -4169,6 +4169,7 @@ int ceph_mdsc_init(struct ceph_fs_client *fsc)
 	INIT_DELAYED_WORK(&mdsc->delayed_work, delayed_work);
 	mdsc->last_renew_caps = jiffies;
 	INIT_LIST_HEAD(&mdsc->cap_delay_list);
+	INIT_LIST_HEAD(&mdsc->cap_wait_list);
 	spin_lock_init(&mdsc->cap_delay_lock);
 	INIT_LIST_HEAD(&mdsc->snap_flush_list);
 	spin_lock_init(&mdsc->snap_flush_lock);
diff --git a/fs/ceph/mds_client.h b/fs/ceph/mds_client.h
index 5cd131b41d84..14c7e8c49970 100644
--- a/fs/ceph/mds_client.h
+++ b/fs/ceph/mds_client.h
@@ -340,6 +340,14 @@ struct ceph_quotarealm_inode {
 	struct inode *inode;
 };
 
+struct cap_wait {
+	struct list_head	list;
+	unsigned long		ino;
+	pid_t			tgid;
+	int			need;
+	int			want;
+};
+
 /*
  * mds client state
  */
@@ -416,6 +424,7 @@ struct ceph_mds_client {
 	spinlock_t	caps_list_lock;
 	struct		list_head caps_list; /* unused (reserved or
 						unreserved) */
+	struct		list_head cap_wait_list;
 	int		caps_total_count;    /* total caps allocated */
 	int		caps_use_count;      /* in use */
 	int		caps_use_max;	     /* max used caps */
-- 
2.23.0

