Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 607C339A25A
	for <lists+ceph-devel@lfdr.de>; Thu,  3 Jun 2021 15:39:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230368AbhFCNlA (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 3 Jun 2021 09:41:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:57064 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229957AbhFCNlA (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Thu, 3 Jun 2021 09:41:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 57FA2613E3;
        Thu,  3 Jun 2021 13:39:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622727555;
        bh=pr8UiRJKFTXvobCQe7pnyvg75oNnyRpmcyT3OmPpDC0=;
        h=From:To:Subject:Date:From;
        b=KXXnpjTiySq49EI9CZCDfB8ZxNNUInLEJnafPXo53AVZGlP9DvZyr4YXJkYLBCBkQ
         fCgfLW1pZTs4TSivRxpzkYkyHnuvM7arLYYj5NsKCxbu3p8JHD4H7BZg980bt5bhf/
         /KCP7Hn+fCIpB+M0oTNZ/J9bfK31KaJNajGrXmaosrVTvDBr3WwExTPL7U3NqEhMqJ
         2JEhTUJ9lFxejmbtCWbzn7KdBrzDHWGa+QK0Ltgt/2RUlpgx3ner3kAKIGm3kgRyWQ
         ecFeq/5hg/Gf5ANXutxcOaT2+CSzEnjJsckV2a2SoBQPr88L0RWY45K8wkTg74UOU5
         rfHhz2/gjLSaA==
From:   Jeff Layton <jlayton@kernel.org>
To:     ceph-devel@vger.kernel.org, idryomov@gmail.com
Subject: [PATCH] ceph: decoding error in ceph_update_snap_realm should return -EIO
Date:   Thu,  3 Jun 2021 09:39:14 -0400
Message-Id: <20210603133914.79072-1-jlayton@kernel.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Currently ceph_update_snap_realm returns -EINVAL when it hits a decoding
error, which is the wrong error code. -EINVAL implies that the user gave
us a bogus argument to a syscall or something similar. -EIO is more
descriptive when we hit a decoding error.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/ceph/snap.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ceph/snap.c b/fs/ceph/snap.c
index d07c1c6ac8fb..f8cac2abab3f 100644
--- a/fs/ceph/snap.c
+++ b/fs/ceph/snap.c
@@ -807,7 +807,7 @@ int ceph_update_snap_trace(struct ceph_mds_client *mdsc,
 	return 0;
 
 bad:
-	err = -EINVAL;
+	err = -EIO;
 fail:
 	if (realm && !IS_ERR(realm))
 		ceph_put_snap_realm(mdsc, realm);
-- 
2.31.1

