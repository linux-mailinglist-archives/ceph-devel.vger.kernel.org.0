Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AF5F7181685
	for <lists+ceph-devel@lfdr.de>; Wed, 11 Mar 2020 12:05:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729007AbgCKLFl (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 11 Mar 2020 07:05:41 -0400
Received: from mx2.suse.de ([195.135.220.15]:33196 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726000AbgCKLFl (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Wed, 11 Mar 2020 07:05:41 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 6C0DBACC6;
        Wed, 11 Mar 2020 11:05:39 +0000 (UTC)
Received: from localhost (webern.olymp [local])
        by webern.olymp (OpenSMTPD) with ESMTPA id 9ec4e936;
        Wed, 11 Mar 2020 11:05:38 +0000 (WET)
Date:   Wed, 11 Mar 2020 11:05:38 +0000
From:   Luis Henriques <lhenriques@suse.com>
To:     Jeff Layton <jlayton@kernel.org>, Sage Weil <sage@redhat.com>,
        Ilya Dryomov <idryomov@gmail.com>
Cc:     Marc Roos <M.Roos@f1-outsourcing.eu>, ceph-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2] ceph: fix snapshot directory timestamps
Message-ID: <20200311110538.GB58729@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

The .snap directory timestamps are kept at 0 (1970-01-01 00:00), which
isn't consistent with what the fuse client does.  This patch makes the
behaviour consistent, by setting these timestamps (atime, btime, ctime,
mtime) to those of the parent directory.

Cc: Marc Roos <M.Roos@f1-outsourcing.eu>
Signed-off-by: Luis Henriques <lhenriques@suse.com>
---
 fs/ceph/inode.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
index d01710a16a4a..968d55ca898d 100644
--- a/fs/ceph/inode.c
+++ b/fs/ceph/inode.c
@@ -82,10 +82,14 @@ struct inode *ceph_get_snapdir(struct inode *parent)
 	inode->i_mode = parent->i_mode;
 	inode->i_uid = parent->i_uid;
 	inode->i_gid = parent->i_gid;
+	inode->i_mtime = parent->i_mtime;
+	inode->i_ctime = parent->i_ctime;
+	inode->i_atime = parent->i_atime;
 	inode->i_op = &ceph_snapdir_iops;
 	inode->i_fop = &ceph_snapdir_fops;
 	ci->i_snap_caps = CEPH_CAP_PIN; /* so we can open */
 	ci->i_rbytes = 0;
+	ci->i_btime = ceph_inode(parent)->i_btime;
 
 	if (inode->i_state & I_NEW)
 		unlock_new_inode(inode);
