Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 30E7653DB65
	for <lists+ceph-devel@lfdr.de>; Sun,  5 Jun 2022 14:33:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245752AbiFEMda (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Sun, 5 Jun 2022 08:33:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231252AbiFEMd3 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Sun, 5 Jun 2022 08:33:29 -0400
Received: from mail-vs1-xe2b.google.com (mail-vs1-xe2b.google.com [IPv6:2607:f8b0:4864:20::e2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3EACF24953
        for <ceph-devel@vger.kernel.org>; Sun,  5 Jun 2022 05:33:28 -0700 (PDT)
Received: by mail-vs1-xe2b.google.com with SMTP id r12so8790342vsg.8
        for <ceph-devel@vger.kernel.org>; Sun, 05 Jun 2022 05:33:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:reply-to:from:date:message-id:subject:to;
        bh=xVJHepNq93ePmAbCv1LHbdOWJcqWYQh8v11fr0KUdVw=;
        b=hLKYd9INIDPHJCEumXOCfTXXmGXl1qQPyU09Q4MaMwVdT1CX0KVeHg21HaDrowp2Lj
         3ycTF5Cvaesg+bExWpGwMNDYpETx7/2o/DmQo5fKU62u/9pNHQVM5HHLCyeBypCWZZIX
         UnIzatqaSwD30pJW5/aLjQHK2LpK6aA+sg3Dh79x4FXmL/ffQrQqj8/DuTo8dzm4967h
         8WHVVBCCe9Vp3tOFbfJQNPMCoA+6Z6P/wZDJs9FxgYKItLKVbWcU9hQZKyuwj6sulHOG
         20bwG8g0Malm0+SdDmPygc24/yiMEUeZKTEJglOEYWrU1sCM8hZLOyHwOGOgzzNMz2Wn
         V+sQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:reply-to:from:date:message-id
         :subject:to;
        bh=xVJHepNq93ePmAbCv1LHbdOWJcqWYQh8v11fr0KUdVw=;
        b=uJ7Z8kpvHmyU3wuyChCdNKXp+7f+CvT/Zew1ZR+F+1S9uo89vwpRRFVGVI7zGFngrk
         BSPVX38+LBgCVxqbWWKnZQV78FyVkJjZGR/B4eVfkMaigF8T05jwcE23HY1IsRwoIRxu
         SU1+vSVukWydIHUF6ESE1f07wgAilYS+SDAyE84MnehfOMUju0p2Cd40xFUOIyCvaI5z
         eOL7zFz1SgDDu5u1r8YbtrpHu2aiU3vWrRya6Z3dHNkRCyRAAGIl28OsTRsu6G2Hq9TS
         WGnwKk1otQyTNUf+C9WPrQMY/YfNAZeXLl6uibVQ7fOyx7EMYd33PRDuIFkm7AfOlAAY
         2VXw==
X-Gm-Message-State: AOAM5323sJibF1WLFYuJhYVDkVAqT+wkRXD3sTh0gHVsOKt/E50U+BB/
        il5ysVcwDjnIws0qxSMa0FQsotCHt2mVblVXIS8=
X-Google-Smtp-Source: ABdhPJyEhaNYzMlTtzxoKjdgaxURT27kDkjEw8Wty57tCb1vJh2t3TMAHz/wcFw1xn3mek/UfPN7ATVJipSTkK39Shg=
X-Received: by 2002:a67:df16:0:b0:32c:bac6:95ad with SMTP id
 s22-20020a67df16000000b0032cbac695admr8640998vsk.29.1654432407182; Sun, 05
 Jun 2022 05:33:27 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a59:6753:0:b0:2c3:f450:1fee with HTTP; Sun, 5 Jun 2022
 05:33:26 -0700 (PDT)
Reply-To: lilywilliam989@gmail.com
From:   Lily William <blessingiyore3@gmail.com>
Date:   Sun, 5 Jun 2022 04:33:26 -0800
Message-ID: <CAKQJGJa=HpNUoYtb-wfqS0wHJbpcd0gCnKtcnHtQMBFK9MGfsg@mail.gmail.com>
Subject: Hi Dear,
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=4.4 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,FREEMAIL_REPLYTO_END_DIGIT,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        UNDISC_FREEM autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: ****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

-- 
Hi Dear,

My name is Lily William, I am from the United States of America. It's my
pleasure to contact you for a new and special friendship. I will be glad to
see your reply so we can get to know each other better.

Yours
Lily
