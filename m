Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 02DCD55B50C
	for <lists+ceph-devel@lfdr.de>; Mon, 27 Jun 2022 04:02:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229801AbiF0CCn (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Sun, 26 Jun 2022 22:02:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229463AbiF0CCn (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Sun, 26 Jun 2022 22:02:43 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 33411EB5
        for <ceph-devel@vger.kernel.org>; Sun, 26 Jun 2022 19:02:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1656295361;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=a3KWLV+tcPCONWgRn8PV2pxwPws+fKq4hYrtdjIBU/M=;
        b=Oirjiabd6isSHh0RC3yKvSI5gWUUawJ6SO+DoAzdxmgM5d/Kxg6DVZNDb29XioYPY3LlLX
        Esr29WFDG/zRQ/isRKl/FSizC5sXoZYFhoStoGVLclyxz23yTXGeGNNZFHRwMhd2XAkpmc
        e0uFQWrfJx/yABVFP/X6+35G8fjpYaw=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-218-o3Ys6pLPOySg9TMPNmNyAQ-1; Sun, 26 Jun 2022 22:02:37 -0400
X-MC-Unique: o3Ys6pLPOySg9TMPNmNyAQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2301C299E77D;
        Mon, 27 Jun 2022 02:02:37 +0000 (UTC)
Received: from lxbceph1.gsslab.pek2.redhat.com (unknown [10.72.47.117])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4A8A8C08087;
        Mon, 27 Jun 2022 02:02:33 +0000 (UTC)
From:   xiubli@redhat.com
To:     jlayton@kernel.org, idryomov@gmail.com
Cc:     vshankar@redhat.com, pdonnell@redhat.com, lhenriques@suse.de,
        ceph-devel@vger.kernel.org, Xiubo Li <xiubli@redhat.com>
Subject: [PATCH v2 0/2] ceph: switch to 4KB block size if quota size is not aligned to 4MB
Date:   Mon, 27 Jun 2022 10:02:00 +0800
Message-Id: <20220627020203.173293-1-xiubli@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
X-Spam-Status: No, score=-2.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: Xiubo Li <xiubli@redhat.com>

V2:
- Switched to IS_ALIGNED() macro
- Added CEPH_4K_BLOCK_SIZE macro
- Rename CEPH_BLOCK to CEPH_BLOCK_SIZE

Xiubo Li (3):
  ceph: make f_bsize always equal to f_frsize
  ceph: switch to use CEPH_4K_BLOCK_SHIFT macro
  ceph: switch to 4KB block size if quota size is not aligned to 4MB

 fs/ceph/quota.c | 32 ++++++++++++++++++++------------
 fs/ceph/super.c | 28 ++++++++++++++--------------
 fs/ceph/super.h |  5 +++--
 3 files changed, 37 insertions(+), 28 deletions(-)

-- 
2.36.0.rc1

