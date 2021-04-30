Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7563B36FCD9
	for <lists+ceph-devel@lfdr.de>; Fri, 30 Apr 2021 16:50:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233641AbhD3Ort (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 30 Apr 2021 10:47:49 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:50834 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234267AbhD3OrP (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Fri, 30 Apr 2021 10:47:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1619793986;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Avv8pRl59pR6/SdHPq883xDTKUdp180ATARmLn+DpHg=;
        b=SjXrgW6BSBMqs0holPS5WOEKfrS0mtRJRebPLgHJqSNsivHPswAukkPWeUdxBS1ZCJEYDx
        aw56ZY9KsPKK6Dehl8eqN3f55qwpvvN075Aea0YHVtQNl1zF5flB4hJ5jyeRwITfxu1qih
        FPVRkqeHlr0f3gU6PxQ1OS42T/IWP8c=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-74-jI-QNC15NKiyDOy0mEbutg-1; Fri, 30 Apr 2021 10:46:24 -0400
X-MC-Unique: jI-QNC15NKiyDOy0mEbutg-1
Received: by mail-ed1-f70.google.com with SMTP id w14-20020aa7da4e0000b02903834aeed684so28701243eds.13
        for <ceph-devel@vger.kernel.org>; Fri, 30 Apr 2021 07:46:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Avv8pRl59pR6/SdHPq883xDTKUdp180ATARmLn+DpHg=;
        b=GV9fHYYyulFjC/JgMFFNYEVHDFACx4H93GLXOsr4iOjacnZNEPkCXwVMecqtXsDvOe
         9PZfogRFb3anlDug5QZRKwjFNF7EdVU+Xe8iy81c2qO3JKFH8weAXvTSNpgvQur4gmRK
         vm9y4QglOm9Vg8wuDSQGT703Mb9zodZk1f6FEVynDj/Ape9G6Lt9qkWc3WSKSMMTeLHT
         XUVESEW7irLK1pA6LI/YbSQu01iZKbc10r6kQY0vQon8Y+UO7wEOF5pCIjCRcCz+DIWm
         TM5WkM3uXWAtlgpbpVLpT1qHrBEXFE/9DeSRgeFEN8PVRbyshXtCbprz2nFHGVmzofnu
         4KrQ==
X-Gm-Message-State: AOAM532QyjNaZvkfuCxZ67yWeeLrVCTU1NppO0PtBEP6rJP0IvT6mjk3
        CXu/WvFtcF5T4YfUHv5TmO6082M6tCNuQc0ofDShR9+cJD3NeWE1WRPFPzATgvXNFPdMFB7metr
        6FGOuDyU2Ule1yXZb9Bz+aR9YRUfZue7A+LcbEg==
X-Received: by 2002:a17:906:e118:: with SMTP id gj24mr4834109ejb.205.1619793983221;
        Fri, 30 Apr 2021 07:46:23 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzYa2/yjfrOdJinIWTm+Udmmc3TIXw9nXSJEL3R3B+ibr2ySjstMXKzSLegg7+xTtE9iAiFo1Tj/fCMWzmNcNk=
X-Received: by 2002:a17:906:e118:: with SMTP id gj24mr4834093ejb.205.1619793983075;
 Fri, 30 Apr 2021 07:46:23 -0700 (PDT)
MIME-Version: 1.0
References: <5aac4d2dca148766caf595975570e97ec2241e24.camel@redhat.com>
 <CA+2bHPbtBS2sbJ6=s3TN3+T72POPUR1AdH81STy6tLNnw7Rk3Q@mail.gmail.com>
 <c8bd4aff582850d62a2932d76a5a15b49a7ac6be.camel@redhat.com>
 <CA+2bHPZ72KdFbUw=c-jsjRfYkQZGdHGVDvdn9WjpKjsa7P2p6g@mail.gmail.com> <ce49bf7c10f86042a3b48d928f45ce186f0a427e.camel@redhat.com>
In-Reply-To: <ce49bf7c10f86042a3b48d928f45ce186f0a427e.camel@redhat.com>
From:   Patrick Donnelly <pdonnell@redhat.com>
Date:   Fri, 30 Apr 2021 07:45:56 -0700
Message-ID: <CA+2bHPbxA+CBeWeSedVc+n_5ZqgUbqfmqqMOP-x8LBZHg2Ldww@mail.gmail.com>
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

On Fri, Apr 30, 2021 at 7:33 AM Jeff Layton <jlayton@redhat.com> wrote:
> We specifically need this for directories and symlinks during pathwalks
> too. Eventually we may also want to encrypt certain data for other inode
> types as well (e.g. block/char devices). That's less critical though.
>
> The problem with fetching it after the inode is first instantiated is
> that we can end up recursing into a separate request while encoding a
> path. For instance, see this stack trace that Luis reported:
> https://lore.kernel.org/ceph-devel/53d5bebb28c1e0cd354a336a56bf103d5e3a6344.camel@kernel.org/T/#m0f7bbed6280623d761b8b4e70671ed568535d7fa
>
> While that implementation stored the context in an xattr, the problem
> isstill the same if you have to fetch the context in the middle of
> building a path. The best solution is just to always ensure it's
> available.

Got it. Splitting the struct makes sense then. The pin cap would be
suitable for the immutable encryption context (if truly
immutable?).Otherwise maybe the Axs cap?


--
Patrick Donnelly, Ph.D.
He / Him / His
Principal Software Engineer
Red Hat Sunnyvale, CA
GPG: 19F28A586F808C2402351B93C3301A3E258DD79D

