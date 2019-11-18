Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E673A1006A3
	for <lists+ceph-devel@lfdr.de>; Mon, 18 Nov 2019 14:38:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727143AbfKRNih (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 18 Nov 2019 08:38:37 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:41525 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727116AbfKRNih (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 18 Nov 2019 08:38:37 -0500
Received: by mail-wr1-f68.google.com with SMTP id b18so18080156wrj.8
        for <ceph-devel@vger.kernel.org>; Mon, 18 Nov 2019 05:38:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=8wVtUNfAxf4ws8vN+2mG/0+RfbKXt8lofWvUcvct5i4=;
        b=NiDKLn5EjrPBp8toseUUl0tCT+E/Um00W8Ac6ZOxIGYKQ7fsA3/O29fzcei6CjoC3d
         GhftGGJ8RWRxZFdqd7iTUgaQZfaCtMDqTGBGA0nMkKFZjI19LRNOZP68CMYz4Ddv36Uc
         romCJ55i4ZNt/R1uaMmj/v/w4wN1jkaWu1u8pvGE/dgYE/B/s+udQN5NU8ZM7YndF7S2
         UWYs9grwSx/mMDMUT+OUNVtkyPPDQv7R6cqfyUOZlIKsh2LgxnWtdvurAlkmZOgfY3BG
         zxyBa/1KLkJhWlmraBPXeXC9Ys4UEeji1HT2+k4Jn2XsANWw0Qe4UacWgYkHvvQ2EIME
         +XJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=8wVtUNfAxf4ws8vN+2mG/0+RfbKXt8lofWvUcvct5i4=;
        b=OItrkp21taFG74GbnLJklsH0N5w0ama6RZmuw9Ek3KnPga230zGj6sbYCvj3mGOT0k
         cCStr5AM7DWhiB+Mk65iq6On1iYsg4H/XVAodwenU9nPOQU+cq7H3uFPlqCg6YzjBiGK
         qRHOEMxSbkxIZa2nzW6Th3FU0c3vdZdGsmqWr8lyuWF6ZY2f2f2orz5rdcTMYejn80EI
         RSrEEmsK4sp/oHlNdKKD7efmVG4+mk+HFJhMI081ECum08Su738nSHfAZYtbilwzdMpz
         oWHNmrsb1SJnmSqjMqDp3Mzg5U7Mb5vi9cR2vZvLCzO2WVhuq7Ca8srCAGcaIsboK6/u
         EGXw==
X-Gm-Message-State: APjAAAX6o4fdacVGJNzR4cw6nA4u8nksY2V+3SEJaz2qpQmDWCSA6dwE
        iCWjs3ESTzSjsE7FH+T1OeIOh0B+
X-Google-Smtp-Source: APXvYqzz/hBGP1+3MMV/P5jvmS78xd+FFc9JRkT60fK6JOhVrK+sjZKlnlWDdS4FiV5n/jcGpn5fgg==
X-Received: by 2002:adf:e40e:: with SMTP id g14mr32141649wrm.264.1574084315050;
        Mon, 18 Nov 2019 05:38:35 -0800 (PST)
Received: from kwango.local (ip-94-112-128-92.net.upcbroadband.cz. [94.112.128.92])
        by smtp.gmail.com with ESMTPSA id t133sm24670242wmb.1.2019.11.18.05.38.34
        for <ceph-devel@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Nov 2019 05:38:34 -0800 (PST)
From:   Ilya Dryomov <idryomov@gmail.com>
To:     ceph-devel@vger.kernel.org
Subject: [PATCH 7/9] rbd: remove snapshot existence validation code
Date:   Mon, 18 Nov 2019 14:38:14 +0100
Message-Id: <20191118133816.3963-8-idryomov@gmail.com>
X-Mailer: git-send-email 2.19.2
In-Reply-To: <20191118133816.3963-1-idryomov@gmail.com>
References: <20191118133816.3963-1-idryomov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

RBD_DEV_FLAG_EXISTS check in rbd_queue_workfn() is racy and leads to
inconsistent behaviour.  If the object (or its snapshot) isn't there,
the OSD returns ENOENT.  A read submitted before the snapshot removal
notification is processed would be zero-filled and ended with status
OK, while future reads would be failed with IOERR.  It also doesn't
handle a case when an image that is mapped read-only is removed.

On top of this, because watch is no longer established for read-only
mappings, we no longer get notifications, so rbd_exists_validate() is
effectively dead code.  While failing requests rather than returning
zeros is a good thing, RBD_DEV_FLAG_EXISTS is not it.

Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
---
 drivers/block/rbd.c | 42 +++---------------------------------------
 1 file changed, 3 insertions(+), 39 deletions(-)

diff --git a/drivers/block/rbd.c b/drivers/block/rbd.c
index bfff195e8e23..aba60e37b058 100644
--- a/drivers/block/rbd.c
+++ b/drivers/block/rbd.c
@@ -462,7 +462,7 @@ struct rbd_device {
  *   by rbd_dev->lock
  */
 enum rbd_dev_flags {
-	RBD_DEV_FLAG_EXISTS,	/* mapped snapshot has not been deleted */
+	RBD_DEV_FLAG_EXISTS,	/* rbd_dev_device_setup() ran */
 	RBD_DEV_FLAG_REMOVING,	/* this mapping is being removed */
 	RBD_DEV_FLAG_READONLY,  /* -o ro or snapshot */
 };
@@ -4848,19 +4848,6 @@ static void rbd_queue_workfn(struct work_struct *work)
 		rbd_assert(!rbd_is_snap(rbd_dev));
 	}
 
-	/*
-	 * Quit early if the mapped snapshot no longer exists.  It's
-	 * still possible the snapshot will have disappeared by the
-	 * time our request arrives at the osd, but there's no sense in
-	 * sending it if we already know.
-	 */
-	if (!test_bit(RBD_DEV_FLAG_EXISTS, &rbd_dev->flags)) {
-		dout("request for non-existent snapshot");
-		rbd_assert(rbd_is_snap(rbd_dev));
-		result = -ENXIO;
-		goto err_rq;
-	}
-
 	if (offset && length > U64_MAX - offset + 1) {
 		rbd_warn(rbd_dev, "bad request range (%llu~%llu)", offset,
 			 length);
@@ -5040,25 +5027,6 @@ static int rbd_dev_v1_header_info(struct rbd_device *rbd_dev)
 	return ret;
 }
 
-/*
- * Clear the rbd device's EXISTS flag if the snapshot it's mapped to
- * has disappeared from the (just updated) snapshot context.
- */
-static void rbd_exists_validate(struct rbd_device *rbd_dev)
-{
-	u64 snap_id;
-
-	if (!test_bit(RBD_DEV_FLAG_EXISTS, &rbd_dev->flags))
-		return;
-
-	snap_id = rbd_dev->spec->snap_id;
-	if (snap_id == CEPH_NOSNAP)
-		return;
-
-	if (rbd_dev_snap_index(rbd_dev, snap_id) == BAD_SNAP_INDEX)
-		clear_bit(RBD_DEV_FLAG_EXISTS, &rbd_dev->flags);
-}
-
 static void rbd_dev_update_size(struct rbd_device *rbd_dev)
 {
 	sector_t size;
@@ -5099,12 +5067,8 @@ static int rbd_dev_refresh(struct rbd_device *rbd_dev)
 			goto out;
 	}
 
-	if (!rbd_is_snap(rbd_dev)) {
-		rbd_dev->mapping.size = rbd_dev->header.image_size;
-	} else {
-		/* validate mapped snapshot's EXISTS flag */
-		rbd_exists_validate(rbd_dev);
-	}
+	rbd_assert(!rbd_is_snap(rbd_dev));
+	rbd_dev->mapping.size = rbd_dev->header.image_size;
 
 out:
 	up_write(&rbd_dev->header_rwsem);
-- 
2.19.2

