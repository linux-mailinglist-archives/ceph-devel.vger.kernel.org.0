Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C31156E333E
	for <lists+ceph-devel@lfdr.de>; Sat, 15 Apr 2023 21:06:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229796AbjDOTGO (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Sat, 15 Apr 2023 15:06:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229853AbjDOTGL (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Sat, 15 Apr 2023 15:06:11 -0400
Received: from mail-lj1-x242.google.com (mail-lj1-x242.google.com [IPv6:2a00:1450:4864:20::242])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5491E35AF
        for <ceph-devel@vger.kernel.org>; Sat, 15 Apr 2023 12:06:09 -0700 (PDT)
Received: by mail-lj1-x242.google.com with SMTP id k15so4416540ljq.4
        for <ceph-devel@vger.kernel.org>; Sat, 15 Apr 2023 12:06:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681585567; x=1684177567;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=aYAe4DL6BBolNtAJv/zYI4HfX4uQZVgW355DYethIwg=;
        b=ZO9jqRsz2Jf7ClhdUkxEsuDvIPdfbTLYusVFDerqZVIbdWDTrY0NPNy3q4AG2VzEWH
         gtnmOmok6gaL55Ii3jSUKoh+OrXXsv43IE5SpvGpX/Bhrn2fvOFVXTQZbTIyCbkBRB+y
         SAFDwSJGR52xvwHI75hQfkMYWyijW90jPM5f5h+1irWW/B4O5xN3Ev6p2DUS+zN4iulI
         zgNtjq7AbqjZk6XEPQY5p0pLwMdus5duWmPQ5y37I55t8Zvepuy7EtEt25XpydiziRNL
         SMvkwQo9V64Omb4aO9vINhTafqg9y1dkLp/EOpCtTBfWDUCpKzKYgQvrteWBBgfGqJ/G
         WikQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681585567; x=1684177567;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=aYAe4DL6BBolNtAJv/zYI4HfX4uQZVgW355DYethIwg=;
        b=KGuDlEZ93wy1JO1ISy+FAW9wxNlQTDR+FH2SbYbkFf/yHWyqJXTR/+Hcx+/woTxocB
         wbaLDE0kf8aMQy7VCGVqveFOGvH79W8edVzQINe0xYiOH/hAeNd8QvrAawEdCCTKJa6F
         6uzot491K2rooUfYwTbjuwW8tf+yV1tli+wlwBpxaNVNsCONJVgQfWxrDZr42ahkzrWq
         d9z5glFzXLGIKL9CVjF1lx4ZMsQck3MDRIjiIkrOclWhVR+PxuP7o8/Qq0J2/U8yrAL2
         +ESyOcG73mwsp8HoXAN1U6JDkzG79AbNgJunORSNQsd1Ki2x5vZDWfrUdD0UWmETMdpw
         t0Vg==
X-Gm-Message-State: AAQBX9fUsZNu9Qt2179vA/zuOtxgrnbh6iXMpxdqmBRDva2VGxY5iQuX
        1Q+4wSRR2pmb+P4nPuPlzffH/AVw0Cus/3pC2+Q=
X-Google-Smtp-Source: AKy350b0UvWfge+Z5NGOcoSWSNynwRqbsvgJsMMH8PpAhy/qqJcochS2s4KGwztSI9ruZqHy5f8S9CWinvEO0nZl1as=
X-Received: by 2002:a2e:9d55:0:b0:2a7:6dd3:ccdb with SMTP id
 y21-20020a2e9d55000000b002a76dd3ccdbmr3015245ljj.0.1681585567371; Sat, 15 Apr
 2023 12:06:07 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a2e:9850:0:b0:2a8:b675:9bbd with HTTP; Sat, 15 Apr 2023
 12:06:06 -0700 (PDT)
From:   "Aim Express Securities Inc." <aim.expresssecurities@gmail.com>
Date:   Sat, 15 Apr 2023 12:06:06 -0700
Message-ID: <CADw8qP097E_rOKBhELFHN9aGNrZsfB7D2iRL+gvgiut-yP6mrw@mail.gmail.com>
Subject: Good Business Proposal.
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=4.0 required=5.0 tests=ADVANCE_FEE_5_NEW_MONEY,
        BAYES_00,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        FREEMAIL_FROM,LOTS_OF_MONEY,MONEY_FRAUD_8,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_MONEY_PERCENT,UNDISC_MONEY autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Level: ****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

STRICTLY CONFIDENTIAL

TRANSFER OF US$35,500.000.00

We are making this contact with you after satisfactory information
gathered from the Nigerian Chamber of Commerce. Based on this, we are
convinced that you will provide us with a solution to effect
remittance of the sum of $35,500.000.00 resulting from over costing of
job/services done for the Nigerian National Petroleum Corporation
(NNPC), by foreign companies.

We are top officials of NNPC. We evaluate and secure approvals for
payment of contracts executed for NNPC. We have tactfully raised
values to a foreign company for onward disbursement among ourselves
the Director of Accounts/Finance and Director of Audit. This
transaction is 100% safe. We are seeking your assistance and
permission to remit this amount into your account.

We have agreed to give you 25% of the total value, while our share
will be70%. The remaining 5% will be used as refund by both sides to
off set the cost that must be incurred in the areas of public
relations, engaging of legal practitioner as attorney, taxation and
other incidentals in the course of securing the legitimate release of
the fund into your account.

Please indicate your acceptance to carry out this transaction urgently
on receipt of this letter. I shall in turn inform you of the
modalities for a formal application to secure the necessary approvals
for the immediate legitimate release of this fund into your account.

Please understand that this transaction must be held in absolute
privacy and confidentiality.Please respond if you are

interested through my alternative address:


Thanks for your co-operations.


Yours faithfully,
Mr.Lambert Gwazo
