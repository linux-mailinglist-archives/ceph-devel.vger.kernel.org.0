Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 09E2838F37
	for <lists+ceph-devel@lfdr.de>; Fri,  7 Jun 2019 17:38:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729822AbfFGPiU (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 7 Jun 2019 11:38:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:48168 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728247AbfFGPiT (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Fri, 7 Jun 2019 11:38:19 -0400
Received: from tleilax.poochiereds.net (cpe-71-70-156-158.nc.res.rr.com [71.70.156.158])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C58FB2146F;
        Fri,  7 Jun 2019 15:38:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559921899;
        bh=W/1nNP043GIFmko2NoTM4G0lEwx1P5uyXRRnd+gW9ZM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HCbfhfo142NL9o1AZnV9CMGk6GyDAi6JMcergl85AQk8XxSOkoIHxJ0FNy5SP/MbN
         iM2JKocPtXuOEoDfc5Xmly4T/pDikAgPQKg/9fY4lcvOD0xHzqW1uxFgwCeulWhz/H
         nWqCzNFPIj1IrYPiCEp43mbMjoldwxSFI7Opz+8w=
From:   Jeff Layton <jlayton@kernel.org>
To:     idryomov@redhat.com, zyan@redhat.com, sage@redhat.com
Cc:     ceph-devel@vger.kernel.org, dev@ceph.io
Subject: [PATCH 01/16] libceph: fix sa_family just after reading address
Date:   Fri,  7 Jun 2019 11:38:01 -0400
Message-Id: <20190607153816.12918-2-jlayton@kernel.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190607153816.12918-1-jlayton@kernel.org>
References: <20190607153816.12918-1-jlayton@kernel.org>
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

