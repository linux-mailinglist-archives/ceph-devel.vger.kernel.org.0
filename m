Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5784551DA91
	for <lists+ceph-devel@lfdr.de>; Fri,  6 May 2022 16:31:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381698AbiEFOep (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 6 May 2022 10:34:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1442207AbiEFOen (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Fri, 6 May 2022 10:34:43 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 4FF7E57B18
        for <ceph-devel@vger.kernel.org>; Fri,  6 May 2022 07:31:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1651847459;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=35d71WxjiyMyDAkHFKcyacGBNaxYJKFHtRIiJzfFcZg=;
        b=ao0GywpW4QXme/ji8aKKVRqwZRDcN3WkQfbp5rTIR2x0HzJ7OQhBdtYBu3fq/3TFd8KL1v
        age/VhLzIN8O94w0Nr9gecKIds3c7+J2Uq3ZMammZh3UdN3QQU1jJyfTzTAqSVhA2VDH7d
        zFYNv6pJFKY33+JhMf9IUWbs62525C4=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-220-o-8kv5x6PEyoKvLPmqDVaQ-1; Fri, 06 May 2022 10:30:57 -0400
X-MC-Unique: o-8kv5x6PEyoKvLPmqDVaQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 81B1A1014A64;
        Fri,  6 May 2022 14:30:56 +0000 (UTC)
Received: from localhost (unknown [10.72.47.117])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3781240D2830;
        Fri,  6 May 2022 14:30:54 +0000 (UTC)
From:   Xiubo Li <xiubli@redhat.com>
To:     jlayton@kernel.org
Cc:     idryomov@gmail.com, vshankar@redhat.com,
        ceph-devel@vger.kernel.org, Xiubo Li <xiubli@redhat.com>
Subject: [PATCH v2] ceph: always try to uninline inline data when opening files
Date:   Fri,  6 May 2022 22:30:52 +0800
Message-Id: <20220506143052.479799-1-xiubli@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

This will help reduce possible deadlock while holding Fcr to use
getattr for read case.

Usually we shouldn't use getattr to fetch inline data after getting
Fcr caps, because it can cause deadlock. The solution is try uniline
the inline data when opening files, thanks David Howells' previous
work on uninlining the inline data work.

It was caused from one possible call path:
  ceph_filemap_fault()-->
     ceph_get_caps(Fcr);
     filemap_fault()-->
        do_sync_mmap_readahead()-->
           page_cache_ra_order()-->
              read_pages()-->
                 aops->readahead()-->
                    netfs_readahead()-->
                       netfs_begin_read()-->
                          netfs_rreq_submit_slice()-->
                             netfs_read_from_server()-->
                                netfs_ops->issue_read()-->
                                   ceph_netfs_issue_read()-->
                                      ceph_netfs_issue_op_inline()-->
                                         getattr()
      ceph_pu_caps_ref(Fcr);

This because if the Locker state is LOCK_EXEC_MIX for auth MDS, and
the replica MDSes' lock state is LOCK_LOCK. Then the kclient could
get 'Frwcb' caps from both auth and replica MDSes.

But if the getattr is sent to any MDS, the MDS needs to do Locker
transition to LOCK_MIX first and then to LOCK_SYNC. But when
transfering to LOCK_MIX state the MDS Locker need to revoke the Fcb
caps back, but the kclient already holding it and waiting the MDS
to finish.

Signed-off-by: Xiubo Li <xiubli@redhat.com>
---
 fs/ceph/file.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/fs/ceph/file.c b/fs/ceph/file.c
index 8c8226c0feac..09327ef5a26d 100644
--- a/fs/ceph/file.c
+++ b/fs/ceph/file.c
@@ -241,11 +241,12 @@ static int ceph_init_file_info(struct inode *inode, struct file *file,
 	INIT_LIST_HEAD(&fi->rw_contexts);
 	fi->filp_gen = READ_ONCE(ceph_inode_to_client(inode)->filp_gen);
 
-	if ((file->f_mode & FMODE_WRITE) &&
-	    ci->i_inline_version != CEPH_INLINE_NONE) {
-		ret = ceph_uninline_data(file);
-		if (ret < 0)
-			goto error;
+	if (ci->i_inline_version != CEPH_INLINE_NONE) {
+		if (!ceph_pool_perm_check(inode, CEPH_CAP_FILE_WR)) {
+			ret = ceph_uninline_data(file);
+			if (ret < 0)
+				goto error;
+		}
 	}
 
 	return 0;
-- 
2.36.0.rc1

