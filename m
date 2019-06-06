Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E003C3759F
	for <lists+ceph-devel@lfdr.de>; Thu,  6 Jun 2019 15:48:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728236AbfFFNsD (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 6 Jun 2019 09:48:03 -0400
Received: from mx1.redhat.com ([209.132.183.28]:50728 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726877AbfFFNsD (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Thu, 6 Jun 2019 09:48:03 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 9E6807FDF8
        for <ceph-devel@vger.kernel.org>; Thu,  6 Jun 2019 13:48:03 +0000 (UTC)
Received: from zhyan-laptop.redhat.com (ovpn-12-89.pek2.redhat.com [10.72.12.89])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3E741183EF;
        Thu,  6 Jun 2019 13:48:00 +0000 (UTC)
From:   "Yan, Zheng" <zyan@redhat.com>
To:     ceph-devel@vger.kernel.org
Cc:     idryomov@redhat.com, jlayton@redhat.com,
        "Yan, Zheng" <zyan@redhat.com>
Subject: [PATCH 2/3] ceph: check page writeback error during write
Date:   Thu,  6 Jun 2019 21:47:53 +0800
Message-Id: <20190606134754.31725-2-zyan@redhat.com>
In-Reply-To: <20190606134754.31725-1-zyan@redhat.com>
References: <20190606134754.31725-1-zyan@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.27]); Thu, 06 Jun 2019 13:48:03 +0000 (UTC)
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

make write(2) return error prematurely if there is writeback error.
User can use fsync() or fdatasync() to clear the error.

Signed-off-by: "Yan, Zheng" <zyan@redhat.com>
---
 fs/ceph/caps.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
index e88a21d830e1..6063e5f4035a 100644
--- a/fs/ceph/caps.c
+++ b/fs/ceph/caps.c
@@ -2816,6 +2816,14 @@ int ceph_get_caps(struct file *filp, int need, int want,
 		break;
 	}
 
+	if (_got & CEPH_CAP_FILE_WR) {
+		ret = filemap_check_wb_err(inode->i_mapping, filp->f_wb_err);
+		if (ret < 0) {
+			ceph_put_cap_refs(ci, _got);
+			return ret;
+		}
+	}
+
 	if ((_got & CEPH_CAP_FILE_RD) && (_got & CEPH_CAP_FILE_CACHE))
 		ceph_fscache_revalidate_cookie(ci);
 
-- 
2.17.2

