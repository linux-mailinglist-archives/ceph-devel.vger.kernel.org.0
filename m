Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 029896A39AF
	for <lists+ceph-devel@lfdr.de>; Mon, 27 Feb 2023 04:32:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230382AbjB0Dcy (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Sun, 26 Feb 2023 22:32:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230303AbjB0Dcx (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Sun, 26 Feb 2023 22:32:53 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF2791CADA
        for <ceph-devel@vger.kernel.org>; Sun, 26 Feb 2023 19:31:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1677468680;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Jx5vMmOdOkRjMPE1KNJOjDLCXnC/0phsEJ7HuO2RSGU=;
        b=bEe32vLoFINPf2ba6IX8uWCcPLOIXJlpj3QK6zHOVRfyAb0AIWOHW0L7f9pJMlS7b/LM21
        uFby8rMfCgWqn8XjGTHRjCCVakDCRy10K0kB8ntYdyI5BnTy0NalzfhoMPHRjKx74Cd7jc
        /xFnhZVUf3vX8I62/z30ibfkZpdsopI=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-130-V88X3q1_NxCJT_p3urwbdw-1; Sun, 26 Feb 2023 22:31:18 -0500
X-MC-Unique: V88X3q1_NxCJT_p3urwbdw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5C4491C04B6A;
        Mon, 27 Feb 2023 03:31:18 +0000 (UTC)
Received: from lxbceph1.gsslab.pek2.redhat.com (unknown [10.72.47.117])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8E9251731B;
        Mon, 27 Feb 2023 03:31:15 +0000 (UTC)
From:   xiubli@redhat.com
To:     idryomov@gmail.com, ceph-devel@vger.kernel.org
Cc:     jlayton@kernel.org, lhenriques@suse.de, vshankar@redhat.com,
        mchangir@redhat.com, Xiubo Li <xiubli@redhat.com>
Subject: [PATCH v16 51/68] ceph: disable fallocate for encrypted inodes
Date:   Mon, 27 Feb 2023 11:27:56 +0800
Message-Id: <20230227032813.337906-52-xiubli@redhat.com>
In-Reply-To: <20230227032813.337906-1-xiubli@redhat.com>
References: <20230227032813.337906-1-xiubli@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: Jeff Layton <jlayton@kernel.org>

...hopefully, just for now.

Reviewed-by: Xiubo Li <xiubli@redhat.com>
Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/ceph/file.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/ceph/file.c b/fs/ceph/file.c
index 0b1206eeb3b1..a9d4e4492420 100644
--- a/fs/ceph/file.c
+++ b/fs/ceph/file.c
@@ -2199,6 +2199,9 @@ static long ceph_fallocate(struct file *file, int mode,
 	if (!S_ISREG(inode->i_mode))
 		return -EOPNOTSUPP;
 
+	if (IS_ENCRYPTED(inode))
+		return -EOPNOTSUPP;
+
 	prealloc_cf = ceph_alloc_cap_flush();
 	if (!prealloc_cf)
 		return -ENOMEM;
-- 
2.31.1

