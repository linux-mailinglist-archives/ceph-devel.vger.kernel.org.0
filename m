Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 74C1223BE27
	for <lists+ceph-devel@lfdr.de>; Tue,  4 Aug 2020 18:32:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729472AbgHDQcB (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 4 Aug 2020 12:32:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:38782 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726027AbgHDQcA (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Tue, 4 Aug 2020 12:32:00 -0400
Received: from tleilax.com (68-20-15-154.lightspeed.rlghnc.sbcglobal.net [68.20.15.154])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B4B70208A9;
        Tue,  4 Aug 2020 16:31:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596558720;
        bh=BaAGDHAbBr+iHu3pSFTSG88KjntsdEBSuHJYo38G694=;
        h=From:To:Cc:Subject:Date:From;
        b=jU418mjGgo92JYHEblpMKPxccotMXgC4rB7si33M9riTyKZGi2kw4619NCleM69qW
         VXyKiG5kabIvsg1YGi44ygHvAn0x1N2W749XwGB+g74A69buVwpFi9JPFenOuPZb1f
         fc6tBixVDOaIZqZ7BzUOvmPbLxEi9ad2NQ57ec8w=
From:   Jeff Layton <jlayton@kernel.org>
To:     ceph-devel@vger.kernel.org
Cc:     idryomov@gmail.com, edward6@linux.ibm.com, pdonnell@redhat.com
Subject: [PATCH] ceph: handle zero-length feature mask in session messages
Date:   Tue,  4 Aug 2020 12:31:56 -0400
Message-Id: <20200804163156.314711-1-jlayton@kernel.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Most session messages contain a feature mask, but the MDS will routinely
send a REJECT message with one that is zero-length.

Commit 0fa8263367db (ceph: fix endianness bug when handling MDS session
feature bits) fixed the decoding of the feature mask, but failed to
account for the MDS sending a zero-length feature mask. This causes
REJECT message decoding to fail.

Skip trying to decode a feature mask if the word count is zero.

Cc: stable@vger.kernel.org # v5.7.x: 0fa8263367db: ceph: fix endianness bug when handling MDS session feature bits
Fixes: 0fa8263367db (ceph: fix endianness bug when handling MDS session feature bits)
URL: https://tracker.ceph.com/issues/46823
Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/ceph/mds_client.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
index 1095802ad9bd..4a26862d7667 100644
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -3358,8 +3358,10 @@ static void handle_session(struct ceph_mds_session *session,
 			goto bad;
 		/* version >= 3, feature bits */
 		ceph_decode_32_safe(&p, end, len, bad);
-		ceph_decode_64_safe(&p, end, features, bad);
-		p += len - sizeof(features);
+		if (len) {
+			ceph_decode_64_safe(&p, end, features, bad);
+			p += len - sizeof(features);
+		}
 	}
 
 	mutex_lock(&mdsc->mutex);
-- 
2.26.2

