Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5B8289AF4C
	for <lists+ceph-devel@lfdr.de>; Fri, 23 Aug 2019 14:25:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394646AbfHWMYn (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 23 Aug 2019 08:24:43 -0400
Received: from mail-wr1-f47.google.com ([209.85.221.47]:41767 "EHLO
        mail-wr1-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726693AbfHWMYn (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Fri, 23 Aug 2019 08:24:43 -0400
Received: by mail-wr1-f47.google.com with SMTP id j16so8449077wrr.8;
        Fri, 23 Aug 2019 05:24:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=wiaJeoINtiSICNo40sR0gJx/Ynv/1TJk6w2DUAYNCpU=;
        b=a1NACfxlQgrNVmC62tfL0Et+m4j7biyPT8R5CU/uFo5ieZbNzthwLDf5Vxu//V45ZS
         RUiyPLr+lRM3VdTt4uPVVugMT9aRDC2VJmONOV7QhVy/2crJviKh5GtJHy71Bm7zMpeA
         jBgu9sPHV64Pi2enAD4HBjuT0JMr7g9tVfiytv6MrMrNlyDvNpN+zz5NQhnEColnSCMd
         E5DxWyuVPShysSplhnPohSeKrImNAycMalN/n6P84oOWpTxQcVHQrzkorDbqSArvEu2c
         +JO2GYbiH5mmI3H7Ifh7BxOU2kY/zTBKaVHeIEnxIDlaN+0QRnD/qK9chMn99WC59TOm
         AAaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=wiaJeoINtiSICNo40sR0gJx/Ynv/1TJk6w2DUAYNCpU=;
        b=di3JOtthUUD/pc3DkqDRckQdpR5HxdFPNkeh7DnAh1GpW3h2klWhiojlGFtmkAQZ4D
         aWMd10g3043jgYntZIEAGfDn9GNFn36MM5Lcno1qfzBi3TqLpQQPZQ7hRKO94T72JpiG
         mzVwTm2igGLiaU8Zr+4OY74lLMqU6824CP1FFyJ0SwMP9lWYtU9NKsG+oXYrRMdzA+Yd
         5EkBLkOZjA4vStfGhIEYLIsVDFmEBlypq8DgYnN7WlMwDHOJJV4Mo//Mgo37X1S1PpVY
         4vTuXGqBlT3aq2/cE4tkKR8MAj22pvHl6AT4TbOEo6kUZvV3UN2CT3Pt+FqzK1bpOhjf
         hocQ==
X-Gm-Message-State: APjAAAXTymhBMOA54OoAXIeTgnGOVFr9BOw6On/cdyr0/qXpuupJye+y
        inLqHs8adGsEHaYbxUzyhXGdd1Pi
X-Google-Smtp-Source: APXvYqwV3zXMN/kB/O/gm41ckO0LFZH2k93XMfy/JiFxnwXM6vOgM+oWQTxHyjLWCTnFqH8pn04nEg==
X-Received: by 2002:a5d:4a0e:: with SMTP id m14mr1216257wrq.72.1566563080830;
        Fri, 23 Aug 2019 05:24:40 -0700 (PDT)
Received: from kwango.redhat.com (ip-94-112-128-92.net.upcbroadband.cz. [94.112.128.92])
        by smtp.gmail.com with ESMTPSA id o9sm3537278wrm.88.2019.08.23.05.24.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Aug 2019 05:24:39 -0700 (PDT)
From:   Ilya Dryomov <idryomov@gmail.com>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     ceph-devel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] Ceph fixes for 5.3-rc6
Date:   Fri, 23 Aug 2019 14:27:26 +0200
Message-Id: <20190823122726.15050-1-idryomov@gmail.com>
X-Mailer: git-send-email 2.19.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Hi Linus,

The following changes since commit d1abaeb3be7b5fa6d7a1fbbd2e14e3310005c4c1:

  Linux 5.3-rc5 (2019-08-18 14:31:08 -0700)

are available in the Git repository at:

  https://github.com/ceph/ceph-client.git tags/ceph-for-5.3-rc6

for you to fetch changes up to a561372405cf6bc6f14239b3a9e57bb39f2788b0:

  libceph: fix PG split vs OSD (re)connect race (2019-08-22 10:47:41 +0200)

----------------------------------------------------------------
Three important fixes tagged for stable (an indefinite hang, a crash on
an assert and a NULL pointer dereference) plus a small series from Luis
fixing instances of vfree() under spinlock.

----------------------------------------------------------------
Erqi Chen (1):
      ceph: clear page dirty before invalidate page

Ilya Dryomov (1):
      libceph: fix PG split vs OSD (re)connect race

Jeff Layton (1):
      ceph: don't try fill file_lock on unsuccessful GETFILELOCK reply

Luis Henriques (4):
      libceph: allow ceph_buffer_put() to receive a NULL ceph_buffer
      ceph: fix buffer free while holding i_ceph_lock in __ceph_setxattr()
      ceph: fix buffer free while holding i_ceph_lock in __ceph_build_xattrs_blob()
      ceph: fix buffer free while holding i_ceph_lock in fill_inode()

 fs/ceph/addr.c              |  5 +++--
 fs/ceph/caps.c              |  5 ++++-
 fs/ceph/inode.c             |  7 ++++---
 fs/ceph/locks.c             |  3 +--
 fs/ceph/snap.c              |  4 +++-
 fs/ceph/super.h             |  2 +-
 fs/ceph/xattr.c             | 19 ++++++++++++++-----
 include/linux/ceph/buffer.h |  3 ++-
 net/ceph/osd_client.c       |  9 ++++-----
 9 files changed, 36 insertions(+), 21 deletions(-)
