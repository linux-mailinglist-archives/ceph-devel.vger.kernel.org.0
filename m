Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C0BE96DF2D7
	for <lists+ceph-devel@lfdr.de>; Wed, 12 Apr 2023 13:15:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229700AbjDLLO6 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 12 Apr 2023 07:14:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229940AbjDLLO4 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 12 Apr 2023 07:14:56 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B00E7B7
        for <ceph-devel@vger.kernel.org>; Wed, 12 Apr 2023 04:13:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1681297969;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=0kYCJF9DGGtp4ZqNQo6CgNdWCJ4wx95TuHBVUhFXafg=;
        b=XChlid5gBfRmOt60ugqhmXPePckEJh2Q4pNAZiHcUzN2VjyWpwi5E+HmdBNP8FK5ZV7SYE
        N/yscKAeljl2Gqu5oZp6n14jAY9eDbsML9arZ8P668lRlLE608sqL2v269F8twP3Cg4cxX
        7rNnelAkoogYr9FxhqDdMZqbYFyY/fI=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-625-VQpY8KJ-NnyGs6LP-l8Olw-1; Wed, 12 Apr 2023 07:12:46 -0400
X-MC-Unique: VQpY8KJ-NnyGs6LP-l8Olw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7774A811E7C;
        Wed, 12 Apr 2023 11:12:45 +0000 (UTC)
Received: from li-a71a4dcc-35d1-11b2-a85c-951838863c8d.ibm.com.com (ovpn-12-131.pek2.redhat.com [10.72.12.131])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C7B13C15BB8;
        Wed, 12 Apr 2023 11:12:40 +0000 (UTC)
From:   xiubli@redhat.com
To:     idryomov@gmail.com, ceph-devel@vger.kernel.org
Cc:     jlayton@kernel.org, vshankar@redhat.com, mchangir@redhat.com,
        lhenriques@suse.de, Xiubo Li <xiubli@redhat.com>
Subject: [PATCH v18 36/71] ceph: allow encrypting a directory while not having Ax caps
Date:   Wed, 12 Apr 2023 19:08:55 +0800
Message-Id: <20230412110930.176835-37-xiubli@redhat.com>
In-Reply-To: <20230412110930.176835-1-xiubli@redhat.com>
References: <20230412110930.176835-1-xiubli@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: Luís Henriques <lhenriques@suse.de>

If a client doesn't have Fx caps on a directory, it will get errors while
trying encrypt it:

ceph: handle_cap_grant: cap grant attempt to change fscrypt_auth on non-I_NEW inode (old len 0 new len 48)
fscrypt (ceph, inode 1099511627812): Error -105 getting encryption context

A simple way to reproduce this is to use two clients:

    client1 # mkdir /mnt/mydir

    client2 # ls /mnt/mydir

    client1 # fscrypt encrypt /mnt/mydir
    client1 # echo hello > /mnt/mydir/world

This happens because, in __ceph_setattr(), we only initialize
ci->fscrypt_auth if we have Ax and ceph_fill_inode() won't use the
fscrypt_auth received if the inode state isn't I_NEW.  Fix it by allowing
ceph_fill_inode() to also set ci->fscrypt_auth if the inode doesn't have
it set already.

Tested-by: Luís Henriques <lhenriques@suse.de>
Tested-by: Venky Shankar <vshankar@redhat.com>
Signed-off-by: Luís Henriques <lhenriques@suse.de>
Signed-off-by: Xiubo Li <xiubli@redhat.com>
---
 fs/ceph/inode.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
index 282c8af0a49c..e88335e05b74 100644
--- a/fs/ceph/inode.c
+++ b/fs/ceph/inode.c
@@ -981,7 +981,8 @@ int ceph_fill_inode(struct inode *inode, struct page *locked_page,
 	__ceph_update_quota(ci, iinfo->max_bytes, iinfo->max_files);
 
 #ifdef CONFIG_FS_ENCRYPTION
-	if (iinfo->fscrypt_auth_len && (inode->i_state & I_NEW)) {
+	if (iinfo->fscrypt_auth_len &&
+	    ((inode->i_state & I_NEW) || (ci->fscrypt_auth_len == 0))) {
 		kfree(ci->fscrypt_auth);
 		ci->fscrypt_auth_len = iinfo->fscrypt_auth_len;
 		ci->fscrypt_auth = iinfo->fscrypt_auth;
-- 
2.39.2

