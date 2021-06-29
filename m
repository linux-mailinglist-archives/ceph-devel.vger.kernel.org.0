Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1533F3B6DAE
	for <lists+ceph-devel@lfdr.de>; Tue, 29 Jun 2021 06:42:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229935AbhF2EpR (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 29 Jun 2021 00:45:17 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:25483 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229480AbhF2EpQ (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Tue, 29 Jun 2021 00:45:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1624941769;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=SxY4o22r1uFD8CSk1K2sYCflOJyQmLUA9fqQpgMAQEU=;
        b=ad9p2xd0P/l0Efmi6+D4eS2s/mEGqX6r4IslQeF/VPvK5ETokv64ac14T72Wn+3ki4Xf/X
        96o6LR4WaHqnKt5PbnvRDHRSyjKJNGvIWMW0wqO0Z/2PRM75u+3B49Vj+N3uIEcTvNxNEK
        sow4+/8TGlgtH8INuUyjKAFpbeAawCE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-234-l6X3fnhgO7eNDBSDydaO5Q-1; Tue, 29 Jun 2021 00:42:47 -0400
X-MC-Unique: l6X3fnhgO7eNDBSDydaO5Q-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C8B761E17;
        Tue, 29 Jun 2021 04:42:46 +0000 (UTC)
Received: from lxbceph1.gsslab.pek2.redhat.com (unknown [10.72.47.117])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E97BD5D9DC;
        Tue, 29 Jun 2021 04:42:44 +0000 (UTC)
From:   xiubli@redhat.com
To:     jlayton@kernel.org
Cc:     idryomov@gmail.com, pdonnell@redhat.com,
        ceph-devel@vger.kernel.org, Xiubo Li <xiubli@redhat.com>
Subject: [PATCH 0/5] flush the mdlog before waiting on unsafe reqs
Date:   Tue, 29 Jun 2021 12:42:36 +0800
Message-Id: <20210629044241.30359-1-xiubli@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: Xiubo Li <xiubli@redhat.com>

For the client requests who will have unsafe and safe replies from
MDS daemons, in the MDS side the MDS daemons won't flush the mdlog
(journal log) immediatelly, because they think it's unnecessary.
That's true for most cases but not all, likes the fsync request.
The fsync will wait until all the unsafe replied requests to be
safely replied.

Normally if there have multiple threads or clients are running, the
whole mdlog in MDS daemons could be flushed in time if any request
will trigger the mdlog submit thread. So usually we won't experience
the normal operations will stuck for a long time. But in case there
has only one client with only thread is running, the stuck phenomenon
maybe obvious and the worst case it must wait at most 5 seconds to
wait the mdlog to be flushed by the MDS's tick thread periodically.

This patch will trigger to flush the mdlog in all the MDSes manually
just before waiting the unsafe requests to finish.




Xiubo Li (5):
  ceph: export ceph_create_session_msg
  ceph: export iterate_sessions
  ceph: flush mdlog before umounting
  ceph: flush the mdlog before waiting on unsafe reqs
  ceph: fix ceph feature bits

 fs/ceph/caps.c               | 35 ++++----------
 fs/ceph/mds_client.c         | 91 +++++++++++++++++++++++++++---------
 fs/ceph/mds_client.h         |  9 ++++
 include/linux/ceph/ceph_fs.h |  1 +
 4 files changed, 88 insertions(+), 48 deletions(-)

-- 
2.27.0

