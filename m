Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 26B92636B47
	for <lists+ceph-devel@lfdr.de>; Wed, 23 Nov 2022 21:35:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235849AbiKWUf1 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 23 Nov 2022 15:35:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239305AbiKWUfI (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 23 Nov 2022 15:35:08 -0500
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7726D2F69
        for <ceph-devel@vger.kernel.org>; Wed, 23 Nov 2022 12:32:17 -0800 (PST)
Received: by mail-pj1-x1034.google.com with SMTP id mv18so9146819pjb.0
        for <ceph-devel@vger.kernel.org>; Wed, 23 Nov 2022 12:32:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=CqmvkkESPfhDMe/qDmW4BJUOiTicPIv5an9zs8Gyv18=;
        b=H05YjYlWatbzx/wYDWLZlWtlE1KBwjnnlgWrAS57YeODNFQbfnbqnkGjrw+7lnDaor
         oScBBYPzE4yA/do2o0oXxJV/7PAgcLDU8MGXopXi7Hyz2CY8RYXjIOxuZIHXCxSyrV4d
         4jeZ+ngrXKdb0oQJMIfkShcljtHyJ8LXyw7yk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=CqmvkkESPfhDMe/qDmW4BJUOiTicPIv5an9zs8Gyv18=;
        b=iDZb25FlDAqMGfGTn/kQbT2y+UrgB8zy0ycgG35x0Q+W7GSHJI/Z/GELe1GhliLDLO
         b8Tv2rI1HSyUBrF3aVt7tlnslU3WoLrcVhR+iFgyIFavYdeGDd8uKLG3hOAUZsB62J/q
         yWgVP5cgv5YuN1R8O2mgcsTg8cHGiDgG1SSi6aOrxHsIj8bDkLIVILNgiaugZ+Y1vmB3
         rzWDtS3Jm9efdC1OKpHKd4KLXCfkTYHNVYL2rezEFIOytWlMrBHJCaLPNgaGURT+tYR7
         zpM4XDzZ+GHBkLLc/C/pa6ShPu0LuPx/XqF8aW3adLIDI5zhIm/1stscVawZGzRxftkU
         GHPA==
X-Gm-Message-State: ANoB5pnzFEtNyYv7rUX27w9HPn7dHOwzje0C59mTxkiMQujAaYodQ/hq
        PITsycrXzH3kO9EkFZHrZiGcVfIrghkANQ==
X-Google-Smtp-Source: AA0mqf52X2xfSyBQIOiQAqyJquxAoq7liJq3PiCxAZfItMquOpx2JaprOj7BClAx4AfAoqhHX/5hNw==
X-Received: by 2002:a17:902:ec8a:b0:188:640f:f400 with SMTP id x10-20020a170902ec8a00b00188640ff400mr12332020plg.143.1669235536623;
        Wed, 23 Nov 2022 12:32:16 -0800 (PST)
Received: from mail-pg1-f173.google.com (mail-pg1-f173.google.com. [209.85.215.173])
        by smtp.gmail.com with ESMTPSA id b15-20020a170902d50f00b0018863e1bd3csm14751869plg.134.2022.11.23.12.32.16
        for <ceph-devel@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 23 Nov 2022 12:32:16 -0800 (PST)
Received: by mail-pg1-f173.google.com with SMTP id 62so17665462pgb.13
        for <ceph-devel@vger.kernel.org>; Wed, 23 Nov 2022 12:32:16 -0800 (PST)
X-Received: by 2002:ad4:4101:0:b0:4b1:856b:4277 with SMTP id
 i1-20020ad44101000000b004b1856b4277mr10112261qvp.129.1669235172559; Wed, 23
 Nov 2022 12:26:12 -0800 (PST)
MIME-Version: 1.0
References: <1459152.1669208550@warthog.procyon.org.uk> <CAHk-=wghJtq-952e_8jd=vtV68y_HsDJ8=e0=C3-AsU2WL-8YA@mail.gmail.com>
 <1619343.1669233783@warthog.procyon.org.uk>
In-Reply-To: <1619343.1669233783@warthog.procyon.org.uk>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Wed, 23 Nov 2022 12:25:56 -0800
X-Gmail-Original-Message-ID: <CAHk-=whJBOAOqB8wWxeAtKy3b9r4rn2Y48+zsuDDhKJ3D3D4cw@mail.gmail.com>
Message-ID: <CAHk-=whJBOAOqB8wWxeAtKy3b9r4rn2Y48+zsuDDhKJ3D3D4cw@mail.gmail.com>
Subject: Re: [PATCH v3] mm, netfs, fscache: Stop read optimisation when folio
 removed from pagecache
To:     David Howells <dhowells@redhat.com>
Cc:     willy@infradead.org, dwysocha@redhat.com,
        Rohith Surabattula <rohiths.msft@gmail.com>,
        Steve French <sfrench@samba.org>,
        Shyam Prasad N <nspmangalore@gmail.com>,
        Dominique Martinet <asmadeus@codewreck.org>,
        Ilya Dryomov <idryomov@gmail.com>, linux-cachefs@redhat.com,
        linux-cifs@vger.kernel.org, linux-afs@lists.infradead.org,
        v9fs-developer@lists.sourceforge.net, ceph-devel@vger.kernel.org,
        linux-nfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
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

On Wed, Nov 23, 2022 at 12:03 PM David Howells <dhowells@redhat.com> wrote:
>
> Linus Torvalds <torvalds@linux-foundation.org> wrote:
>
> > But I also think it's strange in another way, with that odd placement of
> >
> >         mapping_clear_release_always(inode->i_mapping);
> >
> > at inode eviction time. That just feels very random.
>
> I was under the impression that a warning got splashed if unexpected
> address_space flags were set when ->evict_inode() returned.  I may be thinking
> of page flags.  If it doesn't, fine, this isn't required.

I don't know if the warning happens or not, but the thing I reacted to
was just how *random* this was. There was no logic to it, nor any
explanation.

I *suspect* that if we add this kind of new generic address space
flag, then that flag should just be cleared by generic code when the
address space is released.

But I'm not saying it has to be done that way - I'm just saying that
however it is done, please don't make it this random mess with no
explanation.

The *setting* of the flag was at least fairly obvious. I didn't find
code like this odd:

+       if (v9inode->netfs.cache)
+               mapping_set_release_always(inode->i_mapping);

and it makes all kinds of sense (ie I can read it as a "if I use netfs
caching for this inode, then I want to be informed when a folio is
released from this mapping").

It's just the clearing that looked very random to me.

Maybe just a comment would have helped, but I get the feeling that it
migth as well just be cleared in "clear_inode()" or something like
that.

> > That code makes no sense what-so-ever. Why isn't it using
> > "folio_has_private()"?
>
> It should be, yes.
>
> > Why is this done as an open-coded - and *badly* so - version of
> > !folio_needs_release() that you for some reason made private to mm/vmscan.c?
>
> Yeah, in retrospect, I should have put that in mm/internal.h.

So if folio_needs_release() is in mm/internal.h, and then mm/filemap.c
uses it in filemap_release_folio() instead of the odd open-coding, I
think that would clear up my worries about both mm/filemap.c and
mm/vmscan.c.

                Linus
