Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C91E4CDB7F
	for <lists+ceph-devel@lfdr.de>; Fri,  4 Mar 2022 18:57:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241312AbiCDR6b (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 4 Mar 2022 12:58:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239907AbiCDR6b (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Fri, 4 Mar 2022 12:58:31 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC5B517E29
        for <ceph-devel@vger.kernel.org>; Fri,  4 Mar 2022 09:57:40 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3533B60A67
        for <ceph-devel@vger.kernel.org>; Fri,  4 Mar 2022 17:57:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CD16C340F1;
        Fri,  4 Mar 2022 17:57:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646416659;
        bh=5/NI7mk3DTsAjLafBN6cp2uSYDqjMzy81HE5VmwgFdU=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=SvH7h/pCJKxQ96gZaSFAEHFbT8ogYwKhAHnRxOeKiostEqa1oJzD7zIGUknjAPRVj
         AO9TK3qSishj0gKaeKWrEbSczL4Adls82qyVAdBqs+O+WGXjwSgOzpAzVX67NyF57b
         0+7Vf6hrX1TeKUVtbEk+0I8lKBijU74Wwq6mz6Z5/8Ajwg5TISo73A3pt/Qe/JxKc4
         VCaojkqsLazti1xJtSnoRLvv/NHnAUBw3+i2YEfpD0q4Hh8BtH7OeMjSWsM1BHz/d1
         v6rbdrRrCdVS8L+70J86dL3KTbuCJ2ctWfXF11ZpZAuDstKrY9hWbW0TX7LJ1GYa6X
         9ozlLXwZGikpw==
Message-ID: <ea879caa7e98789d236302c8fbad8dc1c37d3e9e.camel@kernel.org>
Subject: Re: [PATCH v4 2/2] ceph: do not dencrypt the dentry name twice for
 readdir
From:   Jeff Layton <jlayton@kernel.org>
To:     xiubli@redhat.com
Cc:     idryomov@gmail.com, vshankar@redhat.com, lhenriques@suse.de,
        ceph-devel@vger.kernel.org
Date:   Fri, 04 Mar 2022 12:57:37 -0500
In-Reply-To: <20220303032640.521999-3-xiubli@redhat.com>
References: <20220303032640.521999-1-xiubli@redhat.com>
         <20220303032640.521999-3-xiubli@redhat.com>
Content-Type: text/plain; charset="ISO-8859-15"
User-Agent: Evolution 3.42.4 (3.42.4-1.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Thu, 2022-03-03 at 11:26 +0800, xiubli@redhat.com wrote:
> From: Xiubo Li <xiubli@redhat.com>
> 
> For the readdir request the dentries will be pasred and dencrypted
> in ceph_readdir_prepopulate(). And in ceph_readdir() we could just
> get the dentry name from the dentry cache instead of parsing and
> dencrypting them again. This could improve performance.
> 
> Signed-off-by: Xiubo Li <xiubli@redhat.com>
> ---
>  fs/ceph/crypto.h     |  8 +++++
>  fs/ceph/dir.c        | 74 +++++++++++++++++++++++---------------------
>  fs/ceph/inode.c      | 15 +++++++++
>  fs/ceph/mds_client.h |  1 +
>  4 files changed, 63 insertions(+), 35 deletions(-)
> 
> diff --git a/fs/ceph/crypto.h b/fs/ceph/crypto.h
> index 1e08f8a64ad6..9a00c60b8535 100644
> --- a/fs/ceph/crypto.h
> +++ b/fs/ceph/crypto.h
> @@ -83,6 +83,14 @@ static inline u32 ceph_fscrypt_auth_len(struct ceph_fscrypt_auth *fa)
>   */
>  #define CEPH_NOHASH_NAME_MAX (189 - SHA256_DIGEST_SIZE)
>  
> +/*
> + * The encrypted long snap name will be in format of
> + * "_${ENCRYPTED-LONG-SNAP-NAME}_${INODE-NUM}". And will set the max longth
> + * to sizeof('_') + NAME_MAX + sizeof('_') + max of sizeof(${INO}) + extra 7
> + * bytes to align the total size to 8 bytes.
> + */
> +#define CEPH_ENCRPTED_LONG_SNAP_NAME_MAX (1 + 255 + 1 + 16 + 7)
> +

Maybe CEPH_ENCRYPTED_LONG_SNAP_NAME_MAX instead?

>  void ceph_fscrypt_set_ops(struct super_block *sb);
>  
>  void ceph_fscrypt_free_dummy_policy(struct ceph_fs_client *fsc);
> diff --git a/fs/ceph/dir.c b/fs/ceph/dir.c
> index 4da59810b036..fa3da3b29130 100644
> --- a/fs/ceph/dir.c
> +++ b/fs/ceph/dir.c
> @@ -316,8 +316,7 @@ static int ceph_readdir(struct file *file, struct dir_context *ctx)
>  	int err;
>  	unsigned frag = -1;
>  	struct ceph_mds_reply_info_parsed *rinfo;
> -	struct fscrypt_str tname = FSTR_INIT(NULL, 0);
> -	struct fscrypt_str oname = FSTR_INIT(NULL, 0);
> +	char *dentry_name = NULL;
>  
>  	dout("readdir %p file %p pos %llx\n", inode, file, ctx->pos);
>  	if (dfi->file_info.flags & CEPH_F_ATEND)
> @@ -345,10 +344,6 @@ static int ceph_readdir(struct file *file, struct dir_context *ctx)
>  		ctx->pos = 2;
>  	}
>  
> -	err = fscrypt_prepare_readdir(inode);
> -	if (err)
> -		goto out;
> -
>  	spin_lock(&ci->i_ceph_lock);
>  	/* request Fx cap. if have Fx, we don't need to release Fs cap
>  	 * for later create/unlink. */
> @@ -369,14 +364,6 @@ static int ceph_readdir(struct file *file, struct dir_context *ctx)
>  		spin_unlock(&ci->i_ceph_lock);
>  	}
>  
> -	err = ceph_fname_alloc_buffer(inode, &tname);
> -	if (err < 0)
> -		goto out;
> -
> -	err = ceph_fname_alloc_buffer(inode, &oname);
> -	if (err < 0)
> -		goto out;
> -
>  	/* proceed with a normal readdir */
>  more:
>  	/* do we have the correct frag content buffered? */
> @@ -528,42 +515,59 @@ static int ceph_readdir(struct file *file, struct dir_context *ctx)
>  			}
>  		}
>  	}
> +
> +	dentry_name = kmalloc(CEPH_ENCRPTED_LONG_SNAP_NAME_MAX, GFP_KERNEL);
> +	if (!dentry_name) {
> +		err = -ENOMEM;
> +		ceph_mdsc_put_request(dfi->last_readdir);
> +		dfi->last_readdir = NULL;
> +		goto out;
> +	}
> +

