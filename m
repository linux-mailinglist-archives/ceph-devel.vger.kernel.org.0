Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E3AA15678C
	for <lists+ceph-devel@lfdr.de>; Wed, 26 Jun 2019 13:26:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726242AbfFZL0g (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 26 Jun 2019 07:26:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:33710 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726077AbfFZL0g (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Wed, 26 Jun 2019 07:26:36 -0400
Received: from tleilax.poochiereds.net (cpe-71-70-156-158.nc.res.rr.com [71.70.156.158])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 97F252080C;
        Wed, 26 Jun 2019 11:26:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561548395;
        bh=OIl1wVPMn+sQwxu8nb6ZglvHM4z1+uE/DqfXgi9tTwI=;
        h=From:To:Cc:Subject:Date:From;
        b=hJV4SBaphFgNG2QfDbq/9pJOLk3HSBUUxmQOSwNDe9hTT3kTpQFZhoTPRC1a96q4O
         3Rrl98CrLpiAUCTdpUWMetKppyqeGgKt0pxGJr0rzs1Ty/T+Q4841E1D4lQNyj9vHe
         GiELPGHfoZ+PT1jHWaasvVffYK1g3bKXIOIN/dUY=
From:   Jeff Layton <jlayton@kernel.org>
To:     zyan@redhat.com, idryomov@gmail.com, sage@redhat.com
Cc:     ceph-devel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] MAINTAINERS: take over for Zheng as CephFS kernel client maintainer
Date:   Wed, 26 Jun 2019 07:26:33 -0400
Message-Id: <20190626112633.12267-1-jlayton@kernel.org>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Zheng wants to be able to spend more time working on the MDS, so I've
volunteered to take over for him as the CephFS kernel client maintainer.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 MAINTAINERS | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Zheng, I'm assuming for now that you don't want to stay on as
co-maintainer. Let me know if that's incorrect and I'll resend.

diff --git a/MAINTAINERS b/MAINTAINERS
index d0ed735994a5..8836f9eb2ff0 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3715,7 +3715,7 @@ F:	arch/powerpc/platforms/cell/
 
 CEPH COMMON CODE (LIBCEPH)
 M:	Ilya Dryomov <idryomov@gmail.com>
-M:	"Yan, Zheng" <zyan@redhat.com>
+M:	Jeff Layton <jlayton@kernel.org>
 M:	Sage Weil <sage@redhat.com>
 L:	ceph-devel@vger.kernel.org
 W:	http://ceph.com/
@@ -3727,7 +3727,7 @@ F:	include/linux/ceph/
 F:	include/linux/crush/
 
 CEPH DISTRIBUTED FILE SYSTEM CLIENT (CEPH)
-M:	"Yan, Zheng" <zyan@redhat.com>
+M:	Jeff Layton <jlayton@kernel.org>
 M:	Sage Weil <sage@redhat.com>
 M:	Ilya Dryomov <idryomov@gmail.com>
 L:	ceph-devel@vger.kernel.org
-- 
2.21.0

