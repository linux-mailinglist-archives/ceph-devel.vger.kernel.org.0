Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 24DF41D8AF0
	for <lists+ceph-devel@lfdr.de>; Tue, 19 May 2020 00:30:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728318AbgERWa1 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 18 May 2020 18:30:27 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:52294 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728237AbgERWa0 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 18 May 2020 18:30:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589841024;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=C/P9duv0/aKfl2c6GRTv9GRqCSazu3j7j2Hfg4zLJaA=;
        b=BVsbw7pThNJhSMEemv9rmjVqWViuGOc2c//YV0lXdXwB+I7i9YNYhcdyVqlVhcUIt0JLSe
        /fhTH6Bd4GtPRd8kmouwT3eZhk9Pj8sAjPasId2l8V736l8vRwk6BB/bxdJ47Nho6DRKBD
        SXAIrPPFzBbjl/QFdcDdVDJeEuLmFVI=
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com
 [209.85.219.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-71-Hmis4RiFPnmo-mLNM_fB3Q-1; Mon, 18 May 2020 18:30:22 -0400
X-MC-Unique: Hmis4RiFPnmo-mLNM_fB3Q-1
Received: by mail-qv1-f69.google.com with SMTP id cf17so12101928qvb.1
        for <ceph-devel@vger.kernel.org>; Mon, 18 May 2020 15:30:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=C/P9duv0/aKfl2c6GRTv9GRqCSazu3j7j2Hfg4zLJaA=;
        b=bBfcxvatvcZmGHee31zGUDadqKzeUpZKNi0lFERv5EZSBXhZjfcc13cH6F219gVxks
         CvPQBb/CUtFSQOlUTKd5g75wwU6JQ/3n4VzcwlyQ/LZC+0OIL9p7qzKjKwTGrKEVrwls
         Qk6G/RxkjnUk+X3oioVTAF4axkk4u3nTFsdgWNTiZsEU0FaPIZ+i9oSH5uqe+ulqpfL0
         ulLQoVSANMoXYuuv2u90A9reoXZ7H6GR01bkOQupi+IApLDkbgzoNtAb8h/nWL6X6vnQ
         k9mfcECQmMD+D5Uoay7DASZhof1ljbBo6lcqcXXHRycWFADqj9IUfvIignWQATjIkM0X
         cV5w==
X-Gm-Message-State: AOAM533mgbERQm7dBxoxBgDvl89R5TxBZSqPO/OeAIxhBvzEVaOjy0GV
        aL6o63eMFz/Erq6tCHIT3i6h89gqNcVrp/mN+E9vkI4rTZTBoCnyeqi5KovuUPUvUs0D91hGCFm
        z4VPr+HMgvu78ZPldy4qi37XtvT1WhTet2He4Eg==
X-Received: by 2002:a37:d92:: with SMTP id 140mr17687314qkn.426.1589841021539;
        Mon, 18 May 2020 15:30:21 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJz9Fl1T1Bjj+QaEHFJFp5emHB87/fFJq+eicr2/lhbUTABu4TLDQgGHrI6L1oqNUv6gpjFvffNm1aOji0HS+rk=
X-Received: by 2002:a37:d92:: with SMTP id 140mr17687270qkn.426.1589841020918;
 Mon, 18 May 2020 15:30:20 -0700 (PDT)
MIME-Version: 1.0
References: <20200514111453.GA99187@suse.com> <8497fe9a11ac1837813ee5f14b6ebae8fa6bf707.camel@kernel.org>
 <20200514124845.GA12559@suse.com> <4e5bf0e3bf055e53a342b19d168f6cf441781973.camel@kernel.org>
 <CAOQ4uxhireZBRvcPQzTS8yOoO4gQt78M0ktZo-9yQ-zcaLZbow@mail.gmail.com>
 <20200515111548.GA54598@suse.com> <61b1f19edcc349641b5383c2ac70cbf9a15ba4bd.camel@kernel.org>
 <CAOQ4uxiWZoSj3Pjwskd_hu-ErV9096hLt13CDcW6nEEvcwDNVA@mail.gmail.com> <e227d42fdc91587e34bc64ac252970d39d9b4eee.camel@kernel.org>
In-Reply-To: <e227d42fdc91587e34bc64ac252970d39d9b4eee.camel@kernel.org>
From:   Gregory Farnum <gfarnum@redhat.com>
Date:   Mon, 18 May 2020 15:30:09 -0700
Message-ID: <CAJ4mKGbahd8CbkEauBHBX6o93jipkCVoYe9O-1rAJQJFZkqDsQ@mail.gmail.com>
Subject: Re: [PATCH] ceph: don't return -ESTALE if there's still an open file
To:     Jeff Layton <jlayton@kernel.org>
Cc:     Amir Goldstein <amir73il@gmail.com>,
        Luis Henriques <lhenriques@suse.com>,
        Ilya Dryomov <idryomov@gmail.com>,
        ceph-devel <ceph-devel@vger.kernel.org>,
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

Maybe we resolved this conversation; I can't quite tell...

On Fri, May 15, 2020 at 12:16 PM Jeff Layton <jlayton@kernel.org> wrote:
>
> On Fri, 2020-05-15 at 19:56 +0300, Amir Goldstein wrote:
> > On Fri, May 15, 2020 at 2:38 PM Jeff Layton <jlayton@kernel.org> wrote:
> > > On Fri, 2020-05-15 at 12:15 +0100, Luis Henriques wrote:
> > > > On Fri, May 15, 2020 at 09:42:24AM +0300, Amir Goldstein wrote:
> > > > > +CC: fstests
> > > > >
> > > > > On Thu, May 14, 2020 at 4:15 PM Jeff Layton <jlayton@kernel.org> wrote:
> > > > > > On Thu, 2020-05-14 at 13:48 +0100, Luis Henriques wrote:
> > > > > > > On Thu, May 14, 2020 at 08:10:09AM -0400, Jeff Layton wrote:
> > > > > > > > On Thu, 2020-05-14 at 12:14 +0100, Luis Henriques wrote:
> > > > > > > > > Similarly to commit 03f219041fdb ("ceph: check i_nlink while converting
> > > > > > > > > a file handle to dentry"), this fixes another corner case with
> > > > > > > > > name_to_handle_at/open_by_handle_at.  The issue has been detected by
> > > > > > > > > xfstest generic/467, when doing:
> > > > > > > > >
> > > > > > > > >  - name_to_handle_at("/cephfs/myfile")
> > > > > > > > >  - open("/cephfs/myfile")
> > > > > > > > >  - unlink("/cephfs/myfile")
> > > > > > > > >  - open_by_handle_at()
> > > > > > > > >
> > > > > > > > > The call to open_by_handle_at should not fail because the file still
> > > > > > > > > exists and we do have a valid handle to it.
> > > > > > > > >
> > > > > > > > > Signed-off-by: Luis Henriques <lhenriques@suse.com>
> > > > > > > > > ---
> > > > > > > > >  fs/ceph/export.c | 13 +++++++++++--
> > > > > > > > >  1 file changed, 11 insertions(+), 2 deletions(-)
> > > > > > > > >
> > > > > > > > > diff --git a/fs/ceph/export.c b/fs/ceph/export.c
> > > > > > > > > index 79dc06881e78..8556df9d94d0 100644
> > > > > > > > > --- a/fs/ceph/export.c
> > > > > > > > > +++ b/fs/ceph/export.c
> > > > > > > > > @@ -171,12 +171,21 @@ struct inode *ceph_lookup_inode(struct super_block *sb, u64 ino)
> > > > > > > > >
> > > > > > > > >  static struct dentry *__fh_to_dentry(struct super_block *sb, u64 ino)
> > > > > > > > >  {
> > > > > > > > > + struct ceph_inode_info *ci;
> > > > > > > > >   struct inode *inode = __lookup_inode(sb, ino);
> > > > > > > > > +
> > > > > > > > >   if (IS_ERR(inode))
> > > > > > > > >           return ERR_CAST(inode);
> > > > > > > > >   if (inode->i_nlink == 0) {
> > > > > > > > > -         iput(inode);
> > > > > > > > > -         return ERR_PTR(-ESTALE);
> > > > > > > > > +         bool is_open;
> > > > > > > > > +         ci = ceph_inode(inode);
> > > > > > > > > +         spin_lock(&ci->i_ceph_lock);
> > > > > > > > > +         is_open = __ceph_is_file_opened(ci);
> > > > > > > > > +         spin_unlock(&ci->i_ceph_lock);
> > > > > > > > > +         if (!is_open) {
> > > > > > > > > +                 iput(inode);
> > > > > > > > > +                 return ERR_PTR(-ESTALE);
> > > > > > > > > +         }
> > > > > > > > >   }
> > > > > > > > >   return d_obtain_alias(inode);
> > > > > > > > >  }
> > > > > > > >
> > > > > > > > Thanks Luis. Out of curiousity, is there any reason we shouldn't ignore
> > > > > > > > the i_nlink value here? Does anything obviously break if we do?
> > > > > > >
> > > > > > > Yes, the scenario described in commit 03f219041fdb is still valid, which
> > > > > > > is basically the same but without the extra open(2):
> > > > > > >
> > > > > > >   - name_to_handle_at("/cephfs/myfile")
> > > > > > >   - unlink("/cephfs/myfile")
> > > > > > >   - open_by_handle_at()
> > > > > > >
> > > > > >
> > > > > > Ok, I guess we end up doing some delayed cleanup, and that allows the
> > > > > > inode to be found in that situation.
> > > > > >
> > > > > > > The open_by_handle_at man page isn't really clear about these 2 scenarios,
> > > > > > > but generic/426 will fail if -ESTALE isn't returned.  Want me to add a
> > > > > > > comment to the code, describing these 2 scenarios?
> > > > > > >
> > > > > >
> > > > > > (cc'ing Amir since he added this test)
> > > > > >
> > > > > > I don't think there is any hard requirement that open_by_handle_at
> > > > > > should fail in that situation. It generally does for most filesystems
> > > > > > due to the way they handle cl794798fa xfsqa: test open_by_handle() on unlinked and freed inode clusters
> > > > > eaning up unlinked inodes, but I don't
> > > > > > think it's technically illegal to allow the inode to still be found. If
> > > > > > the caller cares about whether it has been unlinked it can always test
> > > > > > i_nlink itself.
> > > > > >
> > > > > > Amir, is this required for some reason that I'm not aware of?
> > > > >
> > > > > Hi Jeff,
> > > > >
> > > > > The origin of this test is in fstests commit:
> > > > > 794798fa xfsqa: test open_by_handle() on unlinked and freed inode clusters
> > > > >
> > > > > It was introduced to catch an xfs bug, so this behavior is the expectation
> > > > > of xfs filesystem, but note that it is not a general expectation to fail
> > > > > open_by_handle() after unlink(), it is an expectation to fail open_by_handle()
> > > > > after unlink() + sync() + drop_caches.
> > > >
> > > > Yes, sorry I should have mentioned the sync+drop_caches in the
> > > > description.
> > > >
> > > > > I have later converted the test to generic, because I needed to check the
> > > > > same expectation for overlayfs use case, which is:
> > > > > The original inode is always there (in lower layer), unlink creates a whiteout
> > > > > mark and open_by_handle should treat that as ESTALE, otherwise the
> > > > > unlinked files would be accessible to nfs clients forever.
> > > > >
> > >
> > > Ok, that makes sense.
> > >
> > > The situation with Ceph is a bit different I think. I suspect that we're
> > > cleaning the inode out of the client's caches after drop_caches, but
> > > then we end up issuing a lookup by inode number to the MDS and it
> > > returns an inode that it may be in the process of purging.
> > >
> > > > > In overlayfs, we handle the open file case by returning a dentry only
> > > > > in case the inode with deletion mark in question is already in inode cache,
> > > > > but we take care not to populate inode cache with the check.
> > > > > It is easier, because we do not need to get inode into cache for checking
> > > > > the delete marker.
> > > > >
> > > > > Maybe you could instead check in __fh_to_dentry():
> > > > >
> > > > >     if (inode->i_nlink == 0 && atomic_read(&inode->i_count) == 1)) {
> > > > >         iput(inode);
> > > > >         return ERR_PTR(-ESTALE);
> > > > >     }
> > > > >
> > > > > The above is untested, so I don't know if it's enough to pass generic/426.
> > > >
> > > > Yes, I can confirm that this also fixes the issue -- both tests pass.
> > > > __ceph_is_file_opened() uses some internal counters per inode, incremented
> > > > each time a file is open in a specific mode.  The problem is that these
> > > > counters require some extra locking (maybe they should be atomic_t?), so
> > > > you're suggestion is probably better.
> > > >
> > > > > Note that generic/467 also checks the same behavior for rmdir().
> > > >
> > > > Yeah, but the only test-case failing with cephfs is the one described
> > > > above (i.e. "open_by_handle -dkr ...").
> > > >
> > > > > If you decide that ceph does not need to comply to this behavior,
> > > > > then we probably need to whitelist/blocklist the filesystems that
> > > > > want to test this behavior, which will be a shame.
> > > >
> > > > Unless Jeff has any objection, I'm happy sending v2, simplifying the patch
> > > > to use your simpler solution (and mentioning sync+drop_caches in the
> > > > commit message).
> > > >
> > >
> > > The real question I have is whether this is truly a client-side issue,
> > > or if the MDS is satisfying lookup-by-ino requests with inodes that just
> > > haven't yet been fully purged. If so, then the right fix may be in the
> > > MDS.
> > >
> > > Can we determine that one way or the other?
> > >
> >
> > Questions:
> > 1. Does sync() result in fully purging inodes on MDS?
>
> I don't think so, but again, that code is not trivial to follow. I do
> know that the MDS keeps around a "strays directory" which contains
> unlinked inodes that are lazily cleaned up. My suspicion is that it's
> satisfying lookups out of this cache as well.
>
> Which may be fine...the MDS is not required to be POSIX compliant after
> all. Only the fs drivers are.

I don't think this is quite that simple. Yes, the MDS is certainly
giving back stray inodes in response to a lookup-by-ino request. But
that's for a specific purpose: we need to be able to give back caps on
unlinked-but-open files. For NFS specifically, I don't know what the
rules are on NFS file handles and unlinked files, but the Ceph MDS
won't know when files are closed everywhere, and it translates from
NFS fh to Ceph inode using that lookup-by-ino functionality.

>
> > 2. Is i_nlink synchronized among nodes on deferred delete?
> > IWO, can inode come back from the dead on client if another node
> > has linked it before i_nlink 0 was observed?
>
> No, that shouldn't happen. The caps mechanism should ensure that it
> can't be observed by other clients until after the change.
>
> That said, Luis' current patch doesn't ensure we have the correct caps
> to check the i_nlink. We may need to add that in before we can roll with
> this.
>
> > 3. Can an NFS client be "migrated" from one ceph node to another
> > with an open but unlinked file?
> >
>
> No. Open files in ceph are generally per-client. You can't pass around a
> fd (or equivalent).

But the NFS file handles I think do work across clients, right?

-Greg

