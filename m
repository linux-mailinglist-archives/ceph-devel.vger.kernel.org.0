Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 975143AE866
	for <lists+ceph-devel@lfdr.de>; Mon, 21 Jun 2021 13:51:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229736AbhFULyG (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 21 Jun 2021 07:54:06 -0400
Received: from smtp-out2.suse.de ([195.135.220.29]:39838 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229610AbhFULyF (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 21 Jun 2021 07:54:05 -0400
Received: from imap.suse.de (imap-alt.suse-dmz.suse.de [192.168.254.47])
        (using TLSv1.2 with cipher ECDHE-ECDSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id E48101FD45;
        Mon, 21 Jun 2021 11:51:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1624276309; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=DO0n1xtCMYfokrAghlYDGZKONAfMjZxjcOrUBcnA2TY=;
        b=fANHlnRHzcscmbNIA1fo4fc/EotuCUMXDmK/2jRg1NJDw2vKcvj1BPzcVHPrJqsbKf8wSn
        oCzFTdIACCEKebyWoX/okk7b9BLL2AwDPttmDN9qfP9em0dVO8crPWjp+oMHmmIfavTMqH
        dpxJXqiy10Q1YCoRmzMgIjVB+GPZbQg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1624276309;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=DO0n1xtCMYfokrAghlYDGZKONAfMjZxjcOrUBcnA2TY=;
        b=2FQc3ZLhVZK4mqVpUwj3/ExprX+rm2YKuePPKmCe8eKdPowSPB19rEjWr8vppKObmbQ/Ys
        YR5oNLndkRSOhJDw==
Received: from imap3-int (imap-alt.suse-dmz.suse.de [192.168.254.47])
        by imap.suse.de (Postfix) with ESMTP id 9616F118DD;
        Mon, 21 Jun 2021 11:51:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1624276309; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=DO0n1xtCMYfokrAghlYDGZKONAfMjZxjcOrUBcnA2TY=;
        b=fANHlnRHzcscmbNIA1fo4fc/EotuCUMXDmK/2jRg1NJDw2vKcvj1BPzcVHPrJqsbKf8wSn
        oCzFTdIACCEKebyWoX/okk7b9BLL2AwDPttmDN9qfP9em0dVO8crPWjp+oMHmmIfavTMqH
        dpxJXqiy10Q1YCoRmzMgIjVB+GPZbQg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1624276309;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=DO0n1xtCMYfokrAghlYDGZKONAfMjZxjcOrUBcnA2TY=;
        b=2FQc3ZLhVZK4mqVpUwj3/ExprX+rm2YKuePPKmCe8eKdPowSPB19rEjWr8vppKObmbQ/Ys
        YR5oNLndkRSOhJDw==
Received: from director2.suse.de ([192.168.254.72])
        by imap3-int with ESMTPSA
        id J4uQIVV90GBSGwAALh3uQQ
        (envelope-from <lhenriques@suse.de>); Mon, 21 Jun 2021 11:51:49 +0000
Received: from localhost (brahms [local])
        by brahms (OpenSMTPD) with ESMTPA id 9605bc73;
        Mon, 21 Jun 2021 11:51:48 +0000 (UTC)
Date:   Mon, 21 Jun 2021 12:51:48 +0100
From:   Luis Henriques <lhenriques@suse.de>
To:     Jeff Layton <jlayton@kernel.org>
Cc:     ceph-devel@vger.kernel.org, idryomov@gmail.com
Subject: Re: [PATCH] ceph: take reference to req->r_parent at point of
 assignment
Message-ID: <YNB9VJTVSkOls1XM@suse.de>
References: <20210618173959.13998-1-jlayton@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210618173959.13998-1-jlayton@kernel.org>
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Fri, Jun 18, 2021 at 01:39:59PM -0400, Jeff Layton wrote:
> Currently, we set the r_parent pointer but then don't take a reference
> to it until we submit the request. If we end up freeing the req before
> that point, then we'll do a iput when we shouldn't.
> 
> Instead, take the inode reference in the callers, so that it's always
> safe to call ceph_mdsc_put_request on the req, even before submission.
> 
> Signed-off-by: Jeff Layton <jlayton@kernel.org>
> ---
>  fs/ceph/dir.c        | 9 +++++++++
>  fs/ceph/export.c     | 1 +
>  fs/ceph/file.c       | 1 +
>  fs/ceph/mds_client.c | 1 -
>  4 files changed, 11 insertions(+), 1 deletion(-)
> 
> Note that this isn't a problem with the existing code, because we never
> put the last reference before submission, but with the coming fscrypt
> patchset, we can end up doing this and this becomes a problem. With ths
> change, a set r_parent field means a reference *was* taken.
> 
> diff --git a/fs/ceph/dir.c b/fs/ceph/dir.c
> index bd508b1aeac2..a656c5c00e65 100644
> --- a/fs/ceph/dir.c
> +++ b/fs/ceph/dir.c
> @@ -788,6 +788,7 @@ static struct dentry *ceph_lookup(struct inode *dir, struct dentry *dentry,
>  		mask |= CEPH_CAP_XATTR_SHARED;
>  	req->r_args.getattr.mask = cpu_to_le32(mask);
>  
> +	ihold(dir);
>  	req->r_parent = dir;

Other than my OCD saying that these two statements should be in the
reverse order (or maybe all the other should...?), feel free to add my

Reviewed-by: Luis Henriques <lhenriques@suse.de>

Cheers,
--
Luís

>  	set_bit(CEPH_MDS_R_PARENT_LOCKED, &req->r_req_flags);
>  	err = ceph_mdsc_do_request(mdsc, NULL, req);
> @@ -861,6 +862,7 @@ static int ceph_mknod(struct user_namespace *mnt_userns, struct inode *dir,
>  	req->r_dentry = dget(dentry);
>  	req->r_num_caps = 2;
>  	req->r_parent = dir;
> +	ihold(dir);
>  	set_bit(CEPH_MDS_R_PARENT_LOCKED, &req->r_req_flags);
>  	req->r_args.mknod.mode = cpu_to_le32(mode);
>  	req->r_args.mknod.rdev = cpu_to_le32(rdev);
> @@ -922,6 +924,8 @@ static int ceph_symlink(struct user_namespace *mnt_userns, struct inode *dir,
>  		goto out;
>  	}
>  	req->r_parent = dir;
> +	ihold(dir);
> +
>  	set_bit(CEPH_MDS_R_PARENT_LOCKED, &req->r_req_flags);
>  	req->r_dentry = dget(dentry);
>  	req->r_num_caps = 2;
> @@ -986,6 +990,7 @@ static int ceph_mkdir(struct user_namespace *mnt_userns, struct inode *dir,
>  	req->r_dentry = dget(dentry);
>  	req->r_num_caps = 2;
>  	req->r_parent = dir;
> +	ihold(dir);
>  	set_bit(CEPH_MDS_R_PARENT_LOCKED, &req->r_req_flags);
>  	req->r_args.mkdir.mode = cpu_to_le32(mode);
>  	req->r_dentry_drop = CEPH_CAP_FILE_SHARED | CEPH_CAP_AUTH_EXCL;
> @@ -1030,6 +1035,7 @@ static int ceph_link(struct dentry *old_dentry, struct inode *dir,
>  	req->r_num_caps = 2;
>  	req->r_old_dentry = dget(old_dentry);
>  	req->r_parent = dir;
> +	ihold(dir);
>  	set_bit(CEPH_MDS_R_PARENT_LOCKED, &req->r_req_flags);
>  	req->r_dentry_drop = CEPH_CAP_FILE_SHARED;
>  	req->r_dentry_unless = CEPH_CAP_FILE_EXCL;
> @@ -1151,6 +1157,7 @@ static int ceph_unlink(struct inode *dir, struct dentry *dentry)
>  	req->r_dentry = dget(dentry);
>  	req->r_num_caps = 2;
>  	req->r_parent = dir;
> +	ihold(dir);
>  	req->r_dentry_drop = CEPH_CAP_FILE_SHARED;
>  	req->r_dentry_unless = CEPH_CAP_FILE_EXCL;
>  	req->r_inode_drop = ceph_drop_caps_for_unlink(inode);
> @@ -1225,6 +1232,7 @@ static int ceph_rename(struct user_namespace *mnt_userns, struct inode *old_dir,
>  	req->r_old_dentry = dget(old_dentry);
>  	req->r_old_dentry_dir = old_dir;
>  	req->r_parent = new_dir;
> +	ihold(new_dir);
>  	set_bit(CEPH_MDS_R_PARENT_LOCKED, &req->r_req_flags);
>  	req->r_old_dentry_drop = CEPH_CAP_FILE_SHARED;
>  	req->r_old_dentry_unless = CEPH_CAP_FILE_EXCL;
> @@ -1721,6 +1729,7 @@ static int ceph_d_revalidate(struct dentry *dentry, unsigned int flags)
>  			req->r_dentry = dget(dentry);
>  			req->r_num_caps = 2;
>  			req->r_parent = dir;
> +			ihold(dir);
>  
>  			mask = CEPH_STAT_CAP_INODE | CEPH_CAP_AUTH_SHARED;
>  			if (ceph_security_xattr_wanted(dir))
> diff --git a/fs/ceph/export.c b/fs/ceph/export.c
> index 65540a4429b2..1d65934c1262 100644
> --- a/fs/ceph/export.c
> +++ b/fs/ceph/export.c
> @@ -542,6 +542,7 @@ static int ceph_get_name(struct dentry *parent, char *name,
>  	ihold(inode);
>  	req->r_ino2 = ceph_vino(d_inode(parent));
>  	req->r_parent = d_inode(parent);
> +	ihold(req->r_parent);
>  	set_bit(CEPH_MDS_R_PARENT_LOCKED, &req->r_req_flags);
>  	req->r_num_caps = 2;
>  	err = ceph_mdsc_do_request(mdsc, NULL, req);
> diff --git a/fs/ceph/file.c b/fs/ceph/file.c
> index d3874c2df4b1..c8fd11cf4510 100644
> --- a/fs/ceph/file.c
> +++ b/fs/ceph/file.c
> @@ -706,6 +706,7 @@ int ceph_atomic_open(struct inode *dir, struct dentry *dentry,
>  		mask |= CEPH_CAP_XATTR_SHARED;
>  	req->r_args.open.mask = cpu_to_le32(mask);
>  	req->r_parent = dir;
> +	ihold(dir);
>  
>  	if (flags & O_CREAT) {
>  		struct ceph_file_layout lo;
> diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
> index c03098c58be3..52ae5373437d 100644
> --- a/fs/ceph/mds_client.c
> +++ b/fs/ceph/mds_client.c
> @@ -2983,7 +2983,6 @@ int ceph_mdsc_submit_request(struct ceph_mds_client *mdsc, struct inode *dir,
>  		ceph_take_cap_refs(ci, CEPH_CAP_PIN, false);
>  		__ceph_touch_fmode(ci, mdsc, fmode);
>  		spin_unlock(&ci->i_ceph_lock);
> -		ihold(req->r_parent);
>  	}
>  	if (req->r_old_dentry_dir)
>  		ceph_get_cap_refs(ceph_inode(req->r_old_dentry_dir),
> -- 
> 2.31.1
> 

