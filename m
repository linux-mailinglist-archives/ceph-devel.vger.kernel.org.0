Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3ABBB50068C
	for <lists+ceph-devel@lfdr.de>; Thu, 14 Apr 2022 09:05:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240212AbiDNHIB (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 14 Apr 2022 03:08:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231582AbiDNHH7 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 14 Apr 2022 03:07:59 -0400
Received: from mail-yb1-xb44.google.com (mail-yb1-xb44.google.com [IPv6:2607:f8b0:4864:20::b44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0E2C2E9C9
        for <ceph-devel@vger.kernel.org>; Thu, 14 Apr 2022 00:05:35 -0700 (PDT)
Received: by mail-yb1-xb44.google.com with SMTP id t67so7843332ybi.2
        for <ceph-devel@vger.kernel.org>; Thu, 14 Apr 2022 00:05:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:reply-to:from:date:message-id:subject:to;
        bh=KeMi8W+p20zdR41YZoRj2EapY7imNsLYkAgQIQsIzqY=;
        b=Z9Yl4wpzyxZij8FtX+KgMD4VhLBomqXeX9UjdM+AM2oYY6TCO4eF57inIy2wPrMNcd
         /lPgKTmUzgGGaaFyJPuX893stS7X6zlMnynux9pPAw+yBEnxVC3RnUSyU0y+gsV6F26D
         4Av5EP0KvfHSUJMcPvWEHKR9HpEVZZ/tVYPypbmMaaVFaLabfe+k5PpORXjWb1ds/HoP
         0+AStcCaaVBMmB6OVR1f2y1I5xm6+w2/0NPCS7HTEQaaquK+A3Id5n5QR081itZPv5Bb
         5grqWekBzNBSkdYa/REWMSQszhYxO63sNxawULjMPJ4LUrmMAKdfSnNXG4zzBqoYctTk
         N4bg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:reply-to:from:date:message-id
         :subject:to;
        bh=KeMi8W+p20zdR41YZoRj2EapY7imNsLYkAgQIQsIzqY=;
        b=JEn4lYr1v8iPYh78h+5FJc64eeamndXUiNPXFbtNB0jt1md5J6MxI/wp8++Dh9Pcl/
         Dj2fmHFl6eihdrifiJP2D1EhXR2yaDTYIhJHoG9u2zPoJwpKybnKww6wY8W6mAI7DKNJ
         vt0bvcTeLAxi3dQHdnQ+ebJ6/91JZA0oWkwdL/+7aXLqB2y0cmy+kYENSwQn/ux3DTvJ
         ftqx6SC/CQuJWfYxbYvXCWDoXH1/xPZ1rbvD6N09me0WPmA51onxXhRiWDepJWYhTRc0
         7NxO8pwuQ65N8N32tHHpV8xXUBrkF3ct+KphdsXtQCKydJ3J4eTsJA+n8vrLsaQCtnv3
         T5lQ==
X-Gm-Message-State: AOAM530cpXO+u/GwZ4N84iBHWodXbeFPRt3BmqhCN87NsxxCU+rppWx9
        4Na+hRjA/GvzEXzM9lKnCX6hd+phujwGPDW1oT4=
X-Google-Smtp-Source: ABdhPJzoOp+w9rhSKDvvhRXYLHe83WtuHXU+h4Ry7zW0d8/ftudqaPz/iCRUfWtYAwjP446utzt66CBhmg/stDp0dx8=
X-Received: by 2002:a5b:982:0:b0:63e:7d7e:e2f2 with SMTP id
 c2-20020a5b0982000000b0063e7d7ee2f2mr696283ybq.549.1649919935027; Thu, 14 Apr
 2022 00:05:35 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a05:7010:a822:b0:247:d9b3:22bc with HTTP; Thu, 14 Apr 2022
 00:05:34 -0700 (PDT)
Reply-To: danielseyba@yahoo.com
From:   Seyba Daniel <mohaseen949433@gmail.com>
Date:   Thu, 14 Apr 2022 09:05:34 +0200
Message-ID: <CAOnm=uesEsv=vP67dKQZhHw=N4LD6NpQ_u3sWJ+zEC6JZ+N3Qg@mail.gmail.com>
Subject: Hello,
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: Yes, score=5.5 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,UNDISC_FREEM autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2607:f8b0:4864:20:0:0:0:b44 listed in]
        [list.dnswl.org]
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.5000]
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [mohaseen949433[at]gmail.com]
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.2 FREEMAIL_ENVFROM_END_DIGIT Envelope-from freemail username ends
        *       in digit
        *      [mohaseen949433[at]gmail.com]
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        * -0.0 T_SCC_BODY_TEXT_LINE No description available.
        *  3.7 UNDISC_FREEM Undisclosed recipients + freemail reply-to
        *  1.0 FREEMAIL_REPLYTO Reply-To/From or Reply-To/body contain
        *      different freemails
X-Spam-Level: *****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Hello,

I am so sorry contacting you in this means especially when we have never
met before. I urgently seek your service to represent me in investing in
your region / country and you will be rewarded for your service without
affecting your present job with very little time invested in it.

My interest is in buying real estate, private schools or companies with
potentials for rapid growth in long terms.

So please confirm interest by responding back.

My dearest regards

Seyba Daniel
