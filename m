Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2546846F1AE
	for <lists+ceph-devel@lfdr.de>; Thu,  9 Dec 2021 18:25:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242919AbhLIR2g (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 9 Dec 2021 12:28:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242917AbhLIR2f (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 9 Dec 2021 12:28:35 -0500
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8845CC061746
        for <ceph-devel@vger.kernel.org>; Thu,  9 Dec 2021 09:25:01 -0800 (PST)
Received: by mail-ed1-x52c.google.com with SMTP id e3so22136077edu.4
        for <ceph-devel@vger.kernel.org>; Thu, 09 Dec 2021 09:25:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=iqExJZ9/DphBTKULUzi0rda5Ww/lFJEMJ0HrtECPjTI=;
        b=CEZX4drLnp80p9b9oVxK0f0qT2WA3YF+B1Tl8CQVWg2uGKK6+gQz0h/GPS2FyiNNJ9
         gAKRuC48E81Hb/mGX0sY3phjIF/WMv16b9bipyIo+rIOFDAbKwrmyJ7HqNkTia2gkVbu
         /I1NAgDWldKvVVC+e1z0jNAfGMMlQioj2HEiU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=iqExJZ9/DphBTKULUzi0rda5Ww/lFJEMJ0HrtECPjTI=;
        b=BCRZ9o2I72jeUHweCpw3Hq6+c/4b5Fw5X2tgWKyPvi8hYS0U4d6DfY1lwHtXn0vGWQ
         Ay3Hi87Ez49sKl478tvfaP/F2m3Q9+DMb9YSsF2gUgO5SdTd4q9ZMWDJmSvVT6+mgSO0
         coP9ebEVy1PdzAePTVpqlFqJSzdeIR4nT48za+BDXLP8NGpoD57wopISNM6ZjXNyLAFX
         BvyLfnwmzeLukOjJg4CgeCq4dvzFdXPSAZFSfS1Ll0bX+LKCwq3pUr5D6y4csx70Cg4z
         04vDnZVMzYr1e2YJFf7yXgXqamNyCH3GGszWPHIQCLaGL+9RqyXAek4uckA1t+NRPudk
         E6Yg==
X-Gm-Message-State: AOAM530UBqlx151mPAlLD63zqBpzVBo+BdUoPkG19/SjQJbllqJTIiF/
        iuG7X/GPpAvh21GURYetsJCSTAYlZ5YkbdtN
X-Google-Smtp-Source: ABdhPJztYl5fvC3jIgft7BBtSMUjVdFPJ104hUIIBerycG72VJ630H7aVa8O2msKeCrhoNL2R039Mg==
X-Received: by 2002:a17:906:3a9b:: with SMTP id y27mr17560538ejd.563.1639070536328;
        Thu, 09 Dec 2021 09:22:16 -0800 (PST)
Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com. [209.85.128.45])
        by smtp.gmail.com with ESMTPSA id f16sm191253edd.37.2021.12.09.09.22.14
        for <ceph-devel@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 09 Dec 2021 09:22:15 -0800 (PST)
Received: by mail-wm1-f45.google.com with SMTP id y196so4784819wmc.3
        for <ceph-devel@vger.kernel.org>; Thu, 09 Dec 2021 09:22:14 -0800 (PST)
X-Received: by 2002:a05:600c:22ce:: with SMTP id 14mr8659906wmg.152.1639070533785;
 Thu, 09 Dec 2021 09:22:13 -0800 (PST)
MIME-Version: 1.0
References: <163906878733.143852.5604115678965006622.stgit@warthog.procyon.org.uk>
 <163906891983.143852.6219772337558577395.stgit@warthog.procyon.org.uk>
In-Reply-To: <163906891983.143852.6219772337558577395.stgit@warthog.procyon.org.uk>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Thu, 9 Dec 2021 09:21:57 -0800
X-Gmail-Original-Message-ID: <CAHk-=wgejk2DA53dkzs6NquDbQk5_r6Hw8_-RJQ0_njNijKYew@mail.gmail.com>
Message-ID: <CAHk-=wgejk2DA53dkzs6NquDbQk5_r6Hw8_-RJQ0_njNijKYew@mail.gmail.com>
Subject: Re: [PATCH v2 10/67] fscache: Implement cookie registration
To:     David Howells <dhowells@redhat.com>
Cc:     linux-cachefs@redhat.com,
        Trond Myklebust <trondmy@hammerspace.com>,
        Anna Schumaker <anna.schumaker@netapp.com>,
        Steve French <sfrench@samba.org>,
        Dominique Martinet <asmadeus@codewreck.org>,
        Jeff Layton <jlayton@kernel.org>,
        Matthew Wilcox <willy@infradead.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Omar Sandoval <osandov@osandov.com>,
        JeffleXu <jefflexu@linux.alibaba.com>,
        linux-afs@lists.infradead.org,
        "open list:NFS, SUNRPC, AND..." <linux-nfs@vger.kernel.org>,
        CIFS <linux-cifs@vger.kernel.org>, ceph-devel@vger.kernel.org,
        v9fs-developer@lists.sourceforge.net,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Thu, Dec 9, 2021 at 8:55 AM David Howells <dhowells@redhat.com> wrote:
>
> +               buf = (u32 *)cookie->inline_key;
> +       }
> +
> +       memcpy(buf, index_key, index_key_len);
> +       cookie->key_hash = fscache_hash(cookie->volume->key_hash, buf, bufs);

This is actively wrong given the noise about "endianness independence"
of the fscache_hash() function.

There is absolutely nothing endianness-independent in the above.
You're taking some random data, casting the pointer to a native
word-order 32-bit entity, and then doing things in that native word
order.

The same data will give different results on different endiannesses.

Maybe some other code has always munged stuff so that it's in some
"native word format", but if so, the type system should have been made
to match. And it's not. It explicitly casts what is clearly some other
pointer type to "u32 *".

There is no way in hell this is properly endianness-independent with
each word in an array having some actual endianness-independent value
when you write code like this.

I'd suggest making endianness either explicit (make things explicitly
"__le32" or whatever) and making sure that you don't just randomly
cast pointers, you actually have the proper types.

Or, alternatively, just say "nobody cares about BE any more,
endianness isn't relevant, get over it".

But don't have functions that claim to be endianness-independent and
then randomly access data like this.

              Linus
