Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 651AB5596DE
	for <lists+ceph-devel@lfdr.de>; Fri, 24 Jun 2022 11:39:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229915AbiFXJhl (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 24 Jun 2022 05:37:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229889AbiFXJhk (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Fri, 24 Jun 2022 05:37:40 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id D08B7792B9
        for <ceph-devel@vger.kernel.org>; Fri, 24 Jun 2022 02:37:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1656063459;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=FP7kJWMp4zrtSYi+Q5Rnl3BtduHzgl9spGLOObgtvos=;
        b=HA0xSPXplKDQuTyaLEsXZWfOAHVN3EvUlTBWH4r8U3EbO5TWMBvZvbPpYpjyerDWJZ/3a9
        HVX2OV5ZMBPOaejdOjyimta05AMcm5+cvxXHLrUo3fBNMxXno7flMOe3hQbovLhIoact0B
        oJF6g7IDQLFCHtaO0qRvYClaPxq8MgY=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-187-JvMOextWPsG5z2Sp7qnMXw-1; Fri, 24 Jun 2022 05:37:37 -0400
X-MC-Unique: JvMOextWPsG5z2Sp7qnMXw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id DB0493C1105C;
        Fri, 24 Jun 2022 09:37:36 +0000 (UTC)
Received: from lxbceph1.gsslab.pek2.redhat.com (unknown [10.72.47.117])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 059B81121314;
        Fri, 24 Jun 2022 09:37:33 +0000 (UTC)
From:   xiubli@redhat.com
To:     jlayton@kernel.org, idryomov@gmail.com
Cc:     vshankar@redhat.com, pdonnell@redhat.com, lhenriques@suse.de,
        ceph-devel@vger.kernel.org, Xiubo Li <xiubli@redhat.com>
Subject: [PATCH 0/2] ceph: switch to 4KB block size if quota size is not aligned to 4MB
Date:   Fri, 24 Jun 2022 17:37:28 +0800
Message-Id: <20220624093730.8564-1-xiubli@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: Xiubo Li <xiubli@redhat.com>


Xiubo Li (2):
  ceph: make f_bsize always equal to f_frsize
  ceph: switch to 4KB block size if quota size is not aligned to 4MB

 fs/ceph/quota.c | 31 ++++++++++++++++++++-----------
 fs/ceph/super.c | 22 +++++++++++-----------
 2 files changed, 31 insertions(+), 22 deletions(-)

-- 
2.36.0.rc1

