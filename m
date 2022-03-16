Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BDE2B4DA712
	for <lists+ceph-devel@lfdr.de>; Wed, 16 Mar 2022 01:47:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352846AbiCPAtK (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 15 Mar 2022 20:49:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237764AbiCPAtI (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 15 Mar 2022 20:49:08 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 237C265EB
        for <ceph-devel@vger.kernel.org>; Tue, 15 Mar 2022 17:47:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1647391672;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=re2Tam7gtcX+vvhHqkMR415En/YB7irGYee1U4ejwNA=;
        b=elymFTn/ErjLDxxZMZYydGKToBF9IBYLy8B/RG4niGzDDzGCyYXA0Lis4u+Xd5fmVJFGZC
        cY92qoRzAMdbFnxrUM5a4gvaJHMbA2gL7FhqvQWb/ah1Vf4vgqQEXfTCQj82w2pqOeyIza
        AMoFn9Bo5JtxSq1Q7YVaFWAw1l2vtu0=
Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com
 [209.85.214.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-601-fbYiHLzCOriGdvO7Pn-LBg-1; Tue, 15 Mar 2022 20:47:51 -0400
X-MC-Unique: fbYiHLzCOriGdvO7Pn-LBg-1
Received: by mail-pl1-f200.google.com with SMTP id n17-20020a170902f61100b001538c882549so339312plg.18
        for <ceph-devel@vger.kernel.org>; Tue, 15 Mar 2022 17:47:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=re2Tam7gtcX+vvhHqkMR415En/YB7irGYee1U4ejwNA=;
        b=4bCLhfAtcT7eY4x+ItnYHzMROk4BCUeMc557KfurrlTVCV8F/S8en5uB0R1Nrxj5N1
         qFRgq9uEdkF+nJ7zvgXhFTHSQtiYig3eBya7xNHOBjP43NOlTmbLSxGlKFGa/jO18l/J
         c+b+zGiKp579PUFjT8fxqUCZ93s3YWWMGYABPoeViDGh6XvzEmW2bfSvLPr6L7DzAdVK
         i1afQk/erAsZcy+I5sC1kWDqIDbVa841ZRR7fkmxka0qzRKXWgMrlw6KBBqpG8MOq5uU
         22ZSlswJArJOK91v/o4WL8lGA5KdeRhSXVbLXdO77Aq0y6FGoUL3L/60hIJHeQ/L/d4o
         XlIA==
X-Gm-Message-State: AOAM530sEWd068EWTyyoOgcMckjSx4EbGO1cvpXel3lH3pXL8xvAModr
        tHeXPWIHMHubyn5XUfixe5VIwFis3jeDhU+KVIApq8dIRgWoJvTj2QGjaNMir3bydmeS7kbg7mR
        4FhZEUCoU6hfbWHoG0FocEw==
X-Received: by 2002:aa7:8385:0:b0:4f6:ef47:e943 with SMTP id u5-20020aa78385000000b004f6ef47e943mr31877894pfm.38.1647391669573;
        Tue, 15 Mar 2022 17:47:49 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzt+STF+Jr2foxSo0t7cfUMP5etUeSHxZ4B5S4Lb1iNYGvu0hKG28/BSxJ1czpZ5RaBwHLrfw==
X-Received: by 2002:aa7:8385:0:b0:4f6:ef47:e943 with SMTP id u5-20020aa78385000000b004f6ef47e943mr31877871pfm.38.1647391669165;
        Tue, 15 Mar 2022 17:47:49 -0700 (PDT)
Received: from [10.72.12.110] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id o5-20020a655bc5000000b00372f7ecfcecsm418092pgr.37.2022.03.15.17.47.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 15 Mar 2022 17:47:48 -0700 (PDT)
Subject: Re: [RFC PATCH v2 2/3] ceph: add support for handling encrypted
 snapshot names
To:     =?UTF-8?Q?Lu=c3=ads_Henriques?= <lhenriques@suse.de>,
        Jeff Layton <jlayton@kernel.org>,
        Ilya Dryomov <idryomov@gmail.com>
Cc:     ceph-devel@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20220315161959.19453-1-lhenriques@suse.de>
 <20220315161959.19453-3-lhenriques@suse.de>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <972eafc3-93a3-b523-4ad2-e234b3664635@redhat.com>
Date:   Wed, 16 Mar 2022 08:47:43 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20220315161959.19453-3-lhenriques@suse.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Spam-Status: No, score=-3.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


On 3/16/22 12:19 AM, Luís Henriques wrote:
> When creating a snapshot, the .snap directories for every subdirectory will
> show the snapshot name in the "long format":
>
>    # mkdir .snap/my-snap
>    # ls my-dir/.snap/
>    _my-snap_1099511627782
>
> Encrypted snapshots will need to be able to handle these snapshot names by
> encrypting/decrypting only the snapshot part of the string ('my-snap').
>
> Also, since the MDS prevents snapshot names to be bigger than 240 characters
> it is necessary to adapt CEPH_NOHASH_NAME_MAX to accommodate this extra
> limitation.
>
> Signed-off-by: Luís Henriques <lhenriques@suse.de>
> ---
>   fs/ceph/crypto.c | 158 +++++++++++++++++++++++++++++++++++++++++------
>   fs/ceph/crypto.h |  11 ++--
>   2 files changed, 145 insertions(+), 24 deletions(-)
>
> diff --git a/fs/ceph/crypto.c b/fs/ceph/crypto.c
> index c125a79019b3..06a4b918201c 100644
> --- a/fs/ceph/crypto.c
> +++ b/fs/ceph/crypto.c
> @@ -128,18 +128,95 @@ void ceph_fscrypt_as_ctx_to_req(struct ceph_mds_request *req, struct ceph_acl_se
>   	swap(req->r_fscrypt_auth, as->fscrypt_auth);
>   }
>   
> -int ceph_encode_encrypted_dname(const struct inode *parent, struct qstr *d_name, char *buf)
> +/*
> + * User-created snapshots can't start with '_'.  Snapshots that start with this
> + * character are special (hint: there aren't real snapshots) and use the
> + * following format:
> + *
> + *   _<SNAPSHOT-NAME>_<INODE-NUMBER>
> + *
> + * where:
> + *  - <SNAPSHOT-NAME> - the real snapshot name that may need to be decrypted,
> + *  - <INODE-NUMBER> - the inode number for the actual snapshot
> + *
> + * This function parses these snapshot names and returns the inode
> + * <INODE-NUMBER>.  'name_len' will also bet set with the <SNAPSHOT-NAME>
> + * length.
> + */
> +static struct inode *parse_longname(const struct inode *parent, const char *name,
> +				    int *name_len)
>   {
> +	struct inode *dir = NULL;
> +	struct ceph_vino vino = { .snap = CEPH_NOSNAP };
> +	char *inode_number;
> +	char *name_end;
> +	int orig_len = *name_len;
> +	int ret = -EIO;
> +
> +	/* Skip initial '_' */
> +	name++;
> +	name_end = strrchr(name, '_');
> +	if (!name_end) {
> +		dout("Failed to parse long snapshot name: %s\n", name);
> +		return ERR_PTR(-EIO);
> +	}
> +	*name_len = (name_end - name);
> +	if (*name_len <= 0) {
> +		pr_err("Failed to parse long snapshot name\n");
> +		return ERR_PTR(-EIO);
> +	}
> +
> +	/* Get the inode number */
> +	inode_number = kmemdup_nul(name_end + 1,
> +				   orig_len - *name_len - 2,
> +				   GFP_KERNEL);
> +	if (!inode_number)
> +		return ERR_PTR(-ENOMEM);
> +	ret = kstrtou64(inode_number, 0, &vino.ino);
> +	if (ret) {
> +		dout("Failed to parse inode number: %s\n", name);
> +		dir = ERR_PTR(ret);
> +		goto out;
> +	}
> +
> +	/* And finally the inode */
> +	dir = ceph_get_inode(parent->i_sb, vino, NULL);

Maybe you should use ceph_find_inode() here ? We shouldn't insert a new 
one here. And IMO the parent dir inode must be in the cache...


> +	if (IS_ERR(dir))
> +		dout("Can't find inode %s (%s)\n", inode_number, name);
> +
> +out:
> +	kfree(inode_number);
> +	return dir;
> +}

Here I think you have missed one case, not all the long snap names are 
needed to be dencrypted if they are from the parent snap realms, who are 
not encrypted, for example:

mkdir dir1

fscrypt encrypt dir1

mkdir dir1/dir2

mkdir .snap/root_snap

mkdir dir1/.snap/dir1_snap

ls dir1/dir2/.snap/

_root_snap_1  _dir1_snap_1099511628283

You shouldn't encrypt the "_root_snap_1" long name.


> +
> +int ceph_encode_encrypted_dname(struct inode *parent, struct qstr *d_name, char *buf)
> +{
> +	struct inode *dir = parent;
> +	struct qstr iname;
>   	u32 len;
> +	int name_len;
>   	int elen;
>   	int ret;
> -	u8 *cryptbuf;
> +	u8 *cryptbuf = NULL;
>   
>   	if (!fscrypt_has_encryption_key(parent)) {
>   		memcpy(buf, d_name->name, d_name->len);
>   		return d_name->len;
>   	}
>   
> +	iname.name = d_name->name;
> +	name_len = d_name->len;
> +
> +	/* Handle the special case of snapshot names that start with '_' */
> +	if ((ceph_snap(dir) == CEPH_SNAPDIR) && (name_len > 0) &&
> +	    (iname.name[0] == '_')) {
> +		dir = parse_longname(parent, iname.name, &name_len);
> +		if (IS_ERR(dir))
> +			return PTR_ERR(dir);
> +		iname.name++; /* skip initial '_' */
> +	}
> +	iname.len = name_len;
> +

Maybe you can do this just before checking the 
fscrypt_has_encryption_key() to fix the issue mentioned above ?


>   	/*
>   	 * convert cleartext d_name to ciphertext
>   	 * if result is longer than CEPH_NOKEY_NAME_MAX,
> @@ -147,18 +224,22 @@ int ceph_encode_encrypted_dname(const struct inode *parent, struct qstr *d_name,
>   	 *
>   	 * See: fscrypt_setup_filename
>   	 */
> -	if (!fscrypt_fname_encrypted_size(parent, d_name->len, NAME_MAX, &len))
> -		return -ENAMETOOLONG;
> +	if (!fscrypt_fname_encrypted_size(dir, iname.len, NAME_MAX, &len)) {
> +		elen = -ENAMETOOLONG;
> +		goto out;
> +	}
>   
>   	/* Allocate a buffer appropriate to hold the result */
>   	cryptbuf = kmalloc(len > CEPH_NOHASH_NAME_MAX ? NAME_MAX : len, GFP_KERNEL);
> -	if (!cryptbuf)
> -		return -ENOMEM;
> +	if (!cryptbuf) {
> +		elen = -ENOMEM;
> +		goto out;
> +	}
>   
> -	ret = fscrypt_fname_encrypt(parent, d_name, cryptbuf, len);
> +	ret = fscrypt_fname_encrypt(dir, &iname, cryptbuf, len);
>   	if (ret) {
> -		kfree(cryptbuf);
> -		return ret;
> +		elen = ret;
> +		goto out;
>   	}
>   
>   	/* hash the end if the name is long enough */
> @@ -174,12 +255,24 @@ int ceph_encode_encrypted_dname(const struct inode *parent, struct qstr *d_name,
>   
>   	/* base64 encode the encrypted name */
>   	elen = fscrypt_base64url_encode(cryptbuf, len, buf);
> -	kfree(cryptbuf);
>   	dout("base64-encoded ciphertext name = %.*s\n", elen, buf);
> +
> +	if ((elen > 0) && (dir != parent)) {
> +		char tmp_buf[FSCRYPT_BASE64URL_CHARS(NAME_MAX)];
> +

Do we really need FSCRYPT_BASE64URL_CHARS(NAME_MAX) ? Since you have fix 
the 189->180 code, then the encrypted long snap name shouldn't exceed 255.

I think the NAME_MAX is enough.

And also you should check the elen here it shouldn't exceed 240 after 
encrypted, or should we fail it here directly with a warning log ?


> +		elen = snprintf(tmp_buf, sizeof(tmp_buf), "_%.*s_%ld",
> +				elen, buf, dir->i_ino);
> +		memcpy(buf, tmp_buf, elen);
> +	}
> +
> +out:
> +	kfree(cryptbuf);
> +	if (dir != parent)
> +		iput(dir);
>   	return elen;
>   }
>   
> -int ceph_encode_encrypted_fname(const struct inode *parent, struct dentry *dentry, char *buf)
> +int ceph_encode_encrypted_fname(struct inode *parent, struct dentry *dentry, char *buf)
>   {
>   	WARN_ON_ONCE(!fscrypt_has_encryption_key(parent));
>   
> @@ -204,11 +297,14 @@ int ceph_encode_encrypted_fname(const struct inode *parent, struct dentry *dentr
>   int ceph_fname_to_usr(const struct ceph_fname *fname, struct fscrypt_str *tname,
>   		      struct fscrypt_str *oname, bool *is_nokey)
>   {
> -	int ret;
> +	struct inode *dir = fname->dir;
>   	struct fscrypt_str _tname = FSTR_INIT(NULL, 0);
>   	struct fscrypt_str iname;
> +	char *name = fname->name;
> +	int name_len = fname->name_len;
> +	int ret;
>   
> -	if (!IS_ENCRYPTED(fname->dir)) {
> +	if (!IS_ENCRYPTED(dir)) {
>   		oname->name = fname->name;
>   		oname->len = fname->name_len;
>   		return 0;
> @@ -218,15 +314,24 @@ int ceph_fname_to_usr(const struct ceph_fname *fname, struct fscrypt_str *tname,
>   	if (fname->name_len > NAME_MAX || fname->ctext_len > NAME_MAX)
>   		return -EIO;
>   
> -	ret = __fscrypt_prepare_readdir(fname->dir);
> +	/* Handle the special case of snapshot names that start with '_' */
> +	if ((ceph_snap(dir) == CEPH_SNAPDIR) && (name_len > 0) &&
> +	    (name[0] == '_')) {
> +		dir = parse_longname(dir, name, &name_len);
> +		if (IS_ERR(dir))
> +			return PTR_ERR(dir);
> +		name++; /* skip initial '_' */
> +	}
> +
> +	ret = __fscrypt_prepare_readdir(dir);
>   	if (ret)
> -		return ret;
> +		goto out_inode;
>   
>   	/*
>   	 * Use the raw dentry name as sent by the MDS instead of
>   	 * generating a nokey name via fscrypt.
>   	 */
> -	if (!fscrypt_has_encryption_key(fname->dir)) {
> +	if (!fscrypt_has_encryption_key(dir)) {
>   		if (fname->no_copy)
>   			oname->name = fname->name;
>   		else
> @@ -234,7 +339,8 @@ int ceph_fname_to_usr(const struct ceph_fname *fname, struct fscrypt_str *tname,
>   		oname->len = fname->name_len;
>   		if (is_nokey)
>   			*is_nokey = true;
> -		return 0;
> +		ret = 0;
> +		goto out_inode;
>   	}
>   
>   	if (fname->ctext_len == 0) {
> @@ -243,11 +349,11 @@ int ceph_fname_to_usr(const struct ceph_fname *fname, struct fscrypt_str *tname,
>   		if (!tname) {
>   			ret = fscrypt_fname_alloc_buffer(NAME_MAX, &_tname);
>   			if (ret)
> -				return ret;
> +				goto out_inode;
>   			tname = &_tname;
>   		}
>   
> -		declen = fscrypt_base64url_decode(fname->name, fname->name_len, tname->name);
> +		declen = fscrypt_base64url_decode(name, name_len, tname->name);
>   		if (declen <= 0) {
>   			ret = -EIO;
>   			goto out;
> @@ -259,9 +365,21 @@ int ceph_fname_to_usr(const struct ceph_fname *fname, struct fscrypt_str *tname,
>   		iname.len = fname->ctext_len;
>   	}
>   
> -	ret = fscrypt_fname_disk_to_usr(fname->dir, 0, 0, &iname, oname);
> +	ret = fscrypt_fname_disk_to_usr(dir, 0, 0, &iname, oname);
> +	if (!ret && (dir != fname->dir)) {
> +		char tmp_buf[FSCRYPT_BASE64URL_CHARS(NAME_MAX)];
> +
> +		name_len = snprintf(tmp_buf, sizeof(tmp_buf), "_%.*s_%ld",
> +				    oname->len, oname->name, dir->i_ino);
> +		memcpy(oname->name, tmp_buf, name_len);
> +		oname->len = name_len;
> +	}
> +
>   out:
>   	fscrypt_fname_free_buffer(&_tname);
> +out_inode:
> +	if ((dir != fname->dir) && !IS_ERR(dir))
> +		iput(dir);
>   	return ret;
>   }
>   
> diff --git a/fs/ceph/crypto.h b/fs/ceph/crypto.h
> index 185fb4799a6d..e38a842e02a6 100644
> --- a/fs/ceph/crypto.h
> +++ b/fs/ceph/crypto.h
> @@ -76,13 +76,16 @@ static inline u32 ceph_fscrypt_auth_len(struct ceph_fscrypt_auth *fa)
>    * smaller size. If the ciphertext name is longer than the value below, then
>    * sha256 hash the remaining bytes.
>    *
> - * 189 bytes => 252 bytes base64-encoded, which is <= NAME_MAX (255)
> + * 180 bytes => 240 bytes base64-encoded, which is <= NAME_MAX (255)
> + *
> + * (Note: 240 bytes is the maximum size allowed for snapshot names to take into
> + *  account the format: '_<SNAPSHOT-NAME>_<INODE-NUMBER>')
>    *
>    * Note that for long names that end up having their tail portion hashed, we
>    * must also store the full encrypted name (in the dentry's alternate_name
>    * field).
>    */
> -#define CEPH_NOHASH_NAME_MAX (189 - SHA256_DIGEST_SIZE)
> +#define CEPH_NOHASH_NAME_MAX (180 - SHA256_DIGEST_SIZE)
>   
>   void ceph_fscrypt_set_ops(struct super_block *sb);
>   
> @@ -91,8 +94,8 @@ void ceph_fscrypt_free_dummy_policy(struct ceph_fs_client *fsc);
>   int ceph_fscrypt_prepare_context(struct inode *dir, struct inode *inode,
>   				 struct ceph_acl_sec_ctx *as);
>   void ceph_fscrypt_as_ctx_to_req(struct ceph_mds_request *req, struct ceph_acl_sec_ctx *as);
> -int ceph_encode_encrypted_dname(const struct inode *parent, struct qstr *d_name, char *buf);
> -int ceph_encode_encrypted_fname(const struct inode *parent, struct dentry *dentry, char *buf);
> +int ceph_encode_encrypted_dname(struct inode *parent, struct qstr *d_name, char *buf);
> +int ceph_encode_encrypted_fname(struct inode *parent, struct dentry *dentry, char *buf);
>   
>   static inline int ceph_fname_alloc_buffer(struct inode *parent, struct fscrypt_str *fname)
>   {
>

