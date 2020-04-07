Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C6BFB1A0BEE
	for <lists+ceph-devel@lfdr.de>; Tue,  7 Apr 2020 12:30:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728645AbgDGKaE (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 7 Apr 2020 06:30:04 -0400
Received: from mx2.suse.de ([195.135.220.15]:48736 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728507AbgDGKaD (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Tue, 7 Apr 2020 06:30:03 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id B84E9AF22;
        Tue,  7 Apr 2020 10:30:00 +0000 (UTC)
From:   Luis Henriques <lhenriques@suse.com>
To:     Jeff Layton <jlayton@kernel.org>, Sage Weil <sage@redhat.com>,
        Ilya Dryomov <idryomov@gmail.com>,
        Gregory Farnum <gfarnum@redhat.com>,
        Zheng Yan <zyan@redhat.com>
Cc:     Frank Schilder <frans@dtu.dk>, ceph-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org, Luis Henriques <lhenriques@suse.com>
Subject: [PATCH v2 1/2] ceph: normalize 'delta' parameter usage in check_quota_exceeded
Date:   Tue,  7 Apr 2020 11:30:19 +0100
Message-Id: <20200407103020.22588-2-lhenriques@suse.com>
In-Reply-To: <20200407103020.22588-1-lhenriques@suse.com>
References: <20200407103020.22588-1-lhenriques@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Function check_quota_exceeded() uses delta parameter only for the
QUOTA_CHECK_MAX_BYTES_OP operation.  Using this parameter also for
MAX_FILES will makes the code cleaner and will be required to support
cross-quota-tree renames.

Signed-off-by: Luis Henriques <lhenriques@suse.com>
---
 fs/ceph/quota.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/fs/ceph/quota.c b/fs/ceph/quota.c
index de56dee60540..c5c8050f0f99 100644
--- a/fs/ceph/quota.c
+++ b/fs/ceph/quota.c
@@ -361,8 +361,6 @@ static bool check_quota_exceeded(struct inode *inode, enum quota_check_op op,
 		spin_unlock(&ci->i_ceph_lock);
 		switch (op) {
 		case QUOTA_CHECK_MAX_FILES_OP:
-			exceeded = (max && (rvalue >= max));
-			break;
 		case QUOTA_CHECK_MAX_BYTES_OP:
 			exceeded = (max && (rvalue + delta > max));
 			break;
@@ -417,7 +415,7 @@ bool ceph_quota_is_max_files_exceeded(struct inode *inode)
 
 	WARN_ON(!S_ISDIR(inode->i_mode));
 
-	return check_quota_exceeded(inode, QUOTA_CHECK_MAX_FILES_OP, 0);
+	return check_quota_exceeded(inode, QUOTA_CHECK_MAX_FILES_OP, 1);
 }
 
 /*
