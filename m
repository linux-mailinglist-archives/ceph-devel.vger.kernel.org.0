Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E09813FFBA7
	for <lists+ceph-devel@lfdr.de>; Fri,  3 Sep 2021 10:17:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348170AbhICIRm (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 3 Sep 2021 04:17:42 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:29485 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1347810AbhICIRl (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Fri, 3 Sep 2021 04:17:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1630657002;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=DCzQ/edxY4mMZb8Jwg/Xne+OzLQtUeZmAPS7KNKGKqo=;
        b=M+9D6D1zHbC6bMqR5ZeOcBozFD9yFgVVmLqhmn/nrpppT9aIQwV+z9yA4zbQEyLrcpHor4
        lE580lSsKd3LA2YWR5DSh5/JvNlzSxRNdTRrQt72RYU0pqwjO/hm40fHk9OTVrqQreHRaV
        yIaGd5yeKB+4PfFOrqEFCWzNXT9znjM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-439-4GuLb1NZOUSPPb_DVaQoGg-1; Fri, 03 Sep 2021 04:16:38 -0400
X-MC-Unique: 4GuLb1NZOUSPPb_DVaQoGg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 314721854E20;
        Fri,  3 Sep 2021 08:16:37 +0000 (UTC)
Received: from lxbceph1.gsslab.pek2.redhat.com (unknown [10.72.47.117])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0D6516A8F8;
        Fri,  3 Sep 2021 08:16:34 +0000 (UTC)
From:   xiubli@redhat.com
To:     jlayton@kernel.org
Cc:     idryomov@gmail.com, ukernel@gmail.com, pdonnell@redhat.com,
        ceph-devel@vger.kernel.org, Xiubo Li <xiubli@redhat.com>
Subject: [PATCH RFC 0/2] ceph: size handling for the fscrypt
Date:   Fri,  3 Sep 2021 16:15:08 +0800
Message-Id: <20210903081510.982827-1-xiubli@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: Xiubo Li <xiubli@redhat.com>

This patch series is based Jeff's ceph-fscrypt-size-experimental
branch in https://git.kernel.org/pub/scm/linux/kernel/git/jlayton/linux.git.

This is just a draft patch and need to rebase or recode after Jeff
finished his huge patch set.

Post the patch out for advices and ideas. Thanks.

====

This approach will not do the rmw immediately after the file is
truncated. If the truncate size is aligned to the BLOCK SIZE, so
there no need to do the rmw and only in unaligned case will the
rmw is needed.

And the 'fscrypt_file' field will be cleared after the rmw is done.
If the 'fscrypt_file' is none zero that means after the kclient
reading that block to local buffer or pagecache it needs to do the
zeroing of that block in range of [fscrypt_file, round_up(fscrypt_file,
BLOCK SIZE)).

Once any kclient has dirty that block and write it back to ceph, the
'fscrypt_file' field will be cleared and set to 0. More detail please
see the commit comments in the second patch.

There also need on small work in Jeff's MDS PR in cap flushing code
to clear the 'fscrypt_file'.


Xiubo Li (2):
  Revert "ceph: make client zero partial trailing block on truncate"
  ceph: truncate the file contents when needed when file scrypted

 fs/ceph/addr.c  | 19 ++++++++++++++-
 fs/ceph/caps.c  | 24 ++++++++++++++++++
 fs/ceph/file.c  | 65 ++++++++++++++++++++++++++++++++++++++++++++++---
 fs/ceph/inode.c | 48 +++++++++++++++++++-----------------
 fs/ceph/super.h | 13 +++++++---
 5 files changed, 138 insertions(+), 31 deletions(-)

-- 
2.27.0

