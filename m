Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8BF6962EBA6
	for <lists+ceph-devel@lfdr.de>; Fri, 18 Nov 2022 03:07:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240749AbiKRCHs (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 17 Nov 2022 21:07:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240746AbiKRCHr (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 17 Nov 2022 21:07:47 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0EBA87A5A
        for <ceph-devel@vger.kernel.org>; Thu, 17 Nov 2022 18:06:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1668737211;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=aQfRGAJT8YybJ6Rqyzsdpd1icwaPrtbOkq+tkn5Lzuk=;
        b=TWaDH9WrGGLM6toNbT5w7/tdoVr9/QzRPWBibZzac6k2//Zp/fBP7+9P+manRrelHmnzR/
        ujLCzZJj6cyxzKfui0MGQ3nqHKGJguHjzHr3568go1Zs9g3Kr22+fRUo/9vHqWJUMk7aju
        srkTkiW/TAsSf6Kd3y+CkpOgnZnm65s=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-20-hQGwFr__MCa6qtadNgj0Dg-1; Thu, 17 Nov 2022 21:06:49 -0500
X-MC-Unique: hQGwFr__MCa6qtadNgj0Dg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 02C803804A4E;
        Fri, 18 Nov 2022 02:06:49 +0000 (UTC)
Received: from lxbceph1.gsslab.pek2.redhat.com (unknown [10.72.47.117])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 69242C158CF;
        Fri, 18 Nov 2022 02:06:45 +0000 (UTC)
From:   xiubli@redhat.com
To:     ceph-devel@vger.kernel.org, jlayton@kernel.org, idryomov@gmail.com
Cc:     lhenriques@suse.de, mchangir@redhat.com, viro@zeniv.linux.org.uk,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Xiubo Li <xiubli@redhat.com>
Subject: [PATCH 0/2 v3] ceph: fix the use-after-free bug for file_lock
Date:   Fri, 18 Nov 2022 10:06:40 +0800
Message-Id: <20221118020642.472484-1-xiubli@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
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
  ceph: add ceph_lock_info support for file_lock

 fs/ceph/caps.c                  |  2 +-
 fs/ceph/locks.c                 | 24 ++++++++++++++++++------
 fs/ceph/super.h                 |  1 -
 include/linux/ceph/ceph_fs_fl.h | 17 +++++++++++++++++
 include/linux/fs.h              |  2 ++
 5 files changed, 38 insertions(+), 8 deletions(-)
 create mode 100644 include/linux/ceph/ceph_fs_fl.h

-- 
2.31.1

