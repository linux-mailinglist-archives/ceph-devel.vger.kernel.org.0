Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 213A743DDA4
	for <lists+ceph-devel@lfdr.de>; Thu, 28 Oct 2021 11:21:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229877AbhJ1JYP (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 28 Oct 2021 05:24:15 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:29255 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229835AbhJ1JYO (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Thu, 28 Oct 2021 05:24:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1635412907;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=sa5A8Rg612mKs9FiBwuYX1h1euL/1tiidCsVTOeDTc4=;
        b=g0NQ4+8EEhrYuRcvI+DegCZkgTfnKO3QUL/y3+glzt4bhwRoSM4IhmtWx/8s/AJ4WhWZNk
        xb2Vdl/NCx+DLO5n1gNfObfRtkzhuTvvhLvi9ryjXi6G8StZ5X9BmPbCR4sXEYpoBLnyqk
        nojaDQtq23whNZKCYD/sp6iV5TOJTZQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-216-eFvOmIUyPX6JvajMSf7ALQ-1; Thu, 28 Oct 2021 05:21:44 -0400
X-MC-Unique: eFvOmIUyPX6JvajMSf7ALQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8F305802B7A;
        Thu, 28 Oct 2021 09:21:43 +0000 (UTC)
Received: from lxbceph1.gsslab.pek2.redhat.com (unknown [10.72.47.117])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3F3B660CC4;
        Thu, 28 Oct 2021 09:21:36 +0000 (UTC)
From:   xiubli@redhat.com
To:     jlayton@kernel.org
Cc:     idryomov@gmail.com, vshankar@redhat.com, pdonnell@redhat.com,
        khiremat@redhat.com, ceph-devel@vger.kernel.org,
        Xiubo Li <xiubli@redhat.com>
Subject: [PATCH v3 0/4] ceph: size handling for the fscrypt
Date:   Thu, 28 Oct 2021 17:21:35 +0800
Message-Id: <20211028092135.21668-1-xiubli@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: Xiubo Li <xiubli@redhat.com>

This patch series is based on the fscrypt_size_handling branch in
https://github.com/lxbsz/linux.git, which is based Jeff's
ceph-fscrypt-content-experimental branch in
https://git.kernel.org/pub/scm/linux/kernel/git/jlayton/linux.git,
has reverted one useless commit and added some upstream commits.

I will keep this patch set as simple as possible to review since
this is still one framework code. It works and still in developing
and need some feedbacks and suggestions for two corner cases below.

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

Changed in V3:
- Fix possibly corrupting the file just before the MDS acquires the
  xlock for FILE lock, another client has updated it.
- Flush the pagecache buffer before reading the last block for the
  when filling the truncate request.
- Some other minore fixes.

Xiubo Li (4):
  ceph: add __ceph_get_caps helper support
  ceph: add __ceph_sync_read helper support
  ceph: return the real size readed when hit EOF
  ceph: add truncate size handling support for fscrypt

 fs/ceph/caps.c              |  21 +++--
 fs/ceph/file.c              |  47 +++++++---
 fs/ceph/inode.c             | 182 ++++++++++++++++++++++++++++++++++--
 fs/ceph/super.h             |   5 +
 include/linux/ceph/crypto.h |  23 +++++
 5 files changed, 247 insertions(+), 31 deletions(-)
 create mode 100644 include/linux/ceph/crypto.h

-- 
2.27.0

