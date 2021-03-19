Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D5607342556
	for <lists+ceph-devel@lfdr.de>; Fri, 19 Mar 2021 19:55:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230442AbhCSSyj (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 19 Mar 2021 14:54:39 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:57241 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229956AbhCSSyP (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Fri, 19 Mar 2021 14:54:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1616180053;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ECyNmHlTDxnBMhmVfcdryHCc6UFJGBWfuXn36XF1iDY=;
        b=jCWq12S6nQ8mbYvWeRMTpDCQp/SoJ1ELXj4AxIIkAerLakfe8yVSSMh0o9h6Z2Wj/X/q8m
        e0SxUaiszQYZThs8l8vnpU6Ud4ddUBDsgAnXP07n7FiNjsDWxAS7jE5F87Wa6OnmG2d+Ek
        Hxt7EoeHtOUW0E7ff1bCGK5E1OkL5SM=
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com
 [209.85.160.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-322-msgLZUyrPsqS-bHUwb65vw-1; Fri, 19 Mar 2021 14:54:09 -0400
X-MC-Unique: msgLZUyrPsqS-bHUwb65vw-1
Received: by mail-qt1-f198.google.com with SMTP id 11so10499123qtz.7
        for <ceph-devel@vger.kernel.org>; Fri, 19 Mar 2021 11:54:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=ECyNmHlTDxnBMhmVfcdryHCc6UFJGBWfuXn36XF1iDY=;
        b=ZF52dq85Ry4+Czr5aPj5Faychceam+5rXpn6oGVd+W1iKx7ZRa8FEqQKW7da8H7wyE
         +RDLJ7vkwvUVBvwP8Y5BmnUhMGQxk+0AwzpYXjw+dw/gvsjL+9YPRdfBdmquKSPweWnY
         uQBR3RsGjwxU74H8MS6pvy4ewxjNDIwD6Pd/URJdOT99QWnVeOFZcWAbM5fnEUS8S3CE
         ksrKyvfniMWuoEsEKHS+4MtGFW7P7nNH0BlmqjUCTd4e8c0ro8HLoDh+L4a3K5ETroRt
         +N++tNQmSJ1t549ks7cBeVcf8dNDg9Uh7OBh3fSRQ1tJJfVAkdgSJMUGxah3EZwXZVLj
         fd2A==
X-Gm-Message-State: AOAM530z7VhKOBkzfXx0NynqKMsrtzx68ZhtDO2zdmm0xTNMaCsl899p
        +BoGn7+FyIjUQjIGhDW+bYcqwMVOt22t56TWpjMbTCtfz+Sjizk/ocbmb6L5riC/MlG8bsM2N1H
        JYm6j89rEyo2N+Fe6C2TxrzxPTfWt4ucU7BZnPw==
X-Received: by 2002:a05:6214:cad:: with SMTP id s13mr10726630qvs.53.1616180049250;
        Fri, 19 Mar 2021 11:54:09 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzYpnxDZvdlwPCGLWaENR8IfAfD/74gXGTdnUelzOO5toGt/ACc/dYKMNFCQMvKp+UmJ/7hrrtF/CVCb36dD4M=
X-Received: by 2002:a05:6214:cad:: with SMTP id s13mr10726595qvs.53.1616180048760;
 Fri, 19 Mar 2021 11:54:08 -0700 (PDT)
MIME-Version: 1.0
References: <10fa59845ccb872620cc91d8ec7378302cb44cda.camel@redhat.com>
 <CA+2bHPYg059gP7KeW=J35q_=afYZW0m-kepWskLK-9z24AFxMg@mail.gmail.com>
 <CAJ4mKGaaSn67XRkBemJC0XAWBTyWN_VjgEJfT8EB1cLaokAYvQ@mail.gmail.com>
 <c2dbc391fead002c84c07860812b689a01d2b667.camel@redhat.com>
 <CAJ4mKGZ2vC7AcmR2BKR30ZuipLNC4GB-3gpS4K1zfeEHH4fwbQ@mail.gmail.com>
 <ba57992848772901cd04d56ab0530360d2b9423c.camel@redhat.com>
 <CAJ4mKGbOs2j61wZG_-XXvSfoyGAZHYpZQo47m0iv40wPSk1jhw@mail.gmail.com> <105e3f78a830ca2b9b84c83d9531cffb16fc95a2.camel@redhat.com>
In-Reply-To: <105e3f78a830ca2b9b84c83d9531cffb16fc95a2.camel@redhat.com>
From:   Gregory Farnum <gfarnum@redhat.com>
Date:   Fri, 19 Mar 2021 11:53:57 -0700
Message-ID: <CAJ4mKGYNKmngzYjHm7afU2Q4wuiB10r7kkEzp-7Eh3PkM6RVvQ@mail.gmail.com>
Subject: Re: fscrypt and file truncation on cephfs
To:     Jeff Layton <jlayton@redhat.com>
Cc:     Patrick Donnelly <pdonnell@redhat.com>, dev <dev@ceph.io>,
        "open list:CEPH DISTRIBUTED..." <ceph-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Thu, Mar 18, 2021 at 12:20 PM Jeff Layton <jlayton@redhat.com> wrote:
>
> On Fri, 2021-03-12 at 15:36 -0800, Gregory Farnum wrote:
> > On Fri, Mar 12, 2021 at 12:24 PM Jeff Layton <jlayton@redhat.com> wrote=
:
> > >
> > > On Fri, 2021-03-12 at 11:45 -0800, Gregory Farnum wrote:
> > > > On Fri, Mar 12, 2021 at 4:49 AM Jeff Layton <jlayton@redhat.com> wr=
ote:
> > > > >
> > > > > On Fri, 2021-03-12 at 00:43 -0800, Gregory Farnum wrote:
> > > >
> > > > > > ...although in my current sleep-addled state, I'm actually not =
sure we
> > > > > > need to add any permanent storage to the MDS to handle this cas=
e! We
> > > > > > can probably just extend the front-end truncate op so that it c=
an take
> > > > > > a separate "real-truncate-size" and the logical file size, can'=
t we?
> > > > >
> > > > > That would be one nice thing about the approach of #1. Truncating=
 the
> > > > > size downward is always done via an explicit SETATTR op (I think)=
, so we
> > > > > could just extend that with a new field for that tells the MDS wh=
ere to
> > > > > stop truncating.
> > > > >
> > > > > Note that regardless of the approach we choose, the client will s=
till
> > > > > need to do a read/modify/write on the edge block before we can re=
ally
> > > > > treat the truncation as "done". I'm not yet sure whether that has=
 any
> > > > > bearing on the consistency/safety of the truncation process.
> > > >
> > > > Wait what? Let's talk more about that: I can't emphasize enough how
> > > > much you really, *really* don't want to require clients to do a RMW=
 to
> > > > RADOS that is coordinated with MDS state changes that may modify th=
e
> > > > same objects.
> > > >
> > > > Isn't it enough for:
> > > > 1) truncate op sets file size to new logical size, and truncate_siz=
e
> > > > to end of crypto block
> > > > 2) clients do rados reads until the end of the crypto block and thr=
ow
> > > > away the data past the logical end-of-file when serving IO
> > > > 3) clients can remove the old data on a write when they feel like i=
t
> > > > and then set truncate_size to the real file size
> > > >
> > > > The only tricky bit there is making sure the MDS respects the
> > > > truncate_size everywhere it needs to, and doesn't inadvertently for=
ce
> > > > it down to the file size when we don't want that happening.
> > > >
> > >
> > > That sounds like it would work. I'll probably take something like tha=
t
> > > approach.
> > >
> > > In principle, the MDS really should not care about the logical size o=
f
> > > the file at all. All it needs to know is how big the actual backing
> > > objects are, and that will always be rounded up to the next crypto
> > > block.
> > >
> > > So, I'm sort of a fan of the idea of having a "private" size field th=
at
> > > only the clients with valid the crypto keys use. Everything else woul=
d
> > > just report (and deal with) the rounded-up size. So, the clients woul=
d
> > > always set the current inode size field to the rounded-up size, and t=
hen
> > > maintain the actual logical file size in their private field.
> > >
> > > This has the advantage that we don't need to tinker with the MDS
> > > mechanics so much -- only extend the inode with the new field (which
> > > sucks, but is a reasonably mechanical change).
> >
> > Yeah, I initially really disliked the idea of adding a new "real
> > logical size" member, but the more I think about it the less I like
> > the alternatives, too. IIRC we go to a fair bit of trouble in the
> > server to handle sizes changing while other stuff is going on so
> > you'll want to look at that and see if we're okay just relying on the
> > clients to set their "logical crypto size" or not.
> >
>
> Yeah, this is tricky business, and the MDS side of things is definitely
> not my area of expertise. What kind of "other stuff" do you mean in this
> case?

