Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D64837695B
	for <lists+ceph-devel@lfdr.de>; Fri,  7 May 2021 19:15:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236782AbhEGRQl (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 7 May 2021 13:16:41 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:46621 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230499AbhEGRQj (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Fri, 7 May 2021 13:16:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620407739;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=0HAZILCN1yodWfNqbs34LSwX0MQUaZxwM3O31KdXtyI=;
        b=jQdUsRTDh9POo7812xpsgiRPy1UmQusRzkWdhhY5+END8Zlw6MIKfSum12ZvOKTEVeiHW3
        to9dC3PHzY5l2def60lafeNk1Pd29EtXRB7AYPyxHEr5h6TBgD6sbZpQrS/mUKICD0Vb2C
        xwQ5iuJo+F3Cbq5+Pv7ktDYU7hWUH9Y=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-12-mKUpCdA-P5eEqwofGnbRDw-1; Fri, 07 May 2021 13:15:37 -0400
X-MC-Unique: mKUpCdA-P5eEqwofGnbRDw-1
Received: by mail-ed1-f72.google.com with SMTP id i2-20020a0564020542b02903875c5e7a00so4777149edx.6
        for <ceph-devel@vger.kernel.org>; Fri, 07 May 2021 10:15:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=0HAZILCN1yodWfNqbs34LSwX0MQUaZxwM3O31KdXtyI=;
        b=UHu3hyXfJz8pxarwPsHTX0A6YCCfyD32ZfcegZ83VlJfPSJy24HNhzmbLRbt73gLk3
         WGUbjUqbNiOG2vb1LOSxKjURDL0HoeNVJMr9yTTZ2W/NgPJV3L3qSQNyf+DQdk+51dUy
         Dj5NNx9Vnd820TmfxXssK+bjbFRTmBHhI2vKIFAy0x1T+dao8m4o3st25hPuhZvwg1Tg
         4ZSWpMgDNv3nII97tBpI7qFQYIHK58++2jCeBpBhqXwi0FWiJuyfubj/DKUZO5NkYXqb
         kYUyRK9/sRA6O5+dtKSdZckV5YgxcB1pCKxH3EspZeiBpot3J1HlkSPGleoMmOcB0T8H
         EFRQ==
X-Gm-Message-State: AOAM533lr10Z7qJWkLUIs1s43mZME5qcIFiMcMepY/jamLBUxxRN5N0r
        fpWvghD4B4XQ4E/5K29H3DWlk6HWqgIj7jH+vyGBDsPsperS3TduOVhPFkaSwbMKJ3PNnnNEY1K
        pAmoMsCvmvZaC2+mghURS49F5a+Kd66sfQ1tKGw==
X-Received: by 2002:a05:6402:c1:: with SMTP id i1mr12553934edu.315.1620407736521;
        Fri, 07 May 2021 10:15:36 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyOMlt58h03A7joraZW2/bbk5LEIGp1ZkFzu1YZmU2IUC3TJyRokZGpvvSfFGyO2AK52az5BTkrgOLtOarvQwA=
X-Received: by 2002:a05:6402:c1:: with SMTP id i1mr12553915edu.315.1620407736373;
 Fri, 07 May 2021 10:15:36 -0700 (PDT)
MIME-Version: 1.0
References: <5aac4d2dca148766caf595975570e97ec2241e24.camel@redhat.com>
 <CA+2bHPbtBS2sbJ6=s3TN3+T72POPUR1AdH81STy6tLNnw7Rk3Q@mail.gmail.com>
 <c8bd4aff582850d62a2932d76a5a15b49a7ac6be.camel@redhat.com>
 <CA+2bHPZ72KdFbUw=c-jsjRfYkQZGdHGVDvdn9WjpKjsa7P2p6g@mail.gmail.com>
 <ce49bf7c10f86042a3b48d928f45ce186f0a427e.camel@redhat.com>
 <CA+2bHPbxA+CBeWeSedVc+n_5ZqgUbqfmqqMOP-x8LBZHg2Ldww@mail.gmail.com>
 <5273ea8c01160decc71fd1a06de7bd44f53aea82.camel@redhat.com>
 <CA+2bHPbDi79MZ8KrBGKG8Yi_UrCKMbfYx32TmcJ3Z4Cwzsc+jw@mail.gmail.com> <1988ce8168d06dc9a6273fc1021762ed3e49f11c.camel@redhat.com>
In-Reply-To: <1988ce8168d06dc9a6273fc1021762ed3e49f11c.camel@redhat.com>
From:   Patrick Donnelly <pdonnell@redhat.com>
Date:   Fri, 7 May 2021 10:15:09 -0700
Message-ID: <CA+2bHPaDTy41f5QWhqJR-b2rUyt=KhD=uoCnC1mtxG054+BL3Q@mail.gmail.com>
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

On Fri, May 7, 2021 at 6:07 AM Jeff Layton <jlayton@redhat.com> wrote:
>
> On Fri, 2021-04-30 at 18:03 -0700, Patrick Donnelly wrote:
> > On Fri, Apr 30, 2021 at 8:04 AM Jeff Layton <jlayton@redhat.com> wrote:
> > >
> > > On Fri, 2021-04-30 at 07:45 -0700, Patrick Donnelly wrote:
> > > > On Fri, Apr 30, 2021 at 7:33 AM Jeff Layton <jlayton@redhat.com> wrote:
> > > > > We specifically need this for directories and symlinks during pathwalks
> > > > > too. Eventually we may also want to encrypt certain data for other inode
> > > > > types as well (e.g. block/char devices). That's less critical though.
> > > > >
> > > > > The problem with fetching it after the inode is first instantiated is
> > > > > that we can end up recursing into a separate request while encoding a
> > > > > path. For instance, see this stack trace that Luis reported:
> > > > > https://lore.kernel.org/ceph-devel/53d5bebb28c1e0cd354a336a56bf103d5e3a6344.camel@kernel.org/T/#m0f7bbed6280623d761b8b4e70671ed568535d7fa
> > > > >
> > > > > While that implementation stored the context in an xattr, the problem
> > > > > isstill the same if you have to fetch the context in the middle of
> > > > > building a path. The best solution is just to always ensure it's
> > > > > available.
> > > >
> > > > Got it. Splitting the struct makes sense then. The pin cap would be
> > > > suitable for the immutable encryption context (if truly
> > > > immutable?).Otherwise maybe the Axs cap?
> > > >
> > >
> > > Ok. In that case, then we probably need to put the context blob under
> > > AUTH caps so we can ensure that it's consulted during the permission
> > > checks for pathwalks. The size will need to live under FILE.
> > >
> > > Now for the hard part...what do we name these fields?
> > >
> > >     fscrypt_context
> > >     fscrypt_size
> > >
> > > ...or maybe...
> > >
> > >     fscrypt_auth
> > >     fscrypt_file
> > >
> > > Since they'll be vector blobs, we can version these too so that we can
> > > add other fields later if the need arises (even for non-fscrypt stuff).
> > > Maybe we could consider:
> > >
> > >     client_opaque_auth
> > >     client_opaque_file
> >
> > An opaque blob makes sense but you'd want a sentinel indicating it's
> > an fscrypt blob. Don't think we'd be able to have two competing
> > use-cases but it'd be nice to have it generic enough for future
> > encryption libraries maybe.
> >
>
> I'm going with fscrypt_auth and fscrypt_file for now. We can rename them
> later though if we want. What I'll probably do is just declare a
> versioned format for these blobs. The MDS won't care about it, but the
> clients can follow that convention.
>
> I've made a bit of progress on this this week (fixing up the encoding
> and decoding was a bit of a hassle, fwiw). These fields are associated
> with the core inodes. The clients will use SETATTR calls to set them,
> though they will also be updated with cap flushes, etc.
>
> I need to be able to validate this feature in userland though and I
> don't really want to roll dedicated functions for them. What I may do is
> add new vxattrs (ceph.fscrypt_auth and ceph.fscrypt_file) and have those
> expose these fields. Doing a setxattr on them will do a SETATTR under
> the hood. The alternative is to declare new libcephfs routines for
> fetching and setting these.

A client-side vxattr sounds good to me.

-- 
Patrick Donnelly, Ph.D.
He / Him / His
Principal Software Engineer
Red Hat Sunnyvale, CA
GPG: 19F28A586F808C2402351B93C3301A3E258DD79D

