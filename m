Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EEDE9594D9E
	for <lists+ceph-devel@lfdr.de>; Tue, 16 Aug 2022 03:34:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344251AbiHPBHU (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 15 Aug 2022 21:07:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349525AbiHPBGW (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 15 Aug 2022 21:06:22 -0400
Received: from mail-qv1-xf32.google.com (mail-qv1-xf32.google.com [IPv6:2607:f8b0:4864:20::f32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BD1C1A7C19
        for <ceph-devel@vger.kernel.org>; Mon, 15 Aug 2022 13:53:36 -0700 (PDT)
Received: by mail-qv1-xf32.google.com with SMTP id mz1so1353241qvb.4
        for <ceph-devel@vger.kernel.org>; Mon, 15 Aug 2022 13:53:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version:from:to:cc;
        bh=ej3T27wdcOl5hgxFKEEvscpLUDARFbq7IX1O4+1Fbq8=;
        b=iM1CZ9NHGDptAQfIk0N87uAi9HgPbAfhel+XA2HYxv7zSh4SCFZLHGTnkUurRVPVhp
         x2O8T5WJ4AKLKQ5kMnz29qG92iGoREqa1Bs7pZfsyRm8Avw96pN/DYj9Oq6A8k7Cpo1Y
         58wrSJjGvn5WJZlHsUvMVHavGwd+MJcTis9Axuh+ls/EV7AtTm9GFnzgpZxkxxXV1jFP
         1wElIqKTbY3BCnMXfBDtV02HBQR80ITYSnGaboAkAO/jO2rfQgUe6j5CULs/R48aJM/0
         KKr3ezsg4z0RlIUii4dV1nsvLvQ9pO7IW/n5LsEsR8IRVODqSOTUYDCkTNRV4NDR9bT2
         BMOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version
         :x-gm-message-state:from:to:cc;
        bh=ej3T27wdcOl5hgxFKEEvscpLUDARFbq7IX1O4+1Fbq8=;
        b=E7vfItIcro16B7dGYjv4JckAtxIjL7uCsdGGnbBcpUO8BeEGuQk9O4sbQQ+mymHfFi
         64da4SnsdHeSB+DbH+SAzlZo8BLA6raWH2hxaZdrnU9IJTOG9Jik55c8IiFWEOS2IDJ7
         cqbzMGq5IvF7c2ulItkzZkRTNsvVPKIOB95dnB8p1cHAN1d+Ktt2ZRyHUyv09vNRsm7R
         yEbi1XUL/fE6bxwA53BCdKDt3Mv1GQo+CBLXoPwYe8dJPF2UdRhGMyHP5nMCJhF5X5lX
         O+VNwelLO72NH/PwkzRhYN/s34SijtzgiZCSMXqLYfVCwJe+QFlHw2dk6wA9IDUeSbUU
         1A1g==
X-Gm-Message-State: ACgBeo2+4ZbxAchIDaVjMnkbJ1PkwIufjnR6u/M1lIeyDn7cjHvIwsWq
        jZCJLec3IqhLg6c32IFCLP/VUJfmknyym19Yerg=
X-Google-Smtp-Source: AA6agR5clnRuIcwVJfcCBLkvjTGszFe7W9Qe7XWa2nAdby17ayDP5ntF3AamsNQfs2PyY2NgLL3bE7z5TtwE83j8Oc8=
X-Received: by 2002:a05:6214:4113:b0:476:bb64:b5ea with SMTP id
 kc19-20020a056214411300b00476bb64b5eamr15581778qvb.24.1660596814547; Mon, 15
 Aug 2022 13:53:34 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:ab3:ef88:0:b0:46d:3a61:256e with HTTP; Mon, 15 Aug 2022
 13:53:33 -0700 (PDT)
Reply-To: wijh555@gmail.com
From:   "Prof. Chin Guang" <dmitrybogdanv07@gmail.com>
Date:   Mon, 15 Aug 2022 13:53:33 -0700
Message-ID: <CAPi14yLdqb_qN3a1MOt3ve-LugHfCfFBi9-4_Yrh-fRSRmgweQ@mail.gmail.com>
Subject: Greetings,
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: Yes, score=5.2 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,FREEMAIL_REPLYTO_END_DIGIT,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        UNDISC_FREEM autolearn=no autolearn_force=no version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2607:f8b0:4864:20:0:0:0:f32 listed in]
        [list.dnswl.org]
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.5000]
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        *  0.2 FREEMAIL_REPLYTO_END_DIGIT Reply-To freemail username ends in
        *      digit
        *      [wijh555[at]gmail.com]
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [dmitrybogdanv07[at]gmail.com]
        *  0.2 FREEMAIL_ENVFROM_END_DIGIT Envelope-from freemail username ends
        *       in digit
        *      [dmitrybogdanv07[at]gmail.com]
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
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

-- 
Hello,
We the Board Directors believe you are in good health, doing great and
with the hope that this mail will meet you in good condition, We are
privileged and delighted to reach you via email" And we are urgently
waiting to hear from you. and again your number is not connecting.

Sincerely,
Prof. Chin Guang
