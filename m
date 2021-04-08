Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC3E835797F
	for <lists+ceph-devel@lfdr.de>; Thu,  8 Apr 2021 03:18:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229510AbhDHBS1 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 7 Apr 2021 21:18:27 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:52128 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229505AbhDHBS0 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 7 Apr 2021 21:18:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1617844694;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=R2KpdVf5TfH5b1ZFttEH7LRXyP3NASjRKBtmc+sX0Rk=;
        b=OL1gABhvRFF5jzPuRBP5+SBNY3gHcdXl15U3hsWjaRyBNYYhpJgTi/O+OED4qroJ7GIO8R
        lIGpvqDTRPi+kLHS/P0XUxvm6ETXRhLkxNx1goQT9ZQQBxt/wQVd32yEkSsPXN+K7n1QpH
        tYZOxC6l1CGetpql7LzB3hspwx2mUzw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-235-L05Rde0lNiSD5pVJPpgbdA-1; Wed, 07 Apr 2021 21:18:06 -0400
X-MC-Unique: L05Rde0lNiSD5pVJPpgbdA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id EDD7B1006C81;
        Thu,  8 Apr 2021 01:18:04 +0000 (UTC)
Received: from [10.72.12.53] (ovpn-12-53.pek2.redhat.com [10.72.12.53])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 3FA9E669EC;
        Thu,  8 Apr 2021 01:17:55 +0000 (UTC)
Subject: Re: [PATCH] ceph: don't allow access to MDS-private inodes
To:     Jeff Layton <jlayton@kernel.org>, ceph-devel@vger.kernel.org
Cc:     pdonnell@redhat.com, ukernel@gmail.com, idryomov@gmail.com
References: <20210405113254.8085-1-jlayton@kernel.org>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <db4c5499-2f0e-2106-088e-0eb774a467a5@redhat.com>
Date:   Thu, 8 Apr 2021 09:17:52 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.0
MIME-Version: 1.0
In-Reply-To: <20210405113254.8085-1-jlayton@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On 2021/4/5 19:32, Jeff Layton wrote:
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
>   fs/ceph/export.c     |  8 ++++++++
>   fs/ceph/inode.c      |  3 +++
>   fs/ceph/mds_client.c |  7 +++++++
>   fs/ceph/super.h      | 22 ++++++++++++++++++++++
>   4 files changed, 40 insertions(+)
>
> diff --git a/fs/ceph/export.c b/fs/ceph/export.c
> index 17d8c8f4ec89..65540a4429b2 100644
> --- a/fs/ceph/export.c
> +++ b/fs/ceph/export.c
> @@ -129,6 +129,10 @@ static struct inode *__lookup_inode(struct super_block *sb, u64 ino)
>   
>   	vino.ino = ino;
>   	vino.snap = CEPH_NOSNAP;
> +
> +	if (ceph_vino_is_reserved(vino))
> +		return ERR_PTR(-ESTALE);
> +
>   	inode = ceph_find_inode(sb, vino);
>   	if (!inode) {
>   		struct ceph_mds_request *req;
> @@ -214,6 +218,10 @@ static struct dentry *__snapfh_to_dentry(struct super_block *sb,
>   		vino.ino = sfh->ino;
>   		vino.snap = sfh->snapid;
>   	}
> +
> +	if (ceph_vino_is_reserved(vino))
> +		return ERR_PTR(-ESTALE);
> +
>   	inode = ceph_find_inode(sb, vino);
>   	if (inode)
>   		return d_obtain_alias(inode);
> diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
> index 2c512475c170..3f321ba801f1 100644
> --- a/fs/ceph/inode.c
> +++ b/fs/ceph/inode.c
> @@ -56,6 +56,9 @@ struct inode *ceph_get_inode(struct super_block *sb, struct ceph_vino vino)
>   {
>   	struct inode *inode;
>   
> +	if (ceph_vino_is_reserved(vino))
> +		return ERR_PTR(-EREMOTEIO);
> +
>   	inode = iget5_locked(sb, (unsigned long)vino.ino, ceph_ino_compare,
>   			     ceph_set_ino_cb, &vino);
>   	if (!inode)
> diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
> index 73ecb7d128c9..2d7dcd295bb9 100644
> --- a/fs/ceph/mds_client.c
> +++ b/fs/ceph/mds_client.c
> @@ -433,6 +433,13 @@ static int ceph_parse_deleg_inos(void **p, void *end,
>   
>   		ceph_decode_64_safe(p, end, start, bad);
>   		ceph_decode_64_safe(p, end, len, bad);
> +
> +		/* Don't accept a delegation of system inodes */
> +		if (start < CEPH_INO_SYSTEM_BASE) {
> +			pr_warn_ratelimited("ceph: ignoring reserved inode range delegation (start=0x%llx len=0x%llx)\n",
> +					start, len);
> +			continue;
> +		}
>   		while (len--) {
>   			int err = xa_insert(&s->s_delegated_inos, ino = start++,
>   					    DELEGATED_INO_AVAILABLE,
> diff --git a/fs/ceph/super.h b/fs/ceph/super.h
> index 5e0e1aeee1b5..1fe4cf385481 100644
> --- a/fs/ceph/super.h
> +++ b/fs/ceph/super.h
> @@ -529,10 +529,32 @@ static inline int ceph_ino_compare(struct inode *inode, void *data)
>   		ci->i_vino.snap == pvino->snap;
>   }
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
> +static inline bool ceph_vino_is_reserved(const struct ceph_vino vino)
> +{
> +	if (vino.ino < CEPH_INO_SYSTEM_BASE && vino.ino != CEPH_INO_ROOT) {
> +		WARN_RATELIMIT(1, "Attempt to access reserved inode number 0x%llx", vino.ino);
> +		return true;
> +	}
> +	return false;
> +}
>   
>   static inline struct inode *ceph_find_inode(struct super_block *sb,
>   					    struct ceph_vino vino)
>   {
> +	if (ceph_vino_is_reserved(vino))
> +		return NULL;
> +
>   	/*
>   	 * NB: The hashval will be run through the fs/inode.c hash function
>   	 * anyway, so there is no need to squash the inode number down to

Reviewed-by: Xiubo Li<xiubli@redhat.com>

