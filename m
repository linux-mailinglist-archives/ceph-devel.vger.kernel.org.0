Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E09362AF151
	for <lists+ceph-devel@lfdr.de>; Wed, 11 Nov 2020 13:56:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726494AbgKKM4t (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 11 Nov 2020 07:56:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:52082 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725909AbgKKM4t (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Wed, 11 Nov 2020 07:56:49 -0500
Received: from tleilax.com (68-20-15-154.lightspeed.rlghnc.sbcglobal.net [68.20.15.154])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D0F7C20709
        for <ceph-devel@vger.kernel.org>; Wed, 11 Nov 2020 12:56:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605099409;
        bh=RqAqdiQ68SibPyGOG4GVVNatVQalikvi1jKSklcjysE=;
        h=From:To:Subject:Date:From;
        b=FfAsdIrQXVlxvp9Joa3Th7P6iH9ey3E+Vfd+fApPJ/PjZp1diGd9ftok2sSqnyytw
         p/bRTISPQXQVeUkUzq33ojF80AjPVCdJmh//uzr8J9HylYAh4s2C2+6s+V5hNRv16K
         6pgIcBUazVMmXrGgxc9+f7ClejOnCY08wy204OO8=
From:   Jeff Layton <jlayton@kernel.org>
To:     ceph-devel@vger.kernel.org
Subject: [PATCH] ceph: pass down the flags to grab_cache_page_write_begin
Date:   Wed, 11 Nov 2020 07:56:47 -0500
Message-Id: <20201111125647.21528-1-jlayton@kernel.org>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

write_begin operations are passed a flags parameter that we need to
mirror here, so that we don't (e.g.) recurse back into filesystem code
inappropriately.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/ceph/addr.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
index e10b07edc95c..950552944436 100644
--- a/fs/ceph/addr.c
+++ b/fs/ceph/addr.c
@@ -1321,7 +1321,7 @@ static int ceph_write_begin(struct file *file, struct address_space *mapping,
 	dout("write_begin file %p inode %p page %p %d~%d\n", file, inode, page, (int)pos, (int)len);
 
 	for (;;) {
-		page = grab_cache_page_write_begin(mapping, index, 0);
+		page = grab_cache_page_write_begin(mapping, index, flags);
 		if (!page) {
 			r = -ENOMEM;
 			break;
-- 
2.28.0

