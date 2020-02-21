Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 12FB0167E3D
	for <lists+ceph-devel@lfdr.de>; Fri, 21 Feb 2020 14:17:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728177AbgBUNRJ (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 21 Feb 2020 08:17:09 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:21036 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727053AbgBUNRJ (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Fri, 21 Feb 2020 08:17:09 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582291028;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=IRd0fntnYP70rF9AkJHDNxFPilJSKsTe7IYOQgL17jk=;
        b=EEhRLi6POzuCTMVgLwdXX5TbCM7HprzR8EqRjIc1qSLvxIdwVirX9o4TJXhSeVZJnkuPUc
        VHMDYruwwp9L5KrrFXbt86qqYfkb1NIcVpLdtEfYUHePx6UT3xr8I17RypkyvxWdaiyzOG
        77RZoqkHW/WPGPoM9fLGZ1FScsQ4Kw4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-70-qN9J2bIHO3CXWuXZdr0RNg-1; Fri, 21 Feb 2020 08:17:06 -0500
X-MC-Unique: qN9J2bIHO3CXWuXZdr0RNg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 450E5800D53;
        Fri, 21 Feb 2020 13:17:05 +0000 (UTC)
Received: from zhyan-laptop.redhat.com (ovpn-12-122.pek2.redhat.com [10.72.12.122])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 296C5610DB;
        Fri, 21 Feb 2020 13:17:00 +0000 (UTC)
From:   "Yan, Zheng" <zyan@redhat.com>
To:     ceph-devel@vger.kernel.org
Cc:     jlayton@kernel.org, "Yan, Zheng" <zyan@redhat.com>
Subject: [PATCH v2 0/4] ceph: don't request caps for idle open files
Date:   Fri, 21 Feb 2020 21:16:55 +0800
Message-Id: <20200221131659.87777-1-zyan@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Content-Transfer-Encoding: quoted-printable
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

This series make cephfs client not request caps for open files that
idle for a long time. For the case that one active client and multiple
standby clients open the same file, this increase the possibility that
mds issues exclusive caps to the active client.

Yan, Zheng (4):
  ceph: always renew caps if mds_wanted is insufficient
  ceph: consider inode's last read/write when calculating wanted caps
  ceph: simplify calling of ceph_get_fmode()
  ceph: remove delay check logic from ceph_check_caps()

 fs/ceph/caps.c               | 324 +++++++++++++++--------------------
 fs/ceph/file.c               |  39 ++---
 fs/ceph/inode.c              |  19 +-
 fs/ceph/ioctl.c              |   2 +
 fs/ceph/mds_client.c         |   5 -
 fs/ceph/super.h              |  35 ++--
 include/linux/ceph/ceph_fs.h |   1 +
 7 files changed, 188 insertions(+), 237 deletions(-)

--=20
2.21.1

