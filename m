Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C1E29133F76
	for <lists+ceph-devel@lfdr.de>; Wed,  8 Jan 2020 11:42:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727337AbgAHKmL (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 8 Jan 2020 05:42:11 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:28314 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726466AbgAHKmL (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 8 Jan 2020 05:42:11 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1578480130;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=NZY9emwZ5LaUa+9BSyTVzk98N9QXldEUPL7XJnoxKtY=;
        b=DZ/gDfsBzMN83zjxiu+RlUpIz9SdOHAgNGLxC5NJ5GWegRECpZGMrFkrst5tegMIFlJyGL
        X59lHEl5jJ0k8SBUNnxVqTQVKLLMTYmqHH9cp8BmLZLrnKPbW8U7s+Sa+4VuWml/uc8a9n
        aXM3WQ3ASMlmFpUmMHMaWyEwdSgs1wg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-177-jvSuTJ37NVe2IGYF-JSkMA-1; Wed, 08 Jan 2020 05:42:08 -0500
X-MC-Unique: jvSuTJ37NVe2IGYF-JSkMA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A238C184B1E0;
        Wed,  8 Jan 2020 10:42:07 +0000 (UTC)
Received: from localhost.localdomain (ovpn-12-70.pek2.redhat.com [10.72.12.70])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C9E3619C58;
        Wed,  8 Jan 2020 10:42:02 +0000 (UTC)
From:   xiubli@redhat.com
To:     jlayton@kernel.org, idryomov@gmail.com, zyan@redhat.com
Cc:     sage@redhat.com, pdonnell@redhat.com, ceph-devel@vger.kernel.org,
        Xiubo Li <xiubli@redhat.com>
Subject: [PATCH v2 0/8] ceph: add perf metrics support
Date:   Wed,  8 Jan 2020 05:41:44 -0500
Message-Id: <20200108104152.28468-1-xiubli@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Content-Transfer-Encoding: quoted-printable
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: Xiubo Li <xiubli@redhat.com>

Changed in V2:
- add read/write/metadata latency metric support.
- add and send client provided metric flags in client metadata
- addressed the comments from Ilya and merged the 4/4 patch into 3/4.
- addressed all the other comments in v1 series.

In this version it will send the metrics to the MDSs every second if
sending_metrics is enabled, disable as default.



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

session       caps            miss            hit
-------------------------------------------------
0             204             213             368218


In the MDS side, we can get the metrics(NOTE: the latency is in
nanosecond):

$ ./bin/ceph fs perf stats | python -m json.tool
{
    "client_metadata": {
        "client.4267": {
            "IP": "v1:192.168.195.165",
            "hostname": "fedora1",
            "mount_point": "N/A",
            "root": "/"
        }
    },
    "counters": [
        "cap_hit"
    ],
    "global_counters": [
        "read_latency",
        "write_latency",
        "metadata_latency",
        "dentry_lease_hit"
    ],
    "global_metrics": {
        "client.4267": [
            [
                0,
                32076923
            ],
            [
                3,
                123928571
            ],
            [
                0,
                4740384
            ],
            [
                918,
                0
            ]
        ]
    },
    "metrics": {
        "delayed_ranks": [],
        "mds.0": {
            "client.4267": [
                [
                    368218,
                    213
                ]
            ]
        }
    }
}



Xiubo Li (8):
  ceph: add global dentry lease metric support
  ceph: add caps perf metric for each session
  ceph: add global read latency metric support
  ceph: add global write latency metric support
  ceph: add global metadata perf metric support
  ceph: periodically send perf metrics to MDS
  ceph: add reset metrics support
  ceph: send client provided metric flags in client metadata

 fs/ceph/acl.c                   |   2 +-
 fs/ceph/addr.c                  |  38 +++-
 fs/ceph/caps.c                  |  63 ++++--
 fs/ceph/debugfs.c               | 182 +++++++++++++++-
 fs/ceph/dir.c                   |  38 +++-
 fs/ceph/file.c                  |  26 ++-
 fs/ceph/inode.c                 |   8 +-
 fs/ceph/mds_client.c            | 369 ++++++++++++++++++++++++++++++--
 fs/ceph/mds_client.h            |  48 +++++
 fs/ceph/snap.c                  |   2 +-
 fs/ceph/super.h                 |  15 +-
 fs/ceph/xattr.c                 |   8 +-
 include/linux/ceph/ceph_fs.h    |  77 +++++++
 include/linux/ceph/osd_client.h |   5 +-
 net/ceph/osd_client.c           |  18 +-
 15 files changed, 826 insertions(+), 73 deletions(-)

--=20
2.21.0

