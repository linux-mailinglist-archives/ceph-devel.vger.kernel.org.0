Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6CDEE1C5610
	for <lists+ceph-devel@lfdr.de>; Tue,  5 May 2020 14:59:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728968AbgEEM7G (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 5 May 2020 08:59:06 -0400
Received: from mx2.suse.de ([195.135.220.15]:54034 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728268AbgEEM7F (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Tue, 5 May 2020 08:59:05 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 554D9ACCC;
        Tue,  5 May 2020 12:59:06 +0000 (UTC)
Received: from localhost (webern.olymp [local])
        by webern.olymp (OpenSMTPD) with ESMTPA id 1ffc28eb;
        Tue, 5 May 2020 13:59:02 +0100 (WEST)
Date:   Tue, 5 May 2020 13:59:02 +0100
From:   Luis Henriques <lhenriques@suse.com>
To:     Jeff Layton <jlayton@kernel.org>,
        Ilya Dryomov <idryomov@gmail.com>,
        Gregory Farnum <gfarnum@redhat.com>
Cc:     ceph-devel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] ceph: demote quotarealm lookup warning to a debug message
Message-ID: <20200505125902.GA10381@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

A misconfigured cephx can easily result in having the kernel client
flooding the logs with:

  ceph: Can't lookup inode 1 (err: -13)

Change his message to debug level.

Link: https://tracker.ceph.com/issues/44546
Signed-off-by: Luis Henriques <lhenriques@suse.com>
---
Hi!

This patch should fix some harmless warnings when using cephx to restrict
users access to certain filesystem paths.  I've added a comment to the
tracker where removing this warning could result (unlikely, IMHO!) in an
admin to miss not-so-harmless bogus configurations.

Cheers,
--
Luís

 fs/ceph/quota.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/ceph/quota.c b/fs/ceph/quota.c
index de56dee60540..19507e2fdb57 100644
--- a/fs/ceph/quota.c
+++ b/fs/ceph/quota.c
@@ -159,8 +159,8 @@ static struct inode *lookup_quotarealm_inode(struct ceph_mds_client *mdsc,
 	}
 
 	if (IS_ERR(in)) {
-		pr_warn("Can't lookup inode %llx (err: %ld)\n",
-			realm->ino, PTR_ERR(in));
+		dout("Can't lookup inode %llx (err: %ld)\n",
+		     realm->ino, PTR_ERR(in));
 		qri->timeout = jiffies + msecs_to_jiffies(60 * 1000); /* XXX */
 	} else {
 		qri->timeout = 0;

