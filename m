Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F3E0340E16
	for <lists+ceph-devel@lfdr.de>; Thu, 18 Mar 2021 20:21:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232695AbhCRTUv (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 18 Mar 2021 15:20:51 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:36337 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232729AbhCRTUs (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Thu, 18 Mar 2021 15:20:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1616095248;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=JbaApfgAi5MC2WcZgCIHCQFkd8ks5xRA/pFTbFk/+qo=;
        b=Lqw+tHX3U1VdW6wCjnv83c5b9AOSiwwvgHbs5iMyKHY2jsykBIfP9xh9pEBxgyIbeYOmPh
        wkLn2LDY+9kugQfTSX71F7N22ZSnT32jAOBPcWd6+sdzPCNP9hQ05A8RDEnu1lodxrjh2g
        39r8vgiQuDgRkOXx97FgwMPDZ2aHGpI=
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com
 [209.85.219.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-445-_GBOZwSuNeulCnzH7A9BUQ-1; Thu, 18 Mar 2021 15:20:46 -0400
X-MC-Unique: _GBOZwSuNeulCnzH7A9BUQ-1
Received: by mail-qv1-f72.google.com with SMTP id b15so30578066qvz.15
        for <ceph-devel@vger.kernel.org>; Thu, 18 Mar 2021 12:20:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=JbaApfgAi5MC2WcZgCIHCQFkd8ks5xRA/pFTbFk/+qo=;
        b=feXckr9BgENS0MPCc8/lguvKA/PajIWZZ7B3CDjrIb9bqdwal7OT32r1+H7dJYDikG
         ++3WQ8SvphOmefEy2c3ykzCLtYlbChgBRiBmqcBotXo3Xsrn2DcUfiJlRipxPEmkjln3
         dGOqpgCrM9uvri96lwqjZKRR5UaVoy+h2UbfFZiSaKk9Bmr69RXoBKusoAdAb2Q/z54e
         ogcjvceRRx5sIWjC9x7g9ppYY7+sNO2Liqp45HnwUlpPjlA9Aob0pN/VbwgAmFxc+nnP
         lgc/0UI8e+l+G33Y+LCaPzeTFZw0CwWCWmY00fG1AS1LU9k1v0dRRQ55zfRoccrmDun7
         Xv0w==
X-Gm-Message-State: AOAM532AejWuLC7+z9yF0IS+q551u/8oQteiuGXwQ7lqJafsjW6qxx4M
        OsZe2RmYTIkV45PsW5dyHjcbtBwvMxxbsMfGvojXj1EufXv60yCIsvp8Zfr2nCW60JkKSU4bICu
        j/6ql+BKJS/09FyEghZgcWQ==
X-Received: by 2002:ad4:4732:: with SMTP id l18mr5813177qvz.6.1616095245578;
        Thu, 18 Mar 2021 12:20:45 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyB6X7V2R4cbdmBvAXrJdPsK85o9g/FbmkJ4VodFHOpV+4diHsmUtdPb2HQ5c7kbV46ygygpQ==
X-Received: by 2002:ad4:4732:: with SMTP id l18mr5813125qvz.6.1616095244895;
        Thu, 18 Mar 2021 12:20:44 -0700 (PDT)
Received: from tleilax.poochiereds.net (68-20-15-154.lightspeed.rlghnc.sbcglobal.net. [68.20.15.154])
        by smtp.gmail.com with ESMTPSA id f9sm2110218qto.46.2021.03.18.12.20.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Mar 2021 12:20:44 -0700 (PDT)
Message-ID: <105e3f78a830ca2b9b84c83d9531cffb16fc95a2.camel@redhat.com>
Subject: Re: fscrypt and file truncation on cephfs
From:   Jeff Layton <jlayton@redhat.com>
To:     Gregory Farnum <gfarnum@redhat.com>
Cc:     Patrick Donnelly <pdonnell@redhat.com>, dev <dev@ceph.io>,
        "open list:CEPH DISTRIBUTED..." <ceph-devel@vger.kernel.org>
Date:   Thu, 18 Mar 2021 15:20:43 -0400
In-Reply-To: <CAJ4mKGbOs2j61wZG_-XXvSfoyGAZHYpZQo47m0iv40wPSk1jhw@mail.gmail.com>
References: <10fa59845ccb872620cc91d8ec7378302cb44cda.camel@redhat.com>
         <CA+2bHPYg059gP7KeW=J35q_=afYZW0m-kepWskLK-9z24AFxMg@mail.gmail.com>
         <CAJ4mKGaaSn67XRkBemJC0XAWBTyWN_VjgEJfT8EB1cLaokAYvQ@mail.gmail.com>
         <c2dbc391fead002c84c07860812b689a01d2b667.camel@redhat.com>
         <CAJ4mKGZ2vC7AcmR2BKR30ZuipLNC4GB-3gpS4K1zfeEHH4fwbQ@mail.gmail.com>
         <ba57992848772901cd04d56ab0530360d2b9423c.camel@redhat.com>
         <CAJ4mKGbOs2j61wZG_-XXvSfoyGAZHYpZQo47m0iv40wPSk1jhw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.4 (3.38.4-1.fc33) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Fri, 2021-03-12 at 15:36 -0800, Gregory Farnum wrote:
> On Fri, Mar 12, 2021 at 12:24 PM Jeff Layton <jlayton@redhat.com> wrote:
> > 
> > On Fri, 2021-03-12 at 11:45 -0800, Gregory Farnum wrote:
> > > On Fri, Mar 12, 2021 at 4:49 AM Jeff Layton <jlayton@redhat.com> wrote:
> > > > 
> > > > On Fri, 2021-03-12 at 00:43 -0800, Gregory Farnum wrote:
> > > 
> > > > > ...although in my current sleep-addled state, I'm actually not sure we
> > > > > need to add any permanent storage to the MDS to handle this case! We
> > > > > can probably just extend the front-end truncate op so that it can take
> > > > > a separate "real-truncate-size" and the logical file size, can't we?
> > > > 
> > > > That would be one nice thing about the approach of #1. Truncating the
> > > > size downward is always done via an explicit SETATTR op (I think), so we
> > > > could just extend that with a new field for that tells the MDS where to
> > > > stop truncating.
> > > > 
> > > > Note that regardless of the approach we choose, the client will still
> > > > need to do a read/modify/write on the edge block before we can really
> > > > treat the truncation as "done". I'm not yet sure whether that has any
> > > > bearing on the consistency/safety of the truncation process.
> > > 
> > > Wait what? Let's talk more about that: I can't emphasize enough how
> > > much you really, *really* don't want to require clients to do a RMW to
> > > RADOS that is coordinated with MDS state changes that may modify the
> > > same objects.
> > > 
> > > Isn't it enough for:
> > > 1) truncate op sets file size to new logical size, and truncate_size
> > > to end of crypto block
> > > 2) clients do rados reads until the end of the crypto block and throw
> > > away the data past the logical end-of-file when serving IO
> > > 3) clients can remove the old data on a write when they feel like it
> > > and then set truncate_size to the real file size
> > > 
> > > The only tricky bit there is making sure the MDS respects the
> > > truncate_size everywhere it needs to, and doesn't inadvertently force
> > > it down to the file size when we don't want that happening.
> > > 
> > 
> > That sounds like it would work. I'll probably take something like that
> > approach.
> > 
> > In principle, the MDS really should not care about the logical size of
> > the file at all. All it needs to know is how big the actual backing
> > objects are, and that will always be rounded up to the next crypto
> > block.
> > 
> > So, I'm sort of a fan of the idea of having a "private" size field that
> > only the clients with valid the crypto keys use. Everything else would
> > just report (and deal with) the rounded-up size. So, the clients would
> > always set the current inode size field to the rounded-up size, and then
> > maintain the actual logical file size in their private field.
> > 
> > This has the advantage that we don't need to tinker with the MDS
> > mechanics so much -- only extend the inode with the new field (which
> > sucks, but is a reasonably mechanical change).
> 
> Yeah, I initially really disliked the idea of adding a new "real
> logical size" member, but the more I think about it the less I like
> the alternatives, too. IIRC we go to a fair bit of trouble in the
> server to handle sizes changing while other stuff is going on so
> you'll want to look at that and see if we're okay just relying on the
> clients to set their "logical crypto size" or not.
> 

