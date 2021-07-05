Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 18DDB3BB49E
	for <lists+ceph-devel@lfdr.de>; Mon,  5 Jul 2021 03:23:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229689AbhGEBZl (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Sun, 4 Jul 2021 21:25:41 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:36123 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229549AbhGEBZl (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Sun, 4 Jul 2021 21:25:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1625448185;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=KpSSf+G6kLEsk52KJFF/9T/VZ+JArCUL9vEF2Lt4idI=;
        b=EEbCIRd9P/Qx3TT66wQxZaLy8zsVhcZnC7dcMAPktjhXia6uGVamaGgYlO82d5c8pOa5jB
        cO/C1ESjMzat0Z0tjBdcGGi9uOhsj1NVvnU27tAXZXW3aBx2v3RxqMBbEVbyH1fYIq2cI9
        wGw7T8k/cuu57vfMEqPE2e5o+9cMqG8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-547-8DhGjJCUP0it2wC-HjzpMQ-1; Sun, 04 Jul 2021 21:23:03 -0400
X-MC-Unique: 8DhGjJCUP0it2wC-HjzpMQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4313F1835AC2;
        Mon,  5 Jul 2021 01:23:02 +0000 (UTC)
Received: from lxbceph1.gsslab.pek2.redhat.com (unknown [10.72.47.117])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 62B5860875;
        Mon,  5 Jul 2021 01:23:00 +0000 (UTC)
From:   xiubli@redhat.com
To:     jlayton@kernel.org, idryomov@gmail.com
Cc:     pdonnell@redhat.com, ceph-devel@vger.kernel.org,
        Xiubo Li <xiubli@redhat.com>
Subject: [PATCH v2 0/4] flush the mdlog before waiting on unsafe reqs
Date:   Mon,  5 Jul 2021 09:22:53 +0800
Message-Id: <20210705012257.182669-1-xiubli@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
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

This patch will trigger to flush the mdlog in all the relevant and
auth MDSes manually just before waiting the unsafe requests to finish.


Changed in V2:
- send mdlog flush request to unsafe req relevant and auth MDSes only
instead of all of them.
- rename the first two commits' subject.
- fix the log messages.
- remove the feature bits fixing patch.
- fix some comments.
- remove flush_mdlog() wrapper.
- update the ceph_session_op_name() for new _REQUEST_FLUSH_MDLOG.



Xiubo Li (4):
  ceph: make ceph_create_session_msg a global symbol
  ceph: make iterate_sessions a global symbol
  ceph: flush mdlog before umounting
  ceph: flush the mdlog before waiting on unsafe reqs

 fs/ceph/caps.c               | 104 ++++++++++++++++++++++++++---------
 fs/ceph/mds_client.c         |  90 ++++++++++++++++++++++--------
 fs/ceph/mds_client.h         |   5 ++
 fs/ceph/strings.c            |   1 +
 include/linux/ceph/ceph_fs.h |   1 +
 5 files changed, 152 insertions(+), 49 deletions(-)

-- 
2.27.0

