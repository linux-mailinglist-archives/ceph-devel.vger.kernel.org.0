Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EE9DB4C10AE
	for <lists+ceph-devel@lfdr.de>; Wed, 23 Feb 2022 11:48:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238907AbiBWKs5 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 23 Feb 2022 05:48:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237755AbiBWKs4 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 23 Feb 2022 05:48:56 -0500
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 302A35A0BA
        for <ceph-devel@vger.kernel.org>; Wed, 23 Feb 2022 02:48:29 -0800 (PST)
Received: by mail-wr1-x430.google.com with SMTP id p9so38845060wra.12
        for <ceph-devel@vger.kernel.org>; Wed, 23 Feb 2022 02:48:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:from:mime-version:content-transfer-encoding
         :content-description:subject:to:date:reply-to;
        bh=eaaB5Fi4OIw8X99OdVt3/5VwsoSH3pqqZ03p7mumtcE=;
        b=edMJZSBQEhAZRjGd0CzjEBigO0//mLUFiVkoXvTZxVmAZa0cBgBALLO8UBeu5LauPN
         IfwGfF0k1nYMYQ0m1wd4HZNNQIG+kQjXI2QWUgeubfg6x9Jv+QldFMySqu1OeYgB30GI
         N7cG+cYolaVxsqmIeh+pZ8YX2ylLG/46Byb4un2ldtTYdTRgPY5CoXF8WEjXhegP2ZSM
         n6MDF/FvUi/jM5Hu+Vml+cPIMq+3jSua3FqZyqqs5WtlaUJuSrg/jT7MfIoV0Q+QOdnw
         imaZe83dBQqjWMuAwvT6NNoWZoqZUrBavdh2NYVNa6eMFEt2GA5lvafAAmOOr2qiW4kA
         KnLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:from:mime-version
         :content-transfer-encoding:content-description:subject:to:date
         :reply-to;
        bh=eaaB5Fi4OIw8X99OdVt3/5VwsoSH3pqqZ03p7mumtcE=;
        b=tclRks3BL/K8GKP4gojKaRw4HcVyYg1N5OQ0SVSPQhymHV1DgdSo/e7CaqHsmN7pYW
         rAArsNfZTk/7yS44w8PIb75zMH0pWuSTXQ5HDktfjjDqb8NSyyqF/G2S9yrs9QVuyiY8
         MTrcUeKRclIgwivu4oaa6oLJP7w75vbYBcAsObv+1CcrehaOf8Qa9xiLw+A3bbaIZcN9
         EkjYAyp2nUwVQfH76Z01UGQ+ssj91CDq1meZT6dY0pDcZBOWzAZEr+zU8uJJfpkypPEM
         qODTz+J7wCPBnM19mJG45tSZoJIJw+Rl4DXrAo/2IxufrzZM+bUasdFOUnC1Pjq06sqN
         OhbA==
X-Gm-Message-State: AOAM531yXobhNSPlOgu4dKhJ7uKWSAYLLUvPko9FXl+QOUF3XYVFFEXd
        Ysef6iUYkNmpVO1/VAHuTQc=
X-Google-Smtp-Source: ABdhPJzIrK3yaiTgqnqs6Us6k97ogpgR2ar1O1TwhtpX0CTWfurLL6zcTzAoWBxoP/jbpF2gLaIn4Q==
X-Received: by 2002:adf:ce82:0:b0:1e3:2bdd:8243 with SMTP id r2-20020adfce82000000b001e32bdd8243mr22551859wrn.259.1645613307833;
        Wed, 23 Feb 2022 02:48:27 -0800 (PST)
Received: from [192.168.0.133] ([5.193.8.34])
        by smtp.gmail.com with ESMTPSA id h10sm48947274wrt.57.2022.02.23.02.48.24
        (version=TLS1 cipher=AES128-SHA bits=128/128);
        Wed, 23 Feb 2022 02:48:26 -0800 (PST)
Message-ID: <621610fa.1c69fb81.ffe6a.d4ee@mx.google.com>
From:   Mrs Maria Elisabeth Schaeffler 
        <canadainvestigationboard@gmail.com>
X-Google-Original-From: Mrs Maria Elisabeth Schaeffler
Content-Type: text/plain; charset="iso-8859-1"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Description: Mail message body
Subject: Spende
To:     Recipients <Mrs@vger.kernel.org>
Date:   Wed, 23 Feb 2022 14:48:19 +0400
Reply-To: elisabethschaeffler01@gmail.com
X-Spam-Status: No, score=2.0 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,FREEMAIL_REPLYTO,
        FREEMAIL_REPLYTO_END_DIGIT,LOTS_OF_MONEY,MONEY_FREEMAIL_REPTO,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,TO_MALFORMED,
        T_HK_NAME_FM_MR_MRS,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Hallo,

Ich bin Frau Maria Elisabeth Schaeffler, eine deutsche Wirtschaftsmagnatin,=
 Investorin und Philanthropin. Ich bin der Vorsitzende von Wipro Limited. I=
ch habe 25 Prozent meines pers=F6nlichen Verm=F6gens f=FCr wohlt=E4tige Zwe=
cke ausgegeben. Und ich habe auch versprochen zu geben
der Rest von 25% geht dieses Jahr 2021 an Einzelpersonen. Ich habe mich ent=
schlossen, Ihnen 1.500.000,00 Euro zu spenden. Wenn Sie an meiner Spende in=
teressiert sind, kontaktieren Sie mich f=FCr weitere Informationen.

Sie k=F6nnen auch =FCber den untenstehenden Link mehr =FCber mich lesen


https://en.wikipedia.org/wiki/Maria-Elisabeth_Schaeffler

Sch=F6ne Gr=FC=DFe
Gesch=E4ftsf=FChrer Wipro Limited
Maria-Elisabeth_Schaeffler
Email: elisabethschaeffler01@gmail.com
