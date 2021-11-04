Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B51F0444E7A
	for <lists+ceph-devel@lfdr.de>; Thu,  4 Nov 2021 06:53:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230229AbhKDFz5 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 4 Nov 2021 01:55:57 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:33769 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230011AbhKDFz5 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 4 Nov 2021 01:55:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1636005199;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=vELb+JEAY9cEzSy2zTXSaJvHORPjV8CbKmqNyInETgY=;
        b=cPngqEYZrioJv/iw4ivgaFe5dYJct5lUbPDvvW5WfqE5VX3R8eZ1gCuOuSz/cBEVhxD/Pe
        ZKaTUES2TvVtGyMhdRqW4RGuYQSLsK8gld0O7dCayQeMt/vGQs5hdztCaEdQZFGa4Ggexz
        bYp+eQtM1kfTss2gdAROkCmfH6k0erA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-13-L3lwaH6zPSuRbZZdk8AMZg-1; Thu, 04 Nov 2021 01:53:15 -0400
X-MC-Unique: L3lwaH6zPSuRbZZdk8AMZg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9CCFC19200C2;
        Thu,  4 Nov 2021 05:53:14 +0000 (UTC)
Received: from lxbceph1.gsslab.pek2.redhat.com (unknown [10.72.47.117])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6FFCB2B399;
        Thu,  4 Nov 2021 05:53:06 +0000 (UTC)
From:   xiubli@redhat.com
To:     jlayton@kernel.org
Cc:     idryomov@gmail.com, vshankar@redhat.com, pdonnell@redhat.com,
        khiremat@redhat.com, ceph-devel@vger.kernel.org,
        Xiubo Li <xiubli@redhat.com>
Subject: [PATCH v6 0/9] ceph: size handling for the fscrypt
Date:   Thu,  4 Nov 2021 13:52:39 +0800
Message-Id: <20211104055248.190987-1-xiubli@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: Xiubo Li <xiubli@redhat.com>

This patch series is based on the "wip-fscrypt-fnames" branch in
repo https://github.com/ceph/ceph-client.git.

And I have picked up 5 patches from the "ceph-fscrypt-size-experimental"
branch in repo
https://git.kernel.org/pub/scm/linux/kernel/git/jlayton/linux.git.

====

This approach is based on the discussion from V1 and V2, which will
pass the encrypted last block contents to MDS along with the truncate
request.

This will send the encrypted last block contents to MDS along with
the truncate request when truncating to a smaller size and at the
same time new size does not align to BLOCK SIZE.

The MDS side patch is raised in PR
https://github.com/ceph/ceph/pull/43588, which is also based Jeff's
previous great work in PR https://github.com/ceph/ceph/pull/41284.

The MDS will use the filer.write_trunc(), which could update and
truncate the file in one shot, instead of filer.truncate().

This just assume kclient won't support the inline data feature, which
will be remove soon, more detail please see:
https://tracker.ceph.com/issues/52916


Changed in V6:
- Fixed the file hole bug, also have updated the MDS side PR.
- Add add object version support for sync read in #8.


Changed in V5:
- Rebase to "wip-fscrypt-fnames" branch in ceph-client.git repo.
- Pick up 5 patches from Jeff's "ceph-fscrypt-size-experimental" branch
  in linux.git repo.
- Add "i_truncate_pagecache_size" member support in ceph_inode_info
  struct, this will be used to truncate the pagecache only in kclient
  side, because the "i_truncate_size" will always be aligned to BLOCK
  SIZE. In fscrypt case we need to use the real size to truncate the
  pagecache.


Changed in V4:
- Retry the truncate request by 20 times before fail it with -EAGAIN.
- Remove the "fill_last_block" label and move the code to else branch.
- Remove the #3 patch, which has already been sent out separately, in
  V3 series.
- Improve some comments in the code.


Changed in V3:
- Fix possibly corrupting the file just before the MDS acquires the
  xlock for FILE lock, another client has updated it.
- Flush the pagecache buffer before reading the last block for the
  when filling the truncate request.
- Some other minore fixes.



Jeff Layton (5):
  libceph: add CEPH_OSD_OP_ASSERT_VER support
  ceph: size handling for encrypted inodes in cap updates
  ceph: fscrypt_file field handling in MClientRequest messages
  ceph: get file size from fscrypt_file when present in inode traces
  ceph: handle fscrypt fields in cap messages from MDS

Xiubo Li (4):
  ceph: add __ceph_get_caps helper support
  ceph: add __ceph_sync_read helper support
  ceph: add object version support for sync read
  ceph: add truncate size handling support for fscrypt

 fs/ceph/caps.c                  | 136 ++++++++++++++----
 fs/ceph/crypto.h                |   4 +
 fs/ceph/dir.c                   |   3 +
 fs/ceph/file.c                  |  76 ++++++++--
 fs/ceph/inode.c                 | 243 +++++++++++++++++++++++++++++---
 fs/ceph/mds_client.c            |   9 +-
 fs/ceph/mds_client.h            |   2 +
 fs/ceph/super.h                 |  25 ++++
 include/linux/ceph/crypto.h     |  28 ++++
 include/linux/ceph/osd_client.h |   6 +-
 include/linux/ceph/rados.h      |   4 +
 net/ceph/osd_client.c           |   5 +
 12 files changed, 482 insertions(+), 59 deletions(-)
 create mode 100644 include/linux/ceph/crypto.h

-- 
2.27.0

