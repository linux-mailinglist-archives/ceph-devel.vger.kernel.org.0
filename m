Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 05E6E36FD45
	for <lists+ceph-devel@lfdr.de>; Fri, 30 Apr 2021 17:05:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230105AbhD3PEw (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 30 Apr 2021 11:04:52 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:46491 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229877AbhD3PEv (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Fri, 30 Apr 2021 11:04:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1619795042;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=uR6iQKhEpOI5jHH9SubI72paOdJNRBxAqiLAq7Xcum0=;
        b=hB8HiIAB4obX0KG67HHRr8idhVGJHHUXakatEjLtCOS+nREKtDHpaLgXwl86zoIGeD3Qto
        i/OQp197mSJMApTxx3bgtbJXud28pSwOyynBJIbl2dxqPZpKYHzF76XRdiyqoMK2Xw1zxl
        w7avg6rlepasoNMps9zYQvIWvtzVRFo=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-385-r4bc0VdtOHGHnodyMMJumg-1; Fri, 30 Apr 2021 11:04:01 -0400
X-MC-Unique: r4bc0VdtOHGHnodyMMJumg-1
Received: by mail-qk1-f200.google.com with SMTP id c65-20020a379a440000b02902e75c11d9f2so4778555qke.20
        for <ceph-devel@vger.kernel.org>; Fri, 30 Apr 2021 08:04:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=uR6iQKhEpOI5jHH9SubI72paOdJNRBxAqiLAq7Xcum0=;
        b=TsrE2sdkxVrex1d03sqhJQGVf7mZ9/YroB0/IoamGLts51zLcIdTvkOTIRFR4O3ddJ
         ZewCQ7LaWJnmg30uvFSw/4DtizS2ww2JaJKjwZ8kVGaDbmlPRb7gstcv3D6UbpZCSdFE
         UpjbeMGWWdv3m5UYETD9rzKGCadY6rLx25FE3B5mF8bCUWSjnjf80MgA1FS+9gONMp2H
         /S7bprIpyXG+P8uYCTnI5xyq+Kl4E9N/jDQ9Fs88CJJ54HY7gjW6TbBmqckePnc9dzz1
         o1I55FQC5wSOjJfp36Eno6YFcq3YEi90WNQoho0M3YWR3JgY164EAdyrXPHRpkZjGffe
         zUGw==
X-Gm-Message-State: AOAM5339tTYjfPpBP6EIfX9xadi4guLkyHXJvfdssaN5arF1ekO6BtBX
        PtxpGUQuWCZmez+kgJGi+oc4jRnLRAKyRtxaX4EYE4shpb2LRZrAqw/u7otu6qrzH/a22EUNiB5
        /TcVEJl+7Oc9TDy2NA4r+Tg==
X-Received: by 2002:a37:270b:: with SMTP id n11mr5947184qkn.246.1619795039606;
        Fri, 30 Apr 2021 08:03:59 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJw2MO99DBOZCu+IDphXcG90vWGdG4NpLR51a/yZXyJklh/JbN0FIT9SkYfPz0JuTpZ8cf+1gw==
X-Received: by 2002:a37:270b:: with SMTP id n11mr5947165qkn.246.1619795039392;
        Fri, 30 Apr 2021 08:03:59 -0700 (PDT)
Received: from [192.168.1.3] (68-20-15-154.lightspeed.rlghnc.sbcglobal.net. [68.20.15.154])
        by smtp.gmail.com with ESMTPSA id l4sm2505475qtn.96.2021.04.30.08.03.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Apr 2021 08:03:58 -0700 (PDT)
Message-ID: <5273ea8c01160decc71fd1a06de7bd44f53aea82.camel@redhat.com>
Subject: Re: ceph-mds infrastructure for fscrypt
From:   Jeff Layton <jlayton@redhat.com>
To:     Patrick Donnelly <pdonnell@redhat.com>
Cc:     dev <dev@ceph.io>, Ceph Development <ceph-devel@vger.kernel.org>,
        Luis Henriques <lhenriques@suse.com>,
        Xiubo Li <xiubli@redhat.com>,
        Gregory Farnum <gfarnum@redhat.com>,
        Douglas Fuller <dfuller@redhat.com>
Date:   Fri, 30 Apr 2021 11:03:57 -0400
In-Reply-To: <CA+2bHPbxA+CBeWeSedVc+n_5ZqgUbqfmqqMOP-x8LBZHg2Ldww@mail.gmail.com>
References: <5aac4d2dca148766caf595975570e97ec2241e24.camel@redhat.com>
         <CA+2bHPbtBS2sbJ6=s3TN3+T72POPUR1AdH81STy6tLNnw7Rk3Q@mail.gmail.com>
         <c8bd4aff582850d62a2932d76a5a15b49a7ac6be.camel@redhat.com>
         <CA+2bHPZ72KdFbUw=c-jsjRfYkQZGdHGVDvdn9WjpKjsa7P2p6g@mail.gmail.com>
         <ce49bf7c10f86042a3b48d928f45ce186f0a427e.camel@redhat.com>
         <CA+2bHPbxA+CBeWeSedVc+n_5ZqgUbqfmqqMOP-x8LBZHg2Ldww@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
User-Agent: Evolution 3.40.0 (3.40.0-1.fc34) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Fri, 2021-04-30 at 07:45 -0700, Patrick Donnelly wrote:
> On Fri, Apr 30, 2021 at 7:33 AM Jeff Layton <jlayton@redhat.com> wrote:
> > We specifically need this for directories and symlinks during pathwalks
> > too. Eventually we may also want to encrypt certain data for other inode
> > types as well (e.g. block/char devices). That's less critical though.
> > 
> > The problem with fetching it after the inode is first instantiated is
> > that we can end up recursing into a separate request while encoding a
> > path. For instance, see this stack trace that Luis reported:
> > https://lore.kernel.org/ceph-devel/53d5bebb28c1e0cd354a336a56bf103d5e3a6344.camel@kernel.org/T/#m0f7bbed6280623d761b8b4e70671ed568535d7fa
> > 
> > While that implementation stored the context in an xattr, the problem
> > isstill the same if you have to fetch the context in the middle of
> > building a path. The best solution is just to always ensure it's
> > available.
> 
> Got it. Splitting the struct makes sense then. The pin cap would be
> suitable for the immutable encryption context (if truly
> immutable?).Otherwise maybe the Axs cap?
> 

Ok. In that case, then we probably need to put the context blob under
AUTH caps so we can ensure that it's consulted during the permission
checks for pathwalks. The size will need to live under FILE.

Now for the hard part...what do we name these fields?

    fscrypt_context
    fscrypt_size

...or maybe...

    fscrypt_auth
    fscrypt_file

Since they'll be vector blobs, we can version these too so that we can
add other fields later if the need arises (even for non-fscrypt stuff).
Maybe we could consider:

    client_opaque_auth
    client_opaque_file

-- 
Jeff Layton <jlayton@redhat.com>

