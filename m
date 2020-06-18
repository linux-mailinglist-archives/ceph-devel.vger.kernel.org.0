Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 76C811FF119
	for <lists+ceph-devel@lfdr.de>; Thu, 18 Jun 2020 14:01:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728361AbgFRMBG (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 18 Jun 2020 08:01:06 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:46212 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728085AbgFRMBE (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 18 Jun 2020 08:01:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1592481663;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc; bh=2FsjXwKkiOgYgmeqomgLHQBpVBMSNkMMhA9QfWNow1M=;
        b=YIn5VhGCVJTceyQRIihhgKPNGmHpDhxHnn/GhrNXGqLUTT52rs4x7VHuRgkOqKfdSkzBW2
        7GkjE+encoYk+layYb1jeXzTJ+PcaKRAmpRkDjI9b8yXb25dHcamTyguBkw0qxuaNISIaX
        H7GOsLr5fiRRhlSnlh+0LNHVBHO6f4Q=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-390-snDvZczbO8WkfNaXvihP-Q-1; Thu, 18 Jun 2020 08:00:52 -0400
X-MC-Unique: snDvZczbO8WkfNaXvihP-Q-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 933C0801503;
        Thu, 18 Jun 2020 12:00:51 +0000 (UTC)
Received: from lxbceph0.gsslab.pek2.redhat.com (vm37-55.gsslab.pek2.redhat.com [10.72.37.55])
        by smtp.corp.redhat.com (Postfix) with ESMTP id BB57B7A01A;
        Thu, 18 Jun 2020 12:00:49 +0000 (UTC)
From:   xiubli@redhat.com
To:     jlayton@kernel.org, idryomov@gmail.com
Cc:     zyan@redhat.com, pdonnell@redhat.com, ceph-devel@vger.kernel.org,
        Xiubo Li <xiubli@redhat.com>
Subject: [PATCH v2 0/5] ceph: periodically send perf metrics to ceph
Date:   Thu, 18 Jun 2020 07:59:54 -0400
Message-Id: <1592481599-7851-1-git-send-email-xiubli@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
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


Changed in V2:
- split the patches into small ones as possible.
- check the METRIC_COLLECT feature before sending metrics
- switch to WARN_ON and bubble up errnos to the callers

Xiubo Li (5):
  ceph: add check_session_state helper and make it global
  ceph: periodically send perf metrics to ceph
  ceph: check the METRIC_COLLECT feature before sending metrics
  ceph: switch to WARN_ON and bubble up errnos to the callers
  ceph: send client provided metric flags in client metadata

 fs/ceph/mds_client.c         | 147 ++++++++++++++++++++++++++++++++++---------
 fs/ceph/mds_client.h         |   8 ++-
 fs/ceph/metric.c             | 142 +++++++++++++++++++++++++++++++++++++++++
 fs/ceph/metric.h             |  91 +++++++++++++++++++++++++++
 fs/ceph/super.c              |  49 +++++++++++++++
 fs/ceph/super.h              |   2 +
 include/linux/ceph/ceph_fs.h |   1 +
 7 files changed, 410 insertions(+), 30 deletions(-)

-- 
1.8.3.1

