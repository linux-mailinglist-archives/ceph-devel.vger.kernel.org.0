Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 524DC367085
	for <lists+ceph-devel@lfdr.de>; Wed, 21 Apr 2021 18:48:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240047AbhDUQt2 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 21 Apr 2021 12:49:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:36108 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238466AbhDUQt1 (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Wed, 21 Apr 2021 12:49:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D1F9561449;
        Wed, 21 Apr 2021 16:48:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1619023734;
        bh=K/7ksMNs9kdK0B6JHPyW9VMQNn7IJHDKG/uPnQEZHJ0=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=KYWTWms0347nidZScuN+3D0J/T/vz3Ofbfovcsh2uP291Twoq4wHmr7SHTQYcjT+I
         uLlV7INLSxhwQgGJnvCA23ne7lDHrLkHzSAVD95xkCyhpDrTJwG0JQCwEOj5nZ/xC3
         /2toUJ38zxgMeJswWDyRt3r8jKfw+WlW1pYnkkNOKVvBSOpGOVWNqEh+rcmn0SNn4Q
         tJNB+OrEEXV4EUR6vhNlC5ZA9JjBT54FraAAY9YEVWhyp0wxCdi3ry9NmwORzVm/Ej
         w0dYBq450uuVx8buVGuIB1qqynoJFpvBNNrzcHs36HTa1+B37ZxUET6aQuuMqLGcvM
         Hkm4JAUXewT9w==
Message-ID: <2b839c9fc74107dcf4b797aef179374a34862cb2.camel@kernel.org>
Subject: Re: [PATCH v2] ceph: don't allow access to MDS-private inodes
From:   Jeff Layton <jlayton@kernel.org>
To:     Luis Henriques <lhenriques@suse.de>
Cc:     ceph-devel@vger.kernel.org, xiubli@redhat.com, pdonnell@redhat.com,
        idryomov@redhat.com
Date:   Wed, 21 Apr 2021 12:48:52 -0400
In-Reply-To: <87h7jzy5d2.fsf@suse.de>
References: <20210420140639.33705-1-jlayton@kernel.org>
         <87h7jzy5d2.fsf@suse.de>
Content-Type: text/plain; charset="ISO-8859-15"
User-Agent: Evolution 3.40.0 (3.40.0-1.fc34) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Wed, 2021-04-21 at 17:22 +0100, Luis Henriques wrote:
> Jeff Layton <jlayton@kernel.org> writes:
> 
> > The MDS reserves a set of inodes for its own usage, and these should
> > never be accessible to clients. Add a new helper to vet a proposed
> > inode number against that range, and complain loudly and refuse to
> > create or look it up if it's in it. We do need to carve out an exception
> > for the root and the lost+found directories.
> > 
> > Also, ensure that the MDS doesn't try to delegate that range to us
> > either. Print a warning if it does, and don't save the range in the
> > xarray.
> > 
> > URL: https://tracker.ceph.com/issues/49922
> > Signed-off-by: Jeff Layton <jlayton@kernel.org>
> > Signed-off-by: Xiubo Li<xiubli@redhat.com>
> > Reviewed-by: Patrick Donnelly <pdonnell@redhat.com>
> > ---
> >  fs/ceph/export.c             |  8 ++++++++
> >  fs/ceph/inode.c              |  3 +++
> >  fs/ceph/mds_client.c         |  7 +++++++
> >  fs/ceph/super.h              | 24 ++++++++++++++++++++++++
> >  include/linux/ceph/ceph_fs.h |  7 ++++---
> >  5 files changed, 46 insertions(+), 3 deletions(-)
> > 
> > v2: allow lookups of lost+found dir inodes
> >     flesh out and update the CEPH_INO_* definitions
> > 
> > diff --git a/fs/ceph/export.c b/fs/ceph/export.c
> > index 17d8c8f4ec89..65540a4429b2 100644
> > --- a/fs/ceph/export.c
> > +++ b/fs/ceph/export.c
> > @@ -129,6 +129,10 @@ static struct inode *__lookup_inode(struct super_block *sb, u64 ino)
> >  
> >  	vino.ino = ino;
> >  	vino.snap = CEPH_NOSNAP;
> > +
> > +	if (ceph_vino_is_reserved(vino))
> > +		return ERR_PTR(-ESTALE);
> > +
> >  	inode = ceph_find_inode(sb, vino);
> >  	if (!inode) {
> >  		struct ceph_mds_request *req;
> > @@ -214,6 +218,10 @@ static struct dentry *__snapfh_to_dentry(struct super_block *sb,
> >  		vino.ino = sfh->ino;
> >  		vino.snap = sfh->snapid;
> >  	}
> > +
> > +	if (ceph_vino_is_reserved(vino))
> > +		return ERR_PTR(-ESTALE);
> > +
> >  	inode = ceph_find_inode(sb, vino);
> >  	if (inode)
> >  		return d_obtain_alias(inode);
> > diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
> > index 14a1f7963625..e1c63adb196d 100644
> > --- a/fs/ceph/inode.c
> > +++ b/fs/ceph/inode.c
> > @@ -56,6 +56,9 @@ struct inode *ceph_get_inode(struct super_block *sb, struct ceph_vino vino)
> >  {
> >  	struct inode *inode;
> >  
> > +	if (ceph_vino_is_reserved(vino))
> > +		return ERR_PTR(-EREMOTEIO);
> > +
> >  	inode = iget5_locked(sb, (unsigned long)vino.ino, ceph_ino_compare,
> >  			     ceph_set_ino_cb, &vino);
> >  	if (!inode)
> > diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
> > index 63b53098360c..e5af591d3bd4 100644
> > --- a/fs/ceph/mds_client.c
> > +++ b/fs/ceph/mds_client.c
> > @@ -440,6 +440,13 @@ static int ceph_parse_deleg_inos(void **p, void *end,
> >  
> >  		ceph_decode_64_safe(p, end, start, bad);
> >  		ceph_decode_64_safe(p, end, len, bad);
> > +
> > +		/* Don't accept a delegation of system inodes */
> > +		if (start < CEPH_INO_SYSTEM_BASE) {
> > +			pr_warn_ratelimited("ceph: ignoring reserved inode range delegation (start=0x%llx len=0x%llx)\n",
> > +					start, len);
> > +			continue;
> > +		}
> >  		while (len--) {
> >  			int err = xa_insert(&s->s_delegated_inos, ino = start++,
> >  					    DELEGATED_INO_AVAILABLE,
> > diff --git a/fs/ceph/super.h b/fs/ceph/super.h
> > index df0851b9240e..f1745403c9b0 100644
> > --- a/fs/ceph/super.h
> > +++ b/fs/ceph/super.h
> > @@ -529,10 +529,34 @@ static inline int ceph_ino_compare(struct inode *inode, void *data)
> >  		ci->i_vino.snap == pvino->snap;
> >  }
> >  
> > +/*
> > + * The MDS reserves a set of inodes for its own usage. These should never
> > + * be accessible by clients, and so the MDS has no reason to ever hand these
> > + * out.
> > + *
> > + * These come from src/mds/mdstypes.h in the ceph sources.
> > + */
> > +#define CEPH_MAX_MDS		0x100
> > +#define CEPH_NUM_STRAY		10
> > +#define CEPH_INO_SYSTEM_BASE	((6*CEPH_MAX_MDS) + (CEPH_MAX_MDS * CEPH_NUM_STRAY))
> > +
> > +static inline bool ceph_vino_is_reserved(const struct ceph_vino vino)
> > +{
> > +	if (vino.ino < CEPH_INO_SYSTEM_BASE &&
> > +	    vino.ino != CEPH_INO_ROOT &&
> > +	    vino.ino != CEPH_INO_LOST_AND_FOUND) {
> > +		WARN_RATELIMIT(1, "Attempt to access reserved inode number 0x%llx", vino.ino);
> 
> This warning is quite easy to hit with inode 0x3, using generic/013.  It
> looks like, while looking for the snaprealm to check quotas, we will
> eventually get this value from the MDS.  So this function should also
> return 'true' if ino is CEPH_INO_GLOBAL_SNAPREALM.
> 

I wonder why I'm not seeing this. What mount options are you using?

Thanks,
-- 
Jeff Layton <jlayton@kernel.org>

