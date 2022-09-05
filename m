Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EE6095AD08E
	for <lists+ceph-devel@lfdr.de>; Mon,  5 Sep 2022 12:51:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236686AbiIEKvt (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 5 Sep 2022 06:51:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231656AbiIEKvr (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 5 Sep 2022 06:51:47 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0D3C4E625
        for <ceph-devel@vger.kernel.org>; Mon,  5 Sep 2022 03:51:46 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 8CAEE38827;
        Mon,  5 Sep 2022 10:51:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1662375105; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=C/fXG25XKWaMQfD6q41MFYGCqNH+u6d6HRAoTDaoN/0=;
        b=DF7Uw2x0w6mb8VB52cPFQQZuoy5mDd2SwLtMcCDlHrCKlC9H2usABYB4x9YERf222520am
        rgK13LJpHNAuqYyfZe3QubUJgSnNmTovydsPv3FawcM+ANuQGxeKiUSbQfqGiUJp7CtJTe
        2jdQp7pqaDCDfm1EIQyDv4TpwCedOdw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1662375105;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=C/fXG25XKWaMQfD6q41MFYGCqNH+u6d6HRAoTDaoN/0=;
        b=R4EPNCDDkOExdaKxYzzlhGVhyLhOw/oOg5E/4Z1Rpoq+JwYdawLdXXb5yUXESHv2Ltu+0I
        uQV63CSqMJC0kNBw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 3ADC6139C7;
        Mon,  5 Sep 2022 10:51:45 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id UmZFCsHUFWP2UQAAMHmgww
        (envelope-from <lhenriques@suse.de>); Mon, 05 Sep 2022 10:51:45 +0000
Received: from localhost (brahms.olymp [local])
        by brahms.olymp (OpenSMTPD) with ESMTPA id f56608fe;
        Mon, 5 Sep 2022 10:52:37 +0000 (UTC)
Date:   Mon, 5 Sep 2022 11:52:37 +0100
From:   =?iso-8859-1?Q?Lu=EDs?= Henriques <lhenriques@suse.de>
To:     xiubli@redhat.com
Cc:     ceph-devel@vger.kernel.org, jlayton@kernel.org, idryomov@gmail.com,
        mchangir@redhat.com
Subject: Re: [PATCH v2] ceph: fix incorrectly showing the .snap size for stat
Message-ID: <YxXU9YZ1/8fPApvp@suse.de>
References: <20220831080257.170065-1-xiubli@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220831080257.170065-1-xiubli@redhat.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Wed, Aug 31, 2022 at 04:02:57PM +0800, xiubli@redhat.com wrote:
> From: Xiubo Li <xiubli@redhat.com>
> 
> We should set the 'stat->size' to the real number of snapshots for
> snapdirs.
> 
> URL: https://tracker.ceph.com/issues/57342
> Signed-off-by: Xiubo Li <xiubli@redhat.com>
> ---
>  fs/ceph/inode.c | 68 +++++++++++++++++++++++++++++++++++++++++++++++--
>  1 file changed, 66 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
> index 4db4394912e7..99022bcdde64 100644
> --- a/fs/ceph/inode.c
> +++ b/fs/ceph/inode.c
> @@ -2705,6 +2705,52 @@ static int statx_to_caps(u32 want, umode_t mode)
>  	return mask;
>  }
>  
> +static struct inode *ceph_get_snap_parent(struct inode *inode)
> +{
> +	struct super_block *sb = inode->i_sb;
> +	struct ceph_mds_client *mdsc = ceph_sb_to_mdsc(sb);
> +	struct ceph_mds_request *req;
> +	struct ceph_vino vino = {
> +		.ino = ceph_ino(inode),
> +		.snap = CEPH_NOSNAP,
> +	};
> +	struct inode *parent;
> +	int mask;
> +	int err;
> +
> +	if (ceph_vino_is_reserved(vino))
> +		return ERR_PTR(-ESTALE);
> +
> +	parent = ceph_find_inode(sb, vino);
> +	if (likely(parent)) {
> +		if (ceph_inode_is_shutdown(parent)) {
> +			iput(parent);
> +			return ERR_PTR(-ESTALE);
> +		}
> +		return parent;
> +	}
> +
> +	req = ceph_mdsc_create_request(mdsc, CEPH_MDS_OP_LOOKUPINO,
> +				       USE_ANY_MDS);
> +	if (IS_ERR(req))
> +		return ERR_CAST(req);
> +
> +	mask = CEPH_STAT_CAP_INODE;
> +	if (ceph_security_xattr_wanted(d_inode(sb->s_root)))
> +		mask |= CEPH_CAP_XATTR_SHARED;
> +	req->r_args.lookupino.mask = cpu_to_le32(mask);
> +	req->r_ino1 = vino;
> +	req->r_num_caps = 1;
> +	err = ceph_mdsc_do_request(mdsc, NULL, req);
> +	if (err < 0)
> +		return ERR_PTR(err);
> +	parent = req->r_target_inode;
> +	if (!parent)
> +		return ERR_PTR(-ESTALE);
> +	ihold(parent);
> +	return parent;
> +}

Can't we simply re-use __lookup_inode() instead of duplicating all this
code?

(Also: is there a similar fix for the fuse client?)

Cheers,
--
Luís

> +
>  /*
>   * Get all the attributes. If we have sufficient caps for the requested attrs,
>   * then we can avoid talking to the MDS at all.
> @@ -2748,10 +2794,28 @@ int ceph_getattr(struct user_namespace *mnt_userns, const struct path *path,
>  
>  	if (S_ISDIR(inode->i_mode)) {
>  		if (ceph_test_mount_opt(ceph_sb_to_client(inode->i_sb),
> -					RBYTES))
> +					RBYTES)) {
>  			stat->size = ci->i_rbytes;
> -		else
> +		} else if (ceph_snap(inode) == CEPH_SNAPDIR) {
> +			struct inode *parent = ceph_get_snap_parent(inode);
> +			struct ceph_inode_info *pci;
> +			struct ceph_snap_realm *realm;
> +
> +			if (!parent)
> +				return PTR_ERR(parent);
> +
> +			pci = ceph_inode(parent);
> +			spin_lock(&pci->i_ceph_lock);
> +			realm = pci->i_snap_realm;
> +			if (realm)
> +				stat->size = realm->num_snaps;
> +			else
> +				stat->size = 0;
> +			spin_unlock(&pci->i_ceph_lock);
> +			iput(parent);
> +		} else {
>  			stat->size = ci->i_files + ci->i_subdirs;
> +		}
>  		stat->blocks = 0;
>  		stat->blksize = 65536;
>  		/*
> -- 
> 2.36.0.rc1
> 