If this happens (or an earlier error), all of the dentry references will
leak. I think you probably need to move the cleanup into
destroy_reply_info().

>  	for (; i < rinfo->dir_nr; i++) {
>  		struct ceph_mds_reply_dir_entry *rde = rinfo->dir_entries + i;
> -		struct ceph_fname fname = { .dir	= inode,
> -					    .name	= rde->name,
> -					    .name_len	= rde->name_len,
> -					    .ctext	= rde->altname,
> -					    .ctext_len	= rde->altname_len };
> -		u32 olen = oname.len;
> -
> -		err = ceph_fname_to_usr(&fname, &tname, &oname, NULL);
> -		if (err) {
> -			pr_err("%s unable to decode %.*s, got %d\n", __func__,
> -			       rde->name_len, rde->name, err);
> -			goto out;
> -		}
> +		struct dentry *dn = rde->dentry;
> +		int name_len;
>  
>  		BUG_ON(rde->offset < ctx->pos);
>  		BUG_ON(!rde->inode.in);
> +		BUG_ON(!rde->dentry);
>  
>  		ctx->pos = rde->offset;
> -		dout("readdir (%d/%d) -> %llx '%.*s' %p\n",
> -		     i, rinfo->dir_nr, ctx->pos,
> -		     rde->name_len, rde->name, &rde->inode.in);
>  
> -		if (!dir_emit(ctx, oname.name, oname.len,
> +		spin_lock(&dn->d_lock);
> +		memcpy(dentry_name, dn->d_name.name, dn->d_name.len);
> +		name_len = dn->d_name.len;
> +		spin_unlock(&dn->d_lock);
> +
> +		dentry_name[name_len] = '\0';
> +		dout("readdir (%d/%d) -> %llx '%s' %p\n",
> +		     i, rinfo->dir_nr, ctx->pos, dentry_name, &rde->inode.in);
> +
> +		dput(dn);
> +		rde->dentry = NULL;
> +
> +		if (!dir_emit(ctx, dentry_name, name_len,
>  			      ceph_present_ino(inode->i_sb, le64_to_cpu(rde->inode.in->ino)),
>  			      le32_to_cpu(rde->inode.in->mode) >> 12)) {
>  			dout("filldir stopping us...\n");
> +
> +			/*
> +			 * dput the rest dentries. Must do this before
> +			 * releasing the request.
> +			 */
> +			for (++i; i < rinfo->dir_nr; i++) {
> +				rde = rinfo->dir_entries + i;
> +				dput(rde->dentry);
> +				rde->dentry = NULL;
> +			}
> +
>  			err = 0;
>  			ceph_mdsc_put_request(dfi->last_readdir);
>  			dfi->last_readdir = NULL;
>  			goto out;
>  		}
>  
> -		/* Reset the lengths to their original allocated vals */
> -		oname.len = olen;
>  		ctx->pos++;
>  	}
>  
> @@ -621,8 +625,8 @@ static int ceph_readdir(struct file *file, struct dir_context *ctx)
>  	err = 0;
>  	dout("readdir %p file %p done.\n", inode, file);
>  out:
> -	ceph_fname_free_buffer(inode, &tname);
> -	ceph_fname_free_buffer(inode, &oname);
> +	if (dentry_name)
> +		kfree(dentry_name);
>  	return err;
>  }
>  
> diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
> index e5a9838981ba..d0719feed792 100644
> --- a/fs/ceph/inode.c
> +++ b/fs/ceph/inode.c
> @@ -1902,6 +1902,7 @@ int ceph_readdir_prepopulate(struct ceph_mds_request *req,
>  			goto out;
>  		}
>  
> +		rde->dentry = NULL;
>  		dname.name = oname.name;
>  		dname.len = oname.len;
>  		dname.hash = full_name_hash(parent, dname.name, dname.len);
> @@ -1962,6 +1963,12 @@ int ceph_readdir_prepopulate(struct ceph_mds_request *req,
>  			goto retry_lookup;
>  		}
>  
> +		/*
> +		 * ceph_readdir will use the dentry to get the name
> +		 * to avoid doing the dencrypt again there.
> +		 */
> +		rde->dentry = dget(dn);
> +
>  		/* inode */
>  		if (d_really_is_positive(dn)) {
>  			in = d_inode(dn);
> @@ -2024,6 +2031,14 @@ int ceph_readdir_prepopulate(struct ceph_mds_request *req,
>  		dput(dn);
>  	}
>  out:
> +	if (err) {
> +		for (; i >= 0; i--) {
> +			struct ceph_mds_reply_dir_entry *rde;
> +
> +			rde = rinfo->dir_entries + i;
> +			dput(rde->dentry);
> +		}
> +	}
>  	if (err == 0 && skipped == 0) {
>  		set_bit(CEPH_MDS_R_DID_PREPOPULATE, &req->r_req_flags);
>  		req->r_readdir_cache_idx = cache_ctl.index;
> diff --git a/fs/ceph/mds_client.h b/fs/ceph/mds_client.h
> index 0dfe24f94567..663d7754d57d 100644
> --- a/fs/ceph/mds_client.h
> +++ b/fs/ceph/mds_client.h
> @@ -96,6 +96,7 @@ struct ceph_mds_reply_info_in {
>  };
>  
>  struct ceph_mds_reply_dir_entry {
> +	struct dentry		      *dentry;
>  	char                          *name;
>  	u8			      *altname;
>  	u32                           name_len;

-- 
Jeff Layton <jlayton@kernel.org>
