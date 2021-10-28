Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D988043DD88
	for <lists+ceph-devel@lfdr.de>; Thu, 28 Oct 2021 11:14:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230088AbhJ1JRW (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 28 Oct 2021 05:17:22 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:54041 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230057AbhJ1JRV (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Thu, 28 Oct 2021 05:17:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1635412494;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=sa5A8Rg612mKs9FiBwuYX1h1euL/1tiidCsVTOeDTc4=;
        b=KYX+yzqLSnktlMyXv8XznU55o4cNEC/KYPn8wZ5SwC2TLSR+GNjvqRJFmt1KOd9M2fHYvQ
        Fasu4ToSq+VrGoI5cGh0WbB1GfFxDvcods4nX68NLCpxEDRz5y660Cl5UEYPvhiojOw/JD
        1yJrLWzUS6dymp53xP6EZEwfLh+vNHc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-186-ebCSl_jAMHCjkQ2mp7j4zg-1; Thu, 28 Oct 2021 05:14:51 -0400
X-MC-Unique: ebCSl_jAMHCjkQ2mp7j4zg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 88971101F000;
        Thu, 28 Oct 2021 09:14:50 +0000 (UTC)
Received: from lxbceph1.gsslab.pek2.redhat.com (unknown [10.72.47.117])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2CC975F4EA;
        Thu, 28 Oct 2021 09:14:47 +0000 (UTC)
From:   xiubli@redhat.com
To:     jlayton@kernel.org
Cc:     idryomov@gmail.com, vshankar@redhat.com, pdonnell@redhat.com,
        khiremat@redhat.com, ceph-devel@vger.kernel.org,
        Xiubo Li <xiubli@redhat.com>
Subject: [PATCH v3 0/4] ceph: size handling for the fscrypt
Date:   Thu, 28 Oct 2021 17:14:34 +0800
Message-Id: <20211028091438.21402-1-xiubli@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
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

