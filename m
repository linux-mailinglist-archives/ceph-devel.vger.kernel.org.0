Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 36D7A4AA99C
	for <lists+ceph-devel@lfdr.de>; Sat,  5 Feb 2022 16:17:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357694AbiBEPRI (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Sat, 5 Feb 2022 10:17:08 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:35598 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229940AbiBEPRI (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Sat, 5 Feb 2022 10:17:08 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 35BAF60F66
        for <ceph-devel@vger.kernel.org>; Sat,  5 Feb 2022 15:17:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F7ACC340E8;
        Sat,  5 Feb 2022 15:17:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644074227;
        bh=rTmuwX1z2Dy3mOMinjpZu3OXl/JdUSCfeuM79G+L4sM=;
        h=From:To:Cc:Subject:Date:From;
        b=PdsAOsWRSjpxmxDGyTOfLYuAzJMoOnQ4d+L3rmcWg3m7JGmNm7bjhRXQu7CiTwCBy
         Rx9C2gThDNeLgWSqllhDQOvnDQ5erCp1ANbTiFOst7xE8OdU/swN7gM0emdgnPdI6I
         bSk9nJRcKOflU+0mBAXPkCuhAeWr8r/zOjcKKGRCEa3zdFtX+4GKOAF66fiQjRxfFv
         E9N66PnW1mbc9Eyn33BZBFYxumXiynE848eLn9nLpY/hmgqYZQutmvz7NkQZ7GgfmC
         h1mOgB6rsjKHdR2n4OyONRBH+CDO8bRJ5LJKN8gW0OXjxC/gb+PkAfWP66uqF5s+zM
         bPNVgpfwzqTBg==
From:   Jeff Layton <jlayton@kernel.org>
To:     ceph-devel@vger.kernel.org
Cc:     idryomov@gmail.com, pdonnell@redhat.com
Subject: [PATCH] ceph: wait for async create reply before sending any cap messages
Date:   Sat,  5 Feb 2022 10:17:05 -0500
Message-Id: <20220205151705.36309-1-jlayton@kernel.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

If we haven't received a reply to an async create request, then we don't
want to send any cap messages to the MDS for that inode yet.

Just have ceph_check_caps  and __kick_flushing_caps return without doing
anything, and have ceph_write_inode wait for the reply if we were asked
to wait on the inode writeback.

URL: https://tracker.ceph.com/issues/54107
Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/ceph/caps.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
index e668cdb9c99e..f29e2dbcf8df 100644
--- a/fs/ceph/caps.c
+++ b/fs/ceph/caps.c
@@ -1916,6 +1916,13 @@ void ceph_check_caps(struct ceph_inode_info *ci, int flags,
 		ceph_get_mds_session(session);
 
 	spin_lock(&ci->i_ceph_lock);
+	if (ci->i_ceph_flags & CEPH_I_ASYNC_CREATE) {
+		/* Don't send messages until we get async create reply */
+		spin_unlock(&ci->i_ceph_lock);
+		ceph_put_mds_session(session);
+		return;
+	}
+
 	if (ci->i_ceph_flags & CEPH_I_FLUSH)
 		flags |= CHECK_CAPS_FLUSH;
 retry:
@@ -2410,6 +2417,9 @@ int ceph_write_inode(struct inode *inode, struct writeback_control *wbc)
 	dout("write_inode %p wait=%d\n", inode, wait);
 	ceph_fscache_unpin_writeback(inode, wbc);
 	if (wait) {
+		err = ceph_wait_on_async_create(inode);
+		if (err)
+			return err;
 		dirty = try_flush_caps(inode, &flush_tid);
 		if (dirty)
 			err = wait_event_interruptible(ci->i_cap_wq,
@@ -2440,6 +2450,10 @@ static void __kick_flushing_caps(struct ceph_mds_client *mdsc,
 	u64 first_tid = 0;
 	u64 last_snap_flush = 0;
 
+	/* Don't do anything until create reply comes in */
+	if (ci->i_ceph_flags & CEPH_I_ASYNC_CREATE)
+		return;
+
 	ci->i_ceph_flags &= ~CEPH_I_KICK_FLUSH;
 
 	list_for_each_entry_reverse(cf, &ci->i_cap_flush_list, i_list) {
-- 
2.34.1

