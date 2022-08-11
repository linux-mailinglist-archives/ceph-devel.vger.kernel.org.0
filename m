Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 04F465908C4
	for <lists+ceph-devel@lfdr.de>; Fri, 12 Aug 2022 00:43:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236408AbiHKWnc (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 11 Aug 2022 18:43:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236217AbiHKWnb (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 11 Aug 2022 18:43:31 -0400
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5B399D102
        for <ceph-devel@vger.kernel.org>; Thu, 11 Aug 2022 15:43:30 -0700 (PDT)
Received: by mail-ed1-x535.google.com with SMTP id a89so24718733edf.5
        for <ceph-devel@vger.kernel.org>; Thu, 11 Aug 2022 15:43:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=ZQKmytcen4+lptbV6k47XnVSNsx7hSYd3DzP5g/QpsI=;
        b=JhqVOuroHn8wOfhqmjL4lmbn7t2w6EFFeSecjmHVgpfa6kZXSg5ybW2S2BTyCJPk0L
         SKjzEY5B1fh23yd3mNkbkQtct1YT83yPGhjfbnQU4k+4o10Kpij0rDYYySOvZg8VGnkR
         LEwLNX0aTqwzLgnbGfeGIc+Orc0N+pgnG0YKg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=ZQKmytcen4+lptbV6k47XnVSNsx7hSYd3DzP5g/QpsI=;
        b=cxMhm57k8lMObTkA/p4hFYCd8mZFU8DxpXbi0tFLFP1vxTbvo1LE/21HM8gWbS8kVy
         caQnv11nijb/tvZlq+oD2HxQLbvuNZj8hkg6ilHr/UV5iG7xDgkM3aZEa1StLBozPvQ4
         4YmE0iOKj2qdbtrCu32zjRW6immxzvR8C3SYseT2EKieup0+vEGFsszOMbbjcjWDr49e
         VvT+lgdUwVUzvLcrZszN80I1ayrByRH0SGaJ4SAgb88QrhkH1/tAX9jpD4epoFdvk39m
         hbN/nCL/mXwrOMJeN8xIxSTksj4T3UL46mIHlw09elt+p8RFv1HusTbsnAGZT3qyiQ/9
         VZPw==
X-Gm-Message-State: ACgBeo1l+bXcMlg8S9G8doBbPE7EyMWvNPvgRfX73pNR/rVKvx8+6uKC
        qkXDfxAMixmTPiJJhEVsg2sOdi9VyuuTabT8
X-Google-Smtp-Source: AA6agR6SQ+Mp6tfoPaTcZB57M+lXExqMFQs1iw/uXIRTteC46ckX4n8fXqE0+9BqJw6/qrMMRAFo8g==
X-Received: by 2002:a05:6402:3550:b0:43d:e475:7d2f with SMTP id f16-20020a056402355000b0043de4757d2fmr1100771edd.166.1660257809040;
        Thu, 11 Aug 2022 15:43:29 -0700 (PDT)
Received: from mail-wr1-f51.google.com (mail-wr1-f51.google.com. [209.85.221.51])
        by smtp.gmail.com with ESMTPSA id l10-20020a1709063d2a00b0072ecef772acsm162132ejf.2.2022.08.11.15.43.27
        for <ceph-devel@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 11 Aug 2022 15:43:28 -0700 (PDT)
Received: by mail-wr1-f51.google.com with SMTP id bv3so22824565wrb.5
        for <ceph-devel@vger.kernel.org>; Thu, 11 Aug 2022 15:43:27 -0700 (PDT)
X-Received: by 2002:a05:6000:178d:b0:222:c7ad:2d9a with SMTP id
 e13-20020a056000178d00b00222c7ad2d9amr529576wrg.274.1660257807588; Thu, 11
 Aug 2022 15:43:27 -0700 (PDT)
MIME-Version: 1.0
References: <20220811152446.281723-1-idryomov@gmail.com> <CAHk-=wifgq59uru6xDB=nY-1p6aQ-1YB8nVhW7T-N2ctK3m1gw@mail.gmail.com>
 <CAOi1vP9BSi-65of-8D0BA1_DC0eVD_TQcWkhrGJwaXw_skhHFQ@mail.gmail.com>
 <5d0b0367a5e28ec5b1f3b995c7792ff9a5cbcbd4.camel@kernel.org>
 <YvVzHQ5DVaPAvw26@ZenIV> <72a93a2c8910c3615bba7c093c66c18b1a6a2696.camel@kernel.org>
 <YvV2zfT0XbgwHGe/@ZenIV> <CAHk-=wgYnAPiGsh7H4BS_E1aMM46PdSGg8YqFhi2SpGw+Ac_PQ@mail.gmail.com>
 <YvV86p5DjBLjjXHo@ZenIV> <CAHk-=wjCa=Xf=pA2Z844WnwEeYgy9OPoB2kWphvg7PVn3ohScw@mail.gmail.com>
In-Reply-To: <CAHk-=wjCa=Xf=pA2Z844WnwEeYgy9OPoB2kWphvg7PVn3ohScw@mail.gmail.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Thu, 11 Aug 2022 15:43:11 -0700
X-Gmail-Original-Message-ID: <CAHk-=wjLLw0xjL+TZs5DUGL8hOpmLMa4B92aDVFxw4HZthLraw@mail.gmail.com>
Message-ID: <CAHk-=wjLLw0xjL+TZs5DUGL8hOpmLMa4B92aDVFxw4HZthLraw@mail.gmail.com>
Subject: Re: [GIT PULL] Ceph updates for 5.20-rc1
To:     Al Viro <viro@zeniv.linux.org.uk>
Cc:     Jeff Layton <jlayton@kernel.org>,
        Ilya Dryomov <idryomov@gmail.com>, ceph-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org, Matthew Wilcox <willy@infradead.org>
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

On Thu, Aug 11, 2022 at 3:22 PM Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> Here's a recreation of that patch I mentioned where the OP_COMPARE is
> moved out of the loop. Just for fun, look at how much better the code
> generation is for the common case when you don't have the call messing
> up the clobbered registers etc.

Oh, sadly, clang does much worse here.

Gcc ends up being able to not have a stack frame at all for
__d_lookup_rcu() once that DCACHE_OP_COMPARE case has been moved out.
The gcc code really looks very nice.

Clang, not so much, and it still has spills and reloads.

The loop still ends up better with clang (since that test is no longer
in the loop), but the code generated doesn't go from "ugly to really
nice", it just goes from "ugly to still somewhat ugly".

                  Linus
