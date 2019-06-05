Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5082335D8C
	for <lists+ceph-devel@lfdr.de>; Wed,  5 Jun 2019 15:11:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727964AbfFENLG (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 5 Jun 2019 09:11:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:59434 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727941AbfFENLF (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Wed, 5 Jun 2019 09:11:05 -0400
Received: from tleilax.poochiereds.net (cpe-71-70-156-158.nc.res.rr.com [71.70.156.158])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5D384206DF;
        Wed,  5 Jun 2019 13:11:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559740264;
        bh=W/1nNP043GIFmko2NoTM4G0lEwx1P5uyXRRnd+gW9ZM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=V00EeiOInYlgqzAnzo6IBDSUUYxVOJjmVOcarcWx7AvZuzES1ozsYyB3/OFXZ81ml
         N+PNrtzDQa3mJTm1kBupBPrkNKUooYHnaZj58rQ4uAF/YxtaP3H6YOIdhLUNVMlWVO
         tQS6ENs51Iuqt1+LotX5G4YorRlhWFc2hChfF2kE=
From:   Jeff Layton <jlayton@kernel.org>
To:     ceph-devel@vger.kernel.org
Cc:     idryomov@redhat.com, zyan@redhat.com, sage@redhat.com
Subject: [RFC PATCH 1/9] libceph: fix sa_family just after reading address
Date:   Wed,  5 Jun 2019 09:10:54 -0400
Message-Id: <20190605131102.13529-2-jlayton@kernel.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190605131102.13529-1-jlayton@kernel.org>
References: <20190605131102.13529-1-jlayton@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

It doesn't make sense to leave it undecoded until later.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 net/ceph/messenger.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/net/ceph/messenger.c b/net/ceph/messenger.c
index 3ee380758ddd..a25e71fa8124 100644
--- a/net/ceph/messenger.c
+++ b/net/ceph/messenger.c
@@ -1732,12 +1732,14 @@ static int read_partial_banner(struct ceph_connection *con)
 	ret = read_partial(con, end, size, &con->actual_peer_addr);
 	if (ret <= 0)
 		goto out;
+	ceph_decode_addr(&con->actual_peer_addr);
 
 	size = sizeof (con->peer_addr_for_me);
 	end += size;
 	ret = read_partial(con, end, size, &con->peer_addr_for_me);
 	if (ret <= 0)
 		goto out;
+	ceph_decode_addr(&con->peer_addr_for_me);
 
 out:
 	return ret;
@@ -2010,9 +2012,6 @@ static int process_banner(struct ceph_connection *con)
 	if (verify_hello(con) < 0)
 		return -1;
 
-	ceph_decode_addr(&con->actual_peer_addr);
-	ceph_decode_addr(&con->peer_addr_for_me);
-
 	/*
 	 * Make sure the other end is who we wanted.  note that the other
 	 * end may not yet know their ip address, so if it's 0.0.0.0, give
-- 
2.21.0

