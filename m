Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CE3DD6495AE
	for <lists+ceph-devel@lfdr.de>; Sun, 11 Dec 2022 19:30:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229624AbiLKS2M (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Sun, 11 Dec 2022 13:28:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229461AbiLKS2K (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Sun, 11 Dec 2022 13:28:10 -0500
Received: from mail-qt1-x830.google.com (mail-qt1-x830.google.com [IPv6:2607:f8b0:4864:20::830])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B8C8A1B9
        for <ceph-devel@vger.kernel.org>; Sun, 11 Dec 2022 10:28:09 -0800 (PST)
Received: by mail-qt1-x830.google.com with SMTP id a16so7383804qtw.10
        for <ceph-devel@vger.kernel.org>; Sun, 11 Dec 2022 10:28:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=VcIjNZvmXhwLlIH4qzTb3os7YT1CTCX89zz+g7s11S8=;
        b=MGBmNEXQ9KDFHMWkhfA16f3WXE9+n6bQWGbQ/WBcrwvvD7XGUxNJ4lULAQ4bF52hyX
         I45Gmp4HDqpBwWuXX3l+4nvpELR0hLZgp15u/sM1JcfxMioNWKmTXOmZ3q/OnbB9HyzY
         NTeZGgpA0T0hHbjbfhGwL2uIoepMHlEZ6wf+E=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=VcIjNZvmXhwLlIH4qzTb3os7YT1CTCX89zz+g7s11S8=;
        b=P/tbNzikqjzwjZ94EvMas49TkC6vUe6VMKvFF5NByIvgCH4H/FqU2/DfbAH4bHKLIs
         VWJ34DxXkimeG/7gsgJcuUuDKPfKgozw9X0hye+WZTOQqZl3vnK0dXu7lGr7+kyWGkUq
         WnOxPQGnpHEad+24EP+u4NJhc0ez2mv9+kNODCEcDH8VQk/a3xEVrk2Xj5cE8HpfOrkL
         WznTgkQcbWEIyYErvPUjAljPeK6KWlA8lYfxDYeaLG8VtBwa9Rxz4OQnz9x2O94C/5g0
         rT6MkPo7Z+ajkArU/N/sl/bc+xpoWtaIPHqtaeM+rPusUYkga9CA5UNz+6xjAVfeMNno
         1skg==
X-Gm-Message-State: ANoB5pm/1XC9K9oE7XcdzurcTYiLiS8d1rC5sXmex9T6D0Odamm373Lt
        ofIkotddDn8LGaXyryMaT6BUu/AjieNo4Uq1
X-Google-Smtp-Source: AA0mqf7WJ75mgkYORrAMGaWzLON1Jdw7VJPZOuMR1H06iOP+keyb0o5gK9bZLafJk1aYjzxC72j91A==
X-Received: by 2002:a05:622a:1e15:b0:3a8:61f:8f55 with SMTP id br21-20020a05622a1e1500b003a8061f8f55mr12997498qtb.50.1670783287860;
        Sun, 11 Dec 2022 10:28:07 -0800 (PST)
Received: from mail-qv1-f52.google.com (mail-qv1-f52.google.com. [209.85.219.52])
        by smtp.gmail.com with ESMTPSA id c3-20020ac81103000000b003a50ef44a77sm4561017qtj.28.2022.12.11.10.28.05
        for <ceph-devel@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 11 Dec 2022 10:28:07 -0800 (PST)
Received: by mail-qv1-f52.google.com with SMTP id u10so6851053qvp.4
        for <ceph-devel@vger.kernel.org>; Sun, 11 Dec 2022 10:28:05 -0800 (PST)
X-Received: by 2002:ad4:4101:0:b0:4b1:856b:4277 with SMTP id
 i1-20020ad44101000000b004b1856b4277mr70224982qvp.129.1670783284766; Sun, 11
 Dec 2022 10:28:04 -0800 (PST)
MIME-Version: 1.0
References: <202212112131.994277de-oliver.sang@intel.com>
In-Reply-To: <202212112131.994277de-oliver.sang@intel.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Sun, 11 Dec 2022 10:27:48 -0800
X-Gmail-Original-Message-ID: <CAHk-=wipgS=05hJdztC8sJj01wpxMKQ67tV53UyFa2WtZ93o5A@mail.gmail.com>
Message-ID: <CAHk-=wipgS=05hJdztC8sJj01wpxMKQ67tV53UyFa2WtZ93o5A@mail.gmail.com>
Subject: Re: [ammarfaizi2-block:dhowells/linux-fs/fscache-fixes] [mm, netfs,
 fscache] 6919cda8e0: canonical_address#:#[##]
To:     kernel test robot <oliver.sang@intel.com>
Cc:     David Howells <dhowells@redhat.com>, oe-lkp@lists.linux.dev,
        lkp@intel.com, Rohith Surabattula <rohiths.msft@gmail.com>,
        Matthew Wilcox <willy@infradead.org>,
        Steve French <sfrench@samba.org>,
        Shyam Prasad N <nspmangalore@gmail.com>,
        Dave Wysochanski <dwysocha@redhat.com>,
        Dominique Martinet <asmadeus@codewreck.org>,
        Ilya Dryomov <idryomov@gmail.com>,
        Ammar Faizi <ammarfaizi2@gnuweeb.org>,
        "GNU/Weeb Mailing List" <gwml@vger.gnuweeb.org>,
        v9fs-developer@lists.sourceforge.net,
        linux-afs@lists.infradead.org, linux-cachefs@redhat.com,
        ceph-devel@vger.kernel.org, linux-cifs@vger.kernel.org,
        samba-technical@lists.samba.org, linux-fsdevel@vger.kernel.org,
        linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

The disassembly isn't great, because the test robot doesn't try to
find where the instructions start, but before that

>    4:   48 8b 57 18             mov    0x18(%rdi),%rdx

instruction we also had a

      mov    (%rdi),%rax

and it looks like this is the very top of 'filemap_release_folio()',
so '%rdi' contains the folio pointer coming into this.

End result:

On Sun, Dec 11, 2022 at 6:27 AM kernel test robot <oliver.sang@intel.com> wrote:
>
>    4:   48 8b 57 18             mov    0x18(%rdi),%rdx
>    8:   83 e0 01                and    $0x1,%eax
>    b:   74 59                   je     0x66

The

    and    $0x1,%eax
    je     0x66

above is the test for

    BUG_ON(!folio_test_locked(folio));

where it's jumping out to the 'ud2' in case the lock bit (bit #0) isn't set.

Then we have this:

>    d:   48 f7 07 00 60 00 00    testq  $0x6000,(%rdi)
>   14:   74 22                   je     0x38

Which is testing PG_private | PG_private2, and jumping out (which we
also don't do) if neither is set.

And then we have:

>   16:   48 8b 07                mov    (%rdi),%rax
>   19:   f6 c4 80                test   $0x80,%ah
>   1c:   75 32                   jne    0x50

Which is checking for PG_writeback.

So then we get to

    if (mapping && mapping->a_ops->release_folio)
            return mapping->a_ops->release_folio(folio, gfp);

which is this:

>   1e:   48 85 d2                test   %rdx,%rdx
>   21:   74 34                   je     0x57

This %rdx value is the early load from the top of the function, it's
checking 'mapping' for NULL.

It's not NULL, but it's some odd value according to the oops report:

  RDX: ffff889f03987f71

which doesn't look like it's valid (well, it's a valid kernel pointer,
but it's not aligned like a 'mapping' pointer should be.

So now when we're going to load 'a_ops' from there, we load another
garbage value:

>   23:   48 8b 82 90 00 00 00    mov    0x90(%rdx),%rax

and we now have RAX: b000000000000000

and then the 'a_ops->release_folio' access will trap:

>   2a:*  48 8b 40 48             mov    0x48(%rax),%rax          <-- trapping instruction
>   2e:   48 85 c0                test   %rax,%rax
>   31:   74 24                   je     0x57

The above is the "load a_ops->release_folio and test it for NULL", but
the load took a page fault because RAX was garbage.

But RAX was garbage because we already had a bogus "mapping" pointer earlier.

Now, why 'mapping' was bogus, I don't know. Maybe that page wasn't a
page cache page at all? The mapping field is in a union and can
contain other things.

So I have no explanation for the oops, but I thought I'd just post the
decoding of the instruction stream in case that helps somebody else to
figure it out.

                 Linus
