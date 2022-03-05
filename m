Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 321E34CE1CB
	for <lists+ceph-devel@lfdr.de>; Sat,  5 Mar 2022 02:06:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229907AbiCEBH2 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 4 Mar 2022 20:07:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229478AbiCEBH1 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Fri, 4 Mar 2022 20:07:27 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id E13911E2FD8
        for <ceph-devel@vger.kernel.org>; Fri,  4 Mar 2022 17:06:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646442397;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Z9grOFWPyACFLBEMPdhVO07s3jKH78Nq66X7UX3HdC8=;
        b=h3Y8MKN1j9C4VuvWYsr4PEkZJLkKAPQjVkcFEuJdOw25FtHKCQQtaHZgCSn0VntLd/GTCm
        c4O1Uo07gKmSF2z/ypMtkzMofNj9RTCVZW05NOXvH3NruAzXf5fN/two2D4ubuZN0X9nTd
        EDFjMHIuzjROEpWBeFEpTWvXmcfrEjU=
Received: from mail-pf1-f199.google.com (mail-pf1-f199.google.com
 [209.85.210.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-209-iQWfgqnFNTmNlg-Xc6wHDg-1; Fri, 04 Mar 2022 20:06:36 -0500
X-MC-Unique: iQWfgqnFNTmNlg-Xc6wHDg-1
Received: by mail-pf1-f199.google.com with SMTP id x27-20020aa79a5b000000b004f3f7c2981eso6053954pfj.3
        for <ceph-devel@vger.kernel.org>; Fri, 04 Mar 2022 17:06:36 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=Z9grOFWPyACFLBEMPdhVO07s3jKH78Nq66X7UX3HdC8=;
        b=zHuo/oxuSJvEgu82IvM6aZTHpq9pbbtVV+czK8CuTvQMDQXjXKlEQJCT8ZJ7U+1BEC
         Xoa0TOwoOXyi58cSSNWnmaEjEktAwb4V9ug+mctjw63wvy1sSGbeaIERywf4yLeiQbux
         jCsoLFQxAtAh/EcnfEQFwEoyc2GBnjMgVpH3Wj0441DNVRjlHky4xUKuGVKOiDIUAcmF
         OEjWPNmsb9So0cJQi969Rk1MBLbnsvb36h1RruJEsv+CUt64Dmv/Xcx/U2SNhHzBrxwG
         2sqhRSYEyaybv6CzKOQIMgmbddcJZajs16pgzcP4W7b6drmHtu5wGTsEvwwwdxJG9coF
         tAVQ==
X-Gm-Message-State: AOAM530+6WQ/8+9oTieycdxbgMuC+1It1aOAt5ALWvP3gL3Qv4GFqJJb
        yiJ0HUL0bSMy3oGh+3MQjmHPwxK7V2rrxrZ/RM9rgvBwlratTMEmmQec6J6QkKe6MgN+YZ2rPSx
        Gb1/nulx95wxL+kmfSd3UdPW70l5Z32uXYAuIEZE/Yjp1+iTwklaSm6IrX/b2cICLAAjNHjU=
X-Received: by 2002:a63:8ac8:0:b0:37c:ed36:8e45 with SMTP id y191-20020a638ac8000000b0037ced368e45mr895287pgd.48.1646442394924;
        Fri, 04 Mar 2022 17:06:34 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxj4w5mgak6m1nYOqEcg2lTB/AJhCrh9IzDrPhbpgo6RMh3jnu4GUpsH1RAVubjR2zXE1Uhug==
X-Received: by 2002:a63:8ac8:0:b0:37c:ed36:8e45 with SMTP id y191-20020a638ac8000000b0037ced368e45mr895260pgd.48.1646442394510;
        Fri, 04 Mar 2022 17:06:34 -0800 (PST)
Received: from [10.72.13.171] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id a19-20020a17090ad81300b001bc447c2c91sm11648902pjv.31.2022.03.04.17.06.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 04 Mar 2022 17:06:33 -0800 (PST)
Subject: Re: [PATCH v4 2/2] ceph: do not dencrypt the dentry name twice for
 readdir
To:     Jeff Layton <jlayton@kernel.org>
Cc:     idryomov@gmail.com, vshankar@redhat.com, lhenriques@suse.de,
        ceph-devel@vger.kernel.org
References: <20220303032640.521999-1-xiubli@redhat.com>
 <20220303032640.521999-3-xiubli@redhat.com>
 <ea879caa7e98789d236302c8fbad8dc1c37d3e9e.camel@kernel.org>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <e46ff404-bf96-02f1-b0e8-6bfb9cef71d1@redhat.com>
Date:   Sat, 5 Mar 2022 09:06:27 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <ea879caa7e98789d236302c8fbad8dc1c37d3e9e.camel@kernel.org>
Content-Type: text/plain; charset=iso-8859-15; format=flowed
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


On 3/5/22 1:57 AM, Jeff Layton wrote:
> On Thu, 2022-03-03 at 11:26 +0800, xiubli@redhat.com wrote:
>> From: Xiubo Li <xiubli@redhat.com>
>>
>> For the readdir request the dentries will be pasred and dencrypted
>> in ceph_readdir_prepopulate(). And in ceph_readdir() we could just
>> get the dentry name from the dentry cache instead of parsing and
>> dencrypting them again. This could improve performance.
>>
>> Signed-off-by: Xiubo Li <xiubli@redhat.com>
>> ---
>>   fs/ceph/crypto.h     |  8 +++++
>>   fs/ceph/dir.c        | 74 +++++++++++++++++++++++---------------------
>>   fs/ceph/inode.c      | 15 +++++++++
>>   fs/ceph/mds_client.h |  1 +
>>   4 files changed, 63 insertions(+), 35 deletions(-)
>>
>> diff --git a/fs/ceph/crypto.h b/fs/ceph/crypto.h
>> index 1e08f8a64ad6..9a00c60b8535 100644
>> --- a/fs/ceph/crypto.h
>> +++ b/fs/ceph/crypto.h
>> @@ -83,6 +83,14 @@ static inline u32 ceph_fscrypt_auth_len(struct ceph_fscrypt_auth *fa)
>>    */
>>   #define CEPH_NOHASH_NAME_MAX (189 - SHA256_DIGEST_SIZE)
>>   
>> +/*
>> + * The encrypted long snap name will be in format of
>> + * "_${ENCRYPTED-LONG-SNAP-NAME}_${INODE-NUM}". And will set the max longth
>> + * to sizeof('_') + NAME_MAX + sizeof('_') + max of sizeof(${INO}) + extra 7
>> + * bytes to align the total size to 8 bytes.
>> + */
>> +#define CEPH_ENCRPTED_LONG_SNAP_NAME_MAX (1 + 255 + 1 + 16 + 7)
>> +
> Maybe CEPH_ENCRYPTED_LONG_SNAP_NAME_MAX instead?

Sure, will fix it.


>
>>   void ceph_fscrypt_set_ops(struct super_block *sb);
>>   
>>   void ceph_fscrypt_free_dummy_policy(struct ceph_fs_client *fsc);
>> diff --git a/fs/ceph/dir.c b/fs/ceph/dir.c
>> index 4da59810b036..fa3da3b29130 100644
>> --- a/fs/ceph/dir.c
>> +++ b/fs/ceph/dir.c
>> @@ -316,8 +316,7 @@ static int ceph_readdir(struct file *file, struct dir_context *ctx)
>>   	int err;
>>   	unsigned frag = -1;
>>   	struct ceph_mds_reply_info_parsed *rinfo;
>> -	struct fscrypt_str tname = FSTR_INIT(NULL, 0);
>> -	struct fscrypt_str oname = FSTR_INIT(NULL, 0);
>> +	char *dentry_name = NULL;
>>   
>>   	dout("readdir %p file %p pos %llx\n", inode, file, ctx->pos);
>>   	if (dfi->file_info.flags & CEPH_F_ATEND)
>> @@ -345,10 +344,6 @@ static int ceph_readdir(struct file *file, struct dir_context *ctx)
>>   		ctx->pos = 2;
>>   	}
>>   
>> -	err = fscrypt_prepare_readdir(inode);
>> -	if (err)
>> -		goto out;
>> -
>>   	spin_lock(&ci->i_ceph_lock);
>>   	/* request Fx cap. if have Fx, we don't need to release Fs cap
>>   	 * for later create/unlink. */
>> @@ -369,14 +364,6 @@ static int ceph_readdir(struct file *file, struct dir_context *ctx)
>>   		spin_unlock(&ci->i_ceph_lock);
>>   	}
>>   
>> -	err = ceph_fname_alloc_buffer(inode, &tname);
>> -	if (err < 0)
>> -		goto out;
>> -
>> -	err = ceph_fname_alloc_buffer(inode, &oname);
>> -	if (err < 0)
>> -		goto out;
>> -
>>   	/* proceed with a normal readdir */
>>   more:
>>   	/* do we have the correct frag content buffered? */
>> @@ -528,42 +515,59 @@ static int ceph_readdir(struct file *file, struct dir_context *ctx)
>>   			}
>>   		}
>>   	}
>> +
>> +	dentry_name = kmalloc(CEPH_ENCRPTED_LONG_SNAP_NAME_MAX, GFP_KERNEL);
>> +	if (!dentry_name) {
>> +		err = -ENOMEM;
>> +		ceph_mdsc_put_request(dfi->last_readdir);
>> +		dfi->last_readdir = NULL;
>> +		goto out;
>> +	}
>> +
> If this happens (or an earlier error), all of the dentry references will
> leak. I think you probably need to move the cleanup into
> destroy_reply_info().

