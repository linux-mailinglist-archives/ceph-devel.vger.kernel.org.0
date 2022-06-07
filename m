Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB1BB53F8A0
	for <lists+ceph-devel@lfdr.de>; Tue,  7 Jun 2022 10:50:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238488AbiFGIuu (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 7 Jun 2022 04:50:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238943AbiFGIum (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 7 Jun 2022 04:50:42 -0400
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBC15F04
        for <ceph-devel@vger.kernel.org>; Tue,  7 Jun 2022 01:50:39 -0700 (PDT)
Received: by mail-ed1-x52f.google.com with SMTP id v19so22022507edd.4
        for <ceph-devel@vger.kernel.org>; Tue, 07 Jun 2022 01:50:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:reply-to:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=dk8zUgPEAH8sJMme+gRlsmI7BdAAwGXVFJaTHtWa1SI=;
        b=piavf1+J8QZOu2mSKKzlgiMJC2Z0x8ZM1lIbDIg1jzO7wcDRtX3GgORlW3GaJqKLtF
         pVNR6wpwruWcPMDmta6EJg4xkgaDO+k0cdR7LB7NB2vhie21C7BApeYO7cqX1J74iRAd
         R3B4HSqfkvgNirn/KcqhrVEDZbGOmrVnnMgZO+KGvRQDJy6UbW5Y+0DYqKUCeAuUTwvK
         lqYPBgFL2Nu4Gdfbt9w595FC8QxUivfRhXW1RRaTVdrr87DAb4lhBtORqaT52eCwL/gf
         pyhUE63/FmvTFn+KmVQv/UGRcUbHBo6xWFZ01n7+zM8I84EF0QT1qLAHJ9g7yJRYEKSH
         9PnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:reply-to:from:date:message-id
         :subject:to:content-transfer-encoding;
        bh=dk8zUgPEAH8sJMme+gRlsmI7BdAAwGXVFJaTHtWa1SI=;
        b=PQmddZP8ht1AaIe1+f8JyJDlSWdYJuKV9IAxQMSMhfI8OUrOlh1OJ13a6XLVtGu/Xg
         /7JUwRy0xHknAYwRn0sNc/sjeDM6SCOiKmzp2CJaLmzKwoUwQrk5klbMHG6iMlGXyosN
         ASeKnOucx6Q42WdXEQULXt3XQOXA5L0vJVzp4B3WqAwwuizWmETGNGgaUVFXz5Q3lQQ9
         KyWCY9EWjlEyDSSfxWvrNyZKN08fXHv0lzoLldO0KuKjCtBO3Hv3Nl1G6w9uJq8YONZ/
         9/qnk/taZERRqDaY0iaX0I0GP0dLWAYWVekp2pnQHOIEdeiqLBuMineUFj7+WgpsspN1
         7DPQ==
X-Gm-Message-State: AOAM533floOhZ7t7B6+2DOW2RecqJmkDD3XWfvfsvGkkpKs+UDQ4Et/4
        oCXmyMpr5qU4aO4sk6JL7c92H/DLh/y5mXxNSCk=
X-Google-Smtp-Source: ABdhPJz+IIW/xQcV2hDU7qV2G/vnC45WUlHu8PvswcZOR2/dg7cU7UfcLHYz7FVJi5tbto8a9QsNbQ3/LOLYy/DIGiE=
X-Received: by 2002:a05:6402:cab:b0:42d:c842:8369 with SMTP id
 cn11-20020a0564020cab00b0042dc8428369mr31781463edb.181.1654591838360; Tue, 07
 Jun 2022 01:50:38 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a54:21cc:0:0:0:0:0 with HTTP; Tue, 7 Jun 2022 01:50:37 -0700 (PDT)
Reply-To: robertbaileys_spende@aol.com
From:   Robert Baileys <yusifmaigari222@gmail.com>
Date:   Tue, 7 Jun 2022 10:50:37 +0200
Message-ID: <CA+gykmDkUk6C_OBBa6afOgT9Yq4A3P6FETEA2DMxgxiNnQNv=w@mail.gmail.com>
Subject: 
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: Yes, score=7.4 required=5.0 tests=BAYES_60,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,LOTS_OF_MONEY,MONEY_FREEMAIL_REPTO,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        UNDISC_FREEM,UNDISC_MONEY autolearn=no autolearn_force=no version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2a00:1450:4864:20:0:0:0:52f listed in]
        [list.dnswl.org]
        *  1.5 BAYES_60 BODY: Bayes spam probability is 60 to 80%
        *      [score: 0.6375]
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.2 FREEMAIL_ENVFROM_END_DIGIT Envelope-from freemail username ends
        *       in digit
        *      [yusifmaigari222[at]gmail.com]
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [yusifmaigari222[at]gmail.com]
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        *  0.0 LOTS_OF_MONEY Huge... sums of money
        * -0.0 T_SCC_BODY_TEXT_LINE No description available.
        *  2.3 UNDISC_FREEM Undisclosed recipients + freemail reply-to
        *  2.0 MONEY_FREEMAIL_REPTO Lots of money from someone using free
        *      email?
        *  1.0 FREEMAIL_REPLYTO Reply-To/From or Reply-To/body contain
        *      different freemails
        *  0.6 UNDISC_MONEY Undisclosed recipients + money/fraud signs
X-Spam-Level: *******
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

--=20
Hallo, lieber Beg=C3=BCnstigter,

Sie haben diese E-Mail von der Robert Bailey Foundation erhalten. Ich
bin ein pensionierter Regierungsangestellter aus Harlem und ein
Powerball-Lotterie-Jackpot-Gewinner von 343,8 Millionen Dollar. Ich
bin der gr=C3=B6=C3=9Fte Jackpot-Gewinner in der Geschichte der New York Lo=
ttery
in Amerika. Ich habe diesen Wettbewerb am 27. Oktober 2018 gewonnen
und m=C3=B6chte Ihnen mitteilen, dass Google in Kooperation mit Microsoft
Ihre "E-Mail-Adresse" f=C3=BCr meine Anfrage hat und diese 3.000.000,00
Millionen Euro kosten wird. Ich spende diese 3 Millionen Euro an Sie,
um auch Wohlt=C3=A4tigkeitsorganisationen und armen Menschen in Ihrer
Gemeinde zu helfen, damit wir die Welt zu einem besseren Ort f=C3=BCr alle
machen k=C3=B6nnen. Bitte besuchen Sie die folgende Website f=C3=BCr weiter=
e
Informationen, damit Sie diesen 3 Mio. EUR Ausgaben nicht skeptisch
gegen=C3=BCberstehen.
https://nypost.com/2018/11/14/meet-the-winner-of-the-biggest-lottery-jackpo=
t-in-new-york-history/Sie
Weitere Best=C3=A4tigungen kann ich auch auf meinem Youtube suchen:
https://www.youtube.com/watch?v=3DH5vT18Ysavc
Bitte antworten Sie mir per E-Mail (robertbaileys_spende@aol.com).
Sie m=C3=BCssen diese E-Mail sofort beantworten, damit die =C3=BCberweisend=
e
Bank mit dem Erhalt dieser Spende in H=C3=B6he von 3.000.000,00 Millionen
Euro beginnen kann.
Bitte kontaktieren Sie die untenstehende E-Mail-Adresse f=C3=BCr weitere
Informationen, damit Sie diese Spende von der =C3=BCberweisenden Bank
erhalten k=C3=B6nnen.

E-Mail: robertbaileys_spende@aol.com

Gr=C3=BC=C3=9Fe,
Robert Bailey
* * * * * * * * * * * * * * * *
Powerball-Jackpot-Gewinner
E-Mail: robertbaileys_spende@aol.com