Yeah, this is tricky business, and the MDS side of things is definitely
not my area of expertise. What kind of "other stuff" do you mean in this
case?

In any case, after thinking about this a bit, what may be best is to add
new "crypto_info" field to the inode. This field would basically be
opaque to the MDS, but it'd need to record and track changes to it.

It might be good to make that field some multiple of 16 bytes (which is
the fundamental fscrypt blocksize). I like the idea of being able to
encrypt this info, and there may be other private info we'd wish to
stash in there later.

We could consider tacking this field onto the encryption context xattr,
but I'm not sure that's the best idea.

> > 
> > This also dovetails nicely with having the client "lazily" zero-pad the
> > EOF block after resetting the size.
> > 
> > > I do foresee one leak, which is how we handle probing for file size
> > > when a client with write caps disappears[2], but that's going to be
> > > the case no matter what solution we come up with unless we're willing
> > > to tolerate a two-phase commit. Which would be *awful*[1].
> > > -Greg
> > > 
> > > [1]: We're talking about needing to send a crypto-truncate to the MDS,
> > > have it withdraw all client caps, return a new "start your phase"
> > > message/state which grants read and write caps to the truncating
> > > client (which I have no idea how we'd do while a logical MDS write is
> > > happening), have the client do the RMW on the tail object and return
> > > its caps, commit the new file size, and then return the final op and
> > > re-issue caps — and handle cleaning up if the client fails at any
> > > point in that process. I guess if we did manage to jump through all
> > > those hoops, client failure recovery would be deterministic and
> > > accurate based on if the final object size was larger than or equal to
> > > the attempted new size...
> > 
> > How does this probing work today?
> 
> The MDS checks for objects in the interval from the latest size it has
> seen up to the max allowed size for the client, and sets the size to
> the last byte it finds. There's nothing tricky about it. (It may also
> probe *every* object in the file to try and resolve the mtime, but I'm
> less sure about that.)
> 

