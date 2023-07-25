Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A2ADC7608A3
	for <lists+ceph-devel@lfdr.de>; Tue, 25 Jul 2023 06:36:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230304AbjGYEgT (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 25 Jul 2023 00:36:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229810AbjGYEgS (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 25 Jul 2023 00:36:18 -0400
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8164710C7
        for <ceph-devel@vger.kernel.org>; Mon, 24 Jul 2023 21:36:16 -0700 (PDT)
Received: by mail-wr1-x42c.google.com with SMTP id ffacd0b85a97d-3176a439606so304399f8f.3
        for <ceph-devel@vger.kernel.org>; Mon, 24 Jul 2023 21:36:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1690259775; x=1690864575;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=p127lDYzgkphr+e1cm4J2Q/Ku7XsvGo+SwlW6ttojr4=;
        b=A1W2KcEMGJx7EqTYVdeGvYc01I9DjHVXX0Zgk9jsGU6XU2+nEKy5AwC0CwO90Ji/fH
         3RcIQqZENrv1HM/3oupP+APDyAdErE1R2WykHKoo/Lo9aPS4mqYk113t9PSr/nZQolXS
         4UJm1w1ngXz574NhSpTs27IpdotzfunTdaeONxYcjTGICKkeOLSkmaP7KLwV7ngBnUF4
         Zzm0XkjBLLC/ARhxQ+eUIhFF2aeU2xECOagzkPV3UcIsRj/NUozkS94OGhbm1DcD6F2D
         RmBw0qiErrjscIwpZrc3QX+NwCu/LoJ2yYmipz9VeVsaFmuQ96Fde78ywsbFTPuh9fSC
         4jaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690259775; x=1690864575;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=p127lDYzgkphr+e1cm4J2Q/Ku7XsvGo+SwlW6ttojr4=;
        b=QJ7cwQ12Qg7wyZ1+2y3zIrmEQDR46M+Qut4AuIrqLIsqCG+4DClw0gWxRgO6xewghj
         7hL3EyyQUigSQGKzWNDWkq0g97RjosEioqrfpepg+sJYGstnH1jQd3diaqx/L9khyeH2
         plKAM1GIM6ZQXURClU+m4f3REqfyIaDS6OvUnWsv+loag2xfy7gvahEPyT+sCpungag6
         RW7mKTRrt3KcFDch5MU6j2UKYkSW0wgN1LdVGAPZE9Vrb9rgGau2j73OHk64TmDHI2Pe
         T/lgV42Bnh2hWjQMKyi59sZixJwiPql0Cbf6FyaiHh8z5Vj1KUC3HXgl92hPY4d7KlLe
         oaqA==
X-Gm-Message-State: ABy/qLY6IVTn3EpFYphpDeqcXAB2pl68wMLRH+SZHcp1uWHAg1a/KCK5
        ll9/N3eW3BwjI8xc81Z9LoPVLvMNeFg=
X-Google-Smtp-Source: APBJJlHyai399pSbECauc9zHv2nVSoRKY2ZXp2ZozLn7sSF9souzPvJTAZCE5gwVvmnBYpCXFksBiQ==
X-Received: by 2002:adf:e7ca:0:b0:314:1494:fe28 with SMTP id e10-20020adfe7ca000000b003141494fe28mr7057201wrn.53.1690259774779;
        Mon, 24 Jul 2023 21:36:14 -0700 (PDT)
Received: from localhost.localdomain (ip-94-112-167-15.bb.vodafone.cz. [94.112.167.15])
        by smtp.gmail.com with ESMTPSA id d1-20020a5d6441000000b00317643a93f4sm3500760wrw.96.2023.07.24.21.36.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Jul 2023 21:36:14 -0700 (PDT)
From:   Ilya Dryomov <idryomov@gmail.com>
To:     ceph-devel@vger.kernel.org
Cc:     Dongsheng Yang <dongsheng.yang@easystack.cn>
Subject: [PATCH 0/3] rbd: reduce the potential for erroneous blocklisting
Date:   Tue, 25 Jul 2023 06:35:53 +0200
Message-ID: <20230725043559.123889-1-idryomov@gmail.com>
X-Mailer: git-send-email 2.41.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Hello,

This came out of snapshot-based mirroring work.  Patches 1 and 2 are
preparatory, patch 3 fixes the issue (in as much as reasonable).

Thanks,

                Ilya


Ilya Dryomov (3):
  rbd: make get_lock_owner_info() return a single locker or NULL
  rbd: harden get_lock_owner_info() a bit
  rbd: retrieve and check lock owner twice before blocklisting

 drivers/block/rbd.c                  | 115 ++++++++++++++++++---------
 include/linux/ceph/cls_lock_client.h |  10 +++
 2 files changed, 87 insertions(+), 38 deletions(-)

-- 
2.41.0

