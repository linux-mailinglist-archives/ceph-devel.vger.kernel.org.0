Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 417A83E1A57
	for <lists+ceph-devel@lfdr.de>; Thu,  5 Aug 2021 19:27:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239923AbhHER1m (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 5 Aug 2021 13:27:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230004AbhHER1l (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 5 Aug 2021 13:27:41 -0400
Received: from mail-lf1-x134.google.com (mail-lf1-x134.google.com [IPv6:2a00:1450:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF9CFC061765
        for <ceph-devel@vger.kernel.org>; Thu,  5 Aug 2021 10:27:25 -0700 (PDT)
Received: by mail-lf1-x134.google.com with SMTP id c24so9280973lfi.11
        for <ceph-devel@vger.kernel.org>; Thu, 05 Aug 2021 10:27:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=kSMSzayyNT2YehjLQ2Cwc0r8HqyEvjniy8Pw7lCSffg=;
        b=CjeV+4n++fBbfbgUnSajYHMZzSgIGQ/AzXROF+Y4CaB/aORGEHsRe4pUpEJVdYpwfB
         NmAZXoNyQn6JPxdWXpyZnM00VCUOuYnkUNerNg1Ng90I+xulwoWK81gZiomswCGM8sp6
         nIAp7+gezxOviLaRF+m3bsJwsaKOi0OIDRvRA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=kSMSzayyNT2YehjLQ2Cwc0r8HqyEvjniy8Pw7lCSffg=;
        b=BTKmocIkU04QtB1AvIJVnknWsJRJbpwcA1DzbIrBI4REMP4Cw3n+V9hMmB7P5Eb+KV
         7h76iAITUKoYz5g7QdahkBtKbYSEkJzbb9WIjvHgWP2TQkc0leTl+ATnMSOc0Ere2f82
         YJETW2CTtu3zyILOpGjXHjpIK0XQYIGTW0BM5BBAUChTdWh+NMe+Us6/njAi9TEkkePP
         jW6Trt9Ogy2gj2tbyvP7PS9feq2Da5MUWzhyJlf1bJcH90Itwx1HNL5r+F3lhpcGcYyn
         E/O8GtrC+zOhz4B5ZR0CaYoT1tYQknzW2ogYmfYHdTyFip2VhIqjl5zkvRMieCZGgTqV
         0v4g==
X-Gm-Message-State: AOAM531O0RyMCGKXeLYfeoXbVTPziZKM67fRZusJl2rhXcxFNyTw6kQ3
        8NWaN6aKboAANoSdIc7e4u5FeosbYuQl/B3CS/4=
X-Google-Smtp-Source: ABdhPJxyZ2yPGhxcidsez1YXbFk08NZbnDdfzluTg/sL/589hxUdC56cPRH5G0M2sR0VMBOys21lJg==
X-Received: by 2002:a05:6512:239e:: with SMTP id c30mr2516959lfv.417.1628184443984;
        Thu, 05 Aug 2021 10:27:23 -0700 (PDT)
Received: from mail-lf1-f44.google.com (mail-lf1-f44.google.com. [209.85.167.44])
        by smtp.gmail.com with ESMTPSA id v19sm573306lfg.134.2021.08.05.10.27.21
        for <ceph-devel@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 05 Aug 2021 10:27:22 -0700 (PDT)
Received: by mail-lf1-f44.google.com with SMTP id c16so12611786lfc.2
        for <ceph-devel@vger.kernel.org>; Thu, 05 Aug 2021 10:27:21 -0700 (PDT)
X-Received: by 2002:a05:6512:2388:: with SMTP id c8mr4369071lfv.201.1628184441363;
 Thu, 05 Aug 2021 10:27:21 -0700 (PDT)
MIME-Version: 1.0
References: <YQv+iwmhhZJ+/ndc@casper.infradead.org> <YQvpDP/tdkG4MMGs@casper.infradead.org>
 <YQvbiCubotHz6cN7@casper.infradead.org> <1017390.1628158757@warthog.procyon.org.uk>
 <1170464.1628168823@warthog.procyon.org.uk> <1186271.1628174281@warthog.procyon.org.uk>
 <1219713.1628181333@warthog.procyon.org.uk>
In-Reply-To: <1219713.1628181333@warthog.procyon.org.uk>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Thu, 5 Aug 2021 10:27:05 -0700
X-Gmail-Original-Message-ID: <CAHk-=wjyEk9EuYgE3nBnRCRd_AmRYVOGACEjt0X33QnORd5-ig@mail.gmail.com>
Message-ID: <CAHk-=wjyEk9EuYgE3nBnRCRd_AmRYVOGACEjt0X33QnORd5-ig@mail.gmail.com>
Subject: Re: Canvassing for network filesystem write size vs page size
To:     David Howells <dhowells@redhat.com>
Cc:     Anna Schumaker <anna.schumaker@netapp.com>,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Jeff Layton <jlayton@redhat.com>,
        Steve French <sfrench@samba.org>,
        Dominique Martinet <asmadeus@codewreck.org>,
        Mike Marshall <hubcap@omnibond.com>,
        Miklos Szeredi <miklos@szeredi.hu>,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Shyam Prasad N <nspmangalore@gmail.com>,
        linux-cachefs@redhat.com, linux-afs@lists.infradead.org,
        "open list:NFS, SUNRPC, AND..." <linux-nfs@vger.kernel.org>,
        CIFS <linux-cifs@vger.kernel.org>, ceph-devel@vger.kernel.org,
        v9fs-developer@lists.sourceforge.net, devel@lists.orangefs.org,
        Linux-MM <linux-mm@kvack.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Thu, Aug 5, 2021 at 9:36 AM David Howells <dhowells@redhat.com> wrote:
>
> Some network filesystems, however, currently keep track of which byte ranges
> are modified within a dirty page (AFS does; NFS seems to also) and only write
> out the modified data.

NFS definitely does. I haven't used NFS in two decades, but I worked
on some of the code (read: I made nfs use the page cache both for
reading and writing) back in my Transmeta days, because NFSv2 was the
default filesystem setup back then.

See fs/nfs/write.c, although I have to admit that I don't recognize
that code any more.

It's fairly important to be able to do streaming writes without having
to read the old contents for some loads. And read-modify-write cycles
are death for performance, so you really want to coalesce writes until
you have the whole page.

That said, I suspect it's also *very* filesystem-specific, to the
point where it might not be worth trying to do in some generic manner.

In particular, NFS had things like interesting credential issues, so
if you have multiple concurrent writers that used different 'struct
file *' to write to the file, you can't just mix the writes. You have
to sync the writes from one writer before you start the writes for the
next one, because one might succeed and the other not.

So you can't just treat it as some random "page cache with dirty byte
extents". You really have to be careful about credentials, timeouts,
etc, and the pending writes have to keep a fair amount of state
around.

At least that was the case two decades ago.

[ goes off and looks. See "nfs_write_begin()" and friends in
fs/nfs/file.c for some of the examples of these things, althjough it
looks like the code is less aggressive about avoding the
read-modify-write case than I thought I remembered, and only does it
for write-only opens ]

               Linus

            Linus
