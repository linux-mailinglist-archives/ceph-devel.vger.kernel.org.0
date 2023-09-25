Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EEB647ADFA5
	for <lists+ceph-devel@lfdr.de>; Mon, 25 Sep 2023 21:41:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231853AbjIYTlE (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 25 Sep 2023 15:41:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229481AbjIYTlD (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 25 Sep 2023 15:41:03 -0400
Received: from mail-lf1-x135.google.com (mail-lf1-x135.google.com [IPv6:2a00:1450:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 292C3109
        for <ceph-devel@vger.kernel.org>; Mon, 25 Sep 2023 12:40:56 -0700 (PDT)
Received: by mail-lf1-x135.google.com with SMTP id 2adb3069b0e04-5033918c09eso11537894e87.2
        for <ceph-devel@vger.kernel.org>; Mon, 25 Sep 2023 12:40:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1695670854; x=1696275654; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=HzGke94qDv3RyBeSD1WMElp16vdqVTdL3/iuuUEwp8M=;
        b=ZXQRwBRx65G4xo4PmHLlL1VN4o5IBvZbdfTuKeKpwrFsBl79y9X9mh2PQkGnMy1dwx
         6qjlnyR3MkQvxeJJPIZg+N3ot5zCYzk9lllIDa4ySMGbjHwF8zkcQFBfAKed+/GoLcAp
         fps+N2C+ZHbg2Jql6QuqJE1UvyoeiqvzmWAJ8JgKqvOjT3dP5Cfiym8dY0ldm6Yecm3i
         oVcQ8R84VU+vwrkiZl1cpnJXlpWbWTCexXl1GXOhVITfpcfrf+XXeSAPwENIxpaGKV8d
         I1J5K8v89y3HydM3OzKbb9P+LH7xSQ1GDkla+NR1ShxeLl9b5ZQr9+VfAQP/FsWJxf4s
         ZkhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695670854; x=1696275654;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=HzGke94qDv3RyBeSD1WMElp16vdqVTdL3/iuuUEwp8M=;
        b=pneAZDOcr6XFYUCAVEL82FhcaoJPWhHiVtNW78vHAL3jxgNoclcbk2HOcTwdg9Ke9j
         q08ZD1IH+ABItLw78WRMqPTA21xCJSBPuwiKvet5bCylb6sumrI0B6YB2JwYavqiVt+r
         J28d3Cpzg8cfCh/l7jR0KPkBRiDm+ByODU1l3ZrOqGLKGYzD18aIjzXvtHxIXe9QOAjv
         5PQ4Dq62kzQLTw6M5oxbjQgIt0WDWZ1L8MgU+nH4ZvQjdSEk0wvuimQjc/xeh+8DtkL0
         OJm5QbF7ELc0PydM/TLaiAdp+kwXCo+E+ndH3NwBiLr5kZ8Aj9nIcPLuJ0S+O79ghnMp
         YnQw==
X-Gm-Message-State: AOJu0Yy9AgoGu1Q+S4y0l8Y2uKdO3VO9svq7e0VM9OTey1QaA0XB+fyr
        WO3UuPKzY/WzhGHbNNr+9M/iWMsqq1o=
X-Google-Smtp-Source: AGHT+IHFsCHffXEyyLIREwEa7TWeE3xAIRswBvbotReqAEJRsZMW0FIpbmJ/S7MB50pwwJlFIid8/g==
X-Received: by 2002:a05:6512:32cf:b0:500:a3be:1ab6 with SMTP id f15-20020a05651232cf00b00500a3be1ab6mr6424365lfg.6.1695670854185;
        Mon, 25 Sep 2023 12:40:54 -0700 (PDT)
Received: from localhost.localdomain (ip-94-112-167-15.bb.vodafone.cz. [94.112.167.15])
        by smtp.gmail.com with ESMTPSA id en13-20020a056402528d00b005340d9d042bsm1762365edb.40.2023.09.25.12.40.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Sep 2023 12:40:53 -0700 (PDT)
From:   Ilya Dryomov <idryomov@gmail.com>
To:     ceph-devel@vger.kernel.org
Cc:     Dongsheng Yang <dongsheng.yang@easystack.cn>
Subject: [PATCH 0/4] rbd: fix a deadlock around header_rwsem and lock_rwsem
Date:   Mon, 25 Sep 2023 21:40:30 +0200
Message-ID: <20230925194036.197899-1-idryomov@gmail.com>
X-Mailer: git-send-email 2.41.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Hello,

This fixes a deadlock which can occur when a watch error is hit while
the RBD driver is still recovering from a previous watch error.  This
lock cycle was discovered during some performance tests.

Thanks,

                Ilya


Ilya Dryomov (4):
  rbd: move rbd_dev_refresh() definition
  rbd: decouple header read-in from updating rbd_dev->header
  rbd: decouple parent info read-in from updating rbd_dev
  rbd: take header_rwsem in rbd_dev_refresh() only when updating

 drivers/block/rbd.c | 412 ++++++++++++++++++++++++--------------------
 1 file changed, 225 insertions(+), 187 deletions(-)

-- 
2.41.0

