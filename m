Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4BD034C621D
	for <lists+ceph-devel@lfdr.de>; Mon, 28 Feb 2022 05:20:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232957AbiB1EVR (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Sun, 27 Feb 2022 23:21:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232958AbiB1EVP (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Sun, 27 Feb 2022 23:21:15 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 1ED823EA8F
        for <ceph-devel@vger.kernel.org>; Sun, 27 Feb 2022 20:20:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646022037;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=h7fU9XylpYaxBjeYSj/3OcKuS7WC3APJPCMbxybS8sc=;
        b=FZQZc5Cbxrx49Fyiv6KWvtKhQTh9m2seqzjHXglRrMweADnPYSlsmLPSl0w6S8qjzm7Jvb
        v1OCPzifTn5ue78L6njX6opUTFG2KxFwkY9CXYfi1wdozOf9u6cz2ASOY2pShGo6H0uCOK
        wkxAjDOswucuMsODK5Idt9EktuTD/ZY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-112-Q86wSbIGOE2g9sjudBEx8A-1; Sun, 27 Feb 2022 23:20:35 -0500
X-MC-Unique: Q86wSbIGOE2g9sjudBEx8A-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8CB4A1006AA5;
        Mon, 28 Feb 2022 04:20:34 +0000 (UTC)
Received: from lxbceph1.gsslab.pek2.redhat.com (unknown [10.72.47.117])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E9C08452FA;
        Mon, 28 Feb 2022 04:20:27 +0000 (UTC)
From:   xiubli@redhat.com
To:     jlayton@kernel.org
Cc:     idryomov@gmail.com, vshankar@redhat.com, lhenriques@suse.de,
        ceph-devel@vger.kernel.org, Xiubo Li <xiubli@redhat.com>
Subject: [PATCH 0/3] ceph: encrypt the snapshot directories
Date:   Mon, 28 Feb 2022 12:20:22 +0800
Message-Id: <20220228042025.30806-1-xiubli@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: Xiubo Li <xiubli@redhat.com>




Xiubo Li (3):
  ceph: add ceph_get_snap_parent_inode() support
  ceph: use the parent inode of '.snap' to dencrypt the names for
    readdir
  ceph: use the parent inode of '.snap' to encrypt name to build path

 fs/ceph/dir.c        | 17 ++++++++++-------
 fs/ceph/inode.c      | 15 +++++++++------
 fs/ceph/mds_client.c | 33 ++++++++++++++++++++-------------
 fs/ceph/snap.c       | 24 ++++++++++++++++++++++++
 fs/ceph/super.h      |  1 +
 5 files changed, 64 insertions(+), 26 deletions(-)

-- 
2.27.0

