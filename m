Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 95B2664B4E2
	for <lists+ceph-devel@lfdr.de>; Tue, 13 Dec 2022 13:12:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235498AbiLMMMK (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 13 Dec 2022 07:12:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235307AbiLMML7 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 13 Dec 2022 07:11:59 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26BD114D19
        for <ceph-devel@vger.kernel.org>; Tue, 13 Dec 2022 04:11:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1670933478;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=Nmn/gU7bhXrocCzRhJlM4c++KyOuSLsv/MuG2QFOKHU=;
        b=JTLe0Zg4VlE9OUtsesWIiQ0xzbFuaHA7/oAZX81KgFGCyjzFHuLrAPY3Jdg8kMjFgDXtcY
        ayJbLwvIq0De29h8UtIUHZdbVKcPtKeyke7CUseija1DNwEw6PfsXvdMr/gAbxJ7xxFh0D
        WH23Ws4UPzndeYWt24qh5Ouko3nsOss=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-655-PIf8-ThtNJO02Pqmlk19Ng-1; Tue, 13 Dec 2022 07:11:13 -0500
X-MC-Unique: PIf8-ThtNJO02Pqmlk19Ng-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8CF7B85CE08;
        Tue, 13 Dec 2022 12:11:12 +0000 (UTC)
Received: from lxbceph1.gsslab.pek2.redhat.com (unknown [10.72.47.117])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 140E540AE1E9;
        Tue, 13 Dec 2022 12:11:07 +0000 (UTC)
From:   xiubli@redhat.com
To:     jlayton@kernel.org, idryomov@gmail.com, ceph-devel@vger.kernel.org
Cc:     mchangir@redhat.com, lhenriques@suse.de, viro@zeniv.linux.org.uk,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Xiubo Li <xiubli@redhat.com>
Subject: [PATCH v4 0/2] ceph: fix the use-after-free bug for file_lock
Date:   Tue, 13 Dec 2022 20:11:01 +0800
Message-Id: <20221213121103.213631-1-xiubli@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: Xiubo Li <xiubli@redhat.com>

Changed in V4:
- repeat the afs in fs.h instead of adding ceph specific header file

Changed in V3:
- switched to vfs_inode_has_locks() helper to fix another ceph file lock
bug, thanks Jeff!
- this patch series is based on Jeff's previous VFS lock patch:
  https://patchwork.kernel.org/project/ceph-devel/list/?series=695950

Changed in V2:
- switch to file_lock.fl_u to fix the race bug
- and the most code will be in the ceph layer

Xiubo Li (2):
  ceph: switch to vfs_inode_has_locks() to fix file lock bug
  ceph: add ceph specific member support for file_lock

 fs/ceph/caps.c     |  2 +-
 fs/ceph/locks.c    | 24 ++++++++++++++++++------
 fs/ceph/super.h    |  1 -
 include/linux/fs.h |  3 +++
 4 files changed, 22 insertions(+), 8 deletions(-)

-- 
2.31.1

