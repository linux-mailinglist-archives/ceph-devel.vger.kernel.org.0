Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E2F4C428DF5
	for <lists+ceph-devel@lfdr.de>; Mon, 11 Oct 2021 15:29:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235509AbhJKNb0 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 11 Oct 2021 09:31:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:55982 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235452AbhJKNbZ (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Mon, 11 Oct 2021 09:31:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9A0C160E8B;
        Mon, 11 Oct 2021 13:29:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633958965;
        bh=0OBxW//zHpUL7+VAB0Dnp8Y6r4PfE+afA8YQaoAJVBI=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=cnI+1YG6lgUnChKcxDHanFPcJ07IM3Ngwdr5c360Z2zSJKO93s3cEA+7DbJZu3uWb
         0UZdN0cxg+yL8ljn4ExoMjWhvZmYip6bg1/ZAjv+RUbGDrkDuCGRLpdMmhcWIqYBf7
         y1xz868ByBfK2bDoqPoWBY7E11C6p5LnokUlP1jPOjGDDi+qXCoo0zkYxtlQ7FYyBX
         mwyUCclWYY+tnpEfS0yv4Py1zTPp1GZ/priUxS7REU3S2pth27R5HKG/f/LvZ1TEuN
         xdSFX74kkFOsJhhdQhsKHg2PAwB4t6cvkb954xtrEbaMHjlmi9kkfe/IQNciDZ0UTY
         nEIC4u/puundw==
Message-ID: <126f465b60fd02e14dcc1d6901a80065424c1f17.camel@kernel.org>
Subject: Re: [PATCH RFC 2/2] ceph: truncate the file contents when needed
 when file scrypted
From:   Jeff Layton <jlayton@kernel.org>
To:     Xiubo Li <xiubli@redhat.com>
Cc:     idryomov@gmail.com, ukernel@gmail.com, pdonnell@redhat.com,
        ceph-devel@vger.kernel.org, Douglas Fuller <dfuller@redhat.com>
Date:   Mon, 11 Oct 2021 09:29:23 -0400
In-Reply-To: <9f5ab28e-d5b1-1909-a051-249661f6d150@redhat.com>
References: <20210903081510.982827-1-xiubli@redhat.com>
         <20210903081510.982827-3-xiubli@redhat.com>
         <34538b56f366596fa96a8da8bf1a60f1c1257367.camel@kernel.org>
         <19fac1bf-804c-1577-7aa8-9dcfa52418f9@redhat.com>
         <e97616fc4f8f090f73a39f56de2ece7ed26fbd65.camel@kernel.org>
         <fabbaeae-d63e-a2e2-0717-47afea66f82f@redhat.com>
         <64c8d4daf2bfd9d20dd55ea1b29af7b7f690407d.camel@kernel.org>
         <cadc9f02-d52e-b1fc-1752-20dd6eb1d1c4@redhat.com>
         <90b25a04fb50b42559f1e153dd4b96df54a58c03.camel@kernel.org>
         <5f33583a-8060-1f0f-d200-abfbd1705ba1@redhat.com>
         <7eb2a71e54cb246a8ce1bea642bbdbd2581122f8.camel@kernel.org>
         <9f5ab28e-d5b1-1909-a051-249661f6d150@redhat.com>
Content-Type: text/plain; charset="ISO-8859-15"
User-Agent: Evolution 3.40.4 (3.40.4-1.fc34) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Sat, 2021-09-25 at 17:56 +0800, Xiubo Li wrote:
> On 9/14/21 3:34 AM, Jeff Layton wrote:
> > On Mon, 2021-09-13 at 13:42 +0800, Xiubo Li wrote:
> > > On 9/10/21 7:46 PM, Jeff Layton wrote:
> [...]
> > > > Are you certain that Fw caps is enough to ensure that no other client
> > > > holds Fr caps?
> > > I spent hours and went through the mds Locker related code on the weekends.
> > > 
> > >   From the mds/lock.cc code, for mds filelock for example in the LOCK_MIX
> > > state and some interim transition states to LOCK_MIX it will allow
> > > different clients could hold any of Fw or Fr caps. But the Fb/Fc will be
> > > disabled. Checked the mds/Locker.cc code, found that the mds filelock
> > > could to switch LOCK_MIX state in some cases when there has one client
> > > wants Fw and another client wants any of Fr and Fw.
> > > 
> > > In this case I think the Linux advisory or mandatory locks are necessary
> > > to keep the file contents concurrency. In multiple processes' concurrent
> > > read/write or write/write cases without the Linux advisory/mandatory
> > > locks the file contents' concurrency won't be guaranteed, so the logic
> > > is the same here ?
> > > 
> > > If so, couldn't we just assume the Fw vs Fw and Fr vs Fw caps should be
> > > exclusive in correct use case ? For example, just after the mds filelock
> > > state switches to LOCK_MIX, if clientA gets the advisory file lock and
> > > the Fw caps, and even another clientB could be successfully issued the
> > > Fr caps, the clientB won't do any read because it should be still stuck
> > > and be waiting for the advisory file lock.
> > > 
> > I'm not sure I like that idea. Basically, that would change the meaning
> > of the what Frw caps represent, in a way that is not really consistent
> > with how they have been used before.
> > 
> > We could gate that new behavior on the new feature flags, but it sounds
> > pretty tough.
> > 
> > I think we have a couple of options:
> > 
> > 1) we could just make the clients request and wait on Fx caps when they
> > do a truncate. They might stall for a bit if there is contention, but it
> > would ensure consistency and the client could be completely in charge of
> > the truncate. [a]
> > 
> > 2) we could rev the protocol, and have the client send along the last
> > block to be written along with the SETATTR request.
> 
> I am also thinking send the last block along with SETATTR request, it 
> must journal the last block too, I am afraid it will occupy many cephfs 
> meta pool in corner case, such as when client send massive truncate 
> requests in a short time, just like in this bug: 
> https://tracker.ceph.com/issues/52280.
> 
> 