It's vague in my head, but what I'm mostly concerned about is multiple
clients with write caps updating the size simultaneously, which I
think they can do? So we need to not shrink incorrectly, if one of
them extends the file to 6MB after another has already extended it to
7MB.

Or maybe I'm just remembering how we try to not go backwards on
timestamps and all the size handling is really straightforward. We'll
need to look.

> In any case, after thinking about this a bit, what may be best is to add
> new "crypto_info" field to the inode. This field would basically be
> opaque to the MDS, but it'd need to record and track changes to it.
>
> It might be good to make that field some multiple of 16 bytes (which is
> the fundamental fscrypt blocksize). I like the idea of being able to
> encrypt this info, and there may be other private info we'd wish to
> stash in there later.
>
> We could consider tacking this field onto the encryption context xattr,
> but I'm not sure that's the best idea.

xattrs are convenient because they don't require updating the core
inode wire protocol fields, some of which are unions that are already
full and not incorporated into our newer struct_v versioning (unless
that got fixed up at some point).
I'm not sure how that works out when we need to do a truncate though;
xattrs might require something unpleasant like setting the xattr
logical size and then issuing the mds setattr.

>
> > >
> > > This also dovetails nicely with having the client "lazily" zero-pad t=
he
> > > EOF block after resetting the size.
> > >
> > > > I do foresee one leak, which is how we handle probing for file size
> > > > when a client with write caps disappears[2], but that's going to be
> > > > the case no matter what solution we come up with unless we're willi=
ng
> > > > to tolerate a two-phase commit. Which would be *awful*[1].
> > > > -Greg
> > > >
> > > > [1]: We're talking about needing to send a crypto-truncate to the M=
DS,
> > > > have it withdraw all client caps, return a new "start your phase"
> > > > message/state which grants read and write caps to the truncating
> > > > client (which I have no idea how we'd do while a logical MDS write =
is
> > > > happening), have the client do the RMW on the tail object and retur=
n
> > > > its caps, commit the new file size, and then return the final op an=
d
> > > > re-issue caps =E2=80=94 and handle cleaning up if the client fails =
at any
> > > > point in that process. I guess if we did manage to jump through all
> > > > those hoops, client failure recovery would be deterministic and
> > > > accurate based on if the final object size was larger than or equal=
 to
