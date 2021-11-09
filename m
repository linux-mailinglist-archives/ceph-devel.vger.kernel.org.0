Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E2E4644B2AC
	for <lists+ceph-devel@lfdr.de>; Tue,  9 Nov 2021 19:21:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242305AbhKISYI (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 9 Nov 2021 13:24:08 -0500
Received: from smtp-out2.suse.de ([195.135.220.29]:49550 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242269AbhKISYH (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 9 Nov 2021 13:24:07 -0500
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 7AD991FD5A;
        Tue,  9 Nov 2021 18:21:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1636482080; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/xtxqiSB66//Ah1hf75JwXTklQJr2FJ6+y1XWuD6QLg=;
        b=DFUDN/t7Y+FospIpTXuqFF+DLcVUFw1AyzyMRoIeHXCUWRAx4Luv2gF/qDfxF8CB6geyyW
        JFq80TCaq1/i4mXjb9dbijVDNQ62U6A/c53TCAkqejOVZdtydc4deCdeIAlBqVA2Xu9gWk
        ClTJSWzHa/o2Z6YcDkVfQFoYLj8MT8g=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1636482080;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/xtxqiSB66//Ah1hf75JwXTklQJr2FJ6+y1XWuD6QLg=;
        b=Ycw2B1UZfdckO1Uk+TI57hu3DlGavVMd13CjyJyzIpgfGbo+c5sLDaqp0RsacAoRiFFWy6
        dKzk4D0fmNRL5BDg==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 3F85413B2F;
        Tue,  9 Nov 2021 18:21:20 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id 89VUDCC8imG8agAAMHmgww
        (envelope-from <lhenriques@suse.de>); Tue, 09 Nov 2021 18:21:20 +0000
Received: from localhost (brahms [local])
        by brahms (OpenSMTPD) with ESMTPA id 1b1a75b1;
        Tue, 9 Nov 2021 18:21:19 +0000 (UTC)
Date:   Tue, 9 Nov 2021 18:21:19 +0000
From:   =?iso-8859-1?Q?Lu=EDs?= Henriques <lhenriques@suse.de>
To:     Jeff Layton <jlayton@kernel.org>
Cc:     ceph-devel@vger.kernel.org, idryomov@gmail.com
Subject: Re: [PATCH] ceph: don't check for quotas on MDS stray dirs
Message-ID: <YYq8HztUGzMWknfr@suse.de>
References: <20211109171011.39571-1-jlayton@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20211109171011.39571-1-jlayton@kernel.org>
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Tue, Nov 09, 2021 at 12:10:11PM -0500, Jeff Layton wrote:
> 玮文 胡 reported seeing the WARN_RATELIMITED pop when writing to an
> inode that had been transplanted into the stray dir. The client was
> trying to look up the quotarealm info from the parent and that tripped
> the warning.
> 
> Change the ceph_vino_is_reserved helper to not throw a warning and
> add a new ceph_vino_warn_reserved() helper that does. Change all of the
> existing callsites to call the "warn" variant, and have
> ceph_has_realms_with_quotas check return false when the vino is
> reserved.
> 
> URL: https://tracker.ceph.com/issues/53180
> Signed-off-by: Jeff Layton <jlayton@kernel.org>
> ---
>  fs/ceph/export.c |  4 ++--
>  fs/ceph/inode.c  |  2 +-
>  fs/ceph/quota.c  |  3 +++
>  fs/ceph/super.h  | 17 ++++++++++-------
>  4 files changed, 16 insertions(+), 10 deletions(-)
> 
> diff --git a/fs/ceph/export.c b/fs/ceph/export.c
> index e0fa66ac8b9f..a75cf07d668f 100644
> --- a/fs/ceph/export.c
> +++ b/fs/ceph/export.c
> @@ -130,7 +130,7 @@ static struct inode *__lookup_inode(struct super_block *sb, u64 ino)
>  	vino.ino = ino;
>  	vino.snap = CEPH_NOSNAP;
>  
> -	if (ceph_vino_is_reserved(vino))
> +	if (ceph_vino_warn_reserved(vino))
>  		return ERR_PTR(-ESTALE);
>  
>  	inode = ceph_find_inode(sb, vino);
> @@ -224,7 +224,7 @@ static struct dentry *__snapfh_to_dentry(struct super_block *sb,
>  		vino.snap = sfh->snapid;
>  	}
>  
> -	if (ceph_vino_is_reserved(vino))
> +	if (ceph_vino_warn_reserved(vino))
>  		return ERR_PTR(-ESTALE);
>  
>  	inode = ceph_find_inode(sb, vino);
> diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
> index e8eb8612ddd6..a685fab56772 100644
> --- a/fs/ceph/inode.c
> +++ b/fs/ceph/inode.c
> @@ -56,7 +56,7 @@ struct inode *ceph_get_inode(struct super_block *sb, struct ceph_vino vino)
>  {
>  	struct inode *inode;
>  
> -	if (ceph_vino_is_reserved(vino))
> +	if (ceph_vino_warn_reserved(vino))
>  		return ERR_PTR(-EREMOTEIO);
>  
>  	inode = iget5_locked(sb, (unsigned long)vino.ino, ceph_ino_compare,
> diff --git a/fs/ceph/quota.c b/fs/ceph/quota.c
> index 620c691af40e..d1158c40bb0c 100644
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
> index ed51e04739c4..c232ed8e8a37 100644
> --- a/fs/ceph/super.h
> +++ b/fs/ceph/super.h
> @@ -547,18 +547,21 @@ static inline int ceph_ino_compare(struct inode *inode, void *data)
>  
>  static inline bool ceph_vino_is_reserved(const struct ceph_vino vino)
>  {
> -	if (vino.ino < CEPH_INO_SYSTEM_BASE &&
> -	    vino.ino >= CEPH_MDS_INO_MDSDIR_OFFSET) {
> -		WARN_RATELIMIT(1, "Attempt to access reserved inode number 0x%llx", vino.ino);
> -		return true;
> -	}
> -	return false;
> +	return vino.ino < CEPH_INO_SYSTEM_BASE &&
> +	       vino.ino >= CEPH_MDS_INO_MDSDIR_OFFSET;
> +}
> +
> +static inline bool ceph_vino_warn_reserved(const struct ceph_vino vino)
> +{
> +	return WARN_RATELIMIT(ceph_vino_is_reserved(vino),
> +				"Attempt to access reserved inode number 0x%llx",
> +				vino.ino);
>  }
>  
>  static inline struct inode *ceph_find_inode(struct super_block *sb,
>  					    struct ceph_vino vino)
>  {
> -	if (ceph_vino_is_reserved(vino))
> +	if (ceph_vino_warn_reserved(vino))
>  		return NULL;
>  
>  	/*
> -- 
> 2.33.1
> 

This looks reasonable.  I would probably keep the old function name and
simply name the new one ceph_vino_is_reserved_no_warn().  But that's just
because I'm lazy :-)

Reviewed-by: Luis Henriques <lhenriques@suse.de>

Cheers,
--
Luís
