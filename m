Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE5CA53866E
	for <lists+ceph-devel@lfdr.de>; Mon, 30 May 2022 18:55:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242043AbiE3Qzg (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 30 May 2022 12:55:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236669AbiE3Qzf (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 30 May 2022 12:55:35 -0400
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF2ADA777C
        for <ceph-devel@vger.kernel.org>; Mon, 30 May 2022 09:55:34 -0700 (PDT)
Received: by mail-wr1-x431.google.com with SMTP id e25so4826874wra.11
        for <ceph-devel@vger.kernel.org>; Mon, 30 May 2022 09:55:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:from:mime-version:content-transfer-encoding
         :content-description:subject:to:date:reply-to;
        bh=LJc4Xo1mZHX9XpL7507hcjIerDMQEHJ6CgyIqDOn3T8=;
        b=ikZGTAm8ur/qKKNTrWeN2Z5xvX7ZJtaO7AjM6hrVyGBpiTdKuhH4ohSseQ31JU4zbX
         7NhGQx1OFSgBoATlTUjA+YrsjzSQ7JHO/TSfIK4G6HN6jWz9tpYDy9KbHzkRH1VwLibY
         Qbh0fl+WHTfG1+JnoGydjF0Ov0WeGTPQNZfpJymKtaloZCHpNknEA7BYPg4RCGv0INzN
         JChO9DTiNcC3jLRJdvai1zX4gbTvqGZMTTwqTXNbOddQ1aqENLU2yPgzEmKu3/bs4L6/
         8dg2pEeruVxahVRp1G32hUbKX8t5BDLTZGLaXQn6E7h2EdSUSLvMzRqzpWSyKH2kk9gg
         uWzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:from:mime-version
         :content-transfer-encoding:content-description:subject:to:date
         :reply-to;
        bh=LJc4Xo1mZHX9XpL7507hcjIerDMQEHJ6CgyIqDOn3T8=;
        b=4zjDijrJA4zDxcuX0gKhkAObEQW5N1tu0AyLZrmm3PQ8p8bvLSz/IEWQjCtskwTfmS
         yBpaKoeYC9cbKfsEayiCToc0wbdaWf113B/7Gk9eh5kbA73vKD39JJWiBSCZxMmpEyah
         1MzxFvbqqwF/V7pdnJ5/b6UcckwO0g+YhQBdvGC0g+oefu/+d2mC8iRl9tV9iRfly1MI
         V4G9vjU7064Hvxc3mPGoVJPbFpJT9rGld9Nuyu8nueA4mEESImohq55IdZU6TdJ2qkXe
         6QigYB/MCb268Bsblqx5vvYERh5zbBuquc3scqBVviTFTWWwQ1fTSCO+vU5Yf1pYHr/E
         ruxA==
X-Gm-Message-State: AOAM5317Kab39LMma5S2EX++b8vpkO5qRUdNmuI5dC/uOBAQfGFQEkAT
        MuvDJ0D1HNaqzUJv2+ZgZck=
X-Google-Smtp-Source: ABdhPJw54sBO8ykcJ8k4ssXxt6yC6FjeO8QEXTtWYXdTzOCPEcMxLS0n5oIUyrMSP6BdW2Jz9V9cpg==
X-Received: by 2002:a5d:59af:0:b0:20f:d3fc:c5ba with SMTP id p15-20020a5d59af000000b0020fd3fcc5bamr34177542wrr.436.1653929733339;
        Mon, 30 May 2022 09:55:33 -0700 (PDT)
Received: from [10.10.10.61] ([156.38.95.223])
        by smtp.gmail.com with ESMTPSA id w15-20020a5d680f000000b0021033ba8b15sm3404479wru.44.2022.05.30.09.55.28
        (version=TLS1 cipher=AES128-SHA bits=128/128);
        Mon, 30 May 2022 09:55:32 -0700 (PDT)
Message-ID: <6294f704.1c69fb81.1822c.ee8a@mx.google.com>
From:   David Cliff <etseagbodjalou@gmail.com>
X-Google-Original-From: David Cliff
Content-Type: text/plain; charset="iso-8859-1"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Description: Mail message body
Subject: Hello
To:     Recipients <David@vger.kernel.org>
Date:   Mon, 30 May 2022 16:55:22 +0000
Reply-To: davidcliff396@gmail.com
X-Spam-Status: No, score=1.9 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,FREEMAIL_REPLYTO,
        FREEMAIL_REPLYTO_END_DIGIT,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        TO_MALFORMED,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Hello dear. I have viewed your profile and I wish to say you are very beaut=
iful and charming, nice and gentle. I like you to know that this beauty I s=
ee in you is the heart of every man, I would like to know you better as I a=
m searching for a long lasting relationship. I will tell you more about mys=
elf when I get your reply, send me your email address, here is my email: da=
vidcliff396@gmail.com,
I will wait for your reply. Thanks
David
