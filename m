Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB65E4CBA83
	for <lists+ceph-devel@lfdr.de>; Thu,  3 Mar 2022 10:42:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231608AbiCCJnl (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 3 Mar 2022 04:43:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231172AbiCCJnl (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 3 Mar 2022 04:43:41 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id D4AF45520F
        for <ceph-devel@vger.kernel.org>; Thu,  3 Mar 2022 01:42:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646300574;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=tPT++cB9tIz171LpjLUBtDc0uWy+rceuAsgSj00ndyU=;
        b=h73AogUjN33AUhtH3++fV6KD0IUs5RMGVrbtaVHDBSTwFlnbNZXaw7CFPCHKkwXHG/5jeT
        WJhzpdM6UQ1JNfSUoQ8aoiU78zoSGjElEF65vHoP0MGX2eV1VckVdserOMXAtt01xiOB/T
        n+TXBSOqL/ONKnCAXynYl7Qmwx5nFdg=
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com
 [209.85.214.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-310-mG-9L4xsP4eiUIekdcSe5A-1; Thu, 03 Mar 2022 04:42:54 -0500
X-MC-Unique: mG-9L4xsP4eiUIekdcSe5A-1
Received: by mail-pl1-f199.google.com with SMTP id o15-20020a170902d4cf00b00151559fadd7so2618095plg.20
        for <ceph-devel@vger.kernel.org>; Thu, 03 Mar 2022 01:42:53 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=tPT++cB9tIz171LpjLUBtDc0uWy+rceuAsgSj00ndyU=;
        b=ZBokBebekOsvgGfbJmPDHco1nBlyZMxh0GIpdTukdKlm8qUoioHizjhtwnRtKTK5zj
         /uJBVFMYIdGcBnxKgq01TWPBAA+vibSMfGUh2+6MqHexh7MaXq50sSFh+DkCFMtckgh8
         F3EJU7DdirtAvavRZ97sK6FLfakMaggy2uz1SKuSfgX4x5jock4M/nwVlVLJ6EflfYvf
         KYj6NwCIyQU2xnanx3pujbtfT2wG0jUWGRSr/x836wCWu67gwQGungrDAHxNnWe8HgQn
         DxpQ2VoxRfAA+lC2G8pP6U5K58IyrVlSrbYzWsZzgh4RIJqt6hliBH89o4dfbJIShvEf
         uDfA==
X-Gm-Message-State: AOAM533rLDJKxHE5LCJEgRj5YhJSDoRKxsYU7mDlwymWRMj0vF0I+2O8
        +zy/nFC7K16iFBWY6VPGKUHGJvv2DGBu9W+4I6T3IDUtRvTgMZu4GG6BTV2hK9r4ymn7qaYYzI0
        IrgrrUYRK4SXXneyO393G/ICcDd7kZYggMNQPE0Lsv7hu8j7kBKLqLs93Ut6ogZN7IfnolM4=
X-Received: by 2002:a63:d252:0:b0:363:271c:fe63 with SMTP id t18-20020a63d252000000b00363271cfe63mr29780455pgi.524.1646300572018;
        Thu, 03 Mar 2022 01:42:52 -0800 (PST)
X-Google-Smtp-Source: ABdhPJw2iyRwrv+An5TNQmAt6Fs0vF20MC0ss9CXyw7Bp1CgifTUkSzVk48PQdR0m69qPr5O8kCvhA==
X-Received: by 2002:a63:d252:0:b0:363:271c:fe63 with SMTP id t18-20020a63d252000000b00363271cfe63mr29780424pgi.524.1646300571391;
        Thu, 03 Mar 2022 01:42:51 -0800 (PST)
Received: from [10.72.13.171] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id y12-20020a056a00190c00b004f39e28fb87sm2012255pfi.98.2022.03.03.01.42.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 03 Mar 2022 01:42:50 -0800 (PST)
Subject: Re: [PATCH v4 2/2] ceph: do not dencrypt the dentry name twice for
 readdir
To:     jlayton@kernel.org
Cc:     idryomov@gmail.com, vshankar@redhat.com, lhenriques@suse.de,
        ceph-devel@vger.kernel.org
References: <20220303032640.521999-1-xiubli@redhat.com>
 <20220303032640.521999-3-xiubli@redhat.com>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <88bcdb56-fe90-0887-dc26-770195fc1c7a@redhat.com>
Date:   Thu, 3 Mar 2022 17:42:44 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20220303032640.521999-3-xiubli@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


On 3/3/22 11:26 AM, xiubli@redhat.com wrote:
> From: Xiubo Li <xiubli@redhat.com>
>
> For the readdir request the dentries will be pasred and dencrypted
> in ceph_readdir_prepopulate(). And in ceph_readdir() we could just
> get the dentry name from the dentry cache instead of parsing and
> dencrypting them again. This could improve performance.
>
> Signed-off-by: Xiubo Li <xiubli@redhat.com>
> ---
>   fs/ceph/crypto.h     |  8 +++++
>   fs/ceph/dir.c        | 74 +++++++++++++++++++++++---------------------
>   fs/ceph/inode.c      | 15 +++++++++
>   fs/ceph/mds_client.h |  1 +
>   4 files changed, 63 insertions(+), 35 deletions(-)
>
> diff --git a/fs/ceph/crypto.h b/fs/ceph/crypto.h
> index 1e08f8a64ad6..9a00c60b8535 100644
> --- a/fs/ceph/crypto.h
> +++ b/fs/ceph/crypto.h
> @@ -83,6 +83,14 @@ static inline u32 ceph_fscrypt_auth_len(struct ceph_fscrypt_auth *fa)
>    */
>   #define CEPH_NOHASH_NAME_MAX (189 - SHA256_DIGEST_SIZE)
>   
> +/*
> + * The encrypted long snap name will be in format of
> + * "_${ENCRYPTED-LONG-SNAP-NAME}_${INODE-NUM}". And will set the max longth
> + * to sizeof('_') + NAME_MAX + sizeof('_') + max of sizeof(${INO}) + extra 7
> + * bytes to align the total size to 8 bytes.
> + */
> +#define CEPH_ENCRPTED_LONG_SNAP_NAME_MAX (1 + 255 + 1 + 16 + 7)
> +
>   void ceph_fscrypt_set_ops(struct super_block *sb);
>   
>   void ceph_fscrypt_free_dummy_policy(struct ceph_fs_client *fsc);
> diff --git a/fs/ceph/dir.c b/fs/ceph/dir.c
> index 4da59810b036..fa3da3b29130 100644
> --- a/fs/ceph/dir.c
> +++ b/fs/ceph/dir.c
> @@ -316,8 +316,7 @@ static int ceph_readdir(struct file *file, struct dir_context *ctx)
>   	int err;
>   	unsigned frag = -1;
>   	struct ceph_mds_reply_info_parsed *rinfo;
> -	struct fscrypt_str tname = FSTR_INIT(NULL, 0);
> -	struct fscrypt_str oname = FSTR_INIT(NULL, 0);
> +	char *dentry_name = NULL;
>   
>   	dout("readdir %p file %p pos %llx\n", inode, file, ctx->pos);
>   	if (dfi->file_info.flags & CEPH_F_ATEND)
> @@ -345,10 +344,6 @@ static int ceph_readdir(struct file *file, struct dir_context *ctx)
>   		ctx->pos = 2;
>   	}
>   
> -	err = fscrypt_prepare_readdir(inode);
> -	if (err)
> -		goto out;
> -

Yeah, we need this here, because it will be used in the 
"__dcache_readdir()".

Will add it back in next version.


>   	spin_lock(&ci->i_ceph_lock);
>   	/* request Fx cap. if have Fx, we don't need to release Fs cap
>   	 * for later create/unlink. */
> @@ -369,14 +364,6 @@ static int ceph_readdir(struct file *file, struct dir_context *ctx)
>   		spin_unlock(&ci->i_ceph_lock);
>   	}
>   
> -	err = ceph_fname_alloc_buffer(inode, &tname);
> -	if (err < 0)
> -		goto out;
> -
> -	err = ceph_fname_alloc_buffer(inode, &oname);
> -	if (err < 0)
> -		goto out;
> -
>   	/* proceed with a normal readdir */
>   more:
>   	/* do we have the correct frag content buffered? */
> @@ -528,42 +515,59 @@ static int ceph_readdir(struct file *file, struct dir_context *ctx)
>   			}
>   		}
>   	}
> +
> +	dentry_name = kmalloc(CEPH_ENCRPTED_LONG_SNAP_NAME_MAX, GFP_KERNEL);
> +	if (!dentry_name) {
> +		err = -ENOMEM;
> +		ceph_mdsc_put_request(dfi->last_readdir);
> +		dfi->last_readdir = NULL;
> +		goto out;
> +	}
> +
>   	for (; i < rinfo->dir_nr; i++) {
>   		struct ceph_mds_reply_dir_entry *rde = rinfo->dir_entries + i;
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
>   		BUG_ON(rde->offset < ctx->pos);
>   		BUG_ON(!rde->inode.in);
> +		BUG_ON(!rde->dentry);
>   
>   		ctx->pos = rde->offset;
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
>   			      ceph_present_ino(inode->i_sb, le64_to_cpu(rde->inode.in->ino)),
>   			      le32_to_cpu(rde->inode.in->mode) >> 12)) {
>   			dout("filldir stopping us...\n");
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
>   			err = 0;
>   			ceph_mdsc_put_request(dfi->last_readdir);
>   			dfi->last_readdir = NULL;
>   			goto out;
>   		}
>   
> -		/* Reset the lengths to their original allocated vals */
> -		oname.len = olen;
>   		ctx->pos++;
>   	}
>   
> @@ -621,8 +625,8 @@ static int ceph_readdir(struct file *file, struct dir_context *ctx)
>   	err = 0;
>   	dout("readdir %p file %p done.\n", inode, file);
>   out:
> -	ceph_fname_free_buffer(inode, &tname);
> -	ceph_fname_free_buffer(inode, &oname);
> +	if (dentry_name)
> +		kfree(dentry_name);
>   	return err;
>   }
>   
> diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
> index e5a9838981ba..d0719feed792 100644
> --- a/fs/ceph/inode.c
> +++ b/fs/ceph/inode.c
> @@ -1902,6 +1902,7 @@ int ceph_readdir_prepopulate(struct ceph_mds_request *req,
>   			goto out;
>   		}
>   
> +		rde->dentry = NULL;
>   		dname.name = oname.name;
>   		dname.len = oname.len;
>   		dname.hash = full_name_hash(parent, dname.name, dname.len);
> @@ -1962,6 +1963,12 @@ int ceph_readdir_prepopulate(struct ceph_mds_request *req,
>   			goto retry_lookup;
>   		}
>   
> +		/*
> +		 * ceph_readdir will use the dentry to get the name
> +		 * to avoid doing the dencrypt again there.
> +		 */
> +		rde->dentry = dget(dn);
> +
>   		/* inode */
>   		if (d_really_is_positive(dn)) {
>   			in = d_inode(dn);
> @@ -2024,6 +2031,14 @@ int ceph_readdir_prepopulate(struct ceph_mds_request *req,
>   		dput(dn);
>   	}
>   out:
> +	if (err) {
> +		for (; i >= 0; i--) {
> +			struct ceph_mds_reply_dir_entry *rde;
> +
> +			rde = rinfo->dir_entries + i;
> +			dput(rde->dentry);
> +		}
> +	}
>   	if (err == 0 && skipped == 0) {
>   		set_bit(CEPH_MDS_R_DID_PREPOPULATE, &req->r_req_flags);
>   		req->r_readdir_cache_idx = cache_ctl.index;
> diff --git a/fs/ceph/mds_client.h b/fs/ceph/mds_client.h
> index 0dfe24f94567..663d7754d57d 100644
> --- a/fs/ceph/mds_client.h
> +++ b/fs/ceph/mds_client.h
> @@ -96,6 +96,7 @@ struct ceph_mds_reply_info_in {
>   };
>   
>   struct ceph_mds_reply_dir_entry {
> +	struct dentry		      *dentry;
>   	char                          *name;
>   	u8			      *altname;
>   	u32                           name_len;