Good point.

Yes, we'd need to buffer the last block on a truncate like this, but we
could limit the amount of truncates with "last block" operations that
run concurrently. We'd probably also want to cap the size of the "last
block" too.


> >   Maybe we even
> > consider just adding a new TRUNCATE call independent of SETATTR. The MDS
> > would remain in complete control of it at that point.
> 
> Maybe we can just do:
> 
> When the MDS received a SETATTR request with size changing from clientA, 
> it will try to xlock(filelock), during which the MDS will always only 
> allow Fcb caps to all the clients, so another client could still 
> buffering the last block.
> 
> I think we can just nudge the journal log for this request in MDS and do 
> not do the early reply to let the clientA's truncate request to wait. 
> When the journal log is successfully flushed and before releasing the 
> xlock(filelock), we can tell the clientA to do the RMW for the last 
> block. Currently while the xlock is held, no client could get the Frw 
> caps, so we need to add one interim xlock state to only allow the 
> xlocker clientA to have the Frw, such as:
> 
> [LOCK_XLOCKDONE_TRUNC]  = { LOCK_LOCK, false, LOCK_LOCK, 0, XCL, 0,   
> 0,   0,   0,   0,  0,0,CEPH_CAP_GRD|CEPH_CAP_GWR,0 },
> 
> So for clientA it will be safe to do the RMW, after this the MDS will 
> finished the truncate request with safe reply only.
> 
> 

This sounds pretty fragile. I worry about splitting responsibility for
truncates across two different entities (MDS and client). That means a
lot more complex failure cases.

What will you do if you do this, and then the client dies before it can
finish the RMW? How will you know when the client's RMW cycle is
complete? I assume it'll have to send a "truncate complete" message to
the MDS in that case to know when it can release the xlock?


> > 
> > The other ideas I've considered seem more complex and don't offer any
> > significant advantages that I can see.
> > 
> > [a]: Side question: why does buffering a truncate require Fx and not Fb?
> > How do Fx and Fb interact?
> > 
> > > > IIRC, Frw don't have the same exclusionary relationship
> > > > that (e.g.) Asx has. To exclude Fr, you may need Fb.
> > > > 
> > > > (Side note: these rules really need to be codified into a document
> > > > somewhere. I started that with the capabilities doc in the ceph tree,
> > > > but it's light on details of the FILE caps)
> > > Yeah, that doc is light on the details for now.
> > > 
> > > 
> > > > > And if after clientB have been issued the Fw caps and have modified that
> > > > > block and still not flushed back, a new clientC comes and wants to read
> > > > > the file, so the Fw caps must be revoked from clientB and the dirty data
> > > > > will be flushed, and then when releasing the Fw caps to the MDS, it will
> > > > > update the new fscrypt_file meta together.
> > > > > 
> > > > > I haven't see which case will be racy yet. Or did I miss some cases or
> > > > > something important ?
> > > > > 
> > > > > 
> > > > We also need to consider how legacy, non-fscrypt-capable clients will
> > > > interact with files that have this field set. If one comes in and writes
> > > > to or truncates one of these files, it's liable to leave a real mess.
> > > > The simplest solution may be to just bar them from doing anything with
> > > > fscrypted files aside from deleting them -- maybe we'd allow them to
> > > > acquire Fr caps but not Fw?
> > > For the legacy, non-fscrypt-capable clients, the reading contents should
> > > be encrypted any way, so there won't be any problem even if that
> > > specified block is not RMWed yet and it should ignore this field.
> > > 
> > Right, and I think we have to allow those clients to request Fr caps so
> > that they have the ability to backup and archive encrypted files without
> > needing the key. The cephfs-mirror-daemon, in particular, may need this.
> > 
> > > But for write case, I think the MDS should fail it in the open() stage
> > > if the mode has any of Write/Truncate, etc, and only Read/Buffer-read,
> > > etc are allowed. Or if we change the mds/Locker.cc code by not allowing
> > > it to issue the Fw caps to the legacy/non-fscrypt-capable clients, after
> > > the file is successfully opened with Write mode, it should be stuck
> > > forever when writing data to the file by waiting the Fw caps, which will
> > > never come ?
> > > 
> > Yes. Those clients should be barred from making any changes to file
> > contents or doing anything that might result in a new dentry being
> > attached to an existing inode.
> > 
> > We need to allow them to read files, and unlink them, but that's really
> > about it.
> > 
> > > > > > Really, it comes down to the fact that truncates are supposed to be an
> > > > > > atomic operation, but we need to perform actions in two different
> > > > > > places.
> > > > > > 
> > > > > > Hmmm...it's worse than that even -- if the truncate changes it so that
> > > > > > the last block is in an entirely different object, then there are 3
> > > > > > places that will need to coordinate access.
> > > > > > 
> > > > > > Tricky.
> 

-- 
Jeff Layton <jlayton@kernel.org>

