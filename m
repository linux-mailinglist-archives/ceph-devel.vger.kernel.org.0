Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF3F441E702
	for <lists+ceph-devel@lfdr.de>; Fri,  1 Oct 2021 07:00:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230500AbhJAFCd (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 1 Oct 2021 01:02:33 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:30416 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230397AbhJAFCc (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Fri, 1 Oct 2021 01:02:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1633064448;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=vhj39lJPuTGUXr1hPtNV6d39E/E5yYHsSwmsCE9q4fI=;
        b=RRrI17YqgkWjuy8qggXXcs6vqtLgr7MKIVd3FXvUmuNi4/mdJNxjiTqDgVzxP6DTEpjpc7
        TIDlD6hgrqtz45b3Q3cU/vqYGqm+ZWPuaMai0FL9x180YawLKSNQ2jTAfDK0fs2cG9MDkm
        lH6PKMXwQF99J+wpObWbRJkVqt3bPt8=
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com
 [209.85.216.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-281-qAr6DmunPm2erJkur1sN2g-1; Fri, 01 Oct 2021 01:00:47 -0400
X-MC-Unique: qAr6DmunPm2erJkur1sN2g-1
Received: by mail-pj1-f71.google.com with SMTP id bp19-20020a17090b0c1300b0019f715503e0so913570pjb.5
        for <ceph-devel@vger.kernel.org>; Thu, 30 Sep 2021 22:00:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=vhj39lJPuTGUXr1hPtNV6d39E/E5yYHsSwmsCE9q4fI=;
        b=Jc9x6xU7JHNnH/JxvNRlV6XWXn2tpeJaGff8YxAk38Ywrj4OqC4IJoJ9KxjbJUkZ5t
         ikDVUuYgsQAarhKldO3MhV+Oz5mlb8YpcC3eQU79gpZLMWigqQdRbLpbgLjIoFSr33EH
         aLKFzGZP0t0wW7zUbZYVZGEJxsDrFMo88vW5PCe3GOwPkOtSpEYyRATAIqXX7q+N+X/y
         LkYVomB5bnFNi/osQ9zaafzCZREOA4aDyQN13QprvrYSjU6C6rbmu0pJN7J4jmeQ6nvu
         dtgnWQzg0cq0drLBiKlBsM2X97vHR0KhCdiQuzaK2637To4klHZxMIsf56mLNntvn103
         1eWQ==
X-Gm-Message-State: AOAM531QcmWOA23laCy2wNPWUGPeXVdj0flu5SGQiN6SLH3IeKcBb4RQ
        hHfENa34MvJoZd2XgOxab919aIMlyhzdAS5AvIuJyyl0gPXKTOgWZm0qb/dHwRUD11Pfxp/AFHJ
        QJV+rf5yQoskvcsYfEVF/1w==
X-Received: by 2002:a63:9752:: with SMTP id d18mr8083744pgo.320.1633064446167;
        Thu, 30 Sep 2021 22:00:46 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJz7NoRUJ5Por4ZmKcpyf1g01hIkm3Hnh+miuKxJozmqEgmBmTZV4K6/hZ4kSEdokSNrxMPLkA==
X-Received: by 2002:a63:9752:: with SMTP id d18mr8083730pgo.320.1633064445901;
        Thu, 30 Sep 2021 22:00:45 -0700 (PDT)
Received: from localhost.localdomain ([49.207.221.217])
        by smtp.gmail.com with ESMTPSA id s3sm6377485pjr.1.2021.09.30.22.00.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Sep 2021 22:00:45 -0700 (PDT)
From:   Venky Shankar <vshankar@redhat.com>
To:     jlayton@redhat.com, pdonnell@redhat.com
Cc:     ceph-devel@vger.kernel.org, Venky Shankar <vshankar@redhat.com>
Subject: [PATCH v4 0/2] ceph: add debugfs entries signifying new mount syntax support
Date:   Fri,  1 Oct 2021 10:30:35 +0530
Message-Id: <20211001050037.497199-1-vshankar@redhat.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

v4:
  - use mount_syntax_v1,.. as file names

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
    /sys/kernel/debug/ceph/meta/client_features/mount_syntax_v2
    /sys/kernel/debug/ceph/meta/client_features/mount_syntax_v1
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

