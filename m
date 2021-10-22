Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9BFD9437EF2
	for <lists+ceph-devel@lfdr.de>; Fri, 22 Oct 2021 21:58:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234042AbhJVUBG (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 22 Oct 2021 16:01:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232291AbhJVUBF (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Fri, 22 Oct 2021 16:01:05 -0400
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B94AFC061764
        for <ceph-devel@vger.kernel.org>; Fri, 22 Oct 2021 12:58:47 -0700 (PDT)
Received: by mail-ed1-x52b.google.com with SMTP id z20so6293946edc.13
        for <ceph-devel@vger.kernel.org>; Fri, 22 Oct 2021 12:58:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=OyTESXkijXq7pnJGTLADUG+9VskuYUOHv78z9I+1K/4=;
        b=hM/XQhqnuwClqFHl0xmMUwVFiZI2zWX0Fsvmyov2HtrZf+eht/rZgRbn7tgV6JR5/t
         oaUf+A7xemNq2BqlSo7CgdMlfz4uNIfFdFMMG/GRhS1ONKFBhEIzCT11CSLKS+TAVP9U
         qBUMJuZF6FSADRHZc19vWgXXWGONFvtcXh0sM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=OyTESXkijXq7pnJGTLADUG+9VskuYUOHv78z9I+1K/4=;
        b=XzGC8lc6WcSaZv/r0slpXhUyZa05hJQy6MSITPqVSAeAfdzTGtBTeOu38tKWESSqgK
         40+3id3trCJovUQX85oBkT/Gq40ZSLJqE96ywBnZZLWSxr5t84C2IoheO15u0h3ARNTv
         YVPQkxKvXQk3YnSCI7XpRJprLSMUaIhEuQFuYssM1j3pMP4cD+BqRjqRPlkLAWj7cWG6
         tjbRnv7H8dhOziTmj88vgFXdMjYaX/DBoRtvCZVaySge+fiNl60sBv0Pxk5ZcLRHFszb
         SmPqN2fSzhJood32WD3VQ2pKLQHIefyVuRHtwesFsSONp+I44s4N1iJWR1I9EPLe0N/y
         0etg==
X-Gm-Message-State: AOAM533zj6YTVIEh3t+HlT4MKhJqyonQJPLFUERe7+6RtycNUDqeEKGX
        BFmzaaYaxheB+OJqQz5F03xl3B94WeBXDuka0rI=
X-Google-Smtp-Source: ABdhPJyEOa8v2U0lRF6vdQBqA/XxY1DyePxetddA3nRWtd2fvw4BTo8NdOsXs0fgED44Pu8dGzlvAg==
X-Received: by 2002:a17:907:a413:: with SMTP id sg19mr1989832ejc.241.1634932724507;
        Fri, 22 Oct 2021 12:58:44 -0700 (PDT)
Received: from mail-wr1-f51.google.com (mail-wr1-f51.google.com. [209.85.221.51])
        by smtp.gmail.com with ESMTPSA id 90sm4962464edk.44.2021.10.22.12.58.38
        for <ceph-devel@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 22 Oct 2021 12:58:41 -0700 (PDT)
Received: by mail-wr1-f51.google.com with SMTP id m22so5835238wrb.0
        for <ceph-devel@vger.kernel.org>; Fri, 22 Oct 2021 12:58:38 -0700 (PDT)
X-Received: by 2002:a2e:5cc7:: with SMTP id q190mr2066391ljb.494.1634932708154;
 Fri, 22 Oct 2021 12:58:28 -0700 (PDT)
MIME-Version: 1.0
References: <163492911924.1038219.13107463173777870713.stgit@warthog.procyon.org.uk>
 <CAHk-=wjmx7+PD0hzWj5Bg2b807xYD2KCZApTvFje=ufo+MxBMQ@mail.gmail.com> <1041557.1634931616@warthog.procyon.org.uk>
In-Reply-To: <1041557.1634931616@warthog.procyon.org.uk>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Fri, 22 Oct 2021 09:58:12 -1000
X-Gmail-Original-Message-ID: <CAHk-=wg2LQtWC3e4Z4EGQzEmsLjmk6jm67Ga6UMLY1MH6iDcNQ@mail.gmail.com>
Message-ID: <CAHk-=wg2LQtWC3e4Z4EGQzEmsLjmk6jm67Ga6UMLY1MH6iDcNQ@mail.gmail.com>
Subject: Re: [PATCH v2 00/53] fscache: Rewrite index API and management system
To:     David Howells <dhowells@redhat.com>
Cc:     linux-cachefs@redhat.com, linux-afs@lists.infradead.org,
        Marc Dionne <marc.dionne@auristor.com>,
        Eric Van Hensbergen <ericvh@gmail.com>,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Dave Wysochanski <dwysocha@redhat.com>,
        CIFS <linux-cifs@vger.kernel.org>,
        Dominique Martinet <asmadeus@codewreck.org>,
        Steve French <sfrench@samba.org>,
        Shyam Prasad N <nspmangalore@gmail.com>,
        Jeff Layton <jlayton@kernel.org>,
        Anna Schumaker <anna.schumaker@netapp.com>,
        "open list:NFS, SUNRPC, AND..." <linux-nfs@vger.kernel.org>,
        Latchesar Ionkov <lucho@ionkov.net>,
        v9fs-developer@lists.sourceforge.net,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Trond Myklebust <trondmy@hammerspace.com>,
        Jeff Layton <jlayton@kernel.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Omar Sandoval <osandov@osandov.com>,
        ceph-devel@vger.kernel.org,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Fri, Oct 22, 2021 at 9:40 AM David Howells <dhowells@redhat.com> wrote:
>
> What's the best way to do this?  Is it fine to disable caching in all the
> network filesystems and then directly remove the fscache and cachefiles
> drivers and replace them?

So the basic issue with this whole "total rewrite" is that there's no
way to bisect anything.

And there's no way for people to say "I don't trust the rewrite, I
want to keep using the old tested model".

Which makes this all painful and generally the wrong way to do
anything like this, and there's fundamentally no "best way".

The real best way would be if the conversion could be done truly
incrementally. Flag-days simply aren't good for development, because
even if the patch to enable the new code might be some trivial
one-liner, that doesn't _help_ anything. The switch-over switches from
one code-base to another, with no help from "this is where the problem
started".

So in order of preference:

 (a) actual incremental changes where the code keeps working all the
time, and no flag days

 (b) same interfaces, so at least you can do A/B testing and people
can choose one or the other

 (c) total rewrite

and if (c) is the thing that all the network filesystem people want,
then what the heck is the point in keeping dead code around? At that
point, all the rename crap is just extra work, extra noise, and only a
distraction. There's no upside that I can see.

                   Linus
