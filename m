Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 667B86EFC53
	for <lists+ceph-devel@lfdr.de>; Wed, 26 Apr 2023 23:18:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233554AbjDZVSp (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 26 Apr 2023 17:18:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239995AbjDZVSm (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 26 Apr 2023 17:18:42 -0400
Received: from mail-lf1-x134.google.com (mail-lf1-x134.google.com [IPv6:2a00:1450:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8FA03AB2
        for <ceph-devel@vger.kernel.org>; Wed, 26 Apr 2023 14:18:38 -0700 (PDT)
Received: by mail-lf1-x134.google.com with SMTP id 2adb3069b0e04-4f004943558so1547892e87.3
        for <ceph-devel@vger.kernel.org>; Wed, 26 Apr 2023 14:18:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682543917; x=1685135917;
        h=to:subject:message-id:date:from:reply-to:mime-version:from:to:cc
         :subject:date:message-id:reply-to;
        bh=JL3yT3Q33W5/BCQtgOVvz2cK4S2v0dqNTi6RS5aes9g=;
        b=KqbTHGyytrS1BOcngMo4G9Iy3ChDViqTCalIapEZkTkEXW7nHiuyUJZIjzD+8KmjH0
         WNOF8kbphsgcmGhboyq1SoRXrz1fzEChyXHqwDiPLFfff0P+1GmPtt8SiDEqsUD02Tud
         9iWJ5nbnXWoPa3P6ssvuwMEWL6ZDw/66oG95DvHM1eglQE6BdnMaoLka+eSjtzYU1mkE
         UOZtgpROqvdsgW5fIX2zobZ+AuNrNXEX5ZpMNA7t4OgNOVzFHIcjq3BtpwA9FHdMNg7T
         PE5LFKi6cjvxpaAxFgw6yJrU+amKlvktiyJMPy315uiAQBRAogZC6UKZfmQZQfmul2VQ
         Y3AA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682543917; x=1685135917;
        h=to:subject:message-id:date:from:reply-to:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=JL3yT3Q33W5/BCQtgOVvz2cK4S2v0dqNTi6RS5aes9g=;
        b=V9lsyv5HBsBjCu8aLovT8SnfFhX/gOXlipxTA+TP5E+sOqijlfKlAMxR1ZOX9bim8/
         0uv5n1ZrMohl0kuHPHoOzNEFM9y3cUbphKRjxf9pD0/nHTUdbHQ7pimpgAAaFjjXHOnD
         2ELownkbxecJczpuY/UKduy2ouRLS78ltf/RdkvYPKvhTDdJoELeOlBcaPaBuoSxYLcK
         HucVqX9FYDxqORGNl+RQGvKkHPZdw4zAOV3Qt2MsU3YngLEyQUeGZAXDoiDlRvq4pZba
         5YuG5z2TsRJmTchkoTJAYjoT35wvvbGqk/eqXfHFH610ZHMkNB9xNcplNJvAz4PUzGWJ
         7i0w==
X-Gm-Message-State: AAQBX9dajU6y4jpGWFJHzjcy4Cz55c1GhTUfhBZGn6z5nxadBDnxFx+3
        Chj7ydjzR92QpaBxlfkp/v84F2Ye38pRyxDsZGw=
X-Google-Smtp-Source: AKy350YHSHTYwidEcijDy90mfl6fJRlNgADO2xI0R6fakCPMbXlPlQ9g3ue4/do6LqnawMNDHXi0+lTf4W4ur4a20NU=
X-Received: by 2002:ac2:5a4a:0:b0:4d7:ccef:6b52 with SMTP id
 r10-20020ac25a4a000000b004d7ccef6b52mr5964589lfn.39.1682543916953; Wed, 26
 Apr 2023 14:18:36 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:ab2:638b:0:b0:1b8:330:92a1 with HTTP; Wed, 26 Apr 2023
 14:18:36 -0700 (PDT)
Reply-To: klassoumark@gmail.com
From:   Mark Klassou <charleslucasmake@gmail.com>
Date:   Wed, 26 Apr 2023 21:18:36 +0000
Message-ID: <CAPKQk4Vbvuh+JRhE_mH_Qmsg4qKzcDZA0gJ_q7eMe57zvk22_Q@mail.gmail.com>
Subject: Re
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=3.7 required=5.0 tests=BAYES_40,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,FREEMAIL_REPLYTO,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        UNDISC_FREEM autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: ***
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Good Morning,

I was only wondering if you got my previous email? I have been trying
to reach you by email. Kindly get back to me swiftly, it is very
important.

Yours faithfully
Mark Klassou.
