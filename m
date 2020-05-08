Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F2DB1CB5AA
	for <lists+ceph-devel@lfdr.de>; Fri,  8 May 2020 19:17:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727107AbgEHRQW (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 8 May 2020 13:16:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726756AbgEHRQW (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Fri, 8 May 2020 13:16:22 -0400
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EABA8C061A0C;
        Fri,  8 May 2020 10:16:21 -0700 (PDT)
Received: by mail-wr1-x432.google.com with SMTP id h9so2772971wrt.0;
        Fri, 08 May 2020 10:16:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=nEx7VWUEE5CS/7MRII1BtXnU4gjE+aVUwjHid+Nm0Kc=;
        b=MiGzKwDSoc9PlgUPs6sZC1firZIaNgaQQNEf7spMf50dnlhJeYzZ59BSprQj3laLfH
         uvYRTTgUhfIab+eUXvBTEkvb8I7o5xPXvSknJE9PjOAPqesk0s2LlA/siQHjQIoLbTM7
         Dzr8feJ8u4Ifo3rli4/JNvxXgVtSX96Ml0cn3M4m7hBqOK4UNtIQI50WaArpdL4I13ot
         k8Yc+LTcBKbMypfACeTNXlk4FP4iCcsOMZ3ZYtRGyI4vvBNsGyZcD20JDT6mHuqclbr4
         gl9S3sHMkdq5oWHi89tBqLKYzBIv6RjckI3mcxjN0PnNFabSy/Z24VC2JT+KFoo6OUQg
         3c3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=nEx7VWUEE5CS/7MRII1BtXnU4gjE+aVUwjHid+Nm0Kc=;
        b=nF06th7R1HxfeEwi9goDCIYcMM6n3c/VJQUyfilXneX3D4TfRB9PdNaJ0lAp48GaSc
         fiOvAxFywnDNN+yjg6/97paez0CFcJp90JpwUaqmsnuNFLba7tyOFkNNvT8NpyzPPOwA
         kbU0MehchMcQM5xXdtwPOqY90bFObzgDDEYRk1e1uaWzik21PwbMt5pxuLaFpQdIu1/e
         oMWD53fRSTJ83G6W+mj2gXd/ljNEMYS0pBRgM4IWokXqQ4d9+KrAz9Wvzn5uPgQSnW26
         5XAfw3/7+dpNc15fJpKaYVqOYEJFgaXu4eivahdazaBaDelPmOpyGjArnxPgIq9qEu+e
         wTgQ==
X-Gm-Message-State: AGi0PuawREVx1oTfEhfna0QX7DqacVeTX+3SDUZcJS9CAnb9WaRAHap4
        ysUQkDdjfMZbuyQOnXG/tLSZa/KJ
X-Google-Smtp-Source: APiQypI3RKIhnbHTS3W+/EeF1X2blbLwhwFUzrh91OmXRN/tq/LSpfxNgB1Vd4OZ+uSpNeVnPGE9jA==
X-Received: by 2002:a5d:6a85:: with SMTP id s5mr4001053wru.122.1588958180684;
        Fri, 08 May 2020 10:16:20 -0700 (PDT)
Received: from kwango.redhat.com (ip-94-112-129-237.net.upcbroadband.cz. [94.112.129.237])
        by smtp.gmail.com with ESMTPSA id s18sm4392616wra.94.2020.05.08.10.16.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 May 2020 10:16:20 -0700 (PDT)
From:   Ilya Dryomov <idryomov@gmail.com>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     ceph-devel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] Ceph fixes for 5.7-rc5
Date:   Fri,  8 May 2020 19:16:13 +0200
Message-Id: <20200508171613.27097-1-idryomov@gmail.com>
X-Mailer: git-send-email 2.19.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Hi Linus,

The following changes since commit 0e698dfa282211e414076f9dc7e83c1c288314fd:

  Linux 5.7-rc4 (2020-05-03 14:56:04 -0700)

are available in the Git repository at:

  https://github.com/ceph/ceph-client.git tags/ceph-for-5.7-rc5

for you to fetch changes up to 12ae44a40a1be891bdc6463f8c7072b4ede746ef:

  ceph: demote quotarealm lookup warning to a debug message (2020-05-08 18:44:40 +0200)

----------------------------------------------------------------
Fixes for an endianness handling bug that prevented mounts on
big-endian arches, a spammy log message and a couple error paths.
Also included a MAINTAINERS update.

----------------------------------------------------------------
Jeff Layton (1):
      ceph: fix endianness bug when handling MDS session feature bits

Luis Henriques (1):
      ceph: demote quotarealm lookup warning to a debug message

Sage Weil (1):
      MAINTAINERS: remove myself as ceph co-maintainer

Wu Bo (2):
      ceph: fix special error code in ceph_try_get_caps()
      ceph: fix double unlock in handle_cap_export()

 MAINTAINERS          | 6 ------
 fs/ceph/caps.c       | 3 ++-
 fs/ceph/mds_client.c | 8 +++-----
 fs/ceph/quota.c      | 4 ++--
 4 files changed, 7 insertions(+), 14 deletions(-)
