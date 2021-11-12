Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 864A444E56B
	for <lists+ceph-devel@lfdr.de>; Fri, 12 Nov 2021 12:11:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234771AbhKLLOp (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 12 Nov 2021 06:14:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233994AbhKLLOo (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Fri, 12 Nov 2021 06:14:44 -0500
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDDD1C061766;
        Fri, 12 Nov 2021 03:11:53 -0800 (PST)
Received: by mail-ed1-x531.google.com with SMTP id z21so36185927edb.5;
        Fri, 12 Nov 2021 03:11:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=l3NPsGFLqQUScYZh7+OYppIcBfeqQMA5edW6/FbKnxc=;
        b=pHbjIGtgDPFkVhAGw2y320K83wi1O4Pcrlrgppe1mALLIeYh/2TcWrfWGJocd75UGC
         JztFl7oHN0iHm0APLPRh/tdmOCY/haDOgATQPW+9rSFaCjckPDxZT0ra2g15acFW7Vji
         6YYPLSK3b082xC8WkCtAdJ9Q+WV8CPZDndgE+PN/x6KWfx5lT4t68DkiMVhLT2TJ/7PD
         B+g8raoFdU9GPPZQLCpAn6fVU8V67O7qVFFTWLuzugVbU24BFNlTdk8yS7SR10sMdxol
         +xtxHsJ7fKtEKi12mpGXcqR+LLHO19sXW7K+t1nlXOQd536Wr09W9o/46lx3lNkYGdrV
         SmSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=l3NPsGFLqQUScYZh7+OYppIcBfeqQMA5edW6/FbKnxc=;
        b=LvlzEwNmnYY1SmzqXr++k+1brcEsDkuWZ0ckYXUsRccesOJHtlvNr4WTxRar9qVT62
         5AVetQqOZ8mtevbujBBQj658IJdDkIQlPi8fntlySkNG0ehQozzdPT2JU2R4c8YsRHW7
         2X2F2n3IrMtMRgN25emtDRvCRJaLYEZ0iYLO3pNqrhRrsig4ZweFUIYcTORqCp5HTt0b
         3V/yWyyf7/k3Dv5Xk/CVl8sg/qPOBILaEP1trykZXrGNqdwwSDS80I0VVQjhC/o+X+ec
         ZTiQG3yEhQVReiZw/SIflhPtrkRBEjl+JdBj+6vCUZyzpma1o60ft43q4C+cdBlzb+rV
         imwQ==
X-Gm-Message-State: AOAM533GVaLkc2woI3GaFyYa0O4yG3ugslM9/YOvxPqzi0TZn+mlEw67
        rV3nwD9kV2eCci0x7PJJIGWFRU3m70j1oyu/
X-Google-Smtp-Source: ABdhPJypFIY5XoytavaqD6i79i8paD+ScsRGRunwgo8kYoEuJQaVrAtqBviTFOUFOqyXCwqg+mcXHQ==
X-Received: by 2002:a17:906:4bcf:: with SMTP id x15mr18463739ejv.273.1636715512438;
        Fri, 12 Nov 2021 03:11:52 -0800 (PST)
Received: from kwango.redhat.com ([109.110.91.205])
        by smtp.gmail.com with ESMTPSA id dk5sm2833212edb.20.2021.11.12.03.11.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Nov 2021 03:11:52 -0800 (PST)
From:   Ilya Dryomov <idryomov@gmail.com>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     ceph-devel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] Ceph updates for 5.16-rc1
Date:   Fri, 12 Nov 2021 12:11:32 +0100
Message-Id: <20211112111132.27316-1-idryomov@gmail.com>
X-Mailer: git-send-email 2.19.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Hi Linus,

The following changes since commit 8bb7eca972ad531c9b149c0a51ab43a417385813:

  Linux 5.15 (2021-10-31 13:53:10 -0700)

are available in the Git repository at:

  https://github.com/ceph/ceph-client.git tags/ceph-for-5.16-rc1

for you to fetch changes up to c02cb7bdc4501debc3e71a4d2daf7286c48e1d38:

  ceph: add a new metric to keep track of remote object copies (2021-11-08 03:29:52 +0100)

----------------------------------------------------------------
One notable change here is that async creates and unlinks introduced
in 5.7 are now enabled by default.  This should greatly speed up things
like rm, tar and rsync.  To opt out, wsync mount option can be used.

Other than that we have a pile of bug fixes all across the filesystem
from Jeff, Xiubo and Kotresh and a metrics infrastructure rework from
Luis.

----------------------------------------------------------------
Jean Sacren (1):
      libceph: drop ->monmap and err initialization

Jeff Layton (11):
      ceph: convert to noop_direct_IO
      ceph: enable async dirops by default
      ceph: print inode numbers instead of pointer values
      ceph: don't use -ESTALE as special return code in try_get_cap_refs
      ceph: drop private list from remove_session_caps_cb
      ceph: fix auth cap handling logic in remove_session_caps_cb
      ceph: refactor remove_session_caps_cb
      ceph: shut down access to inode when async create fails
      ceph: just use ci->i_version for fscache aux info
      ceph: shut down mount on bad mdsmap or fsmap decode
      ceph: properly handle statfs on multifs setups

Kotresh HR (1):
      ceph: don't rely on error_string to validate blocklisted session.

Luis Henriques (4):
      ceph: split 'metric' debugfs file into several files
      ceph: clean-up metrics data structures to reduce code duplication
      libceph, ceph: move ceph_osdc_copy_from() into cephfs code
      ceph: add a new metric to keep track of remote object copies

Xiubo Li (3):
      ceph: ignore the truncate when size won't change with Fx caps issued
      ceph: fix mdsmap decode when there are MDS's beyond max_mds
      ceph: return the real size read when it hits EOF

 fs/ceph/addr.c                  |  29 +++----
 fs/ceph/cache.c                 |  23 +-----
 fs/ceph/caps.c                  | 151 ++++++++++++++++++++++++++++++++----
 fs/ceph/debugfs.c               | 167 ++++++++++++++++++++++------------------
 fs/ceph/export.c                |  12 ++-
 fs/ceph/file.c                  | 103 ++++++++++++++++++++-----
 fs/ceph/inode.c                 |  54 ++++++++++---
 fs/ceph/locks.c                 |   6 ++
 fs/ceph/mds_client.c            | 139 +++++++--------------------------
 fs/ceph/mdsmap.c                |   4 -
 fs/ceph/metric.c                | 128 ++++++++----------------------
 fs/ceph/metric.h                |  88 ++++++++++++---------
 fs/ceph/super.c                 |  17 ++--
 fs/ceph/super.h                 |  18 ++++-
 include/linux/ceph/ceph_fs.h    |   2 +
 include/linux/ceph/osd_client.h |  19 ++---
 net/ceph/mon_client.c           |   3 +-
 net/ceph/osd_client.c           |  60 +++------------
 18 files changed, 544 insertions(+), 479 deletions(-)
