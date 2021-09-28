Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF99641A8A7
	for <lists+ceph-devel@lfdr.de>; Tue, 28 Sep 2021 08:07:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239113AbhI1GJb (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 28 Sep 2021 02:09:31 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:46626 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239796AbhI1GId (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Tue, 28 Sep 2021 02:08:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1632809211;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=8oP+Dmt5bILOEf+eMBT2DNNyBk9WHdZfPEYNJyKc44g=;
        b=HI5CXpy46oC8QgZ/7HLHrCPaXh4jsZ+8D7JrcK1fTdTw+Fz9Jyw6jYsaEREl6HqQ5Hxw+w
        cIncKYAfis2AiZPa7eYzJaYpb9ARrQW+E2IgzYLM1+GdYFZCmfWI+12f+19fd6WsXlHYyc
        QM55+Z4uRr+d5PY12cDUY0blUCPFFZg=
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com
 [209.85.214.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-211-OLXDzWpWOuSk_MLf93exfg-1; Tue, 28 Sep 2021 02:06:47 -0400
X-MC-Unique: OLXDzWpWOuSk_MLf93exfg-1
Received: by mail-pl1-f199.google.com with SMTP id c10-20020a170902aa4a00b0013b8ac279deso7681921plr.9
        for <ceph-devel@vger.kernel.org>; Mon, 27 Sep 2021 23:06:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=8oP+Dmt5bILOEf+eMBT2DNNyBk9WHdZfPEYNJyKc44g=;
        b=tD9kIlrvDj362tQbFLtcrObZYGL+/1415/D/exg0xDKLy1r9Mt8QmBZGPb8L5uFGzO
         hSWfeCL2MphjWjnUGEeaz4/vOAwbpRDAoPy5g0m6RXHu3e59Hda1SmlXbJui62W/+tOb
         DiDIy3yI97f3+DzX6tiVu1jK8TqndECjAQuh+VfqeXuhSGePZB0Yv6C8q1x5hlUj2Wzu
         jS7mVocc0idsRBJdB0FtVsOOueU8TP1ZXUrOwl30xfzCF5n4nObwCuZFI8psg8SC6gqM
         /qVoNK+xa/rNaudDa7d4tYwxhH2O799e5dWUM/V+ZkQw3+VgxbD9rg9OmY19hJoZrsfW
         hVOg==
X-Gm-Message-State: AOAM530xS6stYhyt9XPHerN2BPnF2EjFrxeatSV4GBqfTcqfA6vj1aRY
        ZMHCF5MO9BE88YbHB7bEyT16PvzTT/0TWDHLOhWe3FFmOMP3S2t/DiZzdvaUDYwPcjL5kmu88CR
        dsUaQrCskX2VzoF4eSjD3Tg==
X-Received: by 2002:a17:90a:b706:: with SMTP id l6mr3559844pjr.200.1632809206376;
        Mon, 27 Sep 2021 23:06:46 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJy5cgQpYTyaMYKWNxDXTJG45H2IQPyo7iXfArwvlN8qMnK4T1MSIMs9Q/PDclCfZ/LOF8LY8Q==
X-Received: by 2002:a17:90a:b706:: with SMTP id l6mr3559814pjr.200.1632809206019;
        Mon, 27 Sep 2021 23:06:46 -0700 (PDT)
Received: from localhost.localdomain ([49.207.212.118])
        by smtp.gmail.com with ESMTPSA id v6sm18855862pfv.83.2021.09.27.23.06.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Sep 2021 23:06:45 -0700 (PDT)
From:   Venky Shankar <vshankar@redhat.com>
To:     jlayton@redhat.com, pdonnell@redhat.com
Cc:     ceph-devel@vger.kernel.org, Venky Shankar <vshankar@redhat.com>
Subject: [PATCH v3 0/2] ceph: add debugfs entries signifying new mount syntax support
Date:   Tue, 28 Sep 2021 11:36:31 +0530
Message-Id: <20210928060633.349231-1-vshankar@redhat.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

v3:
 - create mount syntax debugfs entries under /<>/ceph/meta/client_features directory
 - mount syntax debugfs file names are v1, v2,... (were v1_mount_sytnax,... earlier)

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
    /sys/kernel/debug/ceph/meta
    /sys/kernel/debug/ceph/meta/client_features
    /sys/kernel/debug/ceph/meta/client_features/v2
    /sys/kernel/debug/ceph/meta/client_features/v1
    ....
    ....

Venky Shankar (2):
  libceph: export ceph_debugfs_dir for use in ceph.ko
  ceph: add debugfs entries for mount syntax support

 fs/ceph/debugfs.c            | 41 ++++++++++++++++++++++++++++++++++++
 fs/ceph/super.c              |  3 +++
 fs/ceph/super.h              |  2 ++
 include/linux/ceph/debugfs.h |  2 ++
 net/ceph/debugfs.c           |  3 ++-
 5 files changed, 50 insertions(+), 1 deletion(-)

-- 
2.27.0