Yeah, I will fix it too.

Thanks.


>
>>   	for (; i < rinfo->dir_nr; i++) {
>>   		struct ceph_mds_reply_dir_entry *rde = rinfo->dir_entries + i;
>> -		struct ceph_fname fname = { .dir	= inode,
>> -					    .name	= rde->name,
>> -					    .name_len	= rde->name_len,
>> -					    .ctext	= rde->altname,
>> -					    .ctext_len	= rde->altname_len };
>> -		u32 olen = oname.len;
>> -
>> -		err = ceph_fname_to_usr(&fname, &tname, &oname, NULL);
>> -		if (err) {
>> -			pr_err("%s unable to decode %.*s, got %d\n", __func__,
>> -			       rde->name_len, rde->name, err);
>> -			goto out;
>> -		}
>> +		struct dentry *dn = rde->dentry;
>> +		int name_len;
>>   
>>   		BUG_ON(rde->offset < ctx->pos);
>>   		BUG_ON(!rde->inode.in);
>> +		BUG_ON(!rde->dentry);
>>   
>>   		ctx->pos = rde->offset;
>> -		dout("readdir (%d/%d) -> %llx '%.*s' %p\n",
>> -		     i, rinfo->dir_nr, ctx->pos,
>> -		     rde->name_len, rde->name, &rde->inode.in);
>>   
>> -		if (!dir_emit(ctx, oname.name, oname.len,
>> +		spin_lock(&dn->d_lock);
>> +		memcpy(dentry_name, dn->d_name.name, dn->d_name.len);
>> +		name_len = dn->d_name.len;
>> +		spin_unlock(&dn->d_lock);
>> +
>> +		dentry_name[name_len] = '\0';
>> +		dout("readdir (%d/%d) -> %llx '%s' %p\n",
>> +		     i, rinfo->dir_nr, ctx->pos, dentry_name, &rde->inode.in);
>> +
>> +		dput(dn);
>> +		rde->dentry = NULL;
>> +
>> +		if (!dir_emit(ctx, dentry_name, name_len,
>>   			      ceph_present_ino(inode->i_sb, le64_to_cpu(rde->inode.in->ino)),
>>   			      le32_to_cpu(rde->inode.in->mode) >> 12)) {
>>   			dout("filldir stopping us...\n");
>> +
>> +			/*
>> +			 * dput the rest dentries. Must do this before
>> +			 * releasing the request.
>> +			 */
>> +			for (++i; i < rinfo->dir_nr; i++) {
>> +				rde = rinfo->dir_entries + i;
>> +				dput(rde->dentry);
>> +				rde->dentry = NULL;
>> +			}
>> +
>>   			err = 0;
>>   			ceph_mdsc_put_request(dfi->last_readdir);
>>   			dfi->last_readdir = NULL;
>>   			goto out;
>>   		}
>>   
>> -		/* Reset the lengths to their original allocated vals */
>> -		oname.len = olen;
>>   		ctx->pos++;
>>   	}
>>   
>> @@ -621,8 +625,8 @@ static int ceph_readdir(struct file *file, struct dir_context *ctx)
>>   	err = 0;
>>   	dout("readdir %p file %p done.\n", inode, file);
>>   out:
>> -	ceph_fname_free_buffer(inode, &tname);
>> -	ceph_fname_free_buffer(inode, &oname);
>> +	if (dentry_name)
>> +		kfree(dentry_name);
>>   	return err;
>>   }
>>   
>> diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
>> index e5a9838981ba..d0719feed792 100644
>> --- a/fs/ceph/inode.c
>> +++ b/fs/ceph/inode.c
>> @@ -1902,6 +1902,7 @@ int ceph_readdir_prepopulate(struct ceph_mds_request *req,
>>   			goto out;
>>   		}
>>   
>> +		rde->dentry = NULL;
>>   		dname.name = oname.name;
>>   		dname.len = oname.len;
>>   		dname.hash = full_name_hash(parent, dname.name, dname.len);
>> @@ -1962,6 +1963,12 @@ int ceph_readdir_prepopulate(struct ceph_mds_request *req,
>>   			goto retry_lookup;
>>   		}
>>   
>> +		/*
>> +		 * ceph_readdir will use the dentry to get the name
>> +		 * to avoid doing the dencrypt again there.
>> +		 */
>> +		rde->dentry = dget(dn);
>> +
>>   		/* inode */
>>   		if (d_really_is_positive(dn)) {
>>   			in = d_inode(dn);
>> @@ -2024,6 +2031,14 @@ int ceph_readdir_prepopulate(struct ceph_mds_request *req,
>>   		dput(dn);
>>   	}
>>   out:
>> +	if (err) {
>> +		for (; i >= 0; i--) {
>> +			struct ceph_mds_reply_dir_entry *rde;
>> +
>> +			rde = rinfo->dir_entries + i;
>> +			dput(rde->dentry);
>> +		}
>> +	}
>>   	if (err == 0 && skipped == 0) {
>>   		set_bit(CEPH_MDS_R_DID_PREPOPULATE, &req->r_req_flags);
>>   		req->r_readdir_cache_idx = cache_ctl.index;
>> diff --git a/fs/ceph/mds_client.h b/fs/ceph/mds_client.h
>> index 0dfe24f94567..663d7754d57d 100644
>> --- a/fs/ceph/mds_client.h
>> +++ b/fs/ceph/mds_client.h
>> @@ -96,6 +96,7 @@ struct ceph_mds_reply_info_in {
>>   };
>>   
>>   struct ceph_mds_reply_dir_entry {
>> +	struct dentry		      *dentry;
>>   	char                          *name;
>>   	u8			      *altname;
>>   	u32                           name_len;

