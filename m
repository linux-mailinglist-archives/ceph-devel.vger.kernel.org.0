Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DDA5B71C2F
	for <lists+ceph-devel@lfdr.de>; Tue, 23 Jul 2019 17:50:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731588AbfGWPuY (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 23 Jul 2019 11:50:24 -0400
Received: from mx2.suse.de ([195.135.220.15]:47596 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728497AbfGWPuY (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Tue, 23 Jul 2019 11:50:24 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id DF2B6B0BF;
        Tue, 23 Jul 2019 15:50:22 +0000 (UTC)
From:   Luis Henriques <lhenriques@suse.com>
To:     Jeff Layton <jlayton@kernel.org>,
        Ilya Dryomov <idryomov@gmail.com>, Sage Weil <sage@redhat.com>
Cc:     ceph-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Luis Henriques <lhenriques@suse.com>
Subject: [RFC PATCH] ceph: fix directories inode i_blkbits initialization
Date:   Tue, 23 Jul 2019 16:50:20 +0100
Message-Id: <20190723155020.17338-1-lhenriques@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

When filling an inode with info from the MDS, i_blkbits is being
initialized using fl_stripe_unit, which contains the stripe unit in
bytes.  Unfortunately, this doesn't make sense for directories as they
have fl_stripe_unit set to '0'.  This means that i_blkbits will be set
to 0xff, causing an UBSAN undefined behaviour in i_blocksize():

  UBSAN: Undefined behaviour in ./include/linux/fs.h:731:12
  shift exponent 255 is too large for 32-bit type 'int'

Fix this by initializing i_blkbits to CEPH_BLOCK_SHIFT if fl_stripe_unit
is zero.

Signed-off-by: Luis Henriques <lhenriques@suse.com>
---
 fs/ceph/inode.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

Hi Jeff,

To be honest, I'm not sure CEPH_BLOCK_SHIFT is the right value to use
here, but for sure the one currently being used isn't correct if the
inode is a directory.  Using stripe units seems to be a bug that has
been there since the beginning, but it definitely became bigger problem
after commit 69448867abcb ("fs: shave 8 bytes off of struct inode").

This fix could also be moved into the 'switch' statement later in that
function, in the S_IFDIR case, similar to commit 5ba72e607cdb ("ceph:
set special inode's blocksize to page size").  Let me know which version
you would prefer.

Cheers,
--
Luis

diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
index 791f84a13bb8..0e6d6db848b7 100644
--- a/fs/ceph/inode.c
+++ b/fs/ceph/inode.c
@@ -800,7 +800,12 @@ static int fill_inode(struct inode *inode, struct page *locked_page,
 
 	/* update inode */
 	inode->i_rdev = le32_to_cpu(info->rdev);
-	inode->i_blkbits = fls(le32_to_cpu(info->layout.fl_stripe_unit)) - 1;
+	/* directories have fl_stripe_unit set to zero */
+	if (le32_to_cpu(info->layout.fl_stripe_unit))
+		inode->i_blkbits =
+			fls(le32_to_cpu(info->layout.fl_stripe_unit)) - 1;
+	else
+		inode->i_blkbits = CEPH_BLOCK_SHIFT;
 
 	__ceph_update_quota(ci, iinfo->max_bytes, iinfo->max_files);
 
