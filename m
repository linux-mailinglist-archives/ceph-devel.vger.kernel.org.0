Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A036A6F2893
	for <lists+ceph-devel@lfdr.de>; Sun, 30 Apr 2023 13:27:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229570AbjD3L1t (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Sun, 30 Apr 2023 07:27:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229461AbjD3L1s (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Sun, 30 Apr 2023 07:27:48 -0400
Received: from mail-il1-x130.google.com (mail-il1-x130.google.com [IPv6:2607:f8b0:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED601199B
        for <ceph-devel@vger.kernel.org>; Sun, 30 Apr 2023 04:27:47 -0700 (PDT)
Received: by mail-il1-x130.google.com with SMTP id e9e14a558f8ab-3294fd17f1cso3704875ab.1
        for <ceph-devel@vger.kernel.org>; Sun, 30 Apr 2023 04:27:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682854067; x=1685446067;
        h=content-transfer-encoding:to:subject:message-id:date:from:sender
         :reply-to:mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=Qs6YQuKaR+Jj8cYfLUlwzIsnjJiio9siuMvBa7Y9KQA=;
        b=rd/WEgfvUPlCKTiRdsjhB2KEkP0DMe+LuWS0oHHO24QFeYBhIsbBcEcYnkSToND1bW
         99fsUm+ofoiCKfvxn8flhZ2yQj9fYFQZecG6K/cqMuBIAnHmWFvvgq0HEgW+2pHE0/dY
         433je5ERY1XYqC5UJbFtjhHTH+HLTzheGnVVYgVoDQS2i/sYsaG+drxhnhyYuPMwBQ/s
         R0OJL1SM2oZtRAa2tsF6VNIIw6Go2F8f9j8Ib/T/O1UTcT73YBqehsdA1AvwKI1YLBop
         JyyVVlpTeQhlmvKgx25xWD2iROB7qQVCgkO8m7jehai8Ka4w77LRAAKo7K9n0SJ1+Nrh
         UrFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682854067; x=1685446067;
        h=content-transfer-encoding:to:subject:message-id:date:from:sender
         :reply-to:mime-version:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Qs6YQuKaR+Jj8cYfLUlwzIsnjJiio9siuMvBa7Y9KQA=;
        b=TRhk0CxMn9AUKaR/mkUaEn3ZpNgHcL063cnqFDPIuS66KCfD1d5ChnCeNUQyCg60FG
         vSYXnED1dsF/ZOR96p3YxK4V+hGD316h+h5mxaI8il5s1jJ/NgD+rxqMTlqPZSmlkcyU
         GUqmRd/5KJ8YmGXjD8+LIIsVNRg5CPd5nrwLV7OFVQYa8DUT+U2uwcIYlhN7z3AQ2d3M
         jjNYc/p+ec1BeRGyWXPPVvOthOKNNKDy54Zj7Mrf+1x76kK4LbCNkrKrWdQ6cnPRgzak
         juKgVAB+DeLGBNdZ7cEk3rDDyWKDhn3uAs0y8mK3Ee6QSIRxLfkbLFj3IZ/64I3r7ioc
         xliw==
X-Gm-Message-State: AC+VfDy2gHnWk3Oy5xTA5NtdJmmoGesYfpYbDFoPdyb407AiWOouummW
        tyvnRgwI0QJALNScKt+XdiOP35SejEVqFiadkcs=
X-Google-Smtp-Source: ACHHUZ6692/KnjHcPXrybopLvVKBRftRNMS2Oq/YCv++jUjcQxP8/3PJJLCUddwaH+K4ofiqAI8e2oc+8CdJZHPqKZA=
X-Received: by 2002:a5d:97d1:0:b0:760:6412:f5c2 with SMTP id
 k17-20020a5d97d1000000b007606412f5c2mr6342003ios.3.1682854067164; Sun, 30 Apr
 2023 04:27:47 -0700 (PDT)
MIME-Version: 1.0
Reply-To: salkavar2@gmail.com
Sender: adilegrah59@gmail.com
Received: by 2002:ac0:dd8d:0:b0:2b4:99e4:6f8f with HTTP; Sun, 30 Apr 2023
 04:27:46 -0700 (PDT)
From:   "Mr.Sal kavar" <salkavar2@gmail.com>
Date:   Sun, 30 Apr 2023 04:27:46 -0700
X-Google-Sender-Auth: DWWXmwEAE2aVtZ1o61hrUcaDc8w
Message-ID: <CAEP0BsXukzTRGpUYBwaQi8TFRgtykF8to151xcpvT9XhaEp+dA@mail.gmail.com>
Subject: Yours Faithful,
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: base64
X-Spam-Status: Yes, score=6.5 required=5.0 tests=BAYES_05,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO_END_DIGIT,HK_NAME_FM_MR_MRS,
        LOTS_OF_MONEY,MONEY_FREEMAIL_REPTO,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,UNDISC_MONEY autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2607:f8b0:4864:20:0:0:0:130 listed in]
        [list.dnswl.org]
        * -0.5 BAYES_05 BODY: Bayes spam probability is 1 to 5%
        *      [score: 0.0160]
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [adilegrah59[at]gmail.com]
        *  0.2 FREEMAIL_REPLYTO_END_DIGIT Reply-To freemail username ends in
        *      digit
        *      [salkavar2[at]gmail.com]
        *  0.2 FREEMAIL_ENVFROM_END_DIGIT Envelope-from freemail username ends
        *       in digit
        *      [adilegrah59[at]gmail.com]
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        *  1.5 HK_NAME_FM_MR_MRS No description available.
        * -0.0 T_SCC_BODY_TEXT_LINE No description available.
        *  0.0 LOTS_OF_MONEY Huge... sums of money
        *  2.1 MONEY_FREEMAIL_REPTO Lots of money from someone using free
        *      email?
        *  3.1 UNDISC_MONEY Undisclosed recipients + money/fraud signs
X-Spam-Level: ******
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

ScKgYXNzdW1lwqB5b3XCoGFuZMKgeW91csKgZmFtaWx5wqBhcmXCoGluwqBnb29kwqBoZWFsdGgu
DQoNClN1bcKgb2bCoChGaWZ0ZWVuwqBNaWxsaW9uwqBGaXZlwqBIdW5kcmVkwqBUaG91c2FuZMKg
RG9sbGFycynCoHdoZW7CoHRoZQ0KYWNjb3VudMKgaG9sZGVywqBzdWRkZW5secKgcGFzc2VkwqBv
bizCoGhlwqBsZWZ0wqBub8KgYmVuZWZpY2lhcnnCoHdob8Kgd291bGTCoGJlDQplbnRpdGxlZMKg
dG/CoHRoZcKgcmVjZWlwdMKgb2bCoHRoaXPCoGZ1bmQuwqBGb3LCoHRoaXPCoHJlYXNvbizCoEnC
oGhhdmXCoGZvdW5kwqBpdA0KZXhwZWRpZW50wqB0b8KgdHJhbnNmZXLCoHRoaXPCoGZ1bmTCoHRv
wqBhwqB0cnVzdHdvcnRoecKgaW5kaXZpZHVhbMKgd2l0aA0KY2FwYWNpdHnCoHRvwqBhY3TCoGFz
wqBmb3JlaWduwqBidXNpbmVzc8KgcGFydG5lci4NCg0KWW91wqB3aWxswqB0YWtlwqA0NSXCoDEw
JcKgd2lsbMKgYmXCoHNoYXJlZMKgdG/CoENoYXJpdHnCoGluwqBib3RowqBjb3VudHJpZXPCoGFu
ZA0KNDUlwqB3aWxswqBiZcKgZm9ywqBtZS4NCg0KDQpNci5TYWzCoEthdmFyLg0K
