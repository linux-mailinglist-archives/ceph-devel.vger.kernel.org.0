Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 177B359264D
	for <lists+ceph-devel@lfdr.de>; Sun, 14 Aug 2022 22:30:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231894AbiHNU3u (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Sun, 14 Aug 2022 16:29:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231800AbiHNU3t (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Sun, 14 Aug 2022 16:29:49 -0400
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03B451EEC7
        for <ceph-devel@vger.kernel.org>; Sun, 14 Aug 2022 13:29:48 -0700 (PDT)
Received: by mail-ej1-x629.google.com with SMTP id w19so10542837ejc.7
        for <ceph-devel@vger.kernel.org>; Sun, 14 Aug 2022 13:29:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=xfOGomlI+wNDkGCVf2j5gRZIqtfFV7kG9Gxf0h/VnxU=;
        b=D1Y6bxPBDIzqq1QHg8NrNOVPs/qLN7TnjpcqjIhu/3KiooSJamYyL11iJeBHUGuw4Z
         /zCFkyohXYQGDTrDFRt92yXE7xHfQMB2U2yeRZ5Y1qo3oqC+NdAsr9axuEid3/m+fXAW
         3BVEy3YoQhiAJCUpa+1DpLtLqINhPLQMU9Pug=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=xfOGomlI+wNDkGCVf2j5gRZIqtfFV7kG9Gxf0h/VnxU=;
        b=jzYSC8pmVfTGxVP7A5cCD3rpsDPVpKmQPF/TPiaZpHSP/61hLTgmBneaLOUILxQA7M
         3x6QdIkFNWcvP9cIalZhHiPi07Jwgx/8JKlaMp/I/cUVKlzTIPx/vqfBWjB4Gy5GIiae
         24XEY5d6LbDyLPfiSW6Gcm4j/2EVkJRBHiO/FLZakieQ/FUlxo4LKw+dvwRI8hVRs0wM
         9j1MwKRCZVFxGaDR1ze50aJUqiRBBVekNemt1OVG+mtirnJuDh28owvOGZp+GeadqIFA
         VPFJ8O1zibOTuNmxLNtLBYPU3fmecPElD3X/D9ylNa/nQOjN8l9XNajOe1Y3+fUgTPY7
         qlSQ==
X-Gm-Message-State: ACgBeo0WsYN2MVpktFmB8De8EFRMRPNDEdeMO2ZZE45AqAfTsGPmaaHe
        VOC+ahe/3RfWdNd0Nj5fLf6JwWTcI2xAt09q
X-Google-Smtp-Source: AA6agR5WzieyAlpEiudOWQvwqADSBOEnBmhpN5m4nqSaOqW4gayak2I58qDlCydC5SOaDstNuXAwBg==
X-Received: by 2002:a17:907:3daa:b0:730:a788:a6e4 with SMTP id he42-20020a1709073daa00b00730a788a6e4mr8432166ejc.77.1660508986302;
        Sun, 14 Aug 2022 13:29:46 -0700 (PDT)
Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com. [209.85.128.54])
        by smtp.gmail.com with ESMTPSA id q3-20020a170906144300b007307c557e31sm3266611ejc.106.2022.08.14.13.29.45
        for <ceph-devel@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 14 Aug 2022 13:29:45 -0700 (PDT)
Received: by mail-wm1-f54.google.com with SMTP id s11-20020a1cf20b000000b003a52a0945e8so3064231wmc.1
        for <ceph-devel@vger.kernel.org>; Sun, 14 Aug 2022 13:29:45 -0700 (PDT)
X-Received: by 2002:a05:600c:4ed0:b0:3a3:3ef3:c8d1 with SMTP id
 g16-20020a05600c4ed000b003a33ef3c8d1mr14508149wmq.154.1660508985000; Sun, 14
 Aug 2022 13:29:45 -0700 (PDT)
MIME-Version: 1.0
References: <CAOi1vP9BSi-65of-8D0BA1_DC0eVD_TQcWkhrGJwaXw_skhHFQ@mail.gmail.com>
 <5d0b0367a5e28ec5b1f3b995c7792ff9a5cbcbd4.camel@kernel.org>
 <YvVzHQ5DVaPAvw26@ZenIV> <72a93a2c8910c3615bba7c093c66c18b1a6a2696.camel@kernel.org>
 <YvV2zfT0XbgwHGe/@ZenIV> <CAHk-=wgYnAPiGsh7H4BS_E1aMM46PdSGg8YqFhi2SpGw+Ac_PQ@mail.gmail.com>
 <YvV86p5DjBLjjXHo@ZenIV> <CAHk-=wjCa=Xf=pA2Z844WnwEeYgy9OPoB2kWphvg7PVn3ohScw@mail.gmail.com>
 <CAHk-=wjLLw0xjL+TZs5DUGL8hOpmLMa4B92aDVFxw4HZthLraw@mail.gmail.com>
 <CAHk-=wjyOB66pofW0mfzDN7SO8zS1EMRZuR-_2aHeO+7kuSrAg@mail.gmail.com>
 <YvlILbn1ERLgZreh@ZenIV> <CAHk-=wjvKtkqF9AXx8GoA80h_RNUV=Ld8qhi8ZEPmDXC0VUDUA@mail.gmail.com>
In-Reply-To: <CAHk-=wjvKtkqF9AXx8GoA80h_RNUV=Ld8qhi8ZEPmDXC0VUDUA@mail.gmail.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Sun, 14 Aug 2022 13:29:28 -0700
X-Gmail-Original-Message-ID: <CAHk-=wiVyGt0XCFom97ULZyG5Phf7+ifC03sW1i4HUz7xaazng@mail.gmail.com>
Message-ID: <CAHk-=wiVyGt0XCFom97ULZyG5Phf7+ifC03sW1i4HUz7xaazng@mail.gmail.com>
Subject: Re: [GIT PULL] Ceph updates for 5.20-rc1
To:     Al Viro <viro@zeniv.linux.org.uk>
Cc:     Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Jeff Layton <jlayton@kernel.org>,
        Ilya Dryomov <idryomov@gmail.com>, ceph-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org, Matthew Wilcox <willy@infradead.org>,
        clang-built-linux <llvm@lists.linux.dev>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Sun, Aug 14, 2022 at 1:03 PM Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> Gcc does well regardless, and clang ends up really wanting to move so
> much out of the dentry_cmp() loop that it runs out of registers and
> always ends up doing a couple of spills.
>
> I think it reduced the spills by one, but not enough to generate the
> nice non-frame code that gcc does.

Note that that code was basically written to make gcc happy, so the
fact that clang then does worse is not hugely surprising.

I dug into it some more, and it is really "load_unaligned_zeropad()"
that makes clang really uncomfortable.

The problem ends up being that clang sees that it's inside that inner
loop, and tries very hard to optimize the shift-and-mask that happens
if the exception happens.

The fact that the exception *never* happens unless DEBUG_PAGEALLOC is
enabled - and very very seldom even then - is not something we can
really explain to clang.

So it thinks that code is really hot in the inner loop, and does all
kinds of silly things due to that.

Gcc, in contrast, generates the obvious straightforward code, and
that's what I wrote and optimized that code for.

             Linus
