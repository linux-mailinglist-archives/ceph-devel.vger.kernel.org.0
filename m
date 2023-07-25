Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4FD92762468
	for <lists+ceph-devel@lfdr.de>; Tue, 25 Jul 2023 23:29:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229696AbjGYV3Q (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 25 Jul 2023 17:29:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229577AbjGYV3P (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 25 Jul 2023 17:29:15 -0400
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E4161FDD
        for <ceph-devel@vger.kernel.org>; Tue, 25 Jul 2023 14:29:11 -0700 (PDT)
Received: by mail-ed1-x533.google.com with SMTP id 4fb4d7f45d1cf-51cff235226so662350a12.0
        for <ceph-devel@vger.kernel.org>; Tue, 25 Jul 2023 14:29:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1690320550; x=1690925350;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=yvZLislPFuVidDyNNuAjPvYttzVSZ5uC0YV2MrllaH4=;
        b=pvhJItrKPSnOG6ujSfqZ8idOw2Ur9PLArdvpF02B2Wb8icd1/83DmC1/UV2DZQaxBp
         kuomlwRwdSOBWGnRAZINp6XX7XMO6qJpY1OFvINdvzMZha7UkMXftFubI6fP2OJJ+cg9
         mbsV5Bx9iiJpJ9IFTVDS/CaTOWO38DVn/O8O7AUHKGh4Uy6S6fpeVWgkwQ/JlleaSalo
         L4gajVEsz9o3nHVEDgVsVCMmOKd2WA8SKmSVCOQhl+0sso7MoGR/QuDTjEZBu29Ms+oT
         nKgkMBD0hvbD16ZnjIk4zFhJq6KuySNDytFQ/sTYvXEfcvxBeinRvVMQarm5NbmE2yka
         Dt5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690320550; x=1690925350;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=yvZLislPFuVidDyNNuAjPvYttzVSZ5uC0YV2MrllaH4=;
        b=GKMI1LoxKaeHq61lxWv9KSmlXreiSBHgsZvxwyiVnbRDqBgG3E08ppyKAKyFxSS8c2
         wi2dLq6Wk6ApxLBchaEwK+yzCSg7mQQjg87tNpz1sybzFWzUWQSNtEWNB0jrvhsPVVB2
         zNgfjVwq3qAf4YKWf52WLeJoWQC+Y+crv4CiGCxw5QJhf1neK6owLLwG2+pBBX/8cjtA
         M+OPMZSAwei1/rbhMfPL45E23iasoowCMYMZJEOAfCXy5wQ4PTonMnPkYidYLrPXZlK2
         MKBXlIALFXaMte768F7akVX90D/1FvZ57cFvfL353debQ3TEoCyl/0Fq7h8GIR604VQc
         yoCg==
X-Gm-Message-State: ABy/qLbr0Hs1l+0wdgFDJpBcIRECJMLWeSdv2L6bhfYkMl/Iv9Rl+7L5
        Hvs/ybx4pfVHCR2oNRnorRk+FXGy3Q0=
X-Google-Smtp-Source: APBJJlGMj58ZimGMliT127gLFxFtWA+ido3Vlc1mSNvvPK87Z/Hoyn+ltMUStv8vUFKcrP6ki6GkDQ==
X-Received: by 2002:a05:6402:386:b0:521:ad49:8493 with SMTP id o6-20020a056402038600b00521ad498493mr403474edv.6.1690320549783;
        Tue, 25 Jul 2023 14:29:09 -0700 (PDT)
Received: from localhost.localdomain (ip-94-112-167-15.bb.vodafone.cz. [94.112.167.15])
        by smtp.gmail.com with ESMTPSA id f23-20020a05640214d700b005224ec27dd7sm1200778edx.66.2023.07.25.14.29.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Jul 2023 14:29:09 -0700 (PDT)
From:   Ilya Dryomov <idryomov@gmail.com>
To:     ceph-devel@vger.kernel.org
Cc:     Dongsheng Yang <dongsheng.yang@easystack.cn>
Subject: [PATCH v2 0/3] rbd: reduce the potential for erroneous blocklisting
Date:   Tue, 25 Jul 2023 23:28:43 +0200
Message-ID: <20230725212847.137672-1-idryomov@gmail.com>
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

v1 -> v2:
- ceph_addr_is_blank() was missing an export
- amended locker equality semantics to ignore addr->type and moved the
  function to rbd.c

Thanks,

                Ilya


Ilya Dryomov (3):
  rbd: make get_lock_owner_info() return a single locker or NULL
  rbd: harden get_lock_owner_info() a bit
  rbd: retrieve and check lock owner twice before blocklisting

 drivers/block/rbd.c  | 124 ++++++++++++++++++++++++++++++-------------
 net/ceph/messenger.c |   1 +
 2 files changed, 87 insertions(+), 38 deletions(-)

-- 
2.41.0

