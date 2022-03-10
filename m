Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 82FAE4D40FD
	for <lists+ceph-devel@lfdr.de>; Thu, 10 Mar 2022 07:08:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236932AbiCJGJo (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 10 Mar 2022 01:09:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233571AbiCJGJn (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 10 Mar 2022 01:09:43 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 917F16C1ED
        for <ceph-devel@vger.kernel.org>; Wed,  9 Mar 2022 22:08:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646892518;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ummWPydrZU32XVQM1qw8zSNU4atwFzj08LvibiRYkJI=;
        b=JQxs/PWuvxkDILS6vK9NGsg/NVeoyRcyE63j9pZ0rGhdd6Hup9LPnwxVUNVu6f4thr/aDk
        wWYIrYwmu2kDB+Tdk8CB2btRPCtsU8v+BY5NNoxQQEuOZOnZd1V1i3OFvHmXCQuO/YStJ0
        QYQr6XzycZKBmjgsChrn0PNOvNuu/mY=
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com
 [209.85.216.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-81-kLD5OJdPOCaj81dzmTAGPA-1; Thu, 10 Mar 2022 01:08:37 -0500
X-MC-Unique: kLD5OJdPOCaj81dzmTAGPA-1
Received: by mail-pj1-f71.google.com with SMTP id q9-20020a17090a7a8900b001bf0a7d9dfdso2777757pjf.4
        for <ceph-devel@vger.kernel.org>; Wed, 09 Mar 2022 22:08:36 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=ummWPydrZU32XVQM1qw8zSNU4atwFzj08LvibiRYkJI=;
        b=ajmQqOnN3SPBgZaphdf68faEsHSuZ+C5eyo01Q8o1qBmGr/RRcEnQKzzCuqGKH5efF
         i1idsWM/CU3eXqZvZfuA1liKlC0DLMqPpZmOooZSjRQU7q0TX9C+3PL5vNyP6BlhkHCL
         fY1wIuU3NqNl6iu/3XbHLwVKfM5hTUR6evTNlIseShw7/fiTERoi9pUfyJvwZNmItGq/
         HiiA8fGbuP5hk55RSvekO790oQIWXGS/vLiLWa3t0g3VzOxNSdzLZ6IYuYByGd0FTkwc
         VPSK/8afqfTgdNoLwFZzsKdwN8zScIHGsSpHgDHOcYyGDxkzD8+qh6MM48zJTX1H+dt9
         RD3Q==
X-Gm-Message-State: AOAM532vUlUgmveVZCBrsbcfzqEFFIk4Nvd5EpWla5VxsgaCm+lRPjfH
        FBDl1Foh3aKW/J6/O4cT6IQA+NcVR+IR4R6c4Tbupmm1Qk8kWXMcAnrrDq30G1Nozhm+JUn+A2d
        pfCoCszMbF0Tn3+m35t2rVXNXMMBQDsOXy2fbPdYZPYedv/EaMiKqDyxp23MuWgGMt7EMdC0=
X-Received: by 2002:a63:ea53:0:b0:341:a28e:16b9 with SMTP id l19-20020a63ea53000000b00341a28e16b9mr2794665pgk.259.1646892515233;
        Wed, 09 Mar 2022 22:08:35 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxm7p6txtamATized8CC+um5BzF1usvMUwpIplqxqK7BoMqStgFZZp4/QU8jfMye40CemCmZQ==
X-Received: by 2002:a63:ea53:0:b0:341:a28e:16b9 with SMTP id l19-20020a63ea53000000b00341a28e16b9mr2794644pgk.259.1646892514828;
        Wed, 09 Mar 2022 22:08:34 -0800 (PST)
Received: from [10.72.12.132] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id m4-20020a17090a7f8400b001bef3fc3938sm4481317pjl.49.2022.03.09.22.08.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Mar 2022 22:08:34 -0800 (PST)
Subject: Re: [PATCH V7] ceph: do not dencrypt the dentry name twice for
 readdir
To:     jlayton@kernel.org
Cc:     idryomov@gmail.com, vshankar@redhat.com, lhenriques@suse.de,
        ceph-devel@vger.kernel.org
References: <20220309135914.95804-1-xiubli@redhat.com>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <b0605e1e-5c54-d250-8e93-773638d36ab6@redhat.com>
Date:   Thu, 10 Mar 2022 14:08:16 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20220309135914.95804-1-xiubli@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


On 3/9/22 9:59 PM, xiubli@redhat.com wrote:
> From: Xiubo Li <xiubli@redhat.com>
>
> For the readdir request the dentries will be pasred and dencrypted
> in ceph_readdir_prepopulate(). And in ceph_readdir() we could just
> get the dentry name from the dentry cache instead of parsing and
> dencrypting them again. This could improve performance.
>
> Signed-off-by: Xiubo Li <xiubli@redhat.com>
> ---
>
> V7:
> - Fix the xfstest generic/006 crash bug about the rde->dentry == NULL.
>
> V6:
> - Remove CEPH_ENCRYPTED_LONG_SNAP_NAME_MAX macro and use the NAME_MAX
>    instead, since we are limiting the max length of snapshot name to
>    240, which is NAME_MAX - 2 * sizeof('_') - sizeof(<inode#>).
>
> V5:
> - fix typo of CEPH_ENCRYPTED_LONG_SNAP_NAME_MAX macro
> - release the rde->dentry in destroy_reply_info
>
>
>
>   fs/ceph/dir.c        | 56 ++++++++++++++++++++------------------------
>   fs/ceph/inode.c      |  7 ++++++
>   fs/ceph/mds_client.c |  1 +
>   fs/ceph/mds_client.h |  1 +
>   4 files changed, 34 insertions(+), 31 deletions(-)
>
> diff --git a/fs/ceph/dir.c b/fs/ceph/dir.c
> index 6df2a91af236..2397c34e9173 100644
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
> @@ -369,14 +368,6 @@ static int ceph_readdir(struct file *file, struct dir_context *ctx)
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
> @@ -528,31 +519,36 @@ static int ceph_readdir(struct file *file, struct dir_context *ctx)
>   			}
>   		}
>   	}
> +
> +	dentry_name = kmalloc(NAME_MAX, GFP_KERNEL);
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

Hi Jeff,

BTW, does the dn->d_lock is must here ? From the code comments, the 
d_lock intends to protect the 'd_flag' and 'd_lockref.count'.

In ceph code I found some places are using the d_lock when accessing the 
d_name, some are not. And in none ceph code, they will almost never use 
the d_lock to protect the d_name.

- Xiubo


> +		dentry_name[name_len] = '\0';
> +		dout("readdir (%d/%d) -> %llx '%s' %p\n",
> +		     i, rinfo->dir_nr, ctx->pos, dentry_name, &rde->inode.in);
> +
> +		if (!dir_emit(ctx, dentry_name, name_len,
>   			      ceph_present_ino(inode->i_sb, le64_to_cpu(rde->inode.in->ino)),
>   			      le32_to_cpu(rde->inode.in->mode) >> 12)) {
>   			/*
> @@ -566,8 +562,6 @@ static int ceph_readdir(struct file *file, struct dir_context *ctx)
>   			goto out;
>   		}
>   
> -		/* Reset the lengths to their original allocated vals */
> -		oname.len = olen;
>   		ctx->pos++;
>   	}
>   
> @@ -625,8 +619,8 @@ static int ceph_readdir(struct file *file, struct dir_context *ctx)
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
> index b573a0f33450..19e5275eae1c 100644
> --- a/fs/ceph/inode.c
> +++ b/fs/ceph/inode.c
> @@ -1909,6 +1909,7 @@ int ceph_readdir_prepopulate(struct ceph_mds_request *req,
>   			goto out;
>   		}
>   
> +		rde->dentry = NULL;
>   		dname.name = oname.name;
>   		dname.len = oname.len;
>   		dname.hash = full_name_hash(parent, dname.name, dname.len);
> @@ -1969,6 +1970,12 @@ int ceph_readdir_prepopulate(struct ceph_mds_request *req,
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
> diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
> index 8d704ddd7291..9e0a51ef1dfa 100644
> --- a/fs/ceph/mds_client.c
> +++ b/fs/ceph/mds_client.c
> @@ -733,6 +733,7 @@ static void destroy_reply_info(struct ceph_mds_reply_info_parsed *info)
>   
>   		kfree(rde->inode.fscrypt_auth);
>   		kfree(rde->inode.fscrypt_file);
> +		dput(rde->dentry);
>   	}
>   	free_pages((unsigned long)info->dir_entries, get_order(info->dir_buf_size));
>   }
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

