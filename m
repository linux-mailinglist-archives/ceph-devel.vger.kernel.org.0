Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 32EE39F2B9
	for <lists+ceph-devel@lfdr.de>; Tue, 27 Aug 2019 20:54:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730665AbfH0SyU (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 27 Aug 2019 14:54:20 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:38281 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730262AbfH0SyU (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 27 Aug 2019 14:54:20 -0400
Received: by mail-wr1-f66.google.com with SMTP id e16so2755723wro.5
        for <ceph-devel@vger.kernel.org>; Tue, 27 Aug 2019 11:54:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=6CnVMWsgO02J5Bq2JTwJU6zDa82FeY8nfEApwodQiY8=;
        b=X+/Tq0Cbp3fv/NzJW864wFBOQf2/TsGpjh/YGoUnFh6MzYWN5QKbUKbwiX4QygqE8R
         0vh7q9FlLTCycZVkaNnmX4/nfnPabn9liRc6wSTvxJBim9+VUu4HC1r5paG6kwdf5GHe
         M34efJRht3fW2n3W/9zTMiWorNlmZWahlUzqQWdQuVhFDXm0GnSkC8i1VsB6RTCcDHjN
         74Fxqpi8R1WldISmF+Skd+ZaBSdr06MrOUbp+uSgqmSs2uJT3MR0NCnE8XziaLgicXjO
         xyDYUUDy0EvztKXnJhjN85xIvYipimPrpdtLiYW096A4V+HJ9ltWVX+Mf9kLLXPoh/2P
         JNtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=6CnVMWsgO02J5Bq2JTwJU6zDa82FeY8nfEApwodQiY8=;
        b=GjxsEe9lQy+I85bNERo2jl8RBscFif7rJePlz4C7pxbpyvLt5EHL4MvTvDco9V3k+d
         lGnw8DeZo3lk7Gibs7C7FM/hE/qeeR8GylhRoMujrnGcurRqX9DrIsMUaVS2G29dyXW4
         yd2UathHg8/cPh/1LHQycR4PLNBWhWDwIX1lVKvauoGUbfR8tDJjMiovO8OUXr51d/iO
         3WhfVxVmEXeYLw3UxD1iKGJbQMf4r+lb86FHj2smNOOl23HGgorFkoVdaJKrLyonA1xA
         aJGnFei6k9MixZxkof0lXqePMS3Wk3c87CdNGALqIiwV0I11c+npiA2VTlBqEa5Y4PDC
         ZbSA==
X-Gm-Message-State: APjAAAVpnPelouROAP/nEpVQ7NbAjmreUTzhkMlE9cdPPdLlUfq25nY+
        vjdlonoe7ysSO8eMEm27g1Ft+kLj
X-Google-Smtp-Source: APXvYqzAXipT9FlyHZtidKImPQRSwrpCoTNvZVNTzZNUCab0VZ5xKTf2doQL5rD7O536/Xf+nel1jQ==
X-Received: by 2002:adf:e94d:: with SMTP id m13mr5658111wrn.174.1566932058002;
        Tue, 27 Aug 2019 11:54:18 -0700 (PDT)
Received: from kwango.brq.redhat.com (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id 74sm11538wma.15.2019.08.27.11.54.16
        for <ceph-devel@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Aug 2019 11:54:17 -0700 (PDT)
From:   Ilya Dryomov <idryomov@gmail.com>
To:     ceph-devel@vger.kernel.org
Subject: [PATCH] rbd: restore zeroing past the overlap when reading from parent
Date:   Tue, 27 Aug 2019 20:57:05 +0200
Message-Id: <20190827185705.19016-1-idryomov@gmail.com>
X-Mailer: git-send-email 2.19.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

The parent image is read only up to the overlap point, the rest of
the buffer should be zeroed.  This snuck in because as it turns out
the overlap test case has not been triggering this code path for
a while now.

Fixes: a9b67e69949d ("rbd: replace obj_req->tried_parent with obj_req->read_state")
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
---
 drivers/block/rbd.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/block/rbd.c b/drivers/block/rbd.c
index 58d9f17363d7..13f42f5b06cc 100644
--- a/drivers/block/rbd.c
+++ b/drivers/block/rbd.c
@@ -3038,6 +3038,17 @@ static bool rbd_obj_advance_read(struct rbd_obj_request *obj_req, int *result)
 		}
 		return true;
 	case RBD_OBJ_READ_PARENT:
+		/*
+		 * The parent image is read only up to the overlap -- zero-fill
+		 * from the overlap to the end of the request.
+		 */
+		if (!*result) {
+			u32 obj_overlap = rbd_obj_img_extents_bytes(obj_req);
+
+			if (obj_overlap < obj_req->ex.oe_len)
+				rbd_obj_zero_range(obj_req, obj_overlap,
+					    obj_req->ex.oe_len - obj_overlap);
+		}
 		return true;
 	default:
 		BUG();
-- 
2.19.2

