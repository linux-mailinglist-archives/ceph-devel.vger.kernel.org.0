Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 717A91D56E5
	for <lists+ceph-devel@lfdr.de>; Fri, 15 May 2020 18:57:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726541AbgEOQ5A (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 15 May 2020 12:57:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726023AbgEOQ47 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Fri, 15 May 2020 12:56:59 -0400
Received: from mail-io1-xd43.google.com (mail-io1-xd43.google.com [IPv6:2607:f8b0:4864:20::d43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A387C061A0C;
        Fri, 15 May 2020 09:56:58 -0700 (PDT)
Received: by mail-io1-xd43.google.com with SMTP id s10so3455378iog.7;
        Fri, 15 May 2020 09:56:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=2Ctr3SX/Gk/ZZWBCoTl13shaTwquzAa+IXhn7A1vXr0=;
        b=mRxxJWgd2Lp2CSWkedggMJqzyp6RN64m1R/q1iSwm/WQWFrEQdA2BLvznqZq7FrKMG
         2d3Wr7+A+3Qje345DXjXskM1th7x94oDQbizV8/d5cC6OqMZiebBVpGG0wWYtT+toHd5
         qVtSaAh/+7CdmlmfNFY2Xe+0qNPiQkgDBBydQWvZ+UsBHvcTWkZ+Wav+coH2cZpURaL0
         LNheEs4qtKMysSZS/bS9M11vcMoX0gVHJy2HD0bmTUXvo3KeOmzIpniafZGDLG5SVZ06
         UcjFoACB9FTFzy7yJFCbuzOBJpxIbD/yKmw8QF87tw+8ibmyW/J23VqMuJNK6DB94EVp
         z+sA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=2Ctr3SX/Gk/ZZWBCoTl13shaTwquzAa+IXhn7A1vXr0=;
        b=llrMMf+4jf2KeDOh1XT/AlBgoqj7akR1w4d2T9Fme3HaMzlq6ceAB8LmOwlg8vU1M6
         OcZmzgzdLfnZfvLaSCVCifT6VThlz4yqt4k/kPjRRJrICu9NiQr1w5czU45YH3B/OE5E
         zIB4PPwvyA6+K8Rr8RzM0S/0yCzyNhoh+MOj5hPgr63NP2s1KdEG5jnX32OfV1jrgbCI
         mH9SyFR00I3L3QpI5+TXzN4ngPTYv3T2jaSNcwXDl1OM3fva82l6NdOB3MTiQ6igHNyp
         ibp/X6gjn8bRd/czIM8Nyr5fAPpJggDzvn6RBUiPP8kE6dYg89yNurqPIr0L43OPAL7f
         5vPg==
X-Gm-Message-State: AOAM532A+3c8B83bDDdrUCS9ZBO1jYBBYSDhWbVRwJwtNPqccPIN+usy
        QIx3g79lCkvbCq+w4sRF+ZdToYZ+uTPvo5Hc99Q=
X-Google-Smtp-Source: ABdhPJxVchxAYI2LXoB22O9ibXBM3+VCtoyMynymt4NDl9lLczlsxsJNXBzpZfOh/JY/nAEisLD20uPl0lSLadVDMUU=
X-Received: by 2002:a5d:898a:: with SMTP id m10mr2646055iol.203.1589561817438;
 Fri, 15 May 2020 09:56:57 -0700 (PDT)
MIME-Version: 1.0
References: <20200514111453.GA99187@suse.com> <8497fe9a11ac1837813ee5f14b6ebae8fa6bf707.camel@kernel.org>
 <20200514124845.GA12559@suse.com> <4e5bf0e3bf055e53a342b19d168f6cf441781973.camel@kernel.org>
 <CAOQ4uxhireZBRvcPQzTS8yOoO4gQt78M0ktZo-9yQ-zcaLZbow@mail.gmail.com>
 <20200515111548.GA54598@suse.com> <61b1f19edcc349641b5383c2ac70cbf9a15ba4bd.camel@kernel.org>
In-Reply-To: <61b1f19edcc349641b5383c2ac70cbf9a15ba4bd.camel@kernel.org>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Fri, 15 May 2020 19:56:44 +0300
Message-ID: <CAOQ4uxiWZoSj3Pjwskd_hu-ErV9096hLt13CDcW6nEEvcwDNVA@mail.gmail.com>
Subject: Re: [PATCH] ceph: don't return -ESTALE if there's still an open file
To:     Jeff Layton <jlayton@kernel.org>
Cc:     Luis Henriques <lhenriques@suse.com>,
        Ilya Dryomov <idryomov@gmail.com>, ceph-devel@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>,
        fstests <fstests@vger.kernel.org>,
        Dave Chinner <dchinner@redhat.com>,
        Christoph Hellwig <hch@lst.de>,
        Miklos Szeredi <miklos@szeredi.hu>
Content-Type: text/plain; charset="UTF-8"
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Fri, May 15, 2020 at 2:38 PM Jeff Layton <jlayton@kernel.org> wrote:
>
> On Fri, 2020-05-15 at 12:15 +0100, Luis Henriques wrote:
> > On Fri, May 15, 2020 at 09:42:24AM +0300, Amir Goldstein wrote:
> > > +CC: fstests
> > >
> > > On Thu, May 14, 2020 at 4:15 PM Jeff Layton <jlayton@kernel.org> wrote:
> > > > On Thu, 2020-05-14 at 13:48 +0100, Luis Henriques wrote:
> > > > > On Thu, May 14, 2020 at 08:10:09AM -0400, Jeff Layton wrote:
> > > > > > On Thu, 2020-05-14 at 12:14 +0100, Luis Henriques wrote:
> > > > > > > Similarly to commit 03f219041fdb ("ceph: check i_nlink while converting
> > > > > > > a file handle to dentry"), this fixes another corner case with
> > > > > > > name_to_handle_at/open_by_handle_at.  The issue has been detected by
> > > > > > > xfstest generic/467, when doing:
> > > > > > >
> > > > > > >  - name_to_handle_at("/cephfs/myfile")
> > > > > > >  - open("/cephfs/myfile")
> > > > > > >  - unlink("/cephfs/myfile")
> > > > > > >  - open_by_handle_at()
> > > > > > >
> > > > > > > The call to open_by_handle_at should not fail because the file still
> > > > > > > exists and we do have a valid handle to it.
> > > > > > >
> > > > > > > Signed-off-by: Luis Henriques <lhenriques@suse.com>
> > > > > > > ---
> > > > > > >  fs/ceph/export.c | 13 +++++++++++--
> > > > > > >  1 file changed, 11 insertions(+), 2 deletions(-)
> > > > > > >
> > > > > > > diff --git a/fs/ceph/export.c b/fs/ceph/export.c
> > > > > > > index 79dc06881e78..8556df9d94d0 100644
> > > > > > > --- a/fs/ceph/export.c
> > > > > > > +++ b/fs/ceph/export.c
> > > > > > > @@ -171,12 +171,21 @@ struct inode *ceph_lookup_inode(struct super_block *sb, u64 ino)
> > > > > > >
> > > > > > >  static struct dentry *__fh_to_dentry(struct super_block *sb, u64 ino)
> > > > > > >  {
> > > > > > > + struct ceph_inode_info *ci;
> > > > > > >   struct inode *inode = __lookup_inode(sb, ino);
> > > > > > > +
> > > > > > >   if (IS_ERR(inode))
> > > > > > >           return ERR_CAST(inode);
> > > > > > >   if (inode->i_nlink == 0) {
> > > > > > > -         iput(inode);
> > > > > > > -         return ERR_PTR(-ESTALE);
> > > > > > > +         bool is_open;
> > > > > > > +         ci = ceph_inode(inode);
> > > > > > > +         spin_lock(&ci->i_ceph_lock);
> > > > > > > +         is_open = __ceph_is_file_opened(ci);
> > > > > > > +         spin_unlock(&ci->i_ceph_lock);
> > > > > > > +         if (!is_open) {
> > > > > > > +                 iput(inode);
> > > > > > > +                 return ERR_PTR(-ESTALE);
> > > > > > > +         }
> > > > > > >   }
> > > > > > >   return d_obtain_alias(inode);
> > > > > > >  }
> > > > > >
> > > > > > Thanks Luis. Out of curiousity, is there any reason we shouldn't ignore
> > > > > > the i_nlink value here? Does anything obviously break if we do?
> > > > >
> > > > > Yes, the scenario described in commit 03f219041fdb is still valid, which
> > > > > is basically the same but without the extra open(2):
> > > > >
> > > > >   - name_to_handle_at("/cephfs/myfile")
> > > > >   - unlink("/cephfs/myfile")
> > > > >   - open_by_handle_at()
> > > > >
> > > >
> > > > Ok, I guess we end up doing some delayed cleanup, and that allows the
> > > > inode to be found in that situation.
> > > >
> > > > > The open_by_handle_at man page isn't really clear about these 2 scenarios,
> > > > > but generic/426 will fail if -ESTALE isn't returned.  Want me to add a
> > > > > comment to the code, describing these 2 scenarios?
> > > > >
> > > >
> > > > (cc'ing Amir since he added this test)
> > > >
> > > > I don't think there is any hard requirement that open_by_handle_at
> > > > should fail in that situation. It generally does for most filesystems
> > > > due to the way they handle cl794798fa xfsqa: test open_by_handle() on unlinked and freed inode clusters
> > > eaning up unlinked inodes, but I don't
> > > > think it's technically illegal to allow the inode to still be found. If
> > > > the caller cares about whether it has been unlinked it can always test
> > > > i_nlink itself.
> > > >
> > > > Amir, is this required for some reason that I'm not aware of?
> > >
> > > Hi Jeff,
> > >
> > > The origin of this test is in fstests commit:
> > > 794798fa xfsqa: test open_by_handle() on unlinked and freed inode clusters
> > >
> > > It was introduced to catch an xfs bug, so this behavior is the expectation
> > > of xfs filesystem, but note that it is not a general expectation to fail
> > > open_by_handle() after unlink(), it is an expectation to fail open_by_handle()
> > > after unlink() + sync() + drop_caches.
> >
> > Yes, sorry I should have mentioned the sync+drop_caches in the
> > description.
> >
> > > I have later converted the test to generic, because I needed to check the
> > > same expectation for overlayfs use case, which is:
> > > The original inode is always there (in lower layer), unlink creates a whiteout
> > > mark and open_by_handle should treat that as ESTALE, otherwise the
> > > unlinked files would be accessible to nfs clients forever.
> > >
>
> Ok, that makes sense.
>
> The situation with Ceph is a bit different I think. I suspect that we're
> cleaning the inode out of the client's caches after drop_caches, but
> then we end up issuing a lookup by inode number to the MDS and it
> returns an inode that it may be in the process of purging.
>
> > >
> > > In overlayfs, we handle the open file case by returning a dentry only
> > > in case the inode with deletion mark in question is already in inode cache,
> > > but we take care not to populate inode cache with the check.
> > > It is easier, because we do not need to get inode into cache for checking
> > > the delete marker.
> > >
> > > Maybe you could instead check in __fh_to_dentry():
> > >
> > >     if (inode->i_nlink == 0 && atomic_read(&inode->i_count) == 1)) {
> > >         iput(inode);
> > >         return ERR_PTR(-ESTALE);
> > >     }
> > >
> > > The above is untested, so I don't know if it's enough to pass generic/426.
> >
> > Yes, I can confirm that this also fixes the issue -- both tests pass.
> > __ceph_is_file_opened() uses some internal counters per inode, incremented
> > each time a file is open in a specific mode.  The problem is that these
> > counters require some extra locking (maybe they should be atomic_t?), so
> > you're suggestion is probably better.
> >
> > > Note that generic/467 also checks the same behavior for rmdir().
> >
> > Yeah, but the only test-case failing with cephfs is the one described
> > above (i.e. "open_by_handle -dkr ...").
> >
> > > If you decide that ceph does not need to comply to this behavior,
> > > then we probably need to whitelist/blocklist the filesystems that
> > > want to test this behavior, which will be a shame.
> >
> > Unless Jeff has any objection, I'm happy sending v2, simplifying the patch
> > to use your simpler solution (and mentioning sync+drop_caches in the
> > commit message).
> >
>
> The real question I have is whether this is truly a client-side issue,
> or if the MDS is satisfying lookup-by-ino requests with inodes that just
> haven't yet been fully purged. If so, then the right fix may be in the
> MDS.
>
> Can we determine that one way or the other?
>

Questions:
1. Does sync() result in fully purging inodes on MDS?
2. Is i_nlink synchronized among nodes on deferred delete?
IWO, can inode come back from the dead on client if another node
has linked it before i_nlink 0 was observed?
3. Can an NFS client be "migrated" from one ceph node to another
with an open but unlinked file?

I think what the test is trying to verify is that a "fully purged" inodes
cannot be opened db handle, but there is no standard way to verify
"fully purged", so the test resorts to sync() + another sync() + drop_caches.

Is there anything else that needs to be done on ceph in order to flush
all deferred operations from this client to MDS?

Thanks,
Amir.
