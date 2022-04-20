Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E94A7508090
	for <lists+ceph-devel@lfdr.de>; Wed, 20 Apr 2022 07:24:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238846AbiDTF1C (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 20 Apr 2022 01:27:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233203AbiDTF1B (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 20 Apr 2022 01:27:01 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 8F37C36B57
        for <ceph-devel@vger.kernel.org>; Tue, 19 Apr 2022 22:24:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1650432253;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=96cBlpvVJxEHqLiy0/ZuThs+8FJX6t1c8zS6QgZU7Fs=;
        b=QsjXAwa2t81TyHuAPdDAzUObiz8wMNpMeY4eBbSsQdgA9ZtBB+TDCB1f3aGOEAjgSNbhJz
        6AsSyoz91yL90XOJJQfW8OiwvNlJveT6ndWxalebnoY+e6hmetbXYIx/8J4Txs4ytt4Fss
        RjfgPTs//HLknrOrdJr/l09AVlosHnU=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-25-UpNij09JNXSKS47qPZACfQ-1; Wed, 20 Apr 2022 01:24:09 -0400
X-MC-Unique: UpNij09JNXSKS47qPZACfQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0BB33811E76;
        Wed, 20 Apr 2022 05:24:09 +0000 (UTC)
Received: from localhost (unknown [10.72.47.117])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 605621006109;
        Wed, 20 Apr 2022 05:24:08 +0000 (UTC)
From:   Xiubo Li <xiubli@redhat.com>
To:     jlayton@kernel.org
Cc:     idryomov@gmail.com, vshankar@redhat.com,
        ceph-devel@vger.kernel.org, Xiubo Li <xiubli@redhat.com>
Subject: [RFC PATCH] ceph: disable updating the atime since cephfs won't maintain it
Date:   Wed, 20 Apr 2022 13:24:03 +0800
Message-Id: <20220420052404.1144209-1-xiubli@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Since the cephFS makes no attempt to maintain atime, we shouldn't
try to update it in mmap and generic read cases and ignore updating
it in direct and sync read cases.

And even we update it in mmap and generic read cases we will drop
it and won't sync it to MDS. And we are seeing the atime will be
updated and then dropped to the floor again and again.

URL: https://lists.ceph.io/hyperkitty/list/ceph-users@ceph.io/thread/VSJM7T4CS5TDRFF6XFPIYMHP75K73PZ6/
Signed-off-by: Xiubo Li <xiubli@redhat.com>
---
 fs/ceph/addr.c  | 1 -
 fs/ceph/super.c | 1 +
 2 files changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
index aa25bffd4823..02722ac86d73 100644
--- a/fs/ceph/addr.c
+++ b/fs/ceph/addr.c
@@ -1774,7 +1774,6 @@ int ceph_mmap(struct file *file, struct vm_area_struct *vma)
 
 	if (!mapping->a_ops->readpage)
 		return -ENOEXEC;
-	file_accessed(file);
 	vma->vm_ops = &ceph_vmops;
 	return 0;
 }
diff --git a/fs/ceph/super.c b/fs/ceph/super.c
index e6987d295079..b73b4f75462c 100644
--- a/fs/ceph/super.c
+++ b/fs/ceph/super.c
@@ -1119,6 +1119,7 @@ static int ceph_set_super(struct super_block *s, struct fs_context *fc)
 	s->s_time_gran = 1;
 	s->s_time_min = 0;
 	s->s_time_max = U32_MAX;
+	s->s_flags |= SB_NODIRATIME | SB_NOATIME;
 
 	ret = set_anon_super_fc(s, fc);
 	if (ret != 0)
-- 
2.36.0.rc1

