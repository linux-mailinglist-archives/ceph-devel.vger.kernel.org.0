Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E269818956D
	for <lists+ceph-devel@lfdr.de>; Wed, 18 Mar 2020 06:46:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726995AbgCRFqJ (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 18 Mar 2020 01:46:09 -0400
Received: from us-smtp-delivery-74.mimecast.com ([63.128.21.74]:59050 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726478AbgCRFqJ (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Wed, 18 Mar 2020 01:46:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1584510368;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc; bh=nJjEv3SSzM5SJyI2GmxG5PSyvc8nPlmtawj/ArGJ7p4=;
        b=FpOtecbB3k8LtyQN0hp9ZWdc5Wo8w6Nu1QqnLsOd+S3qGxIMb/lTrcM4B1P+AxcRah9w7p
        ePI1ZiznmYUBlXGDMb4XH/9M4BUcCXY00Twwm1wrV9OLEfrjR5ue1nooVOqYBzqsVa/rT1
        uSgBk90ms9WYhmmUryIyjKgDj27/PSg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-12-QhIE_dCGP2-8REzNqaDy9w-1; Wed, 18 Mar 2020 01:46:06 -0400
X-MC-Unique: QhIE_dCGP2-8REzNqaDy9w-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3568C477;
        Wed, 18 Mar 2020 05:46:05 +0000 (UTC)
Received: from lxbceph0.gsslab.pek2.redhat.com (vm36-245.gsslab.pek2.redhat.com [10.72.36.245])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1B0268D553;
        Wed, 18 Mar 2020 05:45:59 +0000 (UTC)
From:   xiubli@redhat.com
To:     jlayton@kernel.org
Cc:     sage@redhat.com, idryomov@gmail.com, gfarnum@redhat.com,
        zyan@redhat.com, pdonnell@redhat.com, ceph-devel@vger.kernel.org,
        Xiubo Li <xiubli@redhat.com>
Subject: [PATCH v4 0/4] ceph: add min/max/stdev latency support
Date:   Wed, 18 Mar 2020 01:45:51 -0400
Message-Id: <1584510355-6936-1-git-send-email-xiubli@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: Xiubo Li <xiubli@redhat.com>

Changed in V4:
- fix the 32-bit arches div errors by using DIV64_U64_ROUND_CLOSEST instead. [1/4]
- rebase and combine the stdev patch series [3/4][4/4]
- remove the sum latency showing, which makes no sense for debugging, if it
  is really needed in some case then just do (avg * total) in userland. [4/4]
- switch {read/write/metadata}_latency_sum to atomic type since it will be
  readed very time when updating the latencies to calculate the stdev. [4/4]

Changed in V2:
- switch spin lock to cmpxchg [1/4]

Changed in V3:
- add the __update_min/max_latency helpers [1/4]



# cat /sys/kernel/debug/ceph/0f923fe5-00e6-4866-bf01-2027cb75e94b.client4150/metrics
item          total       avg_lat(us)     min_lat(us)     max_lat(us)     stdev(us)
-----------------------------------------------------------------------------------
read          2312        9000            1000            100000          607.4
write         21777       925000          2000            44551000        29700.3
metadata      6           4179000         1000            21414000        19590.8

item          total           miss            hit
-------------------------------------------------
d_lease       2               0               11
caps          2               14              398418



Xiubo Li (4):
  ceph: switch to DIV64_U64_ROUND_CLOSEST to support 32-bit arches
  ceph: add min/max latency support for read/write/metadata metrics
  ceph: move the metric helpers into one separate file
  ceph: add standard deviation support for read/write/metadata perf
    metric

 fs/ceph/Makefile     |   2 +-
 fs/ceph/debugfs.c    |  89 ++++++++++++++++++------
 fs/ceph/mds_client.c |  83 +---------------------
 fs/ceph/metric.c     | 190 +++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/ceph/metric.h     |  79 +++++++++++----------
 5 files changed, 297 insertions(+), 146 deletions(-)
 create mode 100644 fs/ceph/metric.c

-- 
1.8.3.1

