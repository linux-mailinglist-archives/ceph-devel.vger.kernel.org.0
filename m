Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB5C434975B
	for <lists+ceph-devel@lfdr.de>; Thu, 25 Mar 2021 17:57:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229719AbhCYQ4e (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 25 Mar 2021 12:56:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:35526 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229547AbhCYQ4I (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Thu, 25 Mar 2021 12:56:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D1B0161A1E;
        Thu, 25 Mar 2021 16:56:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616691368;
        bh=vtCT04sR/zzYWQUtv9wSIxPGOTKdKlSuKj0we6esZ14=;
        h=From:To:Cc:Subject:Date:From;
        b=q2tpnx+frC2R82GB3PbsxtNfzA6RbHtMlIYrjggRVWQRnS9rsajH49t3074s8kTPA
         Gu3AS1juiMXqUcYOjU6TsKnwbZk3dvPBx+bJoGdMiVmmOElQbqjQJS4Ixo23lw/0+L
         Up4y06ktaFRn58f/ZgDQU5PJn6Zs1DaWUUKzLrZQUg0mu0iMenH9am0V6XtWFHi8td
         weCgpNcw6ogCo6hAZ1cRvjyBo17HFyyREekuQLS1tXzoAYlLcb2l5THKipHqzZIU31
         2A5qw1ylzMB9+lY3ThToU2tYJWjWMX2qkBUx+ea+dVGVJ+VpspLITtelZU7gSDyyTo
         XPVKvIGEk33xg==
From:   Jeff Layton <jlayton@kernel.org>
To:     ceph-devel@vger.kernel.org
Cc:     idryomov@gmail.com, Luis Henriques <lhenriques@suse.de>
Subject: [PATCH] ceph: only check pool permissions for regular files
Date:   Thu, 25 Mar 2021 12:56:06 -0400
Message-Id: <20210325165606.41943-1-jlayton@kernel.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

There is no need to do a ceph_pool_perm_check() on anything that isn't a
regular file, as the MDS is what handles talking to the OSD in those
cases. Just return 0 if it's not a regular file.

Reported-by: Luis Henriques <lhenriques@suse.de>
Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/ceph/addr.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
index d26a88aca014..07cbf21099b8 100644
--- a/fs/ceph/addr.c
+++ b/fs/ceph/addr.c
@@ -1940,6 +1940,10 @@ int ceph_pool_perm_check(struct inode *inode, int need)
 	s64 pool;
 	int ret, flags;
 
+	/* Only need to do this for regular files */
+	if (!S_ISREG(inode->i_mode))
+		return 0;
+
 	if (ci->i_vino.snap != CEPH_NOSNAP) {
 		/*
 		 * Pool permission check needs to write to the first object.
-- 
2.30.2

