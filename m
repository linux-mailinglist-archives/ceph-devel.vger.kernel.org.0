Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50DCB2497D4
	for <lists+ceph-devel@lfdr.de>; Wed, 19 Aug 2020 09:58:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726612AbgHSH6A (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 19 Aug 2020 03:58:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:48018 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726861AbgHSH55 (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Wed, 19 Aug 2020 03:57:57 -0400
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E09EE207BB;
        Wed, 19 Aug 2020 07:57:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597823876;
        bh=qVY/Tr2YPJpK284bWpyAgLY0JmZ7NnQxxLDZavUFr3Y=;
        h=From:To:Cc:Subject:Date:From;
        b=Sq/pOTWPOgwCXcev5DyArofi/qfPNVyyLdFUgS01R4cHAu27P8Pp5kusPtaydsRcP
         hAyXEf3rnG7fVYMuR7dC2O5c/4OlfZZcrvZ5bFm3DF/8h6qdr5SQW7CZvSe3Ng2mLS
         WcknwwPh0V5ypA+EMiT9wxkU5Zjh365/ya/SDNm8=
From:   Leon Romanovsky <leon@kernel.org>
To:     Ilya Dryomov <idryomov@gmail.com>, Jeff Layton <jlayton@kernel.org>
Cc:     Leon Romanovsky <leonro@nvidia.com>, ceph-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [RFC PATCH] ceph: Delete features that are not used in the kernel
Date:   Wed, 19 Aug 2020 10:57:47 +0300
Message-Id: <20200819075747.917595-1-leon@kernel.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: Leon Romanovsky <leonro@nvidia.com>

The ceph_features.h has declaration of features that are not in-use
in kernel code. This causes to seeing such compilation warnings in
almost every kernel compilation.

./include/linux/ceph/ceph_features.h:14:24: warning: 'CEPH_FEATURE_UID' defined but not used [-Wunused-const-variable=]
   14 |  static const uint64_t CEPH_FEATURE_##name = (1ULL<<bit);  \
      |                        ^~~~~~~~~~~~~
./include/linux/ceph/ceph_features.h:75:1: note: in expansion of macro 'DEFINE_CEPH_FEATURE'
   75 | DEFINE_CEPH_FEATURE( 0, 1, UID)
      | ^~~~~~~~~~~~~~~~~~~

The upstream kernel indeed doesn't have any use of them, so delete it.

Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
I'm sending this as RFC because probably the patch is wrong, but I
would like to bring your attention to the existing problem and asking
for an acceptable solution.
---
 include/linux/ceph/ceph_features.h | 9 +--------
 1 file changed, 1 insertion(+), 8 deletions(-)

diff --git a/include/linux/ceph/ceph_features.h b/include/linux/ceph/ceph_features.h
index fcd84e8d88f4..922e74c84c76 100644
--- a/include/linux/ceph/ceph_features.h
+++ b/include/linux/ceph/ceph_features.h
@@ -72,13 +72,9 @@
  * the bit ever speak to each other.
  */

-DEFINE_CEPH_FEATURE( 0, 1, UID)
-DEFINE_CEPH_FEATURE( 1, 1, NOSRCADDR)
 DEFINE_CEPH_FEATURE_RETIRED( 2, 1, MONCLOCKCHECK, JEWEL, LUMINOUS)

-DEFINE_CEPH_FEATURE( 3, 1, FLOCK)
 DEFINE_CEPH_FEATURE( 4, 1, SUBSCRIBE2)
-DEFINE_CEPH_FEATURE( 5, 1, MONNAMES)
 DEFINE_CEPH_FEATURE( 6, 1, RECONNECT_SEQ)
 DEFINE_CEPH_FEATURE( 7, 1, DIRLAYOUTHASH)
 DEFINE_CEPH_FEATURE( 8, 1, OBJECTLOCATOR)
@@ -176,10 +172,7 @@ DEFINE_CEPH_FEATURE_DEPRECATED(63, 1, RESERVED_BROKEN, LUMINOUS) // client-facin
  * Features supported.
  */
 #define CEPH_FEATURES_SUPPORTED_DEFAULT		\
-	(CEPH_FEATURE_NOSRCADDR |		\
-	 CEPH_FEATURE_FLOCK |			\
-	 CEPH_FEATURE_SUBSCRIBE2 |		\
-	 CEPH_FEATURE_RECONNECT_SEQ |		\
+	(CEPH_FEATURE_RECONNECT_SEQ |		\
 	 CEPH_FEATURE_DIRLAYOUTHASH |		\
 	 CEPH_FEATURE_PGID64 |			\
 	 CEPH_FEATURE_PGPOOL3 |			\
--
2.26.2

