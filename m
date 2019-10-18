Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 83E30DCDB5
	for <lists+ceph-devel@lfdr.de>; Fri, 18 Oct 2019 20:15:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439738AbfJRSPQ (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 18 Oct 2019 14:15:16 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:52467 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726534AbfJRSPQ (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Fri, 18 Oct 2019 14:15:16 -0400
Received: by mail-wm1-f67.google.com with SMTP id r19so7113815wmh.2;
        Fri, 18 Oct 2019 11:15:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=n3NKpwHZkOEFHNIbvqcFrh3RQWv8EaJNYo1QjCedK0E=;
        b=W75ozr2WDnbyzQTiQfLsR84+WKZON9pmLMfjjWgv1/l6Vm8+Iv4IbDXwhSaP9HvPQF
         oUIRv1x2XrlZMvl6hApmaEAXWjKSXtjbOpgommc0wN6zF/LJRkgN7MyNJ3y/19f1f8R0
         yWGanlrCz1rM+dfTG0rmuSu7uuVNNiMmQJawHk7lDbykvqKR52eI9wfXvygbRopAZd1L
         Lo2OGJkdM1pcBAzhQwFADubxApWOS5FKirWoVVrP3O88hNFWNYiOPi9xsvHVsPRWy2b+
         wXb1BiXkiHNvTojfnwaX7i0m1UtdHjL4T1cdzMazmEo4DtpDU9cqhYPSro9IZaaLyAvC
         HUkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=n3NKpwHZkOEFHNIbvqcFrh3RQWv8EaJNYo1QjCedK0E=;
        b=igqmImVXen12zwDWyxtUxfzrORE+DPjc/VHprh77KWZayeN3Ac+mr1bcXZxJmrUX1h
         glZ1hQC/4K5ifnpMaepCQI/wSMukc5F/zb6XIRL1NC+VMAM03sLm8KeUAcIVfoTuyWeN
         +m//LxVpn5h+5nL8YMdGZeNrxGHk9gvgVYoyYyPYb7VN+cTD1lidfKYAJVaufb9CCXjY
         V30P7B/+7uvL1aGGlnjLn9EABCnBplcNAXP2RP1+GOgPIz15EuDJIvP04hD4qU988yp7
         3rxj+1L4Xa3+vd0f84i1zCHzAQNf5Qm/zTXIyftNXi3gu8415cvuSXke1K2NVkw9JlSG
         Gw4g==
X-Gm-Message-State: APjAAAUnxxWWaK5jfYJH7PZFC1uyHiB8AflX+iZfFte7mNwVEenx/iRN
        4IIWW6hIf1LpegkK+nLKHQl+iu2m
X-Google-Smtp-Source: APXvYqy5IJAeOrXuo1xmPcLJlXZgqBtb3eV+0AHL4D8UYkqBm8KSlpzMVCqHWB5n3BD4Q2eKqW14bQ==
X-Received: by 2002:a7b:c387:: with SMTP id s7mr8111350wmj.110.1571422512634;
        Fri, 18 Oct 2019 11:15:12 -0700 (PDT)
Received: from kwango.brq.redhat.com (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id k8sm8313196wrg.15.2019.10.18.11.15.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Oct 2019 11:15:11 -0700 (PDT)
From:   Ilya Dryomov <idryomov@gmail.com>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     ceph-devel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] Ceph fixes for 5.4-rc4
Date:   Fri, 18 Oct 2019 20:15:11 +0200
Message-Id: <20191018181511.8844-1-idryomov@gmail.com>
X-Mailer: git-send-email 2.19.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Hi Linus,

The following changes since commit 4f5cafb5cb8471e54afdc9054d973535614f7675:

  Linux 5.4-rc3 (2019-10-13 16:37:36 -0700)

are available in the Git repository at:

  https://github.com/ceph/ceph-client.git tags/ceph-for-5.4-rc4

for you to fetch changes up to 25e6be21230d3208d687dad90b6e43419013c351:

  rbd: cancel lock_dwork if the wait is interrupted (2019-10-15 17:43:15 +0200)

----------------------------------------------------------------
A future-proofing decoding fix from Jeff intended for stable and
a patch for a mostly benign race from Dongsheng.

----------------------------------------------------------------
Dongsheng Yang (1):
      rbd: cancel lock_dwork if the wait is interrupted

Jeff Layton (1):
      ceph: just skip unrecognized info in ceph_reply_info_extra

 drivers/block/rbd.c  |  9 ++++++---
 fs/ceph/mds_client.c | 21 +++++++++++----------
 2 files changed, 17 insertions(+), 13 deletions(-)
