Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D0F13662D9
	for <lists+ceph-devel@lfdr.de>; Wed, 21 Apr 2021 02:06:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233860AbhDUAGg (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 20 Apr 2021 20:06:36 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:35583 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233752AbhDUAGf (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Tue, 20 Apr 2021 20:06:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1618963563;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=UdQHR7aRZDzCivigH4x4n7Tukq2rAu2TENO3SXddu1E=;
        b=Ue7mlzbv38DHl4WKpdvxLZXVehB+6yD3e57pTGCFz2WxJnFvpys8NgGVlkee4f3A6DdV6h
        IbuBcYZrw+TUDJK3vXUcSACS/9JsliuhWAbhaGohHiO8iT1lBt421VVw7/lPnARmdHEaa+
        PnWcCEdX73SBCoOlovGFV4trtKhYnbc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-72-T8RkpNeTPqG16sVXBL26Tw-1; Tue, 20 Apr 2021 20:05:59 -0400
X-MC-Unique: T8RkpNeTPqG16sVXBL26Tw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 84252343A0;
        Wed, 21 Apr 2021 00:05:58 +0000 (UTC)
Received: from [10.72.13.181] (ovpn-13-181.pek2.redhat.com [10.72.13.181])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 23CA56091A;
        Wed, 21 Apr 2021 00:05:55 +0000 (UTC)
Subject: Re: [PATCH v2] ceph: don't allow access to MDS-private inodes
To:     Jeff Layton <jlayton@kernel.org>, ceph-devel@vger.kernel.org
Cc:     pdonnell@redhat.com, idryomov@redhat.com
References: <20210420140639.33705-1-jlayton@kernel.org>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <20a033e3-06b2-cff1-dc1f-a5518cd7fd3a@redhat.com>
Date:   Wed, 21 Apr 2021 08:05:51 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.1
MIME-Version: 1.0
In-Reply-To: <20210420140639.33705-1-jlayton@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On 2021/4/20 22:06, Jeff Layton wrote:
> The MDS reserves a set of inodes for its own usage, and these should
> never be accessible to clients. Add a new helper to vet a proposed
> inode number against that range, and complain loudly and refuse to
> create or look it up if it's in it. We do need to carve out an exception
> for the root and the lost+found directories.
>
> Also, ensure that the MDS doesn't try to delegate that range to us
> either. Print a warning if it does, and don't save the range in the
> xarray.
>
> URL: https://tracker.ceph.com/issues/49922
> Signed-off-by: Jeff Layton <jlayton@kernel.org>
> Signed-off-by: Xiubo Li<xiubli@redhat.com>
> Reviewed-by: Patrick Donnelly <pdonnell@redhat.com>
> ---
>   fs/ceph/export.c             |  8 ++++++++
>   fs/ceph/inode.c              |  3 +++
>   fs/ceph/mds_client.c         |  7 +++++++
>   fs/ceph/super.h              | 24 ++++++++++++++++++++++++
>   include/linux/ceph/ceph_fs.h |  7 ++++---
>   5 files changed, 46 insertions(+), 3 deletions(-)
>
> v2: allow lookups of lost+found dir inodes
>      flesh out and update the CEPH_INO_* definitions
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
> index 14a1f7963625..e1c63adb196d 100644
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
> index 63b53098360c..e5af591d3bd4 100644
> --- a/fs/ceph/mds_client.c
> +++ b/fs/ceph/mds_client.c
> @@ -440,6 +440,13 @@ static int ceph_parse_deleg_inos(void **p, void *end,
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
> index df0851b9240e..f1745403c9b0 100644
> --- a/fs/ceph/super.h
> +++ b/fs/ceph/super.h
> @@ -529,10 +529,34 @@ static inline int ceph_ino_compare(struct inode *inode, void *data)
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
> +	if (vino.ino < CEPH_INO_SYSTEM_BASE &&
> +	    vino.ino != CEPH_INO_ROOT &&
> +	    vino.ino != CEPH_INO_LOST_AND_FOUND) {
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
> diff --git a/include/linux/ceph/ceph_fs.h b/include/linux/ceph/ceph_fs.h
> index e41a811026f6..3c90ae21a7e1 100644
> --- a/include/linux/ceph/ceph_fs.h
> +++ b/include/linux/ceph/ceph_fs.h
> @@ -27,9 +27,10 @@
>   #define CEPH_MONC_PROTOCOL   15 /* server/client */
>   
>   
> -#define CEPH_INO_ROOT   1
> -#define CEPH_INO_CEPH   2       /* hidden .ceph dir */
> -#define CEPH_INO_DOTDOT 3	/* used by ceph fuse for parent (..) */
> +#define CEPH_INO_ROOT			1 /* root inode number for all cephfs's */
> +#define CEPH_INO_CEPH			2 /* hidden .ceph dir */
> +#define CEPH_INO_GLOBAL_SNAPREALM	3 /* includes all snapshots in the fs */
> +#define CEPH_INO_LOST_AND_FOUND		4 /* lost+found dir */
>   
>   /* arbitrary limit on max # of monitors (cluster of 3 is typical) */
>   #define CEPH_MAX_MON   31

LTGM. Thanks.

