Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6BFE1452DCC
	for <lists+ceph-devel@lfdr.de>; Tue, 16 Nov 2021 10:20:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233056AbhKPJX0 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 16 Nov 2021 04:23:26 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:32662 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233011AbhKPJXN (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Tue, 16 Nov 2021 04:23:13 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1637054416;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=QypVowVRmkyAucYW4FnhSJMego1MuDGa2v5SjKLJ+4s=;
        b=Wc0pPIRuUDnB3nJ4hNYyHtriQU+u4OuLXAy7gFokElRaoV6E0lgs8DkouN20p+YTK+/r+Y
        c/wPgajdyqK4o7tisJG83jIWhhhowRzfzncPTHBEHPqrucn7qxNHepCzUFW7tfilAEAk/S
        pbn3lukD0z0yxIDj4Q87wpLaQcBfpOs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-267-SdtaaOCyM8Wy_bW9jFcRUg-1; Tue, 16 Nov 2021 04:20:14 -0500
X-MC-Unique: SdtaaOCyM8Wy_bW9jFcRUg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 29AA1100C61C;
        Tue, 16 Nov 2021 09:20:13 +0000 (UTC)
Received: from lxbceph1.gsslab.pek2.redhat.com (unknown [10.72.47.117])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 47228100EBAD;
        Tue, 16 Nov 2021 09:20:11 +0000 (UTC)
From:   xiubli@redhat.com
To:     jlayton@kernel.org
Cc:     idryomov@gmail.com, vshankar@redhat.com,
        ceph-devel@vger.kernel.org, Xiubo Li <xiubli@redhat.com>
Subject: [PATCH] ceph: do not truncate pagecache if truncate size doesn't change
Date:   Tue, 16 Nov 2021 17:20:02 +0800
Message-Id: <20211116092002.99439-1-xiubli@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: Xiubo Li <xiubli@redhat.com>

In case truncating a file to a smaller sizeA, the sizeA will be kept
in truncate_size. And if truncate the file to a bigger sizeB, the
MDS will only increase the truncate_seq, but still using the sizeA as
the truncate_size.

So when filling the inode it will truncate the pagecache by using
truncate_sizeA again, which makes no sense and will trim the inocent
pages.

Signed-off-by: Xiubo Li <xiubli@redhat.com>
---
 fs/ceph/inode.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
index 1b4ce453d397..b4f784684e64 100644
--- a/fs/ceph/inode.c
+++ b/fs/ceph/inode.c
@@ -738,10 +738,11 @@ int ceph_fill_file_size(struct inode *inode, int issued,
 			 * don't hold those caps, then we need to check whether
 			 * the file is either opened or mmaped
 			 */
-			if ((issued & (CEPH_CAP_FILE_CACHE|
+			if (ci->i_truncate_size != truncate_size &&
+			    ((issued & (CEPH_CAP_FILE_CACHE|
 				       CEPH_CAP_FILE_BUFFER)) ||
 			    mapping_mapped(inode->i_mapping) ||
-			    __ceph_is_file_opened(ci)) {
+			    __ceph_is_file_opened(ci))) {
 				ci->i_truncate_pending++;
 				queue_trunc = 1;
 			}
-- 
2.27.0

