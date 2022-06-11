Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C0421547474
	for <lists+ceph-devel@lfdr.de>; Sat, 11 Jun 2022 14:20:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230303AbiFKMUg (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Sat, 11 Jun 2022 08:20:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229702AbiFKMUf (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Sat, 11 Jun 2022 08:20:35 -0400
Received: from mail-io1-xd33.google.com (mail-io1-xd33.google.com [IPv6:2607:f8b0:4864:20::d33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57C2113DF3
        for <ceph-devel@vger.kernel.org>; Sat, 11 Jun 2022 05:20:34 -0700 (PDT)
Received: by mail-io1-xd33.google.com with SMTP id p128so1554946iof.1
        for <ceph-devel@vger.kernel.org>; Sat, 11 Jun 2022 05:20:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:reply-to:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=XbdOdn7uobFHsuN9XLMlNq65m3JV0c6v1jahkCkk1ss=;
        b=O+NB+slHVcFCFFjdo+z680lbMFQrfgzvqwMUbvSUUnC7m4MS7SafA02kDiUxUzeeg1
         9CPFxHLabXcw+/KogR7YITS2otSA/D2FUXeXYAisiTIUdRoU7lUqE4UEjeNaG4ZMN2oe
         lpoGeTDevTmRWBy7NSGI5ptuc54Zg4GAVXQBzZC9Q0S3njU6TCS86RU08ETpzf2Fiykz
         RjotJLe2ycJrGkbFV3Mf4Ca2VUySAI7BUvP9QQvCjM8dWu3oxx+HUrnjohXIzBGxkjN/
         UF64hFAdtBeGuKB+qTS4BE8wtYZoOpBRYiny47aDHtlaBd5XBE0bI2Tv6e8lb79e+r5x
         tPLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:reply-to:from:date:message-id
         :subject:to:content-transfer-encoding;
        bh=XbdOdn7uobFHsuN9XLMlNq65m3JV0c6v1jahkCkk1ss=;
        b=S0a1Ekxlf8laB0NDmsAdJ9Gs6UtmrcphD4rhDHI9r87cYb+X1EvHfg1d9lCK4ci72K
         lnkh8yuJ81mMvZqdKHSbch8Y9+ndWEqAUvHcHq1CrG7eUd4VgpoaKy9sMvTfrutlPolO
         3pBk8+bCeTCmQA6Bc2ZMLLU8EqCWo6/Xsr6qRGG8SWfjBgMTb271dQZ1bQRXhVJXTVuE
         k0TY7kTUoR7oe3GDd4/GxW86fih1l7YgHGbUAbeuCp1emtRbczDgdHMRjW3iIIjP6GLL
         XjA2J9SJuMFNHnwj5ZZ3c3lfYTWT/yRRoAvwge3UlpdPN0J4p1WPpa8baVTZZb5Tnr+h
         mjTA==
X-Gm-Message-State: AOAM531b/KgqU+vZ9n8CHkVCLLafpxmkw4c46OOLBln0duuIxWZCf4sI
        zqDylOaRVrzZ6Nw28lajxLr8gXFXbfrvhXwDayM=
X-Google-Smtp-Source: ABdhPJy6zqVInna47XL58hzi+EbfpHw7TZx6u6yhmsPiSzmqpd9gXfcjT44HU0+NtBpaIW+sck25dCoyZ41Wm4oGa28=
X-Received: by 2002:a02:6a6b:0:b0:323:fcf9:2227 with SMTP id
 m43-20020a026a6b000000b00323fcf92227mr26929880jaf.137.1654950033273; Sat, 11
 Jun 2022 05:20:33 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a05:6622:104c:0:0:0:0 with HTTP; Sat, 11 Jun 2022 05:20:32
 -0700 (PDT)
Reply-To: stefanopessina92@gmail.com
From:   stefano pessina <elisifawagikuyu@gmail.com>
Date:   Sat, 11 Jun 2022 05:20:32 -0700
Message-ID: <CAFkGWZa=3_j7ziRpzfeODRRS3rN5kVRvrDO9yHvfJ-q5DHwwfQ@mail.gmail.com>
Subject: =?UTF-8?B?R2zDvGNrd3Vuc2No?=
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=4.1 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,FREEMAIL_REPLYTO,
        FREEMAIL_REPLYTO_END_DIGIT,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,UNDISC_FREEM autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Level: ****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

--=20
Die Summe von 1.500.000,00 =E2=82=AC wurde Ihnen von STEFANO PESSINA
gespendet. Bitte kontaktieren Sie uns f=C3=BCr weitere Informationen per
stefanopessina92@gmail.com
