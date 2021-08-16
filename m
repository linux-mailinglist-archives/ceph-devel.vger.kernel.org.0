Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3FCB33ED871
	for <lists+ceph-devel@lfdr.de>; Mon, 16 Aug 2021 16:01:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236445AbhHPOCP (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 16 Aug 2021 10:02:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:38136 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232016AbhHPOB7 (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Mon, 16 Aug 2021 10:01:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5EB9D60EFF;
        Mon, 16 Aug 2021 14:01:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629122487;
        bh=2mpYzkLZb4kYGiW8RMpFajY82itQqH2luY1auq7wYMI=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=fIgpAn1RwE4CaJM8PC60SMUk6hD17KthKA5xXFjEWH0Qeq9fPvUJd7rpnNa0XI2Dp
         nm/FWtcIls7V2tfzpTrggLQ7oJNGTJbzJmJTcYsmd0MkIDTBvBJ1sJIPIBvKrwI6Xx
         TqoGHqLtF345gyVNuGBHS2OILfs6YZ3gQrq+aL4R8sWmUxmtfEm+2D8WPoHxFG2DPZ
         xtZiJRmX5p4HiRN9luAhFhACfJxdH/bgG9L0iVyViMB7UnMu6cduSlC/PfWmS1TAeU
         0lsiiIV8moLwcQHcMLbjio9qpOXO5cjcUuPSd9ojHJT5dL5bMC1+5RII7hTnohckhK
         yIgqUhq3TRBHA==
Message-ID: <1b55600eb096ac806ccd43c93aa0230a8cc46283.camel@kernel.org>
Subject: Re: [fscrypt][RFC PATCH] ceph: don't allow changing layout on
 encrypted files/directories
From:   Jeff Layton <jlayton@kernel.org>
To:     Luis Henriques <lhenriques@suse.de>
Cc:     ceph-devel@vger.kernel.org, linux-kernel@vger.kernel.org
Date:   Mon, 16 Aug 2021 10:01:26 -0400
In-Reply-To: <87pmudtsho.fsf@suse.de>
References: <YRZtiL+qo95vK0Nf@suse.de>
         <e07e5f52bf73c0a9ef1441295f5ff42753d3e29a.camel@kernel.org>
         <87pmudtsho.fsf@suse.de>
Content-Type: text/plain; charset="ISO-8859-15"
User-Agent: Evolution 3.40.3 (3.40.3-1.fc34) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Mon, 2021-08-16 at 14:43 +0100, Luis Henriques wrote:
> Jeff Layton <jlayton@kernel.org> writes:
> 
> > On Fri, 2021-08-13 at 14:03 +0100, Luis Henriques wrote:
> > > Encryption is currently only supported on files/directories with layouts
> > > where stripe_count=1.  Forbid changing layouts when encryption is involved.
> > > 
> > > Signed-off-by: Luis Henriques <lhenriques@suse.de>
> > > ---
> > > Hi!
> > > 
> > > While continuing looking into fscrypt, I realized we're not yet forbidding
> > > different layouts on encrypted files.  This patch tries to do just that.
> > > 
> > > Regarding the setxattr, I've also made a change [1] to the MDS code so that it
> > > also prevents layouts to be changed.  This should make the changes to
> > > ceph_sync_setxattr() redundant, but in practice it doesn't because if we encrypt
> > > a directory and immediately after that we change that directory layout, the MDS
> > > wouldn't yet have received the fscrypt_auth for that inode.  So... yeah, an
> > > alternative would be to propagate the fscrypt context immediately after
> > > encrypting a directory.
> > > 
> > > [1] https://github.com/luis-henrix/ceph/commit/601488ae798ecfa5ec81677d1ced02f7dd42aa10
> > > 
> > > Cheers,
> > > --
> > > Luis
> > > 
> > >  fs/ceph/ioctl.c | 4 ++++
> > >  fs/ceph/xattr.c | 6 ++++++
> > >  2 files changed, 10 insertions(+)
> > > 
> > > diff --git a/fs/ceph/ioctl.c b/fs/ceph/ioctl.c
> > > index 477ecc667aee..42abfc564301 100644
> > > --- a/fs/ceph/ioctl.c
> > > +++ b/fs/ceph/ioctl.c
> > > @@ -294,6 +294,10 @@ static long ceph_set_encryption_policy(struct file *file, unsigned long arg)
> > >  	struct inode *inode = file_inode(file);
> > >  	struct ceph_inode_info *ci = ceph_inode(inode);
> > >  
> > > +	/* encrypted directories can't have striped layout */
> > > +	if (ci->i_layout.stripe_count > 1)
> > > +		return -EOPNOTSUPP;
> > > +
> > 
> > Yes, I've been needing to add that for a while. I'm not sure EOPNOTSUPP
> > is the right error code though. Maybe EINVAL instead?
> > 
> 
> Right, I had that initially and changed it after a long indecision.  But
> yeah, I've no strong opinion either way.
> 

It's a judgement call, really...

> > 
> > >  	ret = vet_mds_for_fscrypt(file);
> > >  	if (ret)
> > >  		return ret;
> > > diff --git a/fs/ceph/xattr.c b/fs/ceph/xattr.c
> > > index b175b3029dc0..7921cb34900c 100644
> > > --- a/fs/ceph/xattr.c
> > > +++ b/fs/ceph/xattr.c
> > > @@ -1051,6 +1051,12 @@ static int ceph_sync_setxattr(struct inode *inode, const char *name,
> > >  	int op = CEPH_MDS_OP_SETXATTR;
> > >  	int err;
> > >  
> > > +	/* encrypted directories/files can't have their layout changed */
> > > +	if (IS_ENCRYPTED(inode) &&
> > > +	    (!strncmp(name, "ceph.file.layout", 16) ||
> > > +	     !strncmp(name, "ceph.dir.layout", 15)))
> > > +		return -EOPNOTSUPP;
> > > +
> > 
> > Yuck.
> 
> Agreed!
> 
> > What might be nicer is to just make ceph_vxattrcb_layout* return an
> > error when the inode is encrypted? You can return negative error codes
> > from the ->getxattr_cb ops, and that's probably the better place to
> > check for this.
> 
> I'm not sure I understand your suggestion.  This is on the SETXATTR path,
> so we'll need to block attempts to send this operation to the MDS.
> 

Doh! You're correct -- I was thinking about getxattr, but setxattr
doesn't have the same ops vectors. We could add a new option to vet
setxattr requests locally, but that might not be sufficient actually...

> An alternative would be to do this (return an error) on the MDS side, but
> this would mean that we should also send the fscrypt fields to the MDS
> because it may may not know yet that the inode is encrypted.  Which could
> be the correct thing to do BTW.  Although I don't think client B could
> concurrently change the layout of a directory that client A just set as
> encrypted without client A sending that information to the MDS first...
> 

Now that I think about it some more, we probably need to let the MDS vet
these requests. It's possible that we'd do a lookup of the inode and
then call setxattr on it concurrently with another client making the
inode encrypted.

We could ensure that we have As caps here to try to prevent that, but it
hardly seems worthwhile. These are not commonly changed. It seems best
to just let the MDS gather the appropriate locks and handle it there.

-- 
Jeff Layton <jlayton@kernel.org>

