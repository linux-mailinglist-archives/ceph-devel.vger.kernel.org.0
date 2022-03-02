Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1C0C14CA47F
	for <lists+ceph-devel@lfdr.de>; Wed,  2 Mar 2022 13:13:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241664AbiCBMOS (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 2 Mar 2022 07:14:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238422AbiCBMOR (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 2 Mar 2022 07:14:17 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id BB0F62E0A2
        for <ceph-devel@vger.kernel.org>; Wed,  2 Mar 2022 04:13:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646223212;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=tsoaNwkou12yJtcbdHygEC2cON+tUkKOd0eAvQbTM8Y=;
        b=h1piht5ADa9kurqOBLZy9wLf//VVCo3+Qmolxok3m0gVkyfh9o6i0SLc2kWVBF5eRhsmrT
        FC+YcwwMkuBb+uIfCNXt7VD5hx7X2/3uYOUirJHJSiUzF6zrqrGHFsn27tcZG2hU3+IVlT
        U5owdJsRFvZQpyVBjU3CQIe+6C9HkaI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-322-gWdGzFAUOve4K0g8Ui89jA-1; Wed, 02 Mar 2022 07:13:31 -0500
X-MC-Unique: gWdGzFAUOve4K0g8Ui89jA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8C348835DE1;
        Wed,  2 Mar 2022 12:13:30 +0000 (UTC)
Received: from lxbceph1.gsslab.pek2.redhat.com (unknown [10.72.47.117])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C6071781F1;
        Wed,  2 Mar 2022 12:13:28 +0000 (UTC)
From:   xiubli@redhat.com
To:     jlayton@kernel.org
Cc:     idryomov@gmail.com, vshankar@redhat.com,
        ceph-devel@vger.kernel.org, Xiubo Li <xiubli@redhat.com>
Subject: [PATCH v3 0/6] ceph: encrypt the snapshot directories
Date:   Wed,  2 Mar 2022 20:13:17 +0800
Message-Id: <20220302121323.240432-1-xiubli@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: Xiubo Li <xiubli@redhat.com>

This patch series is base on the 'wip-fscrypt' branch in ceph-client.

V3:
- Add more detail comments in the commit comments and code comments.
- Fix some bugs.
- Improved the patches.
- Remove the already merged patch.

V2:
- Fix several bugs, such as for the long snap name encrypt/dencrypt
- Skip double dencypting dentry names for readdir

======

NOTE: This patch series won't fix the long snap shot issue as Luis
is working on that.

Xiubo Li (6):
  ceph: fail the request when failing to decode dentry names
  ceph: do not dencrypt the dentry name twice for readdir
  ceph: add ceph_get_snap_parent_inode() support
  ceph: use the parent inode of '.snap' to dencrypt the names for
    readdir
  ceph: use the parent inode of '.snap' to encrypt name to build path
  ceph: try to encrypt/decrypt long snap name

 fs/ceph/crypto.c     |  95 ++++++++++++++++++++++++++++++++---
 fs/ceph/crypto.h     |  10 +++-
 fs/ceph/dir.c        |  98 ++++++++++++++++++++++--------------
 fs/ceph/inode.c      | 115 ++++++++++++++++++++++++++++++++++++++-----
 fs/ceph/mds_client.c |  57 +++++++++++++--------
 fs/ceph/mds_client.h |   3 ++
 fs/ceph/snap.c       |  24 +++++++++
 fs/ceph/super.h      |   2 +
 8 files changed, 327 insertions(+), 77 deletions(-)

-- 
2.27.0

