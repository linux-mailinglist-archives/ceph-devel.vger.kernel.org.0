Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DFF8113782C
	for <lists+ceph-devel@lfdr.de>; Fri, 10 Jan 2020 21:56:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727184AbgAJU4w (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 10 Jan 2020 15:56:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:48970 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727164AbgAJU4v (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Fri, 10 Jan 2020 15:56:51 -0500
Received: from tleilax.com (68-20-15-154.lightspeed.rlghnc.sbcglobal.net [68.20.15.154])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8132B2087F;
        Fri, 10 Jan 2020 20:56:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578689811;
        bh=oCUuYbQaFi5p1T2ivCv5JrvcqbXEd1/r5JsNLjvdcTk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Mh7UqOZUTizysmqyp+9KZ2WAAYKtux2EK7uTHr/8pa//+SryngMDLALN+h5z8zilQ
         oCL45YPnr658NtayFAS9EHt+VgO68NylVio00PgfUbg8CVavP53xec16vI15Hdpm4l
         TSgkso+/fXI7GP8nVytOj2rJCs+OtLnXRuqb0bPc=
From:   Jeff Layton <jlayton@kernel.org>
To:     ceph-devel@vger.kernel.org
Cc:     zyan@redhat.com, sage@redhat.com, idryomov@gmail.com,
        pdonnell@redhat.com
Subject: [RFC PATCH 1/9] ceph: ensure we have a new cap before continuing in fill_inode
Date:   Fri, 10 Jan 2020 15:56:39 -0500
Message-Id: <20200110205647.311023-2-jlayton@kernel.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200110205647.311023-1-jlayton@kernel.org>
References: <20200110205647.311023-1-jlayton@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

If the caller passes in a NULL cap_reservation, and we can't allocate
one then ensure that we fail gracefully.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/ceph/inode.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
index ffef475af72b..aee7a24bf1bc 100644
--- a/fs/ceph/inode.c
+++ b/fs/ceph/inode.c
@@ -756,8 +756,11 @@ static int fill_inode(struct inode *inode, struct page *locked_page,
 	info_caps = le32_to_cpu(info->cap.caps);
 
 	/* prealloc new cap struct */
-	if (info_caps && ceph_snap(inode) == CEPH_NOSNAP)
+	if (info_caps && ceph_snap(inode) == CEPH_NOSNAP) {
 		new_cap = ceph_get_cap(mdsc, caps_reservation);
+		if (!new_cap)
+			return -ENOMEM;
+	}
 
 	/*
 	 * prealloc xattr data, if it looks like we'll need it.  only
-- 
2.24.1

