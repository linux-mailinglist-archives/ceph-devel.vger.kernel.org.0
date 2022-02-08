Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F9D14AD02E
	for <lists+ceph-devel@lfdr.de>; Tue,  8 Feb 2022 05:11:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346558AbiBHELd (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 7 Feb 2022 23:11:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344043AbiBHELc (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 7 Feb 2022 23:11:32 -0500
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CB8EC0401DC
        for <ceph-devel@vger.kernel.org>; Mon,  7 Feb 2022 20:11:32 -0800 (PST)
Received: by mail-pj1-x1041.google.com with SMTP id g15-20020a17090a67cf00b001b7d5b6bedaso1396615pjm.4
        for <ceph-devel@vger.kernel.org>; Mon, 07 Feb 2022 20:11:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:reply-to:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=4HWW3srFwPeoeibWEbuFvJKgAXfTYBcpWGvdOE3ZrkM=;
        b=NGmCHjD9xS/vhthg2c0kE9x6Up1v3czTz0fYlp+eteLFKn4QTMgz4zife7C/iae7O/
         FJcExb4QLfBd+VTa8Lk2TBHp4I5vrNeMs5xq3iZl+k/tcgtNchRnL9DtgsYUyhi2Bhop
         C3bh4m3OBzJmxwJCBRCunsOjAz3uXhrUC4LRru6Ax+vsX8i78T8M8vJU/J8KVPnQcAjk
         JNexHN2Gcbn0zetHzTi4DPTS5SH7OrPmxmEhCg0puEByPDSsNnjZ4+/0Qhll7dIL8nOZ
         +InepEANihq1NfccjVJqqK26TgWkG5fA0clEfQE52A1T5XCuvZKlBmoAsV9I8r9VcPsC
         8Sxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:reply-to:from:date:message-id
         :subject:to:content-transfer-encoding;
        bh=4HWW3srFwPeoeibWEbuFvJKgAXfTYBcpWGvdOE3ZrkM=;
        b=h7/FLw0Q0G63+QBRkjm5hSGmekCNO62EaJXvyOuEASzslAQ/bmoGi0hXAHINTjQSB9
         DlUkxK+j+xpjwdqCH3LXU+nlb+BKaIW3PEvbc/fd+m8XuKWsKYgjWxGDcBnqDDiI8L7q
         XIyDK7ijfXGF3RkNquC5wcKAVaBfkBmsa7UA/09UmWM1cRMjrMU2jGuVIWnWxm3rAX5B
         ZUnKTvBbHVZqEC8AUdkzU2WAOLfIEK/NsO0SHNvmwOw0Y9WA/xuzda4AFDktuaEp1Egr
         6BbVyub3EkIm2qmimlzzAfuXGrNWBqIgv6fSl+BkOdsCyhEIEDnqMenFnww35mViKU1O
         dQvw==
X-Gm-Message-State: AOAM533Drj37tPzW8PY0Ry3luJ2lQRRQm3noOgKgqVKEw5kW2EU0E1Pe
        KPGfLIISADyUhw5wf9JNSBtgv1AqJJJJQUBJw00=
X-Google-Smtp-Source: ABdhPJy98odlWAEVLCRtiT2/nBCDQ7HjDdmdZUPPz7eV+FUuorsr/1Uyq6godsvXoj8k+R0xQ4Q8y4DAXgFYCCa8gcc=
X-Received: by 2002:a17:90a:741:: with SMTP id s1mr2401900pje.161.1644293491493;
 Mon, 07 Feb 2022 20:11:31 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:a05:6a10:178d:0:0:0:0 with HTTP; Mon, 7 Feb 2022 20:11:30
 -0800 (PST)
Reply-To: selassie.abebe@yandex.com
From:   "Mr. Timo Helenius" <juanangelino0001@gmail.com>
Date:   Mon, 7 Feb 2022 20:11:30 -0800
Message-ID: <CAE93Of2dv8bAguKdgkWjrW+UUGb-Mu_+pV1krmevrcPMr4e4Bw@mail.gmail.com>
Subject: Revamped Catastrophe
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: Yes, score=5.2 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,T_HK_NAME_FM_MR_MRS,T_SCC_BODY_TEXT_LINE,UNDISC_FREEM
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2607:f8b0:4864:20:0:0:0:1041 listed in]
        [list.dnswl.org]
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.5000]
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [juanangelino0001[at]gmail.com]
        *  0.2 FREEMAIL_ENVFROM_END_DIGIT Envelope-from freemail username ends
        *       in digit
        *      [juanangelino0001[at]gmail.com]
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        *  0.0 T_HK_NAME_FM_MR_MRS No description available.
        * -0.0 T_SCC_BODY_TEXT_LINE No description available.
        *  3.4 UNDISC_FREEM Undisclosed recipients + freemail reply-to
        *  1.0 FREEMAIL_REPLYTO Reply-To/From or Reply-To/body contain
        *      different freemails
X-Spam-Level: *****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

--=20
The International Monetary Fund (IMF) Executive Board has approved
immediate grant relief for citizen of 25 IMF's members nation.

This is under the IMF=E2=80=99s revamped Catastrophe Containment and Relief
Trust (CCRT) as part of the Fund=E2=80=99s response to help address the imp=
act
of the COVID-19 pandemic.
Reply to this
Email;selassie.abebe@yandex.com
Best regards and Stay Safe
Mr. Timo Helenius
Copyright @ 2022
