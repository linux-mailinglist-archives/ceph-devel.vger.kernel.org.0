Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D04441DA12
	for <lists+ceph-devel@lfdr.de>; Thu, 30 Sep 2021 14:43:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350736AbhI3MoX (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 30 Sep 2021 08:44:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:44508 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1350675AbhI3MoW (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Thu, 30 Sep 2021 08:44:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E237361452;
        Thu, 30 Sep 2021 12:42:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633005760;
        bh=gg5SFmtR7Fglt/NknkuOyppsjZFwmlUqP9anLOEQP/0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IPuMy9LoL7kPg2JL9juYxvYm1puSxhikpe4cNUCfVC/Hbq0pSfhfdy5kFTpFv+Gzg
         FnlaOKiH8GddFDyiEcBvLBxLlBpYdh7vzpYgak4hP8y1Ad/2P6KsC9Y9ScB+04/Xl3
         pUNess1Kd5YTLZMDKnr17YdlxYjO2Qqm7n611EmFLksev6o94Y+L4wyNbE9f2FlS4r
         s8A51F0Is4EPTO42d0nqsNUdLU9pZu2/YU2Sc/NOPbTgPhXhK9SRxa4jQNgFe13Wn+
         8r7JLFLOwRJiFOCrv1Wd2fDJjrX2yiwgRCp2Ulmg2XomkX1F2zBRTJg/8ifjikFwpw
         7t2EebvS+A+Zw==
From:   Jeff Layton <jlayton@kernel.org>
To:     ceph-devel@vger.kernel.org
Cc:     idryomov@gmail.com, Patrick Donnelly <pdonnell@redhat.com>,
        Niels de Vos <ndevos@redhat.com>
Subject: [RFC PATCH] ceph: skip existing superblocks that are blocklisted when mounting
Date:   Thu, 30 Sep 2021 08:42:38 -0400
Message-Id: <20210930124238.12966-2-jlayton@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210930124238.12966-1-jlayton@kernel.org>
References: <20210930124238.12966-1-jlayton@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Currently when mounting, we may end up finding an existing superblock
that corresponds to a blocklisted MDS client. This means that the new
mount ends up being unusable.

If we've found an existing superblock that is already blocklisted, and
the client is not configured to recover on its own, fail the match.

Cc: Patrick Donnelly <pdonnell@redhat.com>
Cc: Niels de Vos <ndevos@redhat.com>
URL: https://bugzilla.redhat.com/show_bug.cgi?id=1901499
Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/ceph/super.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/fs/ceph/super.c b/fs/ceph/super.c
index f517ad9eeb26..6e0d670a7f34 100644
--- a/fs/ceph/super.c
+++ b/fs/ceph/super.c
@@ -1124,6 +1124,7 @@ static int ceph_compare_super(struct super_block *sb, struct fs_context *fc)
 	struct ceph_mount_options *fsopt = new->mount_options;
 	struct ceph_options *opt = new->client->options;
 	struct ceph_fs_client *other = ceph_sb_to_client(sb);
+	struct ceph_mds_client *mdsc = ceph_sb_to_mdsc(sb);
 
 	dout("ceph_compare_super %p\n", sb);
 
@@ -1140,6 +1141,12 @@ static int ceph_compare_super(struct super_block *sb, struct fs_context *fc)
 		dout("flags differ\n");
 		return 0;
 	}
+
+	/* Exclude any blocklisted superblocks */
+	if (mdsc->blocklisted && !(fsopt->flags & CEPH_MOUNT_OPT_CLEANRECOVER)) {
+		dout("mds client is blocklisted (and CLEANRECOVER is not set)\n");
+		return 0;
+	}
 	return 1;
 }
 
-- 
2.31.1

