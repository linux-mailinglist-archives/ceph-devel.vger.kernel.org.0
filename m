Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F1F002C81E
	for <lists+ceph-devel@lfdr.de>; Tue, 28 May 2019 15:49:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727491AbfE1Ntf (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 28 May 2019 09:49:35 -0400
Received: from mail-yb1-f196.google.com ([209.85.219.196]:35191 "EHLO
        mail-yb1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727387AbfE1Nte (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 28 May 2019 09:49:34 -0400
Received: by mail-yb1-f196.google.com with SMTP id s69so7696514ybi.2
        for <ceph-devel@vger.kernel.org>; Tue, 28 May 2019 06:49:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=fojo91cC1BG3EaLB2mIj0pqxRxA9HSnsRGG7xLnwkRQ=;
        b=d+WfQby7jRoSCrkX4OkJX6L/Cfxw9kNxmwPA6W+KvA6bvpTRQgnXhF/8BXiTrqNOMn
         Xy+aZjPunpngUJ4bAYtmFQ5J814g2MiCOWqSXpx49edXG5oV74q34RmLJ6TXJuZHcUiE
         9+diobX1akqdpWJ19E0w5/H2G37JEk5wYT0zDLdjcJVWuEvpZAgWvqUuhU+pHJMzkFIk
         9WgVPPrh0tVYn+3m3PhiLmM1I+5+SOi59gSDZXJt0OAopTlX8F8PG9xy4wQ0GURgb4T9
         WifexqaR+3ulrVRy4R7ugsn/C8ZifpC1dmcn1l7+iJJCxsBOOmV/QmbL3CkI398EJzpP
         it7g==
X-Gm-Message-State: APjAAAU+UbpjTE5myAVU+4FPFrBBp/tR4Cc32Q9xgGIsZD3G9CtrnDd5
        fAvlgsNr2DPfLkBXT9pPC7kHuQ==
X-Google-Smtp-Source: APXvYqwxmvU52iVnAE8/1pcpmT3yys232rYwZl+5Woyd/VN/LTm6UzxS1+925+DwndxaL/QrxNLeHQ==
X-Received: by 2002:a25:556:: with SMTP id 83mr22636348ybf.155.1559051373961;
        Tue, 28 May 2019 06:49:33 -0700 (PDT)
Received: from tleilax.poochiereds.net (cpe-2606-A000-1100-37D-0-0-0-4F7.dyn6.twc.com. [2606:a000:1100:37d::4f7])
        by smtp.gmail.com with ESMTPSA id 185sm3629337ywn.12.2019.05.28.06.49.33
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 28 May 2019 06:49:33 -0700 (PDT)
Message-ID: <98860d8ffeb81da0d31fa3fc375fc354904d4279.camel@redhat.com>
Subject: Re: [PATCH 4/8] ceph: close race between d_name_cmp() and
 update_dentry_lease()
From:   Jeff Layton <jlayton@redhat.com>
To:     "Yan, Zheng" <zyan@redhat.com>, ceph-devel@vger.kernel.org
Cc:     idryomov@redhat.com
Date:   Tue, 28 May 2019 09:49:32 -0400
In-Reply-To: <20190523081345.20410-4-zyan@redhat.com>
References: <20190523081345.20410-1-zyan@redhat.com>
         <20190523081345.20410-4-zyan@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.32.2 (3.32.2-1.fc30) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Thu, 2019-05-23 at 16:13 +0800, Yan, Zheng wrote:
> d_name_cmp() and update_dentry_lease() lock and unlock dentry->d_lock
> respectively. Dentry may get renamed between them. The fix is moving
> the dentry name compare into update_dentry_lease().
> 
> This patch introduce two version of update_dentry_lease(). One version
> is for the case that parent inode is locked. It does not need to check
> parent/target inode and dentry name. Another version is for the case
> that parent inode is not locked. It checks arent/target inode and dentry
> name after locking dentry->d_lock.
> 
> Signed-off-by: "Yan, Zheng" <zyan@redhat.com>
> ---
>  fs/ceph/inode.c | 164 ++++++++++++++++++++++++++----------------------
>  1 file changed, 88 insertions(+), 76 deletions(-)
> 
> diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
> index 8cfece240ffe..e47a25495be5 100644
> --- a/fs/ceph/inode.c
> +++ b/fs/ceph/inode.c
> @@ -1031,59 +1031,38 @@ static int fill_inode(struct inode *inode, struct page *locked_page,
>  }
>  
>  /*
> - * caller should hold session s_mutex.
> + * caller should hold session s_mutex and dentry->d_lock.
>   */
> -static void update_dentry_lease(struct dentry *dentry,
> -				struct ceph_mds_reply_lease *lease,
> -				struct ceph_mds_session *session,
> -				unsigned long from_time,
> -				struct ceph_vino *tgt_vino,
> -				struct ceph_vino *dir_vino)
> +static void __update_dentry_lease(struct inode *dir, struct dentry *dentry,
> +				  struct ceph_mds_reply_lease *lease,
> +				  struct ceph_mds_session *session,
> +				  unsigned long from_time,
> +				  struct ceph_mds_session **old_lease_session)
>  {
>  	struct ceph_dentry_info *di = ceph_dentry(dentry);
>  	long unsigned duration = le32_to_cpu(lease->duration_ms);
>  	long unsigned ttl = from_time + (duration * HZ) / 1000;
>  	long unsigned half_ttl = from_time + (duration * HZ / 2) / 1000;
> -	struct inode *dir;
> -	struct ceph_mds_session *old_lease_session = NULL;
> -
> -	/*
> -	 * Make sure dentry's inode matches tgt_vino. NULL tgt_vino means that
> -	 * we expect a negative dentry.
> -	 */
> -	if (!tgt_vino && d_really_is_positive(dentry))
> -		return;
> -
> -	if (tgt_vino && (d_really_is_negative(dentry) ||
> -			!ceph_ino_compare(d_inode(dentry), tgt_vino)))
> -		return;
>  
> -	spin_lock(&dentry->d_lock);
>  	dout("update_dentry_lease %p duration %lu ms ttl %lu\n",
>  	     dentry, duration, ttl);
>  
> -	dir = d_inode(dentry->d_parent);
> -
> -	/* make sure parent matches dir_vino */
> -	if (!ceph_ino_compare(dir, dir_vino))
> -		goto out_unlock;
> -
>  	/* only track leases on regular dentries */
>  	if (ceph_snap(dir) != CEPH_NOSNAP)
> -		goto out_unlock;
> +		return;
>  
>  	di->lease_shared_gen = atomic_read(&ceph_inode(dir)->i_shared_gen);
>  	if (duration == 0) {
>  		__ceph_dentry_dir_lease_touch(di);
> -		goto out_unlock;
> +		return;
>  	}
>  
>  	if (di->lease_gen == session->s_cap_gen &&
>  	    time_before(ttl, di->time))
> -		goto out_unlock;  /* we already have a newer lease. */
> +		return;  /* we already have a newer lease. */
>  
>  	if (di->lease_session && di->lease_session != session) {
> -		old_lease_session = di->lease_session;
> +		*old_lease_session = di->lease_session;
>  		di->lease_session = NULL;
>  	}
>  
> @@ -1096,6 +1075,62 @@ static void update_dentry_lease(struct dentry *dentry,
>  	di->time = ttl;
>  
>  	__ceph_dentry_lease_touch(di);
> +}
> +
> +static inline void update_dentry_lease(struct inode *dir, struct dentry *dentry,
> +					struct ceph_mds_reply_lease *lease,
> +					struct ceph_mds_session *session,
> +					unsigned long from_time)
> +{
> +	struct ceph_mds_session *old_lease_session = NULL;
> +	spin_lock(&dentry->d_lock);
> +	__update_dentry_lease(dir, dentry, lease, session, from_time,
> +			      &old_lease_session);
> +	spin_unlock(&dentry->d_lock);
> +	if (old_lease_session)
> +		ceph_put_mds_session(old_lease_session);
> +}
> +
> +/*
> + * update dentry lease without having parent inode locked
> + */
> +static void update_dentry_lease_careful(struct dentry *dentry,
> +					struct ceph_mds_reply_lease *lease,
> +					struct ceph_mds_session *session,
> +					unsigned long from_time,
> +					char *dname, u32 dname_len,
> +					struct ceph_vino *pdvino,
> +					struct ceph_vino *ptvino)
> +

This argument list is huge. I wonder if we'd be better off passing in a
pointer to "req" instead and getting some of the fields from that. For
instance, session, from_time, etc...

> +{
> +	struct inode *dir;
> +	struct ceph_mds_session *old_lease_session = NULL;
> +
> +	spin_lock(&dentry->d_lock);
> +	/* make sure dentry's name matches target */
> +	if (dentry->d_name.len != dname_len ||
> +	    memcmp(dentry->d_name.name, dname, dname_len))
> +		goto out_unlock;
> +
> +	dir = d_inode(dentry->d_parent);
> +	/* make sure parent matches dvino */
> +	if (!ceph_ino_compare(dir, pdvino))
> +		goto out_unlock;
> +
> +	/* make sure dentry's inode matches target. NULL ptvino means that
> +	 * we expect a negative dentry */
> +	if (ptvino) {
> +		if (d_really_is_negative(dentry))
> +			goto out_unlock;
> +		if (!ceph_ino_compare(d_inode(dentry), ptvino))
> +			goto out_unlock;
> +	} else {
> +		if (d_really_is_positive(dentry))
> +			goto out_unlock;
> +	}
> +
> +	__update_dentry_lease(dir, dentry, lease, session,
> +			      from_time, &old_lease_session);
>  out_unlock:
>  	spin_unlock(&dentry->d_lock);
>  	if (old_lease_session)
> @@ -1160,19 +1195,6 @@ static int splice_dentry(struct dentry **pdn, struct inode *in)
>  	return 0;
>  }
>  
> -static int d_name_cmp(struct dentry *dentry, const char *name, size_t len)
> -{
> -	int ret;
> -
> -	/* take d_lock to ensure dentry->d_name stability */
> -	spin_lock(&dentry->d_lock);
> -	ret = dentry->d_name.len - len;
> -	if (!ret)
> -		ret = memcmp(dentry->d_name.name, name, len);
> -	spin_unlock(&dentry->d_lock);
> -	return ret;
> -}
> -
>  /*
>   * Incorporate results into the local cache.  This is either just
>   * one inode, or a directory, dentry, and possibly linked-to inode (e.g.,
> @@ -1375,10 +1397,9 @@ int ceph_fill_trace(struct super_block *sb, struct ceph_mds_request *req)
>  			} else if (have_lease) {
>  				if (d_unhashed(dn))
>  					d_add(dn, NULL);
> -				update_dentry_lease(dn, rinfo->dlease,
> -						    session,
> -						    req->r_request_started,
> -						    NULL, &dvino);
> +				update_dentry_lease(dir, dn,
> +						    rinfo->dlease, session,
> +						    req->r_request_started);
>  			}
>  			goto done;
>  		}
> @@ -1400,11 +1421,9 @@ int ceph_fill_trace(struct super_block *sb, struct ceph_mds_request *req)
>  		}
>  
>  		if (have_lease) {
> -			tvino.ino = le64_to_cpu(rinfo->targeti.in->ino);
> -			tvino.snap = le64_to_cpu(rinfo->targeti.in->snapid);
> -			update_dentry_lease(dn, rinfo->dlease, session,
> -					    req->r_request_started,
> -					    &tvino, &dvino);
> +			update_dentry_lease(dir, dn,
> +					    rinfo->dlease, session,
> +					    req->r_request_started);
>  		}
>  		dout(" final dn %p\n", dn);
>  	} else if ((req->r_op == CEPH_MDS_OP_LOOKUPSNAP ||
> @@ -1422,27 +1441,20 @@ int ceph_fill_trace(struct super_block *sb, struct ceph_mds_request *req)
>  		err = splice_dentry(&req->r_dentry, in);
>  		if (err < 0)
>  			goto done;
> -	} else if (rinfo->head->is_dentry &&
> -		   !d_name_cmp(req->r_dentry, rinfo->dname, rinfo->dname_len)) {
> +	} else if (rinfo->head->is_dentry && req->r_dentry) {
> +		/* parent inode is not locked, be carefull */
>  		struct ceph_vino *ptvino = NULL;
> -
> -		if ((le32_to_cpu(rinfo->diri.in->cap.caps) & CEPH_CAP_FILE_SHARED) ||
> -		    le32_to_cpu(rinfo->dlease->duration_ms)) {
> -			dvino.ino = le64_to_cpu(rinfo->diri.in->ino);
> -			dvino.snap = le64_to_cpu(rinfo->diri.in->snapid);
> -
> -			if (rinfo->head->is_target) {
> -				tvino.ino = le64_to_cpu(rinfo->targeti.in->ino);
> -				tvino.snap = le64_to_cpu(rinfo->targeti.in->snapid);
> -				ptvino = &tvino;
> -			}
> -
> -			update_dentry_lease(req->r_dentry, rinfo->dlease,
> -				session, req->r_request_started, ptvino,
> -				&dvino);
> -		} else {
> -			dout("%s: no dentry lease or dir cap\n", __func__);
> +		dvino.ino = le64_to_cpu(rinfo->diri.in->ino);
> +		dvino.snap = le64_to_cpu(rinfo->diri.in->snapid);
> +		if (rinfo->head->is_target) {
> +			tvino.ino = le64_to_cpu(rinfo->targeti.in->ino);
> +			tvino.snap = le64_to_cpu(rinfo->targeti.in->snapid);
> +			ptvino = &tvino;
>  		}
> +		update_dentry_lease_careful(req->r_dentry, rinfo->dlease,
> +					    session, req->r_request_started,
> +					    rinfo->dname, rinfo->dname_len,
> +					    &dvino, ptvino);
> 	}
>  done:
>  	dout("fill_trace done err=%d\n", err);
> @@ -1604,7 +1616,7 @@ int ceph_readdir_prepopulate(struct ceph_mds_request *req,
>  	/* FIXME: release caps/leases if error occurs */
>  	for (i = 0; i < rinfo->dir_nr; i++) {
>  		struct ceph_mds_reply_dir_entry *rde = rinfo->dir_entries + i;
> -		struct ceph_vino tvino, dvino;
> +		struct ceph_vino tvino;
>  
>  		dname.name = rde->name;
>  		dname.len = rde->name_len;
> @@ -1705,9 +1717,9 @@ int ceph_readdir_prepopulate(struct ceph_mds_request *req,
>  
>  		ceph_dentry(dn)->offset = rde->offset;
>  
> -		dvino = ceph_vino(d_inode(parent));
> -		update_dentry_lease(dn, rde->lease, req->r_session,
> -				    req->r_request_started, &tvino, &dvino);
> +		update_dentry_lease(d_inode(parent), dn,
> +				    rde->lease, req->r_session,
> +				    req->r_request_started);
>  
>  		if (err == 0 && skipped == 0 && cache_ctl.index >= 0) {
>  			ret = fill_readdir_cache(d_inode(parent), dn,

That said...

Reviewed-by: Jeff Layton <jlayton@redhat.com>

