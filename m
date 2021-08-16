Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 372203EDCA1
	for <lists+ceph-devel@lfdr.de>; Mon, 16 Aug 2021 19:52:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232183AbhHPRx0 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 16 Aug 2021 13:53:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:33146 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229590AbhHPRx0 (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Mon, 16 Aug 2021 13:53:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1A9DC60E52;
        Mon, 16 Aug 2021 17:52:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629136374;
        bh=jR6WhEAjfImq2CbCdzAwitEJSHS3ATOzNZYG0gC2HsM=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=RYD1B/6Qwg6Awm+buWVdysbMX5DaFiURFwmL5rrGVh7mLir7H8mIi4XuZMkOd3WL1
         pm/MBCJ9/eQ0XRnmS2byGxXkxf1H6VeW/S8W6NzENAzsv194TyvUzcdfHFUK8uOEhr
         pXVqfHpjvi/IqyPfdzB8CJt96/JGBvebsV5KTq0ivsv5qh4Nu3XLsJxSchysukvlpI
         GbHrwgDX3PHb3sjMmA/shLwXpEpaPMVRDXq1akZVEcTw6SHX9bsjW3yDuvvcDMZxdl
         T7flJ3cF46AdtLS2s2HSGMt5yOIV/7XWxm6M1Vk7BX79g7riAUEamICFfMRfwSnWEz
         FkM3zGufx69Yg==
Message-ID: <62cb9a37a4a28b8a68504534f7b4bdedbca819eb.camel@kernel.org>
Subject: Re: [fscrypt][RFC PATCH] ceph: don't allow changing layout on
 encrypted files/directories
From:   Jeff Layton <jlayton@kernel.org>
To:     Luis Henriques <lhenriques@suse.de>
Cc:     ceph-devel@vger.kernel.org, linux-kernel@vger.kernel.org
Date:   Mon, 16 Aug 2021 13:52:53 -0400
In-Reply-To: <87lf51tm0l.fsf@suse.de>
References: <YRZtiL+qo95vK0Nf@suse.de>
         <e07e5f52bf73c0a9ef1441295f5ff42753d3e29a.camel@kernel.org>
         <87pmudtsho.fsf@suse.de>
         <1b55600eb096ac806ccd43c93aa0230a8cc46283.camel@kernel.org>
         <87lf51tm0l.fsf@suse.de>
Content-Type: text/plain; charset="ISO-8859-15"
User-Agent: Evolution 3.40.3 (3.40.3-1.fc34) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Mon, 2021-08-16 at 17:03 +0100, Luis Henriques wrote:
> Jeff Layton <jlayton@kernel.org> writes:
> 
> > On Mon, 2021-08-16 at 14:43 +0100, Luis Henriques wrote:
> > > Jeff Layton <jlayton@kernel.org> writes:
> > > 
> > > > On Fri, 2021-08-13 at 14:03 +0100, Luis Henriques wrote:
> > > > > Encryption is currently only supported on files/directories with layouts
> > > > > where stripe_count=1.  Forbid changing layouts when encryption is involved.
> > > > > 
> > > > > Signed-off-by: Luis Henriques <lhenriques@suse.de>
> > > > > ---
> > > > > Hi!
> > > > > 
> > > > > While continuing looking into fscrypt, I realized we're not yet forbidding
> > > > > different layouts on encrypted files.  This patch tries to do just that.
> > > > > 
> > > > > Regarding the setxattr, I've also made a change [1] to the MDS code so that it
> > > > > also prevents layouts to be changed.  This should make the changes to
> > > > > ceph_sync_setxattr() redundant, but in practice it doesn't because if we encrypt
> > > > > a directory and immediately after that we change that directory layout, the MDS
> > > > > wouldn't yet have received the fscrypt_auth for that inode.  So... yeah, an
> > > > > alternative would be to propagate the fscrypt context immediately after
> > > > > encrypting a directory.
> > > > > 
> > > > > [1] https://github.com/luis-henrix/ceph/commit/601488ae798ecfa5ec81677d1ced02f7dd42aa10
> > > > > 
> > > > > Cheers,
> > > > > --
> > > > > Luis
> > > > > 
> > > > >  fs/ceph/ioctl.c | 4 ++++
> > > > >  fs/ceph/xattr.c | 6 ++++++
> > > > >  2 files changed, 10 insertions(+)
> > > > > 
> > > > > diff --git a/fs/ceph/ioctl.c b/fs/ceph/ioctl.c
> > > > > index 477ecc667aee..42abfc564301 100644
> > > > > --- a/fs/ceph/ioctl.c
> > > > > +++ b/fs/ceph/ioctl.c
> > > > > @@ -294,6 +294,10 @@ static long ceph_set_encryption_policy(struct file *file, unsigned long arg)
> > > > >  	struct inode *inode = file_inode(file);
> > > > >  	struct ceph_inode_info *ci = ceph_inode(inode);
> > > > >  
> > > > > +	/* encrypted directories can't have striped layout */
> > > > > +	if (ci->i_layout.stripe_count > 1)
> > > > > +		return -EOPNOTSUPP;
> > > > > +
> > > > 
> > > > Yes, I've been needing to add that for a while. I'm not sure EOPNOTSUPP
> > > > is the right error code though. Maybe EINVAL instead?
> > > > 
> > > 
> > > Right, I had that initially and changed it after a long indecision.  But
> > > yeah, I've no strong opinion either way.
> > > 
> > 
> > It's a judgement call, really...
> > 
> > > > 
> > > > >  	ret = vet_mds_for_fscrypt(file);
> > > > >  	if (ret)
> > > > >  		return ret;
> > > > > diff --git a/fs/ceph/xattr.c b/fs/ceph/xattr.c
> > > > > index b175b3029dc0..7921cb34900c 100644
> > > > > --- a/fs/ceph/xattr.c
> > > > > +++ b/fs/ceph/xattr.c
> > > > > @@ -1051,6 +1051,12 @@ static int ceph_sync_setxattr(struct inode *inode, const char *name,
> > > > >  	int op = CEPH_MDS_OP_SETXATTR;
> > > > >  	int err;
> > > > >  
> > > > > +	/* encrypted directories/files can't have their layout changed */
> > > > > +	if (IS_ENCRYPTED(inode) &&
> > > > > +	    (!strncmp(name, "ceph.file.layout", 16) ||
> > > > > +	     !strncmp(name, "ceph.dir.layout", 15)))
> > > > > +		return -EOPNOTSUPP;
> > > > > +
> > > > 
> > > > Yuck.
> > > 
> > > Agreed!
> > > 
> > > > What might be nicer is to just make ceph_vxattrcb_layout* return an
> > > > error when the inode is encrypted? You can return negative error codes
> > > > from the ->getxattr_cb ops, and that's probably the better place to
> > > > check for this.
> > > 
> > > I'm not sure I understand your suggestion.  This is on the SETXATTR path,
> > > so we'll need to block attempts to send this operation to the MDS.
> > > 
> > 
> > Doh! You're correct -- I was thinking about getxattr, but setxattr
> > doesn't have the same ops vectors. We could add a new option to vet
> > setxattr requests locally, but that might not be sufficient actually...
> > 
> > > An alternative would be to do this (return an error) on the MDS side, but
> > > this would mean that we should also send the fscrypt fields to the MDS
> > > because it may may not know yet that the inode is encrypted.  Which could
> > > be the correct thing to do BTW.  Although I don't think client B could
> > > concurrently change the layout of a directory that client A just set as
> > > encrypted without client A sending that information to the MDS first...
> > > 
> > 
> > Now that I think about it some more, we probably need to let the MDS vet
> > these requests.
> 
> Sure, and that's what I tried to do with the MDS patch in [1].  I'm not
> confident that's safe enough, although I _think_ the case you describe:
> 
>  client A                             client B
>                                       mkdir XYZ
>  lookup inode XYZ
>  setxattr (set layout)                encrypt XYZ
> 
> should be protected with the right caps + MDS locks.  But I'll go look
> closer because I *know* I am still missing something.
> 
> [1] https://github.com/luis-henrix/ceph/commit/601488ae798ecfa5ec81677d1ced02f7dd42aa10
> 
> Cheers,

Yep, that's basically what I was thinking.

As I look again, I think we have a similar ToC/ToU race in the
ceph_set_encryption_policy part of the patch too. That layout check is
done without any locking or caps held. I think we could end up with a
similar race there too, where another task or client changes the layout
just after we've checked it.

It's not clear to me what caps we need to hold to ensure that the layout
remains stable. I guess I need to go stare at the MDS code some more...
-- 
Jeff Layton <jlayton@kernel.org>

