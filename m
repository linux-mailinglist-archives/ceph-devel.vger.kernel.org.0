Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 009A17E760
	for <lists+ceph-devel@lfdr.de>; Fri,  2 Aug 2019 03:07:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390620AbfHBBHC (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 1 Aug 2019 21:07:02 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:36692 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388659AbfHBBHC (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 1 Aug 2019 21:07:02 -0400
Received: by mail-pf1-f196.google.com with SMTP id r7so35057031pfl.3;
        Thu, 01 Aug 2019 18:07:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=sjbLcDpFygaRN6z6yMb5W7UMnR2XjEszSpP2HyVCGIs=;
        b=IponQB14Ndkh1lTDXGxq4zZcDMMiTgFeR2haeg8Kf5NrjcJZqPF26AZ9LUoVpKA10d
         Q644iY2+TZkJcbk04d5q542ZIKVZNWo995Wvnz4RCmQNe7hZCpoI5NDv/D5cDsZ3jBJk
         OvSiRONWwOAueWfDWe21zmXFEuUiffAVN089wIITUOpmO8ik1dizR4unfQzq74vosVIR
         V9ZmMj2alFdVUTeJjQ/gb05Ik300TwaagjnDQ/duBui666JFRs16WJK7tJZV5QmxLbkC
         917Ib11ig6nbBHnzcWqVZkdDC1LcVkY2kGX1txzujmaCUGw5nZUNd+IEBCu7s34t9HvA
         /p4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=sjbLcDpFygaRN6z6yMb5W7UMnR2XjEszSpP2HyVCGIs=;
        b=KxfsQ9fC8QuHh33Z3GDgNhgmk+8mUSYqCI6H3Q4uyeyRUMs2qLfIQGZyL3+CPac/nE
         EyCfqukQjb5dI3AR9CecA79r6kIAdAK8qUYD9hAqDjvKxgKyWdAZ1ECQMazTkXfrECGr
         smC0jcBuRtR3QIxgvnMVZJ1Bgk/ZrKZBwAaqcrK6nL0lv3QNOZkEnJHhBzGa4PUxI9ax
         FyaX09R9cFucdRjlh5Vv0nkaL5d/ePjvvV1a9t3QjiPZdHjOIzp78H9UmJtV1yDeG371
         CBYPqP+o488Cp6OvjY7uZTWkRjqaEuRUo6KdKfVRwWIT1ehLCq55AIe3EsjiXuLw7KyB
         57Ww==
X-Gm-Message-State: APjAAAXyBoRxpWrJ7RuD2syRzHY4UipmUwPGOdZ3vShyUcQMuAeeZdi7
        rOwliFy6NvA09c8DVM/zkD0=
X-Google-Smtp-Source: APXvYqxbAs9pJYckXX/s6qMLs6XlrKT8CnTGxmnro6NHrTsdNfQ7PQLtU7B0rT/flc/gcfToHBBqCA==
X-Received: by 2002:a63:a35c:: with SMTP id v28mr28997289pgn.144.1564708021651;
        Thu, 01 Aug 2019 18:07:01 -0700 (PDT)
Received: from blueforge.nvidia.com (searspoint.nvidia.com. [216.228.112.21])
        by smtp.gmail.com with ESMTPSA id 131sm88441523pfx.57.2019.08.01.18.07.00
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 01 Aug 2019 18:07:00 -0700 (PDT)
From:   john.hubbard@gmail.com
X-Google-Original-From: jhubbard@nvidia.com
To:     Jeff Layton <jlayton@kernel.org>
Cc:     Sage Weil <sage@redhat.com>, Ilya Dryomov <idryomov@gmail.com>,
        ceph-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
        John Hubbard <jhubbard@nvidia.com>
Subject: [PATCH] fs/ceph: don't return a value from void function
Date:   Thu,  1 Aug 2019 18:06:58 -0700
Message-Id: <20190802010658.18150-1-jhubbard@nvidia.com>
X-Mailer: git-send-email 2.22.0
MIME-Version: 1.0
X-NVConfidentiality: public
Content-Transfer-Encoding: 8bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: John Hubbard <jhubbard@nvidia.com>

This fixes a build warning to that effect.

Signed-off-by: John Hubbard <jhubbard@nvidia.com>
---

Hi,

I ran into this while working on unrelated changes, to
convert ceph over to put_user_page().

This patch is against the latest linux.git.

thanks,
John Hubbard
NVIDIA


 fs/ceph/debugfs.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/ceph/debugfs.c b/fs/ceph/debugfs.c
index 2eb88ed22993..facb387c2735 100644
--- a/fs/ceph/debugfs.c
+++ b/fs/ceph/debugfs.c
@@ -294,7 +294,6 @@ void ceph_fs_debugfs_init(struct ceph_fs_client *fsc)
 
 void ceph_fs_debugfs_init(struct ceph_fs_client *fsc)
 {
-	return 0;
 }
 
 void ceph_fs_debugfs_cleanup(struct ceph_fs_client *fsc)
-- 
2.22.0

