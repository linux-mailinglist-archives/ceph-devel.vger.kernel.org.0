Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 34973E4BBF
	for <lists+ceph-devel@lfdr.de>; Fri, 25 Oct 2019 15:05:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439390AbfJYNF2 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 25 Oct 2019 09:05:28 -0400
Received: from mx2.suse.de ([195.135.220.15]:36596 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2439284AbfJYNF2 (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Fri, 25 Oct 2019 09:05:28 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 4D95CAFA8;
        Fri, 25 Oct 2019 13:05:26 +0000 (UTC)
From:   Luis Henriques <lhenriques@suse.com>
To:     Jeff Layton <jlayton@kernel.org>, Sage Weil <sage@redhat.com>,
        Ilya Dryomov <idryomov@gmail.com>,
        "Yan, Zheng" <ukernel@gmail.com>
Cc:     ceph-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Luis Henriques <lhenriques@suse.com>
Subject: [PATCH v2] ceph: Fix use-after-free in __ceph_remove_cap
Date:   Fri, 25 Oct 2019 14:05:24 +0100
Message-Id: <20191025130524.31755-1-lhenriques@suse.com>
In-Reply-To: <9c1fe73500ca7dece15c73d7534b9e0ec417c83a.camel@kernel.org>
References: <9c1fe73500ca7dece15c73d7534b9e0ec417c83a.camel@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

KASAN reports a use-after-free when running xfstest generic/531, with the
following trace:

[  293.903362]  kasan_report+0xe/0x20
[  293.903365]  rb_erase+0x1f/0x790
[  293.903370]  __ceph_remove_cap+0x201/0x370
[  293.903375]  __ceph_remove_caps+0x4b/0x70
[  293.903380]  ceph_evict_inode+0x4e/0x360
[  293.903386]  evict+0x169/0x290
[  293.903390]  __dentry_kill+0x16f/0x250
[  293.903394]  dput+0x1c6/0x440
[  293.903398]  __fput+0x184/0x330
[  293.903404]  task_work_run+0xb9/0xe0
[  293.903410]  exit_to_usermode_loop+0xd3/0xe0
[  293.903413]  do_syscall_64+0x1a0/0x1c0
[  293.903417]  entry_SYSCALL_64_after_hwframe+0x44/0xa9

This happens because __ceph_remove_cap() may queue a cap release
(__ceph_queue_cap_release) which can be scheduled before that cap is
removed from the inode list with

	rb_erase(&cap->ci_node, &ci->i_caps);

And, when this finally happens, the use-after-free will occur.

This can be fixed by removing the cap from the inode list before being
removed from the session list, and thus eliminating the risk of an UAF.

Signed-off-by: Luis Henriques <lhenriques@suse.com>
---
Hi!

So, after spending some time trying to find possible races throught code
review and testing, I modified the fix according to Jeff's suggestion.

Cheers,
Luis

fs/ceph/caps.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
index d3b9c9d5c1bd..a9ce858c37d0 100644
--- a/fs/ceph/caps.c
+++ b/fs/ceph/caps.c
@@ -1058,6 +1058,11 @@ void __ceph_remove_cap(struct ceph_cap *cap, bool queue_release)
 
 	dout("__ceph_remove_cap %p from %p\n", cap, &ci->vfs_inode);
 
+	/* remove from inode list */
+	rb_erase(&cap->ci_node, &ci->i_caps);
+	if (ci->i_auth_cap == cap)
+		ci->i_auth_cap = NULL;
+
 	/* remove from session list */
 	spin_lock(&session->s_cap_lock);
 	if (session->s_cap_iterator == cap) {
@@ -1091,11 +1096,6 @@ void __ceph_remove_cap(struct ceph_cap *cap, bool queue_release)
 
 	spin_unlock(&session->s_cap_lock);
 
-	/* remove from inode list */
-	rb_erase(&cap->ci_node, &ci->i_caps);
-	if (ci->i_auth_cap == cap)
-		ci->i_auth_cap = NULL;
-
 	if (removed)
 		ceph_put_cap(mdsc, cap);
 
