Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 243425961AC
	for <lists+ceph-devel@lfdr.de>; Tue, 16 Aug 2022 19:58:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236664AbiHPR6J (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 16 Aug 2022 13:58:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233523AbiHPR6I (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 16 Aug 2022 13:58:08 -0400
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B5572A8
        for <ceph-devel@vger.kernel.org>; Tue, 16 Aug 2022 10:58:05 -0700 (PDT)
Received: by mail-ed1-x533.google.com with SMTP id e13so14459062edj.12
        for <ceph-devel@vger.kernel.org>; Tue, 16 Aug 2022 10:58:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=VC/Trrv6J3X4sE7aLeQxuC2Jf1TU8h3dAVmLNNAb/Js=;
        b=baokk5qq0rlLRQ0xpdsWAYJYwpImRq1O33VCZKgpyUfde7GmI0lSm3zXzVCV3lyMAD
         4P11NRhDl0HTGv5KvbaqHyJVgYFEv7fzxNzP5DiTj8OajrzVTmGfJX4zttB+r6IjL4l1
         BdgfkFgN4/Jrel046lgdpxCSDjFqu9TcUfZEg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=VC/Trrv6J3X4sE7aLeQxuC2Jf1TU8h3dAVmLNNAb/Js=;
        b=PaPDa2FULO+lC0edia0PTdeJFFiJtDhnrjJM90AMCCoGxDeAIIHwAGHU9dvlryEIoN
         6dUvtTj0isZUunAmuXW4+9K1qW1Oi37DePVHWKAXD6HMVK5HXXmZ3et12+W9F7BAta0c
         43I860KMr3cSyUqP6H1YUIAd5WQblQw1kriOwn2gnulyog04YlnDk3yXKk9z6TMxgiVE
         Kr1aDMNF0ktsy7XjRb7Q+8sok/woZLmek2jxP1L/AZLQCpUVp41tw1s4ztV2OWzZyhH9
         qzhiENfmQkFeh912YpCLAv2hh7YqXZNZea6n7rK4B5NEs2R1wN1Ua3ArYa5BAFZa8xIJ
         vUMw==
X-Gm-Message-State: ACgBeo3HwNyglT1wxLTXBbn99iXOBvq8ca95HMnf1Nh0WtMkU1dPX8mp
        D6m4R+uBg8BhanfCs9K10VyZuOobTlKW7p+wI7w=
X-Google-Smtp-Source: AA6agR7HuR8iUPIYqzfiTPtGSRKNWumPHcL9s3J4hrHAGkyu2hSVSIFGUdLRwKSihkP4TLhDzsK6lQ==
X-Received: by 2002:a05:6402:1a44:b0:441:58fb:8b65 with SMTP id bf4-20020a0564021a4400b0044158fb8b65mr20238683edb.257.1660672683288;
        Tue, 16 Aug 2022 10:58:03 -0700 (PDT)
Received: from mail-wr1-f46.google.com (mail-wr1-f46.google.com. [209.85.221.46])
        by smtp.gmail.com with ESMTPSA id n16-20020aa7c790000000b0043d5c9281a3sm8765263eds.96.2022.08.16.10.58.02
        for <ceph-devel@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 16 Aug 2022 10:58:02 -0700 (PDT)
Received: by mail-wr1-f46.google.com with SMTP id p10so13527029wru.8
        for <ceph-devel@vger.kernel.org>; Tue, 16 Aug 2022 10:58:02 -0700 (PDT)
X-Received: by 2002:adf:e843:0:b0:225:221f:262 with SMTP id
 d3-20020adfe843000000b00225221f0262mr272373wrn.193.1660672681718; Tue, 16 Aug
 2022 10:58:01 -0700 (PDT)
MIME-Version: 1.0
References: <CAHk-=wh1xHi-WeytuAK1-iSsR0wi=6e4-WgFq6ZPt8Z1mvqoNA@mail.gmail.com>
 <Yvny9L3tw1EolqQ4@worktop.programming.kicks-ass.net> <CAHk-=whnEN3Apb5gRXSZK7BM+MOby9VCZe3sDcW34Zme_wk3uA@mail.gmail.com>
 <Yvqn8BqE7FdB6Ccd@worktop.programming.kicks-ass.net> <CAHk-=wj6QaNkoNPA0jrW8F_=RNNb1jCsFF2QngNEQb_C=wMDPQ@mail.gmail.com>
 <YvtPEA/9GV7GthZJ@worktop.programming.kicks-ass.net>
In-Reply-To: <YvtPEA/9GV7GthZJ@worktop.programming.kicks-ass.net>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Tue, 16 Aug 2022 10:57:45 -0700
X-Gmail-Original-Message-ID: <CAHk-=wjZ0oC0__-kLX51jRwo4XgAQ9xJ=OeT5_=fiLxmDexFZw@mail.gmail.com>
Message-ID: <CAHk-=wjZ0oC0__-kLX51jRwo4XgAQ9xJ=OeT5_=fiLxmDexFZw@mail.gmail.com>
Subject: Re: Simplify load_unaligned_zeropad() (was Re: [GIT PULL] Ceph
 updates for 5.20-rc1)
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     Al Viro <viro@zeniv.linux.org.uk>,
        Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Jeff Layton <jlayton@kernel.org>,
        Ilya Dryomov <idryomov@gmail.com>, ceph-devel@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Matthew Wilcox <willy@infradead.org>,
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

On Tue, Aug 16, 2022 at 1:02 AM Peter Zijlstra <peterz@infradead.org> wrote:
>
> > +#define EX_TYPE_ZEROPAD                      20 /* load ax from dx zero-padded */
>
> This comment is now woefully incorrect.

Yes it is. Will fix.

> > +     if (insn_decode(&insn, (void *) regs->ip, len, INSN_MODE_KERN))
> > +             return false;
>
> We have insn_decode_kernel() for exactly this (very) common case.

I did that originally, and then I undid it in disgust, because that
interface is too simple.

In particular, it just uses MAX_INSN_SIZE blindly. Which I didn't want
to do when I actually had the instruction size.

Yes, yes, I also check the decode size after-the-fact, but I didn't
want the decoder to even look at the invalid bytes.

This exception case is about the data being at the end of the page, I
wanted the fixup to be aware of code being at the end of a page too.

(And yeah, I'm not convinced that the decoder is that careful, but at
that point I feel it's a decoder issue, and not an issue with the code
I write).

> > +     if (insn.length != len)
> > +             return false;
> > +
> > +     if (insn.opcode.bytes[0] != 0x8b)
> > +             return false;
>
> I was wondering if we want something like MOV_INSN_OPCODE for 0x8b to
> enhance readability, otoh it's currently 0x8b all over the place, so
> whatever. At some point you gotta have the insn tables with you anyway.

Oh, I didn't even notice that we had another case of 0x8b checking.
But yeah, the MMIO decoding wants to see what kind of access it is.

But it wouldn't be MOV_INSN_OPCODE, it would have to be something like
MOV_WORD_INSN_MODRM_REG_OPCODE, because that's what people are
checking for - not just that it's a 'mov', but direction and size too.

And then you'd have to also decide whether you describe those
#define's using the Intel ordering or the one we actually use in our
asm. So now the symbolic names are ambiguous anyway, in ways that the
actual byte value isn't.

So yeah, I suspect it ends up just being an issue of "you have to have
the opcode tables in front of you anyway".

Because you also need to check that that's the only encoding for "mov"
(I checked, and yes, it is - there are other 'mov' encodings that move
directly from memory into %rax, but those are using absolute addresses
that don't make sense for a "this is an unaligned that might be a page
crosser")

Side note: now that I look at it, I note that the MMIO decoding
doesn't handle the absolute address case. It's not really relevant for
the kernel, but I could *imagine* that it is relevant in user mode,
and the SEV case actually does have a "decode and emulate user mode
instruction case".

Not a big issue. If some crazy user even maps IO at a fixed address,
and then uses a "mov %eax <-> moffset" instruction, the kernel
emulation will print out an error and refuse to emulate it.

                  Linus
