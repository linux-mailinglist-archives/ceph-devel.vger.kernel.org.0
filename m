Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7186718C609
	for <lists+ceph-devel@lfdr.de>; Fri, 20 Mar 2020 04:45:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726646AbgCTDpR (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 19 Mar 2020 23:45:17 -0400
Received: from us-smtp-delivery-74.mimecast.com ([63.128.21.74]:33938 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726103AbgCTDpQ (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Thu, 19 Mar 2020 23:45:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1584675915;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc; bh=xmG51exzUm2WnPBZoBNKBwxYjidz0QhjL4RJEVNat20=;
        b=eKGSvC4kcIv1r8QDqnmGNr28snBfYHkvwKDhsBkjz2mqN8V0jVkEdd7j1s+4AjxxscDt/+
        jurp2y/qyND/s65xq1mWnvQYn2X4G4wX+YFlC92klSAR+JV0ZdS+7ugXlQyr4Gog8UDF8L
        V42olzsNpZzu3XGAn1mS35FkZx5kdYk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-288-9_bQ1BVtPZOQ-p-FMEc1xg-1; Thu, 19 Mar 2020 23:45:13 -0400
X-MC-Unique: 9_bQ1BVtPZOQ-p-FMEc1xg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 86346107ACCA;
        Fri, 20 Mar 2020 03:45:12 +0000 (UTC)
Received: from lxbceph0.gsslab.pek2.redhat.com (vm36-245.gsslab.pek2.redhat.com [10.72.36.245])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 483485D9E2;
        Fri, 20 Mar 2020 03:45:06 +0000 (UTC)
From:   xiubli@redhat.com
To:     jlayton@kernel.org
Cc:     sage@redhat.com, idryomov@gmail.com, gfarnum@redhat.com,
        zyan@redhat.com, pdonnell@redhat.com, ceph-devel@vger.kernel.org,
        Xiubo Li <xiubli@redhat.com>
Subject: [PATCH v13 0/4] ceph: add perf metrics support
Date:   Thu, 19 Mar 2020 23:44:58 -0400
Message-Id: <1584675902-16493-1-git-send-email-xiubli@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: Xiubo Li <xiubli@redhat.com>

# cat /sys/kernel/debug/ceph/9a972bfc-68cb-4d52-a610-7cd9a9adbbdd.client52904/metrics
item          total       avg_lat(us)     min_lat(us)     max_lat(us)     stdev(us)
-----------------------------------------------------------------------------------
read          21979       2093            765             248778          2771
write         1129        45184           30252           368629          20437
metadata      3           6462            1674            14260           6811

item          total           miss            hit
-------------------------------------------------
d_lease       2               0               1
caps          2               4               24248


Chnaged in V13:
- [3/4] and [4/4] switch jiffies to ktime_t for the start/end time stamp, which
  will make it much preciser, such as when the IO latency(end - start) < 1ms and
  if the HZ==1000, then we will always get end == start in jiffies, and the min
  will always be 0, actually it should be in range (0, 1000)us.
- [3/4] since by using ktime helpers we are calculating the stdev in nanosecond,
  then switch to us, so to compute the reminder make no sense any more, remove it
  from stdev.

Changed in V12:
- [3/4] and [4/4] switch atomic64_t type to u64 for lat sum and total numbers

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

Xiubo Li (4):
  ceph: add dentry lease metric support
  ceph: add caps perf metric for each superblock
  ceph: add read/write latency metric support
  ceph: add metadata perf metric support

 fs/ceph/Makefile                |   2 +-
 fs/ceph/acl.c                   |   2 +-
 fs/ceph/addr.c                  |  20 ++++++
 fs/ceph/caps.c                  |  19 ++++++
 fs/ceph/debugfs.c               | 100 +++++++++++++++++++++++++--
 fs/ceph/dir.c                   |  17 ++++-
 fs/ceph/file.c                  |  30 ++++++++
 fs/ceph/inode.c                 |   4 +-
 fs/ceph/mds_client.c            |  23 ++++++-
 fs/ceph/mds_client.h            |   7 ++
 fs/ceph/metric.c                | 148 ++++++++++++++++++++++++++++++++++++++++
 fs/ceph/metric.h                |  62 +++++++++++++++++
 fs/ceph/super.h                 |   9 ++-
 fs/ceph/xattr.c                 |   4 +-
 include/linux/ceph/osd_client.h |   3 +
 net/ceph/osd_client.c           |   3 +
 16 files changed, 436 insertions(+), 17 deletions(-)
 create mode 100644 fs/ceph/metric.c
 create mode 100644 fs/ceph/metric.h

-- 
1.8.3.1

