Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8568C72C375
	for <lists+ceph-devel@lfdr.de>; Mon, 12 Jun 2023 13:52:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232926AbjFLLwQ (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 12 Jun 2023 07:52:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232898AbjFLLv5 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 12 Jun 2023 07:51:57 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D20D065A5
        for <ceph-devel@vger.kernel.org>; Mon, 12 Jun 2023 04:46:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1686570379;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=MmFf7qGpYwWBTxaZWrYUPNGhZ0DNhu+ssRfG8uzJxr0=;
        b=BeUFj9qkuAzH9mKe+mhWmnw0E3LX89Gued5xBD/UkvrTIyMxuD7o9Bm3EG8kXe8LDyL9jI
        9NPAOQKejbvgxkD4c0GmR++kCDcM8N9hVRsg/MAQJ1Zw7BeckPzaP3onARqebls96093Ct
        JFN0iHFYndZv8uxirq9JyXAUV0wUutk=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-572-f2aBwJY-MAGaUa1xkKjPbQ-1; Mon, 12 Jun 2023 07:46:17 -0400
X-MC-Unique: f2aBwJY-MAGaUa1xkKjPbQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8758F3C0E447;
        Mon, 12 Jun 2023 11:46:17 +0000 (UTC)
Received: from li-a71a4dcc-35d1-11b2-a85c-951838863c8d.ibm.com.com (ovpn-12-125.pek2.redhat.com [10.72.12.125])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A35881121314;
        Mon, 12 Jun 2023 11:46:13 +0000 (UTC)
From:   xiubli@redhat.com
To:     idryomov@gmail.com, ceph-devel@vger.kernel.org
Cc:     jlayton@kernel.org, vshankar@redhat.com, khiremat@redhat.com,
        mchangir@redhat.com, pdonnell@redhat.com,
        Xiubo Li <xiubli@redhat.com>
Subject: [PATCH v2 0/6] ceph: print the client global id for debug logs
Date:   Mon, 12 Jun 2023 19:43:53 +0800
Message-Id: <20230612114359.220895-1-xiubli@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: Xiubo Li <xiubli@redhat.com>

V2:
- print the client global id for all the dout()/pr_warn(),etc.

This is based the testing branch.


Xiubo Li (6):
  ceph: add the *_client debug macros support
  ceph: pass the mdsc to several helpers
  ceph: rename _to_client() to _to_fs_client()
  ceph: move mdsmap.h to fs/ceph/
  ceph: add ceph_inode_to_client() helper support
  ceph: print the client global_id in all the debug logs

 fs/ceph/acl.c                       |   6 +-
 fs/ceph/addr.c                      | 320 +++++++-----
 fs/ceph/cache.c                     |   2 +-
 fs/ceph/caps.c                      | 762 ++++++++++++++++------------
 fs/ceph/crypto.c                    |  47 +-
 fs/ceph/debugfs.c                   |   8 +-
 fs/ceph/dir.c                       | 242 +++++----
 fs/ceph/export.c                    |  49 +-
 fs/ceph/file.c                      | 294 ++++++-----
 fs/ceph/inode.c                     | 542 +++++++++++---------
 fs/ceph/ioctl.c                     |  18 +-
 fs/ceph/locks.c                     |  62 ++-
 fs/ceph/mds_client.c                | 655 ++++++++++++++----------
 fs/ceph/mds_client.h                |   5 +-
 fs/ceph/mdsmap.c                    |  30 +-
 {include/linux => fs}/ceph/mdsmap.h |   5 +-
 fs/ceph/metric.c                    |   5 +-
 fs/ceph/quota.c                     |  31 +-
 fs/ceph/snap.c                      | 204 ++++----
 fs/ceph/super.c                     |  86 ++--
 fs/ceph/super.h                     |  19 +-
 fs/ceph/xattr.c                     | 109 ++--
 include/linux/ceph/ceph_debug.h     |  38 +-
 23 files changed, 2078 insertions(+), 1461 deletions(-)
 rename {include/linux => fs}/ceph/mdsmap.h (92%)

-- 
2.40.1

