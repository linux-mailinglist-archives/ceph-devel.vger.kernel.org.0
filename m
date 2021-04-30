Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AFECF36FC27
	for <lists+ceph-devel@lfdr.de>; Fri, 30 Apr 2021 16:24:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233160AbhD3OVq (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 30 Apr 2021 10:21:46 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:47982 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233033AbhD3OVk (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Fri, 30 Apr 2021 10:21:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1619792452;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=cEaMnf75tIvET+Jc+axvMPBqaB/PY4i2pHWCej0288s=;
        b=J7uHaT5msU1oFDn/i6dE9QkeR8/rOEIFMxe9iFypvYCRXoTz0NgsjVZ4uCYEYweFSJ5ASm
        VxH/mS5jMYVApZmf3RAG6Cbny1W1YtPuTT2WNbPonIqx1z3qr9IF2nyJQo/eRibCkmt3N9
        2SsDsjtMnnXS+9q9RUjbGlQfbEAN6pQ=
Received: from mail-pf1-f199.google.com (mail-pf1-f199.google.com
 [209.85.210.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-365-jx9C40_mOZmVU5AyfK3hJw-1; Fri, 30 Apr 2021 10:20:47 -0400
X-MC-Unique: jx9C40_mOZmVU5AyfK3hJw-1
Received: by mail-pf1-f199.google.com with SMTP id q18-20020a056a000852b02902766388a3c5so9473787pfk.4
        for <ceph-devel@vger.kernel.org>; Fri, 30 Apr 2021 07:20:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=cEaMnf75tIvET+Jc+axvMPBqaB/PY4i2pHWCej0288s=;
        b=ehGWM5044hKpc/rSYnAdgFcdA9oW1oGynSRed+rTwIX78minr/9mgpVeE/Y7ZC9YkD
         jKQkGixzxFnqqvGddwA4U4Tztfb6qwP/2w/22AcRbZCnEZnMuD9ZxZwyc2PY2+ziZfOU
         pi7/P5q1Xok5yDQi5k4rlcXqPpoCqkA7l+iNMlZ/v6jUjHdYsuHOU1SGx/IuBNXviGBm
         +vPT6CDVUxlwUTDV9YmYT1K1DvS3FfnMPfls5p2FjAAOvQ0Q0HNkqK/cYI/OgCJQJGr7
         WDhMgAcXWRJIPPKgUQEvRpVA91QtHcDz2tarcbNke7TVq+0f6fK3TWmYcQn47wme1OUt
         t1KA==
X-Gm-Message-State: AOAM532LEmeWtxFeaieI5ETGg+wI//PJbmk0Hb0Rk3TH1zEX1LtIwF3t
        wP2eLR8ST3VyMGl1TPvWM5dwvUB1H1/z4WRzpiMY57BRStohyrnwYsab2cU8IHLx0X6XjinK27V
        btLfrxOU5RXX2TcBNexPi+/x/Gyc2wyvr9llTRg==
X-Received: by 2002:a17:903:22c9:b029:ed:7d2a:8d13 with SMTP id y9-20020a17090322c9b02900ed7d2a8d13mr5622355plg.72.1619792446568;
        Fri, 30 Apr 2021 07:20:46 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzrc0hCGb11ttBCLMeiD05Y9d8vzkT/MpXsiVj0oM48pw6kp7J5pl4eInA4ap5ZpwxCFv7SUwnsVptZS2YtNK4=
X-Received: by 2002:a17:903:22c9:b029:ed:7d2a:8d13 with SMTP id
 y9-20020a17090322c9b02900ed7d2a8d13mr5622329plg.72.1619792446318; Fri, 30 Apr
 2021 07:20:46 -0700 (PDT)
MIME-Version: 1.0
References: <5aac4d2dca148766caf595975570e97ec2241e24.camel@redhat.com>
 <CA+2bHPbtBS2sbJ6=s3TN3+T72POPUR1AdH81STy6tLNnw7Rk3Q@mail.gmail.com> <c8bd4aff582850d62a2932d76a5a15b49a7ac6be.camel@redhat.com>
In-Reply-To: <c8bd4aff582850d62a2932d76a5a15b49a7ac6be.camel@redhat.com>
From:   Patrick Donnelly <pdonnell@redhat.com>
Date:   Fri, 30 Apr 2021 07:20:20 -0700
Message-ID: <CA+2bHPZ72KdFbUw=c-jsjRfYkQZGdHGVDvdn9WjpKjsa7P2p6g@mail.gmail.com>
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

On Fri, Apr 30, 2021 at 6:45 AM Jeff Layton <jlayton@redhat.com> wrote:
> > > The client can stuff that into the xattr blob when creating a new inode,
> > > and the MDS can scrape it out of that and move the data into the correct
> > > field in the inode. A setxattr on this field would update the new field
> > > too. It's an ugly interface, but shouldn't be too bad to handle and we
> > > have some precedent for this sort of thing.
> > >
> > > The rules for handling the new field in the client would be a bit weird
> > > though. We'll need to allow it to reading the fscrypt_ctx part without
> > > any caps (since that should be static once it's set), but the size
> > > handling needs to be under the same caps as the traditional size field
> > > (Is that Fsx? The rules for this are never quite clear to me.)
> > >
> > > Would it be better to have two different fields here -- fscrypt_auth and
> > > fscrypt_file? Or maybe, fscrypt_static/_dynamic? We don't necessarily
> > > need to keep all of this info together, but it seemed neater that way.
> >
> > I'm not seeing a reason to split the struct.
> >
>
> What caps should this live under? We have different requirements for
> different parts of the struct.
>
> 1) fscrypt context: needs to be always available, especially when an
> inode is initially instantiated, though it should almost always be
> static once it's set. The exception is that an empty directory can grow
> a new context when it's first encrypted, and we'll want other clients to
> pick up on this change when it occurs.

Do clients need to see this when not reading/writing to the file?

> 2) "real" size: needs to be under Fwx, I think (though I need to look
> more closely at the truncation path to be sure).

Frs would need the size as well.

> ...and that's not even considering what rules we might want in the
> future for other info we stuff into here. Given that the MDS needs to
> treat this as opaque, what locks/caps should cover this new field?

I think because the encryption context is used for reads/writes, it
can fall under the same lock domain as the file size. I don't see a
need (yet) for accessing e.g. the encrypted version/blocksize outside
of the Fsx cap. It's good to think about though and I wonder if anyone
else has thoughts on it.

-- 
Patrick Donnelly, Ph.D.
He / Him / His
Principal Software Engineer
Red Hat Sunnyvale, CA
GPG: 19F28A586F808C2402351B93C3301A3E258DD79D

