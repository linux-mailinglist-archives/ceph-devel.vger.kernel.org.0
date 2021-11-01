Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 67BBA441209
	for <lists+ceph-devel@lfdr.de>; Mon,  1 Nov 2021 03:05:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230393AbhKACHc (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Sun, 31 Oct 2021 22:07:32 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:49629 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230337AbhKACH2 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Sun, 31 Oct 2021 22:07:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1635732295;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=Lha4Dk3BKjghL3zuxkn9XNp9+K1QbTbKD8BMbXvdzis=;
        b=E6hbq5Vh+l90qKi4WY+Fx8CHC4FnEzq9LEjq+hql1vL5dvQ9CTm0Sz9LaScDl0FcNLng1G
        9Krx5EwonIAF0PWVsaeMut0I/qmpL5PLw8kmu1ux5bWBq/CMVDlYYsNv9PYjLRpTLDogMn
        1+BoW2TwBWuYVvCHf9ifxgJtdYi42Uo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-429-RzJFm19gMXWLdiKGXk5p5w-1; Sun, 31 Oct 2021 22:04:53 -0400
X-MC-Unique: RzJFm19gMXWLdiKGXk5p5w-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9DFDF1882FA3;
        Mon,  1 Nov 2021 02:04:52 +0000 (UTC)
Received: from lxbceph1.gsslab.pek2.redhat.com (unknown [10.72.47.117])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 41C9A5D6CF;
        Mon,  1 Nov 2021 02:04:49 +0000 (UTC)
From:   xiubli@redhat.com
To:     jlayton@kernel.org
Cc:     idryomov@gmail.com, vshankar@redhat.com, pdonnell@redhat.com,
        khiremat@redhat.com, ceph-devel@vger.kernel.org,
        Xiubo Li <xiubli@redhat.com>
Subject: [PATCH v4 0/4] ceph: size handling for the fscrypt
Date:   Mon,  1 Nov 2021 10:04:43 +0800
Message-Id: <20211101020447.75872-1-xiubli@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: Xiubo Li <xiubli@redhat.com>

This patch series is based on the "fscrypt_size_handling" branch in
https://github.com/lxbsz/linux.git, which is based Jeff's
"ceph-fscrypt-content-experimental" branch in
https://git.kernel.org/pub/scm/linux/kernel/git/jlayton/linux.git
and added two upstream commits, which should be merged already.

These two upstream commits should be removed after Jeff rebase
his "ceph-fscrypt-content-experimental" branch to upstream code.

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

Xiubo Li (4):
  Revert "ceph: make client zero partial trailing block on truncate"
  ceph: add __ceph_get_caps helper support
  ceph: add __ceph_sync_read helper support
  ceph: add truncate size handling support for fscrypt

 fs/ceph/caps.c              |  21 ++--
 fs/ceph/file.c              |  44 +++++---
 fs/ceph/inode.c             | 203 ++++++++++++++++++++++++++++++------
 fs/ceph/super.h             |   6 +-
 include/linux/ceph/crypto.h |  28 +++++
 5 files changed, 251 insertions(+), 51 deletions(-)
 create mode 100644 include/linux/ceph/crypto.h

-- 
2.27.0

