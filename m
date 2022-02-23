Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 07F344C077C
	for <lists+ceph-devel@lfdr.de>; Wed, 23 Feb 2022 02:59:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232502AbiBWCAO (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 22 Feb 2022 21:00:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230187AbiBWCAN (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 22 Feb 2022 21:00:13 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 691A33BFAC
        for <ceph-devel@vger.kernel.org>; Tue, 22 Feb 2022 17:59:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1645581585;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=wvNrlZGJgKK67rEfV6Z2F0lIyvNm7fwNah0cpofYViI=;
        b=Ub/V2Jk9HW3Sf2+i5gMNhrpLe1kwd5zQAYT3Md6MKKWWidXJ7bDP7La1ON/Y6TMNg3tRs3
        YjwN4QvGYwldq6pNpL+ZsyRxeQApvgv+iPZlucG2sNAidOwCgfPmIw9FgeHxdxBcNZiYRa
        EOmIEkhljqIDlT5AUCX7LH36iZdOQMQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-375-OXdvXRAVNJef90WZCch2UQ-1; Tue, 22 Feb 2022 20:59:42 -0500
X-MC-Unique: OXdvXRAVNJef90WZCch2UQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DDADB804310;
        Wed, 23 Feb 2022 01:59:40 +0000 (UTC)
Received: from lxbceph1.gsslab.pek2.redhat.com (unknown [10.72.47.117])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 273C85F51D;
        Wed, 23 Feb 2022 01:59:38 +0000 (UTC)
From:   xiubli@redhat.com
To:     jlayton@kernel.org
Cc:     idryomov@gmail.com, vshankar@redhat.com,
        ceph-devel@vger.kernel.org, Xiubo Li <xiubli@redhat.com>
Subject: [PATCH v3 0/2] ceph: fix cephfs rsync kworker high load issue
Date:   Wed, 23 Feb 2022 09:59:32 +0800
Message-Id: <20220223015934.37379-1-xiubli@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: Xiubo Li <xiubli@redhat.com>

V3:
- switch to use the kmem_cache_zalloc() to zero the memory.
- rebase to the latest code in testing branch.

V2:
- allocate the capsnap memory ourside of ceph_queue_cap_snap() from
Jeff's advice.
- fix the code style and logs to make the logs to be more readable

Xiubo Li (2):
  ceph: allocate capsnap memory outside of ceph_queue_cap_snap()
  ceph: misc fix for code style and logs

 fs/ceph/snap.c | 168 ++++++++++++++++++++++++++-----------------------
 1 file changed, 90 insertions(+), 78 deletions(-)

-- 
2.27.0

