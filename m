Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3EA0459080B
	for <lists+ceph-devel@lfdr.de>; Thu, 11 Aug 2022 23:30:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235315AbiHKV34 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 11 Aug 2022 17:29:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229591AbiHKV3y (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 11 Aug 2022 17:29:54 -0400
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 955F29D8E9
        for <ceph-devel@vger.kernel.org>; Thu, 11 Aug 2022 14:29:53 -0700 (PDT)
Received: by mail-ej1-x635.google.com with SMTP id k26so35707826ejx.5
        for <ceph-devel@vger.kernel.org>; Thu, 11 Aug 2022 14:29:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=VBVguebNsed4JHqBLdZ7/rFrHjcbNJWah0iJWMXOSv4=;
        b=NFG1HQSM0O6Jf7SBD7BNXBhIFpeZiANKK67mUTxpyGt9xhZstsMvYLuTfwX1HANa9X
         P1oHlk3r5nM94hBzmuLNwwWxmK2sitEZhvHeDJhawn2Mne+EPZJq5eWghnbFL18KKCdw
         kuQlXz3dGIvTtpgMfta6fN3M/1ES2zGHXd+AA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=VBVguebNsed4JHqBLdZ7/rFrHjcbNJWah0iJWMXOSv4=;
        b=108/+sNMcw4Q+DI/q2J0EJMjU4qEbhtbY2jBgTN2cWFP5xX2pDPJWNVdIxlEts/mOM
         4KtHzcznIuHENYy2gIFt3rUGYXtz5eBh4v3cUaEsqIeyFJ8CEdujYx9Ib+CcIMXVPaty
         Ime7f6sr5Ve0hH24GGgNjNTFd/Y6svVOZrN8on+hNiVtT1f+VZ5iGwSVGPctBh2rOrPo
         3uHOn/p3CrtsFkTDTm1LKpPNWZF4WrBd28w1JT9YCAoPVaePinhjsobi6wG9FA9j3vVN
         tvb1OfQqNl89ebOsBUM1bsa82QFWL8LfrnOrFe5AMjNaPswWP+Ju9P6IwqFMlOvb40/i
         p2Xg==
X-Gm-Message-State: ACgBeo3C+iUJiz6Hw4XFa65ymqPresoSvSKGFIi52XufzuZxGN3EDxAl
        Ez4Ct5tySZWO/5AB4TM6PQUIXED1aSKq3Qpm
X-Google-Smtp-Source: AA6agR4WQy3NLbgGID5FNv/Q1YEwut+OEb8RRcsNo3zRD1/hXIZMLqqnZxVWRQtjn8Nn6QuQT+g7LA==
X-Received: by 2002:a17:906:5d08:b0:734:bf6a:6309 with SMTP id g8-20020a1709065d0800b00734bf6a6309mr649472ejt.516.1660253391952;
        Thu, 11 Aug 2022 14:29:51 -0700 (PDT)
Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com. [209.85.221.41])
        by smtp.gmail.com with ESMTPSA id c18-20020a056402121200b0043cc2c9f5adsm294907edw.40.2022.08.11.14.29.51
        for <ceph-devel@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 11 Aug 2022 14:29:51 -0700 (PDT)
Received: by mail-wr1-f41.google.com with SMTP id j7so22714706wrh.3
        for <ceph-devel@vger.kernel.org>; Thu, 11 Aug 2022 14:29:50 -0700 (PDT)
X-Received: by 2002:a05:6000:178d:b0:222:c7ad:2d9a with SMTP id
 e13-20020a056000178d00b00222c7ad2d9amr431723wrg.274.1660253390641; Thu, 11
 Aug 2022 14:29:50 -0700 (PDT)
MIME-Version: 1.0
References: <20220811152446.281723-1-idryomov@gmail.com> <CAHk-=wifgq59uru6xDB=nY-1p6aQ-1YB8nVhW7T-N2ctK3m1gw@mail.gmail.com>
 <CAOi1vP9BSi-65of-8D0BA1_DC0eVD_TQcWkhrGJwaXw_skhHFQ@mail.gmail.com>
In-Reply-To: <CAOi1vP9BSi-65of-8D0BA1_DC0eVD_TQcWkhrGJwaXw_skhHFQ@mail.gmail.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Thu, 11 Aug 2022 14:29:34 -0700
X-Gmail-Original-Message-ID: <CAHk-=whh8QnNb=F6567o=6UKP-Mvi0cjvZKO6zY5QvK84DwV9A@mail.gmail.com>
Message-ID: <CAHk-=whh8QnNb=F6567o=6UKP-Mvi0cjvZKO6zY5QvK84DwV9A@mail.gmail.com>
Subject: Re: [GIT PULL] Ceph updates for 5.20-rc1
To:     Ilya Dryomov <idryomov@gmail.com>
Cc:     ceph-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jeff Layton <jlayton@kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Matthew Wilcox <willy@infradead.org>
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

On Thu, Aug 11, 2022 at 1:56 PM Ilya Dryomov <idryomov@gmail.com> wrote:
>
> On Thu, Aug 11, 2022 at 10:04 PM Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
> >
> > What's the point of warning about bogus folios more than once? That's
> > a debug warning - if it hits even once, that's already "uhhuh,
> > something is bad". Showing the warning more than once is likely just
> > going to cause more problems, not give you more information.
>
> Xiubo and Jeff used it to track down some issues between netfs library
> and folio code that have been randomly plaguing our automated tests for
> a couple of releases.  We already knew that there were issues in that
> area and the actual occurrences mattered.  This was done in cooperation
> with Willy and, since he was involved and this is a no-impact change,
> I didn't think twice.

I don't mind the warning.

I mind the "more than ONCE" part.

If it's a "this shouldn't happen, but if it ever happens I want to
know about it" situation, then the ONCE variant should be what you
want.

And that variant already existed, and adding a new and inferior macro
seems to just have been pointless.

As to dcache issues - if you really don't get an ack from Al, you can
at least make me aware of it before-hand. That's one of the files that
I at least personally care about, and while I would much prefer an ack
from Al for anything that touches it, at least I'll likely be less
unhappy about changes if I was made aware of them ahead of time,
instead of seeing a pull request that suddenly changes that file.

               Linus
