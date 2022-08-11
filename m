Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9938E590736
	for <lists+ceph-devel@lfdr.de>; Thu, 11 Aug 2022 22:04:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233628AbiHKUEU (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 11 Aug 2022 16:04:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229833AbiHKUES (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 11 Aug 2022 16:04:18 -0400
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D855C9C206
        for <ceph-devel@vger.kernel.org>; Thu, 11 Aug 2022 13:04:17 -0700 (PDT)
Received: by mail-ed1-x530.google.com with SMTP id s11so24230863edd.13
        for <ceph-devel@vger.kernel.org>; Thu, 11 Aug 2022 13:04:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=zQB4Obdf/ipH+ijxdi6W4PtV/skZKNQuUU98S4y1UyM=;
        b=DVfnJzwPFC5exnMxGhX1SSonGK3v6yFK5cwUkJwWATTOdO2d7HIXjTHHwt7FK0Icgn
         MSM0ofpCJemi1TDflXFCe7xEbC8iysXVsdR03vgzw/srZPjyS8O/Si7Xj5FtxNCvluaG
         3oWJ0O5YjeoGs/uxzAmlfHB+rzqheSHhTA4R0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=zQB4Obdf/ipH+ijxdi6W4PtV/skZKNQuUU98S4y1UyM=;
        b=TFYjkZ9OuuDK9Wx1k2ob3tsx0bQSkOdeJLoumU5Wk/15UBB2jC4A4D52KoIcmrMLeg
         hBdJ0db/Mzw+BgzE/6UKF/cydOdS4zL0VLuULRo45RVgLYxVoygpSWwZ5RlZ2+b1tdbS
         UkvmKlumF2pum+SzNqkhyBvZPvGorxtCm2+VdT7uUibBXgBHF2Lw2aiFfr+LZ3MVdWx4
         CigU3ykzMJr4V7ZOlxQl43KymR3EqqQvcBm4mijKQMzQu5YdO+cAovrXtHaIHOBWcLWu
         Wt1CToyS+d3cbSPvunJCGnwmV74l4nthVfAIbK1Xdz6JHAXyfPIR3H7B6R1Jlj5kLrpE
         Ajsw==
X-Gm-Message-State: ACgBeo3sAlgPRhHAecQJq57yYjQuNlCz4xegQu4TQSfAcxyGhGV/GziN
        y8ceqmPFt6QoiVVCjjc1/+BtOhhcb5zKkOiv
X-Google-Smtp-Source: AA6agR7T5N5iKmu0qexiiVcbr90hO5AN5nzORyda9yRKHveoTA65FWnOPGx7bK+lnuBO0dA6NxmI9A==
X-Received: by 2002:a50:ed82:0:b0:43d:5334:9d19 with SMTP id h2-20020a50ed82000000b0043d53349d19mr660000edr.232.1660248256131;
        Thu, 11 Aug 2022 13:04:16 -0700 (PDT)
Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com. [209.85.128.43])
        by smtp.gmail.com with ESMTPSA id ot3-20020a170906ccc300b0072ab06bf296sm42118ejb.23.2022.08.11.13.04.13
        for <ceph-devel@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 11 Aug 2022 13:04:14 -0700 (PDT)
Received: by mail-wm1-f43.google.com with SMTP id m17-20020a7bce11000000b003a5bedec07bso1458342wmc.0
        for <ceph-devel@vger.kernel.org>; Thu, 11 Aug 2022 13:04:13 -0700 (PDT)
X-Received: by 2002:a05:600c:4ed0:b0:3a3:3ef3:c8d1 with SMTP id
 g16-20020a05600c4ed000b003a33ef3c8d1mr6705127wmq.154.1660248253437; Thu, 11
 Aug 2022 13:04:13 -0700 (PDT)
MIME-Version: 1.0
References: <20220811152446.281723-1-idryomov@gmail.com>
In-Reply-To: <20220811152446.281723-1-idryomov@gmail.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Thu, 11 Aug 2022 13:03:57 -0700
X-Gmail-Original-Message-ID: <CAHk-=wifgq59uru6xDB=nY-1p6aQ-1YB8nVhW7T-N2ctK3m1gw@mail.gmail.com>
Message-ID: <CAHk-=wifgq59uru6xDB=nY-1p6aQ-1YB8nVhW7T-N2ctK3m1gw@mail.gmail.com>
Subject: Re: [GIT PULL] Ceph updates for 5.20-rc1
To:     Ilya Dryomov <idryomov@gmail.com>
Cc:     ceph-devel@vger.kernel.org, linux-kernel@vger.kernel.org
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

On Thu, Aug 11, 2022 at 8:25 AM Ilya Dryomov <idryomov@gmail.com> wrote:
>
>    [..] Several patches
> touch files outside of our normal purview to set the stage for bringing
> in Jeff's long awaited ceph+fscrypt series in the near future.  All of
> them have appropriate acks and sat in linux-next for a while.

What? No.

I'm looking at the fs/dcache.c change, for example, and don't see the
relevant maintainers having acked it at all.

The mmdebug.h file similarly seems to not have the actual maintainer
acks, and seems just plain stupid (why does it add that new folio
warning macro, when the existing folio warning macro
VM_WARN_ON_ONCE_FOLIO() is *better*?

Those are some very core files, and while the changes seem harmless,
they sure don't seem obviously ok.

What's the point of warning about bogus folios more than once? That's
a debug warning - if it hits even once, that's already "uhhuh,
something is bad". Showing the warning more than once is likely just
going to cause more problems, not give you more information.

And did somebody verify that d_same_name() is still inlined in the
place that truly *matters*?  Because from my quick test, that patch
broke it. Now __d_lookup() does a function call.

And I _suspect_ it's all ok, because it turns out that
__d_lookup_rcu() is the *really* hot case, and that one has inlined it
all manually.

But this kind of "we touch some *truly* core functionality, without
the acks from the maintainers, and then we *claim* to have relevant
acks" is really not even remotely ok.

I've pulled this because I suspect that d_same_name() thing is fine,
and I think the VM_WARN_ON_FOLIO() addition is completely wrong but
not horrendous.

But you're on my tentative shit-list just for having claimed to have
appropriate acks and having been found wanting.

Just for your information: fs/dcache.c is some of the most optimized
code in the kernel, and some of the subtlest. That RCU pathname lookup
is serious business. You don't make changes to pathname lookup just
willy nilly. There's a reason I start looking at individual patches
when I see it in the diffstat.

And please just get rid of VM_WARN_ON_FOLIO() again, and use the
VM_WARN_ON_ONCE_FOLIO() version. Because if you expect to have
multiple, then you probably shouldn't have that warning at ALL.

                 Linus
