Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 490384C40EC
	for <lists+ceph-devel@lfdr.de>; Fri, 25 Feb 2022 10:06:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236785AbiBYJHN (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 25 Feb 2022 04:07:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231588AbiBYJHM (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Fri, 25 Feb 2022 04:07:12 -0500
Received: from mail-il1-x12a.google.com (mail-il1-x12a.google.com [IPv6:2607:f8b0:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67A2729C99
        for <ceph-devel@vger.kernel.org>; Fri, 25 Feb 2022 01:06:41 -0800 (PST)
Received: by mail-il1-x12a.google.com with SMTP id w4so3797119ilj.5
        for <ceph-devel@vger.kernel.org>; Fri, 25 Feb 2022 01:06:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:reply-to:in-reply-to:references:from:date:message-id
         :subject:to:content-transfer-encoding;
        bh=+es4NtbGTalT5oP3GV+xtuy893MsQfDwsU74MLZoOUI=;
        b=busUWXoL29xjS4Oroh4MNq/VuTlpIUyrZU0384tALdS/bsXhjunfXWcNWa2UtO6Tuo
         BYuwIen0cEJQB3d928soubYfZ/Sb//mBfFhjP4XAl1x2AEU6qlSypVo2ddYSKVzwn+gh
         sMbSkNS7JcHPDjSTMturK3o3/fk8Bb74+Jf2soL6UYE4sMu5/DKYOtyV4ayNS40RzFn+
         H5qWe8VONn8rMMDwMqpZ2YhkwlyRhLPkC1aIYfoeWcu+JqwRBSkNPNgwIwES6ecba4m4
         sb1wTQDgzw9dZf7gk4DbIckHADmsHd4mjMMnBpHy9FhZ4PeMs/JtOk0Q5eETvI237NNB
         uoQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:reply-to:in-reply-to:references
         :from:date:message-id:subject:to:content-transfer-encoding;
        bh=+es4NtbGTalT5oP3GV+xtuy893MsQfDwsU74MLZoOUI=;
        b=1aW7kTsubsaB2baurQR/eOLVI9k4iyfHm/Ch3QKjcoKTaLGBOVlaKxapVIHdFkB29I
         UfUkt6ZsIVWTYI6mno7MxDxf7tO3J9V2/HhJUnL7TTBtLZVjw/S1Kgo7H18tEM+7+0jy
         vyutOss8fncwHw+aa0JlxtSi7WujeuKYpUeoQfHEhFWsSfKXm4to2BtOc2Cgp4dTDv+K
         tYB6K5LkRVMOUzBMmFXH7LyvHHNi2quZ2uE++4cvf1sVNK3w3HNRinKJFh/nnLEh3KyX
         SED8OpfE/qdjqOACyqv7hR11jm9yrv/n+714bTreWUmPPsrI7TuHwfYjI8XtH+9vPp+B
         EdwA==
X-Gm-Message-State: AOAM532gGeJpuMVhhEH3SwOdW/qhqilPpjQCA1Dqg7qHVu9td/Pu/W1Q
        ZpCFduquFl0Xsp5lLFgAYxb1FH6KhhwXGSQApVA=
X-Google-Smtp-Source: ABdhPJyjORSSjLqWX6YpwnxsnkKgdnVvqKB6irMTGzYgptcjB+X/7HMKTqjOk+/wtXim9OWFQzfhHiXG2KpXVM+rc/c=
X-Received: by 2002:a05:6e02:1aa1:b0:2be:6c4b:69e2 with SMTP id
 l1-20020a056e021aa100b002be6c4b69e2mr5423798ilv.32.1645780000446; Fri, 25 Feb
 2022 01:06:40 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:a05:6e04:2008:0:0:0:0 with HTTP; Fri, 25 Feb 2022 01:06:39
 -0800 (PST)
Reply-To: redcrosssociety@hellokitty.com
In-Reply-To: <CAFRqpdmB-4TRObd1OVGhryzvBBekC9dLedhT6__UuWO9JXS_Eg@mail.gmail.com>
References: <CAFRqpdktsjaexqmAmxv8+0e_=nUkforqH-n-uh0odnqj7_MDOA@mail.gmail.com>
 <CAFRqpdkebmFvqr-86-BhBt52zp0YgpMBfBYx1ppS7+qmT80f-w@mail.gmail.com>
 <CAFRqpd=xpVka=B+Yct9Xi=3KrKZT-gJQgpqQ3QUNEY1_aMP4KQ@mail.gmail.com>
 <CAFRqpdmw+Wc575+O-9hdgm9L_vMN4JC-xHp8tf5n33UxE9Nfjw@mail.gmail.com>
 <CAFRqpd=w_DQ+JwPFBwG_ZhuXhct31o0FJ=-kjkaqY_KwdZPMsw@mail.gmail.com>
 <CAFRqpd=C_eYSL0wxBzSzuw3Uri=xYtBoH_OPE2GxejgaSL63nw@mail.gmail.com>
 <CAFRqpdnLxHUMvMzP1SwY3cubLb23isGHx+xYRGLLP8OBi7aXwg@mail.gmail.com>
 <CAFRqpdmA30HXvTkScWXMNcpRKmDhf4pTZQinBYgJxhdiz0NZ7g@mail.gmail.com>
 <CAFRqpdnhUoVivpEU=ELFKrrua+bsiGOatMBOMT8=GODFN9r9bg@mail.gmail.com>
 <CAFRqpdmDDQmzf61Og8gyd=_PJ5wecPX0F9Mw70dmCxCGqY6HnQ@mail.gmail.com>
 <CAFRqpdnQHK72UUQyZxG3f4dofj=z46hooxkq-TM7AxNb-5hiog@mail.gmail.com>
 <CAFRqpdkuMuKcL5vuX5R2sjb40zs3rezqa7khW+rBTmyAUWXWPw@mail.gmail.com>
 <CAFRqpdmaDdMaOTtxM2xR_HLkWsDfNpkaA9tfq7yQb0XPrOG=1g@mail.gmail.com>
 <CAFRqpdm-PdtuRuGn69V+ofqqr=RB_MOxMuArbgLZRC7P-0PL7Q@mail.gmail.com>
 <CAFRqpdn5G-3kZ3Rm2SxTaJUUbkJ8xzUc-PnxjKy+s0Aqq5yjCA@mail.gmail.com>
 <CAFRqpdmkA3jFerOtV-U2j=33GEd0CVX5yBeeh378eOLi=f6i8Q@mail.gmail.com>
 <CAFRqpdmVYNe8dMx-U6DL2jhMp8iT6FJuZe_-qWMduOY6kVbjmg@mail.gmail.com>
 <CAFRqpdkcxzOeuLYXLV_wq88iXn1eG3RZDQDebNMJwnprNx1_5A@mail.gmail.com>
 <CAFRqpd=9YTD60q__YX3P+EPrshR5eQFHpe=gRJFDj7F7fiNTsw@mail.gmail.com> <CAFRqpdmB-4TRObd1OVGhryzvBBekC9dLedhT6__UuWO9JXS_Eg@mail.gmail.com>
From:   "Mr. Stevenson" <mathews2019riaan@gmail.com>
Date:   Fri, 25 Feb 2022 11:06:39 +0200
Message-ID: <CAFRqpd=bidX8mH6+1WLUyCfywpds+ybUfTsDmbLWt4nnPMQ7YQ@mail.gmail.com>
Subject: Compensation Relief Fund.
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: Yes, score=5.3 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,HK_SCAM,
        LOTS_OF_MONEY,MILLION_HUNDRED,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,T_HK_NAME_FM_MR_MRS,T_SCC_BODY_TEXT_LINE,UNDISC_MONEY,
        XFER_LOTSA_MONEY autolearn=no autolearn_force=no version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2607:f8b0:4864:20:0:0:0:12a listed in]
        [list.dnswl.org]
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.5000]
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [mathews2019riaan[at]gmail.com]
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.2 MILLION_HUNDRED BODY: Million "One to Nine" Hundred
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        *  0.0 LOTS_OF_MONEY Huge... sums of money
        *  0.0 T_HK_NAME_FM_MR_MRS No description available.
        * -0.0 T_SCC_BODY_TEXT_LINE No description available.
        *  0.0 HK_SCAM No description available.
        *  1.0 XFER_LOTSA_MONEY Transfer a lot of money
        *  3.5 UNDISC_MONEY Undisclosed recipients + money/fraud signs
X-Spam-Level: *****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

/\/\/ Contact Me Please..

My name is Mr. Ewen Stevenson, Group Chief Financial Officer from HSBC
Bank of United Kingdom in Manchester. I was directed by HSBC Bank of
United Kingdom to pay the sum of =C2=A31,500,000.00 (One Million Five
Hundred Thousand Pounds) to you as your Compensation Fund due to
Covid-19 pandemic and other transaction you were engaged in the past
and spent your hard earn money, efforts and finally did not receive
the fund.

Kindly respond to this message in order to direct you on how you will
receive the fund by Bank Wire Transfer to any of your nominated bank
account within 5 working days without any further delay.

I look forward to receive your reply thanks.

Email: redcrosssociety@hellokitty.com
Tel: +44-745-127-4775(WhatsApp me)
Regards
Mr. Ewen Stevenson
(Group Chief Financial Officer)
England United Kingdom
