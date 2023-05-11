Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 112E26FE9FF
	for <lists+ceph-devel@lfdr.de>; Thu, 11 May 2023 05:05:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236082AbjEKDFF (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 10 May 2023 23:05:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236088AbjEKDEt (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 10 May 2023 23:04:49 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8F0A1FCE
        for <ceph-devel@vger.kernel.org>; Wed, 10 May 2023 20:04:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1683774239;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=JptARYMI5KEc5sVLe3d6cz9hnL7OemyHmGZsPCauSKk=;
        b=bbKWYy2ZBVvs1j66rLhN/uS3rsjpZmqJbmfhbhnNSGEiqixP8ysPzXPB7Cat9mEKAkPo55
        BwLj8E7QWbBozo0WeCdigtDTtSyvaH4wI3ex6PqgEwsQOdbGZFu5o7qzCgHScf/EnaTAfL
        v4TP/Kro0JYDZDmsL+miOosArqby9Ow=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-428-huOn_8DTOWmEPFydZ8UuFQ-1; Wed, 10 May 2023 23:03:54 -0400
X-MC-Unique: huOn_8DTOWmEPFydZ8UuFQ-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A19B929DD984;
        Thu, 11 May 2023 03:03:53 +0000 (UTC)
Received: from li-a71a4dcc-35d1-11b2-a85c-951838863c8d.ibm.com.com (ovpn-12-156.pek2.redhat.com [10.72.12.156])
        by smtp.corp.redhat.com (Postfix) with ESMTP id EDBCA492C13;
        Thu, 11 May 2023 03:03:49 +0000 (UTC)
From:   xiubli@redhat.com
To:     idryomov@gmail.com, ceph-devel@vger.kernel.org
Cc:     jlayton@kernel.org, vshankar@redhat.com, sehuww@mail.scut.edu.cn,
        Xiubo Li <xiubli@redhat.com>
Subject: [PATCH v5 0/2] ceph: fix blindly expanding the readahead windows
Date:   Thu, 11 May 2023 11:03:33 +0800
Message-Id: <20230511030335.337094-1-xiubli@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: Xiubo Li <xiubli@redhat.com>

V5:
- Fixed the file ra_pages issue about the posix_fadvise

Xiubo Li (2):
  ceph: add a dedicated private data for netfs rreq
  ceph: fix blindly expanding the readahead windows

 fs/ceph/addr.c  | 83 ++++++++++++++++++++++++++++++++++++++-----------
 fs/ceph/super.h | 13 ++++++++
 2 files changed, 78 insertions(+), 18 deletions(-)

-- 
2.40.0

