Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6D5B339A04
	for <lists+ceph-devel@lfdr.de>; Sat, 13 Mar 2021 00:37:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235853AbhCLXhK (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 12 Mar 2021 18:37:10 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:48627 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235848AbhCLXhH (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Fri, 12 Mar 2021 18:37:07 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1615592226;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=QtPQRWT27EdZHkHv3f89q6c2FCPfvcdsQI65GHgU+8k=;
        b=QIjxUBNRKwazOWHWvyDUueYKqygUSsQsOiL3v4JQH68Uj5RBzje+9YGod+zr6gSh6I64+2
        fsiLb9qp/jH1+YIqQKPryitNKbtYvPPenhTjhJBYbTvbVBdVVZ+jXw6egykKyf3t2N3dLo
        v4m1Xxj8YcdX8gklwQM1E57UN47N8dY=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-175-q1InLZnFMcKRaLcpUakffA-1; Fri, 12 Mar 2021 18:37:04 -0500
X-MC-Unique: q1InLZnFMcKRaLcpUakffA-1
Received: by mail-qk1-f200.google.com with SMTP id b127so17508316qkf.19
        for <ceph-devel@vger.kernel.org>; Fri, 12 Mar 2021 15:37:04 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=QtPQRWT27EdZHkHv3f89q6c2FCPfvcdsQI65GHgU+8k=;
        b=nSK7SGCVdYnmb4LqqjcWgvYzZuC7HCgwFvUfU5w9p3p5F7G+FfhxmmJZmeTeTglWBN
         veXwTc83GgR56IiiKQLElIuB3BIaKBD4LLqDdQbXzA706hJcJvsTv82zOlEyuLSzOuPq
         K/BJQ2yrZofWuXeiftHMYV4KAhwAVdigwoFBB2sNvRzpFje5ldWKWf5iVo+YW3+WqtoA
         bAnNdBMYgtMPMi0O1NtMc0GBq7BRqa9t6FpHO1Q54gbMd0PHzbIy/9owTL7WovD0qYvz
         XFYzyzhkFh5STpy7Td1AboufczUU5TT8xZZtKnQ2nhTFjSUDI8p4MVB3aZs81l3SMvSr
         F4vg==
X-Gm-Message-State: AOAM532ayoZxfKgxJ+FXeLHqu+MwGvhUtVmUtQi8NM9XvVsghEkf0Jlv
        9k0bhgwqgr2zr524mvhQ6MCtaXBdjJkKbGD0+TPqNNqkRD8OIQcT9XYUXhzHzLIrO20CXSPsuTy
        jE9bE86CejVjajOnHddyqVxsLVaQvv1g+36MVWg==
X-Received: by 2002:ac8:1681:: with SMTP id r1mr14038974qtj.110.1615592223849;
        Fri, 12 Mar 2021 15:37:03 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyCdPdyvZZrVfCu6ZpX6b3fyKpZG74mT0MipwySQPyJS8YQdicSh6WpIYZAGofQmGctjP1m4sFXO4hiyhU51u8=
X-Received: by 2002:ac8:1681:: with SMTP id r1mr14038943qtj.110.1615592223342;
 Fri, 12 Mar 2021 15:37:03 -0800 (PST)
MIME-Version: 1.0
References: <10fa59845ccb872620cc91d8ec7378302cb44cda.camel@redhat.com>
 <CA+2bHPYg059gP7KeW=J35q_=afYZW0m-kepWskLK-9z24AFxMg@mail.gmail.com>
 <CAJ4mKGaaSn67XRkBemJC0XAWBTyWN_VjgEJfT8EB1cLaokAYvQ@mail.gmail.com>
 <c2dbc391fead002c84c07860812b689a01d2b667.camel@redhat.com>
 <CAJ4mKGZ2vC7AcmR2BKR30ZuipLNC4GB-3gpS4K1zfeEHH4fwbQ@mail.gmail.com> <ba57992848772901cd04d56ab0530360d2b9423c.camel@redhat.com>
In-Reply-To: <ba57992848772901cd04d56ab0530360d2b9423c.camel@redhat.com>
From:   Gregory Farnum <gfarnum@redhat.com>
Date:   Fri, 12 Mar 2021 15:36:52 -0800
Message-ID: <CAJ4mKGbOs2j61wZG_-XXvSfoyGAZHYpZQo47m0iv40wPSk1jhw@mail.gmail.com>
Subject: Re: fscrypt and file truncation on cephfs
To:     Jeff Layton <jlayton@redhat.com>
Cc:     Patrick Donnelly <pdonnell@redhat.com>, dev <dev@ceph.io>,
        "open list:CEPH DISTRIBUTED..." <ceph-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Fri, Mar 12, 2021 at 12:24 PM Jeff Layton <jlayton@redhat.com> wrote:
>
> On Fri, 2021-03-12 at 11:45 -0800, Gregory Farnum wrote:
> > On Fri, Mar 12, 2021 at 4:49 AM Jeff Layton <jlayton@redhat.com> wrote:
> > >
> > > On Fri, 2021-03-12 at 00:43 -0800, Gregory Farnum wrote:
> >
> > > > ...although in my current sleep-addled state, I'm actually not sure=
 we
> > > > need to add any permanent storage to the MDS to handle this case! W=
e
> > > > can probably just extend the front-end truncate op so that it can t=
ake
> > > > a separate "real-truncate-size" and the logical file size, can't we=
?
> > >
> > > That would be one nice thing about the approach of #1. Truncating the
> > > size downward is always done via an explicit SETATTR op (I think), so=
 we
> > > could just extend that with a new field for that tells the MDS where =
to
> > > stop truncating.
> > >
> > > Note that regardless of the approach we choose, the client will still
> > > need to do a read/modify/write on the edge block before we can really
> > > treat the truncation as "done". I'm not yet sure whether that has any
> > > bearing on the consistency/safety of the truncation process.
> >
> > Wait what? Let's talk more about that: I can't emphasize enough how
> > much you really, *really* don't want to require clients to do a RMW to
> > RADOS that is coordinated with MDS state changes that may modify the
> > same objects.
> >
> > Isn't it enough for:
> > 1) truncate op sets file size to new logical size, and truncate_size
> > to end of crypto block
> > 2) clients do rados reads until the end of the crypto block and throw
> > away the data past the logical end-of-file when serving IO
> > 3) clients can remove the old data on a write when they feel like it
> > and then set truncate_size to the real file size
> >
> > The only tricky bit there is making sure the MDS respects the
> > truncate_size everywhere it needs to, and doesn't inadvertently force
> > it down to the file size when we don't want that happening.
> >
>
> That sounds like it would work. I'll probably take something like that
> approach.
>
> In principle, the MDS really should not care about the logical size of
> the file at all. All it needs to know is how big the actual backing
> objects are, and that will always be rounded up to the next crypto
> block.
>
> So, I'm sort of a fan of the idea of having a "private" size field that
> only the clients with valid the crypto keys use. Everything else would
> just report (and deal with) the rounded-up size. So, the clients would
> always set the current inode size field to the rounded-up size, and then
> maintain the actual logical file size in their private field.
>
> This has the advantage that we don't need to tinker with the MDS
> mechanics so much -- only extend the inode with the new field (which
> sucks, but is a reasonably mechanical change).

