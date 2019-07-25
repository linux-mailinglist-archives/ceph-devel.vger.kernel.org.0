Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 51EB774CC0
	for <lists+ceph-devel@lfdr.de>; Thu, 25 Jul 2019 13:18:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403954AbfGYLRx (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 25 Jul 2019 07:17:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:35246 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2403937AbfGYLRw (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Thu, 25 Jul 2019 07:17:52 -0400
Received: from tleilax.poochiereds.net (cpe-71-70-156-158.nc.res.rr.com [71.70.156.158])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0977522C7C
        for <ceph-devel@vger.kernel.org>; Thu, 25 Jul 2019 11:17:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564053471;
        bh=nKQjK1cDtcuHgj15t4oylW6j00yCaUqjRE68OCDtsnA=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=nPTrA6ZDq+1KW+p02rt+o0CHrIMzF8zKEBq/t5s+erAfW1BK2CYj3FFTXxv/5fQSc
         HpgfHL3eWZ6httUMhqEcGD/jvVYZbSrGMkiiCj6UrBNe575TgA8OJurIJZilrFzo+z
         aA1uMDAMPncUFZho95B+Tn3sBxa9XJUiUWxWbXuY=
From:   Jeff Layton <jlayton@kernel.org>
To:     ceph-devel@vger.kernel.org
Subject: [PATCH 6/8] ceph: remove unneeded test in try_flush_caps
Date:   Thu, 25 Jul 2019 07:17:44 -0400
Message-Id: <20190725111746.10393-7-jlayton@kernel.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190725111746.10393-1-jlayton@kernel.org>
References: <20190725111746.10393-1-jlayton@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

cap->session is always non-NULL, so we can just do a single test for
equality w/o testing explicitly for a NULL pointer.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/ceph/caps.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
index 6b8300d72cac..bb91abaf7559 100644
--- a/fs/ceph/caps.c
+++ b/fs/ceph/caps.c
@@ -2114,7 +2114,7 @@ static int try_flush_caps(struct inode *inode, u64 *ptid)
 		struct ceph_cap *cap = ci->i_auth_cap;
 		int delayed;
 
-		if (!session || session != cap->session) {
+		if (session != cap->session) {
 			spin_unlock(&ci->i_ceph_lock);
 			if (session)
 				mutex_unlock(&session->s_mutex);
-- 
2.21.0

