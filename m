Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4AC7D4EB5C4
	for <lists+ceph-devel@lfdr.de>; Wed, 30 Mar 2022 00:19:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236537AbiC2WUp (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 29 Mar 2022 18:20:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236522AbiC2WUo (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 29 Mar 2022 18:20:44 -0400
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BE8120F4B
        for <ceph-devel@vger.kernel.org>; Tue, 29 Mar 2022 15:19:01 -0700 (PDT)
Received: by mail-wr1-x434.google.com with SMTP id j18so26740423wrd.6
        for <ceph-devel@vger.kernel.org>; Tue, 29 Mar 2022 15:19:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:mime-version:content-transfer-encoding
         :content-description:subject:to:from:date:reply-to;
        bh=+v//v9bV1cKxYYqp6E5HrJfuFydY/JXcjMGnmfr7lM0=;
        b=bzZbLwsT5/G4KFYHvAtKvtNLNvmsohbIts4GcVgmqNVVTswr2jmRAo8ZVZmBeyUTaO
         PurG7r84N2K2ec/5pnBmRaRXxTe6/OAYMJkAVUcyx5yhO1e3bQ9TIkx44qQixNJhKtm1
         ZJQdtKD9GgjUC5yYS462ZXB4D410qiTmpw/KLhfSqvhEgEipvYDwbCkdKQIQUJN6Hy/B
         MNethqkXhlDjwm9P+vgc3ORRUY/JlpvP50Ak3LAWtV5MQbfvDuUiOsz8DQjVTkYmUz8T
         59h0av22b7bZjbM4QZytGeKlxnVh15JJVub6R/ISLxJJpF5lLyc0UyyJsH3VBN87p5Gr
         E8rA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:mime-version
         :content-transfer-encoding:content-description:subject:to:from:date
         :reply-to;
        bh=+v//v9bV1cKxYYqp6E5HrJfuFydY/JXcjMGnmfr7lM0=;
        b=CtQL6sj056iNYFGRGFNMBibSbmyn203gZkrpAfZDm4wH8VxJJMBPsd6gbD5tRXTqaC
         S96D133QhdgaLpzgxlf4U5KhcA6BeG2IRdnetiyWn6aynQKZSG+QBdV3wFQfqAu3+GKG
         F6NFAjTMoRrEAEl68QIcbM/PIGoT39UYaX4q1du1Cmv4SAFphk9Kjv6Y8xJriunq72kw
         k9U1S03jcFyLaMNf1el0SE0Am8jO6uEQRR3qxCcFHxYfy5LqjYh+ZSW9fe8jzWBFGHQa
         NWQh+61uXxMsSRV39RgEBj+Rf6GW6jcVpedRqzL89rQLE3UQSyddB+QI0AkJtPiFqWX8
         VmlQ==
X-Gm-Message-State: AOAM530x9pJRQBCSIRgZFK1tQoXhhhQ8RAdFLTC5zCBU1Fd43nmnGfJd
        Hp70ZR73NDH/Q+SzEYCt83Q=
X-Google-Smtp-Source: ABdhPJwafoDe5xCvHMEC6SNyv0sqTW58jgHE95KTOfCVsoZXwkniYm6e7s+QtyU85cNZQtZmgdgs2Q==
X-Received: by 2002:a5d:504d:0:b0:203:e60e:49ef with SMTP id h13-20020a5d504d000000b00203e60e49efmr33885524wrt.546.1648592339731;
        Tue, 29 Mar 2022 15:18:59 -0700 (PDT)
Received: from [172.20.10.4] ([102.91.4.172])
        by smtp.gmail.com with ESMTPSA id g17-20020a05600c4ed100b0038ca32d0f26sm3545064wmq.17.2022.03.29.15.18.55
        (version=TLS1 cipher=AES128-SHA bits=128/128);
        Tue, 29 Mar 2022 15:18:59 -0700 (PDT)
Message-ID: <624385d3.1c69fb81.545b4.ec3d@mx.google.com>
Content-Type: text/plain; charset="iso-8859-1"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Description: Mail message body
Subject: Gefeliciteerd, er is geld aan je gedoneerd
To:     Recipients <adeboyejofolashade55@gmail.com>
From:   adeboyejofolashade55@gmail.com
Date:   Tue, 29 Mar 2022 23:18:50 +0100
Reply-To: mike.weirsky.foundation003@gmail.com
X-Spam-Status: No, score=2.4 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,FREEMAIL_REPLYTO_END_DIGIT,
        LOTS_OF_MONEY,MONEY_FREEMAIL_REPTO,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,T_US_DOLLARS_3 autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Level: **
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Beste begunstigde,

 Je hebt een liefdadigheidsdonatie van ($ 10.000.000,00) van Mr. Mike Weirs=
ky, een winnaar van een powerball-jackpotloterij van $ 273 miljoen.  Ik don=
eer aan 5 willekeurige personen als je deze e-mail ontvangt, dan is je e-ma=
il geselecteerd na een spin-ball. Ik heb vrijwillig besloten om het bedrag =
van $ 10 miljoen USD aan jou te doneren als een van de geselecteerde 5, om =
mijn winst te verifi=EBren
 =

  Vriendelijk antwoord op: mike.weirsky.foundation003@gmail.com
 Voor uw claim.
