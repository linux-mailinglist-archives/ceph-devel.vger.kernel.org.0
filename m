Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7044D4B6BF2
	for <lists+ceph-devel@lfdr.de>; Tue, 15 Feb 2022 13:23:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235970AbiBOMXn (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 15 Feb 2022 07:23:43 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:33198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236217AbiBOMXm (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 15 Feb 2022 07:23:42 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 8CF61107AAA
        for <ceph-devel@vger.kernel.org>; Tue, 15 Feb 2022 04:23:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1644927811;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=w8KBn54bNFestk2yygnNscAaUId+zdXkb9FTWCtNW+8=;
        b=DNH+GRp8CS6T/MZq9PBrhltvCr7B7TNSyCpmSCZc1WKTa5wAIGMwV4snAy+JWRVGit3uwO
        THV7oLKLzaVzFVGTgLUnel9GuU0umP7ske6n42hjdEdzdjo6+Rz216eUWgcz5hgsxHxUBK
        bgs3F4VxV3gUCSEl658IppSnWwJsRTM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-351-mH5Qzo6-NNCYAYjXy0nYmw-1; Tue, 15 Feb 2022 07:23:28 -0500
X-MC-Unique: mH5Qzo6-NNCYAYjXy0nYmw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3D28F18460E5;
        Tue, 15 Feb 2022 12:23:27 +0000 (UTC)
Received: from lxbceph1.gsslab.pek2.redhat.com (unknown [10.72.47.117])
        by smtp.corp.redhat.com (Postfix) with ESMTP id DA694101F6CF;
        Tue, 15 Feb 2022 12:23:21 +0000 (UTC)
From:   xiubli@redhat.com
To:     jlayton@kernel.org
Cc:     idryomov@gmail.com, vshankar@redhat.com,
        ceph-devel@vger.kernel.org, Xiubo Li <xiubli@redhat.com>
Subject: [PATCH 0/3] ceph: fix cephfs rsync kworker high load issue
Date:   Tue, 15 Feb 2022 20:23:13 +0800
Message-Id: <20220215122316.7625-1-xiubli@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: Xiubo Li <xiubli@redhat.com>

Xiubo Li (3):
  ceph: move to a dedicated slabcache for ceph_cap_snap
  ceph: move kzalloc under i_ceph_lock with GFP_ATOMIC flag
  ceph: do no update snapshot context when there is no new snapshot

 fs/ceph/snap.c               | 56 ++++++++++++++++++++++++------------
 fs/ceph/super.c              |  7 +++++
 fs/ceph/super.h              |  2 +-
 include/linux/ceph/libceph.h |  1 +
 4 files changed, 47 insertions(+), 19 deletions(-)

-- 
2.27.0

