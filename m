Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6CB6013B83F
	for <lists+ceph-devel@lfdr.de>; Wed, 15 Jan 2020 04:45:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728894AbgAODpO (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 14 Jan 2020 22:45:14 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:54878 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728879AbgAODpO (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Tue, 14 Jan 2020 22:45:14 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579059912;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=t0cwY4pUJb5QtKU1ZzjRY4cZVUYo86gSsG6wC6JGFnI=;
        b=SXE3cWePb6NZvWNaagBZ9rBTpT2zwnCAXbRH0OkSkBKfYsDk4uTUKLf3xcHWwTHiBm16WA
        iMnd5uRs0KU+wTiZMpQ37GMa7akxK6l9a9cVTr3iWM6v+RhhRwVUVyASyT5JxipqPtWl42
        kylKHEUHE0YLclTrS+ZCm65P1TQnJo8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-431-KIqr-XvVPm6Z6EqgmHf-mQ-1; Tue, 14 Jan 2020 22:45:11 -0500
X-MC-Unique: KIqr-XvVPm6Z6EqgmHf-mQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E746510054E3;
        Wed, 15 Jan 2020 03:45:09 +0000 (UTC)
Received: from localhost.localdomain (ovpn-12-49.pek2.redhat.com [10.72.12.49])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 986A8101F6D4;
        Wed, 15 Jan 2020 03:45:02 +0000 (UTC)
From:   xiubli@redhat.com
To:     jlayton@kernel.org, idryomov@gmail.com, zyan@redhat.com
Cc:     sage@redhat.com, pdonnell@redhat.com, ceph-devel@vger.kernel.org,
        Xiubo Li <xiubli@redhat.com>
Subject: [PATCH v3 0/8] ceph: add perf metrics support
Date:   Tue, 14 Jan 2020 22:44:36 -0500
Message-Id: <20200115034444.14304-1-xiubli@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
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

Changed in V3:
- addressed Jeff's comments and let's the callers do the metric
counting.
- with some small fixes for the read/write latency
- tested based on the latest testing branch


It will send the metrics to the MDSs every second if sending_metrics is e=
nabled, disable as default.


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


The provided metric flags in client metadata

$./bin/cephfs-journal-tool --rank=3D1:0 event get --type=3DSESSION json
Wrote output to JSON file 'dump'
$ cat dump
[=20
    {
        "client instance": "client.4275 v1:192.168.195.165:0/461391971",
        "open": "true",
        "client map version": 1,
        "inos": "[]",
        "inotable version": 0,
        "client_metadata": {
            "client_features": {
                "feature_bits": "0000000000001bff"
            },
            "metric_spec": {
                "metric_flags": {
                    "feature_bits": "000000000000001f"
                }
            },
            "entity_id": "",
            "hostname": "fedora1",
            "kernel_version": "5.5.0-rc2+",
            "root": "/"
        }
    },
[...]


Xiubo Li (8):
  ceph: add global dentry lease metric support
  ceph: add caps perf metric for each session
  ceph: add global read latency metric support
  ceph: add global write latency metric support
  ceph: add global metadata perf metric support
  ceph: periodically send perf metrics to MDS
  ceph: add reset metrics support
  ceph: send client provided metric flags in client metadata

 fs/ceph/acl.c                   |   2 +
 fs/ceph/addr.c                  |  39 +++-
 fs/ceph/caps.c                  |  71 ++++++
 fs/ceph/debugfs.c               | 182 +++++++++++++++-
 fs/ceph/dir.c                   |  22 +-
 fs/ceph/file.c                  |  42 +++-
 fs/ceph/mds_client.c            | 369 ++++++++++++++++++++++++++++++--
 fs/ceph/mds_client.h            |  48 +++++
 fs/ceph/quota.c                 |   8 +-
 fs/ceph/super.h                 |   9 +
 fs/ceph/xattr.c                 |  17 +-
 include/linux/ceph/ceph_fs.h    |  77 +++++++
 include/linux/ceph/osd_client.h |   5 +-
 net/ceph/osd_client.c           |  18 +-
 14 files changed, 869 insertions(+), 40 deletions(-)

--=20
2.21.0

