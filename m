Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 90A6A7FF79
	for <lists+ceph-devel@lfdr.de>; Fri,  2 Aug 2019 19:23:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404697AbfHBRXi (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 2 Aug 2019 13:23:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:43398 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404689AbfHBRXi (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Fri, 2 Aug 2019 13:23:38 -0400
Received: from tleilax.poochiereds.net (cpe-71-70-156-158.nc.res.rr.com [71.70.156.158])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A8B682087E;
        Fri,  2 Aug 2019 17:23:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564766617;
        bh=yCeECBwhIK+I5qomUrtXtapHaNHA/aVK6Eh245VuMsE=;
        h=From:To:Cc:Subject:Date:From;
        b=JQiIh5Y0TNgYhr1d/8x7HJvKRVbCpPex6BIXvI7cR3ORw1feWQofV4iVxKAo+CMTX
         8J9sP9+vL7WghVASn3F8gIhC9DFl6LoGXAOwfqHFnIoKaWi6JwsEHyp3pk+YfYfo5F
         62xThIUfyDB7AGmfks8hQ8JHFXtUDQr/cIi83Z6w=
From:   Jeff Layton <jlayton@kernel.org>
To:     ceph-devel@vger.kernel.org
Cc:     idryomov@gmail.com, sage@redhat.com
Subject: [PATCH] ceph: undefine pr_fmt before redefining it
Date:   Fri,  2 Aug 2019 13:23:35 -0400
Message-Id: <20190802172335.24553-1-jlayton@kernel.org>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

The preprocessor throws a warning here in some cases:

In file included from fs/ceph/super.h:5,
                 from fs/ceph/io.c:16:
./include/linux/ceph/ceph_debug.h:5: warning: "pr_fmt" redefined
    5 | #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
      |
In file included from ./include/linux/kernel.h:15,
                 from fs/ceph/io.c:12:
./include/linux/printk.h:288: note: this is the location of the previous definition
  288 | #define pr_fmt(fmt) fmt
      |

Since we do mean to redefine it, make that explicit by undefining it
first.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 include/linux/ceph/ceph_debug.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/linux/ceph/ceph_debug.h b/include/linux/ceph/ceph_debug.h
index d5a5da838caf..fa4a84e0e018 100644
--- a/include/linux/ceph/ceph_debug.h
+++ b/include/linux/ceph/ceph_debug.h
@@ -2,6 +2,7 @@
 #ifndef _FS_CEPH_DEBUG_H
 #define _FS_CEPH_DEBUG_H
 
+#undef pr_fmt
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
 #include <linux/string.h>
-- 
2.21.0

