Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA9FC2D9924
	for <lists+ceph-devel@lfdr.de>; Mon, 14 Dec 2020 14:46:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439975AbgLNNoh (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 14 Dec 2020 08:44:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2407077AbgLNNoS (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 14 Dec 2020 08:44:18 -0500
Received: from mail-il1-x12d.google.com (mail-il1-x12d.google.com [IPv6:2607:f8b0:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 720F9C0613CF
        for <ceph-devel@vger.kernel.org>; Mon, 14 Dec 2020 05:43:38 -0800 (PST)
Received: by mail-il1-x12d.google.com with SMTP id r17so15769935ilo.11
        for <ceph-devel@vger.kernel.org>; Mon, 14 Dec 2020 05:43:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=KBqKcFnuJCxAdVvLBmgV+qzjkBMjH3zfRT6Ep8BJ+L8=;
        b=cVlpGyKJkAXg2lYfDH5UhthwLDCbzzzwcXIFFw8WCq16KM8vaxoFDdEPmNCt2nn8Yf
         Ja3WEHcHSfArjFl/5ktxF3Qjc3AgtjMeTUaNax2vxf9nSv51zRZy9EoOrdXCjyhsaFEH
         nruDc/YpkCgEBESeM9Zkdmqx3QKrEGYkr6ZOP7q7kFhk0iqaMjCd4t2ADRhuQdGmwtd0
         5Dr0oj2Ugg7e2TSeaRNg6VGI5nSDz+aEhRDg/NGOR00xaeUZ0dN9e+zVgG5gqMpFTp/4
         LV03MmMUwCqQo0zeGkL4f3nxWzE0ff/KkXr/f22nJLQMeJ52H9Y0M0Y4UQ8p2zXsRh/0
         Wr+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=KBqKcFnuJCxAdVvLBmgV+qzjkBMjH3zfRT6Ep8BJ+L8=;
        b=hNcwhRAODn6AaylBdoqbueh21a8ZwzI5NQzKVHPwiIMYuYP32yID4AkLAFOACX1tLC
         XPMGusuAa0TYg4dcB7wob9Q//suzJ7D3Vucj09myft5Ez4aTR92iiSHSUL89LHQAlf75
         DWezK91E7nW6vd7H60zvsy/DmhlF+9LvSd0MM4dEHX5IoGpxuthSxyofeSs4pf+wRqTZ
         lLTj6xajnQSg7VWXme8V71RQ9r29jhqBZpo10B58LUIsI09B24rCvXMf4cyPU4HUdT1t
         g2l777qK0rvFpvfljMQOIeu0nOLuaTTitl1dWy/Xni9Lgfcp9F+dYltc/5n/kyVH3a4T
         YPVQ==
X-Gm-Message-State: AOAM532taL8GNqTmkUGInV/ImLWRlv/6aYRDNqGvAq7Yv+WHof0NHi43
        PbkCvWisJppxgy80+YRq4lqFZtVGMN4ns9hbs+A9gu0m/B0=
X-Google-Smtp-Source: ABdhPJzywmsn6pCUSPdTR9s7ZRQpjcBW5PvfcHOujNzTgq2SvYylnYWvd7zbXvjAm8rukRv6p/r9fkSbhqB3Q9qw+8I=
X-Received: by 2002:a92:c6c3:: with SMTP id v3mr4451791ilm.281.1607953417845;
 Mon, 14 Dec 2020 05:43:37 -0800 (PST)
MIME-Version: 1.0
From:   Ilya Dryomov <idryomov@gmail.com>
Date:   Mon, 14 Dec 2020 14:43:26 +0100
Message-ID: <CAOi1vP_gHLrNBe-pU9G+GmE+JF8g2SY7UqgGqzeW5sXXf1jAcQ@mail.gmail.com>
Subject: wip-msgr2
To:     Ceph Development <ceph-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Hello,

I've pushed wip-msgr2 and opened a dummy PR in ceph-client:

  https://github.com/ceph/ceph-client/pull/22

This set has been through a over a dozen krbd test suite runs with no
issues other than those with the test suite itself.  The diffstat is
rather big, so I didn't want to spam the list.  If someone wants it
posted, let me know.  Any comments are welcome!

 drivers/block/rbd.c                |    8 +-
 fs/ceph/mds_client.c               |  106 +-
 fs/ceph/mdsmap.c                   |   21 +-
 include/linux/ceph/auth.h          |   68 +-
 include/linux/ceph/ceph_features.h |   11 +-
 include/linux/ceph/ceph_fs.h       |   11 +
 include/linux/ceph/decode.h        |    8 +
 include/linux/ceph/libceph.h       |   10 +-
 include/linux/ceph/mdsmap.h        |    2 +-
 include/linux/ceph/messenger.h     |  285 ++-
 include/linux/ceph/msgr.h          |   57 +-
 include/linux/ceph/osdmap.h        |    4 +-
 net/ceph/Kconfig                   |    3 +
 net/ceph/Makefile                  |    3 +-
 net/ceph/auth.c                    |  408 ++++-
 net/ceph/auth_none.c               |    5 +-
 net/ceph/auth_x.c                  |  298 +++-
 net/ceph/auth_x_protocol.h         |    3 +-
 net/ceph/ceph_common.c             |   63 +
 net/ceph/ceph_strings.c            |   28 +
 net/ceph/crypto.h                  |    3 +
 net/ceph/decode.c                  |  101 ++
 net/ceph/messenger.c               | 2252 +++++------------------
 net/ceph/messenger_v1.c            | 1506 ++++++++++++++++
 net/ceph/messenger_v2.c            | 3443 ++++++++++++++++++++++++++++++++
 net/ceph/mon_client.c              |  320 +++-
 net/ceph/osd_client.c              |  111 +-
 net/ceph/osdmap.c                  |   45 +-
 28 files changed, 7027 insertions(+), 2156 deletions(-)
 create mode 100644 net/ceph/messenger_v1.c
 create mode 100644 net/ceph/messenger_v2.c

Thanks,

                Ilya
