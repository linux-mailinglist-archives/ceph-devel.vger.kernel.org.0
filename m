Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 233F0721F6E
	for <lists+ceph-devel@lfdr.de>; Mon,  5 Jun 2023 09:24:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230248AbjFEHYQ (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 5 Jun 2023 03:24:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229494AbjFEHYO (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 5 Jun 2023 03:24:14 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 220D798
        for <ceph-devel@vger.kernel.org>; Mon,  5 Jun 2023 00:23:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1685949809;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=YccbiWxlzTw0bc0mwSIUpyv7KTIdVADk62GmgMnR6i8=;
        b=c9CKdFqfA7cXysNDbJ8pp/9Ab9Rsw7tcV1UEHu1DWzT1Xz/zsA3d2CkQjzpVmflzLtmCWc
        7xq5lwGkUoEbilvFSbUHMmDgvKumWkQh1DIa2IOgj1PZge9MGdL17nkLSRSTbLnrtKwbAR
        QUFF9uJvbn7hSg8OJLS085od6p9kxZY=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-442-O5VpZ2L4Ml-RGRhySgdtLQ-1; Mon, 05 Jun 2023 03:23:25 -0400
X-MC-Unique: O5VpZ2L4Ml-RGRhySgdtLQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B2037101A53A;
        Mon,  5 Jun 2023 07:23:24 +0000 (UTC)
Received: from li-a71a4dcc-35d1-11b2-a85c-951838863c8d.ibm.com.com (ovpn-12-216.pek2.redhat.com [10.72.12.216])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 477FD1121314;
        Mon,  5 Jun 2023 07:23:18 +0000 (UTC)
From:   xiubli@redhat.com
To:     idryomov@gmail.com, ceph-devel@vger.kernel.org
Cc:     jlayton@kernel.org, vshankar@redhat.com, mchangir@redhat.com,
        sehuww@mail.scut.edu.cn, Xiubo Li <xiubli@redhat.com>
Subject: [PATCH v7 0/2] ceph: fix blindly expanding the readahead windows
Date:   Mon,  5 Jun 2023 15:21:07 +0800
Message-Id: <20230605072109.1027246-1-xiubli@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: Xiubo Li <xiubli@redhat.com>

V7:
- two typo fixes.

Xiubo Li (2):
  ceph: add a dedicated private data for netfs rreq
  ceph: fix blindly expanding the readahead windows

 fs/ceph/addr.c  | 85 ++++++++++++++++++++++++++++++++++++++-----------
 fs/ceph/super.h | 13 ++++++++
 2 files changed, 80 insertions(+), 18 deletions(-)

-- 
2.40.1

