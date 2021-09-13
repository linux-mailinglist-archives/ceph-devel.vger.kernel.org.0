Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DAB55408C30
	for <lists+ceph-devel@lfdr.de>; Mon, 13 Sep 2021 15:14:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235706AbhIMNOx (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 13 Sep 2021 09:14:53 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:29579 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240439AbhIMNOk (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Mon, 13 Sep 2021 09:14:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1631538802;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=hWmcRpWnOsp+N9j6fGp+ij04uAX9QRgGPLAr7qd6RP4=;
        b=dn0e1hKYMFjNGZHhaVnlfobSdX6DyauRGOLCblz+7GOnXajfiMLxajU9gIg8Cis7MLm2fn
        eMGrjfO0GArR2Wwd4KgJle6Q2Bww9wCDBRSx1gBKMkNGlFhn5ZgkBGqihLS/ELC6kTrKkR
        lny+tExeEPx4o3mQJqinifoR1bD2W4o=
Received: from mail-pg1-f198.google.com (mail-pg1-f198.google.com
 [209.85.215.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-5-gxcIx9uWPEqe1qyyKp9iBA-1; Mon, 13 Sep 2021 09:13:21 -0400
X-MC-Unique: gxcIx9uWPEqe1qyyKp9iBA-1
Received: by mail-pg1-f198.google.com with SMTP id d5-20020a63ed05000000b002688d3aff8aso7361655pgi.2
        for <ceph-devel@vger.kernel.org>; Mon, 13 Sep 2021 06:13:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=hWmcRpWnOsp+N9j6fGp+ij04uAX9QRgGPLAr7qd6RP4=;
        b=lW8dS/AnUOUEDgzGaFH1fSXrBcFX66vs3MkoIFy5J1+a2Z2IiMQzo2HHqAOoCzirmW
         70CZw20QyNtOC8xiwjXzkxT3cNNsv+UZrRCcWNtJJkBYEI9U/Z4z4s1gW6ndpy3lrnHA
         qHvXTTHUBPymGV0BxXgA+KwHqUvBcr140VYsk1Q2WCFtGyiJ5aK5BP7t8IMIDcOeQdVp
         +vCwV2JTBdXlti0s4mP2jy+bbJEOR580+rloTeJIGdjJORpVegAF6zyPynEVtuxoqOV9
         L5Xm9pJyZe6RttByA2+ZpNyGwD2PM+AHAvwlwQHylvCdpOOYgyRkQl9+k0b+PI03CsNJ
         s0tA==
X-Gm-Message-State: AOAM530X5nACVCJTlmt7cRctghOH8oz2P+vg1SgZthakZiP725sksKC+
        Y/IoaMWn1GlZDKwVzOqYYHXGYPgN06XrCrGl9GJ2OmztlfrVgClLmtOWdoJiBNzBJLHK96HuYEz
        STkeaxD9oPjVhpzISEXEZGw==
X-Received: by 2002:a17:90a:4d8d:: with SMTP id m13mr12917391pjh.190.1631538800253;
        Mon, 13 Sep 2021 06:13:20 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzFQMkfGNt+i/6BzKNKcQmAjxURStWyMr2yGywEz5WtCu7T62yU7+vMvqilnbGfvpUsIWG7Vw==
X-Received: by 2002:a17:90a:4d8d:: with SMTP id m13mr12917370pjh.190.1631538800042;
        Mon, 13 Sep 2021 06:13:20 -0700 (PDT)
Received: from h3ckers-pride.redhat.com ([49.207.198.118])
        by smtp.gmail.com with ESMTPSA id i10sm7362010pfk.151.2021.09.13.06.13.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Sep 2021 06:13:19 -0700 (PDT)
From:   Venky Shankar <vshankar@redhat.com>
To:     jlayton@redhat.com, pdonnell@redhat.com, xiubli@redhat.com
Cc:     ceph-devel@vger.kernel.org, Venky Shankar <vshankar@redhat.com>
Subject: [PATCH v1 0/4] ceph: forward average read/write/metadata latency
Date:   Mon, 13 Sep 2021 18:43:07 +0530
Message-Id: <20210913131311.1347903-1-vshankar@redhat.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Right now, cumulative read/write/metadata latencies are tracked
and are periodically forwarded to the MDS. These meterics are not
particularly useful. A much more useful metric is the average latency
and standard deviation (stdev) which is what this series of patches
aims to do.

The userspace (libcephfs+tool) changes are here::

          https://github.com/ceph/ceph/pull/41397

The math involved in keeping track of the average latency and stdev
seems incorrect, so, this series fixes that up too (closely mimics
how its done in userspace with some restrictions obviously) as per::

          NEW_AVG = OLD_AVG + ((latency - OLD_AVG) / total_ops)
          NEW_STDEV = SQRT(((OLD_STDEV + (latency - OLD_AVG)*(latency - NEW_AVG)) / (total_ops - 1)))

Note that the cumulative latencies are still forwarded to the MDS but
the tool (cephfs-top) ignores it altogether.

Venky Shankar (4):
  ceph: use "struct ceph_timespec" for r/w/m latencies
  ceph: track average/stdev r/w/m latency
  ceph: include average/stddev r/w/m latency in mds metrics
  ceph: use tracked average r/w/m latencies to display metrics in
    debugfs

 fs/ceph/debugfs.c | 12 +++----
 fs/ceph/metric.c  | 81 +++++++++++++++++++++++++----------------------
 fs/ceph/metric.h  | 64 +++++++++++++++++++++++--------------
 3 files changed, 90 insertions(+), 67 deletions(-)

-- 
2.27.0

