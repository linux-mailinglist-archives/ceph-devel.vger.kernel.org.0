Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3942D74D502
	for <lists+ceph-devel@lfdr.de>; Mon, 10 Jul 2023 14:13:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230396AbjGJMNq (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 10 Jul 2023 08:13:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229679AbjGJMNp (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 10 Jul 2023 08:13:45 -0400
Received: from mail-yw1-x1136.google.com (mail-yw1-x1136.google.com [IPv6:2607:f8b0:4864:20::1136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1ED53B1
        for <ceph-devel@vger.kernel.org>; Mon, 10 Jul 2023 05:13:45 -0700 (PDT)
Received: by mail-yw1-x1136.google.com with SMTP id 00721157ae682-579ef51428eso56992337b3.2
        for <ceph-devel@vger.kernel.org>; Mon, 10 Jul 2023 05:13:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1688991224; x=1691583224;
        h=to:subject:message-id:date:from:sender:reply-to:mime-version:from
         :to:cc:subject:date:message-id:reply-to;
        bh=/2RlxWlOhJbOFxHHiWp08TsyEu+zJrfP5HNHS/WQHJU=;
        b=UMdHs67//27sYQ/MNEmrKCojqnM03niJU6O7M2n4ccl37Mcy0zd9knW80J6s9bjV6e
         YVtqtXBpD5E9VtQuL+KLw4ga7QBxsWJZC8Ol/p7I+Vx17LvhEeKbLOJqs4UOY/uFHpDJ
         npFC0D16e2hF7DyUr/xdgCqfHKoLI2lagLju2JGBLm3F5dnpFjMhxZAorkLg1BjH3Yy7
         jiT+7ZLgGjFbP+h4T3mAYCtiHq8uMPOFNbuunwB7URxZYw7UymmALIEwPqAnxEglYMwO
         54CrnUk4K0ZY+TwWBK6e0SX5xZoNm6KcEy9njN05UiepwOAVshfLTiHX8TbxDvW2PWe8
         vJ5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1688991224; x=1691583224;
        h=to:subject:message-id:date:from:sender:reply-to:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/2RlxWlOhJbOFxHHiWp08TsyEu+zJrfP5HNHS/WQHJU=;
        b=NPMTAOo71wLvTbSTAzF/6/mwLn1/0XgsiGLW6n8YMTlEcNXOxsCKLlDjxCQSmz9JDC
         1CR7MyKIzGmIcCou4aP0ZH7RwZbv0tQUBrj57aCd44V2EOIz4UUhyu4AExrzK+wKN0Lo
         2kpx0Lg3+qcOH6rwrPgrcneYdEx0NUO+VnYpwvGP9NVTJ9LmkzumZaW+IAb7rh/6bRu+
         CPwwZrF+SFm1YkMvBgll/PYC8hUzv32RnemIuxoZpdMq3eRHIjsPeBB2enwDlRWJQeKV
         BYhgyyLWpJH4PjvWyB6tePqPl5kP2WefBgWynd9N22Jrhh1aBFrMqbUssjAP064dtDsh
         Wc9A==
X-Gm-Message-State: ABy/qLaw6vuABA/pnxleoTwy9IvQaxe1oGZy798/+XQUq45GjvqjhHb8
        UgIIhak02sMM5KJotIXg/bPC+fhGGX/cO88tYw==
X-Google-Smtp-Source: APBJJlEsusX5ZtKZDrAO+acpz7n90+USHJQ0urG9mmGpY5w13G4m1Lybf9TF0zE1wr74c9JjHBNY87VmIZHIOrW764c=
X-Received: by 2002:a81:77c1:0:b0:57a:3d5e:f7d with SMTP id
 s184-20020a8177c1000000b0057a3d5e0f7dmr16483769ywc.29.1688991224182; Mon, 10
 Jul 2023 05:13:44 -0700 (PDT)
MIME-Version: 1.0
Reply-To: salkavar78@gmail.com
Sender: penelopeliam84@gmail.com
Received: by 2002:a05:7108:520d:b0:2f8:6076:7715 with HTTP; Mon, 10 Jul 2023
 05:13:43 -0700 (PDT)
From:   "Mr. Sal Kavar" <salkavar78@gmail.com>
Date:   Mon, 10 Jul 2023 05:13:43 -0700
X-Google-Sender-Auth: bs-q11nup4vDsfQut7vNTy4BO-M
Message-ID: <CAFeAMsQrB4rgU-ziadYvvGmimikt7P3XiskLh5UOe-f520376w@mail.gmail.com>
Subject: Yours Faithful,
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: Yes, score=5.9 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO_END_DIGIT,LOTS_OF_MONEY,MILLION_HUNDRED,
        MONEY_FREEMAIL_REPTO,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,
        T_HK_NAME_FM_MR_MRS,T_SCC_BODY_TEXT_LINE,UNDISC_MONEY autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Report: *  0.0 RCVD_IN_DNSWL_BLOCKED RBL: ADMINISTRATOR NOTICE: The query to
        *      DNSWL was blocked.  See
        *      http://wiki.apache.org/spamassassin/DnsBlocklists#dnsbl-block
        *      for more information.
        *      [2607:f8b0:4864:20:0:0:0:1136 listed in]
        [list.dnswl.org]
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.5190]
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        *  0.2 FREEMAIL_ENVFROM_END_DIGIT Envelope-from freemail username ends
        *       in digit
        *      [penelopeliam84[at]gmail.com]
        *  0.2 FREEMAIL_REPLYTO_END_DIGIT Reply-To freemail username ends in
        *      digit
        *      [salkavar78[at]gmail.com]
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [salkavar78[at]gmail.com]
        *  0.0 MILLION_HUNDRED BODY: Million "One to Nine" Hundred
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        * -0.0 T_SCC_BODY_TEXT_LINE No description available.
        *  0.0 T_HK_NAME_FM_MR_MRS No description available.
        *  0.0 LOTS_OF_MONEY Huge... sums of money
        *  1.6 MONEY_FREEMAIL_REPTO Lots of money from someone using free
        *      email?
        *  3.2 UNDISC_MONEY Undisclosed recipients + money/fraud signs
X-Spam-Level: *****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

I assume you and your family are in good health.

Overdue and unclaimed sum of $15.5m, (Fifteen Million Five Hundred
Thousand Dollars Only) when the account holder suddenly passed on, he
left no beneficiary who would be entitled to the receipt of this fund.

Yours Faithful,
Mr.Sal Kavar.
