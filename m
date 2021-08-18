Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 35D663EFA87
	for <lists+ceph-devel@lfdr.de>; Wed, 18 Aug 2021 08:01:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237947AbhHRGCU (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 18 Aug 2021 02:02:20 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:28073 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237892AbhHRGCU (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Wed, 18 Aug 2021 02:02:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1629266505;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=4/88rlTdeVE09dHvQFmilTpr+XZ2SWKTVKUNZwoAaZA=;
        b=CiNTdkpuW7UQyt28vTHnlpj7RSiRz2rNPaiIoSGCj/Od6EPGYZjeSLJqgQyYT1J528o5Rz
        B6EWtGsxVejzC1lf9WsPC62VSpgavwrlGhhWPlHCIa39DwuHgBVnqOymE2DG6/Nms5alOk
        lYT7re6KcCybsPBgOOIceUzTiTTu5/4=
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com
 [209.85.216.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-431-ZHPNZBUTN0yBMHKiGIXNgw-1; Wed, 18 Aug 2021 02:01:43 -0400
X-MC-Unique: ZHPNZBUTN0yBMHKiGIXNgw-1
Received: by mail-pj1-f70.google.com with SMTP id 2-20020a17090a1742b0290178de0ca331so981096pjm.1
        for <ceph-devel@vger.kernel.org>; Tue, 17 Aug 2021 23:01:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=4/88rlTdeVE09dHvQFmilTpr+XZ2SWKTVKUNZwoAaZA=;
        b=Wog8krOFzoQ/KeCbJx+SWA57HsUVTifb2txvCZM9ockCNUjsbiIv6qr/Iy1gRFU6+C
         7aQoh/A1jekQHPdpFsKwvGaPQOeqzl/lcZsdrmcI+MgKwewicG567Rkx0kRixy/mP/T3
         1axLXrYP4LTZkulS13dDFI9/joBtR3+T2fFnEEfCSNsw2GuZSF5IppxIh+ZtOGwKDuKW
         HkwQGsaa5WHjWX5MPZekWVyBoRt+JOJ4EWDGeNWFodeJhQ395Q421FnRp0qnU86YMxc4
         AFflfF0Pb97IMfasCk5rATGWvzkZLGs80b4ZMpEZqSqRgpmHVh6lw7BXlYvWhJW9wNT8
         jIoA==
X-Gm-Message-State: AOAM533rAA7FFvnKtm97RlyRwxdJweqz3IGVMJEycSLSlflRyqk9DvxM
        MHbvEXsDa/q2kBYosekbqrT4MQlENPAYVs/7E9ary+QLuEkMznvG4fSZAKxLweoDZowuzf1BtbV
        T1fbmNZflwxnvj9lle0DU5g==
X-Received: by 2002:a17:90a:7848:: with SMTP id y8mr7426510pjl.223.1629266502641;
        Tue, 17 Aug 2021 23:01:42 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxo2vm4SwS68d701oa0dJ8KoDRUaYhJ795tbCdLvJ1ct/fQtow9PxxH7TQ6KfIaK1gfjqvVKw==
X-Received: by 2002:a17:90a:7848:: with SMTP id y8mr7426505pjl.223.1629266502462;
        Tue, 17 Aug 2021 23:01:42 -0700 (PDT)
Received: from localhost.localdomain ([49.207.198.118])
        by smtp.gmail.com with ESMTPSA id m28sm5865111pgl.9.2021.08.17.23.01.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Aug 2021 23:01:41 -0700 (PDT)
From:   Venky Shankar <vshankar@redhat.com>
To:     jlayton@redhat.com, pdonnell@redhat.com
Cc:     ceph-devel@vger.kernel.org, Venky Shankar <vshankar@redhat.com>
Subject: [RFC 0/2] ceph: add debugfs entries signifying new mount syntax support
Date:   Wed, 18 Aug 2021 11:31:32 +0530
Message-Id: <20210818060134.208546-1-vshankar@redhat.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

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
    /sys/kernel/debug/ceph/dev_support
    /sys/kernel/debug/ceph/dev_support/v2
    ....
    ....

Note that there is no entry signifying v1 mount syntax. That's because
the kernel still supports mounting with old syntax and older kernels do
not have debug entries for the same.

Venky Shankar (2):
  ceph: add helpers to create/cleanup debugfs sub-directories under
    "ceph" directory
  ceph: add debugfs entries for v2 (new) mount syntax support

 fs/ceph/debugfs.c            | 28 ++++++++++++++++++++++++++++
 fs/ceph/super.c              |  3 +++
 fs/ceph/super.h              |  2 ++
 include/linux/ceph/debugfs.h |  3 +++
 net/ceph/debugfs.c           | 26 ++++++++++++++++++++++++--
 5 files changed, 60 insertions(+), 2 deletions(-)

-- 
2.27.0

