Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B0EC0B01B6
	for <lists+ceph-devel@lfdr.de>; Wed, 11 Sep 2019 18:37:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728987AbfIKQhh (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 11 Sep 2019 12:37:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:37430 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728896AbfIKQhh (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Wed, 11 Sep 2019 12:37:37 -0400
Received: from tleilax.poochiereds.net (68-20-15-154.lightspeed.rlghnc.sbcglobal.net [68.20.15.154])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 53EE52085B;
        Wed, 11 Sep 2019 16:37:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568219856;
        bh=K1Xwxc3eqP+9N+qqoySr2CEH79W920Ei0wzaqF/GZbE=;
        h=From:To:Cc:Subject:Date:From;
        b=WyAkpsAJMZ98t98IC2UhgIOTm9Q6t1xEOCbbAe1kt5mBurB6zWJakG/0KIXsH4AFt
         pYyMMCOfg1zDGhhDLBOsbd+jiJ33zw83TPwJ4npxbymc4TkKYyFd6vuxicb79VSoYQ
         /Mq+CBvj2dsyUc5XZkq0m/wNIkqIlDyXqlYPbeCM=
From:   Jeff Layton <jlayton@kernel.org>
To:     ceph-devel@vger.kernel.org
Cc:     idryomov@gmail.com
Subject: [PATCH] ceph: clean up error return in ceph_parse_param
Date:   Wed, 11 Sep 2019 12:37:35 -0400
Message-Id: <20190911163735.23351-1-jlayton@kernel.org>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/ceph/super.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Ilya, I'm planning to just squash this into the mount API conversion
patch, unless you have objections.

diff --git a/fs/ceph/super.c b/fs/ceph/super.c
index 5ccaec686eda..2710f9a4a372 100644
--- a/fs/ceph/super.c
+++ b/fs/ceph/super.c
@@ -298,7 +298,7 @@ static int ceph_parse_param(struct fs_context *fc, struct fs_parameter *param)
 		else if (mode == ceph_recover_session_clean)
 			fsopt->flags |= CEPH_MOUNT_OPT_CLEANRECOVER;
 		else
-			return -EINVAL;
+			goto invalid_value;
 		break;
 	case Opt_wsize:
 		if (result.uint_32 < (int)PAGE_SIZE || result.uint_32 > CEPH_MAX_WRITE_SIZE)
-- 
2.21.0

