Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2E3D214C776
	for <lists+ceph-devel@lfdr.de>; Wed, 29 Jan 2020 09:27:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726183AbgA2I1g (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 29 Jan 2020 03:27:36 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:41120 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726068AbgA2I1g (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 29 Jan 2020 03:27:36 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580286455;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=syzCRXhtj2z/CjsquVuK4EA/fDXyhU6U/mxjoS+Xb6s=;
        b=Etq9MafLkd8HYHM1Dwqt4X8cFWjGQmGRDCgsVZKy0ru84Ooqxd2byCHK9/H5Vd3gVYL2Ij
        HKNHDKs28iGnrJG7aZPgpyk12OsG9gm8zlwMCdDn9p/WJZy+4uz1TUT/xF2zFBayoRAHkK
        gJV3atlzkkaoU8WcQA6gD5RXQmacllE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-373-KVJlqCueMEew3vDWoATg_w-1; Wed, 29 Jan 2020 03:27:32 -0500
X-MC-Unique: KVJlqCueMEew3vDWoATg_w-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 798EDDB60;
        Wed, 29 Jan 2020 08:27:31 +0000 (UTC)
Received: from localhost.localdomain (ovpn-12-34.pek2.redhat.com [10.72.12.34])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1FD3C5C219;
        Wed, 29 Jan 2020 08:27:25 +0000 (UTC)
From:   xiubli@redhat.com
To:     jlayton@kernel.org, idryomov@gmail.com, zyan@redhat.com
Cc:     sage@redhat.com, pdonnell@redhat.com, ceph-devel@vger.kernel.org,
        Xiubo Li <xiubli@redhat.com>
Subject: [PATCH resend v5 0/11] ceph: add perf metrics support
Date:   Wed, 29 Jan 2020 03:27:04 -0500
Message-Id: <20200129082715.5285-1-xiubli@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
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

Changed in V4:
- fix the lock issue

Changed in V5:
- add r_end_stamp for the osdc request
- delete reset metric and move it to metric sysfs
- move ceph_osdc_{read,write}pages to ceph.ko
- use percpu counters instead for read/write/metadata latencies

Changed in V5 resend:
- add the lost patch.

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



*** BLURB HERE ***

Xiubo Li (11):
  ceph: add global dentry lease metric support
  ceph: add caps perf metric for each session
  ceph: move ceph_osdc_{read,write}pages to ceph.ko
  ceph: add r_end_stamp for the osdc request
  ceph: add global read latency metric support
  ceph: add global write latency metric support
  ceph: add global metadata perf metric support
  ceph: periodically send perf metrics to MDS
  ceph: add CEPH_DEFINE_RW_FUNC helper support
  ceph: add reset metrics support
  ceph: send client provided metric flags in client metadata

 fs/ceph/acl.c                   |   2 +
 fs/ceph/addr.c                  | 106 +++++++++-
 fs/ceph/caps.c                  |  74 +++++++
 fs/ceph/debugfs.c               | 168 ++++++++++++++-
 fs/ceph/dir.c                   |  27 ++-
 fs/ceph/file.c                  |  26 +++
 fs/ceph/mds_client.c            | 350 ++++++++++++++++++++++++++++++--
 fs/ceph/mds_client.h            |  10 +
 fs/ceph/metric.h                | 150 ++++++++++++++
 fs/ceph/quota.c                 |   9 +-
 fs/ceph/super.h                 |  14 ++
 fs/ceph/xattr.c                 |  17 +-
 include/linux/ceph/ceph_fs.h    |   1 +
 include/linux/ceph/debugfs.h    |  14 ++
 include/linux/ceph/osd_client.h |  18 +-
 net/ceph/osd_client.c           |  81 +-------
 16 files changed, 935 insertions(+), 132 deletions(-)
 create mode 100644 fs/ceph/metric.h

--=20
2.21.0

