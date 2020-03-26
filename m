Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1550E19487F
	for <lists+ceph-devel@lfdr.de>; Thu, 26 Mar 2020 21:15:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728692AbgCZUPJ (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 26 Mar 2020 16:15:09 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:38521 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727446AbgCZUPJ (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 26 Mar 2020 16:15:09 -0400
Received: by mail-wm1-f68.google.com with SMTP id f6so2400657wmj.3;
        Thu, 26 Mar 2020 13:15:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=iMrLYsKdnop151Jl/lpoDdMH/0Stp9QFCgC1isOqd2g=;
        b=BH3eHgJr4v9eAS682F090rUPKFp6jWHjDKp1iZCr4XWNWYZmYqxrgc/77XMfldUu8w
         1cvvoA0iu1Y4jI285nuptsep5xYUbDIfa84kRkaEEihPmkNwQ402A1IIvNJ2w7OkzGur
         4Syf4QIs/cwbron/+8sLwyh0Shc0aIUgRu8dVzgljrNdU74JDBkXgVm80BO0TQ+FuWIT
         HBIWflDNSJS2yz12o62rYNa1FkUcv66wmvqiez3qJfVnQ8gpx61M7tojfvQOKkb5WHDz
         wOVEASxeqzvuXEy4tLFRFdJdZOe1k7x4IEmy9AHgRMr5XlqaN4N2z07ayU+2a7JPQfWl
         IfMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=iMrLYsKdnop151Jl/lpoDdMH/0Stp9QFCgC1isOqd2g=;
        b=Hv+RpBmOhp6If2zAXEH+90SxtyUQSETQ0mfwo2sjYINOIaKiKzlw54tPhkMkgMy06B
         n3k10x39IncxUA+XOqYRKYSFyGNBQkEByhb+Zy2FHr0B3y6Df5YOdtjQS6mAh2z9yiLd
         rg111yZ6GIe8a8xKs5F1PklJbKY7PE7PzVKwmIiUEDqDVYDm/qMSYTCFC2y4b+cHFXLK
         8C4RuF45R1oSallGxI7IIA5ItKvcNqiGI/yvZ8TcpQmo5c++tN95sNij4egLn9A91L2W
         YZhm7fqoTAD0UtXWboFSKIqQjjE1hAhPePaLBeo4vBcu3xy5l4mm//NPpgxYj0bL42s/
         FhXg==
X-Gm-Message-State: ANhLgQ0nVEbOeJafScw7N/hxGUfES+vUHyiVzcdBGosTY4Zajee+Jo4j
        QpBPAs2kyWByQS1wQm9BubblU/UP
X-Google-Smtp-Source: ADFU+vvmnBc4o0w0B+0U/RgBi4ffTkBWgnkzSv9RJIc97VJyRxjjvB8w04vUygEFbJsf/YYtoYcTOw==
X-Received: by 2002:adf:dd01:: with SMTP id a1mr12017594wrm.153.1585253706802;
        Thu, 26 Mar 2020 13:15:06 -0700 (PDT)
Received: from kwango.redhat.com (ip-94-112-129-237.net.upcbroadband.cz. [94.112.129.237])
        by smtp.gmail.com with ESMTPSA id h18sm4714535wmm.34.2020.03.26.13.15.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Mar 2020 13:15:05 -0700 (PDT)
From:   Ilya Dryomov <idryomov@gmail.com>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     ceph-devel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] Ceph fixes for 5.6-rc8
Date:   Thu, 26 Mar 2020 21:14:53 +0100
Message-Id: <20200326201453.7227-1-idryomov@gmail.com>
X-Mailer: git-send-email 2.19.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Hi Linus,

The following changes since commit 16fbf79b0f83bc752cee8589279f1ebfe57b3b6e:

  Linux 5.6-rc7 (2020-03-22 18:31:56 -0700)

are available in the Git repository at:

  https://github.com/ceph/ceph-client.git tags/ceph-for-5.6-rc8

for you to fetch changes up to c8d6ee01449cd0d2f30410681cccb616a88f50b1:

  ceph: fix memory leak in ceph_cleanup_snapid_map() (2020-03-23 13:07:08 +0100)

----------------------------------------------------------------
A patch for a rather old regression in fullness handling and two memory
leak fixes, marked for stable.

----------------------------------------------------------------
Ilya Dryomov (2):
      ceph: check POOL_FLAG_FULL/NEARFULL in addition to OSDMAP_FULL/NEARFULL
      libceph: fix alloc_msg_with_page_vector() memory leaks

Luis Henriques (1):
      ceph: fix memory leak in ceph_cleanup_snapid_map()

 fs/ceph/file.c                 | 14 +++++++++++---
 fs/ceph/snap.c                 |  1 +
 include/linux/ceph/messenger.h |  7 ++++---
 include/linux/ceph/osdmap.h    |  4 ++++
 include/linux/ceph/rados.h     |  6 ++++--
 net/ceph/messenger.c           |  9 +++++++--
 net/ceph/osd_client.c          | 14 +++-----------
 net/ceph/osdmap.c              |  9 +++++++++
 8 files changed, 43 insertions(+), 21 deletions(-)
