Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7113D74C11E
	for <lists+ceph-devel@lfdr.de>; Sun,  9 Jul 2023 07:41:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231351AbjGIFlM (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Sun, 9 Jul 2023 01:41:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231318AbjGIFlL (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Sun, 9 Jul 2023 01:41:11 -0400
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4455512A
        for <ceph-devel@vger.kernel.org>; Sat,  8 Jul 2023 22:41:10 -0700 (PDT)
Received: by mail-pg1-x52c.google.com with SMTP id 41be03b00d2f7-55bc29a909dso1678720a12.3
        for <ceph-devel@vger.kernel.org>; Sat, 08 Jul 2023 22:41:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1688881270; x=1691473270;
        h=to:subject:message-id:date:from:reply-to:mime-version:from:to:cc
         :subject:date:message-id:reply-to;
        bh=oDVdWICwavrWQ8UAVYhe8ynFXsBBW1vVQ7W08zgiq24=;
        b=BuKr1Z9sgUU2+LVB72ELX+MIdaiMzXd2QGmDT06thF9awYVKdUv1/VtZDQUTWc1Hp/
         wMCm6hrTlsiJxrE3XrFjg8yos1Fush3kN1GWK++BWtsxkDKeOcgbjSCMouKiLkBpz8nC
         sOcC7IsYltEvDW2oJfuF73dqZUkfV+95s2+09HEGHZrOlpoK9GicnLtQK15uUszL9p0O
         xSKQzWK8LmnmGDghVz4btXxwQ4U7X/7j1Uz+x83bRSSK+gUvuZj1I3i/2RsQcChZrBhp
         /smUyifbMzFAZz8YxFUg82yUcjCsw8AEeuEcBoJQrffKOs3BEv5pZ2u4T8p+sYmjjOBW
         h9+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1688881270; x=1691473270;
        h=to:subject:message-id:date:from:reply-to:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=oDVdWICwavrWQ8UAVYhe8ynFXsBBW1vVQ7W08zgiq24=;
        b=OB55sDAINYwzw1O62bmihx/6nD+ZL8gRqXhfproh/RfjuWOSKkpK3tWY8atK+UIby7
         40IZBRNGur2sZ2JK1wNh3Tbf/4Sm6UlptVwShaHT9P38tHUdIjJT1eL+RuZWYYeYHEb2
         iQg8UD/YgHewiKQNSGujAU7iamdsE7q9uw0+IUajxh8WhiUI+6xcILFAf1JOugEcayQz
         usJ40WBAZLe8eGYEmBYYulCac6RPlxAjYijkLT5XNsHzMyb2NLqhoQAz3qo6tCHmtCMU
         A4qSy5IJ5iz3Xrb3CONPwX+QH4PwApVRdK6Dqwc6uSsG1kCSTX9DC5okZbK5+0LF8cMt
         CCzQ==
X-Gm-Message-State: ABy/qLblO+A4UoTSvD47SeW93CGD4z6RSzApVaryCQfOJvJCo1kXoRn4
        0IS5OtSt55M1BCd22ablsK7BPLsiIr5h+kITG9Y=
X-Google-Smtp-Source: APBJJlEpVoesQ83We3N4njXiVkNH+jjVpvimIE4OS4zjXm8KCouuEt/9NGV8pFuOSakBtCK0KoWvgVuzMeoMQdggNMw=
X-Received: by 2002:a17:90a:6582:b0:262:ece1:5fd0 with SMTP id
 k2-20020a17090a658200b00262ece15fd0mr7218552pjj.12.1688881269599; Sat, 08 Jul
 2023 22:41:09 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a05:6a10:cd06:b0:470:f443:15ec with HTTP; Sat, 8 Jul 2023
 22:41:09 -0700 (PDT)
Reply-To: ninacoulibaly03@hotmail.com
From:   nina coulibaly <ninacoulibaly30.info@gmail.com>
Date:   Sun, 9 Jul 2023 05:41:09 +0000
Message-ID: <CAFb7D3dotHKXffGPW6HCzW+91wR3X-5uU-4Ht9VM+oY=ZfdqQw@mail.gmail.com>
Subject: from nina coulibaly
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=4.5 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,FREEMAIL_REPLYTO,
        FREEMAIL_REPLYTO_END_DIGIT,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,UNDISC_FREEM autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Level: ****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Dear,

I am interested to invest with you in your country with total trust
and i hope you will give me total support, sincerity and commitment.
Please get back to me as soon as possible so that i can give you my
proposed details of funding and others.

Best Regards.

Mrs Nina Coulibaly
