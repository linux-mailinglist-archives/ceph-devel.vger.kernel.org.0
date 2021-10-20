Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B93F2435273
	for <lists+ceph-devel@lfdr.de>; Wed, 20 Oct 2021 20:14:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230245AbhJTSQ2 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 20 Oct 2021 14:16:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231220AbhJTSQX (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 20 Oct 2021 14:16:23 -0400
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C000C061749;
        Wed, 20 Oct 2021 11:14:08 -0700 (PDT)
Received: by mail-ed1-x52c.google.com with SMTP id t16so515310eds.9;
        Wed, 20 Oct 2021 11:14:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=D86vPfvEkgcUScB/XB8pymgB1woMrZbE8snC97v/yWM=;
        b=oo9STmrgQyzY3VmgKrvTpqcfU2voaWLDZ+jNaD1KHuBWU9mAkWh4FhkTD2OYlU0lCZ
         tsibwB18P+cQOtUqhwgwa++Q/CHo6eUcEhLbCBjVZY5jx0kiSZFN+sT6kSmVCjnH2IIs
         RBPFOcriayIWxE+GlRrPi18VHRqglwh9M1Hp9K2XAc0wGzOF1wR1BTPmxJxw7mwGkCIF
         A/MznKVzqw4of3i4bKNjg9Fa3N6MObZUvcf1kc3EPpf2KbUZvApmHUr6f3B+rFThMhQT
         JAOiUxY9Ivs2kLhPqslY3GfbSrdWhQcEQtXhodwzibG6UTFd2xDE5Yne4w5exjQNlSeH
         bXnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=D86vPfvEkgcUScB/XB8pymgB1woMrZbE8snC97v/yWM=;
        b=f+WxnmbaYL0bv3Lt3z1cnRjx6pBcHe1C/StoeHQfcwh7vVN2VjrOXcibhRAHtdJkod
         kmO1GQw9h5ZQ1zXt4gxSFOJilWo3iUy2tL0vpHiJzcD3PviBsJI//tEOclQADeiRVcEI
         i5amZmAnLxlSSAKQoI5/5HVfQH/WDAIFFNYEwtmiU/KXvj+vk/miF3cpKzo7wcUnRsnl
         dmBWmfr2UNK6YpXRnl/K65d3CE4XuNWgXH5n/ah9HCwNmL7Bb9EL1qE2TlqutkLh+u+/
         mYt1rFw2DMvU9uZgfQLZ6U2ZkpndramVvVBjVbdAV0XH7sJLAiJAlAt4iuvj0AN+ZTKw
         RsaA==
X-Gm-Message-State: AOAM531UFsuugx9tTYLshR8OVlpF8HU8qlbXSBip+jYHPhg10YW7AXqp
        037r8oshXGGFABYGcTVnpp2TRdStPskJyg==
X-Google-Smtp-Source: ABdhPJwa5gqpC8sZTDh9KFwHgv3N/RnMsCRUvotBVOq3VDHzWHWJcAezVmDDBVXZE8Jz0w0MgAlqXQ==
X-Received: by 2002:a50:bf0f:: with SMTP id f15mr646814edk.43.1634753646936;
        Wed, 20 Oct 2021 11:14:06 -0700 (PDT)
Received: from kwango.local (ip-94-112-171-183.net.upcbroadband.cz. [94.112.171.183])
        by smtp.gmail.com with ESMTPSA id a1sm1593566edu.43.2021.10.20.11.14.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Oct 2021 11:14:06 -0700 (PDT)
From:   Ilya Dryomov <idryomov@gmail.com>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     ceph-devel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] Ceph fixes for 5.15-rc7
Date:   Wed, 20 Oct 2021 20:12:10 +0200
Message-Id: <20211020181210.31975-1-idryomov@gmail.com>
X-Mailer: git-send-email 2.19.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Hi Linus,

The following changes since commit 519d81956ee277b4419c723adfb154603c2565ba:

  Linux 5.15-rc6 (2021-10-17 20:00:13 -1000)

are available in the Git repository at:

  https://github.com/ceph/ceph-client.git tags/ceph-for-5.15-rc7

for you to fetch changes up to 1bd85aa65d0e7b5e4d09240f492f37c569fdd431:

  ceph: fix handling of "meta" errors (2021-10-19 09:36:06 +0200)

----------------------------------------------------------------
Two important filesystem fixes, marked for stable.  The blocklisted
superblocks issue was particularly annoying because for unexperienced
users it essentially exacted a reboot to establish a new functional
mount in that scenario.

----------------------------------------------------------------
Jeff Layton (2):
      ceph: skip existing superblocks that are blocklisted or shut down when mounting
      ceph: fix handling of "meta" errors

 fs/ceph/caps.c       | 12 +++---------
 fs/ceph/file.c       |  1 -
 fs/ceph/inode.c      |  2 --
 fs/ceph/mds_client.c | 17 +++++------------
 fs/ceph/super.c      | 17 ++++++++++++++---
 fs/ceph/super.h      |  3 ---
 6 files changed, 22 insertions(+), 30 deletions(-)
