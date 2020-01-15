Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6D6C513C5E1
	for <lists+ceph-devel@lfdr.de>; Wed, 15 Jan 2020 15:24:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728899AbgAOOYq (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 15 Jan 2020 09:24:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:54608 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726248AbgAOOYq (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Wed, 15 Jan 2020 09:24:46 -0500
Received: from tleilax.poochiereds.net (68-20-15-154.lightspeed.rlghnc.sbcglobal.net [68.20.15.154])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 47710214AF;
        Wed, 15 Jan 2020 14:24:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579098284;
        bh=hrxmH6K05amkZpSFMJZ1R1Ogo2OZ6F4EpgLlW8D3qc8=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=2FXIC4i7r/OH742NSoQihn/UJuXC5umymXeVV8BfH1yMLRGwBwbQHFwfCGH8npMby
         irfbks/iMEU0RDGUZ0GcYioqivrrL0DYPSw2FA4+Z3/fw0d9CYKCxeF9qvAD1ezei7
         94fGJJj0ft+3irgqlzbdF0BFmpVwZxg32eKXhMkk=
Message-ID: <52b531a7092a8bd09f7ade52fb17b0cee68ffd8a.camel@kernel.org>
Subject: Re: [PATCH v3 2/8] ceph: add caps perf metric for each session
From:   Jeff Layton <jlayton@kernel.org>
To:     xiubli@redhat.com, idryomov@gmail.com, zyan@redhat.com
Cc:     sage@redhat.com, pdonnell@redhat.com, ceph-devel@vger.kernel.org
Date:   Wed, 15 Jan 2020 09:24:43 -0500
In-Reply-To: <20200115034444.14304-3-xiubli@redhat.com>
References: <20200115034444.14304-1-xiubli@redhat.com>
         <20200115034444.14304-3-xiubli@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.3 (3.34.3-1.fc31) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Tue, 2020-01-14 at 22:44 -0500, xiubli@redhat.com wrote:
> From: Xiubo Li <xiubli@redhat.com>
> 
> This will fulfill the caps hit/miss metric for each session. When
> checking the "need" mask and if one cap has the subset of the "need"
> mask it means hit, or missed.
> 
> item          total           miss            hit
> -------------------------------------------------
> d_lease       295             0               993
> 
> session       caps            miss            hit
> -------------------------------------------------
> 0             295             107             4119
> 1             1               107             9
> 
> URL: https://tracker.ceph.com/issues/43215
> Signed-off-by: Xiubo Li <xiubli@redhat.com>
> ---
>  fs/ceph/acl.c        |  2 ++
>  fs/ceph/addr.c       |  1 +
>  fs/ceph/caps.c       | 71 ++++++++++++++++++++++++++++++++++++++++++++
>  fs/ceph/debugfs.c    | 20 +++++++++++++
>  fs/ceph/dir.c        |  4 +++
>  fs/ceph/file.c       |  4 ++-
>  fs/ceph/mds_client.c | 16 +++++++++-
>  fs/ceph/mds_client.h |  3 ++
>  fs/ceph/quota.c      |  8 +++--
>  fs/ceph/super.h      |  6 ++++
>  fs/ceph/xattr.c      | 17 +++++++++--
>  11 files changed, 145 insertions(+), 7 deletions(-)
> 
> diff --git a/fs/ceph/acl.c b/fs/ceph/acl.c
> index 26be6520d3fb..58e119e3519f 100644
> --- a/fs/ceph/acl.c
> +++ b/fs/ceph/acl.c
> @@ -22,6 +22,8 @@ static inline void ceph_set_cached_acl(struct inode *inode,
>  	struct ceph_inode_info *ci = ceph_inode(inode);
>  
>  	spin_lock(&ci->i_ceph_lock);
> +	__ceph_caps_metric(ci, CEPH_CAP_XATTR_SHARED);
> +
>  	if (__ceph_caps_issued_mask(ci, CEPH_CAP_XATTR_SHARED, 0))
>  		set_cached_acl(inode, type, acl);
>  	else
> diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
> index 7ab616601141..fe8adf3dc065 100644
> --- a/fs/ceph/addr.c
> +++ b/fs/ceph/addr.c
> @@ -1706,6 +1706,7 @@ int ceph_uninline_data(struct file *filp, struct page *locked_page)
>  			err = -ENOMEM;
>  			goto out;
>  		}
> +		__ceph_caps_metric(ci, CEPH_STAT_CAP_INLINE_DATA);
> 		err = __ceph_do_getattr(inode, page,
>  					CEPH_STAT_CAP_INLINE_DATA, true);
>  		if (err < 0) {
> diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
> index 7fc87b693ba4..df85980f0930 100644
> --- a/fs/ceph/caps.c
> +++ b/fs/ceph/caps.c
> @@ -783,6 +783,73 @@ static int __cap_is_valid(struct ceph_cap *cap)
>  	return 1;
>  }
>  
> +/*
> + * Counts the cap metric.
> + */
> +void __ceph_caps_metric(struct ceph_inode_info *ci, int mask)
> +{
> +	int have = ci->i_snap_caps;
> +	struct ceph_mds_session *s;
> +	struct ceph_cap *cap;
> +	struct rb_node *p;
> +	bool skip_auth = false;
> +
> +	if (mask <= 0)
> +		return;
> +
> +	/* Counts the snap caps metric in the auth cap */
> +	if (ci->i_auth_cap) {
> +		cap = ci->i_auth_cap;
> +		if (have) {
> +			have |= cap->issued;
> +
> +			dout("%s %p cap %p issued %s, mask %s\n", __func__,
> +			     &ci->vfs_inode, cap, ceph_cap_string(cap->issued),
> +			     ceph_cap_string(mask));
> +
> +			s = ceph_get_mds_session(cap->session);
> +			if (s) {
> +				if (mask & have)
> +					percpu_counter_inc(&s->i_caps_hit);
> +				else
> +					percpu_counter_inc(&s->i_caps_mis);
> +				ceph_put_mds_session(s);
> +			}
> +			skip_auth = true;
> +		}
> +	}
> +
> +	if ((mask & have) == mask)
> +		return;
> +
> +	/* Checks others */


Iterating over i_caps requires that you hold the i_ceph_lock. Some
callers of __ceph_caps_metric already hold it but some of the callers
don't.

The simple fix would be to wrap this function in another that takes and
drops the i_ceph_lock before calling this one. It would also be good to
add this at the top of this function as well:

	lockdep_assert_held(&ci->i_ceph_lock);

The bad part is that this does mean adding in extra spinlocking to some
of these codepaths, which is less than ideal. Eventually, I think we
ought to convert the cap handling to use RCU and move the i_caps tree to
a linked list. That would allow us to avoid a lot of the locking for
stuff like this, and it never has _that_ many entries to where a tree
really matters.

> +	for (p = rb_first(&ci->i_caps); p; p = rb_next(p)) {
> +		cap = rb_entry(p, struct ceph_cap, ci_node);
> +		if (!__cap_is_valid(cap))
> +			continue;
> +
> +		if (skip_auth && cap == ci->i_auth_cap)
> +			continue;
> +
> +		dout("%s %p cap %p issued %s, mask %s\n", __func__,
> +		     &ci->vfs_inode, cap, ceph_cap_string(cap->issued),
> +		     ceph_cap_string(mask));
> +
> +		s = ceph_get_mds_session(cap->session);
> +		if (s) {
> +			if (mask & cap->issued)
> +				percpu_counter_inc(&s->i_caps_hit);
> +			else
> +				percpu_counter_inc(&s->i_caps_mis);
> +			ceph_put_mds_session(s);
> +		}
> +
> +		have |= cap->issued;
> +		if ((mask & have) == mask)
> +			return;
> +	}
> +}
> +
>  /*
>   * Return set of valid cap bits issued to us.  Note that caps time
>   * out, and may be invalidated in bulk if the client session times out
> @@ -881,6 +948,7 @@ int __ceph_caps_issued_mask(struct ceph_inode_info *ci, int mask, int touch)
>  		cap = rb_entry(p, struct ceph_cap, ci_node);
>  		if (!__cap_is_valid(cap))
>  			continue;
> +
>  		if ((cap->issued & mask) == mask) {
>  			dout("__ceph_caps_issued_mask ino 0x%lx cap %p issued %s"
>  			     " (mask %s)\n", ci->vfs_inode.i_ino, cap,
> @@ -2603,6 +2671,8 @@ static int try_get_cap_refs(struct inode *inode, int need, int want,
>  		spin_lock(&ci->i_ceph_lock);
>  	}
>  
> +	__ceph_caps_metric(ci, need);
> +

Should "want" also count toward hits and misses here? IOW:

	__ceph_caps_metric(ci, need | want);

?

>  	have = __ceph_caps_issued(ci, &implemented);
>  
>  	if (have & need & CEPH_CAP_FILE_WR) {
> @@ -2871,6 +2941,7 @@ int ceph_get_caps(struct file *filp, int need, int want,
>  			 * getattr request will bring inline data into
> +			__ceph_caps_metric(ci, CEPH_STAT_CAP_INLINE_DATA);
>  			 */
> +			__ceph_caps_metric(ci, CEPH_STAT_CAP_INLINE_DATA);
>  			ret = __ceph_do_getattr(inode, NULL,
>  						CEPH_STAT_CAP_INLINE_DATA,
>  						true);
> diff --git a/fs/ceph/debugfs.c b/fs/ceph/debugfs.c
> index 40a22da0214a..c132fdb40d53 100644
> --- a/fs/ceph/debugfs.c
> +++ b/fs/ceph/debugfs.c
> @@ -128,6 +128,7 @@ static int metric_show(struct seq_file *s, void *p)
>  {
>  	struct ceph_fs_client *fsc = s->private;
>  	struct ceph_mds_client *mdsc = fsc->mdsc;
> +	int i;
>  
>  	seq_printf(s, "item          total           miss            hit\n");
>  	seq_printf(s, "-------------------------------------------------\n");
> @@ -137,6 +138,25 @@ static int metric_show(struct seq_file *s, void *p)
>  		   percpu_counter_sum(&mdsc->metric.d_lease_mis),
>  		   percpu_counter_sum(&mdsc->metric.d_lease_hit));
>  
> +	seq_printf(s, "\n");
> +	seq_printf(s, "session       caps            miss            hit\n");
> +	seq_printf(s, "-------------------------------------------------\n");
> +
> +	mutex_lock(&mdsc->mutex);
> +	for (i = 0; i < mdsc->max_sessions; i++) {
> +		struct ceph_mds_session *session;
> +
> +		session = __ceph_lookup_mds_session(mdsc, i);
> +		if (!session)
> +			continue;
> +		seq_printf(s, "%-14d%-16d%-16lld%lld\n", i,
> +			   session->s_nr_caps,
> +			   percpu_counter_sum(&session->i_caps_mis),
> +			   percpu_counter_sum(&session->i_caps_hit));
> +		ceph_put_mds_session(session);
> +	}
> +	mutex_unlock(&mdsc->mutex);
> +
>  	return 0;
>  }
>  
> diff --git a/fs/ceph/dir.c b/fs/ceph/dir.c
> index 658c55b323cc..c381ce430036 100644
> --- a/fs/ceph/dir.c
> +++ b/fs/ceph/dir.c
> @@ -342,6 +342,8 @@ static int ceph_readdir(struct file *file, struct dir_context *ctx)
>  
>  	/* can we use the dcache? */
>  	spin_lock(&ci->i_ceph_lock);
> +	__ceph_caps_metric(ci, CEPH_CAP_FILE_SHARED);
> +
>  	if (ceph_test_mount_opt(fsc, DCACHE) &&
>  	    !ceph_test_mount_opt(fsc, NOASYNCREADDIR) &&
>  	    ceph_snap(inode) != CEPH_SNAPDIR &&
> @@ -757,6 +759,8 @@ static struct dentry *ceph_lookup(struct inode *dir, struct dentry *dentry,
>  		struct ceph_dentry_info *di = ceph_dentry(dentry);
>  
>  		spin_lock(&ci->i_ceph_lock);
> +		__ceph_caps_metric(ci, CEPH_CAP_FILE_SHARED);
> +
>  		dout(" dir %p flags are %d\n", dir, ci->i_ceph_flags);
>  		if (strncmp(dentry->d_name.name,
>  			    fsc->mount_options->snapdir_name,
> diff --git a/fs/ceph/file.c b/fs/ceph/file.c
> index 1e6cdf2dfe90..b32aba4023b3 100644
> --- a/fs/ceph/file.c
> +++ b/fs/ceph/file.c
> @@ -393,6 +393,7 @@ int ceph_open(struct inode *inode, struct file *file)
>  		     inode, fmode, ceph_cap_string(wanted),
>  		     ceph_cap_string(issued));
>  		__ceph_get_fmode(ci, fmode);
> +		__ceph_caps_metric(ci, fmode);

This looks wrong. fmode is not a cap mask.

>  		spin_unlock(&ci->i_ceph_lock);
>  
>  		/* adjust wanted? */
> @@ -403,7 +404,7 @@ int ceph_open(struct inode *inode, struct file *file)
>  
>  		return ceph_init_file(inode, file, fmode);
>  	} else if (ceph_snap(inode) != CEPH_NOSNAP &&
> -		   (ci->i_snap_caps & wanted) == wanted) {
> +			(ci->i_snap_caps & wanted) == wanted) {
>  		__ceph_get_fmode(ci, fmode);
>  		spin_unlock(&ci->i_ceph_lock);
>  		return ceph_init_file(inode, file, fmode);
> @@ -1340,6 +1341,7 @@ static ssize_t ceph_read_iter(struct kiocb *iocb, struct iov_iter *to)
>  				return -ENOMEM;
>  		}
>  
> +		__ceph_caps_metric(ci, CEPH_STAT_CAP_INLINE_DATA);
>  		statret = __ceph_do_getattr(inode, page,
>  					    CEPH_STAT_CAP_INLINE_DATA, !!page);
>  		if (statret < 0) {
> diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
> index a24fd00676b8..141c1c03636c 100644
> --- a/fs/ceph/mds_client.c
> +++ b/fs/ceph/mds_client.c
> @@ -558,6 +558,8 @@ void ceph_put_mds_session(struct ceph_mds_session *s)
>  	if (refcount_dec_and_test(&s->s_ref)) {
>  		if (s->s_auth.authorizer)
>  			ceph_auth_destroy_authorizer(s->s_auth.authorizer);
> +		percpu_counter_destroy(&s->i_caps_hit);
> +		percpu_counter_destroy(&s->i_caps_mis);
>  		kfree(s);
>  	}
>  }
> @@ -598,6 +600,7 @@ static struct ceph_mds_session *register_session(struct ceph_mds_client *mdsc,
>  						 int mds)
>  {
>  	struct ceph_mds_session *s;
> +	int err;
>  
>  	if (mds >= mdsc->mdsmap->possible_max_rank)
>  		return ERR_PTR(-EINVAL);
> @@ -612,8 +615,10 @@ static struct ceph_mds_session *register_session(struct ceph_mds_client *mdsc,
>  
>  		dout("%s: realloc to %d\n", __func__, newmax);
>  		sa = kcalloc(newmax, sizeof(void *), GFP_NOFS);
> -		if (!sa)
> +		if (!sa) {
> +			err = -ENOMEM;
>  			goto fail_realloc;
> +		}
>  		if (mdsc->sessions) {
>  			memcpy(sa, mdsc->sessions,
>  			       mdsc->max_sessions * sizeof(void *));
> @@ -653,6 +658,13 @@ static struct ceph_mds_session *register_session(struct ceph_mds_client *mdsc,
>  
>  	INIT_LIST_HEAD(&s->s_cap_flushing);
>  
> +	err = percpu_counter_init(&s->i_caps_hit, 0, GFP_NOFS);
> +	if (err)
> +		goto fail_realloc;
> +	err = percpu_counter_init(&s->i_caps_mis, 0, GFP_NOFS);
> +	if (err)
> +		goto fail_init;
> +
>  	mdsc->sessions[mds] = s;
>  	atomic_inc(&mdsc->num_sessions);
>  	refcount_inc(&s->s_ref);  /* one ref to sessions[], one to caller */
> @@ -662,6 +674,8 @@ static struct ceph_mds_session *register_session(struct ceph_mds_client *mdsc,
>  
>  	return s;
>  
> +fail_init:
> +	percpu_counter_destroy(&s->i_caps_hit);
>  fail_realloc:
>  	kfree(s);
>  	return ERR_PTR(-ENOMEM);
> diff --git a/fs/ceph/mds_client.h b/fs/ceph/mds_client.h
> index 7c839a1183e5..7645cecf7fb0 100644
> --- a/fs/ceph/mds_client.h
> +++ b/fs/ceph/mds_client.h
> @@ -201,6 +201,9 @@ struct ceph_mds_session {
>  
>  	struct list_head  s_waiting;  /* waiting requests */
>  	struct list_head  s_unsafe;   /* unsafe requests */
> +
> +	struct percpu_counter i_caps_hit;
> +	struct percpu_counter i_caps_mis;
>  };
>  
>  /*
> diff --git a/fs/ceph/quota.c b/fs/ceph/quota.c
> index de56dee60540..7b248f698100 100644
> --- a/fs/ceph/quota.c
> +++ b/fs/ceph/quota.c
> @@ -147,9 +147,13 @@ static struct inode *lookup_quotarealm_inode(struct ceph_mds_client *mdsc,
>  		return NULL;
>  	}
>  	if (qri->inode) {
> +		int ret;
> +
> +		__ceph_caps_metric(ceph_inode(qri->inode), CEPH_STAT_CAP_INODE);
> +
>  		/* get caps */
> -		int ret = __ceph_do_getattr(qri->inode, NULL,
> -					    CEPH_STAT_CAP_INODE, true);
> +		ret = __ceph_do_getattr(qri->inode, NULL,
> +					CEPH_STAT_CAP_INODE, true);
>  		if (ret >= 0)
>  			in = qri->inode;
>  		else
> diff --git a/fs/ceph/super.h b/fs/ceph/super.h
> index 7af91628636c..7a6f9913c8f1 100644
> --- a/fs/ceph/super.h
> +++ b/fs/ceph/super.h
> @@ -642,6 +642,7 @@ static inline bool __ceph_is_any_real_caps(struct ceph_inode_info *ci)
>  }
>  
>  extern int __ceph_caps_issued(struct ceph_inode_info *ci, int *implemented);
> +extern void __ceph_caps_metric(struct ceph_inode_info *ci, int mask);
>  extern int __ceph_caps_issued_mask(struct ceph_inode_info *ci, int mask, int t);
>  extern int __ceph_caps_issued_other(struct ceph_inode_info *ci,
>  				    struct ceph_cap *cap);
> @@ -927,6 +928,11 @@ extern int __ceph_do_getattr(struct inode *inode, struct page *locked_page,
>  			     int mask, bool force);
>  static inline int ceph_do_getattr(struct inode *inode, int mask, bool force)
>  {
> +	struct ceph_inode_info *ci = ceph_inode(inode);
> +
> +	spin_lock(&ci->i_ceph_lock);
> +	__ceph_caps_metric(ci, mask);
> +	spin_unlock(&ci->i_ceph_lock);
>  	return __ceph_do_getattr(inode, NULL, mask, force);
>  }
>  extern int ceph_permission(struct inode *inode, int mask);
> diff --git a/fs/ceph/xattr.c b/fs/ceph/xattr.c
> index 98a9a3101cda..f3b1149ff7c5 100644
> --- a/fs/ceph/xattr.c
> +++ b/fs/ceph/xattr.c
> @@ -829,6 +829,7 @@ ssize_t __ceph_getxattr(struct inode *inode, const char *name, void *value,
>  	struct ceph_vxattr *vxattr = NULL;
>  	int req_mask;
>  	ssize_t err;
> +	int ret = -1;
>  
>  	/* let's see if a virtual xattr was requested */
>  	vxattr = ceph_match_vxattr(inode, name);
> @@ -856,7 +857,9 @@ ssize_t __ceph_getxattr(struct inode *inode, const char *name, void *value,
>  
>  	if (ci->i_xattrs.version == 0 ||
>  	    !((req_mask & CEPH_CAP_XATTR_SHARED) ||
> -	      __ceph_caps_issued_mask(ci, CEPH_CAP_XATTR_SHARED, 1))) {
> +	      (ret = __ceph_caps_issued_mask(ci, CEPH_CAP_XATTR_SHARED, 1)))) {
> +		if (ret != -1)
> +			__ceph_caps_metric(ci, CEPH_CAP_XATTR_SHARED);
>  		spin_unlock(&ci->i_ceph_lock);
>  
>  		/* security module gets xattr while filling trace */
> @@ -871,6 +874,9 @@ ssize_t __ceph_getxattr(struct inode *inode, const char *name, void *value,
>  		if (err)
>  			return err;
>  		spin_lock(&ci->i_ceph_lock);
> +	} else {
> +		if (ret != -1)
> +			__ceph_caps_metric(ci, CEPH_CAP_XATTR_SHARED);
>  	}
>  
>  	err = __build_xattrs(inode);
> @@ -907,19 +913,24 @@ ssize_t ceph_listxattr(struct dentry *dentry, char *names, size_t size)
>  	struct ceph_inode_info *ci = ceph_inode(inode);
>  	bool len_only = (size == 0);
>  	u32 namelen;
> -	int err;
> +	int err, ret = -1;
>  
>  	spin_lock(&ci->i_ceph_lock);
>  	dout("listxattr %p ver=%lld index_ver=%lld\n", inode,
>  	     ci->i_xattrs.version, ci->i_xattrs.index_version);
>  
>  	if (ci->i_xattrs.version == 0 ||
> -	    !__ceph_caps_issued_mask(ci, CEPH_CAP_XATTR_SHARED, 1)) {
> +	    !(ret = __ceph_caps_issued_mask(ci, CEPH_CAP_XATTR_SHARED, 1))) {
> +		if (ret != -1)
> +			__ceph_caps_metric(ci, CEPH_CAP_XATTR_SHARED);
>  		spin_unlock(&ci->i_ceph_lock);
>  		err = ceph_do_getattr(inode, CEPH_STAT_CAP_XATTR, true);
>  		if (err)
>  			return err;
>  		spin_lock(&ci->i_ceph_lock);
> +	} else {
> +		if (ret != -1)
> +			__ceph_caps_metric(ci, CEPH_CAP_XATTR_SHARED);
>  	}
>  
>  	err = __build_xattrs(inode);

-- 
Jeff Layton <jlayton@kernel.org>

