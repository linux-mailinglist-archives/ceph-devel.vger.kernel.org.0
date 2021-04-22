Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ABC40367DA2
	for <lists+ceph-devel@lfdr.de>; Thu, 22 Apr 2021 11:24:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235528AbhDVJZQ (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 22 Apr 2021 05:25:16 -0400
Received: from mx2.suse.de ([195.135.220.15]:51744 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230270AbhDVJZQ (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Thu, 22 Apr 2021 05:25:16 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 2F7C5AFE6;
        Thu, 22 Apr 2021 09:24:41 +0000 (UTC)
Received: from localhost (brahms [local])
        by brahms (OpenSMTPD) with ESMTPA id bf5f97e7;
        Thu, 22 Apr 2021 09:26:10 +0000 (UTC)
From:   Luis Henriques <lhenriques@suse.de>
To:     Jeff Layton <jlayton@kernel.org>
Cc:     ceph-devel@vger.kernel.org, xiubli@redhat.com, pdonnell@redhat.com,
        idryomov@redhat.com
Subject: Re: [PATCH v3] ceph: don't allow access to MDS-private inodes
References: <20210421183339.66129-1-jlayton@kernel.org>
Date:   Thu, 22 Apr 2021 10:26:10 +0100
In-Reply-To: <20210421183339.66129-1-jlayton@kernel.org> (Jeff Layton's
        message of "Wed, 21 Apr 2021 14:33:39 -0400")
Message-ID: <87o8e68ybx.fsf@suse.de>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Jeff Layton <jlayton@kernel.org> writes:

> The MDS reserves a set of inodes for its own usage, and these should
> never be accessible to clients. Add a new helper to vet a proposed
> inode number against that range, and complain loudly and refuse to
> create or look it up if it's in it.
>
> Also, ensure that the MDS doesn't try to delegate inodes that are in
> that range or lower. Print a warning if it does, and don't save the
> range in the xarray.
>
> URL: https://tracker.ceph.com/issues/49922
> Signed-off-by: Jeff Layton <jlayton@kernel.org>
> Signed-off-by: Xiubo Li<xiubli@redhat.com>
> Reviewed-by: Patrick Donnelly <pdonnell@redhat.com>
> ---
>  fs/ceph/export.c     |  8 ++++++++
>  fs/ceph/inode.c      |  3 +++
>  fs/ceph/mds_client.c |  7 +++++++
>  fs/ceph/super.h      | 24 ++++++++++++++++++++++++
>  4 files changed, 42 insertions(+)
>
> This one carves out inode numbers 1..0xff as allowed. There are probably
> some in that range that shouldn't be, but most of them qualify. This
> should cover the main range we're concerned with anyway.

OK, v3 does indeed fix the problem I reported yesterday.  Thanks!

Cheers,
-- 
Luis


>
> diff --git a/fs/ceph/export.c b/fs/ceph/export.c
> index 17d8c8f4ec89..65540a4429b2 100644
> --- a/fs/ceph/export.c
> +++ b/fs/ceph/export.c
> @@ -129,6 +129,10 @@ static struct inode *__lookup_inode(struct super_block *sb, u64 ino)
>  
>  	vino.ino = ino;
>  	vino.snap = CEPH_NOSNAP;
> +
> +	if (ceph_vino_is_reserved(vino))
> +		return ERR_PTR(-ESTALE);
> +
>  	inode = ceph_find_inode(sb, vino);
>  	if (!inode) {
>  		struct ceph_mds_request *req;
> @@ -214,6 +218,10 @@ static struct dentry *__snapfh_to_dentry(struct super_block *sb,
>  		vino.ino = sfh->ino;
>  		vino.snap = sfh->snapid;
>  	}
> +
> +	if (ceph_vino_is_reserved(vino))
> +		return ERR_PTR(-ESTALE);
> +
>  	inode = ceph_find_inode(sb, vino);
>  	if (inode)
>  		return d_obtain_alias(inode);
> diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
> index 14a1f7963625..e1c63adb196d 100644
> --- a/fs/ceph/inode.c
> +++ b/fs/ceph/inode.c
> @@ -56,6 +56,9 @@ struct inode *ceph_get_inode(struct super_block *sb, struct ceph_vino vino)
>  {
>  	struct inode *inode;
>  
> +	if (ceph_vino_is_reserved(vino))
> +		return ERR_PTR(-EREMOTEIO);
> +
>  	inode = iget5_locked(sb, (unsigned long)vino.ino, ceph_ino_compare,
>  			     ceph_set_ino_cb, &vino);
>  	if (!inode)
> diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
> index 63b53098360c..e5af591d3bd4 100644
> --- a/fs/ceph/mds_client.c
> +++ b/fs/ceph/mds_client.c
> @@ -440,6 +440,13 @@ static int ceph_parse_deleg_inos(void **p, void *end,
>  
>  		ceph_decode_64_safe(p, end, start, bad);
>  		ceph_decode_64_safe(p, end, len, bad);
> +
> +		/* Don't accept a delegation of system inodes */
> +		if (start < CEPH_INO_SYSTEM_BASE) {
> +			pr_warn_ratelimited("ceph: ignoring reserved inode range delegation (start=0x%llx len=0x%llx)\n",
> +					start, len);
> +			continue;
> +		}
>  		while (len--) {
>  			int err = xa_insert(&s->s_delegated_inos, ino = start++,
>  					    DELEGATED_INO_AVAILABLE,
> diff --git a/fs/ceph/super.h b/fs/ceph/super.h
> index df0851b9240e..db80d89556b1 100644
> --- a/fs/ceph/super.h
> +++ b/fs/ceph/super.h
> @@ -529,10 +529,34 @@ static inline int ceph_ino_compare(struct inode *inode, void *data)
>  		ci->i_vino.snap == pvino->snap;
>  }
>  
> +/*
> + * The MDS reserves a set of inodes for its own usage. These should never
> + * be accessible by clients, and so the MDS has no reason to ever hand these
> + * out. The range is CEPH_MDS_INO_MDSDIR_OFFSET..CEPH_INO_SYSTEM_BASE.
> + *
> + * These come from src/mds/mdstypes.h in the ceph sources.
> + */
> +#define CEPH_MAX_MDS		0x100
> +#define CEPH_NUM_STRAY		10
> +#define CEPH_MDS_INO_MDSDIR_OFFSET	(1 * CEPH_MAX_MDS)
> +#define CEPH_INO_SYSTEM_BASE		((6*CEPH_MAX_MDS) + (CEPH_MAX_MDS * CEPH_NUM_STRAY))
> +
> +static inline bool ceph_vino_is_reserved(const struct ceph_vino vino)
> +{
> +	if (vino.ino < CEPH_INO_SYSTEM_BASE &&
> +	    vino.ino >= CEPH_MDS_INO_MDSDIR_OFFSET) {
> +		WARN_RATELIMIT(1, "Attempt to access reserved inode number 0x%llx", vino.ino);
> +		return true;
> +	}
> +	return false;
> +}
>  
>  static inline struct inode *ceph_find_inode(struct super_block *sb,
>  					    struct ceph_vino vino)
>  {
> +	if (ceph_vino_is_reserved(vino))
> +		return NULL;
> +
>  	/*
>  	 * NB: The hashval will be run through the fs/inode.c hash function
>  	 * anyway, so there is no need to squash the inode number down to
> -- 
>
> 2.31.1
>