> > > > the attempted new size...
> > >
> > > How does this probing work today?
> >
> > The MDS checks for objects in the interval from the latest size it has
> > seen up to the max allowed size for the client, and sets the size to
> > the last byte it finds. There's nothing tricky about it. (It may also
> > probe *every* object in the file to try and resolve the mtime, but I'm
> > less sure about that.)
> >
>
> Oh right, I sort of remember seeing this at some point.
>
> I think this can still work -- the MDS would just be determining the
> rounded-up size of the file. The client would need to determine the
> length of the last object though. It can't use the size of the object at
> that point, so we'd need to come up with some other way to track the
> size.
>
> One idea might be to just set an xattr on the object with the latest
> size of the decrypted object when we do a write? We'd have to do it in
> the same WRITE compound op, but that could be done. We could even
> encrypt that data too since prying eyes don't need to know.
>
> Then the client could just vet the size in the xattr of the last object
> vs. the (private) one in the inode.

Yeah, if we give the server the encrypted size to use and maintain the
logical size on clients that's what it'll have to be.

>
> Either way, I'm going to need to enlist some help for the MDS side of
> this bit, I think, and whoever picks up that part should probably be
> involved in the design.
>
> > >
> > > > [2]: And now that I think about the implications of crypto some mor=
e,
> > > > we can even fix this. Since crypto clients can never do rados appen=
d
> > > > ops (and I don't think we can in the FS *anyway*?) we can just have
> > > > all crypto-client writes include setting a "logical size" xattr on =
the
> > > > rados object that the MDS can use when probing. We maybe should do
> > > > that for everything, actually...
> > > >
> > >
> > > That does sound like a good idea, and it wouldn't be too difficult to
> > > implement since we're already going to be moving to doing more multi-=
op
> > > OSD write calls anyway.
> > >
> > > --
> > > Jeff Layton <jlayton@redhat.com>
> > >
> >
>
> --
> Jeff Layton <jlayton@redhat.com>
>

