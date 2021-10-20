Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F0DED434C0E
	for <lists+ceph-devel@lfdr.de>; Wed, 20 Oct 2021 15:28:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230049AbhJTNam (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 20 Oct 2021 09:30:42 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:27293 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230024AbhJTNam (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Wed, 20 Oct 2021 09:30:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1634736507;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=1tGIOGRuWBnpTf1oLH2oPNfMSQimS0BwhMnoesMahR4=;
        b=aD8UvbDNwKbWkBGXOJ3S1dPt4Rxzt4rrTOjhAaGhKEUzggCYU1pzauO0u9iWA/yzeoYaAi
        9jtU9EXg+lbkoY1r98FaZwkA4i3XfOyvnb40KvVEqli8ejBNpbqaqxlPN2G/Ajsel4Qkcu
        pY4d/4Gy2oU1jU6o5jdh+7Btp7CwlQA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-384-zHJQfC9jPWen2jbiw5xxwg-1; Wed, 20 Oct 2021 09:28:24 -0400
X-MC-Unique: zHJQfC9jPWen2jbiw5xxwg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1A378101F7A1;
        Wed, 20 Oct 2021 13:28:23 +0000 (UTC)
Received: from lxbceph1.gsslab.pek2.redhat.com (unknown [10.72.47.117])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9BA4A1042AEE;
        Wed, 20 Oct 2021 13:28:20 +0000 (UTC)
From:   xiubli@redhat.com
To:     jlayton@kernel.org
Cc:     idryomov@gmail.com, vshankar@redhat.com, khiremat@redhat.com,
        pdonnell@redhat.com, ceph-devel@vger.kernel.org,
        Xiubo Li <xiubli@redhat.com>
Subject: [PATCH v2 0/4] ceph: size handling for the fscrypt
Date:   Wed, 20 Oct 2021 21:28:09 +0800
Message-Id: <20211020132813.543695-1-xiubli@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
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

This approach is based on the discussion from V1, which will pass
the encrypted last block contents to MDS along with the truncate
request.

This will send the encrypted last block contents to MDS along with
the truncate request when truncating to a smaller size and at the
same time new size does not align to BLOCK SIZE.

The MDS side patch is raised in PR
https://github.com/ceph/ceph/pull/43588, which is also based Jeff's
previous great work in PR https://github.com/ceph/ceph/pull/41284.

The MDS will use the filer.write_trunc(), which could update and
truncate the file in one shot, instead of filer.truncate().

I have removed the inline data related code since we are remove
this feature, more detail please see:
https://tracker.ceph.com/issues/52916


Note: There still has two CORNER cases we need to deal with:

1), If a truncate request with the last block is sent to the MDS and
just before the MDS has acquired the xlock for FILE lock, if another
client has updated that last block content, we will over write the
last block with old data.

For this case we could send the old encrypted last block data along
with the truncate request and in MDS side read it and then do compare
just before updating it, if the comparasion fails, then fail the
truncate and let the kclient retry it.

2), If another client has buffered the last block, we should flush
it first. I am still thinking how to do this ? Any idea is welcome.

Thanks.


Xiubo Li (4):
  ceph: add __ceph_get_caps helper support
  ceph: add __ceph_sync_read helper support
  ceph: return the real size readed when hit EOF
  ceph: add truncate size handling support for fscrypt

 fs/ceph/caps.c  |  28 ++++---
 fs/ceph/file.c  |  41 ++++++----
 fs/ceph/inode.c | 210 ++++++++++++++++++++++++++++++++++++++++++------
 fs/ceph/super.h |   4 +
 4 files changed, 234 insertions(+), 49 deletions(-)

-- 
2.27.0

