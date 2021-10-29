Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B44A14401C4
	for <lists+ceph-devel@lfdr.de>; Fri, 29 Oct 2021 20:18:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229968AbhJ2SUt (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 29 Oct 2021 14:20:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229826AbhJ2SUs (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Fri, 29 Oct 2021 14:20:48 -0400
Received: from mail-lj1-x22b.google.com (mail-lj1-x22b.google.com [IPv6:2a00:1450:4864:20::22b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F9AFC061714
        for <ceph-devel@vger.kernel.org>; Fri, 29 Oct 2021 11:18:19 -0700 (PDT)
Received: by mail-lj1-x22b.google.com with SMTP id q16so18227755ljg.3
        for <ceph-devel@vger.kernel.org>; Fri, 29 Oct 2021 11:18:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=YR8MaXQV2dAoTf7veoG8XVBeAhgdgomPxezXzaQONmo=;
        b=HVDkvGeodIU22X5kjbO7ZR0lTCWWwkScN+820L1CO6Jp/wFHT2URTkNHboM7IjptmB
         YVg/RfMSjgzCpZAxQHFmCUZlYnl5lVQQW/xElvUR6baO9Q4c6uG+lfqCGqGH4kKGh1KE
         qArq9uCu2p9WrvPFJV+b6G0oeDLEt/s/4EqMQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=YR8MaXQV2dAoTf7veoG8XVBeAhgdgomPxezXzaQONmo=;
        b=M8jyOS/bxmhBb7itvu8Xe22PLaELp/lky/1GaXlyaqEsn3B2ow2ocNFBybm/l6xN3b
         IqUEvE2n5NWrz+ZoOaGUeDdQu08tqumD14empnFJTQS1xjYVktZhpchc539MPIOgMSlw
         uiEMV/YMhQRMbvSvI2Z/ovFiV1NQEDSuPXO2818Z8iMbpfN7XW+L29EWaILBnaoyrvGV
         G8lx08u6ELGIC+lQLTvCLvjlUTi+7tlBQ6UrkiAihzKpkaJTG6wCzfvrBBAxHR7N/gSs
         GNa1yZo6H0KLBwj3NwPsVdplCFKINSTel+hAkLUc6luGJj2ssFZdeYyZW9Cvw0xuFnLW
         jWPg==
X-Gm-Message-State: AOAM532zXGWl720lAMjXaKVlAT48wR/inkdms3pU6C/RpzU/UUw28PwG
        fjQeNaQf8ykouCuaDdNwldOrBhOnD46E2sMUwZo=
X-Google-Smtp-Source: ABdhPJzqLTMpHuEEbJslXvcI7aVuhesZl3f7oYr9gxRrPynl3BLBi3Dv6V1qlWF9uqQTJ1EEQm5Oag==
X-Received: by 2002:a2e:584:: with SMTP id 126mr12675278ljf.30.1635531497258;
        Fri, 29 Oct 2021 11:18:17 -0700 (PDT)
Received: from mail-lj1-f172.google.com (mail-lj1-f172.google.com. [209.85.208.172])
        by smtp.gmail.com with ESMTPSA id k34sm666471lfv.228.2021.10.29.11.18.15
        for <ceph-devel@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 29 Oct 2021 11:18:16 -0700 (PDT)
Received: by mail-lj1-f172.google.com with SMTP id 205so18156678ljf.9
        for <ceph-devel@vger.kernel.org>; Fri, 29 Oct 2021 11:18:15 -0700 (PDT)
X-Received: by 2002:a05:651c:17a6:: with SMTP id bn38mr12949536ljb.56.1635531495482;
 Fri, 29 Oct 2021 11:18:15 -0700 (PDT)
MIME-Version: 1.0
References: <163551653404.1877519.12363794970541005441.stgit@warthog.procyon.org.uk>
 <CAHk-=wiy4KNREEqvd10Ku8VVSY1Lb=fxTA1TzGmqnLaHM3gdTg@mail.gmail.com> <1889041.1635530124@warthog.procyon.org.uk>
In-Reply-To: <1889041.1635530124@warthog.procyon.org.uk>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Fri, 29 Oct 2021 11:17:59 -0700
X-Gmail-Original-Message-ID: <CAHk-=wg_C6V_S+Aox5Fn7MuFe13ADiRVnh6UcvY4WX9JjXn3dg@mail.gmail.com>
Message-ID: <CAHk-=wg_C6V_S+Aox5Fn7MuFe13ADiRVnh6UcvY4WX9JjXn3dg@mail.gmail.com>
Subject: Re: [PATCH v4 00/10] fscache: Replace and remove old I/O API
To:     David Howells <dhowells@redhat.com>
Cc:     Trond Myklebust <trondmy@hammerspace.com>,
        Anna Schumaker <anna.schumaker@netapp.com>,
        Steve French <sfrench@samba.org>,
        Dominique Martinet <asmadeus@codewreck.org>,
        v9fs-developer@lists.sourceforge.net,
        CIFS <linux-cifs@vger.kernel.org>,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        "open list:NFS, SUNRPC, AND..." <linux-nfs@vger.kernel.org>,
        linux-cachefs@redhat.com, Dave Wysochanski <dwysocha@redhat.com>,
        Shyam Prasad N <nspmangalore@gmail.com>,
        Jeff Layton <jlayton@redhat.com>,
        Matthew Wilcox <willy@infradead.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-afs@lists.infradead.org, ceph-devel@vger.kernel.org,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Fri, Oct 29, 2021 at 10:55 AM David Howells <dhowells@redhat.com> wrote:
>
> This means bisection is of limited value and why I'm looking at a 'flag day'.

So I'm kind of resigned to that by now, I just wanted to again clarify
that the rest of my comments are about "if we have to deal with a flag
dat anyway, then make it as simple and straightforward as possible,
rather than adding extra steps that are only noise".

> [ Snip explanation of netfslib ]
> This particular patchset is intended to enable removal of the old I/O routines
> by changing nfs and cifs to use a "fallback" method to use the new kiocb-using
> API and thus allow me to get on with the rest of it.

Ok, at least that explains that part.

But:

> However, if you would rather I just removed all of fscache and (most of[*])
> cachefiles, that I can do.

I assume and think that if you just do that part first, then the
"convert to netfslib" of afs and ceph at that later stage will mean
that the fallback code will never be needed?

So I would much prefer that streamlined model over one that adds that
temporary intermediate stage only for it to be deleted.

             Linus
