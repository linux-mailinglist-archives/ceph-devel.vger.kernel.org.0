Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 101725926E4
	for <lists+ceph-devel@lfdr.de>; Mon, 15 Aug 2022 01:00:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229534AbiHNXAD (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Sun, 14 Aug 2022 19:00:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229450AbiHNXAC (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Sun, 14 Aug 2022 19:00:02 -0400
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 149DA12ACE
        for <ceph-devel@vger.kernel.org>; Sun, 14 Aug 2022 16:00:01 -0700 (PDT)
Received: by mail-ej1-x633.google.com with SMTP id qn6so10865563ejc.11
        for <ceph-devel@vger.kernel.org>; Sun, 14 Aug 2022 16:00:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=Pj3DvG1yaHOkAJw48TxvAXH1Fka6b4HnFllXzmcNwmw=;
        b=gzkf8K+iznFC9OOtWwMej/nzlLqmZ0MKBv/EwSRygYlFzaYE0tX304Bv695K4p2emu
         Vry7WzQ7X7QHzQbhWpuhBUZjFOa/TpLQzwwFM9uiuopeowiIuBUohclzsijz/xuVK/QU
         Z01A8WEGSY17fYuv+7E/1BhUBqQcl94xAR6kw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=Pj3DvG1yaHOkAJw48TxvAXH1Fka6b4HnFllXzmcNwmw=;
        b=FU6XwY3ycc21LxtUmnZMY3dHoXrP/0gtOl1QYCLfYGhkubUwxOixY2OBYLpBJqMG5p
         rE8JS2VCGle+3BdICVBkuAWXRqSxnfPLiRo9agRLeumW/uqvPH18NgrQvMgr0saAfr3V
         5Op81I+OiYXWVQv8KowIXvNUdXTw141fXLKkKTSxieGYqOps4KI4n8FqYxIL96G1CvPZ
         8zg0yMDMZ88P53C86ikbKTD1x9tsxeoKOCcm9/CrFpPeymvIPvvW0uCHcKQ9tPXc4yRm
         rLlDqiOa4zsA0ZhIn3GNPc7k3uYeqdPI6EBFH6aI/f/6sefn4p3iKGE8W1fGLJInMwhZ
         piug==
X-Gm-Message-State: ACgBeo20MviV1zISEW7fa1O8vhdmOhwaZ5ASAzqkYQ3GKHiU3Dud9/vF
        59PgiMrgXNNdZcpx8NomcEl9WTBIv9lUKDT9
X-Google-Smtp-Source: AA6agR5fGvxB/Ww/TcqD+BXw13J/Z46h/vrFLdnzezYXI0/0/mqAhgZXQotTygv5zy8BrIx5RYZtpA==
X-Received: by 2002:a17:907:3f24:b0:730:bcbd:395d with SMTP id hq36-20020a1709073f2400b00730bcbd395dmr9027345ejc.540.1660517999439;
        Sun, 14 Aug 2022 15:59:59 -0700 (PDT)
Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com. [209.85.221.49])
        by smtp.gmail.com with ESMTPSA id cn19-20020a0564020cb300b0043bdc47803csm5499049edb.30.2022.08.14.15.59.58
        for <ceph-devel@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 14 Aug 2022 15:59:58 -0700 (PDT)
Received: by mail-wr1-f49.google.com with SMTP id bv3so7252525wrb.5
        for <ceph-devel@vger.kernel.org>; Sun, 14 Aug 2022 15:59:58 -0700 (PDT)
X-Received: by 2002:a5d:56cf:0:b0:21e:ce64:afe7 with SMTP id
 m15-20020a5d56cf000000b0021ece64afe7mr7004000wrw.281.1660517998361; Sun, 14
 Aug 2022 15:59:58 -0700 (PDT)
MIME-Version: 1.0
References: <CAHk-=wh1xHi-WeytuAK1-iSsR0wi=6e4-WgFq6ZPt8Z1mvqoNA@mail.gmail.com>
 <20220814225415.n546anzvud6sumux@box.shutemov.name>
In-Reply-To: <20220814225415.n546anzvud6sumux@box.shutemov.name>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Sun, 14 Aug 2022 15:59:42 -0700
X-Gmail-Original-Message-ID: <CAHk-=wiOqbuzy7xzsLrN8LXKGGUUMH109wcKOXx_PV9PkHa=Zw@mail.gmail.com>
Message-ID: <CAHk-=wiOqbuzy7xzsLrN8LXKGGUUMH109wcKOXx_PV9PkHa=Zw@mail.gmail.com>
Subject: Re: Simplify load_unaligned_zeropad() (was Re: [GIT PULL] Ceph
 updates for 5.20-rc1)
To:     "Kirill A. Shutemov" <kirill@shutemov.name>
Cc:     Al Viro <viro@zeniv.linux.org.uk>,
        Peter Zijlstra <peterz@infradead.org>,
        Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Jeff Layton <jlayton@kernel.org>,
        Ilya Dryomov <idryomov@gmail.com>, ceph-devel@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Matthew Wilcox <willy@infradead.org>,
        clang-built-linux <llvm@lists.linux.dev>,
        Dave Hansen <dave.hansen@linux.intel.com>
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

On Sun, Aug 14, 2022 at 3:51 PM Kirill A. Shutemov <kirill@shutemov.name> wrote:
>
> Do we gain enough benefit from the microoptimization to justify existing
> load_unaligned_zeropad()? The helper has rather confusing side-effects.

It's a *big* deal in pathname handling, yes. Doing things a byte at a
time is very noticeably slower.

If TDX has problems with it, then TDX needs to be fixed. And it's
simple enough - just make sure you have a guard page between any
kernel RAM mapping and whatever odd crazy page.

There is nothing subtle about this at all. You probably would want
that guard page *anyway*.

That "uaccepted memory" type needs to be just clearly fixed.

                Linus
