Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C078D14E91F
	for <lists+ceph-devel@lfdr.de>; Fri, 31 Jan 2020 08:28:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728119AbgAaH2W (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 31 Jan 2020 02:28:22 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:58119 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728027AbgAaH2W (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Fri, 31 Jan 2020 02:28:22 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580455700;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=cONhPH/fZOeCUT79NZa5QDvKXWg0Y6YpjMI2zF704gI=;
        b=jOz2ZGhXn6v9UYq4EfOS1ZMND3bKQ35cfhictkxPa95GU/Y7+KDA1ccPxuRgYbV+M0Wh0Z
        +XX83jmv8j7vad5gEQ8gWU4b902YuggJlgIxEi94HnRvIrnCWIGGbAgSi3MYrevDgahiVj
        n6LgZ5P7lnoN5RahGoEadIxZk1fLdNY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-14-B1C0h5DPPsyJsszepfamSw-1; Fri, 31 Jan 2020 02:28:18 -0500
X-MC-Unique: B1C0h5DPPsyJsszepfamSw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id AFF268010C2;
        Fri, 31 Jan 2020 07:28:17 +0000 (UTC)
Received: from localhost.localdomain (ovpn-12-34.pek2.redhat.com [10.72.12.34])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6048D5D9E5;
        Fri, 31 Jan 2020 07:28:12 +0000 (UTC)
From:   xiubli@redhat.com
To:     jlayton@kernel.org, idryomov@gmail.com, zyan@redhat.com
Cc:     sage@redhat.com, pdonnell@redhat.com, ceph-devel@vger.kernel.org,
        Xiubo Li <xiubli@redhat.com>
Subject: [PATCH] ceph: fix the comment for ceph_start_io_direct
Date:   Fri, 31 Jan 2020 02:27:58 -0500
Message-Id: <20200131072758.7294-1-xiubli@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Content-Transfer-Encoding: quoted-printable
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: Xiubo Li <xiubli@redhat.com>

This maybe missed to change after copied from somewhere.

Signed-off-by: Xiubo Li <xiubli@redhat.com>
---
 fs/ceph/io.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ceph/io.c b/fs/ceph/io.c
index 97602ea92ff4..c456509b31c3 100644
--- a/fs/ceph/io.c
+++ b/fs/ceph/io.c
@@ -118,7 +118,7 @@ static void ceph_block_buffered(struct ceph_inode_inf=
o *ci, struct inode *inode)
 }
=20
 /**
- * ceph_end_io_direct - declare the file is being used for direct i/o
+ * ceph_start_io_direct - declare the file is being used for direct i/o
  * @inode: file inode
  *
  * Declare that a direct I/O operation is about to start, and ensure
--=20
2.21.0

