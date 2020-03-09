Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 15B0F17D9EC
	for <lists+ceph-devel@lfdr.de>; Mon,  9 Mar 2020 08:37:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726217AbgCIHhX (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 9 Mar 2020 03:37:23 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:41330 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725796AbgCIHhX (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 9 Mar 2020 03:37:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1583739442;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc; bh=O4f98KnIOL/vi/reAobt6ydEQ3jrD8iMHP5+iXfy4jE=;
        b=K1L102b+hnsSHjh/iOSYv3lLuFnVy9j48jFCHFR2WSxy8RQeNzdlyT83nYo1Qxsc9iLink
        iQg85RXNpdcM8ZspV6NwVlgul3nUh1CITnOLxkxt6papCLYQZ/Kcc2xF1sbm6bR9xdwOZg
        T1iRhKF4ntgbGNAoL4aP8Bueb0bPbu0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-23-jSp_Z7M1ONS4DIn2N9hqOg-1; Mon, 09 Mar 2020 03:37:19 -0400
X-MC-Unique: jSp_Z7M1ONS4DIn2N9hqOg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C48F7184C800;
        Mon,  9 Mar 2020 07:37:18 +0000 (UTC)
Received: from lxbceph0.gsslab.pek2.redhat.com (vm36-245.gsslab.pek2.redhat.com [10.72.36.245])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 828C690F71;
        Mon,  9 Mar 2020 07:37:13 +0000 (UTC)
From:   xiubli@redhat.com
To:     jlayton@kernel.org, idryomov@gmail.com
Cc:     sage@redhat.com, zyan@redhat.com, pdonnell@redhat.com,
        ceph-devel@vger.kernel.org, Xiubo Li <xiubli@redhat.com>
Subject: [PATCH v9 0/5] ceph: add perf metrics support
Date:   Mon,  9 Mar 2020 03:37:05 -0400
Message-Id: <1583739430-4928-1-git-send-email-xiubli@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: Xiubo Li <xiubli@redhat.com>

Changed in V9:
- add an r_ended field to the mds request struct and use that to calculate the metric
- fix some commit comments

We can get the metrics from the debugfs:

$ cat /sys/kernel/debug/ceph/0c93a60d-5645-4c46-8568-4c8f63db4c7f.client4267/metrics 
item          total       sum_lat(us)     avg_lat(us)
-----------------------------------------------------
read          13          417000          32076
write         42          131205000       3123928
metadata      104         493000          4740

item          total           miss            hit
-------------------------------------------------
d_lease       204             0               918
caps          204             213             368218


Xiubo Li (5):
  ceph: add global dentry lease metric support
  ceph: add caps perf metric for each session
  ceph: add global read latency metric support
  ceph: add global write latency metric support
  ceph: add global metadata perf metric support

 fs/ceph/acl.c                   |   2 +-
 fs/ceph/addr.c                  |  18 +++++++
 fs/ceph/caps.c                  |  19 ++++++++
 fs/ceph/debugfs.c               |  71 ++++++++++++++++++++++++++--
 fs/ceph/dir.c                   |  17 ++++++-
 fs/ceph/file.c                  |  26 ++++++++++
 fs/ceph/inode.c                 |   4 +-
 fs/ceph/mds_client.c            | 102 +++++++++++++++++++++++++++++++++++++++-
 fs/ceph/mds_client.h            |   7 ++-
 fs/ceph/metric.h                |  69 +++++++++++++++++++++++++++
 fs/ceph/super.h                 |   9 ++--
 fs/ceph/xattr.c                 |   4 +-
 include/linux/ceph/osd_client.h |   1 +
 net/ceph/osd_client.c           |   2 +
 14 files changed, 334 insertions(+), 17 deletions(-)
 create mode 100644 fs/ceph/metric.h

-- 
1.8.3.1

