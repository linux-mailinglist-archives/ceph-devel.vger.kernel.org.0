Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 44C8918AC97
	for <lists+ceph-devel@lfdr.de>; Thu, 19 Mar 2020 07:00:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727085AbgCSGAm (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 19 Mar 2020 02:00:42 -0400
Received: from us-smtp-delivery-74.mimecast.com ([63.128.21.74]:36517 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727048AbgCSGAm (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Thu, 19 Mar 2020 02:00:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1584597640;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc; bh=DWAKzOU23iQuFrZ8NqNxnYxOFUckDgRhKql/nOsa6T8=;
        b=CdUBLmoYYliMmYqYKU69EEUNOlcoe5Wkl2vuFfuCO4q/GsZIA22FALDmL0L2CLAOc8xqie
        bHw/g4fzL2O/7IexYjRTmJ8rQeanf8JFaivOUKvZFuYEDDGVPZscUPfMn7SJnDHlJfVDtt
        oaWuU17mLhw7DWCAS14g0TuQp2w2BR8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-202-66n6GqqJOd-ymmcnlobYAQ-1; Thu, 19 Mar 2020 02:00:36 -0400
X-MC-Unique: 66n6GqqJOd-ymmcnlobYAQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E4C9C8010F2;
        Thu, 19 Mar 2020 06:00:35 +0000 (UTC)
Received: from lxbceph0.gsslab.pek2.redhat.com (vm36-245.gsslab.pek2.redhat.com [10.72.36.245])
        by smtp.corp.redhat.com (Postfix) with ESMTP id EE166BBBF4;
        Thu, 19 Mar 2020 06:00:29 +0000 (UTC)
From:   xiubli@redhat.com
To:     jlayton@kernel.org
Cc:     sage@redhat.com, idryomov@gmail.com, gfarnum@redhat.com,
        zyan@redhat.com, pdonnell@redhat.com, ceph-devel@vger.kernel.org,
        Xiubo Li <xiubli@redhat.com>
Subject: [PATCH v11 0/4] ceph: add perf metrics support
Date:   Thu, 19 Mar 2020 02:00:22 -0400
Message-Id: <1584597626-11127-1-git-send-email-xiubli@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: Xiubo Li <xiubli@redhat.com>

Changed in V11:
- [3/4] and [4/4] fold the min/max/stdev factors

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




Xiubo Li (4):
  ceph: add dentry lease metric support
  ceph: add caps perf metric for each session
  ceph: add read/write latency metric support
  ceph: add metadata perf metric support

 fs/ceph/Makefile                |   2 +-
 fs/ceph/acl.c                   |   2 +-
 fs/ceph/addr.c                  |  18 ++++
 fs/ceph/caps.c                  |  19 ++++
 fs/ceph/debugfs.c               | 117 +++++++++++++++++++++++-
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
 16 files changed, 488 insertions(+), 18 deletions(-)
 create mode 100644 fs/ceph/metric.c
 create mode 100644 fs/ceph/metric.h

-- 
1.8.3.1

