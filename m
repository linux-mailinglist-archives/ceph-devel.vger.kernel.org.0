Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5076D11D617
	for <lists+ceph-devel@lfdr.de>; Thu, 12 Dec 2019 19:44:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730444AbfLLSoR (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 12 Dec 2019 13:44:17 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:43615 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730400AbfLLSoR (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 12 Dec 2019 13:44:17 -0500
Received: by mail-wr1-f65.google.com with SMTP id d16so3848882wre.10;
        Thu, 12 Dec 2019 10:44:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=5DKpgH8XAvi3uA/mISb+fZKoyXnYonlOHAe7V1uGxoE=;
        b=nhJMtdHAGaGjkw2xvo1YkJMwUtNAion8YJTDLtnPbocPLXhvIlE+MEgTdXFBqPidTX
         icSEhQYwhGARMdwJcJ14WnnQtNIFaHCW6o9VLbL97/ZGOynr1xS2L63QfNeQBba03FWl
         Ij/CZVfkXUDM0Kg3hUWaEVVZS1iKkpc21lUEDea6kM/TGbwtuDfRhXh28aUzW10c25VP
         SjRwzGqO6E/t0KXVHwIIzc8FXmyiOQnD44lRXKZmw4bQmU4toWl5YUAiPi9Bb/kRoxsY
         8dJynUIEvHqnosW1APwgAntrLVNG5jJorKKVpBGsfaCOUCobs/lT5/PBLwb/I2IeWCwo
         wqxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=5DKpgH8XAvi3uA/mISb+fZKoyXnYonlOHAe7V1uGxoE=;
        b=Tl3tH/D92jK5MA72Egv3G1WLN2RMEA+6o7nXOJFsBAJEtR3HqOmqnbPsLYw0JxhM3P
         j3XiCilYE8fhx89DpYWjhM5pREU1yPkFUwQ4FvCOdWBesB63pCYpNb6IYJabD6O/QqDP
         ob+GNGpAZNWrvJ3U7fpoWOFUeOsLoDZ6keVSUu7AZwrMfVsX6elFHfvrfGiF0aZbeVfo
         QAnOktvpTc2NRYcq4zQdFCYmkEaoPnopDfDIhtQKACC5O6DcMTKq5ui7LhYJQsvDGIGr
         cdnb4kxaJhEriaTWIpJNCJYOSQxz2OfMio+iOTv5NOLUaCNzi1aKJctQSDFALGRaRQsn
         A0sA==
X-Gm-Message-State: APjAAAUqFTvRyRVsuLE/idATnXVvcHrAumInwuQ1HU1BqfUt+rij3yF1
        QmsfPvFFvHhtCawJW6bzIpQ=
X-Google-Smtp-Source: APXvYqyuQOSGLR6/IBab/w6lPDb1uX2GY2FBp9dNcex+KPlzE9sVx24oZImN1D/YwW2KKoKQqGJJVQ==
X-Received: by 2002:a5d:62d0:: with SMTP id o16mr7725210wrv.197.1576176255053;
        Thu, 12 Dec 2019 10:44:15 -0800 (PST)
Received: from kwango.redhat.com (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id p15sm2305631wma.40.2019.12.12.10.44.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Dec 2019 10:44:14 -0800 (PST)
From:   Ilya Dryomov <idryomov@gmail.com>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     ceph-devel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] Ceph fixes for 5.5-rc2
Date:   Thu, 12 Dec 2019 19:43:56 +0100
Message-Id: <20191212184356.7143-1-idryomov@gmail.com>
X-Mailer: git-send-email 2.19.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Hi Linus,

The following changes since commit e42617b825f8073569da76dc4510bfa019b1c35a:

  Linux 5.5-rc1 (2019-12-08 14:57:55 -0800)

are available in the Git repository at:

  https://github.com/ceph/ceph-client.git tags/ceph-for-5.5-rc2

for you to fetch changes up to da08e1e1d7c3f805f8771ad6a6fd3a7a30ba4fe2:

  ceph: add more debug info when decoding mdsmap (2019-12-09 20:55:10 +0100)

----------------------------------------------------------------
A fix to avoid a corner case when scheduling cap reclaim in batches
from Xiubo, a patch to add some observability into cap waiters from
Jeff and a couple of cleanups.

----------------------------------------------------------------
Jeff Layton (2):
      ceph: convert int fields in ceph_mount_options to unsigned int
      ceph: show tasks waiting on caps in debugfs caps file

Xiubo Li (3):
      ceph: trigger the reclaim work once there has enough pending caps
      ceph: switch to global cap helper
      ceph: add more debug info when decoding mdsmap

 fs/ceph/caps.c       | 41 +++++++++++++++++++++++++++--------------
 fs/ceph/debugfs.c    | 13 +++++++++++++
 fs/ceph/mds_client.c |  8 +++++---
 fs/ceph/mds_client.h |  9 +++++++++
 fs/ceph/mdsmap.c     | 12 ++++++++----
 fs/ceph/super.c      | 28 +++++++++++++++-------------
 fs/ceph/super.h      | 16 ++++++++--------
 7 files changed, 85 insertions(+), 42 deletions(-)
