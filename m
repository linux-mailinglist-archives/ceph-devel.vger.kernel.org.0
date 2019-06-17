Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F396348344
	for <lists+ceph-devel@lfdr.de>; Mon, 17 Jun 2019 14:57:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728063AbfFQM4D (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 17 Jun 2019 08:56:03 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51944 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726599AbfFQM4D (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Mon, 17 Jun 2019 08:56:03 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id A23B8356E5
        for <ceph-devel@vger.kernel.org>; Mon, 17 Jun 2019 12:56:03 +0000 (UTC)
Received: from zhyan-laptop.redhat.com (ovpn-12-92.pek2.redhat.com [10.72.12.92])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D843739BE;
        Mon, 17 Jun 2019 12:55:57 +0000 (UTC)
From:   "Yan, Zheng" <zyan@redhat.com>
To:     ceph-devel@vger.kernel.org
Cc:     idryomov@redhat.com, jlayton@redhat.com,
        "Yan, Zheng" <zyan@redhat.com>
Subject: [PATCH 7/8] ceph: check page writeback error during write
Date:   Mon, 17 Jun 2019 20:55:28 +0800
Message-Id: <20190617125529.6230-8-zyan@redhat.com>
In-Reply-To: <20190617125529.6230-1-zyan@redhat.com>
References: <20190617125529.6230-1-zyan@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.30]); Mon, 17 Jun 2019 12:56:03 +0000 (UTC)
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Make write(2) return error prematurely if there is writeback error.
User can use fsync() or fdatasync() to clear the error.

This change is mainly for reporting errors after blacklist + reconnect.

Signed-off-by: "Yan, Zheng" <zyan@redhat.com>
---
 fs/ceph/caps.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
index 57e1447a9d4b..f07767d3864c 100644
--- a/fs/ceph/caps.c
+++ b/fs/ceph/caps.c
@@ -2814,6 +2814,14 @@ int ceph_get_caps(struct file *filp, int need, int want,
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

