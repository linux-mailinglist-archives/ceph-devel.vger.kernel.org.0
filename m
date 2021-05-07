Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 54A5C3765C5
	for <lists+ceph-devel@lfdr.de>; Fri,  7 May 2021 15:07:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236283AbhEGNI5 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 7 May 2021 09:08:57 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:54903 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232140AbhEGNI5 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Fri, 7 May 2021 09:08:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620392877;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=0fSBmdNuHhU3zI6N/Si5YzltUDgB39VJPlA46q7Uv+M=;
        b=K72F4aAiRA763PqaXGAW/7+y43s1ydK17kntrDednUUnrTrTgVjjHdeSiqu20614VFVuvt
        V1eQbH5igW3noJsCdW3BmB/TC4iIFQG5jWrfIAScxTfHFjj/fU8jdrhCQKWpWd5PLopzPu
        GWENXqJoJC06c3VbDr5P1ZKV5ROItJ4=
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com
 [209.85.160.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-460-u0NmvGJXPJeTAFgHNO1vgg-1; Fri, 07 May 2021 09:07:54 -0400
X-MC-Unique: u0NmvGJXPJeTAFgHNO1vgg-1
Received: by mail-qt1-f197.google.com with SMTP id o5-20020ac872c50000b02901c32e7e3c21so5702386qtp.8
        for <ceph-devel@vger.kernel.org>; Fri, 07 May 2021 06:07:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=0fSBmdNuHhU3zI6N/Si5YzltUDgB39VJPlA46q7Uv+M=;
        b=Wy70xp8y9FXn5TwNdP5LJoAlo5WUknyI4UeHHJdsjLmAKJGvZ1Rqzt1706NMEOovpf
         eItvWcLs4zVXe4g1kj/PUoSwlJi2RJs2ODqC2BiJtrt2vOBOZXjpECj7a5QXtX6hx5bO
         Iu1HXubCFoBYKWg6/DMoJcWWc5IADhL4vEQZvczZ/owiG3MonPAKPWZcfNezCOwapHML
         zXTsTYe0GvhLIkgtp4rFa9XLb36FexmjMugbmYsx82l0BWB4Mc9sasF7+ai1jv8dgB+S
         xKdzI7qfR1Thp3L+DiIzXwhbFYz4yx2Ju3tcg95OzvmeNXSarW6UuZHjAB4u1zHyIhbq
         YbBQ==
X-Gm-Message-State: AOAM532/UNYHz2bRYkmOTXTGbxWPweroPe/RsMtQ9ZtITej46ltIokCT
        m5P5C8KKiq9/ylfoxFd6QrAjYDeJAP/k6c3b2aBeUDmzkFa2GYu7WvTabLV7frljbghQfkmkRhX
        AWdHO/fIhYDg4QtCWByYiYg==
X-Received: by 2002:a37:e317:: with SMTP id y23mr9399266qki.396.1620392873514;
        Fri, 07 May 2021 06:07:53 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwWePw1OswXfB2JYI/qo+TonSDpUPGwyMXkOkxT21FisYAnYbnUNnLCQOWU34enl7baf6IDsA==
X-Received: by 2002:a37:e317:: with SMTP id y23mr9399240qki.396.1620392873263;
        Fri, 07 May 2021 06:07:53 -0700 (PDT)
Received: from [192.168.1.3] (68-20-15-154.lightspeed.rlghnc.sbcglobal.net. [68.20.15.154])
        by smtp.gmail.com with ESMTPSA id g7sm4619471qts.90.2021.05.07.06.07.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 May 2021 06:07:52 -0700 (PDT)
Message-ID: <1988ce8168d06dc9a6273fc1021762ed3e49f11c.camel@redhat.com>
Subject: Re: ceph-mds infrastructure for fscrypt
From:   Jeff Layton <jlayton@redhat.com>
To:     Patrick Donnelly <pdonnell@redhat.com>
Cc:     dev <dev@ceph.io>, Ceph Development <ceph-devel@vger.kernel.org>,
        Luis Henriques <lhenriques@suse.com>,
        Xiubo Li <xiubli@redhat.com>,
        Gregory Farnum <gfarnum@redhat.com>,
        Douglas Fuller <dfuller@redhat.com>
Date:   Fri, 07 May 2021 09:07:51 -0400
In-Reply-To: <CA+2bHPbDi79MZ8KrBGKG8Yi_UrCKMbfYx32TmcJ3Z4Cwzsc+jw@mail.gmail.com>
References: <5aac4d2dca148766caf595975570e97ec2241e24.camel@redhat.com>
         <CA+2bHPbtBS2sbJ6=s3TN3+T72POPUR1AdH81STy6tLNnw7Rk3Q@mail.gmail.com>
         <c8bd4aff582850d62a2932d76a5a15b49a7ac6be.camel@redhat.com>
         <CA+2bHPZ72KdFbUw=c-jsjRfYkQZGdHGVDvdn9WjpKjsa7P2p6g@mail.gmail.com>
         <ce49bf7c10f86042a3b48d928f45ce186f0a427e.camel@redhat.com>
         <CA+2bHPbxA+CBeWeSedVc+n_5ZqgUbqfmqqMOP-x8LBZHg2Ldww@mail.gmail.com>
         <5273ea8c01160decc71fd1a06de7bd44f53aea82.camel@redhat.com>
         <CA+2bHPbDi79MZ8KrBGKG8Yi_UrCKMbfYx32TmcJ3Z4Cwzsc+jw@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
User-Agent: Evolution 3.40.1 (3.40.1-1.fc34) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Fri, 2021-04-30 at 18:03 -0700, Patrick Donnelly wrote:
> On Fri, Apr 30, 2021 at 8:04 AM Jeff Layton <jlayton@redhat.com> wrote:
> > 
> > On Fri, 2021-04-30 at 07:45 -0700, Patrick Donnelly wrote:
> > > On Fri, Apr 30, 2021 at 7:33 AM Jeff Layton <jlayton@redhat.com> wrote:
> > > > We specifically need this for directories and symlinks during pathwalks
> > > > too. Eventually we may also want to encrypt certain data for other inode
> > > > types as well (e.g. block/char devices). That's less critical though.
> > > > 
> > > > The problem with fetching it after the inode is first instantiated is
> > > > that we can end up recursing into a separate request while encoding a
> > > > path. For instance, see this stack trace that Luis reported:
> > > > https://lore.kernel.org/ceph-devel/53d5bebb28c1e0cd354a336a56bf103d5e3a6344.camel@kernel.org/T/#m0f7bbed6280623d761b8b4e70671ed568535d7fa
> > > > 
> > > > While that implementation stored the context in an xattr, the problem
> > > > isstill the same if you have to fetch the context in the middle of
> > > > building a path. The best solution is just to always ensure it's
> > > > available.
> > > 
> > > Got it. Splitting the struct makes sense then. The pin cap would be
> > > suitable for the immutable encryption context (if truly
> > > immutable?).Otherwise maybe the Axs cap?
> > > 
> > 
> > Ok. In that case, then we probably need to put the context blob under
> > AUTH caps so we can ensure that it's consulted during the permission
> > checks for pathwalks. The size will need to live under FILE.
> > 
> > Now for the hard part...what do we name these fields?
> > 
> >     fscrypt_context
> >     fscrypt_size
> > 
> > ...or maybe...
> > 
> >     fscrypt_auth
> >     fscrypt_file
> > 
> > Since they'll be vector blobs, we can version these too so that we can
> > add other fields later if the need arises (even for non-fscrypt stuff).
> > Maybe we could consider:
> > 
> >     client_opaque_auth
> >     client_opaque_file
> 
> An opaque blob makes sense but you'd want a sentinel indicating it's
> an fscrypt blob. Don't think we'd be able to have two competing
> use-cases but it'd be nice to have it generic enough for future
> encryption libraries maybe.
> 

I'm going with fscrypt_auth and fscrypt_file for now. We can rename them
later though if we want. What I'll probably do is just declare a
versioned format for these blobs. The MDS won't care about it, but the
clients can follow that convention.

I've made a bit of progress on this this week (fixing up the encoding
and decoding was a bit of a hassle, fwiw). These fields are associated
with the core inodes. The clients will use SETATTR calls to set them,
though they will also be updated with cap flushes, etc.

I need to be able to validate this feature in userland though and I
don't really want to roll dedicated functions for them. What I may do is
add new vxattrs (ceph.fscrypt_auth and ceph.fscrypt_file) and have those
expose these fields. Doing a setxattr on them will do a SETATTR under
the hood. The alternative is to declare new libcephfs routines for
fetching and setting these.

I'm not terribly crazy about either, but I have a slight preference for
the vxattr since it's something we could replicate in the kernel for
debugging purposes.

Thoughts?
-- 
Jeff Layton <jlayton@redhat.com>

