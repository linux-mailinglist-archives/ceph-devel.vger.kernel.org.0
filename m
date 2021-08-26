Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D003E3F8B58
	for <lists+ceph-devel@lfdr.de>; Thu, 26 Aug 2021 17:52:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242973AbhHZPwr (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 26 Aug 2021 11:52:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230203AbhHZPwr (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 26 Aug 2021 11:52:47 -0400
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84634C061757;
        Thu, 26 Aug 2021 08:51:59 -0700 (PDT)
Received: by mail-wr1-x42f.google.com with SMTP id z4so5827822wrr.6;
        Thu, 26 Aug 2021 08:51:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=wE8pOF+CHNbYLFAWyiFAE2bL1C1N8UI/VrhKuLFFvUQ=;
        b=Cg1IjsLge76KmPcWWIdMdj4bzm2XHPccNYk4S1WCmtvcIk6ErdVSEIzRvTbqpRl+gQ
         9ljpXWFJIAypQD1OsnAZrntDrMBHw8NgVB9TBpvmT//YgmquMVOoO+bgMqxIEr2Was0+
         9rpFA/eFGe/AxRwzeRLPnS7FVB6fK3E80/VtTeE+y6jWcVQXIpviCowfOb6wSzu0Alnf
         OwrDslr7eqM0iVvJBT12xJkHjtJxq7Nh1bwobBoEoBtz1ABtD3nvtXuT7N1+erLGEXRT
         b4EZIN3I6zg19Y8tjTQOwwcf01Kgu1j9+AnlgqPYrrGrLo0j/NnzxXlfm64I93R5Qin4
         CDNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=wE8pOF+CHNbYLFAWyiFAE2bL1C1N8UI/VrhKuLFFvUQ=;
        b=sY/8uBvOlCe/KekC94NGI5+talef5vuPnoVAkuDPIJtMUJgtE6mfQ3a+16/ekHrq0r
         z1uLq7hakZK+P/Khwi2NnAb9YBKZZ3HEcEqo7NGq4fCokK1ZxI0A6FAJhSGUE8fYMuaj
         wQvRtXI2I6yK+7MQwA/yiu7gXU9SAjVppCdaVxKmEnQEGHXhGI2YTDdtfYYCaUBOocXQ
         0sx9t+PZBpLhtpyrmJ1zvx/JVrmc66YVK1Zvt0iijzNvUoU43dTKQp/yqcUvumxD5tbZ
         z6Q+XoRxKTKGvPlxfbqaWlOqds7xvfI09K2nAzRer5kzurrnSSfN8DIaZQ3jFTCBqGvo
         GY4w==
X-Gm-Message-State: AOAM532DPszkgj73PtTntylBW1Ikxj8kRpKTyQf1d4WxFSS0Tx7sykUQ
        GmbVIXEwrxE0ywcctyUHnNk=
X-Google-Smtp-Source: ABdhPJw0cNDZ2+Fiu+u9/qgSuVqKd96nL6YFH8B32y8Cgkg2BJTHTx8MaUYW2HNRmvZ+luFGJSw0Ug==
X-Received: by 2002:adf:fc4f:: with SMTP id e15mr4792648wrs.95.1629993118134;
        Thu, 26 Aug 2021 08:51:58 -0700 (PDT)
Received: from kwango.redhat.com (ip-94-112-171-183.net.upcbroadband.cz. [94.112.171.183])
        by smtp.gmail.com with ESMTPSA id r1sm3723770wmh.17.2021.08.26.08.51.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Aug 2021 08:51:57 -0700 (PDT)
From:   Ilya Dryomov <idryomov@gmail.com>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     ceph-devel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] Ceph fixes for 5.14-rc8
Date:   Thu, 26 Aug 2021 17:51:42 +0200
Message-Id: <20210826155142.31960-1-idryomov@gmail.com>
X-Mailer: git-send-email 2.19.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Hi Linus,

The following changes since commit e22ce8eb631bdc47a4a4ea7ecf4e4ba499db4f93:

  Linux 5.14-rc7 (2021-08-22 14:24:56 -0700)

are available in the Git repository at:

  https://github.com/ceph/ceph-client.git tags/ceph-for-5.14-rc8

for you to fetch changes up to a9e6ffbc5b7324b6639ee89028908b1e91ceed51:

  ceph: fix possible null-pointer dereference in ceph_mdsmap_decode() (2021-08-25 16:34:11 +0200)

----------------------------------------------------------------
Two memory management fixes for the filesystem.

----------------------------------------------------------------
Tuo Li (1):
      ceph: fix possible null-pointer dereference in ceph_mdsmap_decode()

Xiubo Li (1):
      ceph: correctly handle releasing an embedded cap flush

 fs/ceph/caps.c       | 21 +++++++++++++--------
 fs/ceph/mds_client.c |  7 ++++---
 fs/ceph/mdsmap.c     |  8 +++++---
 fs/ceph/snap.c       |  3 +++
 fs/ceph/super.h      |  3 ++-
 5 files changed, 27 insertions(+), 15 deletions(-)
