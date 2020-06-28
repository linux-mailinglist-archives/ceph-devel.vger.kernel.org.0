Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D9E120C715
	for <lists+ceph-devel@lfdr.de>; Sun, 28 Jun 2020 10:42:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726093AbgF1Im3 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Sun, 28 Jun 2020 04:42:29 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:48036 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726038AbgF1Im3 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Sun, 28 Jun 2020 04:42:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1593333747;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc; bh=HX1lLJrj2lxCiKMHsnDUhVUdH7DNUGlrnOJagtzmdnU=;
        b=diJ9ePprvsQMh1aQDe9+AAabRaGM7blTER9AI/s+a6Ptvhdda9mX05yPimjZwUGE0l23Hd
        Q6ffY0uqaTIYSutOxThzwHqFxYkPLWTrup7N1NNnY+HtdAHF62loGqCWLIkksamcueTwNO
        NXIu/bqhGvqaR1AzJcsg7mqwsC2P8LM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-454-DLfdZTGpO9a1yarmdK317A-1; Sun, 28 Jun 2020 04:42:22 -0400
X-MC-Unique: DLfdZTGpO9a1yarmdK317A-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6F6CD1800D42;
        Sun, 28 Jun 2020 08:42:21 +0000 (UTC)
Received: from lxbceph0.gsslab.pek2.redhat.com (vm37-55.gsslab.pek2.redhat.com [10.72.37.55])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 55C561944D;
        Sun, 28 Jun 2020 08:42:19 +0000 (UTC)
From:   xiubli@redhat.com
To:     jlayton@kernel.org, idryomov@gmail.com
Cc:     zyan@redhat.com, pdonnell@redhat.com, ceph-devel@vger.kernel.org,
        Xiubo Li <xiubli@redhat.com>
Subject: [PATCH v4 0/5] ceph: periodically send perf metrics to ceph
Date:   Sun, 28 Jun 2020 04:42:09 -0400
Message-Id: <1593333734-27480-1-git-send-email-xiubli@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: Xiubo Li <xiubli@redhat.com>

This series is based the previous patches of the metrics in kceph[1]
and mds daemons record and forward client side metrics to manager[2][3].

This will send the caps/read/write/metadata metrics to any available
MDS only once per second, which will be the same as the userland client.
We could disable it via the enable_send_metrics module parameter.

And will also send the metric flags to MDS, currently it supports the
cap, read latency, write latency and metadata latency.

Also have pushed this series to github [4].

[1] https://patchwork.kernel.org/project/ceph-devel/list/?series=238907 [Merged]
[2] https://github.com/ceph/ceph/pull/26004 [Merged]
[3] https://github.com/ceph/ceph/pull/35608 [Merged]
[4] https://github.com/lxbsz/ceph-client/commits/perf_metric4

Changes in V4:
- WARN_ON --> WARN_ON_ONCE
- do not send metrics when no mds suppor the metric collection.
- add global total_caps in mdsc->metric
- add the delayed work for each session and choose one to send the metrics to get rid of the mdsc->mutex lock

Changed in V3:
- fold "check the METRIC_COLLECT feature before sending metrics" into previous one
- use `enable_send_metrics` on/off switch instead

Changed in V2:
- split the patches into small ones as possible.
- check the METRIC_COLLECT feature before sending metrics
- switch to WARN_ON and bubble up errnos to the callers



Xiubo Li (5):
  ceph: add check_session_state helper and make it global
  ceph: add global total_caps to count the mdsc's caps number
  ceph: periodically send perf metrics to ceph
  ceph: switch to WARN_ON_ONCE and bubble up errnos to the callers
  ceph: send client provided metric flags in client metadata

 fs/ceph/caps.c               |   2 +
 fs/ceph/mds_client.c         | 158 +++++++++++++++++++++++++++++++++++--------
 fs/ceph/mds_client.h         |   8 ++-
 fs/ceph/metric.c             | 156 ++++++++++++++++++++++++++++++++++++++++++
 fs/ceph/metric.h             |  96 ++++++++++++++++++++++++++
 fs/ceph/super.c              |  42 ++++++++++++
 fs/ceph/super.h              |   2 +
 include/linux/ceph/ceph_fs.h |   1 +
 8 files changed, 434 insertions(+), 31 deletions(-)

-- 
1.8.3.1