Oh right, I sort of remember seeing this at some point.

I think this can still work -- the MDS would just be determining the
rounded-up size of the file. The client would need to determine the
length of the last object though. It can't use the size of the object at
that point, so we'd need to come up with some other way to track the
size.

One idea might be to just set an xattr on the object with the latest
size of the decrypted object when we do a write? We'd have to do it in
the same WRITE compound op, but that could be done. We could even
encrypt that data too since prying eyes don't need to know.

Then the client could just vet the size in the xattr of the last object
vs. the (private) one in the inode.

Either way, I'm going to need to enlist some help for the MDS side of
this bit, I think, and whoever picks up that part should probably be
involved in the design.

> > 
> > > [2]: And now that I think about the implications of crypto some more,
> > > we can even fix this. Since crypto clients can never do rados append
> > > ops (and I don't think we can in the FS *anyway*?) we can just have
> > > all crypto-client writes include setting a "logical size" xattr on the
> > > rados object that the MDS can use when probing. We maybe should do
> > > that for everything, actually...
> > > 
> > 
> > That does sound like a good idea, and it wouldn't be too difficult to
> > implement since we're already going to be moving to doing more multi-op
> > OSD write calls anyway.
> > 
> > --
> > Jeff Layton <jlayton@redhat.com>
> > 
> 

-- 
Jeff Layton <jlayton@redhat.com>

