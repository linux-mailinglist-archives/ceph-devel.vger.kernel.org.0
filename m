Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 14FE46B23A7
	for <lists+ceph-devel@lfdr.de>; Thu,  9 Mar 2023 13:07:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230006AbjCIMHm (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 9 Mar 2023 07:07:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229878AbjCIMHk (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 9 Mar 2023 07:07:40 -0500
Received: from mail-yw1-x1134.google.com (mail-yw1-x1134.google.com [IPv6:2607:f8b0:4864:20::1134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CC5FE7EF0
        for <ceph-devel@vger.kernel.org>; Thu,  9 Mar 2023 04:07:38 -0800 (PST)
Received: by mail-yw1-x1134.google.com with SMTP id 00721157ae682-53d277c1834so30604497b3.10
        for <ceph-devel@vger.kernel.org>; Thu, 09 Mar 2023 04:07:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678363658;
        h=to:subject:message-id:date:from:reply-to:mime-version:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/rL+TycpMQLfB5P4Zn9xgGfUWg8yPCNTwrE46ZNldMM=;
        b=d7nhE3NIkslXm34vnWVbf303x/Z9NUElwuWVVxQKRwAhx/cJYsuaiFACTzxj7CFiZM
         9dKLhLZF7a6jqvyc57Kk1boqmtsv137Fa+MgtjTiToxYNHqHEyg7y48vngkzkKHfdz6t
         qqFEvYzln7yQCRTeqDQEpkOyEc+J75B9UGX/kvFugseRiUWy+1BMwBAcOsISGDvtYfLi
         M5fmXLQR73egdnuqcARNpE8bpWem5r1t+GRAVemvZxE/CGFNAnPBcFMfJ/I/e01gEvWY
         +luXDZi7fOZKf3sF+0kalWwLM5oihW95HfjuqEvyykAfIZA7eRUD3XtyRNi5RuMiWf0Z
         3qZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678363658;
        h=to:subject:message-id:date:from:reply-to:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/rL+TycpMQLfB5P4Zn9xgGfUWg8yPCNTwrE46ZNldMM=;
        b=JykCLMlW32rLCrGP0VtPAiyvk5iYWWSO9SeL90GGi3lbnwc1Cu9jC2qnwy1H1a4eU0
         OCX5Q1Ts7Nn0C5regWsZz6EK7nozayFFx8akW8fTUBL5INc95jZ3L1muAtdrAqU4Vsy/
         01cBrw66EkWW0VdFtpE8++jmD/T/Bk9hhQ2KDwJskQk5u/r5qxtZlTqoqREGi4uPuJha
         dDdp3JyDwPfO/qAT00uSIj4rk8grOKIor10vQMaGJwb+w0e0KsWdvLdagPlLrc4KI0+R
         cQ/E4h/oKne3K1na5cZflOKsYhcHE7jwwqvgIeetnYMxXaf8xMVG9ekEBEFmOL7a8Gh7
         GEXQ==
X-Gm-Message-State: AO0yUKXZTikf5YQLUnpRYtSt+orLLaZLvsvtL0mzkQO6LBWVJmvp8e4k
        0hv3BXzR+irRtdpP1aEWrnsDAdObCwucLQrJPu8=
X-Google-Smtp-Source: AK7set/WrO1GByJYjA1fC9z16/rPQoAe1MvXZIER0NOyKbsh9dFt5CEH7nIIE7VNkcsE/b5kkFU1wtUmM4grIk/LBhU=
X-Received: by 2002:a81:a9c8:0:b0:533:9c5b:7278 with SMTP id
 g191-20020a81a9c8000000b005339c5b7278mr13602529ywh.0.1678363657574; Thu, 09
 Mar 2023 04:07:37 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:a05:7010:dd09:b0:321:de0b:83e4 with HTTP; Thu, 9 Mar 2023
 04:07:36 -0800 (PST)
Reply-To: dravasmith27@gmail.com
From:   Dr Ava Smith <gracebanneth@gmail.com>
Date:   Thu, 9 Mar 2023 04:07:36 -0800
Message-ID: <CABo=7A0--T-OTtJweEeHcT52Uc4M307=z52sGw8ts6Bm9hj0Vw@mail.gmail.com>
Subject: GREETINGS FROM DR AVA SMITH
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: Yes, score=5.2 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,FREEMAIL_REPLYTO,
        FREEMAIL_REPLYTO_END_DIGIT,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        SUBJ_ALL_CAPS,UNDISC_FREEM autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2607:f8b0:4864:20:0:0:0:1134 listed in]
        [list.dnswl.org]
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.5004]
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        *  0.5 SUBJ_ALL_CAPS Subject is all capitals
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [gracebanneth[at]gmail.com]
        *  0.2 FREEMAIL_REPLYTO_END_DIGIT Reply-To freemail username ends in
        *      digit
        *      [dravasmith27[at]gmail.com]
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        *  2.9 UNDISC_FREEM Undisclosed recipients + freemail reply-to
        *  1.0 FREEMAIL_REPLYTO Reply-To/From or Reply-To/body contain
        *      different freemails
X-Spam-Level: *****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

-- 
Hello Dear,
how are you today?hope you are fine
My name is Dr Ava Smith ,Am an English and French nationalities.
I will give you pictures and more details about me as soon as i hear from you
Thanks
Ava
