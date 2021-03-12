Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A394B33982A
	for <lists+ceph-devel@lfdr.de>; Fri, 12 Mar 2021 21:25:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234752AbhCLUZB (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 12 Mar 2021 15:25:01 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:22374 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234644AbhCLUYk (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Fri, 12 Mar 2021 15:24:40 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1615580680;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=qbesPmkJY0xMYH0D5ogvQHLVFBlINgpiWsxVN++CylE=;
        b=SzmUNuthRK7aIboO/RfPDVkl2qH6ifSeOAQQe49OZ9LrwW6Q1IvSJueKSOLMXo4XxZ1hrg
        xIAQz64gDIbW65hBNCOXOaxDMVkjFmblKJbfO8NiU7mwmotrD0Ov7GO0j4pBBYcqgYS1gJ
        b48cD0KdPgpiy8kZoxV8Vqi2ruR/E4w=
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com
 [209.85.160.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-294-Cd__fRMsOOu1UVUfsPNsJA-1; Fri, 12 Mar 2021 15:24:26 -0500
X-MC-Unique: Cd__fRMsOOu1UVUfsPNsJA-1
Received: by mail-qt1-f200.google.com with SMTP id w2so12884989qts.18
        for <ceph-devel@vger.kernel.org>; Fri, 12 Mar 2021 12:24:26 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=qbesPmkJY0xMYH0D5ogvQHLVFBlINgpiWsxVN++CylE=;
        b=goo0avgyka/id7Vj6xsX9fEh2POX4rZvAL+X8QoQtmz1OESkPLnMxPFM2OFd7haYqA
         maCzBhoPM8usqBYt7VsnV/JPzAsVKprw6/diQHowjEobQoJyr2q4kHsS1yfmOrk6MZs0
         3Mr+t4MJiJYw5YqLnsrHIeoJiy70JoIXj4DkzOJCAMMfRTRs7wA9vIUne2NMnv4gvBJh
         dAUFMRLrBZEoUpaXbA7W6Hu6nFRr1we6hnQDEB0syuq6qFZXB3x6d1hhA+Rwner50cWX
         CZFpmRLYk6t7AJpJkuI6ho1qgq71zxmQL9GHQhXzstQKIc7BvskZuzkAkWvEf2lXMSNw
         3EIw==
X-Gm-Message-State: AOAM533m+/ll8R3WHMlgYDFuaAioVbhnntiwzyl9WUTDcEU/QOw6cVi6
        2B7SIF4GlITHb+/U/BeLQ0dj9XAXQ9IOySh2kiRMSwy/wan3qTktI/UYOZkCqHRw0mIXC+1XKXW
        6KPDP27fw7KM5tJ/L+Fzymw==
X-Received: by 2002:ad4:4732:: with SMTP id l18mr107083qvz.6.1615580665812;
        Fri, 12 Mar 2021 12:24:25 -0800 (PST)
X-Google-Smtp-Source: ABdhPJy64oFkvva4BAChQhvJP0p+vGP3lCvJZA4FlveCUoxzUl7KDuWpc74vYacl2Y2dGyUJXeybPg==
X-Received: by 2002:ad4:4732:: with SMTP id l18mr107070qvz.6.1615580665559;
        Fri, 12 Mar 2021 12:24:25 -0800 (PST)
Received: from tleilax.poochiereds.net (68-20-15-154.lightspeed.rlghnc.sbcglobal.net. [68.20.15.154])
        by smtp.gmail.com with ESMTPSA id q65sm5049333qkb.51.2021.03.12.12.24.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Mar 2021 12:24:25 -0800 (PST)
Message-ID: <ba57992848772901cd04d56ab0530360d2b9423c.camel@redhat.com>
Subject: Re: fscrypt and file truncation on cephfs
From:   Jeff Layton <jlayton@redhat.com>
To:     Gregory Farnum <gfarnum@redhat.com>
Cc:     Patrick Donnelly <pdonnell@redhat.com>, dev <dev@ceph.io>,
        "open list:CEPH DISTRIBUTED..." <ceph-devel@vger.kernel.org>
Date:   Fri, 12 Mar 2021 15:24:24 -0500
In-Reply-To: <CAJ4mKGZ2vC7AcmR2BKR30ZuipLNC4GB-3gpS4K1zfeEHH4fwbQ@mail.gmail.com>
References: <10fa59845ccb872620cc91d8ec7378302cb44cda.camel@redhat.com>
         <CA+2bHPYg059gP7KeW=J35q_=afYZW0m-kepWskLK-9z24AFxMg@mail.gmail.com>
         <CAJ4mKGaaSn67XRkBemJC0XAWBTyWN_VjgEJfT8EB1cLaokAYvQ@mail.gmail.com>
         <c2dbc391fead002c84c07860812b689a01d2b667.camel@redhat.com>
         <CAJ4mKGZ2vC7AcmR2BKR30ZuipLNC4GB-3gpS4K1zfeEHH4fwbQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.4 (3.38.4-1.fc33) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Fri, 2021-03-12 at 11:45 -0800, Gregory Farnum wrote:
> On Fri, Mar 12, 2021 at 4:49 AM Jeff Layton <jlayton@redhat.com> wrote:
> > 
> > On Fri, 2021-03-12 at 00:43 -0800, Gregory Farnum wrote:
> 
> > > ...although in my current sleep-addled state, I'm actually not sure we
> > > need to add any permanent storage to the MDS to handle this case! We
> > > can probably just extend the front-end truncate op so that it can take
> > > a separate "real-truncate-size" and the logical file size, can't we?
> > 
> > That would be one nice thing about the approach of #1. Truncating the
> > size downward is always done via an explicit SETATTR op (I think), so we
> > could just extend that with a new field for that tells the MDS where to
> > stop truncating.
> > 
> > Note that regardless of the approach we choose, the client will still
> > need to do a read/modify/write on the edge block before we can really
> > treat the truncation as "done". I'm not yet sure whether that has any
> > bearing on the consistency/safety of the truncation process.
> 
> Wait what? Let's talk more about that: I can't emphasize enough how
> much you really, *really* don't want to require clients to do a RMW to
> RADOS that is coordinated with MDS state changes that may modify the
> same objects.
> 
> Isn't it enough for:
> 1) truncate op sets file size to new logical size, and truncate_size
> to end of crypto block
> 2) clients do rados reads until the end of the crypto block and throw
> away the data past the logical end-of-file when serving IO
> 3) clients can remove the old data on a write when they feel like it
> and then set truncate_size to the real file size
> 
> The only tricky bit there is making sure the MDS respects the
> truncate_size everywhere it needs to, and doesn't inadvertently force
> it down to the file size when we don't want that happening.
>

