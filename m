Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4AB23FB94C
	for <lists+ceph-devel@lfdr.de>; Wed, 13 Nov 2019 21:01:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726162AbfKMUBe (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 13 Nov 2019 15:01:34 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:36359 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726066AbfKMUBe (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 13 Nov 2019 15:01:34 -0500
Received: by mail-wr1-f67.google.com with SMTP id r10so3851922wrx.3
        for <ceph-devel@vger.kernel.org>; Wed, 13 Nov 2019 12:01:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=e3z0+dQAS4hTijs69fkB5tLNRI8LgwTJRdZ7+MehyPc=;
        b=rds1HjE71lIbXdVFxh31/P0qrK+AqFCnoFaXQq7SlyLR+0QXLQgKno4M6HKqBdRhA4
         b7vzHkF8+TmzGoHBjiMnnBHG28MIw3tTwvqxRAtsmOyjw90T0km3dGcOzIMfhifRqo1G
         6oOiTYRf75H31YpQvET4owA5Li/G8R6veI+9Dy7FS1YN/GFjzJhaDXGJrRU+Axk7Hiib
         O4EvHmOe9IofZQaNWV2xTQE6rPT1Bg/izmwmyz6JWI8kh+PfT/VWR4XMVUj3uktxl0Ft
         mjQgKFOx/9Gs/Jp/iz9/RGhDxzCo425mkomFG/PnaWfKO2toyxiqVyZDQOu74qWmkb9y
         CahQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=e3z0+dQAS4hTijs69fkB5tLNRI8LgwTJRdZ7+MehyPc=;
        b=ZBGbv3ZATm0B3BFBRhGWgu3qausB2xIznj8u/gQ2SfO9G4jattWasynhLNhr4gk1oq
         rSaUCPqJyZ9n5SeN/+BNyg/E0lb5t8BRTnDXHvU/W8ILnBfKVEGZQuIJujnQfu/In0kE
         Zv6xugyrBYDxJ0bwd8S531fMc81oRPganDzVwhuOMwSYcWOjRg1Rx4lvEQmZ2D2WvrI/
         itD7D5khB8jqdMPvu0inHWDaa8ar0ygkIDsu1su/cLk4zSnFXYlXQoMSiTETz1RS3/eu
         S1GbcpuHJUPke9bKvj6vYauyb7H9FzZnPxu+Q83l4S9JlZrSG89hezorVxpx6kfhITWg
         J+wA==
X-Gm-Message-State: APjAAAXg2UpsdYehaDYewoRvhNhj9rUUeJkp8eLbwcuyowISPTR/DAd5
        K2Vm20O2v6KB/+H3MmIQWtGmqZ2+
X-Google-Smtp-Source: APXvYqzvJ6HfZ6IQ+g0qSNgoMmJEjXbLx83xxE62iemtmaks94sgFttrLDT+Hf5ZNUwHNgccxho6Iw==
X-Received: by 2002:adf:cf10:: with SMTP id o16mr4736281wrj.334.1573675290710;
        Wed, 13 Nov 2019 12:01:30 -0800 (PST)
Received: from kwango.local (ip-94-112-128-92.net.upcbroadband.cz. [94.112.128.92])
        by smtp.gmail.com with ESMTPSA id u18sm4160672wrp.14.2019.11.13.12.01.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Nov 2019 12:01:29 -0800 (PST)
From:   Ilya Dryomov <idryomov@gmail.com>
To:     ceph-devel@vger.kernel.org
Cc:     Alex Elder <elder@kernel.org>,
        Dongsheng Yang <dongsheng.yang@easystack.cn>,
        Sage Weil <sage@redhat.com>
Subject: [PATCH] rbd: update MAINTAINERS info
Date:   Wed, 13 Nov 2019 21:01:51 +0100
Message-Id: <20191113200151.30674-1-idryomov@gmail.com>
X-Mailer: git-send-email 2.19.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Alex has got plenty on his plate aside from rbd and hasn't really been
active in recent years.  Remove his maintainership entry.

Dongsheng is very familiar with the code base and has been reviewing rbd
patches for a while now.  Add him as a reviewer.

Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
---
 MAINTAINERS | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index eb19fad370d7..073cacc1b23c 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -13582,7 +13582,7 @@ F:	drivers/media/radio/radio-tea5777.c
 RADOS BLOCK DEVICE (RBD)
 M:	Ilya Dryomov <idryomov@gmail.com>
 M:	Sage Weil <sage@redhat.com>
-M:	Alex Elder <elder@kernel.org>
+R:	Dongsheng Yang <dongsheng.yang@easystack.cn>
 L:	ceph-devel@vger.kernel.org
 W:	http://ceph.com/
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/sage/ceph-client.git
-- 
2.19.2

