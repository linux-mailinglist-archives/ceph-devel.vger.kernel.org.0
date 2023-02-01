Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 66405685CAB
	for <lists+ceph-devel@lfdr.de>; Wed,  1 Feb 2023 02:37:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229991AbjBABho (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 31 Jan 2023 20:37:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229863AbjBABho (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 31 Jan 2023 20:37:44 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD1764FAE0
        for <ceph-devel@vger.kernel.org>; Tue, 31 Jan 2023 17:37:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1675215420;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=wTkZ/4ghEIcoWv51VyDHKbmQhB/kamlQY+76dxcIiIQ=;
        b=OWE/4CftncfyJFHYeChguftxbd3kwTV6w4EncCxDfPRUWcE7cL0QyQDx2RanGruotgbQxJ
        a2ISVmoxVSa7IYFcLvpsnaZ7NxDklBc9rWHe45R6XaAh640MqPynOWq3g3E3PEDtRlreul
        MhwVi/wt+SqRfYWU8ukaMCSjpLJy2Jw=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-418-eh-YjtQsNvmfka7fWQJRKA-1; Tue, 31 Jan 2023 20:36:56 -0500
X-MC-Unique: eh-YjtQsNvmfka7fWQJRKA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2C653802314;
        Wed,  1 Feb 2023 01:36:56 +0000 (UTC)
Received: from lxbceph1.gsslab.pek2.redhat.com (unknown [10.72.47.117])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 679EF422FE;
        Wed,  1 Feb 2023 01:36:53 +0000 (UTC)
From:   xiubli@redhat.com
To:     idryomov@gmail.com, ceph-devel@vger.kernel.org
Cc:     jlayton@kernel.org, mchangir@redhat.com, vshankar@redhat.com,
        lhenriques@suse.de, Xiubo Li <xiubli@redhat.com>
Subject: [PATCH v7 0/2] ceph: blocklist the kclient when receiving corrupted snap trace
Date:   Wed,  1 Feb 2023 09:36:43 +0800
Message-Id: <20230201013645.404251-1-xiubli@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
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

V7:
- fix the debug log
- reorder the fence io and request's err checking
- remove stray whitespace

V6:
- switch to ceph_inode_is_shutdown() to check the mount state
- fix two debug logs
- use the WRITE_ONCE to set the FENCE_IO state

V5:
- s/CEPH_MOUNT_CORRUPTED/CEPH_MOUNT_FENCE_IO/g

V4:
- block all the IO/metadata requests before evicting the client.

V3:
- Fixed ERROR: spaces required around that ':' (ctx:VxW)

V2:
- Switched to WARN() to taint the Linux kernel.

Xiubo Li (2):
  ceph: move mount state enum to fs/ceph/super.h
  ceph: blocklist the kclient when receiving corrupted snap trace

 fs/ceph/addr.c               | 17 ++++++++++++++--
 fs/ceph/caps.c               | 16 ++++++++++++---
 fs/ceph/file.c               |  9 +++++++++
 fs/ceph/mds_client.c         | 28 +++++++++++++++++++++++---
 fs/ceph/snap.c               | 38 ++++++++++++++++++++++++++++++++++--
 fs/ceph/super.h              | 11 +++++++++++
 include/linux/ceph/libceph.h | 10 ----------
 7 files changed, 109 insertions(+), 20 deletions(-)

-- 
2.31.1

