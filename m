Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 40378180E30
	for <lists+ceph-devel@lfdr.de>; Wed, 11 Mar 2020 03:54:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727591AbgCKCyU (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 10 Mar 2020 22:54:20 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:22263 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727506AbgCKCyU (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Tue, 10 Mar 2020 22:54:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1583895259;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc; bh=17Q4nnuYn3SVRyz61EhYJFc9Zlr5YF/vZIJ3kMsFKq8=;
        b=h+JcIXkJBXuh81zkb2+hINPJA/oTsEQwl2fwHim6XLmdKnz/bnuN+RcV2fn7tUk2mtuXLT
        vmB2FFg9KFH4OtX+hE/eY66D0VBGCKwVPazu/ndzWI7HB1z4Oy8XzhMR7JhaMBknktvq2i
        OmRT3cJfWD639h6OwuoH8kvcx88a1rc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-329-qjNsa-SrPeKQFdFI8bZppw-1; Tue, 10 Mar 2020 22:54:16 -0400
X-MC-Unique: qjNsa-SrPeKQFdFI8bZppw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 293CF801E6D;
        Wed, 11 Mar 2020 02:54:15 +0000 (UTC)
Received: from lxbceph0.gsslab.pek2.redhat.com (vm36-245.gsslab.pek2.redhat.com [10.72.36.245])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D4DDE60C18;
        Wed, 11 Mar 2020 02:54:09 +0000 (UTC)
From:   xiubli@redhat.com
To:     jlayton@kernel.org
Cc:     sage@redhat.com, idryomov@gmail.com, zyan@redhat.com,
        pdonnell@redhat.com, ceph-devel@vger.kernel.org,
        Xiubo Li <xiubli@redhat.com>
Subject: [PATCH 0/2] add standard deviation support
Date:   Tue, 10 Mar 2020 22:54:05 -0400
Message-Id: <1583895247-17312-1-git-send-email-xiubli@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: Xiubo Li <xiubli@redhat.com>

The idea came from Jeff's comment in previous patch series:

#  cat /sys/kernel/debug/ceph/81b62c25-7c41-4345-9140-201730bfdde0.client4333/metrics 
item          total       sum_lat(us)     avg_lat(us)     min_lat(us)     max_lat(us)     stdev(us)
---------------------------------------------------------------------------------------------------
read          492         20817000        24000           3000            1027000         2571
write         400         1184122000      2994000         16000           5613000         53949
metadata      4           22000           5000            1000            16000           207

item          total           miss            hit
-------------------------------------------------
d_lease       2               0               1
caps          2               6               102140


Xiubo Li (2):
  ceph: move all the metric helpers into one separate file
  ceph: add standard deviation support for read/write/metadata perf
    metric

 fs/ceph/Makefile     |   2 +-
 fs/ceph/debugfs.c    |  70 +++++++++++------
 fs/ceph/mds_client.c |  95 +----------------------
 fs/ceph/metric.c     | 214 +++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/ceph/metric.h     | 102 ++++++------------------
 5 files changed, 286 insertions(+), 197 deletions(-)
 create mode 100644 fs/ceph/metric.c

-- 
1.8.3.1

