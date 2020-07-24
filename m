Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6EAB222BAFC
	for <lists+ceph-devel@lfdr.de>; Fri, 24 Jul 2020 02:26:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728324AbgGXA0l (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 23 Jul 2020 20:26:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727982AbgGXA0l (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 23 Jul 2020 20:26:41 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F31C4C0619D3;
        Thu, 23 Jul 2020 17:26:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=vhOqR9Gr3btEKPJ9ZiQD72w1Ieu2CnG1iBwxaYm/s0c=; b=VEYEIjzSxhOy772aPTMdX2Hes/
        tbsO5Ak0tcX5qupK1rvRph3kn/2jBuqKwyS4HgqoVaT+YSO7+vmBjxThzviuRvLZbHNFM3MTgBfuD
        aSPdbzNLSW114PMCL8CyBLf7unY4dEFgdAEQ2mvAWvPtjj3WT9VXwyiFE85Vz23tFz+EGfrxqdKOU
        /09zOXh2etUO3lRsT20rh6p2pcZF23wtsvsGAWGv1TZwyUqb9RWPuCHTdPEl8XUNcSz1oQCcLO6xE
        7xuftRZxiZlHarUSR9t8Lcs7a6Uqi63AEtpJK0kShdY+bJx3zy4vH5ZfVeoXwgu/gGtOS8HH9a0GS
        cWzTSXgg==;
Received: from [2601:1c0:6280:3f0::19c2] (helo=smtpauth.infradead.org)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jylXq-0007dG-1f; Fri, 24 Jul 2020 00:26:39 +0000
From:   Randy Dunlap <rdunlap@infradead.org>
To:     linux-kernel@vger.kernel.org
Cc:     Randy Dunlap <rdunlap@infradead.org>,
        Ilya Dryomov <idryomov@gmail.com>,
        Jeff Layton <jlayton@kernel.org>, ceph-devel@vger.kernel.org
Subject: [PATCH] ceph: delete repeated words in fs/ceph/
Date:   Thu, 23 Jul 2020 17:26:34 -0700
Message-Id: <20200724002634.2545-1-rdunlap@infradead.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Drop duplicated words "down" and "the" in fs/ceph/super.[ch].

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Ilya Dryomov <idryomov@gmail.com>
Cc: Jeff Layton <jlayton@kernel.org>
Cc: ceph-devel@vger.kernel.org
---
Jeff, this is last of the duplicate words patches for ceph.

 fs/ceph/super.c |    2 +-
 fs/ceph/super.h |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

--- linux-next-20200723.orig/fs/ceph/super.c
+++ linux-next-20200723/fs/ceph/super.c
@@ -828,7 +828,7 @@ static void destroy_caches(void)
 }
 
 /*
- * ceph_umount_begin - initiate forced umount.  Tear down down the
+ * ceph_umount_begin - initiate forced umount.  Tear down the
  * mount, skipping steps that may hang while waiting for server(s).
  */
 static void ceph_umount_begin(struct super_block *sb)
--- linux-next-20200723.orig/fs/ceph/super.h
+++ linux-next-20200723/fs/ceph/super.h
@@ -353,7 +353,7 @@ struct ceph_inode_info {
 	unsigned i_dirty_caps, i_flushing_caps;     /* mask of dirtied fields */
 
 	/*
-	 * Link to the the auth cap's session's s_cap_dirty list. s_cap_dirty
+	 * Link to the auth cap's session's s_cap_dirty list. s_cap_dirty
 	 * is protected by the mdsc->cap_dirty_lock, but each individual item
 	 * is also protected by the inode's i_ceph_lock. Walking s_cap_dirty
 	 * requires the mdsc->cap_dirty_lock. List presence for an item can
