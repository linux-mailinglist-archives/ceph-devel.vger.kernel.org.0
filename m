Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8206A369171
	for <lists+ceph-devel@lfdr.de>; Fri, 23 Apr 2021 13:45:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230482AbhDWLqE convert rfc822-to-8bit (ORCPT
        <rfc822;lists+ceph-devel@lfdr.de>); Fri, 23 Apr 2021 07:46:04 -0400
Received: from mx2.suse.de ([195.135.220.15]:50136 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229957AbhDWLqD (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Fri, 23 Apr 2021 07:46:03 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 890A1B113;
        Fri, 23 Apr 2021 11:45:26 +0000 (UTC)
Received: from localhost (brahms [local])
        by brahms (OpenSMTPD) with ESMTPA id 102e9d3e;
        Fri, 23 Apr 2021 11:46:55 +0000 (UTC)
From:   Luis Henriques <lhenriques@suse.de>
To:     Jeff Layton <jlayton@redhat.com>
Cc:     dev <dev@ceph.io>, ceph-devel@vger.kernel.org,
        Luis Henriques <lhenriques@suse.com>,
        Patrick Donnelly <pdonnell@redhat.com>,
        Xiubo Li <xiubli@redhat.com>,
        Gregory Farnum <gfarnum@redhat.com>,
        Douglas Fuller <dfuller@redhat.com>
Subject: Re: ceph-mds infrastructure for fscrypt
References: <5aac4d2dca148766caf595975570e97ec2241e24.camel@redhat.com>
Date:   Fri, 23 Apr 2021 12:46:54 +0100
In-Reply-To: <5aac4d2dca148766caf595975570e97ec2241e24.camel@redhat.com> (Jeff
        Layton's message of "Thu, 22 Apr 2021 14:18:53 -0400")
Message-ID: <8735vh8bpt.fsf@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Jeff Layton <jlayton@redhat.com> writes:

> tl;dr: we need to change the MDS infrastructure for fscrypt (again), and
> I want to do it in a way that would clean up some existing mess and more
> easily allow for future changes. The design is a bit odd though...

Thanks for summarizing this issue in an email.  It really helps to see the
full picture.

> Sorry for the long email here, but I needed communicate this design, and
> the rationale for the changes I'm proposing. First, the rationale:
>
> I've been (intermittently) working on the fscrypt implementation for
> cephfs, and have posted a few different draft proposals for the first
> part of it [1], which rely on a couple of changes in the MDS:
>
> - the alternate_names feature [2]. This is needed to handle extra-long
>   filenames without allowing unprintable characters in the filename.
>
> - setting an "fscrypted" flag if the inode has an fscrypt context blob
>   in encryption.ctx xattr [3].
>
> With the filenames part more or less done, the next steps are to plumb
> in content encryption. Because the MDS handles truncates, we have to
> teach it to align those on fscrypt block boundaries. Rather than foist
> those details onto the MDS, the current idea is to add an opaque blob to
> the inode that would get updated along with size changes. The client
> would be responsible for filling out that field with the actual i_size,
> and would always round the existing size field up to the end of the last
> crypto block. That keeps the real size opaque to the MDS and the
> existing size handling logic should "just work". Regardless, that means
> we need another inode field for the size.
>
> Storing the context in an xattr is also proving to be problematic [4].
> There are some situations where we can end up with an inode that is
> flagged as encrypted but doesn't have the caps to trust its xattrs. We
> could just treat "encryption.ctx" as special and not require Xs caps to
> read whatever cached value we have, and that might fix that issue, but
> I'm not fully convinced that's foolproof. We might end up with no cached
> context on a directory that is actually encrypted in some cases and not
> have a context.
>
> At this point, I'm thinking it might be best to unify all of the 
> per-inode info into a single field that the MDS would treat as opaque.
> Note that the alternate_names feature would remain more or less
> untouched since it's associated more with dentries than inodes.
>
> The initial version of this field would look something like this:
>
> struct ceph_fscrypt_context {
> 	u8				version;	// == 1
> 	struct fscrypt_context_v2	fscrypt_ctx;	// 40 bytes
> 	__le32				blocksize	// 4k for now
> 	__le64				size;		// "real"
> i_size
> };
>
> The MDS would send this along with any size updates (InodeStat, and
> MClientCaps replies). The client would need to send this in cap
> flushes/updates, and we'd also need to extend the SETATTR op too, so the
> client can update this field in truncates (at least).
>
> I don't look forward to having to plumb this into all of the different
> client ops that can create inodes though. What I'm thinking we might
> want to do is expose this field as the "ceph.fscrypt" vxattr.
>
> The client can stuff that into the xattr blob when creating a new inode,
> and the MDS can scrape it out of that and move the data into the correct
> field in the inode. A setxattr on this field would update the new field
> too. It's an ugly interface, but shouldn't be too bad to handle and we
> have some precedent for this sort of thing.

I don't really have an objection for this, but I'm not sure I understand
why we would want to have this as a vxattr if the it will really be stored
in the inode.  Will this make things easier on the client side?  Or is
that just a matter of having visibility into these fields?

> The rules for handling the new field in the client would be a bit weird
> though. We'll need to allow it to reading the fscrypt_ctx part without
> any caps (since that should be static once it's set), but the size

The PIN cap seems to fit here as the ctx can be considered an "immutable"
field to some extent.  This means that, if there's a context, it's safe to
assume it's valid.

If it's possible to request PIN caps to be revoked (is it?), a client
could simply do that when a directory is initially encrypted.  After that,
any client getting PIN caps for it will have the new fscrypt_ctx.

> handling needs to be under the same caps as the traditional size field
> (Is that Fsx? The rules for this are never quite clear to me.)

 [ A different question which is maybe a bit OT in this context but that
   pops up in my mind quite often is how to handle multiple writers to the
   same file.  It should be OK to have 2 clients doing O_DIRECT as long as
   they are writing to different encryption blocks but it's still tricky,
   isn't it?  Can't we end-up with a corrupted file that is completely
   unrecoverable?  Should O_DIRECT be forbid in encrypted inodes?  Not to
   mention LAZYIO... ]

> Would it be better to have two different fields here -- fscrypt_auth and
> fscrypt_file? Or maybe, fscrypt_static/_dynamic? We don't necessarily
> need to keep all of this info together, but it seemed neater that way.
>
> Thoughts? Opinions? Is this a horrible idea? What would be better?

I've been looping through this since yesterday and I'm convinced the
design will need to be something close to what you just described.  I
can't poke holes in it, but the devil is always on the details.

Cheers,
-- 
Luis

>
> Thanks,
> -- 
> Jeff Layton <jlayton@redhat.com>
>
> [1]: latest draft was posted here:
> https://lore.kernel.org/ceph-devel/53d5bebb28c1e0cd354a336a56bf103d5e3a6344.camel@kernel.org/T/#t
> [2]: https://github.com/ceph/ceph/pull/37297
> [3]:
> https://github.com/ceph/ceph/commit/7fe1c57846a42443f0258fd877d7166f33fd596f
> [4]:
> https://lore.kernel.org/ceph-devel/53d5bebb28c1e0cd354a336a56bf103d5e3a6344.camel@kernel.org/T/#m0f7bbed6280623d761b8b4e70671ed568535d7fa
>
>

