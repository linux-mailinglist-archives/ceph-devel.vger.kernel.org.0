Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6985E13782D
	for <lists+ceph-devel@lfdr.de>; Fri, 10 Jan 2020 21:56:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727198AbgAJU4x (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 10 Jan 2020 15:56:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:49002 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727185AbgAJU4w (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Fri, 10 Jan 2020 15:56:52 -0500
Received: from tleilax.com (68-20-15-154.lightspeed.rlghnc.sbcglobal.net [68.20.15.154])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F3B7E208E4;
        Fri, 10 Jan 2020 20:56:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578689812;
        bh=eEWtNHpih/MwlKZ7fbM8LrbCsGwlBIp35lKUOA5C4L4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xaay4d1q1mmXnCdBH0qgU9SKtErRuzONcxU0/8JIlHaJHkGF++pxj6pxJJtJtJNel
         ZvQQidhVnMMgGBXlyAnjh/SBfECU8el4F0wdxPBFHy9+JylG7wTjDRed1+wu/HJetQ
         5JeoKltXwUQbZZJ0ZegLb8pQoX+ZsDgvXoUwRckE=
From:   Jeff Layton <jlayton@kernel.org>
To:     ceph-devel@vger.kernel.org
Cc:     zyan@redhat.com, sage@redhat.com, idryomov@gmail.com,
        pdonnell@redhat.com
Subject: [RFC PATCH 3/9] ceph: close some holes in struct ceph_mds_request
Date:   Fri, 10 Jan 2020 15:56:41 -0500
Message-Id: <20200110205647.311023-4-jlayton@kernel.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200110205647.311023-1-jlayton@kernel.org>
References: <20200110205647.311023-1-jlayton@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/ceph/mds_client.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ceph/mds_client.h b/fs/ceph/mds_client.h
index df18a29f9587..27a7446e10d3 100644
--- a/fs/ceph/mds_client.h
+++ b/fs/ceph/mds_client.h
@@ -234,6 +234,7 @@ struct ceph_mds_request {
 	struct rb_node r_node;
 	struct ceph_mds_client *r_mdsc;
 
+	struct kref       r_kref;
 	int r_op;                    /* mds op code */
 
 	/* operation on what? */
@@ -304,7 +305,6 @@ struct ceph_mds_request {
 	int               r_resend_mds; /* mds to resend to next, if any*/
 	u32               r_sent_on_mseq; /* cap mseq request was sent at*/
 
-	struct kref       r_kref;
 	struct list_head  r_wait;
 	struct completion r_completion;
 	struct completion r_safe_completion;
-- 
2.24.1

