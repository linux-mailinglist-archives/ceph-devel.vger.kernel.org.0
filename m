Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DBECD4D798F
	for <lists+ceph-devel@lfdr.de>; Mon, 14 Mar 2022 04:06:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231569AbiCNDIB (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Sun, 13 Mar 2022 23:08:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229645AbiCNDH7 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Sun, 13 Mar 2022 23:07:59 -0400
Received: from mail-yw1-x1141.google.com (mail-yw1-x1141.google.com [IPv6:2607:f8b0:4864:20::1141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6296620184
        for <ceph-devel@vger.kernel.org>; Sun, 13 Mar 2022 20:06:51 -0700 (PDT)
Received: by mail-yw1-x1141.google.com with SMTP id 00721157ae682-2e51609648cso56458807b3.10
        for <ceph-devel@vger.kernel.org>; Sun, 13 Mar 2022 20:06:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:reply-to:sender:from:date:message-id:subject:to;
        bh=vIF0HCtULT8/Hj4oEOKhM3wVM2dbK4vAQWbMA06NHEs=;
        b=ExOBs8eZ/+F0N1yDeFn15qhgw54NyRRjNVK3ki2qZuTqAvSa4Zbz73DXdUPUACzc+p
         TEarBQwbRgm9vAo4S1PTy402WxQSF75Q6wVL2kjT1MrpI10mMcBr0R5a1tuYPg8ay6fM
         4Z0yubiuFWoqEtDS4BfMlldoV9/FD4Ci4WpwzTYwVwjeSLuJLNbFPK0L1VVa8U2qxJ8w
         tADCOnHmwWsujvomSvI2hLFlsVJP/CA7zqTCM9TWUxQNudHt6bGNELRYlZgcRGahC12+
         s19RBGQgFnEkH4kAgLlAPv/pf3aqnyIjuZ4zMHUaq3dpIxz+irZnXb9id4/u9qJeGFnl
         QJrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:reply-to:sender:from:date
         :message-id:subject:to;
        bh=vIF0HCtULT8/Hj4oEOKhM3wVM2dbK4vAQWbMA06NHEs=;
        b=GbEIdLqG/Kdif1aSJpc6e+jfnVDCTFjuCGK7/z8YOtGLu670LLW8E6qyPVVyrL8kbt
         h2rVmfOloBZssFEUSwrMNGYL3VZ5iQPOvTBsFbOdsbgWa5gppFmCDKZpwHzH6r+FYs7L
         OudrPvMNsKwyP9wmlZGBrbYOUrbeNxzg+7WIXgNgnCp57AFN581dCM5RUzqhUza8a9nA
         K9MvHFviZb0zdpGYSkNaxouJsLyt/fJm8LbL9Dp31rDebgqmXbGSAY61rUCyDR3scW+4
         sF5GKsabSd1j01YaiowMOFM0/jlHHtrtLoUhimjexgd5nxH+g8vqnBZdyiZBNQW/RUT/
         WXLA==
X-Gm-Message-State: AOAM531K46ySev+6jnwSPpp71lKxyH6OUdMkq3uF97QPzj4Ukk4hYvnm
        yrH1Tn+F2G4LZsxoWNyKonWLFOVYlZrRgDP3Fbw=
X-Google-Smtp-Source: ABdhPJyXgH510wXWLigzAfE+GwG9J/Nq50+ix5mSBCFfYUQkEhg4OKGrUV6oQ8EV1kE3xQXcJ+cyeYa/VVZZVcX2RN8=
X-Received: by 2002:a81:12c3:0:b0:2dc:5f5a:38ec with SMTP id
 186-20020a8112c3000000b002dc5f5a38ecmr17225546yws.347.1647227210349; Sun, 13
 Mar 2022 20:06:50 -0700 (PDT)
MIME-Version: 1.0
Reply-To: salkavar2@gmail.com
Sender: iqbalfarrukh60@gmail.com
Received: by 2002:a05:6918:7a89:b0:a4:b177:26e2 with HTTP; Sun, 13 Mar 2022
 20:06:49 -0700 (PDT)
From:   "Mr.Sal kavar" <salkavar2@gmail.com>
Date:   Mon, 14 Mar 2022 04:06:49 +0100
X-Google-Sender-Auth: aAFiYTrjkI5GD45oIodUHc9dDJk
Message-ID: <CAL3Nt6hTxTZ4ZWGJsZ9UZwfJqEhUE4Sf1TpZ-gb=mOfYT92gng@mail.gmail.com>
Subject: Yours Faithful,
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=3.7 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO_END_DIGIT,LOTS_OF_MONEY,MILLION_HUNDRED,
        MONEY_FRAUD_8,MONEY_FREEMAIL_REPTO,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,T_HK_NAME_FM_MR_MRS,T_MONEY_PERCENT,T_SCC_BODY_TEXT_LINE,
        UNDISC_MONEY autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: ***
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

I assume you and your family are in good health. I am the foreign
operations Manager

This being a wide world in which it can be difficult to make new
acquaintances and because it is virtually impossible to know who is
trustworthy and who can be believed, i have decided to repose
confidence in you after much fasting and prayer. It is only because of
this that I have decided to confide in you and to share with you this
confidential business.

overdue and unclaimed sum of $15.5m, (Fifteen Million Five Hundred
Thousand Dollars Only) when the account holder suddenly passed on, he
left no beneficiary who would be entitled to the receipt of this fund.
For this reason, I have found it expedient to transfer this fund to a
trustworthy individual with capacity to act as foreign business
partner.

Thus i humbly request your assistance to claim this fund. Upon the
transfer of this fund in your account, you will take 45% as your share
from the total fund, 10% will be shared to Charity Organizations in
both country and 45% will be for me.

Yours Faithful,
Mr.Sal Kavar.
