Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D1AD33397A1
	for <lists+ceph-devel@lfdr.de>; Fri, 12 Mar 2021 20:46:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234387AbhCLTqA (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 12 Mar 2021 14:46:00 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:49886 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234319AbhCLTpe (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Fri, 12 Mar 2021 14:45:34 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1615578334;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=soxrL5Juo/SnEQv4LbTr5Gc8r/d7UU3WCepDhj1Enic=;
        b=Db/ZusaiE9DKo5ee9N1k4PRTqHP8kV2JryeN5W6ZaQaJ1P3GqOk6AET+CdPypzZQZRvJ1A
        tV+Z4vIEaDoLNsB9JAApgCTzsSYcpHqKT2hB+G3YGFRn4GWBE5x7KYIvDc2EFWTYu1CHrf
        19zPRQWqoFr6egTdHEANQQ/jTfZsWJE=
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com
 [209.85.219.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-412-uw1ihxBdN6udAWCmW_mPwA-1; Fri, 12 Mar 2021 14:45:32 -0500
X-MC-Unique: uw1ihxBdN6udAWCmW_mPwA-1
Received: by mail-qv1-f70.google.com with SMTP id h12so18186005qvm.9
        for <ceph-devel@vger.kernel.org>; Fri, 12 Mar 2021 11:45:32 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=soxrL5Juo/SnEQv4LbTr5Gc8r/d7UU3WCepDhj1Enic=;
        b=L5+t7tXqzmFyOrBZsZW2awmWTRlJpHMnDFNZub6VeHpb3k+T8a7+TtrxE0FVeIrolt
         GYqg7MkHIypZXtctYKkUTq1SXWF5XNLB16nBjpp8s/fnriUi4sQ1ecPbc+1quopx6kZ7
         /IvzTJaYLU0v5kodjxp1PRBOmWiLgnh8set/fuN3HMI8UMJOZgEDjjLmHP9wrkT6xwZA
         A9JOxqTK703e4KjD9V44TbMlNogVBakPwiwqyjaiI/R1YC9dQW/8asDtXZmKdVN3I1r9
         kp0LfCcS6xknhmsxwdfzP5nYt+sKpifpg7HZqurgBQYzDj4s57EaXTLKeYQEqGzKybDH
         Z1vw==
X-Gm-Message-State: AOAM5337h3sHVIjQigUPe20WNXMn3B0XfAZ0zkdRP7B2EM5vN9S8gRdt
        krREwNuAzkOeFueytHY6T2A7ywzPu/dG95r9OQ4pLgcBRGMx9LiKiQASVrBj+mhSIg66hjMqSAX
        a9v7Z5QCUj73J90viPROY1eiwXeTTV8VagkCV9A==
X-Received: by 2002:a37:d17:: with SMTP id 23mr13963721qkn.191.1615578331559;
        Fri, 12 Mar 2021 11:45:31 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzKEpGl9GY45DxOuhWEeT8mZ9hFfMwsQkEQLMUsJ3ArtffyWg9DpqpYBqdgQUTML3kSoxoCZGOfaa/q7OhyZ0g=
X-Received: by 2002:a37:d17:: with SMTP id 23mr13963699qkn.191.1615578331085;
 Fri, 12 Mar 2021 11:45:31 -0800 (PST)
MIME-Version: 1.0
References: <10fa59845ccb872620cc91d8ec7378302cb44cda.camel@redhat.com>
 <CA+2bHPYg059gP7KeW=J35q_=afYZW0m-kepWskLK-9z24AFxMg@mail.gmail.com>
 <CAJ4mKGaaSn67XRkBemJC0XAWBTyWN_VjgEJfT8EB1cLaokAYvQ@mail.gmail.com> <c2dbc391fead002c84c07860812b689a01d2b667.camel@redhat.com>
In-Reply-To: <c2dbc391fead002c84c07860812b689a01d2b667.camel@redhat.com>
From:   Gregory Farnum <gfarnum@redhat.com>
Date:   Fri, 12 Mar 2021 11:45:19 -0800
Message-ID: <CAJ4mKGZ2vC7AcmR2BKR30ZuipLNC4GB-3gpS4K1zfeEHH4fwbQ@mail.gmail.com>
Subject: Re: fscrypt and file truncation on cephfs
To:     Jeff Layton <jlayton@redhat.com>
Cc:     Patrick Donnelly <pdonnell@redhat.com>, dev <dev@ceph.io>,
        "open list:CEPH DISTRIBUTED..." <ceph-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Fri, Mar 12, 2021 at 4:49 AM Jeff Layton <jlayton@redhat.com> wrote:
>
> On Fri, 2021-03-12 at 00:43 -0800, Gregory Farnum wrote:

> > ...although in my current sleep-addled state, I'm actually not sure we
> > need to add any permanent storage to the MDS to handle this case! We
> > can probably just extend the front-end truncate op so that it can take
> > a separate "real-truncate-size" and the logical file size, can't we?
>
> That would be one nice thing about the approach of #1. Truncating the
> size downward is always done via an explicit SETATTR op (I think), so we
> could just extend that with a new field for that tells the MDS where to
> stop truncating.
>
> Note that regardless of the approach we choose, the client will still
> need to do a read/modify/write on the edge block before we can really
> treat the truncation as "done". I'm not yet sure whether that has any
> bearing on the consistency/safety of the truncation process.

Wait what? Let's talk more about that: I can't emphasize enough how
much you really, *really* don't want to require clients to do a RMW to
RADOS that is coordinated with MDS state changes that may modify the
same objects.

Isn't it enough for:
1) truncate op sets file size to new logical size, and truncate_size
to end of crypto block
2) clients do rados reads until the end of the crypto block and throw
away the data past the logical end-of-file when serving IO
3) clients can remove the old data on a write when they feel like it
and then set truncate_size to the real file size

The only tricky bit there is making sure the MDS respects the
truncate_size everywhere it needs to, and doesn't inadvertently force
it down to the file size when we don't want that happening.
I do foresee one leak, which is how we handle probing for file size
when a client with write caps disappears[2], but that's going to be
the case no matter what solution we come up with unless we're willing
to tolerate a two-phase commit. Which would be *awful*[1].
-Greg

[1]: We're talking about needing to send a crypto-truncate to the MDS,
have it withdraw all client caps, return a new "start your phase"
message/state which grants read and write caps to the truncating
client (which I have no idea how we'd do while a logical MDS write is
happening), have the client do the RMW on the tail object and return
its caps, commit the new file size, and then return the final op and
re-issue caps =E2=80=94 and handle cleaning up if the client fails at any
point in that process. I guess if we did manage to jump through all
those hoops, client failure recovery would be deterministic and
accurate based on if the final object size was larger than or equal to
the attempted new size...
[2]: And now that I think about the implications of crypto some more,
we can even fix this. Since crypto clients can never do rados append
ops (and I don't think we can in the FS *anyway*?) we can just have
all crypto-client writes include setting a "logical size" xattr on the
rados object that the MDS can use when probing. We maybe should do
that for everything, actually...

