Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 570BB14E2D8
	for <lists+ceph-devel@lfdr.de>; Thu, 30 Jan 2020 20:00:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728124AbgA3TAv (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 30 Jan 2020 14:00:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:39224 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727285AbgA3TAv (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Thu, 30 Jan 2020 14:00:51 -0500
Received: from raleigh-dur.bear2.charlotte1.level3.net (unknown [173.95.209.66])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7BDC42082E;
        Thu, 30 Jan 2020 19:00:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580410849;
        bh=R+Irlg3sKvZpLCjJAkk7VJ8QVRhBUjC3XZifH/GAkB8=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=rHl4CGkZ88bLVfLSxZOXw28VT0OSYJWIy6t+BdyRdXGn14hQ3+LFObhGkADJRDQo/
         er9ezkMRH3Iu/g6+nrpZag4OMDiOql6YNL8/IOIbEagRA5hEifrW2PvNQ68hFzLa4b
         v5VgIw0CzYxZqq5f+zr3bn4N+rr1nKcl9CFDALAM=
Message-ID: <44f8f32e04b3fba2c6e444ba079cfd14ea180318.camel@kernel.org>
Subject: Re: [PATCH resend v5 02/11] ceph: add caps perf metric for each
 session
From:   Jeffrey Layton <jlayton@kernel.org>
To:     Xiubo Li <xiubli@redhat.com>, Jeff Layton <jlayton@kernel.org>,
        idryomov@gmail.com, zyan@redhat.com
Cc:     sage@redhat.com, pdonnell@redhat.com, ceph-devel@vger.kernel.org
Date:   Thu, 30 Jan 2020 14:00:22 -0500
In-Reply-To: <c60f2ad9-1b33-04d5-8b65-e4205880b345@redhat.com>
References: <20200129082715.5285-1-xiubli@redhat.com>
         <20200129082715.5285-3-xiubli@redhat.com>
         <a456a29671efa7a94a955bc8f1655bb042dbf13d.camel@kernel.org>
         <c60f2ad9-1b33-04d5-8b65-e4205880b345@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.3 (3.34.3-1.fc31) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Thu, 2020-01-30 at 10:22 +0800, Xiubo Li wrote:
> On 2020/1/29 22:21, Jeff Layton wrote:
> > On Wed, 2020-01-29 at 03:27 -0500, xiubli@redhat.com wrote:
> > > From: Xiubo Li <xiubli@redhat.com>
> > > 
> > > This will fulfill the caps hit/miss metric for each session. When
> > > checking the "need" mask and if one cap has the subset of the
> > > "need"
> > > mask it means hit, or missed.
> > > 
> > > item          total           miss            hit
> > > -------------------------------------------------
> > > d_lease       295             0               993
> > > 
> > > session       caps            miss            hit
> > > -------------------------------------------------
> > > 0             295             107             4119
> > > 1             1               107             9
> > > 
> > > URL: https://tracker.ceph.com/issues/43215
> > > Signed-off-by: Xiubo Li <xiubli@redhat.com>
> > > ---
> > >   fs/ceph/acl.c        |  2 ++
> > >   fs/ceph/addr.c       |  2 ++
> > >   fs/ceph/caps.c       | 74
> > > ++++++++++++++++++++++++++++++++++++++++++++
> > >   fs/ceph/debugfs.c    | 20 ++++++++++++
> > >   fs/ceph/dir.c        |  9 ++++--
> > >   fs/ceph/file.c       |  3 ++
> > >   fs/ceph/mds_client.c | 16 +++++++++-
> > >   fs/ceph/mds_client.h |  3 ++
> > >   fs/ceph/quota.c      |  9 ++++--
> > >   fs/ceph/super.h      | 11 +++++++
> > >   fs/ceph/xattr.c      | 17 ++++++++--
> > >   11 files changed, 158 insertions(+), 8 deletions(-)
> > > 
> > > diff --git a/fs/ceph/acl.c b/fs/ceph/acl.c
> > > index 26be6520d3fb..58e119e3519f 100644
> > > --- a/fs/ceph/acl.c
> > > +++ b/fs/ceph/acl.c
> > > @@ -22,6 +22,8 @@ static inline void ceph_set_cached_acl(struct
> > > inode *inode,
> > >   	struct ceph_inode_info *ci = ceph_inode(inode);
> > >   
> > >   	spin_lock(&ci->i_ceph_lock);
> > > +	__ceph_caps_metric(ci, CEPH_CAP_XATTR_SHARED);
> > > +
> > >   	if (__ceph_caps_issued_mask(ci, CEPH_CAP_XATTR_SHARED,
> > > 0))
> > >   		set_cached_acl(inode, type, acl);
> > >   	else
> > > diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
> > > index 7ab616601141..29d4513eff8c 100644
> > > --- a/fs/ceph/addr.c
> > > +++ b/fs/ceph/addr.c
> > > @@ -1706,6 +1706,8 @@ int ceph_uninline_data(struct file *filp,
> > > struct page *locked_page)
> > >   			err = -ENOMEM;
> > >   			goto out;
> > >   		}
> > > +
> > > +		ceph_caps_metric(ci, CEPH_STAT_CAP_INLINE_DATA);
> > Should a check for inline data really count here?
> Currently all the INLINE_DATA is in 'force' mode, so we can ignore
> it.
> > >   		err = __ceph_do_getattr(inode, page,
> > >   					CEPH_STAT_CAP_INLINE_DA
> > > TA, true);
> > >   		if (err < 0) {
> > > diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
> > > index 7fc87b693ba4..af2e9e826f8c 100644
> > > --- a/fs/ceph/caps.c
> > > +++ b/fs/ceph/caps.c
> > > @@ -783,6 +783,75 @@ static int __cap_is_valid(struct ceph_cap
> > > *cap)
> > >   	return 1;
> > >   }
> > >   
> > > +/*
> > > + * Counts the cap metric.
> > > + */
> > This needs some comments. Specifically, what should this be
> > counting and
> > how?
> 
> Will add it.
> 
> The __ceph_caps_metric() will traverse the inode's i_caps try to get
> the 
> 'issued' excepting the 'invoking' caps until it get enough caps in 
> 'mask'. The i_caps traverse logic is following
> __ceph_caps_issued_mask().
> 
> 
> > > +void __ceph_caps_metric(struct ceph_inode_info *ci, int mask)
> > > +{
> > > +	int have = ci->i_snap_caps;
> > > +	struct ceph_mds_session *s;
> > > +	struct ceph_cap *cap;
> > > +	struct rb_node *p;
> > > +	bool skip_auth = false;
> > > +
> > > +	lockdep_assert_held(&ci->i_ceph_lock);
> > > +
> > > +	if (mask <= 0)
> > > +		return;
> > > +
> > > +	/* Counts the snap caps metric in the auth cap */
> > > +	if (ci->i_auth_cap) {
> > > +		cap = ci->i_auth_cap;
> > > +		if (have) {
> > > +			have |= cap->issued;
> > > +
> > > +			dout("%s %p cap %p issued %s, mask %s\n",
> > > __func__,
> > > +			     &ci->vfs_inode, cap, ceph_cap_string(cap-
> > > >issued),
> > > +			     ceph_cap_string(mask));
> > > +
> > > +			s = ceph_get_mds_session(cap->session);
> > > +			if (s) {
> > > +				if (mask & have)
> > > +					percpu_counter_inc(&s-
> > > >i_caps_hit);
> > > +				else
> > > +					percpu_counter_inc(&s-
> > > >i_caps_mis);
> > > +				ceph_put_mds_session(s);
> > > +			}
> > > +			skip_auth = true;
> > > +		}
> > > +	}
> > > +
> > > +	if ((mask & have) == mask)
> > > +		return;
> > > +
> > > +	/* Checks others */
> > > +	for (p = rb_first(&ci->i_caps); p; p = rb_next(p)) {
> > > +		cap = rb_entry(p, struct ceph_cap, ci_node);
> > > +		if (!__cap_is_valid(cap))
> > > +			continue;
> > > +
> > > +		if (skip_auth && cap == ci->i_auth_cap)
> > > +			continue;
> > > +
> > > +		dout("%s %p cap %p issued %s, mask %s\n", __func__,
> > > +		     &ci->vfs_inode, cap, ceph_cap_string(cap->issued),
> > > +		     ceph_cap_string(mask));
> > > +
> > > +		s = ceph_get_mds_session(cap->session);
> > > +		if (s) {
> > > +			if (mask & cap->issued)
> > > +				percpu_counter_inc(&s->i_caps_hit);
> > > +			else
> > > +				percpu_counter_inc(&s->i_caps_mis);
> > > +			ceph_put_mds_session(s);
> > > +		}
> > > +
> > > +		have |= cap->issued;
> > > +		if ((mask & have) == mask)
> > > +			return;
> > > +	}
> > > +}
> > > +
> > I'm trying to understand what happens with the above when more than
> > one
> > ceph_cap has the same bit set in "issued". For instance:
> > 
> > Suppose we're doing the check for a statx call, and we're trying to
> > get
> > caps for pAsFsLs. We have two MDS's and they've each granted us
> > caps for
> > the inode, say:
> > 
> > MDS 0: pAs
> > MDS 1: pAsLsFs
> > 
> > We check the cap0 first, and consider it a hit, and then we check
> > cap1
> > and consider it a hit as well. So that seems like it's being
> > double-
> > counted.
> 
> Yeah, it will.
> 
> In case2:
> 
> MDS 0: pAsFs
> 
> MDS 1: pAsLs
> 
> For this case and yours both the i_cap0 and i_cap1 are 'hit'.
> 
> 
> In case3 :
> 
> MDS0: pAsFsLs
> 
> MDS1: pAs
> 
> Only the i_cap0 is 'hit'.  i_cap1 will not be counted any 'hit' or
> 'mis'.
> 
> 
> In case4:
> 
> MDS0: p
> 
> MDS1: pAsLsFs
> 
> i_cap0 will 'mis' and i_cap1 will 'hit'.
> 
> 
> All the logic are the same with __ceph_caps_issued_mask() does.
> 
> The 'hit' means to get all the caps in 'mask we have checked the 
> i_cap[0~N] and if they have a subset in 'mask', and the 'mis' means
> we 
> have checked the i_cap[0~N] but they do not.
> 
> For the i_cap[N+1 ~ M], if we won't touch them because we have
> already 
> gotten enough caps needed in 'mask', they won't count any 'hit' or
> 'mis'
> 
> All in all, the current logic is that the 'hit' means 'touched' and
> it 
> have some of what we needed, and the 'mis' means 'touched' and
> missed 
> any of what we needed.
> 
> 

That seems sort of arbitrary, given that you're going to get different
results depending on the index of the MDS with the caps. For instance:


MDS0: pAsLsFs
MDS1: pAs

...vs...

MDS0: pAs
MDS1: pAsLsFs

If we assume we're looking for pAsLsFs, then the first scenario will
just end up with 1 hit and the second will give you 2. AFAIU, the two
MDSs are peers, so it really seems like the index should not matter
here.

I'm really struggling to understand how these numbers will be useful.
What, specifically, are we trying to count here and why?

> 
> > ISTM, that what you really want to do here is logically or all of
> > the
> > cap->issued fields together, and then check that vs. the mask
> > value, and
> > count only one hit or miss per inode.
> > 
> > That said, it's not 100% clear what you're counting as a hit or
> > miss
> > here, so please let me know if I have that wrong.
> >   
> > >   /*
> > >    * Return set of valid cap bits issued to us.  Note that caps
> > > time
> > >    * out, and may be invalidated in bulk if the client session
> > > times out
> > > @@ -2746,6 +2815,7 @@ static void check_max_size(struct inode
> > > *inode, loff_t endoff)
> > >   int ceph_try_get_caps(struct inode *inode, int need, int want,
> > >   		      bool nonblock, int *got)
> > >   {
> > > +	struct ceph_inode_info *ci = ceph_inode(inode);
> > >   	int ret;
> > >   
> > >   	BUG_ON(need & ~CEPH_CAP_FILE_RD);
> > > @@ -2758,6 +2828,7 @@ int ceph_try_get_caps(struct inode *inode,
> > > int need, int want,
> > >   	BUG_ON(want & ~(CEPH_CAP_FILE_CACHE |
> > > CEPH_CAP_FILE_LAZYIO |
> > >   			CEPH_CAP_FILE_SHARED |
> > > CEPH_CAP_FILE_EXCL |
> > >   			CEPH_CAP_ANY_DIR_OPS));
> > > +	ceph_caps_metric(ci, need | want);
> > >   	ret = try_get_cap_refs(inode, need, want, 0, nonblock,
> > > got);
> > >   	return ret == -EAGAIN ? 0 : ret;
> > >   }
> > > @@ -2784,6 +2855,8 @@ int ceph_get_caps(struct file *filp, int
> > > need, int want,
> > >   	    fi->filp_gen != READ_ONCE(fsc->filp_gen))
> > >   		return -EBADF;
> > >   
> > > +	ceph_caps_metric(ci, need | want);
> > > +
> > >   	while (true) {
> > >   		if (endoff > 0)
> > >   			check_max_size(inode, endoff);
> > > @@ -2871,6 +2944,7 @@ int ceph_get_caps(struct file *filp, int
> > > need, int want,
> > >   			 * getattr request will bring inline
> > > data into
> > >   			 * page cache
> > >   			 */
> > > +			ceph_caps_metric(ci,
> > > CEPH_STAT_CAP_INLINE_DATA);
> > >   			ret = __ceph_do_getattr(inode, NULL,
> > >   						CEPH_STAT_CAP_I
> > > NLINE_DATA,
> > >   						true);
> > > diff --git a/fs/ceph/debugfs.c b/fs/ceph/debugfs.c
> > > index 40a22da0214a..c132fdb40d53 100644
> > > --- a/fs/ceph/debugfs.c
> > > +++ b/fs/ceph/debugfs.c
> > > @@ -128,6 +128,7 @@ static int metric_show(struct seq_file *s,
> > > void *p)
> > >   {
> > >   	struct ceph_fs_client *fsc = s->private;
> > >   	struct ceph_mds_client *mdsc = fsc->mdsc;
> > > +	int i;
> > >   
> > >   	seq_printf(s,
> > > "item          total           miss            hit\n");
> > >   	seq_printf(s, "--------------------------------------
> > > -----------\n");
> > > @@ -137,6 +138,25 @@ static int metric_show(struct seq_file *s,
> > > void *p)
> > >   		   percpu_counter_sum(&mdsc-
> > > >metric.d_lease_mis),
> > >   		   percpu_counter_sum(&mdsc-
> > > >metric.d_lease_hit));
> > >   
> > > +	seq_printf(s, "\n");
> > > +	seq_printf(s,
> > > "session       caps            miss            hit\n");
> > > +	seq_printf(s, "----------------------------------------------
> > > ---\n");
> > > +
> > > +	mutex_lock(&mdsc->mutex);
> > > +	for (i = 0; i < mdsc->max_sessions; i++) {
> > > +		struct ceph_mds_session *session;
> > > +
> > > +		session = __ceph_lookup_mds_session(mdsc, i);
> > > +		if (!session)
> > > +			continue;
> > > +		seq_printf(s, "%-14d%-16d%-16lld%lld\n", i,
> > > +			   session->s_nr_caps,
> > > +			   percpu_counter_sum(&session->i_caps_mis),
> > > +			   percpu_counter_sum(&session->i_caps_hit));
> > > +		ceph_put_mds_session(session);
> > > +	}
> > > +	mutex_unlock(&mdsc->mutex);
> > > +
> > >   	return 0;
> > >   }
> > >   
> > > diff --git a/fs/ceph/dir.c b/fs/ceph/dir.c
> > > index 658c55b323cc..33eb239e09e2 100644
> > > --- a/fs/ceph/dir.c
> > > +++ b/fs/ceph/dir.c
> > > @@ -313,7 +313,7 @@ static int ceph_readdir(struct file *file,
> > > struct dir_context *ctx)
> > >   	struct ceph_fs_client *fsc =
> > > ceph_inode_to_client(inode);
> > >   	struct ceph_mds_client *mdsc = fsc->mdsc;
> > >   	int i;
> > > -	int err;
> > > +	int err, ret = -1;
> > >   	unsigned frag = -1;
> > >   	struct ceph_mds_reply_info_parsed *rinfo;
> > >   
> > > @@ -346,13 +346,16 @@ static int ceph_readdir(struct file *file,
> > > struct dir_context *ctx)
> > >   	    !ceph_test_mount_opt(fsc, NOASYNCREADDIR) &&
> > >   	    ceph_snap(inode) != CEPH_SNAPDIR &&
> > >   	    __ceph_dir_is_complete_ordered(ci) &&
> > > -	    __ceph_caps_issued_mask(ci, CEPH_CAP_FILE_SHARED, 1)) {
> > > +	    (ret = __ceph_caps_issued_mask(ci, CEPH_CAP_FILE_SHARED,
> > > 1))) {
> > >   		int shared_gen = atomic_read(&ci-
> > > >i_shared_gen);
> > > +		__ceph_caps_metric(ci, CEPH_CAP_XATTR_SHARED);
> > >   		spin_unlock(&ci->i_ceph_lock);
> > >   		err = __dcache_readdir(file, ctx, shared_gen);
> > >   		if (err != -EAGAIN)
> > >   			return err;
> > >   	} else {
> > > +		if (ret != -1)
> > > +			__ceph_caps_metric(ci, CEPH_CAP_XATTR_SHARED);
> > >   		spin_unlock(&ci->i_ceph_lock);
> > >   	}
> > >   
> > > @@ -757,6 +760,8 @@ static struct dentry *ceph_lookup(struct
> > > inode *dir, struct dentry *dentry,
> > >   		struct ceph_dentry_info *di =
> > > ceph_dentry(dentry);
> > >   
> > >   		spin_lock(&ci->i_ceph_lock);
> > > +		__ceph_caps_metric(ci, CEPH_CAP_FILE_SHARED);
> > > +
> > >   		dout(" dir %p flags are %d\n", dir, ci-
> > > >i_ceph_flags);
> > >   		if (strncmp(dentry->d_name.name,
> > >   			    fsc->mount_options->snapdir_name,
> > > diff --git a/fs/ceph/file.c b/fs/ceph/file.c
> > > index 1e6cdf2dfe90..c78dfbbb7b91 100644
> > > --- a/fs/ceph/file.c
> > > +++ b/fs/ceph/file.c
> > > @@ -384,6 +384,8 @@ int ceph_open(struct inode *inode, struct
> > > file *file)
> > >   	 * asynchronously.
> > >   	 */
> > >   	spin_lock(&ci->i_ceph_lock);
> > > +	__ceph_caps_metric(ci, wanted);
> > > +
> > >   	if (__ceph_is_any_real_caps(ci) &&
> > >   	    (((fmode & CEPH_FILE_MODE_WR) == 0) || ci-
> > > >i_auth_cap)) {
> > >   		int mds_wanted = __ceph_caps_mds_wanted(ci,
> > > true);
> > > @@ -1340,6 +1342,7 @@ static ssize_t ceph_read_iter(struct kiocb
> > > *iocb, struct iov_iter *to)
> > >   				return -ENOMEM;
> > >   		}
> > >   
> > > +		ceph_caps_metric(ci, CEPH_STAT_CAP_INLINE_DATA);
> > >   		statret = __ceph_do_getattr(inode, page,
> > >   					    CEPH_STAT_CAP_INLIN
> > > E_DATA, !!page);
> > >   		if (statret < 0) {
> > > diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
> > > index a24fd00676b8..141c1c03636c 100644
> > > --- a/fs/ceph/mds_client.c
> > > +++ b/fs/ceph/mds_client.c
> > > @@ -558,6 +558,8 @@ void ceph_put_mds_session(struct
> > > ceph_mds_session *s)
> > >   	if (refcount_dec_and_test(&s->s_ref)) {
> > >   		if (s->s_auth.authorizer)
> > >   			ceph_auth_destroy_authorizer(s-
> > > >s_auth.authorizer);
> > > +		percpu_counter_destroy(&s->i_caps_hit);
> > > +		percpu_counter_destroy(&s->i_caps_mis);
> > >   		kfree(s);
> > >   	}
> > >   }
> > > @@ -598,6 +600,7 @@ static struct ceph_mds_session
> > > *register_session(struct ceph_mds_client *mdsc,
> > >   						 int mds)
> > >   {
> > >   	struct ceph_mds_session *s;
> > > +	int err;
> > >   
> > >   	if (mds >= mdsc->mdsmap->possible_max_rank)
> > >   		return ERR_PTR(-EINVAL);
> > > @@ -612,8 +615,10 @@ static struct ceph_mds_session
> > > *register_session(struct ceph_mds_client *mdsc,
> > >   
> > >   		dout("%s: realloc to %d\n", __func__, newmax);
> > >   		sa = kcalloc(newmax, sizeof(void *), GFP_NOFS);
> > > -		if (!sa)
> > > +		if (!sa) {
> > > +			err = -ENOMEM;
> > >   			goto fail_realloc;
> > > +		}
> > >   		if (mdsc->sessions) {
> > >   			memcpy(sa, mdsc->sessions,
> > >   			       mdsc->max_sessions * sizeof(void
> > > *));
> > > @@ -653,6 +658,13 @@ static struct ceph_mds_session
> > > *register_session(struct ceph_mds_client *mdsc,
> > >   
> > >   	INIT_LIST_HEAD(&s->s_cap_flushing);
> > >   
> > > +	err = percpu_counter_init(&s->i_caps_hit, 0, GFP_NOFS);
> > > +	if (err)
> > > +		goto fail_realloc;
> > > +	err = percpu_counter_init(&s->i_caps_mis, 0, GFP_NOFS);
> > > +	if (err)
> > > +		goto fail_init;
> > > +
> > >   	mdsc->sessions[mds] = s;
> > >   	atomic_inc(&mdsc->num_sessions);
> > >   	refcount_inc(&s->s_ref);  /* one ref to sessions[], one
> > > to caller */
> > > @@ -662,6 +674,8 @@ static struct ceph_mds_session
> > > *register_session(struct ceph_mds_client *mdsc,
> > >   
> > >   	return s;
> > >   
> > > +fail_init:
> > > +	percpu_counter_destroy(&s->i_caps_hit);
> > >   fail_realloc:
> > >   	kfree(s);
> > >   	return ERR_PTR(-ENOMEM);
> > > diff --git a/fs/ceph/mds_client.h b/fs/ceph/mds_client.h
> > > index dd1f417b90eb..ba74ff74c59c 100644
> > > --- a/fs/ceph/mds_client.h
> > > +++ b/fs/ceph/mds_client.h
> > > @@ -201,6 +201,9 @@ struct ceph_mds_session {
> > >   
> > >   	struct list_head  s_waiting;  /* waiting requests */
> > >   	struct list_head  s_unsafe;   /* unsafe requests */
> > > +
> > > +	struct percpu_counter i_caps_hit;
> > > +	struct percpu_counter i_caps_mis;
> > >   };
> > >   
> > >   /*
> > > diff --git a/fs/ceph/quota.c b/fs/ceph/quota.c
> > > index de56dee60540..4ce2f658e63d 100644
> > > --- a/fs/ceph/quota.c
> > > +++ b/fs/ceph/quota.c
> > > @@ -147,9 +147,14 @@ static struct inode
> > > *lookup_quotarealm_inode(struct ceph_mds_client *mdsc,
> > >   		return NULL;
> > >   	}
> > >   	if (qri->inode) {
> > > +		struct ceph_inode_info *ci = ceph_inode(qri->inode);
> > > +		int ret;
> > > +
> > > +		ceph_caps_metric(ci, CEPH_STAT_CAP_INODE);
> > > +
> > >   		/* get caps */
> > > -		int ret = __ceph_do_getattr(qri->inode, NULL,
> > > -					    CEPH_STAT_CAP_INODE, true);
> > > +		ret = __ceph_do_getattr(qri->inode, NULL,
> > > +					CEPH_STAT_CAP_INODE, true);
> > >   		if (ret >= 0)
> > >   			in = qri->inode;
> > >   		else
> > > diff --git a/fs/ceph/super.h b/fs/ceph/super.h
> > > index 7af91628636c..3f4829222528 100644
> > > --- a/fs/ceph/super.h
> > > +++ b/fs/ceph/super.h
> > > @@ -641,6 +641,14 @@ static inline bool
> > > __ceph_is_any_real_caps(struct ceph_inode_info *ci)
> > >   	return !RB_EMPTY_ROOT(&ci->i_caps);
> > >   }
> > >   
> > > +extern void __ceph_caps_metric(struct ceph_inode_info *ci, int
> > > mask);
> > > +static inline void ceph_caps_metric(struct ceph_inode_info *ci,
> > > int mask)
> > > +{
> > > +	spin_lock(&ci->i_ceph_lock);
> > > +	__ceph_caps_metric(ci, mask);
> > > +	spin_unlock(&ci->i_ceph_lock);
> > > +}
> > > +
> > >   extern int __ceph_caps_issued(struct ceph_inode_info *ci, int
> > > *implemented);
> > >   extern int __ceph_caps_issued_mask(struct ceph_inode_info *ci,
> > > int mask, int t);
> > >   extern int __ceph_caps_issued_other(struct ceph_inode_info *ci,
> > > @@ -927,6 +935,9 @@ extern int __ceph_do_getattr(struct inode
> > > *inode, struct page *locked_page,
> > >   			     int mask, bool force);
> > >   static inline int ceph_do_getattr(struct inode *inode, int
> > > mask, bool force)
> > >   {
> > > +	struct ceph_inode_info *ci = ceph_inode(inode);
> > > +
> > > +	ceph_caps_metric(ci, mask);
> > >   	return __ceph_do_getattr(inode, NULL, mask, force);
> > >   }
> > >   extern int ceph_permission(struct inode *inode, int mask);
> > > diff --git a/fs/ceph/xattr.c b/fs/ceph/xattr.c
> > > index d58fa14c1f01..ebd522edb0a8 100644
> > > --- a/fs/ceph/xattr.c
> > > +++ b/fs/ceph/xattr.c
> > > @@ -829,6 +829,7 @@ ssize_t __ceph_getxattr(struct inode *inode,
> > > const char *name, void *value,
> > >   	struct ceph_vxattr *vxattr = NULL;
> > >   	int req_mask;
> > >   	ssize_t err;
> > > +	int ret = -1;
> > >   
> > >   	/* let's see if a virtual xattr was requested */
> > >   	vxattr = ceph_match_vxattr(inode, name);
> > > @@ -856,7 +857,9 @@ ssize_t __ceph_getxattr(struct inode *inode,
> > > const char *name, void *value,
> > >   
> > >   	if (ci->i_xattrs.version == 0 ||
> > >   	    !((req_mask & CEPH_CAP_XATTR_SHARED) ||
> > > -	      __ceph_caps_issued_mask(ci, CEPH_CAP_XATTR_SHARED, 1))) {
> > > +	      (ret = __ceph_caps_issued_mask(ci, CEPH_CAP_XATTR_SHARED,
> > > 1)))) {
> > > +		if (ret != -1)
> > > +			__ceph_caps_metric(ci, CEPH_CAP_XATTR_SHARED);
> > >   		spin_unlock(&ci->i_ceph_lock);
> > >   
> > >   		/* security module gets xattr while filling
> > > trace */
> > > @@ -871,6 +874,9 @@ ssize_t __ceph_getxattr(struct inode *inode,
> > > const char *name, void *value,
> > >   		if (err)
> > >   			return err;
> > >   		spin_lock(&ci->i_ceph_lock);
> > > +	} else {
> > > +		if (ret != -1)
> > > +			__ceph_caps_metric(ci, CEPH_CAP_XATTR_SHARED);
> > >   	}
> > >   
> > >   	err = __build_xattrs(inode);
> > > @@ -907,19 +913,24 @@ ssize_t ceph_listxattr(struct dentry
> > > *dentry, char *names, size_t size)
> > >   	struct ceph_inode_info *ci = ceph_inode(inode);
> > >   	bool len_only = (size == 0);
> > >   	u32 namelen;
> > > -	int err;
> > > +	int err, ret = -1;
> > >   
> > >   	spin_lock(&ci->i_ceph_lock);
> > >   	dout("listxattr %p ver=%lld index_ver=%lld\n", inode,
> > >   	     ci->i_xattrs.version, ci->i_xattrs.index_version);
> > >   
> > >   	if (ci->i_xattrs.version == 0 ||
> > > -	    !__ceph_caps_issued_mask(ci, CEPH_CAP_XATTR_SHARED, 1)) {
> > > +	    !(ret = __ceph_caps_issued_mask(ci, CEPH_CAP_XATTR_SHARED,
> > > 1))) {
> > > +		if (ret != -1)
> > > +			__ceph_caps_metric(ci, CEPH_CAP_XATTR_SHARED);
> > >   		spin_unlock(&ci->i_ceph_lock);
> > >   		err = ceph_do_getattr(inode,
> > > CEPH_STAT_CAP_XATTR, true);
> > >   		if (err)
> > >   			return err;
> > >   		spin_lock(&ci->i_ceph_lock);
> > > +	} else {
> > > +		if (ret != -1)
> > > +			__ceph_caps_metric(ci, CEPH_CAP_XATTR_SHARED);
> > >   	}
> > >   
> > >   	err = __build_xattrs(inode);
> 
> 
-- 
Jeffrey Layton <jlayton@kernel.org>

