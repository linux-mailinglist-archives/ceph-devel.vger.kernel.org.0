Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 27A01775CF5
	for <lists+ceph-devel@lfdr.de>; Wed,  9 Aug 2023 13:32:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233933AbjHILcc (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 9 Aug 2023 07:32:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233894AbjHILcc (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 9 Aug 2023 07:32:32 -0400
Received: from mail-yb1-xb2d.google.com (mail-yb1-xb2d.google.com [IPv6:2607:f8b0:4864:20::b2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F54C10D4
        for <ceph-devel@vger.kernel.org>; Wed,  9 Aug 2023 04:32:31 -0700 (PDT)
Received: by mail-yb1-xb2d.google.com with SMTP id 3f1490d57ef6-d18566dc0c1so7426764276.0
        for <ceph-devel@vger.kernel.org>; Wed, 09 Aug 2023 04:32:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1691580750; x=1692185550;
        h=content-transfer-encoding:to:subject:message-id:date:from:sender
         :reply-to:mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=9kydyMnwD//o0quRqImkimRYfrWW9k+FT8t/oHoxyE8=;
        b=qy3ztAQpWi9g2/mbpw6O59eql+rqsAgN7hBCpk6Y8/kqLnomESFcoccX9sODNMXc6l
         yQLnyprtY/5h+lThMDnyfLKFTSUeApSFaDXOipkU35OamgDY8E30NqNGEdtA/PaqFNjp
         hcoRKLNh3jMm3FkY+/QX77VSK9WxmZ+HJdNEu7J7RVueSyfNxhkOoru0nQmHSngYLfAp
         lum79oefCz9DZlGvTet7yHOwRd/A90CcwuGIkZ7t3NZ0R5U3YwW59B4PONIMC6Oim3h0
         IuLC+OgO9n0dGnZ2QCa1T3zS+npfS8GeiyB7MKutEOrO63lNiALbsgJ5W0YTmoEqTOK1
         lqCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691580750; x=1692185550;
        h=content-transfer-encoding:to:subject:message-id:date:from:sender
         :reply-to:mime-version:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9kydyMnwD//o0quRqImkimRYfrWW9k+FT8t/oHoxyE8=;
        b=S3wOoIO1ZhKats8eVyfgf5u039rmPyxjSVUheJ8UIZzxzLuLE9I6JF4LKpE6njTSgi
         NuNA7fEba9TVcG2O96oDR1ffQ7KLXcpn0NggAt08VMadPFfYN4MaexHDHsinEizKVlrs
         gI3QA/fqQYrM7FSkXfp687hbDOBzSinytBkHIjN7RSyj0FkXOSrQTixo2ZmR+5yCwj4r
         Gm9FsuKck5CpcZGjkh9iCytQBIlbBMGkiyeK8ZtCRPr4XnXKmhxIBnbbel+vm83ueMv/
         RmGDyIPyttMyCZLRhj98VMp2VPK3acgtOkvvCWXzB84vX8i1S/TJeTGq3fw8W3sztVo3
         QmSg==
X-Gm-Message-State: AOJu0YwfeF9EGCQiEjyzMX6u8sjq5KFuDjUp0aieDMrrDvgcBNOw2Csd
        UvL/GXdMpF6F12eqXO5D1Pe1CMxTXheUy6+6GdE=
X-Google-Smtp-Source: AGHT+IFymFwOefdiBHJb10yG9bAEEUCeSDTAAecVoO9pR0EG8go29sSFF3OGpMtM0HHdOQSTcLX6CW6DSFDg9WhsRr0=
X-Received: by 2002:a25:df8c:0:b0:d35:8e23:2df1 with SMTP id
 w134-20020a25df8c000000b00d358e232df1mr2161220ybg.16.1691580750420; Wed, 09
 Aug 2023 04:32:30 -0700 (PDT)
MIME-Version: 1.0
Reply-To: razumkoykhailo@gmail.com
Sender: mr.leonharris111@gmail.com
Received: by 2002:a05:7010:4588:b0:36f:cc5:bd6 with HTTP; Wed, 9 Aug 2023
 04:32:30 -0700 (PDT)
From:   "Mr.Razum Khailo" <razumkoykhailo@gmail.com>
Date:   Wed, 9 Aug 2023 04:32:30 -0700
X-Google-Sender-Auth: dSV8BDTA9fnzQt7BD0Tq_c61k1U
Message-ID: <CANg__WRnJ-rT_pvwQPWJLztMU8-H-c3ZJAR+EN_Ob4mUt=oAXg@mail.gmail.com>
Subject: Greetings from Ukraine,
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: base64
X-Spam-Status: Yes, score=5.9 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,LOTS_OF_MONEY,MILLION_USD,MONEY_FREEMAIL_REPTO,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,T_HK_NAME_FM_MR_MRS,
        UNDISC_MONEY autolearn=no autolearn_force=no version=3.4.6
X-Spam-Report: *  0.0 RCVD_IN_DNSWL_BLOCKED RBL: ADMINISTRATOR NOTICE: The query to
        *      DNSWL was blocked.  See
        *      http://wiki.apache.org/spamassassin/DnsBlocklists#dnsbl-block
        *      for more information.
        *      [2607:f8b0:4864:20:0:0:0:b2d listed in]
        [list.dnswl.org]
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.4998]
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [mr.leonharris111[at]gmail.com]
        *  0.2 FREEMAIL_ENVFROM_END_DIGIT Envelope-from freemail username ends
        *       in digit
        *      [mr.leonharris111[at]gmail.com]
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.0 MILLION_USD BODY: Talks about millions of dollars
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        *  0.0 T_HK_NAME_FM_MR_MRS No description available.
        *  0.0 LOTS_OF_MONEY Huge... sums of money
        *  2.2 MONEY_FREEMAIL_REPTO Lots of money from someone using free
        *      email?
        *  2.8 UNDISC_MONEY Undisclosed recipients + money/fraud signs
X-Spam-Level: *****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

R3JlZXRpbmdzwqBmcm9twqBVa3JhaW5lLA0KDQpNci7CoFJhenVta292wqBNeWtoYWlsbyzCoGFu
wqBlbnRyZXByZW5ldXLCoGJ1c2luZXNzbWFuwqBmcm9twqBPZGVzc2ENClVrcmFpbmUuwqBXaXRo
aW7CoGHCoHllYXLCoHBsdXPCoHNvbWXCoG1vbnRoc8Kgbm93LMKgbW9yZcKgdGhhbsKgOC4ywqBt
aWxsaW9uDQpwZW9wbGXCoGFyb3VuZMKgdGhlwqBjaXRpZXPCoG9mwqBtecKgY291bnRyecKgVWty
YWluZcKgaGF2ZcKgYmVlbsKgZXZhY3VhdGVkwqB0bw0KYcKgc2FmZcKgbG9jYXRpb27CoGFuZMKg
b3V0wqBvZsKgdGhlwqBjb3VudHJ5LMKgbW9zdMKgZXNwZWNpYWxsecKgY2hpbGRyZW7CoHdpdGgN
CnRoZWlywqBwYXJlbnRzLMKgbnVyc2luZ8KgbW90aGVyc8KgYW5kwqBwcmVnbmFudMKgd29tZW4s
wqBhbmTCoHRob3NlwqB3aG/CoGhhdmUNCmJlZW7CoHNlcmlvdXNsecKgd291bmRlZMKgYW5kwqBu
ZWVkwqB1cmdlbnTCoG1lZGljYWzCoGF0dGVudGlvbi7CoEnCoHdhc8KgYW1vbmcNCnRob3NlwqB0
aGF0wqB3ZXJlwqBhYmxlwqB0b8KgZXZhY3VhdGXCoHRvwqBvdXLCoG5laWdoYm91cmluZ8KgY291
bnRyaWVzwqBhbmTCoEnigJltDQpub3fCoGluwqB0aGXCoHJlZnVnZWXCoGNhbXDCoG9mwqBUZXLC
oEFwZWzCoEdyb25pbmdlbsKgaW7CoHRoZcKgTmV0aGVybGFuZHMuDQoNCknCoG5lZWTCoGHCoGZv
cmVpZ27CoHBhcnRuZXLCoHRvwqBlbmFibGXCoG1lwqB0b8KgdHJhbnNwb3J0wqBtecKgaW52ZXN0
bWVudA0KY2FwaXRhbMKgYW5kwqB0aGVuwqByZWxvY2F0ZcKgd2l0aMKgbXnCoGZhbWlseSzCoGhv
bmVzdGx5wqBpwqB3aXNowqBJwqB3aWxsDQpkaXNjdXNzwqBtb3JlwqBhbmTCoGdldMKgYWxvbmcu
wqBJwqBuZWVkwqBhwqBwYXJ0bmVywqBiZWNhdXNlwqBtecKgaW52ZXN0bWVudA0KY2FwaXRhbMKg
aXPCoGluwqBtecKgaW50ZXJuYXRpb25hbMKgYWNjb3VudC7CoEnigJltwqBpbnRlcmVzdGVkwqBp
bsKgYnV5aW5nDQpwcm9wZXJ0aWVzLMKgaG91c2VzLMKgYnVpbGRpbmfCoHJlYWzCoGVzdGF0ZXMs
wqBtecKgY2FwaXRhbMKgZm9ywqBpbnZlc3RtZW50DQppc8KgKCQzMMKgTWlsbGlvbsKgVVNEKcKg
LsKgVGhlwqBmaW5hbmNpYWzCoGluc3RpdHV0aW9uc8KgaW7CoG15wqBjb3VudHJ5DQpVa3JhaW5l
wqBhcmXCoGFsbMKgc2hvdMKgZG93bsKgZHVlwqB0b8KgdGhlwqBjcmlzaXPCoG9mwqB0aGlzwqB3
YXLCoG9uwqBVa3JhaW5lDQpzb2lswqBiecKgdGhlwqBSdXNzaWFuwqBmb3JjZXMuwqBNZWFud2hp
bGUswqBpZsKgdGhlcmXCoGlzwqBhbnnCoHByb2ZpdGFibGUNCmludmVzdG1lbnTCoHRoYXTCoHlv
dcKgaGF2ZcKgc2/CoG11Y2jCoGV4cGVyaWVuY2XCoGluwqB5b3VywqBjb3VudHJ5LMKgdGhlbsKg
d2UNCmNhbsKgam9pbsKgdG9nZXRoZXLCoGFzwqBwYXJ0bmVyc8Kgc2luY2XCoEnigJltwqBhwqBm
b3JlaWduZXIuDQoNCknCoGNhbWXCoGFjcm9zc8KgeW91csKgZS1tYWlswqBjb250YWN0wqB0aHJv
dWdowqBwcml2YXRlwqBzZWFyY2jCoHdoaWxlwqBpbsKgbmVlZA0Kb2bCoHlvdXLCoGFzc2lzdGFu
Y2XCoGFuZMKgScKgZGVjaWRlZMKgdG/CoGNvbnRhY3TCoHlvdcKgZGlyZWN0bHnCoHRvwqBhc2vC
oHlvdcKgaWYNCnlvdcKga25vd8KgYW55wqBsdWNyYXRpdmXCoGJ1c2luZXNzwqBpbnZlc3RtZW50
wqBpbsKgeW91csKgY291bnRyecKgacKgY2FuDQppbnZlc3TCoG15wqBtb25lecKgc2luY2XCoG15
wqBjb3VudHJ5wqBVa3JhaW5lwqBzZWN1cml0ecKgYW5kwqBlY29ub21pYw0KaW5kZXBlbmRlbnTC
oGhhc8KgbG9zdMKgdG/CoHRoZcKgZ3JlYXRlc3TCoGxvd2VywqBsZXZlbCzCoGFuZMKgb3VywqBj
dWx0dXJlwqBoYXMNCmxvc3TCoGluY2x1ZGluZ8Kgb3VywqBoYXBwaW5lc3PCoGhhc8KgYmVlbsKg
dGFrZW7CoGF3YXnCoGZyb23CoHVzLsKgT3VywqBjb3VudHJ5DQpoYXPCoGJlZW7CoG9uwqBmaXJl
wqBmb3LCoG1vcmXCoHRoYW7CoGHCoHllYXLCoG5vdy4NCg0KSWbCoHlvdcKgYXJlwqBjYXBhYmxl
wqBvZsKgaGFuZGxpbmfCoHRoaXPCoGJ1c2luZXNzwqBwYXJ0bmVyc2hpcCzCoGNvbnRhY3TCoG1l
DQpmb3LCoG1vcmXCoGRldGFpbHMswqBJwqB3aWxswqBhcHByZWNpYXRlwqBpdMKgaWbCoHlvdcKg
Y2FuwqBjb250YWN0wqBtZQ0KaW1tZWRpYXRlbHkuwqBZb3XCoG1hecKgYXPCoHdlbGzCoHRlbGzC
oG1lwqBhwqBsaXR0bGXCoG1vcmXCoGFib3V0wqB5b3Vyc2VsZi4NCkNvbnRhY3TCoG1lwqB1cmdl
bnRsecKgdG/CoGVuYWJsZcKgdXPCoHRvwqBwcm9jZWVkwqB3aXRowqB0aGXCoGJ1c2luZXNzLsKg
ScKgd2lsbA0KYmXCoHdhaXRpbmfCoGZvcsKgeW91csKgcmVzcG9uc2UuwqBNecKgc2luY2VyZcKg
YXBvbG9naWVzwqBmb3LCoHRoZQ0KaW5jb252ZW5pZW5jZS4NCg0KDQpUaGFua8KgeW91IQ0KDQpN
ci4gUmF6dW1rb3bCoE15a2hhaWxvLg0K
