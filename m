Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 503DF15CB1B
	for <lists+ceph-devel@lfdr.de>; Thu, 13 Feb 2020 20:25:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728389AbgBMTZo (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 13 Feb 2020 14:25:44 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:44802 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728075AbgBMTZn (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 13 Feb 2020 14:25:43 -0500
Received: by mail-wr1-f68.google.com with SMTP id m16so8084214wrx.11
        for <ceph-devel@vger.kernel.org>; Thu, 13 Feb 2020 11:25:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=+H2JnSpbbdauotPaYqz1xI3Rvxm6COXZjcJmu2xxVQ0=;
        b=Z2l8OXsWBt9UQjpLSZIudr4dsHqDYlFJlxeOxarfXz/OxGSKTEfqqmdu5nPFNPp/Sb
         aTLzbfI+30pOCLzTOsiWF5I9o6KA1Tl8VkqKWKm7+h1epot/oExCilHgLoyiqQwn+BA1
         bbkEWJo9Xy+lery7D2OXCjWOjjI9lx/K3Jv+sB/VFGyF5HUzxhzZ3qaAGpPOemZk07s8
         BFm9uct0g0Uqhr8gb/ZA6Mi8YJbaCeL/omFP2m1JJ/g0aMUNGKVTp0n1dyPszIU9iGos
         gEJ/HO+ktO7L1LT/UhSNjOghJP3Lz2EQseXU4q+KhQU03f+VgbcFUKUUYY8cbgO6FzUM
         oweA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=+H2JnSpbbdauotPaYqz1xI3Rvxm6COXZjcJmu2xxVQ0=;
        b=i3vq/m3zDcXyFXU2ZJI0TIhgalOAxWeinkEZdvKTUeuzYuVz4DMbuAoBqI0R6enDY2
         cXxNcNbHfdIhgDpl9UtR/rs0lJWz7togfu2exVshnskGnyFC6KhlAomsDOSl3aSxVbxn
         vAntEOwRdm35s4peTsJYp/XFk0MYmVR1Og+UjDI7hNNZO0UZUIO6uKyAXm4V7uuYZo+O
         cOfkwmS5I5sNgRk8oms/p8nzSGSZWpWyp4E6UZHsDKIRUUlK2By3nyw4wKzd+GqdsZl4
         1zG/fTHMFB4jV39tN57L5zjqj26Ut6LgcpugpLBsAJrSiMHmegeizQ6/Z5r5nLFSJsXm
         jV+g==
X-Gm-Message-State: APjAAAWcpeIRUEHk1XEmjXqm404RdYER9kpTR4l2Gc2pqiKdoyLCiNjT
        9gpPrlz7ERzhhULTnh2dAPEAUBuYIww=
X-Google-Smtp-Source: APXvYqyli0xT8mA6//O0iu4ORUiL4ALS93mVQPHMtayyiV+ijVdOuKLtov23spQ4GBAAvf7E7F0b5w==
X-Received: by 2002:adf:df8f:: with SMTP id z15mr22540715wrl.282.1581621941296;
        Thu, 13 Feb 2020 11:25:41 -0800 (PST)
Received: from kwango.redhat.com (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id 21sm4326227wmo.8.2020.02.13.11.25.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Feb 2020 11:25:40 -0800 (PST)
From:   Ilya Dryomov <idryomov@gmail.com>
To:     ceph-devel@vger.kernel.org
Cc:     Hannes Reinecke <hare@suse.de>
Subject: [PATCH 0/5] rbd: enable multiple blk-mq queues
Date:   Thu, 13 Feb 2020 20:26:01 +0100
Message-Id: <20200213192606.31194-1-idryomov@gmail.com>
X-Mailer: git-send-email 2.19.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Hi Hannes,

Here is what I intend to queue for 5.7.  I didn't hear from you on
the need to protect the object request list, the impact of image
request state_mutex on performance or the problem with queue_rq(),
so I concentrated on the tail of your series and reworked the payload
patch to avoid acquiring header_rwsem at least twice for each I/O.

I observed the same ~25-30% improvement in some rough synthetic tests
on a laptop (random 4k reads with very high queue depth in particular).
I assume you did your testing on real hardware -- it would be great if
you could share some details.

Thanks,

                Ilya


Hannes Reinecke (2):
  rbd: kill img_request kref
  rbd: enable multiple blk-mq queues

Ilya Dryomov (3):
  rbd: get rid of img_request_layered_clear()
  rbd: acquire header_rwsem just once in rbd_queue_workfn()
  rbd: embed image request in blk-mq pdu

 drivers/block/rbd.c | 212 +++++++++++++++++---------------------------
 1 file changed, 79 insertions(+), 133 deletions(-)

-- 
2.19.2

