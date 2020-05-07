Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1AF711C9AA6
	for <lists+ceph-devel@lfdr.de>; Thu,  7 May 2020 21:15:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728526AbgEGTPH (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 7 May 2020 15:15:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:38614 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726320AbgEGTPG (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Thu, 7 May 2020 15:15:06 -0400
Received: from embeddedor (unknown [189.207.59.248])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C6B74208D6;
        Thu,  7 May 2020 19:15:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588878906;
        bh=G6KMEamY18fl3fWqdUXZEPHjZzA7lN73yyBEGPKoCPg=;
        h=Date:From:To:Cc:Subject:From;
        b=eF6nDo0Kauty1qyvRId7Y4Z4Y2qmkPQHPx6M4S3vF4q3FklYUyhJg/jAkPzXchXkN
         wCMK7Ltw8VN3iGt5jOrO0pEllR9K0gqoANqIlUL1PeWjHqYoew1Fy/fPm0cjRdOPVT
         w2cIloaxI+FsLyj6daG9Ohzu5Q/IyP5K2y/lKHzY=
Date:   Thu, 7 May 2020 14:19:32 -0500
From:   "Gustavo A. R. Silva" <gustavoars@kernel.org>
To:     Ilya Dryomov <idryomov@gmail.com>, Sage Weil <sage@redhat.com>
Cc:     Dongsheng Yang <dongsheng.yang@easystack.cn>,
        ceph-devel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] rbd: Replace zero-length array with flexible-array
Message-ID: <20200507191932.GA15991@embeddedor>
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
 drivers/block/rbd_types.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/block/rbd_types.h b/drivers/block/rbd_types.h
index ac98ab6ccd3b..a600e0eb6b6f 100644
--- a/drivers/block/rbd_types.h
+++ b/drivers/block/rbd_types.h
@@ -93,7 +93,7 @@ struct rbd_image_header_ondisk {
 	__le32 snap_count;
 	__le32 reserved;
 	__le64 snap_names_len;
-	struct rbd_image_snap_ondisk snaps[0];
+	struct rbd_image_snap_ondisk snaps[];
 } __attribute__((packed));
 
 

