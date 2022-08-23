Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C4F2F59CD3C
	for <lists+ceph-devel@lfdr.de>; Tue, 23 Aug 2022 02:35:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238188AbiHWAfM (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 22 Aug 2022 20:35:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232069AbiHWAfL (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 22 Aug 2022 20:35:11 -0400
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A09E4B4AE
        for <ceph-devel@vger.kernel.org>; Mon, 22 Aug 2022 17:35:10 -0700 (PDT)
Received: by mail-pl1-x629.google.com with SMTP id y4so11416610plb.2
        for <ceph-devel@vger.kernel.org>; Mon, 22 Aug 2022 17:35:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version:from:to:cc;
        bh=EqaxGUkFM8fioC3ASGh089vGBWnyekQ5Kheib+LNTiY=;
        b=S3njSFZ1i4qs/e+lh1NTiMxQ/uqgxYX5Xsss5TDwijY7m20S55U/UUVoU1mcMP9qbC
         0YgdCag+ptqsku8tASAYmOZ1BdpL43BXHvbEg3IBf2DOHeJcrfrODHLUlxHJUca4ILQl
         qwvgpzlVgqExBYFduUWmM6rvsr0qX5mY+Pb+SXDnGGwnSt32Jh9ZPya5bEHMC9FHuWuJ
         FkLWcs/osRGi/mVCOLnFBIt7ewCmpSTWsOqzy84+YRxADRB3uuYgLl2+RBwH+EElNirH
         KklXaPISAxRjcVQ12nBsUsi748DMGKngGMZMCggs4VZre/Wq0gU/ESTgiYGkpoIL3jka
         ZMwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version
         :x-gm-message-state:from:to:cc;
        bh=EqaxGUkFM8fioC3ASGh089vGBWnyekQ5Kheib+LNTiY=;
        b=NQClEIC/wPYXUO1Qr5BHAzwHP1haTpp/WcObsz66SuSJFz/YNW3Gp1L6DXiVH1M4NM
         13QcgtGtr+oBWVrt1x8QD0ZcFp2hCoXpVCVRiBaXCJIPPX+z/tu1t2M2w96fxuGpva2U
         MidiC0OTL28NrLT/q69hrV7JUKhVeIREOHlwvkayyh+cAs9vCUqpE7Il14M7ip5cxTFb
         l+jLE+yBYHwoeaJANlUJaWgkORl1bqIqU8oGp0DNb2/3tyaJ9PS+mgeAwtBd2MbmvqsZ
         56EQVNHA3em8wMx8F2fbjms0Cr849L1CdfQbpCECWUkVWoHLz/0Ueb1sMwmP7FAXoFxn
         86Eg==
X-Gm-Message-State: ACgBeo2fAK7ZWIkiHvoiTuavZd4HiKt0uHRa9IzekeXZXhLkr70+N+PM
        QWg0Puv0MdVBNq9i/EsKrnnOs9kUDq0Htt8rKZk=
X-Google-Smtp-Source: AA6agR6ZIQ7TTs3Z25AkrN67J/A4KUwSOALGrX2ibw0R+ODP2Nayss5XKNXaAI7Rbr4+yXiAgSOVGMcljnvVSJwp68c=
X-Received: by 2002:a17:90a:f48d:b0:1f7:2e00:f7f8 with SMTP id
 bx13-20020a17090af48d00b001f72e00f7f8mr840107pjb.94.1661214909390; Mon, 22
 Aug 2022 17:35:09 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a05:6a06:1883:b0:567:66b0:675f with HTTP; Mon, 22 Aug 2022
 17:35:08 -0700 (PDT)
Reply-To: richard.lr1911@gmail.com
From:   Richard <bluke7396@gmail.com>
Date:   Tue, 23 Aug 2022 01:35:08 +0100
Message-ID: <CAMgxhgyq__=LsB9UODbQ1OKZk1vqd+ORF1LexqiiEMZ1+G+Peg@mail.gmail.com>
Subject: Letter of intent! and Please Read!
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: Yes, score=5.9 required=5.0 tests=BAYES_60,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,FREEMAIL_REPLYTO_END_DIGIT,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        UNDISC_FREEM autolearn=no autolearn_force=no version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2607:f8b0:4864:20:0:0:0:629 listed in]
        [list.dnswl.org]
        *  1.5 BAYES_60 BODY: Bayes spam probability is 60 to 80%
        *      [score: 0.6192]
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [bluke7396[at]gmail.com]
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.2 FREEMAIL_REPLYTO_END_DIGIT Reply-To freemail username ends in
        *      digit
        *      [richard.lr1911[at]gmail.com]
        *  0.2 FREEMAIL_ENVFROM_END_DIGIT Envelope-from freemail username ends
        *       in digit
        *      [bluke7396[at]gmail.com]
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        * -0.0 T_SCC_BODY_TEXT_LINE No description available.
        *  3.1 UNDISC_FREEM Undisclosed recipients + freemail reply-to
        *  1.0 FREEMAIL_REPLYTO Reply-To/From or Reply-To/body contain
        *      different freemails
X-Spam-Level: *****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Attn!

Are you in need of a business or personal loan? Or is your business
struggling due to covid 19 pandemic, we are offering easy loans to
meet your needs, our funding and loans have repayment plans of 10 to
25 years' time for new and existing businesses, housing projects, and
individual financing.

We are willing to finance your request no matter where you are
stationed or located, our financing is global once you're willing to
meet the process and conditions. Your request will be processed and
sent to your account within 24 hours after the process is completed.

Kindly contact us in order for us to direct you to our procurement
officer, If you are interested.

Thank you in advance as we hope to meet your demand irrespective of
the volume in need.


Thanks & Regards
Mr. Richard.