That sounds like it would work. I'll probably take something like that
approach.

In principle, the MDS really should not care about the logical size of
the file at all. All it needs to know is how big the actual backing
objects are, and that will always be rounded up to the next crypto
block.

So, I'm sort of a fan of the idea of having a "private" size field that
only the clients with valid the crypto keys use. Everything else would
just report (and deal with) the rounded-up size. So, the clients would
always set the current inode size field to the rounded-up size, and then
maintain the actual logical file size in their private field.

This has the advantage that we don't need to tinker with the MDS
mechanics so much -- only extend the inode with the new field (which
sucks, but is a reasonably mechanical change).

This also dovetails nicely with having the client "lazily" zero-pad the
EOF block after resetting the size.

> I do foresee one leak, which is how we handle probing for file size
> when a client with write caps disappears[2], but that's going to be
> the case no matter what solution we come up with unless we're willing
> to tolerate a two-phase commit. Which would be *awful*[1].
> -Greg
> 
> [1]: We're talking about needing to send a crypto-truncate to the MDS,
> have it withdraw all client caps, return a new "start your phase"
> message/state which grants read and write caps to the truncating
> client (which I have no idea how we'd do while a logical MDS write is
> happening), have the client do the RMW on the tail object and return
> its caps, commit the new file size, and then return the final op and
> re-issue caps — and handle cleaning up if the client fails at any
> point in that process. I guess if we did manage to jump through all
> those hoops, client failure recovery would be deterministic and
> accurate based on if the final object size was larger than or equal to
> the attempted new size...

How does this probing work today?

> [2]: And now that I think about the implications of crypto some more,
> we can even fix this. Since crypto clients can never do rados append
> ops (and I don't think we can in the FS *anyway*?) we can just have
> all crypto-client writes include setting a "logical size" xattr on the
> rados object that the MDS can use when probing. We maybe should do
> that for everything, actually...
> 

That does sound like a good idea, and it wouldn't be too difficult to
implement since we're already going to be moving to doing more multi-op
OSD write calls anyway.

-- 
Jeff Layton <jlayton@redhat.com>

