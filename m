Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5EECE19FBAE
	for <lists+ceph-devel@lfdr.de>; Mon,  6 Apr 2020 19:35:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728777AbgDFRe7 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 6 Apr 2020 13:34:59 -0400
Received: from mx2.suse.de ([195.135.220.15]:41654 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726510AbgDFRe7 (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Mon, 6 Apr 2020 13:34:59 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 50375C086;
        Mon,  6 Apr 2020 17:34:56 +0000 (UTC)
From:   Luis Henriques <lhenriques@suse.com>
To:     Jeff Layton <jlayton@kernel.org>, Sage Weil <sage@redhat.com>,
        Ilya Dryomov <idryomov@gmail.com>,
        Gregory Farnum <gfarnum@redhat.com>,
        Zheng Yan <zyan@redhat.com>
Cc:     Frank Schilder <frans@dtu.dk>, ceph-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org, Luis Henriques <lhenriques@suse.com>
Subject: [PATCH 1/2] ceph: normalize 'delta' parameter usage in check_quota_exceeded
Date:   Mon,  6 Apr 2020 16:12:00 +0100
Message-Id: <20200406151201.32432-2-lhenriques@suse.com>
In-Reply-To: <20200406151201.32432-1-lhenriques@suse.com>
References: <20200406151201.32432-1-lhenriques@suse.com>
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
