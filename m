Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A037452BDD4
	for <lists+ceph-devel@lfdr.de>; Wed, 18 May 2022 17:25:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238899AbiEROqK (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 18 May 2022 10:46:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238904AbiEROqG (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 18 May 2022 10:46:06 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id AC5543E0EE
        for <ceph-devel@vger.kernel.org>; Wed, 18 May 2022 07:46:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1652885164;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=gGE+Ub17qq/C1GkdhUyvVjCTwA0D6nQtm+wNAxOQhrU=;
        b=Hg3OOMlBIot1n1uY6yZoPnxw+G22QRZ8ku1mxMCcBYuc9XzBSkGwCSb2WzxGnkv+fa8hOj
        RSFGaFegR0DCoJj3Osb4SX/lTuCFabr//gJMS6jwc4Lzh8Nra3T1Lz4svJji3ViT/0vTyZ
        V2MAHyyhQFWFXNKgUNwCgZNfjSOwpoM=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-594-d6QY-msDMG6MLmcXX9hRyA-1; Wed, 18 May 2022 10:46:01 -0400
X-MC-Unique: d6QY-msDMG6MLmcXX9hRyA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id F04B8801210;
        Wed, 18 May 2022 14:46:00 +0000 (UTC)
Received: from localhost (unknown [10.72.47.117])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4568D2026D64;
        Wed, 18 May 2022 14:45:54 +0000 (UTC)
From:   Xiubo Li <xiubli@redhat.com>
To:     jlayton@kernel.org, idryomov@gmail.com, viro@zeniv.linux.org.uk
Cc:     willy@infradead.org, vshankar@redhat.com,
        ceph-devel@vger.kernel.org, arnd@arndb.de, mcgrof@kernel.org,
        akpm@linux-foundation.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, Xiubo Li <xiubli@redhat.com>
Subject: [PATCH v4 0/2] ceph: wait async unlink to finish
Date:   Wed, 18 May 2022 22:45:43 +0800
Message-Id: <20220518144545.246604-1-xiubli@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

V4:
- Switch to use TASK_KILLABLE

V3:
- Removed WARN_ON_ONCE()/BUG_ON().
- Set the hashtable bit to 8.

V2:
- Add one dedicated spin lock to protect the list_add/del_rcu
- Other small fixes
- Fix the compile error from kernel test robot



Xiubo Li (2):
  fs/dcache: add d_compare() helper support
  ceph: wait the first reply of inflight async unlink

 fs/ceph/dir.c          | 70 +++++++++++++++++++++++++++++++++++++---
 fs/ceph/file.c         |  4 +++
 fs/ceph/mds_client.c   | 73 ++++++++++++++++++++++++++++++++++++++++++
 fs/ceph/mds_client.h   |  1 +
 fs/ceph/super.c        |  3 ++
 fs/ceph/super.h        | 19 ++++++++---
 fs/dcache.c            | 15 +++++++++
 include/linux/dcache.h |  2 ++
 8 files changed, 177 insertions(+), 10 deletions(-)

-- 
2.36.0.rc1

