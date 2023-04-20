Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C4AC6E9618
	for <lists+ceph-devel@lfdr.de>; Thu, 20 Apr 2023 15:43:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231493AbjDTNng (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 20 Apr 2023 09:43:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231481AbjDTNnf (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 20 Apr 2023 09:43:35 -0400
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F35795BA1
        for <ceph-devel@vger.kernel.org>; Thu, 20 Apr 2023 06:43:29 -0700 (PDT)
Received: by mail-ej1-x62c.google.com with SMTP id a640c23a62f3a-94a34d3812dso77244466b.3
        for <ceph-devel@vger.kernel.org>; Thu, 20 Apr 2023 06:43:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681998208; x=1684590208;
        h=content-transfer-encoding:to:subject:message-id:date:from:reply-to
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=TikCagQRGSzGWOj2YMiTIgqMIw7ESQMXtg8OU9sy6Ns=;
        b=XL5je69Dm1E6JFSb7lxdIvJu+oUsZMDAUygP2corgaKB0/JNWYyfajTJIz/GgNegMN
         O6mjw08QVvqUKu3rUsxz0XMyM9ub36J9WVA3HgqwAP4oHN6sCeTUrMAm2aE8/G+V0/Bx
         NQTW7caSbBrLMDyZz1Sk/SWFavIULfIHsbOH56WuRQV/4Yb+sgnjigbLJSExm28Zusto
         xWQAxrohFO7YGyilmdBtJlvSVDSJMxyRCZSptTM/WXhbunSVwsocdSzQZhCKuDQmt960
         NO3Ymrujvl1ay0CiUpkt+XGqBZME339InKNoMQJ4Y9Uzq3AjV62oF703pRFObx13JWnU
         Tbnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681998208; x=1684590208;
        h=content-transfer-encoding:to:subject:message-id:date:from:reply-to
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=TikCagQRGSzGWOj2YMiTIgqMIw7ESQMXtg8OU9sy6Ns=;
        b=N4AMUrTgHX4RjYnrCS4j4LaZ6fKOIlabuKuQjyilQOirvgnmr1MwPaf6rpWx3rbJoh
         GUefz7SHeeUmnURb5sStJ2XYxc0P8Cy0E9Gl5SbAiZPzRateR2uYzsFt9SsYsw1zMaGo
         0A7cIHe5dba9NqwTpGBLITeQneqn2uo1NTkqdE9kE31MSC5/5Iq3cSvhhKeRvAKpcVTn
         X6fxF08yPLVN3S+vzwxVCzgDbAyYD+lg68rrDATfhKlkf5UdrxOiwhz4ViRYm+W7rKV2
         Lm4PIhggDOzO7mTMc8683ZtTGS5ctmCfs7DT/UyFxWqFyQzMtnqMyXuTHdzdHjxKpDOh
         5PyQ==
X-Gm-Message-State: AAQBX9ffqlDBFs8QXWROd4dUyGVrzy6fVe5CAv6brqFDGWAfHtEAKQU4
        EoYq5gXY7EdflWFFpNiBRvwqtdYbPh3WOGxnL7E=
X-Google-Smtp-Source: AKy350Y9emNNeha61aFhEh5t+8ri633fR1LDnKmU93NqbrxgX/OSZJNesHlc6ne/EGDTlKH5IQsE6U5oBgU3v+Qo7no=
X-Received: by 2002:aa7:d7c7:0:b0:4fc:709f:7abd with SMTP id
 e7-20020aa7d7c7000000b004fc709f7abdmr2079314eds.2.1681998208110; Thu, 20 Apr
 2023 06:43:28 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a05:7208:b14d:b0:65:e393:d745 with HTTP; Thu, 20 Apr 2023
 06:43:27 -0700 (PDT)
Reply-To: stefanopessina92@gmail.com
From:   SPENDE <mdrpnmon@gmail.com>
Date:   Thu, 20 Apr 2023 06:43:27 -0700
Message-ID: <CAOzj+TEOX70SNQ9Ooib3v9dWT_0QQeY+r2kj8y8t3h6fUWsK-g@mail.gmail.com>
Subject: spende
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,FREEMAIL_REPLYTO,
        FREEMAIL_REPLYTO_END_DIGIT,HK_RANDOM_ENVFROM,HK_RANDOM_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        UNDISC_FREEM autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: **
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

--=20
Der Betrag von 1.500.000,00 =E2=82=AC wurde Ihnen von STEFANO angeboten/ges=
pendet
PESSINA.Bitte kontaktieren Sie stefanopessina92@gmail.com f=C3=BCr weitere
Informationen
