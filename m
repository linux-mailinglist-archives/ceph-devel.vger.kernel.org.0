Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3FE9A15C813
	for <lists+ceph-devel@lfdr.de>; Thu, 13 Feb 2020 17:26:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728261AbgBMQSX (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 13 Feb 2020 11:18:23 -0500
Received: from gateway24.websitewelcome.com ([192.185.51.202]:49874 "EHLO
        gateway24.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727725AbgBMQSW (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Thu, 13 Feb 2020 11:18:22 -0500
X-Greylist: delayed 1246 seconds by postgrey-1.27 at vger.kernel.org; Thu, 13 Feb 2020 11:18:22 EST
Received: from cm12.websitewelcome.com (cm12.websitewelcome.com [100.42.49.8])
        by gateway24.websitewelcome.com (Postfix) with ESMTP id 80AF110AB93
        for <ceph-devel@vger.kernel.org>; Thu, 13 Feb 2020 09:57:36 -0600 (CST)
Received: from gator4166.hostgator.com ([108.167.133.22])
        by cmsmtp with SMTP
        id 2GrwjMCj9vBMd2GrwjKhB2; Thu, 13 Feb 2020 09:57:36 -0600
X-Authority-Reason: nr=8
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=embeddedor.com; s=default; h=Content-Type:MIME-Version:Message-ID:Subject:
        Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=Um+rb49HzTPy3aKPHN4PPBR2MnF7JZXlZxEpVoL80Og=; b=Xcayo0azDhxE8evk6zOzISkC+a
        UscPK1V/D7cNNgwGTSzhFGcAR6B2WrjvRP93mpb1Fsqi39h5TwWNN7kYUxsA9xxk2jTF4oe+m+KCH
        9OpmMN246fJjGVFyIIuuhA1sncn0YcQZQawhW6nwozqMMX601tRPFklDF9QfWDzV0Fp9cKDew2DLf
        1KfjoNGmHVAxdn32wiwQrlGG1Y8/wuSTQdicz+Xsnd5vlxfck+R99EWzPCxVlIMbEdFj7CBrBPbiy
        iD9Obr+ZVl2DYbXVsAwUr2fjAvZcRZIVvallDEYMJQIxw4Y9pqerWkoVFamVJrjKPGcVQK8XTe+6V
        texiosAA==;
Received: from [200.68.140.15] (port=18357 helo=embeddedor)
        by gator4166.hostgator.com with esmtpa (Exim 4.92)
        (envelope-from <gustavo@embeddedor.com>)
        id 1j2Gru-003WPh-M4; Thu, 13 Feb 2020 09:57:34 -0600
Date:   Thu, 13 Feb 2020 10:00:04 -0600
From:   "Gustavo A. R. Silva" <gustavo@embeddedor.com>
To:     Jeff Layton <jlayton@kernel.org>, Sage Weil <sage@redhat.com>,
        Ilya Dryomov <idryomov@gmail.com>
Cc:     ceph-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Subject: [PATCH] ceph: cache: Replace zero-length array with flexible-array
 member
Message-ID: <20200213160004.GA4334@embeddedor>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.9.4 (2018-02-28)
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - gator4166.hostgator.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - embeddedor.com
X-BWhitelist: no
X-Source-IP: 200.68.140.15
X-Source-L: No
X-Exim-ID: 1j2Gru-003WPh-M4
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: (embeddedor) [200.68.140.15]:18357
X-Source-Auth: gustavo@embeddedor.com
X-Email-Count: 34
X-Source-Cap: Z3V6aWRpbmU7Z3V6aWRpbmU7Z2F0b3I0MTY2Lmhvc3RnYXRvci5jb20=
X-Local-Domain: yes
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

This issue was found with the help of Coccinelle.

[1] https://gcc.gnu.org/onlinedocs/gcc/Zero-Length.html
[2] https://github.com/KSPP/linux/issues/21
[3] commit 76497732932f ("cxgb3/l2t: Fix undefined behaviour")

Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
---
 fs/ceph/cache.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ceph/cache.c b/fs/ceph/cache.c
index 270b769607a2..2f5cb6bc78e1 100644
--- a/fs/ceph/cache.c
+++ b/fs/ceph/cache.c
@@ -32,7 +32,7 @@ struct ceph_fscache_entry {
 	size_t uniq_len;
 	/* The following members must be last */
 	struct ceph_fsid fsid;
-	char uniquifier[0];
+	char uniquifier[];
 };
 
 static const struct fscache_cookie_def ceph_fscache_fsid_object_def = {
-- 
2.25.0

