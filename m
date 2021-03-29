Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 02D8A34C2BA
	for <lists+ceph-devel@lfdr.de>; Mon, 29 Mar 2021 07:00:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230338AbhC2E7s (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 29 Mar 2021 00:59:48 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:43425 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230337AbhC2E7T (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Mon, 29 Mar 2021 00:59:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1616993958;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=BuDAp41i8Eba6ajQ/bUIcPzwQ/eDaYGh1+/1/NKvMyg=;
        b=BBbCe9wVqsqKByjcRiRmdCT4nSlENZpOoSiYNxW0tVGp4FXmlB2/r+4b/dSeehcGKEa3oW
        ul2mgsag6G2YB/kK35Crr4Sc/Rt3a8YXu+T9YLVkq6ygS58V8bH1CdlY+Ql2/jfQJFlxDk
        0J791Rh4D4F5KApjgq8u19NR4sw2Ffc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-574-1MtpLShmPKSQnlRU98oGIg-1; Mon, 29 Mar 2021 00:59:14 -0400
X-MC-Unique: 1MtpLShmPKSQnlRU98oGIg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E8DBC80061;
        Mon, 29 Mar 2021 04:59:13 +0000 (UTC)
Received: from lxbceph1.gsslab.pek2.redhat.com (unknown [10.72.47.117])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0399F1037E81;
        Mon, 29 Mar 2021 04:59:11 +0000 (UTC)
From:   xiubli@redhat.com
To:     jlayton@kernel.org
Cc:     idryomov@gmail.com, pdonnell@redhat.com,
        ceph-devel@vger.kernel.org, Xiubo Li <xiubli@redhat.com>
Subject: [PATCH] ceph: fix a typo in comments
Date:   Mon, 29 Mar 2021 12:59:04 +0800
Message-Id: <20210329045904.135183-1-xiubli@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: Xiubo Li <xiubli@redhat.com>

Signed-off-by: Xiubo Li <xiubli@redhat.com>
---
 fs/ceph/addr.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
index 57c67180ce5c..5b66f17afe0c 100644
--- a/fs/ceph/addr.c
+++ b/fs/ceph/addr.c
@@ -1945,7 +1945,7 @@ int ceph_pool_perm_check(struct inode *inode, int need)
 	if (ci->i_vino.snap != CEPH_NOSNAP) {
 		/*
 		 * Pool permission check needs to write to the first object.
-		 * But for snapshot, head of the first object may have alread
+		 * But for snapshot, head of the first object may have already
 		 * been deleted. Skip check to avoid creating orphan object.
 		 */
 		return 0;
-- 
2.27.0

