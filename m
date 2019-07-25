Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E238474CBD
	for <lists+ceph-devel@lfdr.de>; Thu, 25 Jul 2019 13:18:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403932AbfGYLRv (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 25 Jul 2019 07:17:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:35240 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2403918AbfGYLRu (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Thu, 25 Jul 2019 07:17:50 -0400
Received: from tleilax.poochiereds.net (cpe-71-70-156-158.nc.res.rr.com [71.70.156.158])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EF52C22C7C
        for <ceph-devel@vger.kernel.org>; Thu, 25 Jul 2019 11:17:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564053469;
        bh=n4F7qRXOj0Z68P8NoocgpSboVcZ2sy0QDBfZsaWy0sk=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=OKrPISR/Vd/53U/ohHk+jB1AbozOuIZRTeoMh1mDtRDHodOusnP3AL7af4cYvmnoq
         ekk2175gcHN2Mf3oJbppQfQQY1/7JEcCMUwBaMJO5yxhd2q25CiS40UdUHw45BFK8x
         RiG+OK4uFeNN6dAgsBxN+vWYI3Z3RTO3LqhQGnn8=
From:   Jeff Layton <jlayton@kernel.org>
To:     ceph-devel@vger.kernel.org
Subject: [PATCH 2/8] ceph: fetch cap_gen under spinlock in ceph_add_cap
Date:   Thu, 25 Jul 2019 07:17:40 -0400
Message-Id: <20190725111746.10393-3-jlayton@kernel.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190725111746.10393-1-jlayton@kernel.org>
References: <20190725111746.10393-1-jlayton@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

It's protected by the s_gen_ttl_lock, so we should fetch under it
and ensure that we're using the same generation in both places.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/ceph/caps.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
index 4615f2501e15..bdfec8978479 100644
--- a/fs/ceph/caps.c
+++ b/fs/ceph/caps.c
@@ -614,6 +614,7 @@ void ceph_add_cap(struct inode *inode,
 	struct ceph_cap *cap;
 	int mds = session->s_mds;
 	int actual_wanted;
+	u32 gen;
 
 	dout("add_cap %p mds%d cap %llx %s seq %d\n", inode,
 	     session->s_mds, cap_id, ceph_cap_string(issued), seq);
@@ -625,6 +626,10 @@ void ceph_add_cap(struct inode *inode,
 	if (fmode >= 0)
 		wanted |= ceph_caps_for_mode(fmode);
 
+	spin_lock(&session->s_gen_ttl_lock);
+	gen = session->s_cap_gen;
+	spin_unlock(&session->s_gen_ttl_lock);
+
 	cap = __get_cap_for_mds(ci, mds);
 	if (!cap) {
 		cap = *new_cap;
@@ -650,7 +655,7 @@ void ceph_add_cap(struct inode *inode,
 		list_move_tail(&cap->session_caps, &session->s_caps);
 		spin_unlock(&session->s_cap_lock);
 
-		if (cap->cap_gen < session->s_cap_gen)
+		if (cap->cap_gen < gen)
 			cap->issued = cap->implemented = CEPH_CAP_PIN;
 
 		/*
@@ -744,7 +749,7 @@ void ceph_add_cap(struct inode *inode,
 	cap->seq = seq;
 	cap->issue_seq = seq;
 	cap->mseq = mseq;
-	cap->cap_gen = session->s_cap_gen;
+	cap->cap_gen = gen;
 
 	if (fmode >= 0)
 		__ceph_get_fmode(ci, fmode);
-- 
2.21.0

