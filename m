Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E4ADD113616
	for <lists+ceph-devel@lfdr.de>; Wed,  4 Dec 2019 21:02:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728071AbfLDUCj (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 4 Dec 2019 15:02:39 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:42211 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727033AbfLDUCj (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 4 Dec 2019 15:02:39 -0500
Received: by mail-wr1-f65.google.com with SMTP id a15so678276wrf.9;
        Wed, 04 Dec 2019 12:02:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=cT11YIcdkgYhqPU2AoD2MILDuUK9k9JrX8T2PQ0wiok=;
        b=Jf765RLV+6LVYeO1/qjODFKvDMtjuXP3EMmCo7Za5XuSjYXPGcSDIqj9EAJC0wfmH+
         A5KTCr1znLUPapknCAEF/9GJ+6yUaqT5b6hOXZ2NCR18/Mtc7W2epI9+3zwUIRE842JF
         UwspeWXaJzFHAKhQYMVxboRVvv4KLS7/IXTImHPU2TgXO+D0h237IGbpFsTwiam+hMTp
         imsxzTHAEjKhEnICuarTPb59P16aMrcBPiZ19jheMna6rz1EfUVmAmojQ5eqU+O0r1Ui
         ffGW3VdC+v6i4mQYxHaZdSEjLijsRNOewLOX/0aivPBydQ4VdZT7zcf8pAZLtm9NXoKe
         ejww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=cT11YIcdkgYhqPU2AoD2MILDuUK9k9JrX8T2PQ0wiok=;
        b=OL/1ST6agOxpW/PuEVoY2zIQkrb50u5FbwIwM/o1mEkMTsojFcdRO6hr9sgMLKmyff
         T9Ss/eH8Ag5i+/5cZt0nkdCg/FS8svQ+beYpcUiQJm7W8Rz52R4JSeBkBlShfZTlkXFi
         GR5GFZGpq+hsk+xCZ6wx/WVwCz6edFtnwANPtndlK5PdamXEa1ts0wVjE5Pf1skxn+AO
         TZlQqgI+pFN9/lW9TcujruV0nlL+LBRom9Dg8vSLxPf4FrQrthGhQDlQfw3xuib5a47+
         21TmdpG5d91/yqJW7S89CX20brPf27AUwUKYHLMTWTjY7RLOdMN4Dsq8lJSAwX08kitB
         +s9g==
X-Gm-Message-State: APjAAAVT+IIhosIhl6eBs0DCJqiLlgAUh45gCwbCyEMm8IWf5aCV3B2o
        LIqYXwktev/VvmljCeIbYLLTGkED3Bg=
X-Google-Smtp-Source: APXvYqwhsXbE+16pnIoX7jXk6Byem86Plk7+CaoB3dZ6j2EiZAPM+gx1eDZb1yscAtBwka2A7+qm4g==
X-Received: by 2002:adf:9b83:: with SMTP id d3mr6072634wrc.54.1575489757346;
        Wed, 04 Dec 2019 12:02:37 -0800 (PST)
Received: from kwango.redhat.com (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id h127sm7962492wme.31.2019.12.04.12.02.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Dec 2019 12:02:36 -0800 (PST)
From:   Ilya Dryomov <idryomov@gmail.com>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     ceph-devel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] Ceph updates for 5.5-rc1
Date:   Wed,  4 Dec 2019 21:03:07 +0100
Message-Id: <20191204200307.21047-1-idryomov@gmail.com>
X-Mailer: git-send-email 2.19.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Hi Linus,

The following changes since commit 219d54332a09e8d8741c1e1982f5eae56099de85:

  Linux 5.4 (2019-11-24 16:32:01 -0800)

are available in the Git repository at:

  https://github.com/ceph/ceph-client.git tags/ceph-for-5.5-rc1

for you to fetch changes up to 82995cc6c5ae4bf4d72edef381a085e52d5b5905:

  libceph, rbd, ceph: convert to use the new mount API (2019-11-27 22:28:37 +0100)

----------------------------------------------------------------
The two highlights are a set of improvements to how rbd read-only
mappings are handled and a conversion to the new mount API (slightly
complicated by the fact that we had a common option parsing framework
that called out into rbd and the filesystem instead of them calling
into it).  Also included a few scattered fixes and a MAINTAINERS update
for rbd, adding Dongsheng as a reviewer.

----------------------------------------------------------------
Colin Ian King (1):
      rbd: fix spelling mistake "requeueing" -> "requeuing"

David Howells (1):
      libceph, rbd, ceph: convert to use the new mount API

Ilya Dryomov (11):
      libceph: drop unnecessary check from dispatch() in mon_client.c
      rbd: update MAINTAINERS info
      rbd: introduce rbd_is_snap()
      rbd: introduce RBD_DEV_FLAG_READONLY
      rbd: treat images mapped read-only seriously
      rbd: disallow read-write partitions on images mapped read-only
      rbd: don't acquire exclusive lock for read-only mappings
      rbd: don't establish watch for read-only mappings
      rbd: remove snapshot existence validation code
      rbd: don't query snapshot features
      rbd: ask for a weaker incompat mask for read-only mappings

Jeff Layton (3):
      ceph: make several helper accessors take const pointers
      ceph: tone down loglevel on ceph_mdsc_build_path warning
      ceph: don't leave ino field in ceph_mds_request_head uninitialized

Xiubo Li (1):
      ceph: fix geting random mds from mdsmap

 MAINTAINERS                  |   2 +-
 drivers/block/rbd.c          | 467 ++++++++++++++++---------------
 fs/ceph/cache.c              |   9 +-
 fs/ceph/cache.h              |   5 +-
 fs/ceph/mds_client.c         |  19 +-
 fs/ceph/mdsmap.c             |  11 +-
 fs/ceph/super.c              | 646 ++++++++++++++++++++++---------------------
 fs/ceph/super.h              |  13 +-
 include/linux/ceph/libceph.h |  10 +-
 net/ceph/ceph_common.c       | 419 +++++++++++++---------------
 net/ceph/messenger.c         |   2 -
 net/ceph/mon_client.c        |   3 -
 12 files changed, 803 insertions(+), 803 deletions(-)
