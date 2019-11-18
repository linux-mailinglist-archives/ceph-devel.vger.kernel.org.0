Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D3D261006A0
	for <lists+ceph-devel@lfdr.de>; Mon, 18 Nov 2019 14:38:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727082AbfKRNid (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 18 Nov 2019 08:38:33 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:42905 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726627AbfKRNic (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 18 Nov 2019 08:38:32 -0500
Received: by mail-wr1-f65.google.com with SMTP id a15so19517555wrf.9
        for <ceph-devel@vger.kernel.org>; Mon, 18 Nov 2019 05:38:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=DVnn3LT8HfKAn3otZMw1YLXrFkmCYdTRUb1AiySCKGs=;
        b=b9mXIRhaUJvYBW3ITSriLeo8fiMP/XMr9W3b71lEQ0ArHtAJAUIphbq45wN9dRRJcf
         9t2FNXsLxbg6lXcEn8Ai0rIlrTbdzXOswOE5a/iOLcu2rs2stJ+QMR4Ln6Khjx3WqOfo
         3AA2B5/XIixUL2Mr8Xy7oT7Yq727dLYtYjLtrRt5lHsUGGhdK18z9dpjLugervzxo0s7
         +fnbiovtwRJhjGtey+w5Iydc18oRmnuJjUJ6pbbo9LcsJoCc675kqpk5udRu755oYqx0
         E9H9FIrOKkqzqxWnFitngMFaB2mTnKE00CILmp3O655/KjNqqpTtV/kvAPpoyuwf9pbS
         bfMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=DVnn3LT8HfKAn3otZMw1YLXrFkmCYdTRUb1AiySCKGs=;
        b=bWho5mB6pf2uDSWDtQz5gnL7a/tDNKU9LPF+/fP2S2qgu7ZcZhzohZSsEvF0ZEpjFY
         5a7/o1FTal8z51cBk/fJ5hoDdkM27hLTysIz9RN2MsS2vKKql42TqFoLT7GDjH+mW7a8
         KQbSpwed6TGJZqjA42PnUwHKEvepA8SgTRJreVireHmxheER5/HNVbci0CgkEDsXKHzp
         T1cc+YE9UalD8NY8WFF0AIoRCBFdN1i+z7+vqtrs1bcG1rHWDCKlve41j8YlQjVVOq53
         b965FRP3Udie3bZ2AEebGTvK/OZ/nBjEt44EwAnQj5+t1kGQqE1fN5UMQfQYHfwGdATh
         9m1Q==
X-Gm-Message-State: APjAAAVZqcIuQmYkB7I3DzkQFU5PFhOQwhs2q9C7Lkf0P4/ey1beEL7D
        HA18Pqx43WYGalRzpKY803uOTtQ8
X-Google-Smtp-Source: APXvYqzZz5Ycf5q5Z/+i3gQct/yXyx40Zr8f8LQJwyHCWemuiO/NJTuzIQlWVldgEqbWEEc+oTOJBA==
X-Received: by 2002:a5d:538d:: with SMTP id d13mr32234603wrv.304.1574084311319;
        Mon, 18 Nov 2019 05:38:31 -0800 (PST)
Received: from kwango.local (ip-94-112-128-92.net.upcbroadband.cz. [94.112.128.92])
        by smtp.gmail.com with ESMTPSA id t133sm24670242wmb.1.2019.11.18.05.38.30
        for <ceph-devel@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Nov 2019 05:38:30 -0800 (PST)
From:   Ilya Dryomov <idryomov@gmail.com>
To:     ceph-devel@vger.kernel.org
Subject: [PATCH 3/9] rbd: treat images mapped read-only seriously
Date:   Mon, 18 Nov 2019 14:38:10 +0100
Message-Id: <20191118133816.3963-4-idryomov@gmail.com>
X-Mailer: git-send-email 2.19.2
In-Reply-To: <20191118133816.3963-1-idryomov@gmail.com>
References: <20191118133816.3963-1-idryomov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Even though -o ro/-o read_only/--read-only options are very old, we
have never really treated them seriously (on par with snapshots).  As
a first step, fail writes to images mapped read-only just like we do
for snapshots.

We need this check in rbd because the block layer basically ignores
read-only setting, see commit a32e236eb93e ("Partially revert "block:
fail op_is_write() requests to read-only partitions"").

Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
---
 drivers/block/rbd.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/drivers/block/rbd.c b/drivers/block/rbd.c
index 330d2789f373..842b92ef2c06 100644
--- a/drivers/block/rbd.c
+++ b/drivers/block/rbd.c
@@ -4820,11 +4820,14 @@ static void rbd_queue_workfn(struct work_struct *work)
 		goto err_rq;
 	}
 
-	if (op_type != OBJ_OP_READ && rbd_is_snap(rbd_dev)) {
-		rbd_warn(rbd_dev, "%s on read-only snapshot",
-			 obj_op_name(op_type));
-		result = -EIO;
-		goto err;
+	if (op_type != OBJ_OP_READ) {
+		if (rbd_is_ro(rbd_dev)) {
+			rbd_warn(rbd_dev, "%s on read-only mapping",
+				 obj_op_name(op_type));
+			result = -EIO;
+			goto err;
+		}
+		rbd_assert(!rbd_is_snap(rbd_dev));
 	}
 
 	/*
-- 
2.19.2

