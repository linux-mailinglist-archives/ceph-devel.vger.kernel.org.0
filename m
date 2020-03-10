Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 976D717FF58
	for <lists+ceph-devel@lfdr.de>; Tue, 10 Mar 2020 14:46:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727993AbgCJNqR (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 10 Mar 2020 09:46:17 -0400
Received: from mx2.suse.de ([195.135.220.15]:48160 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727327AbgCJNqQ (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Tue, 10 Mar 2020 09:46:16 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id D9DACAC22;
        Tue, 10 Mar 2020 13:46:14 +0000 (UTC)
Received: from localhost (webern.olymp [local])
        by webern.olymp (OpenSMTPD) with ESMTPA id e1a12c44;
        Tue, 10 Mar 2020 13:46:13 +0000 (WET)
Date:   Tue, 10 Mar 2020 13:46:13 +0000
From:   Luis Henriques <lhenriques@suse.com>
To:     Marc Roos <M.Roos@f1-outsourcing.eu>,
        Jeff Layton <jlayton@kernel.org>
Cc:     ceph-users <ceph-users@ceph.io>, ceph-devel@vger.kernel.org
Subject: Re: [ceph-users] cephfs snap mkdir strange timestamp
Message-ID: <20200310134613.GA74810@suse.com>
References: <"H000007100163fdf.1583792359.sx.f1-outsourcing.eu*"@MHS>
 <"H000007100164304.1583836879.sx.f1-outsourcing.eu*"@MHS>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <"H000007100164304.1583836879.sx.f1-outsourcing.eu*"@MHS>
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

[ CC'ing Jeff and ceph-devel@ ]

On Tue, Mar 10, 2020 at 11:41:19AM +0100, Marc Roos wrote:
>  
> 
> If I make a directory in linux the directory has the date of now, why is 
> this not with creating a snap dir? Is this not a bug? One expects this 
> to be the same as in linux not????

I've noticed that long time ago, but I never checked the fuse client
behaviour, which turns out to be different.  The fuse client seems to set
ctime and atime to the same value as the parent directory (see
Client::open_snapdir()).

The patch below mimics that behaviour, by simply copying those timestamps
from the parent inode.

Cheers,
--
Luis

From 2c8e06e66e5453ddf8b634cf1689a812dc05a0c6 Mon Sep 17 00:00:00 2001
From: Luis Henriques <lhenriques@suse.com>
Date: Tue, 10 Mar 2020 13:35:11 +0000
Subject: [PATCH] ceph: fix snapshot dir ctime and mtime

The .snap directory timestamps are kept at 0 (1970-01-01 00:00), which
isn't consistent with what the fuse client does.  This patch makes the
behaviour consistent, by setting these timestamps to those of the parent
directory.

Signed-off-by: Luis Henriques <lhenriques@suse.com>
---
 fs/ceph/inode.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
index d01710a16a4a..f4e78ade0871 100644
--- a/fs/ceph/inode.c
+++ b/fs/ceph/inode.c
@@ -82,6 +82,8 @@ struct inode *ceph_get_snapdir(struct inode *parent)
 	inode->i_mode = parent->i_mode;
 	inode->i_uid = parent->i_uid;
 	inode->i_gid = parent->i_gid;
+	inode->i_mtime = parent->i_mtime;
+	inode->i_ctime = parent->i_ctime;
 	inode->i_op = &ceph_snapdir_iops;
 	inode->i_fop = &ceph_snapdir_fops;
 	ci->i_snap_caps = CEPH_CAP_PIN; /* so we can open */
