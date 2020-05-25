Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D5D831E0CA9
	for <lists+ceph-devel@lfdr.de>; Mon, 25 May 2020 13:16:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390109AbgEYLQh (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 25 May 2020 07:16:37 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:34550 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2389897AbgEYLQh (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Mon, 25 May 2020 07:16:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1590405396;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc; bh=X8f7am6lBJ2PndUUas7ljwZg82QKXeqgxjZFswXtTNk=;
        b=FIISPDTPUCK98oBrzqQiu4LccdRLB74MbNvdIMhpgpmm6Ox2Mlva0gepyHw3w9NgfeEc21
        tbQC27vJtTQadOMR11xTNd07H/2CydgI2mO7jAR8jGMGhEUkr9yHTYc9Px2t0sPZj8Q7cd
        X8pHScHAmAdRU8H0yp7RIwKz3w93qys=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-398-Yx_tyOCwPsyIrAMrTS24vg-1; Mon, 25 May 2020 07:16:34 -0400
X-MC-Unique: Yx_tyOCwPsyIrAMrTS24vg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3E6A5460;
        Mon, 25 May 2020 11:16:33 +0000 (UTC)
Received: from lxbceph0.gsslab.pek2.redhat.com (vm36-245.gsslab.pek2.redhat.com [10.72.36.245])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1E9925C1BB;
        Mon, 25 May 2020 11:16:30 +0000 (UTC)
From:   xiubli@redhat.com
To:     jlayton@kernel.org, idryomov@gmail.com, zyan@redhat.com
Cc:     pdonnell@redhat.com, ceph-devel@vger.kernel.org,
        Xiubo Li <xiubli@redhat.com>
Subject: [PATCH v2 0/2] ceph: fix dead lock and double lock
Date:   Mon, 25 May 2020 07:16:23 -0400
Message-Id: <1590405385-27406-1-git-send-email-xiubli@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: Xiubo Li <xiubli@redhat.com>

Changed in V2:
- do not check the caps when reconnecting to mds
- switch ceph_async_check_caps() to ceph_async_put_cap_refs()


Xiubo Li (2):
  ceph: add ceph_async_put_cap_refs to avoid double lock and deadlock
  ceph: do not check the caps when reconnecting to mds

 fs/ceph/caps.c       | 45 +++++++++++++++++++++++++++++++++++++++++++--
 fs/ceph/dir.c        |  2 +-
 fs/ceph/file.c       |  2 +-
 fs/ceph/inode.c      |  3 +++
 fs/ceph/mds_client.c | 24 ++++++++++++++++--------
 fs/ceph/mds_client.h |  3 ++-
 fs/ceph/super.h      |  7 +++++++
 7 files changed, 73 insertions(+), 13 deletions(-)

-- 
1.8.3.1

