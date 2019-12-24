Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F132C129D33
	for <lists+ceph-devel@lfdr.de>; Tue, 24 Dec 2019 05:05:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726874AbfLXEF3 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 23 Dec 2019 23:05:29 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:58563 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726853AbfLXEF2 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Mon, 23 Dec 2019 23:05:28 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1577160327;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=Vh9jlma9tomI66hlCUf3Wr+3rc1b+sCH0kaHjkXHD+A=;
        b=aI0HHJ0CMxB2QgG7aMDcOSwKqwgAvhjUk/UJo7rXhrz3BghJBRVebZZZeOH03cpSgMD7+C
        JcnmoRhTMKVE8O+2MvHTP9QURIepFosqfaprDkgBsqtUQTNR8oqBiSmW987uHakN7QdGYW
        2cbJL/Blj2uISHVR7brjJx4+xm6fYZY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-326-MniuBIxZOL6Zcbv8ZGqRKQ-1; Mon, 23 Dec 2019 23:05:25 -0500
X-MC-Unique: MniuBIxZOL6Zcbv8ZGqRKQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D1916800D48;
        Tue, 24 Dec 2019 04:05:24 +0000 (UTC)
Received: from localhost.localdomain (ovpn-12-64.pek2.redhat.com [10.72.12.64])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A69331000322;
        Tue, 24 Dec 2019 04:05:19 +0000 (UTC)
From:   xiubli@redhat.com
To:     jlayton@kernel.org, idryomov@gmail.com
Cc:     sage@redhat.com, zyan@redhat.com, pdonnell@redhat.com,
        ceph-devel@vger.kernel.org, Xiubo Li <xiubli@redhat.com>
Subject: [PATCH 0/4] ceph: add caps and dentry lease perf metrics support
Date:   Mon, 23 Dec 2019 23:05:10 -0500
Message-Id: <20191224040514.26144-1-xiubli@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Content-Transfer-Encoding: quoted-printable
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: Xiubo Li <xiubli@redhat.com>

*** Merry Christmas and Happy New Year! ***

This will collect the dentry lease and sessions' cap hit/mis metrics.

=3D=3D=3D=3D=3D=3D=3D SHOW METRICS IN KCLIENT SIDE =3D=3D=3D=3D=3D=3D
You can show this via the "metrics" debugfs, it will look like:

$ cat /sys/kernel/debug/ceph/XXX.client4783/metrics

item          total           miss            hit
-------------------------------------------------
d_lease       131             24              2891

session       caps            miss            hit
-------------------------------------------------
0             54              3               106
1             108             13              3254


=3D=3D=3D=3D=3D=3D=3D SHOW METRICS IN MDS SIDE =3D=3D=3D=3D=3D=3D=3D
And if you want to send this metrics stuff to MDS servers, you need
to enable it by writing a "1" to sending_metrics debugfs:

$ echo 1 > /sys/kernel/debug/ceph/XXX.client4783/sending_metrics

And it will send the metric stuff periodically every second.
Disabled as default.=20

Then in the MDS we can show this by using:

$ ceph mgr module enable stats
$ ceph fs perf stats | python -m json.tool
{
    "client_metadata": {
        "client.4783": {
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
        "metadata_latency"
    ],
    "global_metrics": {
        "client.4783": [
            [
                0,
                0
            ],
            [
                0,
                0
            ],
            [
                0,
                0
            ]
        ]
    },
    "metrics": {
        "delayed_ranks": [],
        "mds.0": {
            "client.4783": [
                [
                    106,
                    3
                ]
            ]
        },
        "mds.1": {
            "client.4783": [
                [
                    3254,
                    13
                ]
            ]
        }
    }
}

Currently the MDS hasn't support the dentry lease metric showing yet.

Xiubo Li (4):
  ceph: add global dentry lease metric support
  ceph: add caps perf metric for each session
  ceph: periodically send cap and dentry lease perf metrics to MDS
  ceph: add enable/disable sending metrics to MDS debugfs support

 fs/ceph/acl.c                |   2 +-
 fs/ceph/caps.c               |  63 +++++++++---
 fs/ceph/debugfs.c            |  94 +++++++++++++++++-
 fs/ceph/dir.c                |  38 +++++--
 fs/ceph/file.c               |   6 +-
 fs/ceph/inode.c              |   8 +-
 fs/ceph/mds_client.c         | 188 +++++++++++++++++++++++++++++++----
 fs/ceph/mds_client.h         |  15 +++
 fs/ceph/snap.c               |   2 +-
 fs/ceph/super.h              |  14 ++-
 fs/ceph/xattr.c              |   8 +-
 include/linux/ceph/ceph_fs.h |  39 ++++++++
 12 files changed, 414 insertions(+), 63 deletions(-)

--=20
2.21.0

