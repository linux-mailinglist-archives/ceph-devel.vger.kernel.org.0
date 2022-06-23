Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B6733557725
	for <lists+ceph-devel@lfdr.de>; Thu, 23 Jun 2022 11:52:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231232AbiFWJwx (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 23 Jun 2022 05:52:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229811AbiFWJww (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 23 Jun 2022 05:52:52 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id E87D9B848
        for <ceph-devel@vger.kernel.org>; Thu, 23 Jun 2022 02:52:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1655977970;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=j9aDuA5k5z+apHFuZ9q4JnU/jFaZVavt3nOXObUu3V8=;
        b=V7RWehh27bQE/5g+bepH7iSoeP1qW5OZZj1B6PuXb+rBYGjQ4kijPPfFvfAvKpgYgdthEH
        6damBL8pFFnDNwI88MMXc9lb4G/sNOyXijin8AyWl/eETB0m4CgRcNrBNz9KiNUUaV5Gl1
        LoOL3sEn9x8/ekfYe4rQZFlWIZg/gRs=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-552-7fu2ASyuM4y4oii8jDBjsg-1; Thu, 23 Jun 2022 05:52:46 -0400
X-MC-Unique: 7fu2ASyuM4y4oii8jDBjsg-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2A761811E76;
        Thu, 23 Jun 2022 09:52:46 +0000 (UTC)
Received: from fedora.redhat.com (ovpn-12-43.pek2.redhat.com [10.72.12.43])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5A46F492CA6;
        Thu, 23 Jun 2022 09:52:41 +0000 (UTC)
From:   xiubli@redhat.com
To:     jlayton@kernel.org, idryomov@gmail.com
Cc:     vshankar@redhat.com, pdonnell@redhat.com,
        ceph-devel@vger.kernel.org, Xiubo Li <xiubli@redhat.com>
Subject: [PATCH] ceph: flush the dirty caps immediatelly when quota is approaching
Date:   Thu, 23 Jun 2022 17:52:38 +0800
Message-Id: <20220623095238.874126-1-xiubli@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: Xiubo Li <xiubli@redhat.com>

When the quota is approaching we need to notify it to the MDS as
soon as possible, or the client could write to the directory more
than expected.

This will flush the dirty caps without delaying after each write,
though this couldn't prevent the real size of a directory exceed
the quota but could prevent it as soon as possible.

URL: https://tracker.ceph.com/issues/56180
Signed-off-by: Xiubo Li <xiubli@redhat.com>
---
 fs/ceph/caps.c | 5 +++--
 fs/ceph/file.c | 5 +++--
 2 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
index c7163afdc71a..511d1963aa09 100644
--- a/fs/ceph/caps.c
+++ b/fs/ceph/caps.c
@@ -1979,14 +1979,15 @@ void ceph_check_caps(struct ceph_inode_info *ci, int flags,
 	}
 
 	dout("check_caps %llx.%llx file_want %s used %s dirty %s flushing %s"
-	     " issued %s revoking %s retain %s %s%s\n", ceph_vinop(inode),
+	     " issued %s revoking %s retain %s %s%s%s\n", ceph_vinop(inode),
 	     ceph_cap_string(file_wanted),
 	     ceph_cap_string(used), ceph_cap_string(ci->i_dirty_caps),
 	     ceph_cap_string(ci->i_flushing_caps),
 	     ceph_cap_string(issued), ceph_cap_string(revoking),
 	     ceph_cap_string(retain),
 	     (flags & CHECK_CAPS_AUTHONLY) ? " AUTHONLY" : "",
-	     (flags & CHECK_CAPS_FLUSH) ? " FLUSH" : "");
+	     (flags & CHECK_CAPS_FLUSH) ? " FLUSH" : "",
+	     (flags & CHECK_CAPS_NOINVAL) ? " NOINVAL" : "");
 
 	/*
 	 * If we no longer need to hold onto old our caps, and we may
diff --git a/fs/ceph/file.c b/fs/ceph/file.c
index debc1748ccdf..0eb4a02175ad 100644
--- a/fs/ceph/file.c
+++ b/fs/ceph/file.c
@@ -1960,7 +1960,7 @@ static ssize_t ceph_write_iter(struct kiocb *iocb, struct iov_iter *from)
 		if (dirty)
 			__mark_inode_dirty(inode, dirty);
 		if (ceph_quota_is_max_bytes_approaching(inode, iocb->ki_pos))
-			ceph_check_caps(ci, 0, NULL);
+			ceph_check_caps(ci, CHECK_CAPS_FLUSH, NULL);
 	}
 
 	dout("aio_write %p %llx.%llx %llu~%u  dropping cap refs on %s\n",
@@ -2577,7 +2577,8 @@ static ssize_t __ceph_copy_file_range(struct file *src_file, loff_t src_off,
 		/* Let the MDS know about dst file size change */
 		if (ceph_inode_set_size(dst_inode, dst_off) ||
 		    ceph_quota_is_max_bytes_approaching(dst_inode, dst_off))
-			ceph_check_caps(dst_ci, CHECK_CAPS_AUTHONLY, NULL);
+			ceph_check_caps(dst_ci, CHECK_CAPS_AUTHONLY | CHECK_CAPS_FLUSH,
+					NULL);
 	}
 	/* Mark Fw dirty */
 	spin_lock(&dst_ci->i_ceph_lock);
-- 
2.36.0.rc1

