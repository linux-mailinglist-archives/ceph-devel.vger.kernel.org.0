Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 095B615CB1C
	for <lists+ceph-devel@lfdr.de>; Thu, 13 Feb 2020 20:25:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728543AbgBMTZp (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 13 Feb 2020 14:25:45 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:36356 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728075AbgBMTZo (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 13 Feb 2020 14:25:44 -0500
Received: by mail-wr1-f67.google.com with SMTP id z3so8144757wru.3
        for <ceph-devel@vger.kernel.org>; Thu, 13 Feb 2020 11:25:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=r144PgSd2lIbIcJ03EKfsOEE6P1UhKDqheXGlm+kzlM=;
        b=K0n4oboTdbj+77gQgKubwFABHHCFaOn7UKxtQjVfuFxdHWDMwh23vJk3wl1nIg9sI7
         09gyFC/X+tsc6c3FNxyuhJ4Q3u47/VRKamxKJYVp7xQe7g3wCZL/kIwnpVS0Oj5VIca8
         CJYXnN+UkuTiEKNMlKdHfIqlWQUtHcJNQqrZn+tZaZo0q6bt2Dkrh/FqEIRixkfJEKo8
         4WPvFuaHrkVAnPG9wW40Dghzdk/4Z7KWOMcU90+q3BQrFBFraqMwdZ9QX9oLSsXC7RSA
         qqBC8jDYGfCaIHss2bA3QIpEn0f60O2h+3oA/b03jOJ1ScDMectK4o7zVH0rGafAaeEm
         EV8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=r144PgSd2lIbIcJ03EKfsOEE6P1UhKDqheXGlm+kzlM=;
        b=DFHSmnC6o4Vyx4bZh3zKpCbhn1sraAdwqXpIVMjmjYInINKbc6Qa92maEFoB5Rbm6j
         Chr1VibUoOru+/+mr7kW6SL3i1AnydOa9AqwznpX9lxWFSN2Iq2HOcQDqDYiqcjYztaE
         W6EXnzLxEqtg/tRXmwS4dlp6UQ+U5HwCbYSvFsuvoJwYwl3v+BBECelf4goQods5jVDf
         eqZohyMTgXgCeWaN9BxmZveaTCOw6naconiahtkp7gv5lmjsiyP2t1aB0hhIU3D/Nk+C
         IqMhLuWGLmem7eDDNZM6sJ1PGkSCpRtQmhvjVxsLrFXme4PEKBs9Dl/TnZTIE2zGgaZR
         411Q==
X-Gm-Message-State: APjAAAUdnfYsN/qw42YY2gSluq+3A7fT+RvP1aBlPKUOZL32XddWYOet
        PU1WouFlFPKhz/UG/QtLvCPAtnY+n4o=
X-Google-Smtp-Source: APXvYqwZYpyqTDWJebLMfQvQj44JP4Wh7s3QeCsLCW8m30tKCFhr2tX+VylgYv6EpvU6BLkHJo0XfA==
X-Received: by 2002:a5d:448c:: with SMTP id j12mr22760409wrq.125.1581621943239;
        Thu, 13 Feb 2020 11:25:43 -0800 (PST)
Received: from kwango.redhat.com (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id 21sm4326227wmo.8.2020.02.13.11.25.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Feb 2020 11:25:42 -0800 (PST)
From:   Ilya Dryomov <idryomov@gmail.com>
To:     ceph-devel@vger.kernel.org
Cc:     Hannes Reinecke <hare@suse.de>
Subject: [PATCH 2/5] rbd: get rid of img_request_layered_clear()
Date:   Thu, 13 Feb 2020 20:26:03 +0100
Message-Id: <20200213192606.31194-3-idryomov@gmail.com>
X-Mailer: git-send-email 2.19.2
In-Reply-To: <20200213192606.31194-1-idryomov@gmail.com>
References: <20200213192606.31194-1-idryomov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

No need to clear IMG_REQ_LAYERED before destroying the request.

Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
---
 drivers/block/rbd.c | 9 +--------
 1 file changed, 1 insertion(+), 8 deletions(-)

diff --git a/drivers/block/rbd.c b/drivers/block/rbd.c
index 22d524a0e98b..96aa0133fb40 100644
--- a/drivers/block/rbd.c
+++ b/drivers/block/rbd.c
@@ -1358,11 +1358,6 @@ static void img_request_layered_set(struct rbd_img_request *img_request)
 	set_bit(IMG_REQ_LAYERED, &img_request->flags);
 }
 
-static void img_request_layered_clear(struct rbd_img_request *img_request)
-{
-	clear_bit(IMG_REQ_LAYERED, &img_request->flags);
-}
-
 static bool img_request_layered_test(struct rbd_img_request *img_request)
 {
 	return test_bit(IMG_REQ_LAYERED, &img_request->flags) != 0;
@@ -1661,10 +1656,8 @@ static void rbd_img_request_destroy(struct rbd_img_request *img_request)
 	for_each_obj_request_safe(img_request, obj_request, next_obj_request)
 		rbd_img_obj_request_del(img_request, obj_request);
 
-	if (img_request_layered_test(img_request)) {
-		img_request_layered_clear(img_request);
+	if (img_request_layered_test(img_request))
 		rbd_dev_parent_put(img_request->rbd_dev);
-	}
 
 	if (rbd_img_is_write(img_request))
 		ceph_put_snap_context(img_request->snapc);
-- 
2.19.2

