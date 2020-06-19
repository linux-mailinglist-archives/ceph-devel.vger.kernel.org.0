Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B052B2008C3
	for <lists+ceph-devel@lfdr.de>; Fri, 19 Jun 2020 14:35:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732295AbgFSMfj (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 19 Jun 2020 08:35:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730721AbgFSMfj (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Fri, 19 Jun 2020 08:35:39 -0400
Received: from mail-ej1-x642.google.com (mail-ej1-x642.google.com [IPv6:2a00:1450:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99B8FC06174E;
        Fri, 19 Jun 2020 05:35:38 -0700 (PDT)
Received: by mail-ej1-x642.google.com with SMTP id y13so10037075eju.2;
        Fri, 19 Jun 2020 05:35:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=cGk94kqlaz+It7mAczUwCb778qzoBgZjifJczd8x0xQ=;
        b=ljgPT/Zh5oiWswbruuHm0fkAFiJmBoLMYg/fb0Esdw4f9NxbEymaZaiJ4pkQ/6AV3x
         P0iOR6iVjufv2FMNPXD8gh0nx52xakn7LUP4Psqiw1uOb4P+DFIzd5gdssmMqEJVC86C
         zDC0SqSKb2Oc1Gc/UVggj/FfJcjvzll6OG3gomTzHtnW6+QMFEGQG9gG4Tn+SQ78vvQ4
         Zh35p9rGw6tIMrtud49EcsDzwJJPeZUlNrWatjS1sY70466xklqkQKypIE0RERpPdaDp
         gGp/Q1KAZGfv93e79hZdxfZ+K4/8E23g1+XyMDpof6yGHG1ody9T5Bg2NgykS4vDiIdl
         6Nuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=cGk94kqlaz+It7mAczUwCb778qzoBgZjifJczd8x0xQ=;
        b=qosRJNXk9g1VUmeCdeM3TQeygdZHIobZpttjSJ1MggkhATHsF9Gtx8qfH+YGkgSXtR
         cwAGIYjIt9G19ZCxzrENq76EQJ9JKRJH80x4Vek3ubZOxzVYCPQPKVj1nzgjNJZof0h1
         MFsn21e+hTeMvHjQHPzeLye0/LBMMn7/o0oBcTRTKU5V4DmbnkUerP8dBrsPldb9vcar
         IUJOkJu1QbXCdyAwOJ0ZG5qwf+r66H14LFWsLvUmL3Z0XTgQh64Aoi+7MxTZg7mAmKTv
         UINpJGKv63JbiMKv2Iwp5mq33cKCbvH5OVL+4jxknYMrb8EisZ8nXhEIK3jcmsknySxE
         epQQ==
X-Gm-Message-State: AOAM530AQ9xjnXrCJzKc6MrDLYzxc00fCOhr8Ltj1iaVkkFi1O8NAl+D
        XBLx69q9tZnNyf7XWeBwLcs4xgc7SiC4Vg==
X-Google-Smtp-Source: ABdhPJyPEGrbnqv1eD/mrcEcqZKRfP+urvoDUQ3QBKXEeTdn3/nCrPnP+FCbZEdFkVKNY+zmUyWb3Q==
X-Received: by 2002:a17:906:ce31:: with SMTP id sd17mr3386742ejb.255.1592570137390;
        Fri, 19 Jun 2020 05:35:37 -0700 (PDT)
Received: from kwango.local (ip-94-112-129-237.net.upcbroadband.cz. [94.112.129.237])
        by smtp.gmail.com with ESMTPSA id n25sm4572231edo.56.2020.06.19.05.35.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Jun 2020 05:35:36 -0700 (PDT)
From:   Ilya Dryomov <idryomov@gmail.com>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     ceph-devel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] Ceph fixes for 5.8-rc2
Date:   Fri, 19 Jun 2020 14:35:47 +0200
Message-Id: <20200619123547.14353-1-idryomov@gmail.com>
X-Mailer: git-send-email 2.19.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Hi Linus,

The following changes since commit b3a9e3b9622ae10064826dccb4f7a52bd88c7407:

  Linux 5.8-rc1 (2020-06-14 12:45:04 -0700)

are available in the Git repository at:

  https://github.com/ceph/ceph-client.git tags/ceph-for-5.8-rc2

for you to fetch changes up to 7ed286f3e061ee394782bd9fb4ed96bff0b5a021:

  libceph: don't omit used_replica in target_copy() (2020-06-16 16:02:08 +0200)

----------------------------------------------------------------
An important follow-up for replica reads support that went into -rc1
and two target_copy() fixups.

----------------------------------------------------------------
Ilya Dryomov (3):
      libceph: move away from global osd_req_flags
      libceph: don't omit recovery_deletes in target_copy()
      libceph: don't omit used_replica in target_copy()

 drivers/block/rbd.c          |  4 +++-
 include/linux/ceph/libceph.h |  4 ++--
 net/ceph/ceph_common.c       | 14 ++++++--------
 net/ceph/osd_client.c        |  9 ++++-----
 4 files changed, 15 insertions(+), 16 deletions(-)
