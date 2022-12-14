Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2025E64CAD9
	for <lists+ceph-devel@lfdr.de>; Wed, 14 Dec 2022 14:14:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238581AbiLNNOK (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 14 Dec 2022 08:14:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238573AbiLNNOC (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 14 Dec 2022 08:14:02 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94AC210A3
        for <ceph-devel@vger.kernel.org>; Wed, 14 Dec 2022 05:13:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1671023596;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=QOwGv901pllqFOEV2tGHpEbQ3tIqDfx5elblceAuPEI=;
        b=IZi0mC58EeJ19liaaqjrW079j1gX4cauIOCURHmY3RyJCcAOqwFbR7MBz5vL7rL76Uawz0
        dLF1Nq+aZGOcF+DXZa73ZyGUaaFSQgSUqYpKJGQ5k7UDQZiFX7Gwlmtv1l07YdPm4oUP/k
        VipmXhlm+dVC941fL1HWceu1eO4wUAg=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-66-pK6vCix4PM6k8ogrM7f2dA-1; Wed, 14 Dec 2022 08:13:13 -0500
X-MC-Unique: pK6vCix4PM6k8ogrM7f2dA-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 40D141C0513D;
        Wed, 14 Dec 2022 13:13:13 +0000 (UTC)
Received: from lxbceph1.gsslab.pek2.redhat.com (unknown [10.72.47.117])
        by smtp.corp.redhat.com (Postfix) with ESMTP id AEC95400F5A;
        Wed, 14 Dec 2022 13:13:10 +0000 (UTC)
From:   xiubli@redhat.com
To:     idryomov@gmail.com, ceph-devel@vger.kernel.org
Cc:     jlayton@kernel.org, mchangir@redhat.com, vshankar@redhat.com,
        Xiubo Li <xiubli@redhat.com>
Subject: [PATCH v4 0/2]  ceph: blocklist the kclient when receiving corrupted snap trace
Date:   Wed, 14 Dec 2022 21:13:05 +0800
Message-Id: <20221214131307.42618-1-xiubli@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: Xiubo Li <xiubli@redhat.com>

V4:
- block all the IO/metadata requests before evicting the client.

V3:
- Fixed ERROR: spaces required around that ':' (ctx:VxW)

V2:
- Switched to WARN() to taint the Linux kernel.

Xiubo Li (2):
  ceph: move mount state enum to fs/ceph/super.h
  ceph: blocklist the kclient when receiving corrupted snap trace

 fs/ceph/addr.c               | 22 +++++++++++++++++++--
 fs/ceph/caps.c               | 17 ++++++++++++++---
 fs/ceph/file.c               |  9 +++++++++
 fs/ceph/mds_client.c         | 28 ++++++++++++++++++++++++---
 fs/ceph/snap.c               | 37 ++++++++++++++++++++++++++++++++++--
 fs/ceph/super.h              | 11 +++++++++++
 include/linux/ceph/libceph.h | 10 ----------
 7 files changed, 114 insertions(+), 20 deletions(-)

-- 
2.31.1

