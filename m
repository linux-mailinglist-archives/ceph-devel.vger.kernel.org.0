Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A23CF72490
	for <lists+ceph-devel@lfdr.de>; Wed, 24 Jul 2019 04:26:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728208AbfGXC00 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 23 Jul 2019 22:26:26 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:39693 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727916AbfGXC00 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 23 Jul 2019 22:26:26 -0400
Received: by mail-pf1-f193.google.com with SMTP id f17so16095053pfn.6
        for <ceph-devel@vger.kernel.org>; Tue, 23 Jul 2019 19:26:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=+WuWFuTNJPvOEF7mjj6M6Sety0RI1KDUphA77ZwptYw=;
        b=taCkySyuyxywaYUpQvZXYei5Csmyol2CsBQmi4bv3SiHF/xP4IKknmJ3/A/k8BX5jC
         as1/S203aU/Bfzb4fw/YNH9h6bw44iGKpLHpT969APjvc3YP6r0Pfm6pRbvq9yVrVeTq
         90hikCVtSU22RnFHsAtt4IAv8BznjxoXlF59Kr6B9hHfXqYr5SPLiJEVBq61KEW8Y1xF
         ehkkNzhWoYNmNDtFTIcw2To/oGuGFlv3kUVekJ5aJbTut8SwEj3bMHiPsi7K3sl9QwUj
         pSnhS/oHk4maLHfsHKb6PdZYgZyUvaw1jbXnW+PyMqqmEA0NV0inpFsw2lX2inlyZnfm
         0Fqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=+WuWFuTNJPvOEF7mjj6M6Sety0RI1KDUphA77ZwptYw=;
        b=p4EVW7HURQ011AOhdJFpz+LBGUzuZjvu7H0YVbRN8Q5ZS9TP3iVh5287+WsEXQmddh
         Cjjs+rAdJ2D9alI9A4SPdMsquVcmoNNBw4FUX+J84435i9JqZWnc+zts12smJAfo43e7
         ccdFG3jiK5Vh0hxl43lgnkKltT412JjCY+nfuSsaDikU1Y5ShZnOMClzLGLQfIeqsBlb
         ocbZaBIWfsS+VYXKRCFnBRYv8LNfLlX9+P5HTCQIDU4hCgDM1MCjwZRzupxD+zTpT+9w
         2IDFVMoV9i1rX8AeAbQ0fZwbh7VygY29u13h1iSeTJnmaRsFiykmK65Buwj3MhFsUlX2
         vgwg==
X-Gm-Message-State: APjAAAWSF2I6SZMcZGc6dxaNMuQgovMDdlCd24/XbIqe/852sZImNKAP
        g9ZEjnwJmzunh5GGkKjMOXc13o9rvsM=
X-Google-Smtp-Source: APXvYqyvbUe62vHt8IPuSEZh+dCFZEfr7BKw++VCHauuR5ropGTScGonwXnjFUMRiXX2uwaoAWow8w==
X-Received: by 2002:a62:8643:: with SMTP id x64mr9080541pfd.7.1563935185641;
        Tue, 23 Jul 2019 19:26:25 -0700 (PDT)
Received: from localhost.localdomain (69-172-67-191.static.imsbiz.com. [69.172.67.191])
        by smtp.gmail.com with ESMTPSA id a3sm53043558pje.3.2019.07.23.19.26.23
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Tue, 23 Jul 2019 19:26:25 -0700 (PDT)
From:   chenerqi@gmail.com
To:     ceph-devel@vger.kernel.org
Cc:     chenerqi@gmail.com
Subject: [PATCH] ceph: clear page dirty before invalidate page
Date:   Wed, 24 Jul 2019 10:26:09 +0800
Message-Id: <20190724022609.15652-1-chenerqi@gmail.com>
X-Mailer: git-send-email 2.20.1 (Apple Git-117)
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: Erqi Chen <chenerqi@gmail.com>

clear_page_dirty_for_io(page) before mapping->a_ops->invalidatepage().
invalidatepage() clears page's private flag, if dirty flag is not
cleared, the page may cause BUG_ON failure in ceph_set_page_dirty().

Fixes: https://tracker.ceph.com/issues/40862
Signed-off-by: Erqi Chen chenerqi@gmail.com
---
 fs/ceph/addr.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
index e078cc5..5d3f2dd 100644
--- a/fs/ceph/addr.c
+++ b/fs/ceph/addr.c
@@ -913,8 +913,9 @@ static int ceph_writepages_start(struct address_space *mapping,
 			if (page_offset(page) >= ceph_wbc.i_size) {
 				dout("%p page eof %llu\n",
 				     page, ceph_wbc.i_size);
-				if (ceph_wbc.size_stable ||
+				if ((ceph_wbc.size_stable ||
 				    page_offset(page) >= i_size_read(inode))
+				    && clear_page_dirty_for_io(page))
 					mapping->a_ops->invalidatepage(page,
 								0, PAGE_SIZE);
 				unlock_page(page);
-- 
1.8.3.1

