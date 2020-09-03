Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B697725C1C3
	for <lists+ceph-devel@lfdr.de>; Thu,  3 Sep 2020 15:40:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728978AbgICNjr (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 3 Sep 2020 09:39:47 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:56679 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728731AbgICNB5 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 3 Sep 2020 09:01:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1599138112;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc; bh=y4G7VaqiU9ptN86sVXbUUGAETs7PTLWB655OROHK7Ds=;
        b=X4gIeVm4ibsh+n0JMsQA5V2sLXGrYa4+mCg8bcpoM/dtP+NJfsakD4KeQdQvDwee2LIKhS
        AsB1SfU09jr2ZqOoSBfJftN6CPfqQxediZv8DQNec4rxhwJ0Ipgg9UnV7ywnI0gzhj/Nbg
        5Fi0cdXkD7A5etwfDZLQV3PJDETmID4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-402-jG5_MuxpN3yztW0U-Ew2Lg-1; Thu, 03 Sep 2020 09:01:49 -0400
X-MC-Unique: jG5_MuxpN3yztW0U-Ew2Lg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1C2FE18A226F;
        Thu,  3 Sep 2020 13:01:48 +0000 (UTC)
Received: from lxbceph1.gsslab.pek2.redhat.com (vm37-202.gsslab.pek2.redhat.com [10.72.37.202])
        by smtp.corp.redhat.com (Postfix) with ESMTP id F106778B38;
        Thu,  3 Sep 2020 13:01:45 +0000 (UTC)
From:   xiubli@redhat.com
To:     jlayton@kernel.org
Cc:     idryomov@gmail.com, zyan@redhat.com, pdonnell@redhat.com,
        ceph-devel@vger.kernel.org, Xiubo Li <xiubli@redhat.com>
Subject: [PATCH v5 0/2] ceph: metrics for opened files, pinned caps and opened inodes
Date:   Thu,  3 Sep 2020 09:01:38 -0400
Message-Id: <20200903130140.799392-1-xiubli@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: Xiubo Li <xiubli@redhat.com>

Changed in V5:
- Remove mdsc parsing helpers except the ceph_sb_to_mdsc()
- Remove the is_opened member.

Changed in V4:
- A small fix about the total_inodes.

Changed in V3:
- Resend for V2 just forgot one patch, which is adding some helpers
support to simplify the code.

Changed in V2:
- Add number of inodes that have opened files.
- Remove the dir metrics and fold into files.



Xiubo Li (2):
  ceph: add ceph_sb_to_mdsc helper support to parse the mdsc
  ceph: metrics for opened files, pinned caps and opened inodes

 fs/ceph/caps.c    | 41 +++++++++++++++++++++++++++++++++++++----
 fs/ceph/debugfs.c | 11 +++++++++++
 fs/ceph/dir.c     | 20 +++++++-------------
 fs/ceph/file.c    | 13 ++++++-------
 fs/ceph/inode.c   | 11 ++++++++---
 fs/ceph/locks.c   |  2 +-
 fs/ceph/metric.c  | 14 ++++++++++++++
 fs/ceph/metric.h  |  7 +++++++
 fs/ceph/quota.c   | 10 +++++-----
 fs/ceph/snap.c    |  2 +-
 fs/ceph/super.h   |  6 ++++++
 11 files changed, 103 insertions(+), 34 deletions(-)

-- 
2.18.4

