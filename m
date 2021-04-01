Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1060F3520A0
	for <lists+ceph-devel@lfdr.de>; Thu,  1 Apr 2021 22:33:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234874AbhDAUdH (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 1 Apr 2021 16:33:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:60000 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234114AbhDAUdH (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Thu, 1 Apr 2021 16:33:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E5C1E60232;
        Thu,  1 Apr 2021 20:33:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617309187;
        bh=4oMvH1+Sbc4JkukXp7VXzMKZqwcqQ6+86xXZcp3L5To=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=UHg6lrfLEjHWz3DzTFbGFvo0mT7druwtiXD0vCapNA/wJpAaqo/zCbjcxbSNZl6fL
         0s0fbwWnfcA6kuqrEpVbZ0tlD8o/JulA0bGoQeGavaxSsUR7UVrXtEaAo3Qxcl7PBB
         c79YrfrdDvQeQ1Rmmd655qph84U+/hdkaqMrYCyKLJjsAm1FAQWnVtnwHcWW2UWVmt
         XbY/igp4CKf6NZpzRohgtG9XB6w4a8kRgLNfRhq4d49VFQC1pMZfA9+yuj+0qQVcjM
         0SD8ylwlxR2K5QqR7FJ5HrszLNOF9JwdghpF2PKs2sB6yNuVvazPw07VIrk6ItWEod
         v1arZY6x4+B7Q==
Message-ID: <b1f1b809b255fd5fd622496ba5e5a53371d84441.camel@kernel.org>
Subject: Re: [RFC PATCH] ceph: don't allow access to MDS-private inodes
From:   Jeff Layton <jlayton@kernel.org>
To:     ceph-devel@vger.kernel.org
Cc:     pdonnell@redhat.com, ukernel@gmail.com,
        Ilya Dryomov <idryomov@gmail.com>
Date:   Thu, 01 Apr 2021 16:33:05 -0400
In-Reply-To: <20210401201611.32644-1-jlayton@kernel.org>
References: <20210401201611.32644-1-jlayton@kernel.org>
Content-Type: text/plain; charset="ISO-8859-15"
User-Agent: Evolution 3.38.4 (3.38.4-1.fc33) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Thu, 2021-04-01 at 16:16 -0400, Jeff Layton wrote:
> The MDS reserves a set of inodes for its own usage, and these should
> never be accessible to clients. Add a new helper to vet a proposed
> inode number against that range, and complain loudly and refuse to
> create or look it up if it's in it.
> 
> Also, ensure that the MDS doesn't try to delegate that range to us
> either. Print a warning if it does, and don't save the range in the
> xarray.
> 
> URL: https://tracker.ceph.com/issues/49922
> Signed-off-by: Jeff Layton <jlayton@kernel.org>
> ---
>  fs/ceph/inode.c      |  5 +++++
>  fs/ceph/mds_client.c |  7 +++++++
>  fs/ceph/super.h      | 24 ++++++++++++++++++++++++
>  3 files changed, 36 insertions(+)
> 

Should have cc'ed Ilya too -- mea culpa...

The idea here is to not allow the client to attempt to access this inode
number range (and gather some info about how it might be occurring).

This is RFC since Zheng seemed to indicate in a corresponding PR for the
MDS that there may be reason to allow the clients to get at these. If
there's not such a reason though, then I think something like this patch
would be good.

> diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
> index 2c512475c170..6aa796c59e1b 100644
> --- a/fs/ceph/inode.c
> +++ b/fs/ceph/inode.c
> @@ -54,8 +54,13 @@ static int ceph_set_ino_cb(struct inode *inode, void *data)
>  
>  struct inode *ceph_get_inode(struct super_block *sb, struct ceph_vino vino)
>  {
> +	int ret;
>  	struct inode *inode;
>  
> +	ret = ceph_vet_vino(vino);
> +	if (ret)
> +		return ERR_PTR(ret);
> +
>  	inode = iget5_locked(sb, (unsigned long)vino.ino, ceph_ino_compare,
>  			     ceph_set_ino_cb, &vino);
>  	if (!inode)
> diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
> index 73ecb7d128c9..2d7dcd295bb9 100644
> --- a/fs/ceph/mds_client.c
> +++ b/fs/ceph/mds_client.c
> @@ -433,6 +433,13 @@ static int ceph_parse_deleg_inos(void **p, void *end,
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
> index 5e0e1aeee1b5..1d63c5a28665 100644
> --- a/fs/ceph/super.h
> +++ b/fs/ceph/super.h
> @@ -529,10 +529,34 @@ static inline int ceph_ino_compare(struct inode *inode, void *data)
>  		ci->i_vino.snap == pvino->snap;
>  }
>  
> +/*
> + * The MDS reserves a set of inodes for its own usage. These should never
> + * be accessible by clients, and so the MDS has no reason to ever hand these
> + * out.
> + *
> + * These come from src/mds/mdstypes.h in the ceph sources.
> + */
> +#define CEPH_MAX_MDS		0x100
> +#define CEPH_NUM_STRAY		10
> +#define CEPH_INO_SYSTEM_BASE	((6*CEPH_MAX_MDS) + (CEPH_MAX_MDS * CEPH_NUM_STRAY))
> +
> +static inline int ceph_vet_vino(const struct ceph_vino vino)
> +{
> +	if (vino.ino < CEPH_INO_SYSTEM_BASE && vino.ino != CEPH_INO_ROOT) {
> +		WARN_RATELIMIT(1, "Attempt to access reserved inode number 0x%llx", vino.ino);
> +		return -EREMOTEIO;
> +	}
> +	return 0;
> +}
>  

I think I'll also need to fix up the LOOKUPINO callers in export.c as
well, and for that, I'll probably rework the above function to return
bool (and change the name). The callers will need to be changed
accordingly.

>  static inline struct inode *ceph_find_inode(struct super_block *sb,
>  					    struct ceph_vino vino)
>  {
> +	int ret = ceph_vet_vino(vino);
> +
> +	if (ret)
> +		return NULL;
> +
>  	/*
>  	 * NB: The hashval will be run through the fs/inode.c hash function
>  	 * anyway, so there is no need to squash the inode number down to

-- 
Jeff Layton <jlayton@kernel.org>

