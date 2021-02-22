Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C860321A50
	for <lists+ceph-devel@lfdr.de>; Mon, 22 Feb 2021 15:30:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231631AbhBVOZD (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 22 Feb 2021 09:25:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232041AbhBVOV6 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 22 Feb 2021 09:21:58 -0500
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46421C06178B;
        Mon, 22 Feb 2021 06:21:17 -0800 (PST)
Received: by mail-ej1-x630.google.com with SMTP id e13so26413628ejl.8;
        Mon, 22 Feb 2021 06:21:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Ekjo4rKlS9igYMaQMjtFAKeWa9l9vaEq+4QyGfDGcno=;
        b=eC360sHskqhl3gwfGLIJnXqlM0GAto3XOC0wi7V7MNj5UX4Aab0YIrrUJweHC950uH
         sDOt4MrXERUpqGDvNkqaeRsyGha+Rq1cR0mWXT43AQy+iFJwMAxiH0JjzEkVsclBEApJ
         +k8e7lbjAFtPLSuIsZFxV6cVbyVL2NKw1bNHH3GYM1ivgW0XvvjLwm9W+Mk607oP357f
         8xcv9wv+RmznsLd5n7X6iCZiuZI4xthYYLC0dy+k6K03IeGUAQECez7AhFtESWoauXi5
         dA8de99dcI3XLiaIJK4IVXz5BMq/dzsYvjN0CTAbygcjoO0KrNL19d50S1x3f07sb+zv
         /Bkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Ekjo4rKlS9igYMaQMjtFAKeWa9l9vaEq+4QyGfDGcno=;
        b=dPzrRrvIGOeV9QrBQ7ekSaYPUMY0CrLK+7GLeRKyeHi36oCWJmlSEt44Gid2IWfkHS
         RCf/x+Zv93EZXzXZdjs9gI/krCye4dwl3k5Xvb8LjyM8rxavdo/x2nPiSk+sSe+/25TL
         wZEMhM+MsVH7UPpXY/8rN4VZnYwJnfrzTc7mAy+CuvgXZ6zArc2mEZgM8ha4cJV8sYF6
         zl1Yjd3TfG5anaMZD6Ksmu0MjRvoD8lbIWySbK9p/tV6WzWNkHA3diudFRjFVubss9ZW
         BxhMh0TK8jiZMDs99Zs8D1qpHq7qZIROYLW3ltv30Go+h4YpvR3yzEZ29GjIP9mNd7GJ
         f65g==
X-Gm-Message-State: AOAM530PPZvt1TmH/E3UHVrnG+yWYUJceB0QuDpB3HPKHEqQU5eqTIQh
        2tz8Jt6CSnJxiWkEYcBv90y9xPVlj/U=
X-Google-Smtp-Source: ABdhPJyUgChX7hXrjLM3oYneyvHJbxCCLXbvnDErOnZBwkDAlFOSp0xs8kIFf30fbJhxUVm3sRYr7A==
X-Received: by 2002:a17:906:2b4e:: with SMTP id b14mr1896857ejg.467.1614003676095;
        Mon, 22 Feb 2021 06:21:16 -0800 (PST)
Received: from kwango.local (ip-94-112-132-16.net.upcbroadband.cz. [94.112.132.16])
        by smtp.gmail.com with ESMTPSA id l7sm10462072edv.50.2021.02.22.06.21.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Feb 2021 06:21:15 -0800 (PST)
From:   Ilya Dryomov <idryomov@gmail.com>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     ceph-devel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] Ceph updates for 5.12-rc1
Date:   Mon, 22 Feb 2021 15:21:07 +0100
Message-Id: <20210222142107.20046-1-idryomov@gmail.com>
X-Mailer: git-send-email 2.19.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Hi Linus,

The following changes since commit f40ddce88593482919761f74910f42f4b84c004b:

  Linux 5.11 (2021-02-14 14:32:24 -0800)

are available in the Git repository at:

  https://github.com/ceph/ceph-client.git tags/ceph-for-5.12-rc1

for you to fetch changes up to 558b4510f622a3d96cf9d95050a04e7793d343c7:

  ceph: defer flushing the capsnap if the Fb is used (2021-02-16 12:09:52 +0100)

----------------------------------------------------------------
With netfs helper library and fscache rework delayed, just a few cap
handling improvements to avoid grabbing mmap_lock in some code paths
and deal with capsnaps better and a mount option cleanup.

----------------------------------------------------------------
Ilya Dryomov (2):
      libceph: deprecate [no]cephx_require_signatures options
      libceph: remove osdtimeout option entirely

Jeff Layton (3):
      ceph: fix flush_snap logic after putting caps
      ceph: clean up inode work queueing
      ceph: allow queueing cap/snap handling after putting cap references

Xiubo Li (1):
      ceph: defer flushing the capsnap if the Fb is used

 fs/ceph/addr.c               |  2 +-
 fs/ceph/caps.c               | 70 +++++++++++++++++++++++++++++++-------------
 fs/ceph/inode.c              | 61 ++++++++------------------------------
 fs/ceph/snap.c               | 10 +++++++
 fs/ceph/super.h              | 40 +++++++++++++++++++++----
 include/linux/ceph/libceph.h |  7 ++---
 net/ceph/ceph_common.c       | 17 ++++-------
 7 files changed, 115 insertions(+), 92 deletions(-)
