Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0604234EE8A
	for <lists+ceph-devel@lfdr.de>; Tue, 30 Mar 2021 18:54:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232459AbhC3QyY (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 30 Mar 2021 12:54:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:59708 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232319AbhC3Qxw (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Tue, 30 Mar 2021 12:53:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1B34061928;
        Tue, 30 Mar 2021 16:53:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617123232;
        bh=wHyokMBJExOMFMnfOGwIISS5+NEOWdUEUjgRLC3woag=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=dg+5iaUKD6r7xXO2ISLNafmBg44m8xKvzCEg5/DaE+YnMqvbEBWbjMMpDoYMpgEdi
         w+s9wnojv9ATjtq3C17FLLAO3718KxuG///5M4PhnHEYv8EWUPfvFn0ml3ZtJUaVDj
         IGvVACOALztEkSRsBbIQzpBHlrpZtmqOwbdtokD4TW8sinnjjo1jjuXqk94Wl7MiSJ
         H091DMNSW9s5w4KY5Q9zIwviRveI+kYouGNv6TlaZPu+dqSt4anSh0iwMFqVGxHgKo
         wbDCzCYFakN4NfLM8zO5fcruZs/fflUm1a4IvtO+rbUhOTr4Rw90w71EHKlKofWjES
         cWtQUOtcB1Gsw==
Message-ID: <c434172e4d53cdbb1414eee1c22408996e10a3ed.camel@kernel.org>
Subject: Re: [PATCH] ceph: fix inode leak on getattr error in __fh_to_dentry
From:   Jeff Layton <jlayton@kernel.org>
To:     Luis Henriques <lhenriques@suse.de>
Cc:     ceph-devel@vger.kernel.org, idryomov@gmail.com
Date:   Tue, 30 Mar 2021 12:53:51 -0400
In-Reply-To: <YGMro0mhz1sIk7Q8@suse.de>
References: <20210326154032.86410-1-jlayton@kernel.org>
         <YGMro0mhz1sIk7Q8@suse.de>
Content-Type: text/plain; charset="ISO-8859-15"
User-Agent: Evolution 3.38.4 (3.38.4-1.fc33) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Tue, 2021-03-30 at 14:46 +0100, Luis Henriques wrote:
> On Fri, Mar 26, 2021 at 11:40:32AM -0400, Jeff Layton wrote:
> > Cc: Luis Henriques <lhenriques@suse.de>
> > Fixes: 878dabb64117 (ceph: don't return -ESTALE if there's still an open file)
> > Signed-off-by: Jeff Layton <jlayton@kernel.org>
> > ---
> >  fs/ceph/export.c | 4 +++-
> >  1 file changed, 3 insertions(+), 1 deletion(-)
> > 
> > diff --git a/fs/ceph/export.c b/fs/ceph/export.c
> > index f22156ee7306..17d8c8f4ec89 100644
> > --- a/fs/ceph/export.c
> > +++ b/fs/ceph/export.c
> > @@ -178,8 +178,10 @@ static struct dentry *__fh_to_dentry(struct super_block *sb, u64 ino)
> >  		return ERR_CAST(inode);
> >  	/* We need LINK caps to reliably check i_nlink */
> >  	err = ceph_do_getattr(inode, CEPH_CAP_LINK_SHARED, false);
> > -	if (err)
> > +	if (err) {
> > +		iput(inode);
> 
> To be honest, I'm failing to see where we could be leaking the inode here.
> We're trying to get LINK caps to do the check bellow; if ceph_do_getattr()
> fails, the inode reference it (may) grabs will be released by calling
> ceph_mdsc_put_request().
> 
> Do you see any other possibility?
> 

We already hold a reference to the inode at this point by virtue of the
successful return from __lookup_inode. ceph_do_getattr does not consume
that reference on success or failure, AFAICT.

-- 
Jeff Layton <jlayton@kernel.org>

