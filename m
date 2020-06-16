Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39D7B1FB12E
	for <lists+ceph-devel@lfdr.de>; Tue, 16 Jun 2020 14:52:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728448AbgFPMwv (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 16 Jun 2020 08:52:51 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:25054 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728160AbgFPMwv (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 16 Jun 2020 08:52:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1592311970;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc; bh=//k4Ht5vmkGqzzwhWycBvn9wZywtGFEGT596M/FM6PQ=;
        b=FNv2BTjruslX3Jh5jVYWP0MeBFS9Wr7h68sitbBwGh2lVYHSP+gVWeHb0erQ7plksJ4+iA
        /31XFjH1JmJjSD3uHiHcH6zghSxgzPOxx/sskd+Yg3Y/mivQ3/JoP4RVwiQWc9avnhmDZ5
        hSOxqbvTEONtzp2uZDwRtKQlzVMWLZk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-298-qDXdV2H2MnSjREjiZMO5Zg-1; Tue, 16 Jun 2020 08:52:44 -0400
X-MC-Unique: qDXdV2H2MnSjREjiZMO5Zg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 993045AEC8;
        Tue, 16 Jun 2020 12:52:43 +0000 (UTC)
Received: from lxbceph0.gsslab.pek2.redhat.com (vm37-55.gsslab.pek2.redhat.com [10.72.37.55])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 83ACC768AA;
        Tue, 16 Jun 2020 12:52:41 +0000 (UTC)
From:   xiubli@redhat.com
To:     jlayton@kernel.org, idryomov@gmail.com
Cc:     zyan@redhat.com, pdonnell@redhat.com, ceph-devel@vger.kernel.org,
        Xiubo Li <xiubli@redhat.com>
Subject: [PATCH 0/2] ceph: periodically send perf metrics to ceph
Date:   Tue, 16 Jun 2020 08:52:28 -0400
Message-Id: <1592311950-17623-1-git-send-email-xiubli@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: Xiubo Li <xiubli@redhat.com>

This series is based the previous patches of the metrics in kceph[1]
and mds daemons record and forward client side metrics to manager[2].

This will send the caps/read/write/metadata metrics to any available
MDS only once per second as default, which will be the same as the
userland client, or every metric_send_interval seconds, which is a
module parameter, the valid values for metric_send_interval will be
1~5 seconds.

And will also send the metric flags to MDS, currently it supports the
cap, read latency, write latency and metadata latency.

[1] https://patchwork.kernel.org/project/ceph-devel/list/?series=238907 [Merged]
[2] https://github.com/ceph/ceph/pull/26004 [Merged]

Xiubo Li (2):
  ceph: periodically send perf metrics to ceph
  ceph: send client provided metric flags in client metadata

 fs/ceph/mds_client.c         |  93 +++++++++++++++++++++++-------
 fs/ceph/mds_client.h         |   4 ++
 fs/ceph/metric.c             | 133 +++++++++++++++++++++++++++++++++++++++++++
 fs/ceph/metric.h             |  91 +++++++++++++++++++++++++++++
 fs/ceph/super.c              |  29 ++++++++++
 include/linux/ceph/ceph_fs.h |   1 +
 6 files changed, 332 insertions(+), 19 deletions(-)

-- 
1.8.3.1

