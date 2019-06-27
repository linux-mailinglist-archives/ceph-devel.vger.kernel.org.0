Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ED861583D8
	for <lists+ceph-devel@lfdr.de>; Thu, 27 Jun 2019 15:51:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726498AbfF0Nv2 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 27 Jun 2019 09:51:28 -0400
Received: from mx2.suse.de ([195.135.220.15]:52968 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726462AbfF0Nv2 (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Thu, 27 Jun 2019 09:51:28 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 23C5BAB9D;
        Thu, 27 Jun 2019 13:51:27 +0000 (UTC)
From:   Luis Henriques <lhenriques@suse.com>
To:     Jeff Layton <jlayton@kernel.org>, "Yan, Zheng" <zyan@redhat.com>,
        Sage Weil <sage@redhat.com>, Ilya Dryomov <idryomov@gmail.com>
Cc:     ceph-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Luis Henriques <lhenriques@suse.com>
Subject: [RFC PATCH] ceph: initialize superblock s_time_gran to 1
Date:   Thu, 27 Jun 2019 14:51:22 +0100
Message-Id: <20190627135122.12817-1-lhenriques@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Having granularity set to 1us results in having inode timestamps with a
accurancy different from the fuse client (i.e. atime, ctime and mtime will
always end with '000').  This patch normalizes this behaviour and sets the
granularity to 1.

Signed-off-by: Luis Henriques <lhenriques@suse.com>
---
 fs/ceph/super.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Hi!

As far as I could see there are no other side-effects of changing
s_time_gran but I'm really not sure why it was initially set to 1000 in
the first place so I may be missing something.

diff --git a/fs/ceph/super.c b/fs/ceph/super.c
index d57fa60dcd43..35dd75bc9cd0 100644
--- a/fs/ceph/super.c
+++ b/fs/ceph/super.c
@@ -980,7 +980,7 @@ static int ceph_set_super(struct super_block *s, void *data)
 	s->s_d_op = &ceph_dentry_ops;
 	s->s_export_op = &ceph_export_ops;
 
-	s->s_time_gran = 1000;  /* 1000 ns == 1 us */
+	s->s_time_gran = 1;
 
 	ret = set_anon_super(s, NULL);  /* what is that second arg for? */
 	if (ret != 0)
