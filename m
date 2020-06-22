Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8FD8D2037E1
	for <lists+ceph-devel@lfdr.de>; Mon, 22 Jun 2020 15:25:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728623AbgFVNZX (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 22 Jun 2020 09:25:23 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:26157 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727963AbgFVNZX (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 22 Jun 2020 09:25:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1592832321;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc; bh=C0ky4QX0aRnwI9L12+7f+tA2germAv8UKM8s1LKz/ts=;
        b=Wc8WKlp6fRoWdC6NzdzY1bPKbOUJGWK44O/vBcYJWJIhile1xOwi0H/3RZw8CAesfLNlGw
        E89DyqLnEEVmfzNaSpMeJwBii9P3TNZ6CL0EJYOkLrfl4tie4m+u8bJp4lB4pNytYkW6ou
        K1k1Fdz0MchNuHZiI/sWEbGOIBUzXsw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-184-62ZpvJUpNHOScBEFlJK7XQ-1; Mon, 22 Jun 2020 09:25:05 -0400
X-MC-Unique: 62ZpvJUpNHOScBEFlJK7XQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9B4938014D4;
        Mon, 22 Jun 2020 13:25:04 +0000 (UTC)
Received: from lxbceph0.gsslab.pek2.redhat.com (vm37-55.gsslab.pek2.redhat.com [10.72.37.55])
        by smtp.corp.redhat.com (Postfix) with ESMTP id BCBED7C1E3;
        Mon, 22 Jun 2020 13:25:02 +0000 (UTC)
From:   xiubli@redhat.com
To:     jlayton@kernel.org, idryomov@gmail.com
Cc:     zyan@redhat.com, pdonnell@redhat.com, ceph-devel@vger.kernel.org,
        Xiubo Li <xiubli@redhat.com>
Subject: [PATCH v3 0/4] ceph: periodically send perf metrics to ceph
Date:   Mon, 22 Jun 2020 09:24:56 -0400
Message-Id: <1592832300-29109-1-git-send-email-xiubli@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: Xiubo Li <xiubli@redhat.com>

This series is based the previous patches of the metrics in kceph[1]
and mds daemons record and forward client side metrics to manager[2][3].

This will send the caps/read/write/metadata metrics to any available
MDS only once per second as default, which will be the same as the
userland client, or every metric_send_interval seconds, which is a
module parameter, the valid values for metric_send_interval will be
0~5 seconds, 0 means disabled.

And will also send the metric flags to MDS, currently it supports the
cap, read latency, write latency and metadata latency.

Also have pushed this series to github [4].

[1] https://patchwork.kernel.org/project/ceph-devel/list/?series=238907 [Merged]
[2] https://github.com/ceph/ceph/pull/26004 [Merged]
[3] https://github.com/ceph/ceph/pull/35608 [Merged]
[4] https://github.com/lxbsz/ceph-client/commits/perf_metric2

Changed in V3:
- fold "check the METRIC_COLLECT feature before sending metrics" into previous one
- use `enable_send_metrics` on/off switch instead

Changed in V2:
- split the patches into small ones as possible.
- check the METRIC_COLLECT feature before sending metrics
- switch to WARN_ON and bubble up errnos to the callers


Xiubo Li (4):
  ceph: add check_session_state helper and make it global
  ceph: periodically send perf metrics to ceph
  ceph: switch to WARN_ON and bubble up errnos to the callers
  ceph: send client provided metric flags in client metadata

 fs/ceph/mds_client.c         | 152 ++++++++++++++++++++++++++++++++++---------
 fs/ceph/mds_client.h         |   8 ++-
 fs/ceph/metric.c             | 142 ++++++++++++++++++++++++++++++++++++++++
 fs/ceph/metric.h             |  91 ++++++++++++++++++++++++++
 fs/ceph/super.c              |  42 ++++++++++++
 fs/ceph/super.h              |   2 +
 include/linux/ceph/ceph_fs.h |   1 +
 7 files changed, 407 insertions(+), 31 deletions(-)

-- 
1.8.3.1

