Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DBDAB6C6034
	for <lists+ceph-devel@lfdr.de>; Thu, 23 Mar 2023 07:59:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230320AbjCWG7J (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 23 Mar 2023 02:59:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230318AbjCWG7F (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 23 Mar 2023 02:59:05 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21CEB6192
        for <ceph-devel@vger.kernel.org>; Wed, 22 Mar 2023 23:57:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1679554670;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Tz7+OdyKe1VwKYb4OXcr4LCJtqf+7Kk4sqL3p/DjlSc=;
        b=I2mp24sk8/XfpRKCTl0zRTRpzKmVzNE8NESTEDaaFHx/Q3jOMXH/EkZvJq8nhSy062jt0G
        +j+i1O85ymkyQM/d4SuUbBzNsIyYi1fsSC0oc++EkZ8GrV6cDX4pLMxNkS0XYN2P/mn/D0
        BMBec+6qWoji+XIzzwbMTwAIT0HUfA8=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-433-sdb4Y60SPOmzCfg_2gNOHw-1; Thu, 23 Mar 2023 02:57:43 -0400
X-MC-Unique: sdb4Y60SPOmzCfg_2gNOHw-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id DD8853814952;
        Thu, 23 Mar 2023 06:57:42 +0000 (UTC)
Received: from lxbceph1.gsslab.pek2.redhat.com (unknown [10.72.47.117])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1D336492B03;
        Thu, 23 Mar 2023 06:57:39 +0000 (UTC)
From:   xiubli@redhat.com
To:     idryomov@gmail.com, ceph-devel@vger.kernel.org
Cc:     jlayton@kernel.org, vshankar@redhat.com, mchangir@redhat.com,
        lhenriques@suse.de, Xiubo Li <xiubli@redhat.com>
Subject: [PATCH v17 36/71] ceph: allow encrypting a directory while not having Ax caps
Date:   Thu, 23 Mar 2023 14:54:50 +0800
Message-Id: <20230323065525.201322-37-xiubli@redhat.com>
In-Reply-To: <20230323065525.201322-1-xiubli@redhat.com>
References: <20230323065525.201322-1-xiubli@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
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
2.31.1

