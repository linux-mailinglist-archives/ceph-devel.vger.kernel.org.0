Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D29B3163B6D
	for <lists+ceph-devel@lfdr.de>; Wed, 19 Feb 2020 04:39:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726496AbgBSDj4 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 18 Feb 2020 22:39:56 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:43712 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726403AbgBSDj4 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 18 Feb 2020 22:39:56 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582083595;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=F32S/p1TpdOGPAwyddGUuMeOlxSe/G/GR6gfTQd00Qg=;
        b=LRtGK1OYf0RgbPX60KHBnvQbpjkYkLO/9v/u1ssDFZlBRugAbJfZxWciYJ9nHoxMyNQmVK
        mc0A5ingw7Q86lrcHG0V0PB4QvKCFEVI+M4wjt3QEPyI7cIvzp3HJ9s4FS3fQsmi/AuSfy
        Nqtlpg/U/5duIkzovqN51en5fb8Dcec=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-70-fymJOBw-OXyBfICqIhAx9w-1; Tue, 18 Feb 2020 22:39:53 -0500
X-MC-Unique: fymJOBw-OXyBfICqIhAx9w-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4B319100550E;
        Wed, 19 Feb 2020 03:39:52 +0000 (UTC)
Received: from localhost.localdomain (ovpn-12-94.pek2.redhat.com [10.72.12.94])
        by smtp.corp.redhat.com (Postfix) with ESMTP id CE86960C81;
        Wed, 19 Feb 2020 03:39:46 +0000 (UTC)
From:   xiubli@redhat.com
To:     jlayton@kernel.org, idryomov@gmail.com
Cc:     sage@redhat.com, zyan@redhat.com, pdonnell@redhat.com,
        ceph-devel@vger.kernel.org, Xiubo Li <xiubli@redhat.com>
Subject: [PATCH v7 0/5] ceph: add perf metrics support
Date:   Tue, 18 Feb 2020 22:38:46 -0500
Message-Id: <20200219033851.6548-1-xiubli@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Content-Transfer-Encoding: quoted-printable
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: Xiubo Li <xiubli@redhat.com>

Changed in V7:
- Rebase to the latest commit
- Address the comments for cap patch.
- Drop the other patches which will send the metrics to ceph cluster for
now.

We can get the metrics from the debugfs:

$ cat /sys/kernel/debug/ceph/0c93a60d-5645-4c46-8568-4c8f63db4c7f.client4=
267/metrics=20
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

 fs/ceph/acl.c                   |   2 +
 fs/ceph/addr.c                  |  13 ++++
 fs/ceph/caps.c                  |  31 ++++++++++
 fs/ceph/debugfs.c               |  71 ++++++++++++++++++++--
 fs/ceph/dir.c                   |  25 ++++++--
 fs/ceph/file.c                  |  22 +++++++
 fs/ceph/mds_client.c            | 103 +++++++++++++++++++++++++++++++-
 fs/ceph/mds_client.h            |   4 ++
 fs/ceph/metric.h                |  65 ++++++++++++++++++++
 fs/ceph/quota.c                 |   9 ++-
 fs/ceph/super.h                 |  10 ++++
 fs/ceph/xattr.c                 |  17 +++++-
 include/linux/ceph/osd_client.h |   1 +
 net/ceph/osd_client.c           |   2 +
 14 files changed, 360 insertions(+), 15 deletions(-)
 create mode 100644 fs/ceph/metric.h

--=20
2.21.0

