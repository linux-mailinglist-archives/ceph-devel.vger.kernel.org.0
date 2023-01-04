Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D24B965CE04
	for <lists+ceph-devel@lfdr.de>; Wed,  4 Jan 2023 09:06:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233785AbjADIGH (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 4 Jan 2023 03:06:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233067AbjADIGG (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 4 Jan 2023 03:06:06 -0500
Received: from mail-ed1-x542.google.com (mail-ed1-x542.google.com [IPv6:2a00:1450:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06FF4B7C8
        for <ceph-devel@vger.kernel.org>; Wed,  4 Jan 2023 00:06:05 -0800 (PST)
Received: by mail-ed1-x542.google.com with SMTP id i15so47582875edf.2
        for <ceph-devel@vger.kernel.org>; Wed, 04 Jan 2023 00:06:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version:from:to:cc
         :subject:date:message-id:reply-to;
        bh=AgsU3TKYj1ea+xyRd1YeQ6QbaDveXYDp3sPPYkvfdzA=;
        b=PGGZz/errlCrdY54pcd746i5wphxwqlHHQZTpmvHbkziVFDwBH3p1fjq1HPo7m6oGa
         Ip77e2Xqiv0Ce3/H6xiz1BRH15s82Ta6jriYBpIePjN+ACyPoIBeOI5bBI+LWCw7zS6L
         UvzPzZiR1hx0g09BqfZloDE657RqDb7VduajESitX5XabBC+DMc7NlSXKF5OLz7CvvIU
         HG+L3FK/vmxxqVqXry9oWiivZtvtvE5Dy8nbJtpCVMrCE4Gwbj82M67ueOIa29fnqn+9
         cbZhj8AaPfgB9GMg8it6S2l+OJqDdtPATjmWe9ZNdx9hw7lpVziuzEcorJiSIrfskwsL
         7omQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=AgsU3TKYj1ea+xyRd1YeQ6QbaDveXYDp3sPPYkvfdzA=;
        b=Ry664kVnvDMCDS0vEigq5hLLpzP1kLayVrPv1IPI7RH3P90JNSw12F7VqwqLo1UX1K
         jtLYzJ0m6aCHkpeyG2rcGPCyF5MnyUHtmwSfx9DuqdyN3SE6f9MIvg3PElMPh6ACOvf0
         jk9NX5NSckpgZhX7r+F82wSVY6wJnbMfJwUxjYAmWxLfE2dVL0kQDXq/l+Kzwm6EagQ6
         0C5B4mLQrduzZdr5N6BmrhSGAGplbbxmHcBLe1AR9aFi4ucx6I1yMoWWXxMhJ1DLnql7
         PuZC6xaJxygRxrlXIBTOsH86joJZl+Pcg4FuyTjJ89uCBmotGSExlt92i9YC/ulrJNL/
         lSjg==
X-Gm-Message-State: AFqh2kqe6gyCgWPN6tSbvE96qfOzqbsK7z1iZ9W1e3TCBJqUqzmL+ljq
        GPIwbM9ljphp7if43FnnmDNeFb0L/FXVf1Dkbw==
X-Google-Smtp-Source: AMrXdXtr5L5Dcm7ltz+fyueRNf/R3RAJ6jzLPh33R/YUjK8u9bl6NwAMAhyD4rdn+79XOoBfOV94dutFme8n3Zc0o2g=
X-Received: by 2002:a05:6402:1394:b0:48a:eac7:2b9f with SMTP id
 b20-20020a056402139400b0048aeac72b9fmr1553016edv.91.1672819563408; Wed, 04
 Jan 2023 00:06:03 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:a05:7208:8297:b0:5e:de3b:d9a6 with HTTP; Wed, 4 Jan 2023
 00:06:02 -0800 (PST)
Reply-To: Gregdenzell9@gmail.com
From:   Greg Denzell <denzellgreg392@gmail.com>
Date:   Wed, 4 Jan 2023 08:06:02 +0000
Message-ID: <CALb=U3mbQW1W02JBjSMyzhOGtQ6dzWrdSpLaxzrDem0=9b3KNg@mail.gmail.com>
Subject: Happy new year,
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=4.8 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,FREEMAIL_REPLYTO_END_DIGIT,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,UNDISC_FREEM autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Level: ****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Happy new year,


This will remind you again that I have not yet received your reply to
my last message to you.
