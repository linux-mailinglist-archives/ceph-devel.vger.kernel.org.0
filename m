Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C24436FBAB
	for <lists+ceph-devel@lfdr.de>; Fri, 30 Apr 2021 15:45:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230196AbhD3Nqe (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 30 Apr 2021 09:46:34 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:46791 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230175AbhD3Nqd (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Fri, 30 Apr 2021 09:46:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1619790345;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=7qJglcu5D5OvOGPsV6q8B0PLQWI4+3L0Fnbf8my3jjA=;
        b=YU+U3NpTENwHfxSiO8x3L8aG2Owpf/TZG3VcOwAbtFPaOPKtWi9D75eQ9Dfgj1a6uNH2mf
        qT4h3TP/eFetlBsDk/occvnvf6NUHLYi9yiK9AC+HEuq20GQYAPLmDdkoTnBh6i/p9BLtr
        f/+k4Po9sxIwX6fam0b4N96aO0ogO38=
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com
 [209.85.160.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-409-gmZu5HyoNWibBNx15v1i1w-1; Fri, 30 Apr 2021 09:45:37 -0400
X-MC-Unique: gmZu5HyoNWibBNx15v1i1w-1
Received: by mail-qt1-f199.google.com with SMTP id i7-20020ac84f470000b02901b944d49e13so21455263qtw.7
        for <ceph-devel@vger.kernel.org>; Fri, 30 Apr 2021 06:45:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=7qJglcu5D5OvOGPsV6q8B0PLQWI4+3L0Fnbf8my3jjA=;
        b=n+JCmR622uFBROxbYu342LmMrUqKRpM4wRgKvaZO6tmjzVlqIXqk15nLcOqYjLhAOT
         0gAytAuViDcmPP2f/3Auoj1thPyY/d6zO5jcASCKboSDMHEAEhyRCdif4jyc0NaXYoSs
         nCR5YxAfXcBL0iTnIKdIE0XFRga/qFa5nb5pG5SxHXXg4yMe+vCkI0/MAwU28oOFjQVr
         VrjEJVO3gkJwNiSUaEgETWrXsbPjgs8fP0qTh6UesPvq+AEidaMSRkAtaDTXw6r+U8G9
         EmcCqnD430O6UdjD9mpK2EniWGwhSIUyDyGVwhr75HZeJ6Yhryu2qliWLLMeJ+bk6sXy
         UVmQ==
X-Gm-Message-State: AOAM533uiBJR41PohD34uEPsHfusme3TezqJMMEq+UQcqcI+9K9Y+K5S
        7DjWq1Rl9Q2X+DCEJXACXd02mHH2H6M4upM1Z0Xc+CmxDwBcK3V9t1r0LKUXIBtgQ1kZR0apdtB
        AcXqMiUOQ+G+DJIPeRFOVTQ==
X-Received: by 2002:a0c:8c03:: with SMTP id n3mr5514346qvb.32.1619790337138;
        Fri, 30 Apr 2021 06:45:37 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyAuPnxliRjM4qXUraClrfQXFupxY0ijr5xUGjAZqi1cGGrL2Piz5drcYdk6LJfnsDbDx3DSg==
X-Received: by 2002:a0c:8c03:: with SMTP id n3mr5514326qvb.32.1619790336940;
        Fri, 30 Apr 2021 06:45:36 -0700 (PDT)
Received: from [192.168.1.3] (68-20-15-154.lightspeed.rlghnc.sbcglobal.net. [68.20.15.154])
        by smtp.gmail.com with ESMTPSA id e15sm1457180qkl.9.2021.04.30.06.45.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Apr 2021 06:45:36 -0700 (PDT)
Message-ID: <c8bd4aff582850d62a2932d76a5a15b49a7ac6be.camel@redhat.com>
Subject: Re: ceph-mds infrastructure for fscrypt
From:   Jeff Layton <jlayton@redhat.com>
To:     Patrick Donnelly <pdonnell@redhat.com>
Cc:     dev <dev@ceph.io>, Ceph Development <ceph-devel@vger.kernel.org>,
        Luis Henriques <lhenriques@suse.com>,
        Xiubo Li <xiubli@redhat.com>,
        Gregory Farnum <gfarnum@redhat.com>,
        Douglas Fuller <dfuller@redhat.com>
Date:   Fri, 30 Apr 2021 09:45:35 -0400
In-Reply-To: <CA+2bHPbtBS2sbJ6=s3TN3+T72POPUR1AdH81STy6tLNnw7Rk3Q@mail.gmail.com>
References: <5aac4d2dca148766caf595975570e97ec2241e24.camel@redhat.com>
         <CA+2bHPbtBS2sbJ6=s3TN3+T72POPUR1AdH81STy6tLNnw7Rk3Q@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
User-Agent: Evolution 3.40.0 (3.40.0-1.fc34) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Thu, 2021-04-29 at 16:46 -0700, Patrick Donnelly wrote:
> Hi Jeff,
> 
> On Thu, Apr 22, 2021 at 11:19 AM Jeff Layton <jlayton@redhat.com> wrote:
> > At this point, I'm thinking it might be best to unify all of the
> > per-inode info into a single field that the MDS would treat as opaque.
> > Note that the alternate_names feature would remain more or less
> > untouched since it's associated more with dentries than inodes.
> > 
> > The initial version of this field would look something like this:
> > 
> > struct ceph_fscrypt_context {
> >         u8                              version;        // == 1
> >         struct fscrypt_context_v2       fscrypt_ctx;    // 40 bytes
> >         __le32                          blocksize       // 4k for now
> >         __le64                          size;           // "real"
> > i_size
> > };
> > 
> > The MDS would send this along with any size updates (InodeStat, and
> > MClientCaps replies). The client would need to send this in cap
> > flushes/updates, and we'd also need to extend the SETATTR op too, so the
> > client can update this field in truncates (at least).
> > 
> > I don't look forward to having to plumb this into all of the different
> > client ops that can create inodes though. What I'm thinking we might
> > want to do is expose this field as the "ceph.fscrypt" vxattr.
> 
> I think the process for adding the fscrypt bits to the MClientRequest
> will be the same as adding alternate_name? In the
> ceph_mds_request_head payload. I don't like the idea of stuffing this
> data in the xattr map.
> 

That does sound considerably less hacky. I'll look into doing that.

> > The client can stuff that into the xattr blob when creating a new inode,
> > and the MDS can scrape it out of that and move the data into the correct
> > field in the inode. A setxattr on this field would update the new field
> > too. It's an ugly interface, but shouldn't be too bad to handle and we
> > have some precedent for this sort of thing.
> > 
> > The rules for handling the new field in the client would be a bit weird
> > though. We'll need to allow it to reading the fscrypt_ctx part without
> > any caps (since that should be static once it's set), but the size
> > handling needs to be under the same caps as the traditional size field
> > (Is that Fsx? The rules for this are never quite clear to me.)
> > 
> > Would it be better to have two different fields here -- fscrypt_auth and
> > fscrypt_file? Or maybe, fscrypt_static/_dynamic? We don't necessarily
> > need to keep all of this info together, but it seemed neater that way.
> 
> I'm not seeing a reason to split the struct.
> 

What caps should this live under? We have different requirements for
different parts of the struct.

1) fscrypt context: needs to be always available, especially when an
inode is initially instantiated, though it should almost always be
static once it's set. The exception is that an empty directory can grow
a new context when it's first encrypted, and we'll want other clients to
pick up on this change when it occurs.

2) "real" size: needs to be under Fwx, I think (though I need to look
more closely at the truncation path to be sure).

...and that's not even considering what rules we might want in the
future for other info we stuff into here. Given that the MDS needs to
treat this as opaque, what locks/caps should cover this new field?

> > Thoughts? Opinions? Is this a horrible idea? What would be better?
> > 
> > Thanks,
> > --
> > Jeff Layton <jlayton@redhat.com>
> > 
> > [1]: latest draft was posted here:
> > https://lore.kernel.org/ceph-devel/53d5bebb28c1e0cd354a336a56bf103d5e3a6344.camel@kernel.org/T/#t
> > [2]: https://github.com/ceph/ceph/pull/37297
> > [3]:
> > https://github.com/ceph/ceph/commit/7fe1c57846a42443f0258fd877d7166f33fd596f
> > [4]:
> > https://lore.kernel.org/ceph-devel/53d5bebb28c1e0cd354a336a56bf103d5e3a6344.camel@kernel.org/T/#m0f7bbed6280623d761b8b4e70671ed568535d7fa
> > 
> > 
> 
> 

-- 
Jeff Layton <jlayton@redhat.com>

