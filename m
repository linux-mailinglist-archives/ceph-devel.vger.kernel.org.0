Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B59C646BF4E
	for <lists+ceph-devel@lfdr.de>; Tue,  7 Dec 2021 16:29:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238737AbhLGPdF (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 7 Dec 2021 10:33:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238634AbhLGPdE (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 7 Dec 2021 10:33:04 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21422C061746
        for <ceph-devel@vger.kernel.org>; Tue,  7 Dec 2021 07:29:34 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 57ACACE1B81
        for <ceph-devel@vger.kernel.org>; Tue,  7 Dec 2021 15:29:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3531C341C5;
        Tue,  7 Dec 2021 15:29:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638890970;
        bh=+4sZYRL0eTtAmxWrqHXDhZ+F57RSmKb3ZM/4XBcqmD0=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=GkaqoYZgD+J4fCHw5G//zOCP2uWGFgJTu4r1KXaR5u8OxJZV9GKK86YQE8kNM99PB
         p50eHhjo/0gX1TN8U24+L1R9KPYZE49JTUIYlAHVY4sWezyvMr9iJuMuxhEkE+aE/3
         Ly01UfWoSPrEDE+/RNiUwtp2dEC1SXS1YIF121LDx1rj17d8UxRrwjQJumeeUVhCDo
         T8SglKSjbQwlkbZl8kjAcBHgBV52xkhywqPhg2pzavxh3Y1MWPiDsgCUBdUqVRDFXa
         d/gXfkmMfUcAgmuzaBcY82PrKy134CFQi2r7b+huML4UD3bpgkdVe4LLe1ZcgpTjRt
         7JtXfgUVZTfgg==
Message-ID: <e666ba1d2db25a90de7e2582c31c36a6fb9854ab.camel@kernel.org>
Subject: Re: [PATCH v2] ceph: don't check for quotas on MDS stray dirs
From:   Jeff Layton <jlayton@kernel.org>
To:     ceph-devel@vger.kernel.org
Cc:     idryomov@gmail.com, lhenriques@suse.de,
        Hu Weiwen <sehuww@mail.scut.edu.cn>,
        Xiubo Li <xiubli@redhat.com>
Date:   Tue, 07 Dec 2021 10:29:28 -0500
In-Reply-To: <20211207152705.167010-1-jlayton@kernel.org>
References: <20211207152705.167010-1-jlayton@kernel.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.1 (3.42.1-1.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Tue, 2021-12-07 at 10:27 -0500, Jeff Layton wrote:
> 玮文 胡 reported seeing the WARN_RATELIMIT pop when writing to an
> inode that had been transplanted into the stray dir. The client was
> trying to look up the quotarealm info from the parent and that tripped
> the warning.
> 
> Change the ceph_vino_is_reserved helper to not throw a warning for
> MDS stray directories (0x100 - 0x1ff), only for reserved dirs that
> are not in that range.
> 
> Also, fix ceph_has_realms_with_quotas to return false when encountering
> a reserved inode.
> 
> URL: https://tracker.ceph.com/issues/53180
> Reported-by: Hu Weiwen <sehuww@mail.scut.edu.cn>
> Reviewed-by: Luis Henriques <lhenriques@suse.de>
> Reviewed-by: Xiubo Li <xiubli@redhat.com>

Oops, I forgot to remote the Reviewed-by: lines before sending since
this patch is different. The one in the testing branch has them removed.
Reviews of this patch would still be welcome.

> Signed-off-by: Jeff Layton <jlayton@kernel.org>
> ---
>  fs/ceph/quota.c |  3 +++
>  fs/ceph/super.h | 20 ++++++++++++--------
>  2 files changed, 15 insertions(+), 8 deletions(-)
> 
> I was still seeing some warnings even with the earlier patch, so I
> decided to rework it to just never warn on MDS stray dirs. This should
> also silence the warnings on MDS stray dirs (and also alleviate Luis'
> concern about the function renaming in the earlier patch).
> 
> diff --git a/fs/ceph/quota.c b/fs/ceph/quota.c
> index 24ae13ea2241..a338a3ec0dc4 100644
> --- a/fs/ceph/quota.c
> +++ b/fs/ceph/quota.c
> @@ -30,6 +30,9 @@ static inline bool ceph_has_realms_with_quotas(struct inode *inode)
>  	/* if root is the real CephFS root, we don't have quota realms */
>  	if (root && ceph_ino(root) == CEPH_INO_ROOT)
>  		return false;
> +	/* MDS stray dirs have no quota realms */
> +	if (ceph_vino_is_reserved(ceph_inode(inode)->i_vino))
> +		return false;
>  	/* otherwise, we can't know for sure */
>  	return true;
>  }
> diff --git a/fs/ceph/super.h b/fs/ceph/super.h
> index 387ee33894db..f9b1bbf26c1b 100644
> --- a/fs/ceph/super.h
> +++ b/fs/ceph/super.h
> @@ -541,19 +541,23 @@ static inline int ceph_ino_compare(struct inode *inode, void *data)
>   *
>   * These come from src/mds/mdstypes.h in the ceph sources.
>   */
> -#define CEPH_MAX_MDS		0x100
> -#define CEPH_NUM_STRAY		10
> +#define CEPH_MAX_MDS			0x100
> +#define CEPH_NUM_STRAY			10
>  #define CEPH_MDS_INO_MDSDIR_OFFSET	(1 * CEPH_MAX_MDS)
> +#define CEPH_MDS_INO_LOG_OFFSET		(2 * CEPH_MAX_MDS)
>  #define CEPH_INO_SYSTEM_BASE		((6*CEPH_MAX_MDS) + (CEPH_MAX_MDS * CEPH_NUM_STRAY))
>  
>  static inline bool ceph_vino_is_reserved(const struct ceph_vino vino)
>  {
> -	if (vino.ino < CEPH_INO_SYSTEM_BASE &&
> -	    vino.ino >= CEPH_MDS_INO_MDSDIR_OFFSET) {
> -		WARN_RATELIMIT(1, "Attempt to access reserved inode number 0x%llx", vino.ino);
> -		return true;
> -	}
> -	return false;
> +	if (vino.ino >= CEPH_INO_SYSTEM_BASE ||
> +	    vino.ino < CEPH_MDS_INO_MDSDIR_OFFSET)
> +		return false;
> +
> +	/* Don't warn on mdsdirs */
> +	WARN_RATELIMIT(vino.ino >= CEPH_MDS_INO_LOG_OFFSET,
> +			"Attempt to access reserved inode number 0x%llx",
> +			vino.ino);
> +	return true;
>  }
>  
>  static inline struct inode *ceph_find_inode(struct super_block *sb,

-- 
Jeff Layton <jlayton@kernel.org>
