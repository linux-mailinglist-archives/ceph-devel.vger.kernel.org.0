Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A55EB40A995
	for <lists+ceph-devel@lfdr.de>; Tue, 14 Sep 2021 10:49:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229673AbhINIua (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 14 Sep 2021 04:50:30 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:23200 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229526AbhINIu3 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Tue, 14 Sep 2021 04:50:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1631609352;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=UhhMlYj2jdWVd+qGrTc/pWAyVK3vv2lCtDjmXZ4sS3E=;
        b=USicgr+w6JfDOPC+qY84vxmo1JIZmIfF4WN+ndNwVNhDJCZgk0ch0szESA3EQVHmU9RjM0
        VE1cAb7stwRBzUE9XupQTpfoZniwtU2IKRKZhGvLt61taWtE7xd9SwWZoxmAfFd/kSDbgZ
        OoVjVtC0yACEuohtCyf5AqdvM5dIbzY=
Received: from mail-pf1-f198.google.com (mail-pf1-f198.google.com
 [209.85.210.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-204-i9EmqHcYNhSQZqgl8xRQxA-1; Tue, 14 Sep 2021 04:49:11 -0400
X-MC-Unique: i9EmqHcYNhSQZqgl8xRQxA-1
Received: by mail-pf1-f198.google.com with SMTP id g17-20020aa781910000b0290360a5312e3eso7882404pfi.7
        for <ceph-devel@vger.kernel.org>; Tue, 14 Sep 2021 01:49:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=UhhMlYj2jdWVd+qGrTc/pWAyVK3vv2lCtDjmXZ4sS3E=;
        b=peunSTEfx/R+VLH3T/BS7uOXbJK2ZiUsbHsbX5yXQGdJMKZp1TNLdoYJC81k2wmm2v
         lPwkXOsMnsXj28BjlhXVo4C8FRTIEGH6Ybo2hIxCzH0fiz4SwQIAeiwJ+T6Z0sVWClzv
         mKtOG4xSQ6zteq0tluhi8kNzG7hMNu8bGi7P73hyyk/KcywIWSfOHW6R8ZDpAjXGE/AW
         tWd8xuuVMuV81lioUo9lmM/JFjQ7tpvuw2zzUEhvHVZUybczVlKIkg7zkT342EtCxIMj
         ir5hoUORGqJhgpzkyqHExYxiExUc7zslKJ2LJDQEH38d92Sx104AU85aqIQ9gQNmmerh
         pNDw==
X-Gm-Message-State: AOAM533kENrkjo5g0KRH6mDwxU2xB9U3L9bOUIylQYkgyQVtatNV5dLm
        0D+18fO2P9RVaN+MesMA02hXhK/KbRwdvBKJLP+FcN3GeCwc4SK9wfMVcuNcNIxIygIVtfci+Oo
        +VUuNC3urjX3zPCuJW4Qe3w==
X-Received: by 2002:a17:90a:4093:: with SMTP id l19mr855926pjg.118.1631609349911;
        Tue, 14 Sep 2021 01:49:09 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwBnUACNbkpUqH56omBeLNMA6EbdvlfxQ3Oh+Db0oX4jNgR8Pzegdu+oZke/GTlHfTv161y6Q==
X-Received: by 2002:a17:90a:4093:: with SMTP id l19mr855904pjg.118.1631609349680;
        Tue, 14 Sep 2021 01:49:09 -0700 (PDT)
Received: from h3ckers-pride.redhat.com ([49.207.198.118])
        by smtp.gmail.com with ESMTPSA id b12sm10006219pff.63.2021.09.14.01.49.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Sep 2021 01:49:09 -0700 (PDT)
From:   Venky Shankar <vshankar@redhat.com>
To:     jlayton@redhat.com, pdonnell@redhat.com, xiubli@redhat.com
Cc:     ceph-devel@vger.kernel.org, Venky Shankar <vshankar@redhat.com>
Subject: [PATCH v2 0/4] ceph: forward average read/write/metadata latency
Date:   Tue, 14 Sep 2021 14:18:58 +0530
Message-Id: <20210914084902.1618064-1-vshankar@redhat.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

v2:
  - based on top of ceph-client/testing branch

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

 fs/ceph/debugfs.c |  20 ++++-----
 fs/ceph/metric.c  | 105 ++++++++++++++++++++++------------------------
 fs/ceph/metric.h  |  68 +++++++++++++++++++-----------
 3 files changed, 104 insertions(+), 89 deletions(-)

-- 
2.31.1

