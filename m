Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B2ED33F8C79
	for <lists+ceph-devel@lfdr.de>; Thu, 26 Aug 2021 18:52:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243108AbhHZQuz (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 26 Aug 2021 12:50:55 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:23784 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S243057AbhHZQuv (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Thu, 26 Aug 2021 12:50:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1629996603;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=11AuWfCVFa30Glb85AGyd/BykqOjOMuJA28QI2uiEaY=;
        b=PmHhZCH/t8xHV/I9WjDcEIlE1r6x6G6Vtj2OpZRUayBAQ2Cu4myGgWoEbOXni2XPS4zxUM
        BcMxzhB6emzRPvAPYmToOYH/YHi9/hxiZA4hqNdqZGOmC029PuGM8PasVDA6JZL7Wz+g0m
        bSl45ukp0IwCgCpDqhBjMJJPwBDMoN8=
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com
 [209.85.160.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-343-iL_YsxcxP1i7uJ05i31rmg-1; Thu, 26 Aug 2021 12:50:02 -0400
X-MC-Unique: iL_YsxcxP1i7uJ05i31rmg-1
Received: by mail-qt1-f197.google.com with SMTP id c11-20020ac87dcb0000b0290293566e00b1so2143826qte.15
        for <ceph-devel@vger.kernel.org>; Thu, 26 Aug 2021 09:50:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:user-agent
         :mime-version:content-transfer-encoding;
        bh=11AuWfCVFa30Glb85AGyd/BykqOjOMuJA28QI2uiEaY=;
        b=Hcp/MJLaRdhom+NLCJOljB8nPhK+VHxzIYuMV8aw7LNEWLy8d9joXCZLPSzCF3RDvt
         OkrJT978Zdhr0Oc3uNFgJj7Lhz5cSg+2F2NQlScplaAy4BkRqsvN1ZR4SRALFD58M+Z1
         qoSALFhpxq3cNnzlZgx9FhSAxPVYI9Z0WDrKgHjisHbT+eGK0/OaaZVAhcop2vnJcFVS
         U46iFKm840SoGHrBtE/LnJ1oZU5wq7bnZ2cLt3AMmyOjLv4Y7aAWor3I7EbCGVG5JhMl
         kZvMN3eXGe1cihodjqf3zWZmxR6TwXwUZ+Ahvi4COX4HZ2EUWyGviFw+A3Y0Jbqt9fdU
         zbNw==
X-Gm-Message-State: AOAM533eXhnw2D/WBfM9+SrPPD7m/r8C99VyEo7foqrmeZ/CKPHDKbHn
        wE1ty8TBelEPgxZgpHKzqhCIZeK+xG8UUSdizyVTO4DsoOI6auQzfxWIg/kWpt2Kv9H5ZbflAiq
        E1cb17O+qUlQ9ZLa20VFkR8AqeF1dntfL015S93zh0tQ76VcixEHELh4DngimxUkKmzkM72WV
X-Received: by 2002:a05:620a:21dc:: with SMTP id h28mr4825184qka.198.1629996601265;
        Thu, 26 Aug 2021 09:50:01 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzJa2geiG6POj86gQTgAToG5uoQi5PZukRXawdcVvObPoe0bvQyGig9RO2mZ4GPYcLJQhbQng==
X-Received: by 2002:a05:620a:21dc:: with SMTP id h28mr4825136qka.198.1629996600813;
        Thu, 26 Aug 2021 09:50:00 -0700 (PDT)
Received: from [192.168.1.3] (68-20-15-154.lightspeed.rlghnc.sbcglobal.net. [68.20.15.154])
        by smtp.gmail.com with ESMTPSA id v10sm2748685qkj.79.2021.08.26.09.50.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Aug 2021 09:50:00 -0700 (PDT)
Message-ID: <448e72b2726c92306709d261a94c893559cb8454.camel@redhat.com>
Subject: State of the ceph+fscrypt union
From:   Jeff Layton <jlayton@redhat.com>
To:     Ceph Development <ceph-devel@vger.kernel.org>, dev <dev@ceph.io>
Cc:     Luis Henriques <lhenriques@suse.com>,
        Marcel Lauhoff <marcel.lauhoff@suse.com>,
        Xiubo Li <xiubli@redhat.com>,
        Kotresh Hiremath Ravishankar <khiremat@redhat.com>,
        David Howells <dhowells@redhat.com>
Date:   Thu, 26 Aug 2021 12:49:59 -0400
Content-Type: text/plain; charset="ISO-8859-15"
User-Agent: Evolution 3.40.4 (3.40.4-1.fc34) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

When I first started this project, I figured "eh, maybe a month or so to
throw together a prototype". I have never been so wrong, though I
probably should have suspected that it would be more difficult, given
that it involves cryptography.

Now that it's evident that it's too much for to do alone, so I'm looking
to hand off some parts of this to different folks to carry it over the
finish line.

To that end, let me go over the current state of ceph+fscrypt. There are
several pieces to the ceph+fscrypt project, so I'll go over the state of
each in turn:

userland MDS patches:
=====================
The first part (the alternate_name patches) were merged quite some time
ago and are in Pacific. They aren't sufficient for fscrypt support
though. We also need patches to add two new blobs to the inode. The
current patches are in this draft PR:

    https://github.com/ceph/ceph/pull/41284

This part basically works. So far, most of the changes are taking the
form of opaque fields that are attached to the inode or dentry objects
as tracked by the MDS. All of the kernel parts rely on these changes.

There is probably more work needed in the MDS. I think we probably want
to prevent clients that don't support fscrypt from corrupting files. We
may need a client-side feature bit for that that prevents the MDS from
handing out Fw caps to such clients when there is a fscrypt_auth field
set. We'll probably need it to prevent other footguns too.

kernel crypto context, filename and symlink handling:
=====================================================
The current patches are here:

    https://github.com/ceph/ceph-client/tree/wip-fscrypt-fnames

This part is basically done and working, modulo cleanup (and review).
It (of course) needs a lot more testing, but works well enough in my own
environment now. If we make changes to the approach in the MDS patches,
we'll probably need to account for that here.

The jeopardy here is that this is ~1500 lines of very invasive code
changes. It's difficult to separate this out into a neat subsystem since
it requires tendrils in some fundamental pieces of kcephfs.

File size handling:
===================
When we move to using fscrypt, then we are implicitly turning CephFS
into a block-based filesystem, when it wasn't one before. The current
approach is to use 4k blocks for the crypto (we may want to consider
making that variable later).

truncation is handled by the MDS in CephFS, so we must to ensure that it
never leaves us with a partial crypto block. The basic approach we'll
use is to keep the "real" file size in a new opaque field in the inode,
and always round the traditional size we report to the MDS up to the end
of the last crypto block.

This means that if you truncate a file in the middle of a crypto block,
the client will be responsible for doing read/modify/write on the last
block in the file.

This part is still a WIP. The basic plumbing of the file size handling
itself is working, but I haven't yet implemented the rmw of the final
block in the file. The current state is here:

    https://git.kernel.org/pub/scm/linux/kernel/git/jlayton/linux.git/log/?h=ceph-fscrypt-size-experimental

There may also be races or issues here that I haven't considered yet.
Truncate/file size handling in cephfs is already non-trivial. This makes
it even more complex.

Buffered content encryption:
============================
When the client has appropriate caps, it can store and deal with file
data in the pagecache (and the fscache). We want to encrypt that data
and also ensure that data stored in the fscache is encrypted, to guard
against offline attacks.

This means plumbing this support into the new netfs layer for that.
We'll also need to add support for writepage/writepages to netfs. David
Howells has already started working on that part.

I'm hoping this piece will turn out to be fairly simple to implement
once the right infrastructure is in place in the netfs library. Ideally
we'll be able to just hand netfs some "encrypt" and "decrypt" ops
pointers and it will take care of the rest.

Unbuffered content encryption:
==============================
For both Direct I/O, and the case where we don't have appropriate caps
to use the pagecache, we need to be able to do fscrypt'ed I/O without
using pagecache pages.

Handling writes in particular is pretty complex as you need to do rmw
cycles on partially written blocks, and have the rados ops assert on the
change attribute not changing.

This part is largely not done yet, though I do have some draft patches
here. They are pretty much entirely untested but they may give you some
idea of what's involved:

    https://git.kernel.org/pub/scm/linux/kernel/git/jlayton/linux.git/log/?h=ceph-fscrypt-experimental

That said, I think this is probably the wrong approach. What we probably
want to do is add new infrastructure to netfs lib for doing I/O into an
arbitrary set of pages, and then just hook up the appropriate codepaths
in ceph for that.

CIFS has a similar needs for uncached I/O, so that may also help it
implement fscrypt as well.

What next?
==========
I think we probably ought to be able to break up the remaining work
among a few folks. Luis and Marcel from SuSE have also reached out to
volunteer. I haven't included them below, but their help is certainly
welcome.

Here's what I think is probably reasonable:

- Kotresh has volunteered to take over the MDS patchset and either
rework it or merge it as-is once the other pieces are working. It's not
terribly complex code, but I think it needs someone with better "taste"
than me to vet and/or rework it for long-term ceph maintenance. I'm open
to doing it completely differently too. We probably also need more self
tests, etc, and the MDS needs to do more to ensure that non-fscrypt
clients can corrupt data. I think we should not merge this until the
kernel parts are closer to being done (i.e., we have a working
prototype).

- base kernel patches up to and including filenames portion: I just sent
the latest pile of patches for this to the mailing list. I'll keep
maintaining that and keep it up to date in the face of kernel and MDS
changes. My aim is to keep the wip-fscrypt-fnames branch fairly stable
to serve as a base for other development, though it is still subject to
rebase and changes.

- size handling: Xiubo has volunteered to take on this part. The
main remaining piece is teaching the client to do a rmw on the last
block on a truncate, but it'll need a lot of testing. We may also want
to implement hole punching (since it should use some of the same rmw
infrastructure). I think this part needs to be done and working well
before we can make much headway on the content encryption pieces.

- buffered I/O: I'll plan to continue working with David Howells to add
writeback functionality to netfs layer, and eventually hook ceph up to
it. I'll also work with him to add in the appropriate hooks to handle
content encryption.

- uncached I/O: I think we probably ought to table this until after
buffered I/O is working, and add infrastructure to netfs for it. We
should be able to reuse some of netfs's existing infrastructure for
that. I'll probably plan to do this piece, but if someone else wants to
tackle it, then I'd be open to that.

- userland bits: I haven't even really thought about this much. We have
the command-line fscrypt utility (written in Go), but we may want to
consider other utilities for this. I know a lot of cloud providers are
particularly interested in this. What would work best for them? Having
someone deep dive on this and thoughts about how this feature would be
best managed would be a good thing.

IRC communications
==================
Shameless plug for our IRC channel: Please join us on #cephfs on OFTC
network if you're interested in contributing in this project or other
cephfs work!

Cheers,
-- 
Jeff Layton <jlayton@redhat.com>

