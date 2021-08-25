Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF8E03F6EFC
	for <lists+ceph-devel@lfdr.de>; Wed, 25 Aug 2021 07:50:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232480AbhHYFvg (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 25 Aug 2021 01:51:36 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:39833 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232265AbhHYFvf (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Wed, 25 Aug 2021 01:51:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1629870650;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=RNCnIL59swX+xVWRit7a1juPShZBUJGhLooQX4AWiXo=;
        b=bvXyiIMNgtCzrE+ckFYbTkMCdhyQRhEj9+lTFS3jh8N4pSyDG6lP9b+Ah02QHBaixJNxJP
        8mu9vL6OrVvHjIKeq1dl6pjPS2MrNzmj8nOkggJhe1yHtVd4p/GHmOpU4qip90RzEN+n4j
        WCuD9tm8zj/ZoY/HxnrHo2EY+DTxIkY=
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com
 [209.85.214.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-14-EhUHM7ITPwqa7eARdM1pUQ-1; Wed, 25 Aug 2021 01:50:48 -0400
X-MC-Unique: EhUHM7ITPwqa7eARdM1pUQ-1
Received: by mail-pl1-f199.google.com with SMTP id w10-20020a170902e88a00b0012dbc24039dso6649011plg.22
        for <ceph-devel@vger.kernel.org>; Tue, 24 Aug 2021 22:50:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=RNCnIL59swX+xVWRit7a1juPShZBUJGhLooQX4AWiXo=;
        b=lYSu/NepKx87F4dG/9UwoCgATIYmCnQo2fj4qlRzjKhBuJY/2vJangl/AA/7fxfDqU
         2s0G9Kji7MV+UFleDbMOcsl04aJzDoynph7woYl5vKgMhAlW1/jVCbwn8klWcWw45k8i
         iiOZ8VSMQUZvtZrzopw0CeNhS7WpswOoj2WdPuNTHM1hDFURVQ74OR2mvLDBWBcp641M
         j6Ze/07FeHY86MJtQVAx+pVTRC3amTpLaOUjr1fg2hS/y7hquv8mBX/ptjR538tIrd9N
         rp07RCkF2dTqRNbwNrU2gPV3ikV0KYzr0F82BKAQ1Z9k8GuPYhYif6lXJDYdbieyArCT
         TAaw==
X-Gm-Message-State: AOAM531FEJliucbblmwHtHIDy//aoE3q1E4DZoHTq2r75dwD7r8GhL5Y
        x36SM/svXVFFQtVHT1HEfeymmhg3woISav0Zl+yndPjqpMh6vb/sZieiF4peejPr6AdR2a2eo8f
        YeXyvX0TDIj/kPgH4OTRVzA==
X-Received: by 2002:a17:90a:fa0b:: with SMTP id cm11mr6565699pjb.63.1629870647352;
        Tue, 24 Aug 2021 22:50:47 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzrsVpmevzEXIksJvzYKOr95tjzpGkwoaMKoqg7G+LIoUt5PCGg04CaO3MAkm+7uaAYQen4fg==
X-Received: by 2002:a17:90a:fa0b:: with SMTP id cm11mr6565681pjb.63.1629870647094;
        Tue, 24 Aug 2021 22:50:47 -0700 (PDT)
Received: from localhost.localdomain ([49.207.198.118])
        by smtp.gmail.com with ESMTPSA id w4sm960362pjj.15.2021.08.24.22.50.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Aug 2021 22:50:46 -0700 (PDT)
From:   Venky Shankar <vshankar@redhat.com>
To:     jlayton@redhat.com, pdonnell@redhat.com
Cc:     ceph-devel@vger.kernel.org, Venky Shankar <vshankar@redhat.com>
Subject: [PATCH v2 0/2] ceph: add debugfs entries signifying new mount syntax support
Date:   Wed, 25 Aug 2021 11:20:33 +0530
Message-Id: <20210825055035.306043-1-vshankar@redhat.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

v2:
 - export ceph_debugfs_dir
 - include v1 mount support debugfs entry
 - create debugfs entries under /<>/ceph/client_features dir

[This is based on top of new mount syntax series]

Patrick proposed the idea of having debugfs entries to signify if
kernel supports the new (v2) mount syntax. The primary use of this
information is to catch any bugs in the new syntax implementation.

This would be done as follows::

The userspace mount helper tries to mount using the new mount syntax
and fallsback to using old syntax if the mount using new syntax fails.
However, a bug in the new mount syntax implementation can silently
result in the mount helper switching to old syntax.

So, the debugfs entries can be relied upon by the mount helper to
check if the kernel supports the new mount syntax. Cases when the
mount using the new syntax fails, but the kernel does support the
new mount syntax, the mount helper could probably log before switching
to the old syntax (or fail the mount altogether when run in test mode).

Debugfs entries are as follows::

    /sys/kernel/debug/ceph/
    ....
    ....
    /sys/kernel/debug/ceph/client_features
    /sys/kernel/debug/ceph/client_features/v2_mount_syntax
    /sys/kernel/debug/ceph/client_features/v1_mount_syntax
    ....
    ....

Venky Shankar (2):
  libceph: export ceph_debugfs_dir for use in ceph.ko
  ceph: add debugfs entries for mount syntax support

 fs/ceph/debugfs.c            | 36 ++++++++++++++++++++++++++++++++++++
 fs/ceph/super.c              |  3 +++
 fs/ceph/super.h              |  2 ++
 include/linux/ceph/debugfs.h |  2 ++
 net/ceph/debugfs.c           |  3 ++-
 5 files changed, 45 insertions(+), 1 deletion(-)

-- 
2.27.0

