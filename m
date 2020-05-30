Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5731B1E9259
	for <lists+ceph-devel@lfdr.de>; Sat, 30 May 2020 17:34:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729029AbgE3Pem (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Sat, 30 May 2020 11:34:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728999AbgE3Pel (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Sat, 30 May 2020 11:34:41 -0400
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70499C03E969
        for <ceph-devel@vger.kernel.org>; Sat, 30 May 2020 08:34:40 -0700 (PDT)
Received: by mail-wr1-x444.google.com with SMTP id x14so7190098wrp.2
        for <ceph-devel@vger.kernel.org>; Sat, 30 May 2020 08:34:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=b/872xH0vYt4MNBBYaw8CUl/rWJy5DRYbRDkch4fCKc=;
        b=UcW237IVJbGHRtskHnYKbrSS2q3N7Lj1Ll64+KhUYa2VC844h3+5RLGljDtW5LX7Tr
         sNiFlbZcODeIe59d0OrStk/puCaZokQWGrqIMt/2015TQpUou2WDnb6YOGGQHZGOLc12
         pn384CjHGg0t7o3PCvLv+bVu2CxQx5jncf0389g7ZGtcBXcJiuQT4VwNvWS5tKO3ED6W
         CZPBRzaIusKuSEbR70FJmnUFxY/d5q8V7xfiqwbMLSer6qBkvX9dkgiw32OEuabuBoFm
         hyd3Ac5YEJVV8kJOOmH2DgQCPkzZvGE+8VwNeIOSM6LHztQaqGg58qDpCYvfClZEw73u
         yM2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=b/872xH0vYt4MNBBYaw8CUl/rWJy5DRYbRDkch4fCKc=;
        b=W/dPLdljDnvPNkanRC98lyJi7rgK5MK2/Eib+07FigXmKMDYJCjW/Lw5fBo4gFxNOW
         Qa6TPUbXNIYOGZMTlHSRCvfcd7rCg8pxQIUE3ufAPq/1QmfFLR3Z7yDYUbpiEqYD7fuV
         jGKlYvYKl7lnyACMtgXGZP5qcHV+rcHVmwBm5UwOuexmIuGKdFgMNlCoKJs/iX6+ZgW+
         5MYyV7FWHaAxJfC1o19+Y+PvWwXhl8KerI4iaO9+6SVrlUEn8DpyyW+Jq5Gspo4dc6eC
         9DJ3xow97egjrzadOGcjQcWT++CjKXQmA5ss5RCysWqjzYPPDV9xCbbN0bCr7H0ntity
         BPNw==
X-Gm-Message-State: AOAM530HzFVl31TymrE3QJ+25oso25NQlmLbHLF2YFctjCEzg+ZTZBvO
        LzX2qTAmdb4KOCUMhQDx3E04MKzBNV4=
X-Google-Smtp-Source: ABdhPJyEUCZxcZ8ybHVqRIRsJ21ITiT1k8ydYbuVGKpCA8ay2M3QQVruM9jsNa8ZXp+6wwqBM9bKcQ==
X-Received: by 2002:adf:a41a:: with SMTP id d26mr14241831wra.324.1590852878660;
        Sat, 30 May 2020 08:34:38 -0700 (PDT)
Received: from kwango.local (ip-94-112-129-237.net.upcbroadband.cz. [94.112.129.237])
        by smtp.gmail.com with ESMTPSA id z132sm4835068wmc.29.2020.05.30.08.34.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 30 May 2020 08:34:37 -0700 (PDT)
From:   Ilya Dryomov <idryomov@gmail.com>
To:     ceph-devel@vger.kernel.org
Cc:     Jeff Layton <jlayton@kernel.org>
Subject: [PATCH v2 0/5] libceph: support for replica reads
Date:   Sat, 30 May 2020 17:34:34 +0200
Message-Id: <20200530153439.31312-1-idryomov@gmail.com>
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

v1 -> v2:
- change crush_location syntax
- rename read_policy to read_from_replica, add read_from_replica=no
- crush_location and read_from_replica are now overridable

Thanks,

                Ilya


Ilya Dryomov (5):
  libceph: add non-asserting rbtree insertion helper
  libceph: decode CRUSH device/bucket types and names
  libceph: crush_location infrastructure
  libceph: support for balanced and localized reads
  libceph: read_from_replica option

 include/linux/ceph/libceph.h    |  13 +-
 include/linux/ceph/osd_client.h |   1 +
 include/linux/ceph/osdmap.h     |  19 +-
 include/linux/crush/crush.h     |   6 +
 net/ceph/ceph_common.c          |  75 +++++++
 net/ceph/crush/crush.c          |   3 +
 net/ceph/debugfs.c              |   6 +-
 net/ceph/osd_client.c           |  92 +++++++-
 net/ceph/osdmap.c               | 363 +++++++++++++++++++++++++++-----
 9 files changed, 517 insertions(+), 61 deletions(-)

-- 
2.19.2

