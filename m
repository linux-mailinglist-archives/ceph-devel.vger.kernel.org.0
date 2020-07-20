Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5FF262254DB
	for <lists+ceph-devel@lfdr.de>; Mon, 20 Jul 2020 02:13:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726655AbgGTANK (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Sun, 19 Jul 2020 20:13:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726156AbgGTANK (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Sun, 19 Jul 2020 20:13:10 -0400
Received: from merlin.infradead.org (merlin.infradead.org [IPv6:2001:8b0:10b:1231::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0401C0619D2;
        Sun, 19 Jul 2020 17:13:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=Content-Transfer-Encoding:MIME-Version:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=OoBxCM7kR8Bn+e6mXK1TKeVJzvNOOfwwqkj9KXYxgso=; b=Tl2HgLRl9N+TtT85weWwfaoaY4
        TWZ/f8kwZEnVbmrq+TGqh60mymp7HOPxg7+3tarbIN/EeD/D6AGp9zgR4V6mzpHbxxWKTmTrA9Xvr
        VAr3zURKbGBEBvbeWJ9PshVVs83ydZ5dXH46iVlXrpAEPN2nRVvUgHikReaRWNqn4c2DAVV1cqMbl
        mSfb6XZBQt24hxncavkRbu4RM8mucypL3eAkQ7bLH9OLtXO/1mVnRP0DOkfsTRAupuuiQh3QOB0fr
        +hRznH8LShMrW/G4xMNss1v091t8maUN6Ze8H17D+dwBorwDOR3nDMInofefEdMLvg5l17WQlsZBt
        7rvYUIbw==;
Received: from [2601:1c0:6280:3f0::19c2] (helo=smtpauth.infradead.org)
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jxJQY-0003w8-EM; Mon, 20 Jul 2020 00:13:07 +0000
From:   Randy Dunlap <rdunlap@infradead.org>
To:     linux-kernel@vger.kernel.org
Cc:     Randy Dunlap <rdunlap@infradead.org>,
        Jeff Layton <jlayton@kernel.org>,
        Ilya Dryomov <idryomov@gmail.com>, ceph-devel@vger.kernel.org
Subject: [PATCH] ceph: super.h: delete a duplicated word
Date:   Sun, 19 Jul 2020 17:12:59 -0700
Message-Id: <20200720001259.21668-1-rdunlap@infradead.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Drop the repeated word "the" in a comment.

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Jeff Layton <jlayton@kernel.org>
Cc: Ilya Dryomov <idryomov@gmail.com>
Cc: ceph-devel@vger.kernel.org
---
 fs/ceph/super.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-next-20200717.orig/fs/ceph/super.h
+++ linux-next-20200717/fs/ceph/super.h
@@ -353,7 +353,7 @@ struct ceph_inode_info {
 	unsigned i_dirty_caps, i_flushing_caps;     /* mask of dirtied fields */
 
 	/*
-	 * Link to the the auth cap's session's s_cap_dirty list. s_cap_dirty
+	 * Link to the auth cap's session's s_cap_dirty list. s_cap_dirty
 	 * is protected by the mdsc->cap_dirty_lock, but each individual item
 	 * is also protected by the inode's i_ceph_lock. Walking s_cap_dirty
 	 * requires the mdsc->cap_dirty_lock. List presence for an item can
