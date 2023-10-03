Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2E10B7B6734
	for <lists+ceph-devel@lfdr.de>; Tue,  3 Oct 2023 13:07:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231337AbjJCLHJ (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 3 Oct 2023 07:07:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231466AbjJCLHI (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 3 Oct 2023 07:07:08 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB074EE
        for <ceph-devel@vger.kernel.org>; Tue,  3 Oct 2023 04:06:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1696331174;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=vJMuEaAyRy8dNu6BKz3gbmpaY2uUt9itV/yLGCVyYo0=;
        b=i3ahzmiRthSxyIjCpcKTbkEbPH4eVxK+lnAW7wXcEzhn2BYwbmDNP/mmHzJvA5fvqgumb8
        AeRCFUpwRYHwCZtl5nR2m7scTgDBlKn5r7+8GwC3ByvjMBt9QITZzadh98eASk1WHbkAlb
        Y3jIsmyxbAMiz6NQmKVZdTlNMhIYnpE=
Received: from mail-pf1-f200.google.com (mail-pf1-f200.google.com
 [209.85.210.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-631-KZqEHLkaMCuOBVtpxKxlog-1; Tue, 03 Oct 2023 07:06:13 -0400
X-MC-Unique: KZqEHLkaMCuOBVtpxKxlog-1
Received: by mail-pf1-f200.google.com with SMTP id d2e1a72fcca58-6936a25f49bso743264b3a.1
        for <ceph-devel@vger.kernel.org>; Tue, 03 Oct 2023 04:06:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696331171; x=1696935971;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=vJMuEaAyRy8dNu6BKz3gbmpaY2uUt9itV/yLGCVyYo0=;
        b=fVMV/AdCwnRD0u4yz8+GWYMRsWoS48rJYvqUWvqmHNP5me7z+Y2+tGkrGSz7AyJ1x8
         YkzK32W+Fi6mJo9mWaaNPGNmk4AmZ+KwachqGDeim3NCH4i3yU6+yG8ln2A48g/tl0UH
         cPGt0xoM/F0x6GukGcJ5uUZaKpjHtNu+d/1j3VPLslFgx09/lVxcNpcvmAxzn9hy0MjF
         JWaS51r4oRIIiatl+EPM69Re/vkKXXmvIO4tswnDRmEHvbX0gxuHBO7xxzm6NUPNnT4p
         oIMol6VfvVyZrKTD2BiyvUU1CmxFjR6M+NQdgFT30s7XkgCczqWVi73MpBda4NsHcvk4
         kjpg==
X-Gm-Message-State: AOJu0YxdXzc7hZMqpL7WAJi5GbJ/BXyLgqQBPEeWO0onYCl7z4Jhk5K7
        2kDkalG32CQX51xKG9U7559N2zIILE4IAKWMa7nD+tyf0cnxSng/gTppe1/wa+1wqADxUWU9a8z
        3OX282uPOuBF9gK3F+CVPiItCS+xYl8/pEXB+j6gt0tvVZ6U9k4+RXha0IbSv57cHfGOrP8xWjj
        9ajmSKhVfx
X-Received: by 2002:a05:6a21:47ca:b0:15d:ad11:748 with SMTP id as10-20020a056a2147ca00b0015dad110748mr12583441pzc.30.1696331171032;
        Tue, 03 Oct 2023 04:06:11 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IH46Ci2iT5QgZCneNP7cgoVXeZYy4cwZm0zdmmHRj/5LK0RpfQvWBWYs+TJkjI1tsFMU2pbAA==
X-Received: by 2002:a05:6a21:47ca:b0:15d:ad11:748 with SMTP id as10-20020a056a2147ca00b0015dad110748mr12583422pzc.30.1696331170673;
        Tue, 03 Oct 2023 04:06:10 -0700 (PDT)
Received: from h3ckers-pride.redhat.com ([106.51.172.103])
        by smtp.gmail.com with ESMTPSA id e24-20020a62ee18000000b006887be16675sm1081723pfi.205.2023.10.03.04.06.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Oct 2023 04:06:10 -0700 (PDT)
From:   Venky Shankar <vshankar@redhat.com>
To:     ceph-devel@vger.kernel.org
Cc:     idryomov@gmail.com, jlayton@kernel.org, mchangir@redhat.com,
        xiubli@redhat.com, Venky Shankar <vshankar@redhat.com>
Subject: [PATCH] Revert "ceph: enable async dirops by default"
Date:   Tue,  3 Oct 2023 16:35:56 +0530
Message-ID: <20231003110556.140317-1-vshankar@redhat.com>
X-Mailer: git-send-email 2.41.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: Xiubo Li <xiubli@redhat.com>

This reverts commit f7a67b463fb83a4b9b11ceaa8ec4950b8fb7f902.

We have identified an issue in the MDS affecting CephFS users using
the kernel driver. The issue was first introduced in the octopus
release that added support for clients to perform asynchronous
directory operations using the `nowsync` mount option. The issue
presents itself as an MDS crash resembling (any of) the following
crashes:

        https://tracker.ceph.com/issues/61009
        https://tracker.ceph.com/issues/58489

There is no apparent data loss or corruption, but since the underlying
cause is related to an (operation) ordering issue, the extent of the
problem could surface in other forms - most likely MDS crashes
involving preallocated inodes.

The fix is being reviewed and is being worked on priority:

        https://github.com/ceph/ceph/pull/53752

As a workaround, we recommend (kernel) clients be remounted with the
`wsync` mount option which disables asynchronous directory operations
(depending on the kernel version being used, the default could be
`nowsync`).

This change reverts the default, so, async dirops is disabled (by default).

Signed-off-by: Xiubo Li <xiubli@redhat.com>
Signed-off-by: Venky Shankar <vshankar@redhat.com>
---
 fs/ceph/super.c | 4 ++--
 fs/ceph/super.h | 3 +--
 2 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/fs/ceph/super.c b/fs/ceph/super.c
index 5ec102f6b1ac..2bf6ccc9887b 100644
--- a/fs/ceph/super.c
+++ b/fs/ceph/super.c
@@ -742,8 +742,8 @@ static int ceph_show_options(struct seq_file *m, struct dentry *root)
 	if (fsopt->flags & CEPH_MOUNT_OPT_CLEANRECOVER)
 		seq_show_option(m, "recover_session", "clean");
 
-	if (!(fsopt->flags & CEPH_MOUNT_OPT_ASYNC_DIROPS))
-		seq_puts(m, ",wsync");
+	if (fsopt->flags & CEPH_MOUNT_OPT_ASYNC_DIROPS)
+		seq_puts(m, ",nowsync");
 	if (fsopt->flags & CEPH_MOUNT_OPT_NOPAGECACHE)
 		seq_puts(m, ",nopagecache");
 	if (fsopt->flags & CEPH_MOUNT_OPT_SPARSEREAD)
diff --git a/fs/ceph/super.h b/fs/ceph/super.h
index 7f4b62182a5d..a5476892896c 100644
--- a/fs/ceph/super.h
+++ b/fs/ceph/super.h
@@ -47,8 +47,7 @@
 
 #define CEPH_MOUNT_OPT_DEFAULT			\
 	(CEPH_MOUNT_OPT_DCACHE |		\
-	 CEPH_MOUNT_OPT_NOCOPYFROM |		\
-	 CEPH_MOUNT_OPT_ASYNC_DIROPS)
+	 CEPH_MOUNT_OPT_NOCOPYFROM)
 
 #define ceph_set_mount_opt(fsc, opt) \
 	(fsc)->mount_options->flags |= CEPH_MOUNT_OPT_##opt
-- 
2.41.0

