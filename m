Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B6763F1312
	for <lists+ceph-devel@lfdr.de>; Thu, 19 Aug 2021 08:07:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230292AbhHSGHs (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 19 Aug 2021 02:07:48 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:32826 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229782AbhHSGHr (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Thu, 19 Aug 2021 02:07:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1629353231;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=t0MwYc+NC0Mj7OnBLXxK4KsOOVhwbK5tszWk91DJA78=;
        b=dz8lIcx5SrZOxfwbjOPq/755EpzfMnazUT+x2wwupbYUu+fmp0idttxsOsaupONdLOSvZT
        DoNDNBeU9k7gmeEc+cMpAC+k4qG0YbEwU4RjOB0e6f1mdmOLPgm4AXgNT3wyL6lZuQvNHH
        QLHygEYkn8qgDCv6WElYGePVHqGbi84=
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com
 [209.85.216.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-151-nC_WO1ZpNwurM8aGkQwyPg-1; Thu, 19 Aug 2021 02:07:09 -0400
X-MC-Unique: nC_WO1ZpNwurM8aGkQwyPg-1
Received: by mail-pj1-f71.google.com with SMTP id s8-20020a17090a0748b0290177ecd83711so2583830pje.2
        for <ceph-devel@vger.kernel.org>; Wed, 18 Aug 2021 23:07:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=t0MwYc+NC0Mj7OnBLXxK4KsOOVhwbK5tszWk91DJA78=;
        b=LjpWudDUkxn0VUvlSk8OaKnXLcGUaLZFrmzQmsCKlJeQXbq/kpw2xQFGL3iPpl/Ruy
         oyG+OvkPcOiIGl63Zr5vEZW73YzbXKhK32wnBuQHl6SN02t/Z1XRWZ9Ph2T3lhSokGOj
         YVYsUg7TEiN2tgv32neNPgn02Bg9ABn1TBb/CPDXtgPj6hWs9tinGk4omFMKLTPYu0cy
         ty3x3TBwHvIaH2ACoaBMXzL5izhNZ1T0IorNjjQpkmgQQaQ6iN+LUmY+unMSu7DMeyaV
         pGLtRSIDYFrLXZh6XLJ6lWTlzkazH36Eb60u+swh4YbnsmYt7WsBmUGaoXhur4GzU6jM
         Qhcg==
X-Gm-Message-State: AOAM532QtP+QFVV6GOStV4Yb7NlcQBfuNrwVsqxBJFcE722USMi7qcTN
        5TFsT9ekX1Gqz0Uz00/2g3jA603zmmi/OjFSFgwVhFIfjaFiS1qKWOO2pASjuiD7OrXiBo2M1be
        r5B2Vt1/s5arGPcxANYaCSg==
X-Received: by 2002:a17:90b:1d0c:: with SMTP id on12mr11556395pjb.12.1629353228806;
        Wed, 18 Aug 2021 23:07:08 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJz3k4BalorVDXg9UQxkpFHoAGZcvhs1c3pqr4eJukZq0za9krzlFDhBa5+JTvsq0k77vxeqDg==
X-Received: by 2002:a17:90b:1d0c:: with SMTP id on12mr11556384pjb.12.1629353228617;
        Wed, 18 Aug 2021 23:07:08 -0700 (PDT)
Received: from localhost.localdomain ([49.207.198.118])
        by smtp.gmail.com with ESMTPSA id o24sm1663100pjs.49.2021.08.18.23.07.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Aug 2021 23:07:08 -0700 (PDT)
From:   Venky Shankar <vshankar@redhat.com>
To:     jlayton@redhat.com, pdonnell@redhat.com
Cc:     ceph-devel@vger.kernel.org, Venky Shankar <vshankar@redhat.com>
Subject: [PATCH 0/2] ceph: add debugfs entries signifying new mount syntax support
Date:   Thu, 19 Aug 2021 11:36:59 +0530
Message-Id: <20210819060701.25486-1-vshankar@redhat.com>
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
 net/ceph/debugfs.c           | 27 +++++++++++++++++++++++++--
 5 files changed, 61 insertions(+), 2 deletions(-)

-- 
2.27.0

