Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AC927189D8C
	for <lists+ceph-devel@lfdr.de>; Wed, 18 Mar 2020 15:06:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726962AbgCROGU (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 18 Mar 2020 10:06:20 -0400
Received: from us-smtp-delivery-74.mimecast.com ([216.205.24.74]:56720 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726738AbgCROGU (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Wed, 18 Mar 2020 10:06:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1584540378;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc; bh=AWS6w/SRDEbhPW6/fX6AhZAgRoMyjiNpr/HHWJhYuAU=;
        b=SAWcT8G+JH6BQR/gBldEXVQ1zqSIwn91SaWzLA5o+qsaFJFu6s3wjJikXGobiYljNo1yhL
        Gl92Tq+clyOWkkX2/7shWVpYDwyJxS+fWZSU8RT9rTIuCLICUvz3jXVvfts5UWWlpZE91l
        6QbRf+EDWozfrqw4lCxGoXoq5G7KapU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-341-sMPyy0iCMS6hs1UGPzZ8_A-1; Wed, 18 Mar 2020 10:06:11 -0400
X-MC-Unique: sMPyy0iCMS6hs1UGPzZ8_A-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CAE7A1005512;
        Wed, 18 Mar 2020 14:06:09 +0000 (UTC)
Received: from lxbceph0.gsslab.pek2.redhat.com (vm36-245.gsslab.pek2.redhat.com [10.72.36.245])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 307B91001920;
        Wed, 18 Mar 2020 14:06:01 +0000 (UTC)
From:   xiubli@redhat.com
To:     jlayton@kernel.org
Cc:     sage@redhat.com, idryomov@gmail.com, gfarnum@redhat.com,
        zyan@redhat.com, pdonnell@redhat.com, ceph-devel@vger.kernel.org,
        Xiubo Li <xiubli@redhat.com>
Subject: [PATCH v10 0/6] ceph: add perf metrics support
Date:   Wed, 18 Mar 2020 10:05:50 -0400
Message-Id: <1584540356-5885-1-git-send-email-xiubli@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: Xiubo Li <xiubli@redhat.com>

Changed in V10:
- rebase to the latest testing branch
- merge all the metric related patches into one
- [1/6] move metric helpers into a new file metric.c
- [2/6] move metric helpers into metric.c
- [3/6] merge the read/write patches into a signal patch and move metric helpers to metric.c
- [4/6] move metric helpers to metric.c
- [5/6] min/max latency support
- [6/6] standard deviation support

Changed in V9:
- add an r_ended field to the mds request struct and use that to calculate the metric
- fix some commit comments

# cat /sys/kernel/debug/ceph/9a972bfc-68cb-4d52-a610-7cd9a9adbbdd.client52904/metrics
item          total       avg_lat(us)     min_lat(us)     max_lat(us)     stdev(us)
-----------------------------------------------------------------------------------
read          798         32000           4000            196000          560.3
write         2394        588000          28000           4812000         36673.9
metadata      7           116000          2000            707000          8282.8

item          total           miss            hit
-------------------------------------------------
d_lease       2               0               0
caps          2               14              546500




Xiubo Li (6):
  ceph: add dentry lease metric support
  ceph: add caps perf metric for each session
  ceph: add read/write latency metric support
  ceph: add metadata perf metric support
  ceph: add min/max latency support for read/write/metadata metrics
  ceph: add standard deviation support for read/write/metadata perf
    metric

 fs/ceph/Makefile                |   2 +-
 fs/ceph/acl.c                   |   2 +-
 fs/ceph/addr.c                  |  18 ++++
 fs/ceph/caps.c                  |  19 ++++
 fs/ceph/debugfs.c               | 116 +++++++++++++++++++++++-
 fs/ceph/dir.c                   |  17 +++-
 fs/ceph/file.c                  |  26 ++++++
 fs/ceph/inode.c                 |   4 +-
 fs/ceph/mds_client.c            |  21 ++++-
 fs/ceph/mds_client.h            |   7 +-
 fs/ceph/metric.c                | 193 ++++++++++++++++++++++++++++++++++++++++
 fs/ceph/metric.h                |  64 +++++++++++++
 fs/ceph/super.h                 |   9 +-
 fs/ceph/xattr.c                 |   4 +-
 include/linux/ceph/osd_client.h |   1 +
 net/ceph/osd_client.c           |   2 +
 16 files changed, 487 insertions(+), 18 deletions(-)
 create mode 100644 fs/ceph/metric.c
 create mode 100644 fs/ceph/metric.h

-- 
1.8.3.1

