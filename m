Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 366E61E8194
	for <lists+ceph-devel@lfdr.de>; Fri, 29 May 2020 17:20:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727779AbgE2PT7 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 29 May 2020 11:19:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727108AbgE2PTz (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Fri, 29 May 2020 11:19:55 -0400
Received: from mail-ed1-x543.google.com (mail-ed1-x543.google.com [IPv6:2a00:1450:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DB2CC08C5C8
        for <ceph-devel@vger.kernel.org>; Fri, 29 May 2020 08:19:54 -0700 (PDT)
Received: by mail-ed1-x543.google.com with SMTP id p18so2013905eds.7
        for <ceph-devel@vger.kernel.org>; Fri, 29 May 2020 08:19:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=seANPVVun1DThpyEGxJ1c9iTEgoWmBYeLqmXtu/gSUE=;
        b=gueFEa5GjCZCzEBiozfMng13dv45i1IFnYNR8pwx4vIwEsuBDWg7IwFmIXDVEEsX4m
         Tr5fFeT6l9x/E56suRTvDLCsAbGI1XzGAb6umnICS0It5na4DJBxxumm5DPJyudry/g2
         zxRlTueTMYIvHhCQy9nttNOMplJphdBPAGnCo2+wuV5Ed6tlIRHSaHdH4k0KxF1kDo4Q
         SoYa/YQ7qhad+be+0K5r9TykxJlBz9OaBG6s9dEl0FCLpaGUpLi9CdBFUrRb1oXMGtJb
         CiiiMc5fcY/TZo9j7OMMAdPt0F1aXwLybPhYaXTjEPqGhgfiU5/wavpWL/7NSYZXh4VQ
         h8Rw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=seANPVVun1DThpyEGxJ1c9iTEgoWmBYeLqmXtu/gSUE=;
        b=cVAdjw5UjhyFmTQeGGxBV2XE6QV87LGD+M2vrsocCs2HguRAKbpYmgiJ2A7duI3Mqx
         FP3OEQgKes05mBPyeX/r0dW0jaM3wyFgxX18q06AmPLZ+6k7W+DZYtVAqwJLxKuBA9sl
         vMPZRkNs1iO8/4tQohgWiFvunn04+hmIAtLIZSiIeWzriEp1l0HWdwbR5xTlzdKELKLv
         BiA86DW6yPuWuYmDl6Lkm3obkjnxMwkdQ4fU0TW4iIHVo21/KIb5mYgfqcDpCPviUHYB
         +NDyuK8oGzYJHoZ2pwRhQ1RjNuYFCFC3z7XdqdUA3/DdEPLNziNAHZeOrp/fnpFvsMfW
         ZrFQ==
X-Gm-Message-State: AOAM531iDLz8/0VYVi5nnGMeZQ6VJwIVHrAkjCN9yj1I+s59FEd5w0l0
        rNRi44SBWz4XtFJivn18Xviklyfx3Ao=
X-Google-Smtp-Source: ABdhPJyl0DwdbNSFcPqE0NzM3xFLrrAWRnpWdnJDYi8ZcrucbthJcijkqHd3RLqmNd4AvdBnkRiZLw==
X-Received: by 2002:a05:6402:296:: with SMTP id l22mr9121934edv.353.1590765592820;
        Fri, 29 May 2020 08:19:52 -0700 (PDT)
Received: from kwango.local (ip-94-112-129-237.net.upcbroadband.cz. [94.112.129.237])
        by smtp.gmail.com with ESMTPSA id cd17sm6616663ejb.115.2020.05.29.08.19.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 May 2020 08:19:52 -0700 (PDT)
From:   Ilya Dryomov <idryomov@gmail.com>
To:     ceph-devel@vger.kernel.org
Cc:     Jeff Layton <jlayton@kernel.org>
Subject: [PATCH 0/5] libceph: support for replica reads
Date:   Fri, 29 May 2020 17:19:47 +0200
Message-Id: <20200529151952.15184-1-idryomov@gmail.com>
X-Mailer: git-send-email 2.19.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Hello,

This adds support for replica reads (balanced and localized reads)
to rbd and ceph.  crush_location syntax is slightly different, see
patch 3 for details.

Thanks,

                Ilya


Ilya Dryomov (5):
  libceph: add non-asserting rbtree insertion helper
  libceph: decode CRUSH device/bucket types and names
  libceph: crush_location infrastructure
  libceph: support for balanced and localized reads
  libceph: read_policy option

 include/linux/ceph/libceph.h    |  13 +-
 include/linux/ceph/osd_client.h |   1 +
 include/linux/ceph/osdmap.h     |  19 +-
 include/linux/crush/crush.h     |   6 +
 net/ceph/ceph_common.c          |  51 +++++
 net/ceph/crush/crush.c          |   3 +
 net/ceph/debugfs.c              |   6 +-
 net/ceph/osd_client.c           |  92 +++++++-
 net/ceph/osdmap.c               | 361 +++++++++++++++++++++++++++-----
 9 files changed, 491 insertions(+), 61 deletions(-)

-- 
2.19.2