Yeah, I initially really disliked the idea of adding a new "real
logical size" member, but the more I think about it the less I like
the alternatives, too. IIRC we go to a fair bit of trouble in the
server to handle sizes changing while other stuff is going on so
you'll want to look at that and see if we're okay just relying on the
clients to set their "logical crypto size" or not.

>
> This also dovetails nicely with having the client "lazily" zero-pad the
> EOF block after resetting the size.
>
> > I do foresee one leak, which is how we handle probing for file size
> > when a client with write caps disappears[2], but that's going to be
> > the case no matter what solution we come up with unless we're willing
> > to tolerate a two-phase commit. Which would be *awful*[1].
> > -Greg
> >
> > [1]: We're talking about needing to send a crypto-truncate to the MDS,
> > have it withdraw all client caps, return a new "start your phase"
> > message/state which grants read and write caps to the truncating
> > client (which I have no idea how we'd do while a logical MDS write is
> > happening), have the client do the RMW on the tail object and return
> > its caps, commit the new file size, and then return the final op and
> > re-issue caps =E2=80=94 and handle cleaning up if the client fails at a=
ny
> > point in that process. I guess if we did manage to jump through all
> > those hoops, client failure recovery would be deterministic and
> > accurate based on if the final object size was larger than or equal to
> > the attempted new size...
>
> How does this probing work today?

The MDS checks for objects in the interval from the latest size it has
seen up to the max allowed size for the client, and sets the size to
the last byte it finds. There's nothing tricky about it. (It may also
probe *every* object in the file to try and resolve the mtime, but I'm
less sure about that.)

>
> > [2]: And now that I think about the implications of crypto some more,
> > we can even fix this. Since crypto clients can never do rados append
> > ops (and I don't think we can in the FS *anyway*?) we can just have
> > all crypto-client writes include setting a "logical size" xattr on the
> > rados object that the MDS can use when probing. We maybe should do
> > that for everything, actually...
> >
>
> That does sound like a good idea, and it wouldn't be too difficult to
> implement since we're already going to be moving to doing more multi-op
> OSD write calls anyway.
>
> --
> Jeff Layton <jlayton@redhat.com>
>

