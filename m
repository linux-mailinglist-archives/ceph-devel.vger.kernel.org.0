Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0604936FC7D
	for <lists+ceph-devel@lfdr.de>; Fri, 30 Apr 2021 16:33:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232817AbhD3Oed (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 30 Apr 2021 10:34:33 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:36243 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232622AbhD3Oed (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Fri, 30 Apr 2021 10:34:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1619793224;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=CjgqK83YjXbRudeDBw8XOd6SvK+F9v1yJKncxaUQH/k=;
        b=AWRsnO3Ww5zGA+OdH/YmxGWfQfmNPfRL6QX5vOnkJDHvRuyD6++pVvatdVqkUh5OipiImc
        TxuXA0Y6gBkkuGU4n+957u+1kxYlesJ48Qk8+7iOniPVvDTzbPfJf3mR6Zrq7tGLXW5H6k
        6mJxYtn9OoNYDe7ai7WgW8mdDFJwKzI=
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com
 [209.85.219.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-76-0kFmISW0MMKCtkn5wt0abw-1; Fri, 30 Apr 2021 10:33:42 -0400
X-MC-Unique: 0kFmISW0MMKCtkn5wt0abw-1
Received: by mail-qv1-f72.google.com with SMTP id h12-20020a0cf44c0000b02901c0e9c3e1d0so5681067qvm.4
        for <ceph-devel@vger.kernel.org>; Fri, 30 Apr 2021 07:33:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=CjgqK83YjXbRudeDBw8XOd6SvK+F9v1yJKncxaUQH/k=;
        b=WhielDkNjw6zgrf2vO1gZbcVtp/w+cygO+LIzbEry1/57vf4rGSYk7CqLQDkMRoM4+
         JxsvyJ+20Sj77kXypryJQFUlESreHkdpJEk35uWSTPp0dQ/HQtSfwBzDVT1YqJXjv4U5
         sj4jsYGAKhWw/BX6udfCJ3rPLolRF/5/7aLA/Wsz/8bpxhi4vSo/s5TeBrlEDRcFsvDW
         tJc5u+TasN41o55vgGNSBJhOHgWqhvek0RPVV/JyJUbl3BgYYldhLQocmvvu6xrsG77X
         X9n+n08CHaxUFiJ8yuuonYQollyKNTahcaSDU+Qt2K1vHdsomTk3oLiW4DtkVlPurJAo
         cHCQ==
X-Gm-Message-State: AOAM532RZfJ2XPiEl+QD+1g4yAsOdhZ1X/hxsV2UkxijJn938MXI+LvT
        vw2dAvLNkvQA4YpgCrIB4t0mpnjyIxAkUKk+PyaxCQFKpNf7FIEg3QcMdb3PmiaeGAmsDTzm8lC
        lOss0kw26AtQdncnQ1BGelw==
X-Received: by 2002:ac8:7f50:: with SMTP id g16mr4708060qtk.43.1619793222130;
        Fri, 30 Apr 2021 07:33:42 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwOt+FF5mpSBUExwTwb6Vvz/lQrbH3+EoqRzKLjRMmRJQNxSslLqVrn7L5wmdtRTBYEmxExLw==
X-Received: by 2002:ac8:7f50:: with SMTP id g16mr4708038qtk.43.1619793221867;
        Fri, 30 Apr 2021 07:33:41 -0700 (PDT)
Received: from [192.168.1.3] (68-20-15-154.lightspeed.rlghnc.sbcglobal.net. [68.20.15.154])
        by smtp.gmail.com with ESMTPSA id h62sm1536437qkf.116.2021.04.30.07.33.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Apr 2021 07:33:41 -0700 (PDT)
Message-ID: <ce49bf7c10f86042a3b48d928f45ce186f0a427e.camel@redhat.com>
Subject: Re: ceph-mds infrastructure for fscrypt
From:   Jeff Layton <jlayton@redhat.com>
To:     Patrick Donnelly <pdonnell@redhat.com>
Cc:     dev <dev@ceph.io>, Ceph Development <ceph-devel@vger.kernel.org>,
        Luis Henriques <lhenriques@suse.com>,
        Xiubo Li <xiubli@redhat.com>,
        Gregory Farnum <gfarnum@redhat.com>,
        Douglas Fuller <dfuller@redhat.com>
Date:   Fri, 30 Apr 2021 10:33:40 -0400
In-Reply-To: <CA+2bHPZ72KdFbUw=c-jsjRfYkQZGdHGVDvdn9WjpKjsa7P2p6g@mail.gmail.com>
References: <5aac4d2dca148766caf595975570e97ec2241e24.camel@redhat.com>
         <CA+2bHPbtBS2sbJ6=s3TN3+T72POPUR1AdH81STy6tLNnw7Rk3Q@mail.gmail.com>
         <c8bd4aff582850d62a2932d76a5a15b49a7ac6be.camel@redhat.com>
         <CA+2bHPZ72KdFbUw=c-jsjRfYkQZGdHGVDvdn9WjpKjsa7P2p6g@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
User-Agent: Evolution 3.40.0 (3.40.0-1.fc34) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Fri, 2021-04-30 at 07:20 -0700, Patrick Donnelly wrote:
> On Fri, Apr 30, 2021 at 6:45 AM Jeff Layton <jlayton@redhat.com> wrote:
> > > > The client can stuff that into the xattr blob when creating a new inode,
> > > > and the MDS can scrape it out of that and move the data into the correct
> > > > field in the inode. A setxattr on this field would update the new field
> > > > too. It's an ugly interface, but shouldn't be too bad to handle and we
> > > > have some precedent for this sort of thing.
> > > > 
> > > > The rules for handling the new field in the client would be a bit weird
> > > > though. We'll need to allow it to reading the fscrypt_ctx part without
> > > > any caps (since that should be static once it's set), but the size
> > > > handling needs to be under the same caps as the traditional size field
> > > > (Is that Fsx? The rules for this are never quite clear to me.)
> > > > 
> > > > Would it be better to have two different fields here -- fscrypt_auth and
> > > > fscrypt_file? Or maybe, fscrypt_static/_dynamic? We don't necessarily
> > > > need to keep all of this info together, but it seemed neater that way.
> > > 
> > > I'm not seeing a reason to split the struct.
> > > 
> > 
> > What caps should this live under? We have different requirements for
> > different parts of the struct.
> > 
> > 1) fscrypt context: needs to be always available, especially when an
> > inode is initially instantiated, though it should almost always be
> > static once it's set. The exception is that an empty directory can grow
> > a new context when it's first encrypted, and we'll want other clients to
> > pick up on this change when it occurs.
> 
> Do clients need to see this when not reading/writing to the file?
> 

Generally, yes. It's used for regular files when reading/writing,
directories for accessing their contents, and for encrypting/decrypting
symlink contents.


> > 2) "real" size: needs to be under Fwx, I think (though I need to look
> > more closely at the truncation path to be sure).
> 
> Frs would need the size as well.
>

Correct, I was speaking more about what you'd need to cache changes to
it. Reads would indeed need Fr or Fs.

> > ...and that's not even considering what rules we might want in the
> > future for other info we stuff into here. Given that the MDS needs to
> > treat this as opaque, what locks/caps should cover this new field?
> 
> I think because the encryption context is used for reads/writes, it
> can fall under the same lock domain as the file size. I don't see a
> need (yet) for accessing e.g. the encrypted version/blocksize outside
> of the Fsx cap. It's good to think about though and I wonder if anyone
> else has thoughts on it.
> 

We specifically need this for directories and symlinks during pathwalks
too. Eventually we may also want to encrypt certain data for other inode
types as well (e.g. block/char devices). That's less critical though.

The problem with fetching it after the inode is first instantiated is
that we can end up recursing into a separate request while encoding a
path. For instance, see this stack trace that Luis reported:
https://lore.kernel.org/ceph-devel/53d5bebb28c1e0cd354a336a56bf103d5e3a6344.camel@kernel.org/T/#m0f7bbed6280623d761b8b4e70671ed568535d7fa

While that implementation stored the context in an xattr, the problem
isstill the same if you have to fetch the context in the middle of
building a path. The best solution is just to always ensure it's
available.

-- 
Jeff Layton <jlayton@redhat.com>

