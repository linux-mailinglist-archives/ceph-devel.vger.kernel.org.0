Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7DFBA30E1A
	for <lists+ceph-devel@lfdr.de>; Fri, 31 May 2019 14:28:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727310AbfEaM2Y (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 31 May 2019 08:28:24 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55102 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726415AbfEaM2X (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Fri, 31 May 2019 08:28:23 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id F3F853179B49;
        Fri, 31 May 2019 12:28:19 +0000 (UTC)
Received: from zhyan-laptop.redhat.com (ovpn-12-56.pek2.redhat.com [10.72.12.56])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3025D1758B;
        Fri, 31 May 2019 12:28:16 +0000 (UTC)
From:   "Yan, Zheng" <zyan@redhat.com>
To:     ceph-devel@vger.kernel.org
Cc:     idryomov@redhat.com, jlayton@redhat.com, lhenriques@suse.com,
        "Yan, Zheng" <zyan@redhat.com>
Subject: [PATCH 3/3] ceph: fix infinite loop in get_quota_realm()
Date:   Fri, 31 May 2019 20:28:02 +0800
Message-Id: <20190531122802.12814-3-zyan@redhat.com>
In-Reply-To: <20190531122802.12814-1-zyan@redhat.com>
References: <20190531122802.12814-1-zyan@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.41]); Fri, 31 May 2019 12:28:23 +0000 (UTC)
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

get_quota_realm() enters infinite loop if quota inode has no caps.
This can happen after client gets evicted.

Signed-off-by: "Yan, Zheng" <zyan@redhat.com>
---
 fs/ceph/quota.c | 15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

diff --git a/fs/ceph/quota.c b/fs/ceph/quota.c
index d629fc857450..de56dee60540 100644
--- a/fs/ceph/quota.c
+++ b/fs/ceph/quota.c
@@ -135,7 +135,7 @@ static struct inode *lookup_quotarealm_inode(struct ceph_mds_client *mdsc,
 		return NULL;
 
 	mutex_lock(&qri->mutex);
-	if (qri->inode) {
+	if (qri->inode && ceph_is_any_caps(qri->inode)) {
 		/* A request has already returned the inode */
 		mutex_unlock(&qri->mutex);
 		return qri->inode;
@@ -146,7 +146,18 @@ static struct inode *lookup_quotarealm_inode(struct ceph_mds_client *mdsc,
 		mutex_unlock(&qri->mutex);
 		return NULL;
 	}
-	in = ceph_lookup_inode(sb, realm->ino);
+	if (qri->inode) {
+		/* get caps */
+		int ret = __ceph_do_getattr(qri->inode, NULL,
+					    CEPH_STAT_CAP_INODE, true);
+		if (ret >= 0)
+			in = qri->inode;
+		else
+			in = ERR_PTR(ret);
+	}  else {
+		in = ceph_lookup_inode(sb, realm->ino);
+	}
+
 	if (IS_ERR(in)) {
 		pr_warn("Can't lookup inode %llx (err: %ld)\n",
 			realm->ino, PTR_ERR(in));
-- 
2.17.2

