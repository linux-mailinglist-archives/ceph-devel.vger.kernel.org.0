Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 997D71796BE
	for <lists+ceph-devel@lfdr.de>; Wed,  4 Mar 2020 18:33:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728926AbgCDRdH (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 4 Mar 2020 12:33:07 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:44726 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727084AbgCDRdH (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 4 Mar 2020 12:33:07 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1583343186;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=xM0ucriD5FN/0zLFlSGNj+qqxlqogOOhxXTL6sXcJ/o=;
        b=OFfKtYHJGeZOdYATW6JLx/mt6XkiSIxtKwuTR2Ka4RnxpusRypIorjrTxzE24PiP8aPwR3
        RVzephGxvbUlqRXJY/43ygXY8FimXvh5valIWTtJ1tgJQuLCZ3hF0exHKMRIbCu6xnh+He
        TxcHHOofCeG0CHK30+G/WXc/LD8IaCo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-44-FGvR-dJlOSqhC633mIcTXA-1; Wed, 04 Mar 2020 12:33:04 -0500
X-MC-Unique: FGvR-dJlOSqhC633mIcTXA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 91BEE1097C0B;
        Wed,  4 Mar 2020 17:33:02 +0000 (UTC)
Received: from zhyan-laptop.redhat.com (ovpn-12-198.pek2.redhat.com [10.72.12.198])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E16715C1D4;
        Wed,  4 Mar 2020 17:33:00 +0000 (UTC)
From:   "Yan, Zheng" <zyan@redhat.com>
To:     ceph-devel@vger.kernel.org
Cc:     jlayton@kernel.org, "Yan, Zheng" <zyan@redhat.com>
Subject: [PATCH v4 0/6] ceph: don't request caps for idle open files
Date:   Thu,  5 Mar 2020 01:32:52 +0800
Message-Id: <20200304173258.48377-1-zyan@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Content-Transfer-Encoding: quoted-printable
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

This series make cephfs client not request caps for open files that
idle for a long time. For the case that one active client and multiple
standby clients open the same file, this increase the possibility that
mds issues exclusive caps to the active client.

Yan, Zheng (6):
  ceph: always renew caps if mds_wanted is insufficient
  ceph: consider inode's last read/write when calculating wanted caps
  ceph: remove delay check logic from ceph_check_caps()
  ceph: simplify calling of ceph_get_fmode()
  ceph: update i_requested_max_size only when sending cap msg to auth mds
  ceph: check all mds' caps after page writeback

 fs/ceph/caps.c               | 338 ++++++++++++++++-------------------
 fs/ceph/file.c               |  45 ++---
 fs/ceph/inode.c              |  21 +--
 fs/ceph/ioctl.c              |   2 +
 fs/ceph/mds_client.c         |   5 -
 fs/ceph/super.h              |  37 ++--
 include/linux/ceph/ceph_fs.h |   1 +
 7 files changed, 202 insertions(+), 247 deletions(-)

changes since v2
 - make __ceph_caps_file_wanted() more readable
 - add patch 5 and 6, which fix hung write during testing patch 1~4

changes since v3
 - don't queue delayed cap check for snap inode
 - initialize ci->{last_rd,last_wr} to jiffies - 3600 * HZ
 - make __ceph_caps_file_wanted() check inode type

--=20
2.21.1

