Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 642194905CC
	for <lists+ceph-devel@lfdr.de>; Mon, 17 Jan 2022 11:19:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238416AbiAQKTu (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 17 Jan 2022 05:19:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238435AbiAQKTt (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 17 Jan 2022 05:19:49 -0500
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C7AAC061574
        for <ceph-devel@vger.kernel.org>; Mon, 17 Jan 2022 02:19:48 -0800 (PST)
Received: by mail-ed1-x52f.google.com with SMTP id 30so63511779edv.3
        for <ceph-devel@vger.kernel.org>; Mon, 17 Jan 2022 02:19:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=4/B8S0T6l/cNTFCwbllAbkeryrIurv7WGfpD2SElg7M=;
        b=dv+17V5MOPEzuLfM1Cm4a6q4iFsZiMxvmb+0viRdfYd80RUx9gSegypMRnWQrTQsgq
         ELfJeQS4rdN44RZDM7QPPQ+LhOWupRIi2hAcGelXeM8j3ZRa1Ovn58l4OFMKbb0SCu+G
         sDzPWHuK7OWM2HO8kcdaLHy+dfHG+z9C+iDOU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=4/B8S0T6l/cNTFCwbllAbkeryrIurv7WGfpD2SElg7M=;
        b=3Thwoaj1TdNZ6mqIWI3c1WXCbofnzM0vg0omdNubUXR3c1hXL+mbPnCm5XGpgp65p2
         2saPF5FtKIp1Ts2SOR+VtjnZKumeBdB/hAG7Rsi6fpto6XUuzDAxGyc9emWLgTy4fp1x
         Y0ab47YLDl9ds9Lh5ih8yFcK+WhpWml9LJwITgv8gRS7VptctxpyfHNAo66mslozRC1i
         UUBvOl0ejy2Tbm26va3A8CEF95/N7NKe08tUVC5IYZP+R+lvRFSb3kuSytxinnxA9S/Y
         2msfjvJtxSmlwuldeXVNMHyY74HEo51RDBt5jliof3QrNR/icE8DN2CjERvVdj2XRZ5r
         h5cQ==
X-Gm-Message-State: AOAM5328s8YA3ffo2x6S2JbVwG6Ql9DJBeXI50h+yfKtt0+YjqzbjBMB
        UGMw5Op7RbMjHCMU2oVN8pSjv6xSF/5D/woI
X-Google-Smtp-Source: ABdhPJwCiRG1UDyl3DuZ8c+dgUmzo8OXVWZlbn1+/YrJeNaqcrfSxqsbsWtmm4VLGAclY3kBiGKWvg==
X-Received: by 2002:aa7:dc05:: with SMTP id b5mr19864762edu.46.1642414786990;
        Mon, 17 Jan 2022 02:19:46 -0800 (PST)
Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com. [209.85.128.53])
        by smtp.gmail.com with ESMTPSA id e28sm4334544ejm.96.2022.01.17.02.19.45
        for <ceph-devel@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 17 Jan 2022 02:19:46 -0800 (PST)
Received: by mail-wm1-f53.google.com with SMTP id p1-20020a1c7401000000b00345c2d068bdso23116466wmc.3
        for <ceph-devel@vger.kernel.org>; Mon, 17 Jan 2022 02:19:45 -0800 (PST)
X-Received: by 2002:a05:600c:3482:: with SMTP id a2mr3476469wmq.152.1642414785683;
 Mon, 17 Jan 2022 02:19:45 -0800 (PST)
MIME-Version: 1.0
References: <2752208.1642413437@warthog.procyon.org.uk>
In-Reply-To: <2752208.1642413437@warthog.procyon.org.uk>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Mon, 17 Jan 2022 12:19:29 +0200
X-Gmail-Original-Message-ID: <CAHk-=wjQG5HnwQD98z8de1EvRzDnebZxh=gQUVTKCn0DOp7PQw@mail.gmail.com>
Message-ID: <CAHk-=wjQG5HnwQD98z8de1EvRzDnebZxh=gQUVTKCn0DOp7PQw@mail.gmail.com>
Subject: Re: Out of order read() completion and buffer filling beyond returned amount
To:     David Howells <dhowells@redhat.com>
Cc:     Alexander Viro <viro@zeniv.linux.org.uk>,
        Anna Schumaker <anna.schumaker@netapp.com>,
        Dave Wysochanski <dwysocha@redhat.com>,
        Dominique Martinet <asmadeus@codewreck.org>,
        Jeff Layton <jlayton@kernel.org>,
        Latchesar Ionkov <lucho@ionkov.net>,
        Marc Dionne <marc.dionne@auristor.com>,
        Matthew Wilcox <willy@infradead.org>,
        Omar Sandoval <osandov@osandov.com>,
        Shyam Prasad N <nspmangalore@gmail.com>,
        Steve French <sfrench@samba.org>,
        Trond Myklebust <trondmy@hammerspace.com>,
        Peter Zijlstra <peterz@infradead.org>,
        ceph-devel@vger.kernel.org, linux-afs@lists.infradead.org,
        linux-cachefs@redhat.com, CIFS <linux-cifs@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linux-MM <linux-mm@kvack.org>,
        "open list:NFS, SUNRPC, AND..." <linux-nfs@vger.kernel.org>,
        v9fs-developer@lists.sourceforge.net,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Mon, Jan 17, 2022 at 11:57 AM David Howells <dhowells@redhat.com> wrote:
>
> Do you have an opinion on whether it's permissible for a filesystem to write
> into the read() buffer beyond the amount it claims to return, though still
> within the specified size of the buffer?

I'm pretty sure that would seriously violate POSIX in the general
case, and maybe even break some programs that do fancy buffer
management (ie I could imagine some circular buffer thing that expects
any "unwritten" ('unread'?) parts to stay with the old contents)

That said, that's for generic 'read()' cases for things like tty's or
pipes etc that can return partial reads in the first place.

If it's a regular file, then any partial read *already* violates
POSIX, and nobody sane would do any such buffer management because
it's supposed to be a 'can't happen' thing.

And since you mention DIO, that's doubly true, and is already outside
basic POSIX, and has already violated things like "all or nothing"
rules for visibility of writes-vs-reads (which admittedly most Linux
filesystems have violated even outside of DIO, since the strictest
reading of the rules are incredibly nasty anyway). But filesystems
like XFS which took some of the strict rules more seriously already
ignored them for DIO, afaik.

So I suspect you're fine. Buffered reads might care more, but even
there the whole "you can't really validly have partial reads anyway"
thing is a bigger violation to begin with.

With DIO, I suspect nobody cares about _those_ kinds of semantic
details. People who use DIO tend to care primarily about performance -
it's why they use it, after all - and are probably more than happy to
be lax about other rules.

But maybe somebody would prefer to have a mount option to specify just
how out-of-spec things can be (ie like the traditional old nfs 'intr'
thing). If only for testing, and for 'in case some odd app breaks'

                Linus
