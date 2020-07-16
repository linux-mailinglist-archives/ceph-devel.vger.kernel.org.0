Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 059062224D5
	for <lists+ceph-devel@lfdr.de>; Thu, 16 Jul 2020 16:06:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728892AbgGPOGk (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 16 Jul 2020 10:06:40 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:50184 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727044AbgGPOGj (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Thu, 16 Jul 2020 10:06:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594908398;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=qN3smbuhky4BcnJ2tjNYKpLPI6G0RPqvAKYRQVMG6rw=;
        b=RwOyTaD3KQWcaGUX+gFwCQcHa2K0C8QQNzLmlALwwtgUyuxY4MfYFpo3g16KpqvToVuXK2
        JIh0Tw/Re8z18KWtJm/evi1qtUJaWDdDWCb+LjMmZWBosKmd+HiFpSK/rxpgmBCUqAlaRr
        98Y4uVe33bWESSU/2k7HQ5R8LubecTk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-93-CfvjXJarOm2cKNafPHv9rw-1; Thu, 16 Jul 2020 10:06:09 -0400
X-MC-Unique: CfvjXJarOm2cKNafPHv9rw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CB37B8027F6;
        Thu, 16 Jul 2020 14:06:08 +0000 (UTC)
Received: from lxbceph0.gsslab.pek2.redhat.com (vm37-55.gsslab.pek2.redhat.com [10.72.37.55])
        by smtp.corp.redhat.com (Postfix) with ESMTP id ADAC761499;
        Thu, 16 Jul 2020 14:06:00 +0000 (UTC)
From:   xiubli@redhat.com
To:     jlayton@kernel.org
Cc:     idryomov@gmail.com, ceph-devel@vger.kernel.org, zyan@redhat.com,
        pdonnell@redhat.com, vshankar@redhat.com,
        Xiubo Li <xiubli@redhat.com>
Subject: [PATCH v6 0/2] ceph: periodically send perf metrics to ceph
Date:   Thu, 16 Jul 2020 10:05:56 -0400
Message-Id: <20200716140558.5185-1-xiubli@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: Xiubo Li <xiubli@redhat.com>

This series is based the previous patches of the metrics in kceph[1]
and mds daemons record and forward client side metrics to manager[2][3].

This will send the caps/read/write/metadata metrics to any available
MDS only once per second, which will be the same as the userland client.
We could disable it via the disable_send_metrics module parameter.

In mdsc->metric we have one important member:
'metric.session': hold the available and valid session to send the metrics,
                  we will hold the session reference until its state is no
                  longer good or when doing the unmount to release the
                  resources.

And will also send the metric flags to MDS, currently it supports the
cap, read latency, write latency and metadata latency.

Also I have pushed this series to github [4].

[1] https://patchwork.kernel.org/project/ceph-devel/list/?series=238907 [Merged]
[2] https://github.com/ceph/ceph/pull/26004 [Merged]
[3] https://github.com/ceph/ceph/pull/35608 [Merged]
[4] https://github.com/lxbsz/ceph-client/commits/perf_metric6

Changed in V6:
- switch 'ceph_fsc_lock' to spin lock
- metric.mds --> metric.session, to hold the session reference instead until its state is no longer good to get rid of the mutex lock.

Changed in V5:
- rename enable_send_metrics --> disable_send_metrics
- switch back to a single workqueue job.
- 'list' --> 'metric_wakeup'

Changed in V4:
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






Xiubo Li (2):
  ceph: periodically send perf metrics to ceph
  ceph: send client provided metric flags in client metadata

 fs/ceph/mds_client.c         |  64 ++++++++++++++-
 fs/ceph/mds_client.h         |   4 +-
 fs/ceph/metric.c             | 151 +++++++++++++++++++++++++++++++++++
 fs/ceph/metric.h             |  90 +++++++++++++++++++++
 fs/ceph/super.c              |  42 ++++++++++
 fs/ceph/super.h              |   2 +
 include/linux/ceph/ceph_fs.h |   1 +
 7 files changed, 351 insertions(+), 3 deletions(-)

-- 
2.27.0.221.ga08a83d.dirty

