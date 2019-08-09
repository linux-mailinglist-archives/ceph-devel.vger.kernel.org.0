Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D9AA187057
	for <lists+ceph-devel@lfdr.de>; Fri,  9 Aug 2019 05:57:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404791AbfHID46 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 8 Aug 2019 23:56:58 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:41416 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729419AbfHID46 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 8 Aug 2019 23:56:58 -0400
Received: by mail-pf1-f196.google.com with SMTP id m30so45297370pff.8;
        Thu, 08 Aug 2019 20:56:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=a8MxHbYgV4FR4px/xpjjPQF9zcuXdOB9bKmKMJtQBFU=;
        b=nyrb/ENFwvzE16dXeTFhPmi36X4sq+y7mO/ApHgRvnaPxwKJ5nGwT5Xb3iXfy0Qr3x
         IaMvF6+lQTM9lB+ZUETp3fPRI+0ObQ7TS0LgZn9nalv1VTFMU78wGQ8jFe47zq2jnTpW
         BezeG6Vtupjk2x8nzomi0ZuFQVfoEXL+ieH92E/XhA41Lefl23FBKfQYj2JIvUDUT8CE
         BPSl/rO3vPQyN+NYKQWKLnYDYpfkhCt/8J+5Rrk6Ofn+PVt/69f9EEE7JuNA/3DuUWqY
         GbAwq5zNz60yOTQpjVUm2UeIJBJ+LMqvgxetIuM420wpoRREFUxc2MFNuOONio9z5Ma9
         2b5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=a8MxHbYgV4FR4px/xpjjPQF9zcuXdOB9bKmKMJtQBFU=;
        b=XIipFqaNdOdpoqqQAVqXnQaWkK962qOCB8esByKv3xr8aGYoHX1V71k+NdRHuvTkrF
         6x2ylZdusJIS+8DaC3ao5RNiUQp27dD83IvNygL0eCe0htjwzaSIPPsGRX8wyOC7Uhz0
         KkoIRCNr05nbVcODNNTSEtdTRGX6MmeqMHIZuVTtUFXGkVtyTGUl7A1GdkxE4RIlmqj0
         CHkKfRVrk0DVPrMAbUMVERUvIp5z+oj0wLu7bM8ecjs7nNNxOqCno/S9FhtWKobHxenT
         bHlqJcMmgVdw7A6eMieD/f0JM82VJClcT4cMle7Y0h9Ov2+NS+SKYOMpVIt7eVfQ2H3L
         4V5w==
X-Gm-Message-State: APjAAAW8c0debInEOTmpW0g8LfBpniZ4xo88WPtZgzwOBbd5BhPpctis
        P7GegSiDEsI+XlhKLqFDt8o=
X-Google-Smtp-Source: APXvYqxscUTAgil4snTeC8qFgKtSj5vq1Em0S9l09CJFvTqPZu1N/wafFWjrKzQO41BiEh3fmIu9aA==
X-Received: by 2002:a17:90a:7d04:: with SMTP id g4mr7402936pjl.41.1565323017911;
        Thu, 08 Aug 2019 20:56:57 -0700 (PDT)
Received: from blueforge.nvidia.com (searspoint.nvidia.com. [216.228.112.21])
        by smtp.gmail.com with ESMTPSA id 21sm3513849pjh.25.2019.08.08.20.56.56
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 08 Aug 2019 20:56:57 -0700 (PDT)
From:   john.hubbard@gmail.com
X-Google-Original-From: jhubbard@nvidia.com
To:     Jeff Layton <jlayton@kernel.org>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        John Hubbard <jhubbard@nvidia.com>,
        Sage Weil <sage@redhat.com>, Ilya Dryomov <idryomov@gmail.com>,
        ceph-devel@vger.kernel.org
Subject: [PATCH] fs/ceph: use release_pages() directly
Date:   Thu,  8 Aug 2019 20:56:47 -0700
Message-Id: <20190809035647.18866-1-jhubbard@nvidia.com>
X-Mailer: git-send-email 2.22.0
MIME-Version: 1.0
X-NVConfidentiality: public
Content-Transfer-Encoding: 8bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: John Hubbard <jhubbard@nvidia.com>

release_pages() has been available to modules since Oct, 2010,
when commit 0be8557bcd34 ("fuse: use release_pages()") added
EXPORT_SYMBOL(release_pages). However, this ceph code was still
using a workaround.

Remove the workaround, and call release_pages() directly.

Cc: Jeff Layton <jlayton@kernel.org>
Cc: Sage Weil <sage@redhat.com>
Cc: Ilya Dryomov <idryomov@gmail.com>
Cc: ceph-devel@vger.kernel.org
Signed-off-by: John Hubbard <jhubbard@nvidia.com>
---

Hi,

I noticed this while I trying to understand mlock.c's use of
pagevec_release(). So I was looking around for examples, and stumbled
across this, which seems worth cleaning up.

thanks,
John Hubbard
NVIDIA

 fs/ceph/addr.c | 19 +------------------
 1 file changed, 1 insertion(+), 18 deletions(-)

diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
index e078cc55b989..22ed45d143be 100644
--- a/fs/ceph/addr.c
+++ b/fs/ceph/addr.c
@@ -679,23 +679,6 @@ static int ceph_writepage(struct page *page, struct writeback_control *wbc)
 	return err;
 }
 
-/*
- * lame release_pages helper.  release_pages() isn't exported to
- * modules.
- */
-static void ceph_release_pages(struct page **pages, int num)
-{
-	struct pagevec pvec;
-	int i;
-
-	pagevec_init(&pvec);
-	for (i = 0; i < num; i++) {
-		if (pagevec_add(&pvec, pages[i]) == 0)
-			pagevec_release(&pvec);
-	}
-	pagevec_release(&pvec);
-}
-
 /*
  * async writeback completion handler.
  *
@@ -769,7 +752,7 @@ static void writepages_finish(struct ceph_osd_request *req)
 		dout("writepages_finish %p wrote %llu bytes cleaned %d pages\n",
 		     inode, osd_data->length, rc >= 0 ? num_pages : 0);
 
-		ceph_release_pages(osd_data->pages, num_pages);
+		release_pages(osd_data->pages, num_pages);
 	}
 
 	ceph_put_wrbuffer_cap_refs(ci, total_pages, snapc);
-- 
2.22.0

