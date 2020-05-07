Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 881891C999B
	for <lists+ceph-devel@lfdr.de>; Thu,  7 May 2020 20:47:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728485AbgEGSrN (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 7 May 2020 14:47:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:47650 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726467AbgEGSrN (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Thu, 7 May 2020 14:47:13 -0400
Received: from embeddedor (unknown [189.207.59.248])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 05D1421835;
        Thu,  7 May 2020 18:47:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588877232;
        bh=f+LUv1Y7A4BpaBDHCwe6DTNBpqkkYTWihjXsRz71OLM=;
        h=Date:From:To:Cc:Subject:From;
        b=e54Ef6Dxw35dosckI9n+IIoNelf/NcaMvUZzlp44lRwX+kmktdYylj9TVGR1o1h0Q
         bVAPouqFdqyNXBnlCsTWz9Mu1+aA3bIYB5j2uqIi0J8ABL9wRepsAL9owWSFcnLI+i
         EEU3kC5WCWnCyBmMQ5VykK/HzqNbmiSMImUslmgM=
Date:   Thu, 7 May 2020 13:51:38 -0500
From:   "Gustavo A. R. Silva" <gustavoars@kernel.org>
To:     Ilya Dryomov <idryomov@gmail.com>,
        Jeff Layton <jlayton@kernel.org>, Sage Weil <sage@redhat.com>
Cc:     ceph-devel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] libceph: Replace zero-length array with flexible-array
Message-ID: <20200507185138.GA14076@embeddedor>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

The current codebase makes use of the zero-length array language
extension to the C90 standard, but the preferred mechanism to declare
variable-length types such as these ones is a flexible array member[1][2],
introduced in C99:

struct foo {
        int stuff;
        struct boo array[];
};

By making use of the mechanism above, we will get a compiler warning
in case the flexible array does not occur last in the structure, which
will help us prevent some kind of undefined behavior bugs from being
inadvertently introduced[3] to the codebase from now on.

Also, notice that, dynamic memory allocations won't be affected by
this change:

"Flexible array members have incomplete type, and so the sizeof operator
may not be applied. As a quirk of the original implementation of
zero-length arrays, sizeof evaluates to zero."[1]

sizeof(flexible-array-member) triggers a warning because flexible array
members have incomplete type[1]. There are some instances of code in
which the sizeof operator is being incorrectly/erroneously applied to
zero-length arrays and the result is zero. Such instances may be hiding
some bugs. So, this work (flexible-array member conversions) will also
help to get completely rid of those sorts of issues.

This issue was found with the help of Coccinelle.

[1] https://gcc.gnu.org/onlinedocs/gcc/Zero-Length.html
[2] https://github.com/KSPP/linux/issues/21
[3] commit 76497732932f ("cxgb3/l2t: Fix undefined behaviour")

Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
---
 include/linux/ceph/mon_client.h |    2 +-
 include/linux/crush/crush.h     |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/ceph/mon_client.h b/include/linux/ceph/mon_client.h
index dbb8a6959a73..ce4ffeb384d7 100644
--- a/include/linux/ceph/mon_client.h
+++ b/include/linux/ceph/mon_client.h
@@ -19,7 +19,7 @@ struct ceph_monmap {
 	struct ceph_fsid fsid;
 	u32 epoch;
 	u32 num_mon;
-	struct ceph_entity_inst mon_inst[0];
+	struct ceph_entity_inst mon_inst[];
 };
 
 struct ceph_mon_client;
diff --git a/include/linux/crush/crush.h b/include/linux/crush/crush.h
index 54741295c70b..38b0e4d50ed9 100644
--- a/include/linux/crush/crush.h
+++ b/include/linux/crush/crush.h
@@ -87,7 +87,7 @@ struct crush_rule_mask {
 struct crush_rule {
 	__u32 len;
 	struct crush_rule_mask mask;
-	struct crush_rule_step steps[0];
+	struct crush_rule_step steps[];
 };
 
 #define crush_rule_size(len) (sizeof(struct crush_rule) + \

