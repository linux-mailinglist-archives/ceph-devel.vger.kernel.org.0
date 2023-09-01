Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4CB417900E8
	for <lists+ceph-devel@lfdr.de>; Fri,  1 Sep 2023 18:47:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348345AbjIAQrE (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 1 Sep 2023 12:47:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348351AbjIAQrE (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Fri, 1 Sep 2023 12:47:04 -0400
Received: from mail-yw1-x112f.google.com (mail-yw1-x112f.google.com [IPv6:2607:f8b0:4864:20::112f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2B2D1703
        for <ceph-devel@vger.kernel.org>; Fri,  1 Sep 2023 09:46:55 -0700 (PDT)
Received: by mail-yw1-x112f.google.com with SMTP id 00721157ae682-58df8cab1f2so23492177b3.3
        for <ceph-devel@vger.kernel.org>; Fri, 01 Sep 2023 09:46:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1693586815; x=1694191615; darn=vger.kernel.org;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=KIsbmJDg7dS9cQVKyOcizau0xf1gcPa7JhOt3x+PsGU=;
        b=fiKS7lirAu2YahVHP3sohC/UnKSsHVF+hzzw6PawDkbQwp2zkDggnuTNUFrDQCtU0I
         tmMKXh1P8MAjWXzxUZ5/98X5JAVXXzFxI8zNtz0d5RNDdXiTx9EIXxvGIzLCO99TsycW
         RXbi+md1ca+7CVapJkI/8YjSORgdfvDsnZ4e+dQ1+paF6z0k96dOkiJ7zbr+dvh1uDEB
         FL5Yaz7e+L64iJC5UlmcS0yb+Qqlo/ObAhSkS3d0NIU/iSoL+evZkJWb3juhMQHk6cxQ
         3ZAU0pG32/B1P7bYhKolGopwf0rL80g9yeTHrB9p9MlwJMOaLUPvAkZ/stmnutjUHJhU
         kBbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693586815; x=1694191615;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=KIsbmJDg7dS9cQVKyOcizau0xf1gcPa7JhOt3x+PsGU=;
        b=RpGehA6TXXsKMe9hqiJr5G9J+e6GAxUbBZ7p5q5TjKM6X7pp3mv9EtWKE0noIEuK7E
         39hq55N8fbkr8SF/o2pTp9GF7665f/LaSwF5bx0yA1EDjBKnleMQF5vXlsgSKY+uZlvh
         49hrNQ+ZBcss28PjN1bOgA4lLYO2pq5m2QFi6vRFch0pUuP/LNY7XHy/fN/BNtPivAPw
         2bPuebdQCPjWjjRlxk9AumIAUtlmezU6AP+dcrONPapdWYKSG5eO+xfxG8ZFY0wbP7ia
         ymEZPECK+jSMPFM/7uE87RJ9jYBY7U/kKHpW6jCVTriYwzWsbDd8KBZSDqVMzKVWqEXh
         CteQ==
X-Gm-Message-State: AOJu0YxHae6yb1jL1Wr3AAAp1x/w4WQXj3/7Q7DM50EgBpjRM1j7GsTD
        ZFC/ZIn3+DUowqw9FWkh8CZXr2R4kD9Yi2Aifn3wWTFZPL3Hyw==
X-Google-Smtp-Source: AGHT+IE/enSGYHijAeh+4VPHnLKEUickZuba/PTR/JLSEkesVG6DuMWiKgVkC+/SLQBd3TiJJdVGtLDrbAvuzqE9qX4=
X-Received: by 2002:a25:1c3:0:b0:d62:b91b:10e3 with SMTP id
 186-20020a2501c3000000b00d62b91b10e3mr3060930ybb.48.1693586814866; Fri, 01
 Sep 2023 09:46:54 -0700 (PDT)
MIME-Version: 1.0
From:   Sara James <sara.b2bemaillist@gmail.com>
Date:   Fri, 1 Sep 2023 11:46:42 -0500
Message-ID: <CADoNQ0JbieHJWU=AAiR4DGP-n9ikG0=es5XKPSze8qx7bj1JNA@mail.gmail.com>
Subject: RE: APHA Conference Attendees Email list- 2023
To:     Sara James <sara.b2bemaillist@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=2.6 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FILL_THIS_FORM,
        FILL_THIS_FORM_LONG,FREEMAIL_FROM,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,
        SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: **
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Hi,

Would you be interested in acquiring The American Public Health
Association Email List-2023?

Our package includes a list of 17,968 attendees from the 2023 The
APHA, including their contact information such as Company Name,
Contact Name, First Name, Middle Name, Last Name, Title, Address,
Street, City, Zip code, State, Country, Telephone, Email address, and
more.

APHA Data package is available for $ 1,689.

Interested? Email me back; I would love to provide more information on the list.

Best regards,
Sara James
