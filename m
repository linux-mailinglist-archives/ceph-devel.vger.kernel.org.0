Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 049FA277BF
	for <lists+ceph-devel@lfdr.de>; Thu, 23 May 2019 10:13:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726429AbfEWINu (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 23 May 2019 04:13:50 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37358 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725814AbfEWINu (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Thu, 23 May 2019 04:13:50 -0400
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 13FE53082B5F
        for <ceph-devel@vger.kernel.org>; Thu, 23 May 2019 08:13:50 +0000 (UTC)
Received: from zhyan-laptop.redhat.com (ovpn-12-163.pek2.redhat.com [10.72.12.163])
        by smtp.corp.redhat.com (Postfix) with ESMTP id DA715619EF;
        Thu, 23 May 2019 08:13:47 +0000 (UTC)
From:   "Yan, Zheng" <zyan@redhat.com>
To:     ceph-devel@vger.kernel.org
Cc:     idryomov@redhat.com, jlayton@redhat.com,
        "Yan, Zheng" <zyan@redhat.com>
Subject: [PATCH 1/8] ceph: fix error handling in ceph_get_caps()
Date:   Thu, 23 May 2019 16:13:38 +0800
Message-Id: <20190523081345.20410-1-zyan@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.45]); Thu, 23 May 2019 08:13:50 +0000 (UTC)
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

The function return 0 even when interrupted or try_get_cap_refs()
return error.

Introduce by commit 1199d7da2d "ceph: simplify arguments and return
semantics of try_get_cap_refs"

Signed-off-by: "Yan, Zheng" <zyan@redhat.com>
---
 fs/ceph/caps.c | 22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
index 72f8e1311392..079d0df9650c 100644
--- a/fs/ceph/caps.c
+++ b/fs/ceph/caps.c
@@ -2738,15 +2738,13 @@ int ceph_get_caps(struct ceph_inode_info *ci, int need, int want,
 		_got = 0;
 		ret = try_get_cap_refs(ci, need, want, endoff,
 				       false, &_got);
-		if (ret == -EAGAIN) {
+		if (ret == -EAGAIN)
 			continue;
-		} else if (!ret) {
-			int err;
-
+		if (!ret) {
 			DEFINE_WAIT_FUNC(wait, woken_wake_function);
 			add_wait_queue(&ci->i_cap_wq, &wait);
 
-			while (!(err = try_get_cap_refs(ci, need, want, endoff,
+			while (!(ret = try_get_cap_refs(ci, need, want, endoff,
 							true, &_got))) {
 				if (signal_pending(current)) {
 					ret = -ERESTARTSYS;
@@ -2756,14 +2754,16 @@ int ceph_get_caps(struct ceph_inode_info *ci, int need, int want,
 			}
 
 			remove_wait_queue(&ci->i_cap_wq, &wait);
-			if (err == -EAGAIN)
+			if (ret == -EAGAIN)
 				continue;
 		}
-		if (ret == -ESTALE) {
-			/* session was killed, try renew caps */
-			ret = ceph_renew_caps(&ci->vfs_inode);
-			if (ret == 0)
-				continue;
+		if (ret < 0) {
+			if (ret == -ESTALE) {
+				/* session was killed, try renew caps */
+				ret = ceph_renew_caps(&ci->vfs_inode);
+				if (ret == 0)
+					continue;
+			}
 			return ret;
 		}
 
-- 
2.17.2

