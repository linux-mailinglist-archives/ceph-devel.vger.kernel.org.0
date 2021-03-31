Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D7B4234FD78
	for <lists+ceph-devel@lfdr.de>; Wed, 31 Mar 2021 11:52:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234773AbhCaJwN (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 31 Mar 2021 05:52:13 -0400
Received: from mx2.suse.de ([195.135.220.15]:46614 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234800AbhCaJwH (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Wed, 31 Mar 2021 05:52:07 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id AE7ACAF13;
        Wed, 31 Mar 2021 09:52:03 +0000 (UTC)
Received: from localhost (brahms [local])
        by brahms (OpenSMTPD) with ESMTPA id ded4d69c;
        Wed, 31 Mar 2021 09:53:24 +0000 (UTC)
Date:   Wed, 31 Mar 2021 10:53:24 +0100
From:   Luis Henriques <lhenriques@suse.de>
To:     Jeff Layton <jlayton@kernel.org>
Cc:     ceph-devel@vger.kernel.org, idryomov@gmail.com
Subject: Re: [PATCH] ceph: fix inode leak on getattr error in __fh_to_dentry
Message-ID: <YGRGlH/INmTuV2uw@suse.de>
References: <20210326154032.86410-1-jlayton@kernel.org>
 <YGMro0mhz1sIk7Q8@suse.de>
 <c434172e4d53cdbb1414eee1c22408996e10a3ed.camel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <c434172e4d53cdbb1414eee1c22408996e10a3ed.camel@kernel.org>
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Tue, Mar 30, 2021 at 12:53:51PM -0400, Jeff Layton wrote:
> On Tue, 2021-03-30 at 14:46 +0100, Luis Henriques wrote:
> > On Fri, Mar 26, 2021 at 11:40:32AM -0400, Jeff Layton wrote:
> > > Cc: Luis Henriques <lhenriques@suse.de>
> > > Fixes: 878dabb64117 (ceph: don't return -ESTALE if there's still an open file)
> > > Signed-off-by: Jeff Layton <jlayton@kernel.org>
> > > ---
> > >  fs/ceph/export.c | 4 +++-
> > >  1 file changed, 3 insertions(+), 1 deletion(-)
> > > 
> > > diff --git a/fs/ceph/export.c b/fs/ceph/export.c
> > > index f22156ee7306..17d8c8f4ec89 100644
> > > --- a/fs/ceph/export.c
> > > +++ b/fs/ceph/export.c
> > > @@ -178,8 +178,10 @@ static struct dentry *__fh_to_dentry(struct super_block *sb, u64 ino)
> > >  		return ERR_CAST(inode);
> > >  	/* We need LINK caps to reliably check i_nlink */
> > >  	err = ceph_do_getattr(inode, CEPH_CAP_LINK_SHARED, false);
> > > -	if (err)
> > > +	if (err) {
> > > +		iput(inode);
> > 
> > To be honest, I'm failing to see where we could be leaking the inode here.
> > We're trying to get LINK caps to do the check bellow; if ceph_do_getattr()
> > fails, the inode reference it (may) grabs will be released by calling
> > ceph_mdsc_put_request().
> > 
> > Do you see any other possibility?
> > 
> 
> We already hold a reference to the inode at this point by virtue of the
> successful return from __lookup_inode. ceph_do_getattr does not consume
> that reference on success or failure, AFAICT.

Doh!  Of course.  I was looking at it the wrong way.

Cheers,
--
Luís
