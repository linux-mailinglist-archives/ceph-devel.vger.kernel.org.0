Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC1BC1ACEA0
	for <lists+ceph-devel@lfdr.de>; Thu, 16 Apr 2020 19:24:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390928AbgDPRXm (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 16 Apr 2020 13:23:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S2388338AbgDPRXj (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Thu, 16 Apr 2020 13:23:39 -0400
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 233EFC061A0C;
        Thu, 16 Apr 2020 10:23:39 -0700 (PDT)
Received: by mail-wr1-x442.google.com with SMTP id f13so5732058wrm.13;
        Thu, 16 Apr 2020 10:23:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Z9XHKckPCLBcZSv3PK4hH27LcSZZ7AZ4+cDFop3NIPQ=;
        b=H5GIAQ0ShVvZb4fhj6iIB/qGY+q4uMEhxdwpqxo2RaCk09uo88RWgc7BsALOUjTMJn
         UHhhIXKm/FtjQ7UvVHE8rUq2UxdnF9xjdDoYkeETt4M3AnyI9FTDbKTpdAtPMavCjVAu
         mmMFYGLVD28KNJETihHa9RJp1ZWrHlKhjJ6kqsqya6J69vTK2bb5leJwZ9/ZFeFMnm2w
         DU/HQgUQkL4gHQJbuXVXIiQmskobgdkOuQn8t4Idb+CgVTUOk9XTwnBfAsWjH2SL2I/Q
         rwWrumE37oriWHoUcImXD/3QMcXa6KapOYwmPMYzARG9qi8dnY43bi0dlrdZXv4pGReF
         ONPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Z9XHKckPCLBcZSv3PK4hH27LcSZZ7AZ4+cDFop3NIPQ=;
        b=p6DEMabk6LI+CfAF2mMdZa1AQASQefBuT7F/UQnLFY+J7hIr3diM2SL4drIAoeJhP3
         pt181Bjxbr/Cqu1LxhX/t7H3rE/lB81Dc2+22jVHceV/LRxluwgNI5ZHEXpLmHEo288Y
         HwoQ+ZsYa4qGNY3ZlOscPEuCn5MUTh8ilOZMqN68DCGAja8EUzlrGobNAMpN6dfsEhFE
         k7Ij7QG/Fyn9I4ErJQOsb1W3PHuK3xPouBcutMdm6AhrNtd8HrUOCTxR+P1pQiPChRDV
         IiQKmR7Nx87DwPCIThWw6JZfoIb36gMsPorHldg4zA9bRsqY3k04Orovd2cnqeo3EO3+
         aE0w==
X-Gm-Message-State: AGi0PuYKN/ayTqYlxAdnidDqw1oNg0Iu0U89d1beq0+l/yRWEAbugjOc
        ECSKHDoiI1612O3gih4JhLg=
X-Google-Smtp-Source: APiQypKzyc24yuJDB7Jn2s/8pHU8T+iSuTsxPtDgiWHOEQc+B31IaI7PkAzu9cFFtSFWJO0CCqW+7g==
X-Received: by 2002:a5d:4286:: with SMTP id k6mr23465999wrq.222.1587057817866;
        Thu, 16 Apr 2020 10:23:37 -0700 (PDT)
Received: from kwango.redhat.com (ip-94-112-129-237.net.upcbroadband.cz. [94.112.129.237])
        by smtp.gmail.com with ESMTPSA id w12sm13763186wrk.56.2020.04.16.10.23.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Apr 2020 10:23:37 -0700 (PDT)
From:   Ilya Dryomov <idryomov@gmail.com>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     ceph-devel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] Ceph fixes for 5.7-rc2
Date:   Thu, 16 Apr 2020 19:23:21 +0200
Message-Id: <20200416172321.20778-1-idryomov@gmail.com>
X-Mailer: git-send-email 2.19.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Hi Linus,

The following changes since commit 8f3d9f354286745c751374f5f1fcafee6b3f3136:

  Linux 5.7-rc1 (2020-04-12 12:35:55 -0700)

are available in the Git repository at:

  https://github.com/ceph/ceph-client.git tags/ceph-for-5.7-rc2

for you to fetch changes up to 2a575f138d003fff0f4930b5cfae4a1c46343b8f:

  ceph: fix potential bad pointer deref in async dirops cb's (2020-04-13 19:33:47 +0200)

----------------------------------------------------------------
A set of patches for a deadlock on "rbd map" error path and a fix
for invalid pointer dereference and uninitialized variable use on
asynchronous create and unlink error paths.

----------------------------------------------------------------
Ilya Dryomov (4):
      rbd: avoid a deadlock on header_rwsem when flushing notifies
      rbd: call rbd_dev_unprobe() after unwatching and flushing notifies
      rbd: don't test rbd_dev->opts in rbd_dev_image_release()
      rbd: don't mess with a page vector in rbd_notify_op_lock()

Jeff Layton (1):
      ceph: fix potential bad pointer deref in async dirops cb's

 drivers/block/rbd.c  | 33 +++++++++++++++++++--------------
 fs/ceph/dir.c        |  4 ++--
 fs/ceph/file.c       |  4 ++--
 fs/ceph/mds_client.h |  2 +-
 4 files changed, 24 insertions(+), 19 deletions(-)
