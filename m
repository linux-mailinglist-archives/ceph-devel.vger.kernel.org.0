Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C20237049A
	for <lists+ceph-devel@lfdr.de>; Sat,  1 May 2021 03:05:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231298AbhEABFQ (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 30 Apr 2021 21:05:16 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:45832 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230226AbhEABFP (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Fri, 30 Apr 2021 21:05:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1619831065;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=xheCBNPo6+gwnXoBwoY2P9JkufvRy6XPYWCxJ+Gwjjw=;
        b=dVWARzCSuZDEgO6dF4JnlXnBQciIpOaV3kY+4/pUK8Zw6LLO3Z/Wn8T7r+0dH38jjeETPD
        hvpYeaAPhy46c/VHVwMJm+FaX3M+0vhP7ddmn9DcfZD4mdLSiD9biZQ/JwJTBY3Pv0yUVQ
        eKiXPfD4GrM3g5jsCm1hpgEBpxq4CPE=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-597-ie2dNtiePLWdPilJkrhO4A-1; Fri, 30 Apr 2021 21:04:23 -0400
X-MC-Unique: ie2dNtiePLWdPilJkrhO4A-1
Received: by mail-ed1-f72.google.com with SMTP id w14-20020aa7da4e0000b02903834aeed684so48613eds.13
        for <ceph-devel@vger.kernel.org>; Fri, 30 Apr 2021 18:04:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=xheCBNPo6+gwnXoBwoY2P9JkufvRy6XPYWCxJ+Gwjjw=;
        b=UUzruLtLUtvE80yONeDumxxaw9Rz1AycT3OEi4tR40oBub/PUAksLXpx9IpWPmLy06
         TVxxYgkwMK1sm6YUc57Zg3Oy3Mk62odoPymIleM3n6Lz7MTz/as7LzzY1IbVrXKY9sz4
         aXHmqMBPqH7zoc+q0pJ8oJdTj5/gmONSAqLKAqTrSZuQzHmJrLKB3a+f93emM/CwinJY
         pc576kFQHXBBGVoP6ypnOk3Cxdl8GvV4TtsNIgOmuzMAF38qhal0XVz5Q+bIkvx/WH/d
         7ZOd6dlt7TweYq7LFT7gfCrGqZFyh7/tHvfYPTHg3hdvbKsTdBxUUbbZlAOXyQJY1vPw
         Jqpg==
X-Gm-Message-State: AOAM532zQFuCQ1CeM4m3fiVCaMzqnUYsYQHRmHnYfAKsbhrbAKPCwd4I
        6sOwgYNmRaaZsIwuT5l0Gi+4lyWgnCu3p1QzRpzjslbrpsOtpWLn16R1+9oyMrLY0FHSi7yF+Zr
        omizjE05Dg6Ex/ebUSV8w9Fn2lZM7CBkTN+2bBg==
X-Received: by 2002:a17:906:c099:: with SMTP id f25mr6933691ejz.499.1619831061937;
        Fri, 30 Apr 2021 18:04:21 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyQpXxERwmg6vhIMGGq1WpR5XNc2V/gXpNMLLJ/xpVpB26Y+rLMhRof2X9X/9zGFRpsv9jjEAoDMZk0O8U2Pek=
X-Received: by 2002:a17:906:c099:: with SMTP id f25mr6933675ejz.499.1619831061765;
 Fri, 30 Apr 2021 18:04:21 -0700 (PDT)
MIME-Version: 1.0
References: <5aac4d2dca148766caf595975570e97ec2241e24.camel@redhat.com>
 <CA+2bHPbtBS2sbJ6=s3TN3+T72POPUR1AdH81STy6tLNnw7Rk3Q@mail.gmail.com>
 <c8bd4aff582850d62a2932d76a5a15b49a7ac6be.camel@redhat.com>
 <CA+2bHPZ72KdFbUw=c-jsjRfYkQZGdHGVDvdn9WjpKjsa7P2p6g@mail.gmail.com>
 <ce49bf7c10f86042a3b48d928f45ce186f0a427e.camel@redhat.com>
 <CA+2bHPbxA+CBeWeSedVc+n_5ZqgUbqfmqqMOP-x8LBZHg2Ldww@mail.gmail.com> <5273ea8c01160decc71fd1a06de7bd44f53aea82.camel@redhat.com>
In-Reply-To: <5273ea8c01160decc71fd1a06de7bd44f53aea82.camel@redhat.com>
From:   Patrick Donnelly <pdonnell@redhat.com>
Date:   Fri, 30 Apr 2021 18:03:56 -0700
Message-ID: <CA+2bHPbDi79MZ8KrBGKG8Yi_UrCKMbfYx32TmcJ3Z4Cwzsc+jw@mail.gmail.com>
Subject: Re: ceph-mds infrastructure for fscrypt
To:     Jeff Layton <jlayton@redhat.com>
Cc:     dev <dev@ceph.io>, Ceph Development <ceph-devel@vger.kernel.org>,
        Luis Henriques <lhenriques@suse.com>,
        Xiubo Li <xiubli@redhat.com>,
        Gregory Farnum <gfarnum@redhat.com>,
        Douglas Fuller <dfuller@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Fri, Apr 30, 2021 at 8:04 AM Jeff Layton <jlayton@redhat.com> wrote:
>
> On Fri, 2021-04-30 at 07:45 -0700, Patrick Donnelly wrote:
> > On Fri, Apr 30, 2021 at 7:33 AM Jeff Layton <jlayton@redhat.com> wrote:
> > > We specifically need this for directories and symlinks during pathwalks
> > > too. Eventually we may also want to encrypt certain data for other inode
> > > types as well (e.g. block/char devices). That's less critical though.
> > >
> > > The problem with fetching it after the inode is first instantiated is
> > > that we can end up recursing into a separate request while encoding a
> > > path. For instance, see this stack trace that Luis reported:
> > > https://lore.kernel.org/ceph-devel/53d5bebb28c1e0cd354a336a56bf103d5e3a6344.camel@kernel.org/T/#m0f7bbed6280623d761b8b4e70671ed568535d7fa
> > >
> > > While that implementation stored the context in an xattr, the problem
> > > isstill the same if you have to fetch the context in the middle of
> > > building a path. The best solution is just to always ensure it's
> > > available.
> >
> > Got it. Splitting the struct makes sense then. The pin cap would be
> > suitable for the immutable encryption context (if truly
> > immutable?).Otherwise maybe the Axs cap?
> >
>
> Ok. In that case, then we probably need to put the context blob under
> AUTH caps so we can ensure that it's consulted during the permission
> checks for pathwalks. The size will need to live under FILE.
>
> Now for the hard part...what do we name these fields?
>
>     fscrypt_context
>     fscrypt_size
>
> ...or maybe...
>
>     fscrypt_auth
>     fscrypt_file
>
> Since they'll be vector blobs, we can version these too so that we can
> add other fields later if the need arises (even for non-fscrypt stuff).
> Maybe we could consider:
>
>     client_opaque_auth
>     client_opaque_file

An opaque blob makes sense but you'd want a sentinel indicating it's
an fscrypt blob. Don't think we'd be able to have two competing
use-cases but it'd be nice to have it generic enough for future
encryption libraries maybe.

-- 
Patrick Donnelly, Ph.D.
He / Him / His
Principal Software Engineer
Red Hat Sunnyvale, CA
GPG: 19F28A586F808C2402351B93C3301A3E258DD79D

