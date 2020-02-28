Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AB7291736AA
	for <lists+ceph-devel@lfdr.de>; Fri, 28 Feb 2020 12:56:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726661AbgB1L4A (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 28 Feb 2020 06:56:00 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:20286 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726631AbgB1L4A (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Fri, 28 Feb 2020 06:56:00 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582890959;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=WsNfg4ZiCIQ4+sf3HaTPwSrgnKTc3A8/MlgelaERrk4=;
        b=O3vWb12QV90NfQjmBIZsHKUOeeINrmE/0RY4vjHUTQm7NXh2lZIM7H0wIb40fe7lOukZ/p
        v1z5ZEasGVLooZgvJsv/9DxuDtaVLUt2IXw9NEvIimsr2FWg4ho0tXVYEebACzTSjlKhEb
        A1McmdVKtUEVwmUS08ezydQF5PMN8xE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-256-teb8JpgtN4qQFT0sI_idRg-1; Fri, 28 Feb 2020 06:55:56 -0500
X-MC-Unique: teb8JpgtN4qQFT0sI_idRg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 203A713E4;
        Fri, 28 Feb 2020 11:55:55 +0000 (UTC)
Received: from zhyan-laptop.redhat.com (ovpn-12-212.pek2.redhat.com [10.72.12.212])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 408275C54A;
        Fri, 28 Feb 2020 11:55:52 +0000 (UTC)
From:   "Yan, Zheng" <zyan@redhat.com>
To:     ceph-devel@vger.kernel.org
Cc:     jlayton@kernel.org, "Yan, Zheng" <zyan@redhat.com>
Subject: [PATCH v3 0/6] ceph: don't request caps for idle open files
Date:   Fri, 28 Feb 2020 19:55:44 +0800
Message-Id: <20200228115550.6904-1-zyan@redhat.com>
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

changes since v2
 - make __ceph_caps_file_wanted more readable
 - add patch 5 and 6, which fix hung write during testing patch 1~4

--=20
2.21.1

