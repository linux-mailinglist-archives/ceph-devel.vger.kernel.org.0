Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C36D772314E
	for <lists+ceph-devel@lfdr.de>; Mon,  5 Jun 2023 22:27:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232271AbjFEU12 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 5 Jun 2023 16:27:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229698AbjFEU10 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 5 Jun 2023 16:27:26 -0400
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C26DC98
        for <ceph-devel@vger.kernel.org>; Mon,  5 Jun 2023 13:27:25 -0700 (PDT)
Received: by mail-ej1-x62a.google.com with SMTP id a640c23a62f3a-973f78329e3so829458466b.3
        for <ceph-devel@vger.kernel.org>; Mon, 05 Jun 2023 13:27:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685996844; x=1688588844;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=pgUugEONNtRYoEgUIqt0OScY32MeN5441aSQEpnoT70=;
        b=J+Zbo4cJ3Bqd34Ss4D6CXVF9zg6oykQSNgI5ZJiPjSaywONVWKKKBYAQGo51nc4CHT
         FTdkdRLAEZavN4r3Pz2Wk0kz71Z6sq+UdTiou6BPtrQRtak+d4eTz/MBs5G4SZhsjxWD
         fdcDZW+HQhaBPRnhtj2jgDcpm/sQfQXgXX+bbj0ZjoeP0h/w6jKzPH81oK8+R6Vx9Ydk
         6TTDwqsOVjLLtfqMLA0GZCBMFFDN268ce1WS6ah452UGjGBdDpXKNJmG54gCUPD6slNd
         RtRdTfjnXK2uQf09hFtHiqxBcnNiZr3ExnmB8qz8r2XYdrz8owmaj4x/ccytoKGmJGFC
         f+ng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685996844; x=1688588844;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=pgUugEONNtRYoEgUIqt0OScY32MeN5441aSQEpnoT70=;
        b=Y+4HUL6yMBWPsV6Wr4tgHSr4GTRXoBb1ge2ImqsmrtNfdqqQpuW2o+Z/mM6TXIr72l
         8wBUtsUTsicvN++ATPRj1ppwkg6Xue5wvCOlRyUIfZisA98CLerg6tgcnckOYQP61rcD
         HwvMojAwGMVuizCSzkOc6tdAzC+hV5aZXRM6DPYT6MUi+wh/Ejdj76gC7VSmqLsEkYVm
         qV8SxYjzcI/vVFT6x8Lf0DzQnYkyFxISU0QI2VsfFXQj1YZUuMmpK4I+J9EjJ4iC83n2
         jo90fe7AvwlrDwPX9lfQzt0o4ixboxm3txkRnYdB33HGLUFnZ3LV9+7WPvKZhBsxOI1B
         XMQQ==
X-Gm-Message-State: AC+VfDxoUHYn6Qqx6jV0nYv+rRw5h5mCT31GYC7RAlL26bupVk6c/K+I
        7b5Rzo/FBxA/GQTnvZomff1qsVvRzUo=
X-Google-Smtp-Source: ACHHUZ78WANZmVcb1BPNyf7+aePx0Ugr4ZUMDTS1sR+C08EXl8npEZWrIAtEHIjAcF85XAj4caMEtA==
X-Received: by 2002:a17:907:9689:b0:973:93d6:189f with SMTP id hd9-20020a170907968900b0097393d6189fmr7769874ejc.61.1685996844004;
        Mon, 05 Jun 2023 13:27:24 -0700 (PDT)
Received: from zambezi.redhat.com (ip-94-112-104-28.bb.vodafone.cz. [94.112.104.28])
        by smtp.gmail.com with ESMTPSA id i15-20020a170906a28f00b00968242f8c37sm4619808ejz.50.2023.06.05.13.27.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Jun 2023 13:27:22 -0700 (PDT)
From:   Ilya Dryomov <idryomov@gmail.com>
To:     ceph-devel@vger.kernel.org
Cc:     Dongsheng Yang <dongsheng.yang@easystack.cn>
Subject: [PATCH 0/2] rbd: avoid fast-diff corruption in snapshot-based mirroring
Date:   Mon,  5 Jun 2023 22:27:13 +0200
Message-Id: <20230605202715.968962-1-idryomov@gmail.com>
X-Mailer: git-send-email 2.39.2
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

This fixes a potential data corruption in the destination image in
differential backup and especially snapshot-based mirroring use cases
with fast-diff enabled.

Thanks,

                Ilya


Ilya Dryomov (2):
  rbd: move RBD_OBJ_FLAG_COPYUP_ENABLED flag setting
  rbd: get snapshot context after exclusive lock is ensured to be held

 drivers/block/rbd.c | 62 ++++++++++++++++++++++++++++++++-------------
 1 file changed, 44 insertions(+), 18 deletions(-)

-- 
2.39.2

