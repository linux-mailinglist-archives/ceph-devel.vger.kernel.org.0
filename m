Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 923731D4CC1
	for <lists+ceph-devel@lfdr.de>; Fri, 15 May 2020 13:39:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726224AbgEOLi4 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 15 May 2020 07:38:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:55986 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726046AbgEOLiz (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Fri, 15 May 2020 07:38:55 -0400
Received: from tleilax.poochiereds.net (68-20-15-154.lightspeed.rlghnc.sbcglobal.net [68.20.15.154])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0096B2065C;
        Fri, 15 May 2020 11:38:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589542734;
        bh=+S6mlhgbIwCKyftKptzsPmNaoU/0SlgMilrpE31kyiw=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=r3jXPxZ9s8xL1hJJzYfSfII/OZKEJz2jTjEfyJYykW+sHhDzeVo4j+p+Due+naIqa
         oeN9L7qn3DHdFydtEZXSaTvjboqUOkkIwXOBHmLOFCsBU6jXfYHTYT+ac2kC2l4BuW
         ifIlnD8M7D4ccXe+VpvyZXiuC09h8/HOiWA/otq0=
Message-ID: <61b1f19edcc349641b5383c2ac70cbf9a15ba4bd.camel@kernel.org>
Subject: Re: [PATCH] ceph: don't return -ESTALE if there's still an open file
From:   Jeff Layton <jlayton@kernel.org>
To:     Luis Henriques <lhenriques@suse.com>,
        Amir Goldstein <amir73il@gmail.com>
Cc:     Ilya Dryomov <idryomov@gmail.com>, ceph-devel@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>,
        fstests <fstests@vger.kernel.org>,
        Dave Chinner <dchinner@redhat.com>,
        Christoph Hellwig <hch@lst.de>,
        Miklos Szeredi <miklos@szeredi.hu>
Date:   Fri, 15 May 2020 07:38:52 -0400
In-Reply-To: <20200515111548.GA54598@suse.com>
References: <20200514111453.GA99187@suse.com>
         <8497fe9a11ac1837813ee5f14b6ebae8fa6bf707.camel@kernel.org>
         <20200514124845.GA12559@suse.com>
         <4e5bf0e3bf055e53a342b19d168f6cf441781973.camel@kernel.org>
         <CAOQ4uxhireZBRvcPQzTS8yOoO4gQt78M0ktZo-9yQ-zcaLZbow@mail.gmail.com>
         <20200515111548.GA54598@suse.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.2 (3.36.2-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Fri, 2020-05-15 at 12:15 +0100, Luis Henriques wrote:
> On Fri, May 15, 2020 at 09:42:24AM +0300, Amir Goldstein wrote:
> > +CC: fstests
> > 
> > On Thu, May 14, 2020 at 4:15 PM Jeff Layton <jlayton@kernel.org> wrote:
> > > On Thu, 2020-05-14 at 13:48 +0100, Luis Henriques wrote:
> > > > On Thu, May 14, 2020 at 08:10:09AM -0400, Jeff Layton wrote:
> > > > > On Thu, 2020-05-14 at 12:14 +0100, Luis Henriques wrote:
> > > > > > Similarly to commit 03f219041fdb ("ceph: check i_nlink while converting
> > > > > > a file handle to dentry"), this fixes another corner case with
> > > > > > name_to_handle_at/open_by_handle_at.  The issue has been detected by
> > > > > > xfstest generic/467, when doing:
> > > > > > 
> > > > > >  - name_to_handle_at("/cephfs/myfile")
> > > > > >  - open("/cephfs/myfile")
> > > > > >  - unlink("/cephfs/myfile")
> > > > > >  - open_by_handle_at()
> > > > > > 
> > > > > > The call to open_by_handle_at should not fail because the file still
> > > > > > exists and we do have a valid handle to it.
> > > > > > 
> > > > > > Signed-off-by: Luis Henriques <lhenriques@suse.com>
> > > > > > ---
> > > > > >  fs/ceph/export.c | 13 +++++++++++--
> > > > > >  1 file changed, 11 insertions(+), 2 deletions(-)
> > > > > > 
> > > > > > diff --git a/fs/ceph/export.c b/fs/ceph/export.c
> > > > > > index 79dc06881e78..8556df9d94d0 100644
> > > > > > --- a/fs/ceph/export.c
> > > > > > +++ b/fs/ceph/export.c
> > > > > > @@ -171,12 +171,21 @@ struct inode *ceph_lookup_inode(struct super_block *sb, u64 ino)
> > > > > > 
> > > > > >  static struct dentry *__fh_to_dentry(struct super_block *sb, u64 ino)
> > > > > >  {
> > > > > > + struct ceph_inode_info *ci;
> > > > > >   struct inode *inode = __lookup_inode(sb, ino);
> > > > > > +
> > > > > >   if (IS_ERR(inode))
> > > > > >           return ERR_CAST(inode);
> > > > > >   if (inode->i_nlink == 0) {
> > > > > > -         iput(inode);
> > > > > > -         return ERR_PTR(-ESTALE);
> > > > > > +         bool is_open;
> > > > > > +         ci = ceph_inode(inode);
> > > > > > +         spin_lock(&ci->i_ceph_lock);
> > > > > > +         is_open = __ceph_is_file_opened(ci);
> > > > > > +         spin_unlock(&ci->i_ceph_lock);
> > > > > > +         if (!is_open) {
> > > > > > +                 iput(inode);
> > > > > > +                 return ERR_PTR(-ESTALE);
> > > > > > +         }
> > > > > >   }
> > > > > >   return d_obtain_alias(inode);
> > > > > >  }
> > > > > 
> > > > > Thanks Luis. Out of curiousity, is there any reason we shouldn't ignore
> > > > > the i_nlink value here? Does anything obviously break if we do?
> > > > 
> > > > Yes, the scenario described in commit 03f219041fdb is still valid, which
> > > > is basically the same but without the extra open(2):
> > > > 
> > > >   - name_to_handle_at("/cephfs/myfile")
> > > >   - unlink("/cephfs/myfile")
> > > >   - open_by_handle_at()
> > > > 
> > > 
> > > Ok, I guess we end up doing some delayed cleanup, and that allows the
> > > inode to be found in that situation.
> > > 
> > > > The open_by_handle_at man page isn't really clear about these 2 scenarios,
> > > > but generic/426 will fail if -ESTALE isn't returned.  Want me to add a
> > > > comment to the code, describing these 2 scenarios?
> > > > 
> > > 
> > > (cc'ing Amir since he added this test)
> > > 
> > > I don't think there is any hard requirement that open_by_handle_at
> > > should fail in that situation. It generally does for most filesystems
> > > due to the way they handle cl794798fa xfsqa: test open_by_handle() on unlinked and freed inode clusters
> > eaning up unlinked inodes, but I don't
> > > think it's technically illegal to allow the inode to still be found. If
> > > the caller cares about whether it has been unlinked it can always test
> > > i_nlink itself.
> > > 
> > > Amir, is this required for some reason that I'm not aware of?
> > 
> > Hi Jeff,
> > 
> > The origin of this test is in fstests commit:
> > 794798fa xfsqa: test open_by_handle() on unlinked and freed inode clusters
> > 
> > It was introduced to catch an xfs bug, so this behavior is the expectation
> > of xfs filesystem, but note that it is not a general expectation to fail
> > open_by_handle() after unlink(), it is an expectation to fail open_by_handle()
> > after unlink() + sync() + drop_caches.
> 
> Yes, sorry I should have mentioned the sync+drop_caches in the
> description.
> 
> > I have later converted the test to generic, because I needed to check the
> > same expectation for overlayfs use case, which is:
> > The original inode is always there (in lower layer), unlink creates a whiteout
> > mark and open_by_handle should treat that as ESTALE, otherwise the
> > unlinked files would be accessible to nfs clients forever.
> > 

Ok, that makes sense. 

The situation with Ceph is a bit different I think. I suspect that we're
cleaning the inode out of the client's caches after drop_caches, but
then we end up issuing a lookup by inode number to the MDS and it
returns an inode that it may be in the process of purging.

> > 
> > In overlayfs, we handle the open file case by returning a dentry only
> > in case the inode with deletion mark in question is already in inode cache,
> > but we take care not to populate inode cache with the check.
> > It is easier, because we do not need to get inode into cache for checking
> > the delete marker.
> > 
> > Maybe you could instead check in __fh_to_dentry():
> > 
> >     if (inode->i_nlink == 0 && atomic_read(&inode->i_count) == 1)) {
> >         iput(inode);
> >         return ERR_PTR(-ESTALE);
> >     }
> > 
> > The above is untested, so I don't know if it's enough to pass generic/426.
> 
> Yes, I can confirm that this also fixes the issue -- both tests pass.
> __ceph_is_file_opened() uses some internal counters per inode, incremented
> each time a file is open in a specific mode.  The problem is that these
> counters require some extra locking (maybe they should be atomic_t?), so
> you're suggestion is probably better.
> 
> > Note that generic/467 also checks the same behavior for rmdir().
> 
> Yeah, but the only test-case failing with cephfs is the one described
> above (i.e. "open_by_handle -dkr ...").
> 
> > If you decide that ceph does not need to comply to this behavior,
> > then we probably need to whitelist/blocklist the filesystems that
> > want to test this behavior, which will be a shame.
> 
> Unless Jeff has any objection, I'm happy sending v2, simplifying the patch
> to use your simpler solution (and mentioning sync+drop_caches in the
> commit message).
> 

The real question I have is whether this is truly a client-side issue,
or if the MDS is satisfying lookup-by-ino requests with inodes that just
haven't yet been fully purged. If so, then the right fix may be in the
MDS.

Can we determine that one way or the other?

Thanks,
-- 
Jeff Layton <jlayton@kernel.org>

