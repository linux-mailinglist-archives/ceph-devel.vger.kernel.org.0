Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0DA7A17A525
	for <lists+ceph-devel@lfdr.de>; Thu,  5 Mar 2020 13:21:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725991AbgCEMVN (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 5 Mar 2020 07:21:13 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:51532 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725989AbgCEMVN (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 5 Mar 2020 07:21:13 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1583410872;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=h3d1NdfVce6RXWP6PGO/diImY0ZsLXeGXy9kEMUPkWE=;
        b=EIhu742ATERqzPb7Ni1kXl7zKG9DeilIWcTeUshtqrwaHHJMi+bG6MQag1ctogD/c6zXME
        2Z0g6IAm3Xql72Jqwyb95LIrk+3sGPte/iaMURCRarPZ1Kvzw72JlnZBffVv3W0tPOJsOh
        InsOvEjBAr8PqB1cjs7V6lt8B6vzBOI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-46-ogJpInBhMw-7cCEIwK93-A-1; Thu, 05 Mar 2020 07:21:10 -0500
X-MC-Unique: ogJpInBhMw-7cCEIwK93-A-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9FC2210CE782;
        Thu,  5 Mar 2020 12:21:09 +0000 (UTC)
Received: from zhyan-laptop.redhat.com (ovpn-12-47.pek2.redhat.com [10.72.12.47])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D8A551CB;
        Thu,  5 Mar 2020 12:21:07 +0000 (UTC)
From:   "Yan, Zheng" <zyan@redhat.com>
To:     ceph-devel@vger.kernel.org
Cc:     jlayton@kernel.org, "Yan, Zheng" <zyan@redhat.com>
Subject: [PATCH v5 0/7] ceph: don't request caps for idle open files
Date:   Thu,  5 Mar 2020 20:20:58 +0800
Message-Id: <20200305122105.69184-1-zyan@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Content-Transfer-Encoding: quoted-printable
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

This series make cephfs client not request caps for open files that
idle for a long time. For the case that one active client and multiple
standby clients open the same file, this increase the possibility that
mds issues exclusive caps to the active client.

Yan, Zheng (7):
  ceph: always renew caps if mds_wanted is insufficient
  ceph: consider inode's last read/write when calculating wanted caps
  ceph: remove delay check logic from ceph_check_caps()
  ceph: simplify calling of ceph_get_fmode()
  ceph: update i_requested_max_size only when sending cap msg to auth mds
  ceph: check all mds' caps after page writeback
  ceph: calculate dir's wanted caps according to recent dirops

 fs/ceph/caps.c               | 360 ++++++++++++++++-------------------
 fs/ceph/dir.c                |  21 +-
 fs/ceph/file.c               |  45 ++---
 fs/ceph/inode.c              |  21 +-
 fs/ceph/ioctl.c              |   2 +
 fs/ceph/mds_client.c         |  16 +-
 fs/ceph/super.h              |  37 ++--
 include/linux/ceph/ceph_fs.h |   1 +
 8 files changed, 243 insertions(+), 260 deletions(-)

changes since v2
 - make __ceph_caps_file_wanted() more readable
 - add patch 5 and 6, which fix hung write during testing patch 1~4

changes since v3
 - don't queue delayed cap check for snap inode
 - initialize ci->{last_rd,last_wr} to jiffies - 3600 * HZ
 - make __ceph_caps_file_wanted() check inode type

changes since v4
 - add patch 7, improve how to calculate dir's wanted caps

--=20
2.21.1

