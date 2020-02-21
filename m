Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 94983166FF9
	for <lists+ceph-devel@lfdr.de>; Fri, 21 Feb 2020 08:06:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727053AbgBUHGu (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 21 Feb 2020 02:06:50 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:33592 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726244AbgBUHGt (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Fri, 21 Feb 2020 02:06:49 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582268808;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=cXUxp4lz68SdrZV6iNdGOS7A6wtxyXid3CJESTgPovA=;
        b=hUz9gYyk45W8gMyWV/62sBqPPBow7tcxreOq6B5V+aWNMgNAIBR/VD7bzH/9oKXO6t/JAK
        89ma2/vqboZxY5T3VufZNFWsb+7jt1x01abGOnxTFaI7qe6YTHaH7R/8zuFauNcmVMvPBv
        ccedxvC3qkKr7D3jIAgDGRPfo8qOk3I=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-394-wZtWD0i9Phud_zfu6DDAYA-1; Fri, 21 Feb 2020 02:06:46 -0500
X-MC-Unique: wZtWD0i9Phud_zfu6DDAYA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 56B12107ACC5;
        Fri, 21 Feb 2020 07:06:45 +0000 (UTC)
Received: from localhost.localdomain (ovpn-12-94.pek2.redhat.com [10.72.12.94])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1089C5D9E2;
        Fri, 21 Feb 2020 07:06:39 +0000 (UTC)
From:   xiubli@redhat.com
To:     jlayton@kernel.org, idryomov@gmail.com
Cc:     sage@redhat.com, zyan@redhat.com, pdonnell@redhat.com,
        ceph-devel@vger.kernel.org, Xiubo Li <xiubli@redhat.com>
Subject: [PATCH v8 0/5] ceph: add perf metrics support
Date:   Fri, 21 Feb 2020 02:05:51 -0500
Message-Id: <20200221070556.18922-1-xiubli@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Content-Transfer-Encoding: quoted-printable
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: Xiubo Li <xiubli@redhat.com>

Changed in V8:
- address the comments for cap patch from Jeff.

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

 fs/ceph/acl.c                   |   2 +-
 fs/ceph/addr.c                  |  13 ++++
 fs/ceph/caps.c                  |  19 ++++++
 fs/ceph/debugfs.c               |  71 ++++++++++++++++++++--
 fs/ceph/dir.c                   |  21 +++++--
 fs/ceph/file.c                  |  20 +++++++
 fs/ceph/inode.c                 |   4 +-
 fs/ceph/mds_client.c            | 103 +++++++++++++++++++++++++++++++-
 fs/ceph/mds_client.h            |   4 ++
 fs/ceph/metric.h                |  81 +++++++++++++++++++++++++
 fs/ceph/super.h                 |   9 ++-
 fs/ceph/xattr.c                 |   4 +-
 include/linux/ceph/osd_client.h |   1 +
 net/ceph/osd_client.c           |   2 +
 14 files changed, 336 insertions(+), 18 deletions(-)
 create mode 100644 fs/ceph/metric.h

--=20
2.21.0

