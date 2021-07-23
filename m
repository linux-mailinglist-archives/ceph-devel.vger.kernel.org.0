Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38F833D3DA2
	for <lists+ceph-devel@lfdr.de>; Fri, 23 Jul 2021 18:32:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230094AbhGWPwN (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 23 Jul 2021 11:52:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229492AbhGWPwN (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Fri, 23 Jul 2021 11:52:13 -0400
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 771E1C061575;
        Fri, 23 Jul 2021 09:32:46 -0700 (PDT)
Received: by mail-wm1-x329.google.com with SMTP id k4so1149146wms.3;
        Fri, 23 Jul 2021 09:32:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=F0GRC2vCVuYYISF15psvUoO8rQlr2seRikFny4zHVB0=;
        b=Zbup/Tx34T0/+2pJnKKTxzocIWMqFdeIoCZ3I0rG6XBuIxx7rF4pY5vbh/pSlczLuW
         ow6+AtzRLZOHqWEbYlnb4ig9i2ApxNVlCpA2lulsmUJku02IsZUxMKmybGQAB/pQL0rM
         X7c/yuy2w/s+7YLgFU6KKOv6dLMEfYOQ3IzhzpcMaoYp098Y6p9bVrw+ec7wk3zimfe5
         nKqznRoOumkfnwVyN/ve7zZ6Rj/y3OX3R4LMsPAVktmD3hLq/oSks9EX6a6JJ1dWCRqE
         /MIZCxzBO8CX/9vxNFRFmAPrnrePK5+zkX5Vj/7pvPFmLTiQkI4yArT4rNfh/bYtgg9N
         ZsuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=F0GRC2vCVuYYISF15psvUoO8rQlr2seRikFny4zHVB0=;
        b=JJeW+HUnieZek/zNAl79VB0oSMfJOx4Q3Abo7rb7dIX1z92M3yk4o8WPPuA3p4bx7s
         O2+CFjczf9v2uD2gXPAGQ4ylOMCqmnC09IPXm17J2dE/ArN8rieEtjMsUVDw31pwct6w
         jDEQ/owU8Bm9yexin3LYVWUg8Tt0vQw6WDJGmyVZRCgC02+jOaaaIiUv5kekjvub9oZq
         gEyJaTnE9tvo09NNKh1mT286wFUB286EsOtUFbt2Fbz2SXyxVsr4pwSmrlCTdlunwLnC
         +Lmbb4Q5lbNMCv11jZO24l79oyAu+99eVhwd0w6j9Um14AaqOcqN2ScepBfudh47x6WN
         FnKw==
X-Gm-Message-State: AOAM531aTEkory/3TQSMHCgXRaW3rkr2Px0TZ3TEUD/s/XHq7+FzXgED
        O16MoPrL/tqdTsozkgAzTaG/NsKhtQscWg==
X-Google-Smtp-Source: ABdhPJyugzIJcupJ2VMsg8dA2AhNrYxq1odU1qtNcrk7N2umvqkzNzBeli1khkAhVyhRAWovDFewYA==
X-Received: by 2002:a05:600c:4a17:: with SMTP id c23mr5406064wmp.7.1627057965156;
        Fri, 23 Jul 2021 09:32:45 -0700 (PDT)
Received: from kwango.redhat.com (ip-94-112-137-87.net.upcbroadband.cz. [94.112.137.87])
        by smtp.gmail.com with ESMTPSA id r19sm35800641wrg.74.2021.07.23.09.32.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Jul 2021 09:32:44 -0700 (PDT)
From:   Ilya Dryomov <idryomov@gmail.com>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     ceph-devel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] Ceph fixes for 5.14-rc3
Date:   Fri, 23 Jul 2021 18:32:11 +0200
Message-Id: <20210723163211.8436-1-idryomov@gmail.com>
X-Mailer: git-send-email 2.19.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Hi Linus,

The following changes since commit 2734d6c1b1a089fb593ef6a23d4b70903526fe0c:

  Linux 5.14-rc2 (2021-07-18 14:13:49 -0700)

are available in the Git repository at:

  https://github.com/ceph/ceph-client.git tags/ceph-for-5.14-rc3

for you to fetch changes up to 0077a50082729c3f9ea2836f59e35d9b7dacfb12:

  rbd: resurrect setting of disk->private_data in rbd_init_disk() (2021-07-21 17:20:43 +0200)

----------------------------------------------------------------
rbd fixes for a -rc1 regression and a subtle deadlock on lock_rwsem
(marked for stable).  Also included a rare WARN condition tweak.

----------------------------------------------------------------
Ilya Dryomov (3):
      rbd: always kick acquire on "acquired" and "released" notifications
      rbd: don't hold lock_rwsem while running_list is being drained
      rbd: resurrect setting of disk->private_data in rbd_init_disk()

Luis Henriques (1):
      ceph: don't WARN if we're still opening a session to an MDS

 drivers/block/rbd.c  | 33 +++++++++++++--------------------
 fs/ceph/mds_client.c |  2 +-
 2 files changed, 14 insertions(+), 21 deletions(-)
