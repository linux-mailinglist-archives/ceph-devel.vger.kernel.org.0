Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8EADC18F94D
	for <lists+ceph-devel@lfdr.de>; Mon, 23 Mar 2020 17:07:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727600AbgCWQHO (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 23 Mar 2020 12:07:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:49466 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727426AbgCWQHN (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Mon, 23 Mar 2020 12:07:13 -0400
Received: from tleilax.com (68-20-15-154.lightspeed.rlghnc.sbcglobal.net [68.20.15.154])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4990020753;
        Mon, 23 Mar 2020 16:07:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584979632;
        bh=VkM2bUO4dDDJShlv8kfKJD6uuEQnUCWXHJp/N+emm3M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=opBdDJexjL3ZE75hFPEG/dY4MakvK2SysQFNT4MkRO52Uugaguek/K2O6eico0P+r
         QuViD72QyK+oBzS7ofEiMEcc2qcP9ghcem+yP3MqorelgSoGGW3/qUQkBl5Ektlrrn
         +ne+4lzXqajYcb0PdNmLWS7t+HIiQPawZTptALzU=
From:   Jeff Layton <jlayton@kernel.org>
To:     ceph-devel@vger.kernel.org
Cc:     ukernel@gmail.com, idryomov@gmail.com, sage@redhat.com
Subject: [PATCH 3/8] ceph: add comments for handle_cap_flush_ack logic
Date:   Mon, 23 Mar 2020 12:07:03 -0400
Message-Id: <20200323160708.104152-4-jlayton@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200323160708.104152-1-jlayton@kernel.org>
References: <20200323160708.104152-1-jlayton@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/ceph/caps.c | 14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
index 01877f91b85b..6220425e2a9c 100644
--- a/fs/ceph/caps.c
+++ b/fs/ceph/caps.c
@@ -3491,14 +3491,26 @@ static void handle_cap_flush_ack(struct inode *inode, u64 flush_tid,
 	bool wake_mdsc = false;
 
 	list_for_each_entry_safe(cf, tmp_cf, &ci->i_cap_flush_list, i_list) {
+		/* Is this the one that was flushed? */
 		if (cf->tid == flush_tid)
 			cleaned = cf->caps;
-		if (cf->caps == 0) /* capsnap */
+
+		/* Is this a capsnap? */
+		if (cf->caps == 0)
 			continue;
+
 		if (cf->tid <= flush_tid) {
+			/*
+			 * An earlier or current tid. The FLUSH_ACK should
+			 * represent a superset of this flush's caps.
+			 */
 			wake_ci |= __detach_cap_flush_from_ci(ci, cf);
 			list_add_tail(&cf->i_list, &to_remove);
 		} else {
+			/*
+			 * This is a later one. Any caps in it are still dirty
+			 * so don't count them as cleaned.
+			 */
 			cleaned &= ~cf->caps;
 			if (!cleaned)
 				break;
-- 
2.25.1

