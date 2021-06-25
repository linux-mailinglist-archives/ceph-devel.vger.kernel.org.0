Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4CB923B4564
	for <lists+ceph-devel@lfdr.de>; Fri, 25 Jun 2021 16:18:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231215AbhFYOU5 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 25 Jun 2021 10:20:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229890AbhFYOU5 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Fri, 25 Jun 2021 10:20:57 -0400
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 554ECC061766;
        Fri, 25 Jun 2021 07:18:36 -0700 (PDT)
Received: by mail-ed1-x52a.google.com with SMTP id i5so13665803eds.1;
        Fri, 25 Jun 2021 07:18:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=cOJFOmdUHROkGGL9o10HPT7caFmqQTrAZfZPgAMOXMY=;
        b=TglVHwMg4uxf/q+kt0ufs/84wvpSEKPe+10V/NrFk2X1yUvMwMF+JSfrmKFvwHX8El
         gXPrku8HXmJauilGQmTi+iOyTl0qFrVxuvCLur/qRYa3PX6CfiTxjsepvKbI4AWLudAV
         zCGVis2POx654+AyySjVeBZOKXUs6liDFEsHx6eOrNjawjrFBYRCwSAPJn2h4MpHR+p5
         qFfyz/HJwKfJNDgChKoGmJjsUZ1jt0qFjBbPHgptP9nxL1jo0JQDq1koLyLM50F3vRkx
         ptasxbOfJ1LBZrxb2TG0mesQOk3gsBWn9iuHV65Q+fN7y8owKqolZHaC8BDx3R0puJna
         yF/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=cOJFOmdUHROkGGL9o10HPT7caFmqQTrAZfZPgAMOXMY=;
        b=h6Ty0vgHoGAoR99oiv9J/T4DWw1BQzVrdtCyI5zLnxdJZWBXRi0U6sdZb4xBbBc7iG
         4Imgyz7DtPwpLVmWOGn1bUj6ZsvN82aO33skcXztiUrKxqWUoAocmnZV+z2hd27naFzo
         ltZqnZImna1FcHQE0baQseZHRilLC8MhAyrKlLhctafiHaLiFiPEnW2IXohcYsAlWvGX
         /16s8ymOyW8bAEFE56CmKOpJPYa+qp7e1Nv7UOq1NSYlee0jvnFp/VYV+euZSOQnUnqz
         jqPU9eefQ6xfZYO+ZKcgyyiI80zgy3thabLAXnEwETC3FcM9InWm8iusQBOwWkZaLm2c
         b/dg==
X-Gm-Message-State: AOAM532wEFW8fayXskTcry9X+IGM7RSBQjh/8kX2GOh0aE1QsdPddOBb
        u4FOkywoBNEEsRoVpbSMQyVsLr3Bx3EFfQ==
X-Google-Smtp-Source: ABdhPJxYEE/E3N2i9Vkg4vuc3ufDB1asf8c1oDqCW5/6Ny3eb7M4NBXxolJUCFmqpqDqFn/czV96lg==
X-Received: by 2002:a05:6402:451:: with SMTP id p17mr11965437edw.332.1624630714949;
        Fri, 25 Jun 2021 07:18:34 -0700 (PDT)
Received: from kwango.redhat.com (ip-94-112-132-16.net.upcbroadband.cz. [94.112.132.16])
        by smtp.gmail.com with ESMTPSA id v8sm3925561edc.59.2021.06.25.07.18.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Jun 2021 07:18:34 -0700 (PDT)
From:   Ilya Dryomov <idryomov@gmail.com>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     ceph-devel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] Ceph fixes for 5.13-rc8
Date:   Fri, 25 Jun 2021 16:18:23 +0200
Message-Id: <20210625141823.22507-1-idryomov@gmail.com>
X-Mailer: git-send-email 2.19.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Hi Linus,

The following changes since commit 13311e74253fe64329390df80bed3f07314ddd61:

  Linux 5.13-rc7 (2021-06-20 15:03:15 -0700)

are available in the Git repository at:

  https://github.com/ceph/ceph-client.git tags/ceph-for-5.13-rc8

for you to fetch changes up to 03af4c7bad8ca59143bca488b90b3775d10d7f94:

  libceph: set global_id as soon as we get an auth ticket (2021-06-24 21:03:17 +0200)

----------------------------------------------------------------
Two -rc1 regression fixes: one in the auth code affecting old clusters
and one in the filesystem for proper propagation of MDS request errors.
Also included a locking fix for async creates, marked for stable.

----------------------------------------------------------------
Ilya Dryomov (2):
      libceph: don't pass result into ac->ops->handle_reply()
      libceph: set global_id as soon as we get an auth ticket

Jeff Layton (2):
      ceph: must hold snap_rwsem when filling inode for async create
      ceph: fix error handling in ceph_atomic_open and ceph_lookup

 fs/ceph/dir.c             | 22 ++++++++++++----------
 fs/ceph/file.c            | 17 +++++++++++------
 fs/ceph/inode.c           |  2 ++
 fs/ceph/super.h           |  2 +-
 include/linux/ceph/auth.h |  4 +++-
 net/ceph/auth.c           | 20 +++++++++++---------
 net/ceph/auth_none.c      |  5 +++--
 net/ceph/auth_x.c         | 15 +++++++--------
 8 files changed, 50 insertions(+), 37 deletions(-)
