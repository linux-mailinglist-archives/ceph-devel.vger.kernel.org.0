Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D9F364D1F60
	for <lists+ceph-devel@lfdr.de>; Tue,  8 Mar 2022 18:47:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349244AbiCHRsb (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 8 Mar 2022 12:48:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349246AbiCHRs3 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 8 Mar 2022 12:48:29 -0500
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FD7C238
        for <ceph-devel@vger.kernel.org>; Tue,  8 Mar 2022 09:47:32 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 079F4210F2;
        Tue,  8 Mar 2022 17:47:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1646761651; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=HcwDnkh3wCGETBy8KqkUaanNPJ11vRQnNqs9gEadlPU=;
        b=r64TtE1svUUb8ygKBG2lsnH3NtplR0x3Itus1sBzEXoPmew4McqMCsfvG+TCRyIy3ImYm1
        C+7X+HC7PlXwlD5OR+U0OwozVgdIA7Q1FO2hrLv9+smI9Y8ygnTAh2sf5bhOirhoUQSpCp
        kAq0f5HYS/Wz6/iPNmBt/RplhvqJNkA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1646761651;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=HcwDnkh3wCGETBy8KqkUaanNPJ11vRQnNqs9gEadlPU=;
        b=w1teVX8KFrod7ILGTQX5BRbnKJOdB0Vl05GZrS8/9HZcHaCU/IAinFlM18Ym2/9kelKrVi
        tYxTvJzMdrfuNtAg==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id A761F13CCE;
        Tue,  8 Mar 2022 17:47:30 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id 79e9JbKWJ2I/GAAAMHmgww
        (envelope-from <lhenriques@suse.de>); Tue, 08 Mar 2022 17:47:30 +0000
Received: from localhost (brahms.olymp [local])
        by brahms.olymp (OpenSMTPD) with ESMTPA id 19a92530;
        Tue, 8 Mar 2022 17:47:45 +0000 (UTC)
From:   =?utf-8?Q?Lu=C3=ADs_Henriques?= <lhenriques@suse.de>
To:     xiubli@redhat.com
Cc:     jlayton@kernel.org, idryomov@gmail.com, vshankar@redhat.com,
        ceph-devel@vger.kernel.org
Subject: Re: [PATCH v5] ceph: do not dencrypt the dentry name twice for readdir
References: <20220305122527.1102109-1-xiubli@redhat.com>
Date:   Tue, 08 Mar 2022 17:47:45 +0000
In-Reply-To: <20220305122527.1102109-1-xiubli@redhat.com> (xiubli@redhat.com's
        message of "Sat, 5 Mar 2022 20:25:27 +0800")
Message-ID: <87h788z67y.fsf@brahms.olymp>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

xiubli@redhat.com writes:

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
> V5:
> - fix typo of CEPH_ENCRYPTED_LONG_SNAP_NAME_MAX macro
> - release the rde->dentry in destroy_reply_info
>
>
>  fs/ceph/crypto.h     |  8 ++++++
>  fs/ceph/dir.c        | 59 +++++++++++++++++++++-----------------------
>  fs/ceph/inode.c      |  7 ++++++
>  fs/ceph/mds_client.c |  2 ++
>  fs/ceph/mds_client.h |  1 +
>  5 files changed, 46 insertions(+), 31 deletions(-)
>
> diff --git a/fs/ceph/crypto.h b/fs/ceph/crypto.h
> index 1e08f8a64ad6..c85cb8c8bd79 100644
> --- a/fs/ceph/crypto.h
> +++ b/fs/ceph/crypto.h
> @@ -83,6 +83,14 @@ static inline u32 ceph_fscrypt_auth_len(struct ceph_fs=
crypt_auth *fa)
>   */
>  #define CEPH_NOHASH_NAME_MAX (189 - SHA256_DIGEST_SIZE)
>=20=20
> +/*
> + * The encrypted long snap name will be in format of
> + * "_${ENCRYPTED-LONG-SNAP-NAME}_${INODE-NUM}". And will set the max lon=
gth
> + * to sizeof('_') + NAME_MAX + sizeof('_') + max of sizeof(${INO}) + ext=
ra 7
> + * bytes to align the total size to 8 bytes.
> + */
> +#define CEPH_ENCRYPTED_LONG_SNAP_NAME_MAX (1 + 255 + 1 + 16 + 7)
> +

I think this constant needs to be defined in a different way and we need
to keep the snapshots names length a bit shorter than NAME_MAX.  And I'm
not talking just about the encrypted snapshots.

Right now, ceph PR#45192 fixes an MDS limitation that is keeping long
snapshot names smaller than 80 characters.  With this limitation we would
need to keep the snapshot names < 64:

   '_' + <name> + '_' + '<inode#>' '\0'
    1  +   64   +  1  +    12     +  1 =3D 80

Note however that currently clients *do* allow to create snapshots with
bigger names.  And if we do that we'll get an error when doing an LSSNAP
on a .snap subdirectory that will contain the corresponding long name:

  # mkdir a/.snap/123456qwertasdfgzxcvb7890yuiophjklnm123456qwertasdfgzxcvb=
78912345
  # ls -li a/b/.snap
  ls: a/b/.snap/_123456qwertasdfgzxcvb7890yuiophjklnm123456qwertasdfgzxcvb7=
8912345_109951162777: No such file or directory

We can limit the snapshot names on creation, but this should probably be
handled on the MDS side (so that old clients won't break anything).  Does
this make sense?  I can work on an MDS patch for this but... to which
length should names be limited? NAME_MAX - (2*'_' + <inode len>)?  Or
should we take base64-encoded names already into account?

(Sorry, I'm jumping around between PRs and patches, and trying to make any
sense out of the snapshots code :-/ )

Cheers,
--=20
Lu=C3=ADs


>  void ceph_fscrypt_set_ops(struct super_block *sb);
>=20=20
>  void ceph_fscrypt_free_dummy_policy(struct ceph_fs_client *fsc);
> diff --git a/fs/ceph/dir.c b/fs/ceph/dir.c
> index 6df2a91af236..b30429e2d079 100644
> --- a/fs/ceph/dir.c
> +++ b/fs/ceph/dir.c
> @@ -316,8 +316,7 @@ static int ceph_readdir(struct file *file, struct dir=
_context *ctx)
>  	int err;
>  	unsigned frag =3D -1;
>  	struct ceph_mds_reply_info_parsed *rinfo;
> -	struct fscrypt_str tname =3D FSTR_INIT(NULL, 0);
> -	struct fscrypt_str oname =3D FSTR_INIT(NULL, 0);
> +	char *dentry_name =3D NULL;
>=20=20
>  	dout("readdir %p file %p pos %llx\n", inode, file, ctx->pos);
>  	if (dfi->file_info.flags & CEPH_F_ATEND)
> @@ -369,14 +368,6 @@ static int ceph_readdir(struct file *file, struct di=
r_context *ctx)
>  		spin_unlock(&ci->i_ceph_lock);
>  	}
>=20=20
> -	err =3D ceph_fname_alloc_buffer(inode, &tname);
> -	if (err < 0)
> -		goto out;
> -
> -	err =3D ceph_fname_alloc_buffer(inode, &oname);
> -	if (err < 0)
> -		goto out;
> -
>  	/* proceed with a normal readdir */
>  more:
>  	/* do we have the correct frag content buffered? */
> @@ -528,31 +519,39 @@ static int ceph_readdir(struct file *file, struct d=
ir_context *ctx)
>  			}
>  		}
>  	}
> +
> +	dentry_name =3D kmalloc(CEPH_ENCRYPTED_LONG_SNAP_NAME_MAX, GFP_KERNEL);
> +	if (!dentry_name) {
> +		err =3D -ENOMEM;
> +		ceph_mdsc_put_request(dfi->last_readdir);
> +		dfi->last_readdir =3D NULL;
> +		goto out;
> +	}
> +
>  	for (; i < rinfo->dir_nr; i++) {
>  		struct ceph_mds_reply_dir_entry *rde =3D rinfo->dir_entries + i;
> -		struct ceph_fname fname =3D { .dir	=3D inode,
> -					    .name	=3D rde->name,
> -					    .name_len	=3D rde->name_len,
> -					    .ctext	=3D rde->altname,
> -					    .ctext_len	=3D rde->altname_len };
> -		u32 olen =3D oname.len;
> -
> -		err =3D ceph_fname_to_usr(&fname, &tname, &oname, NULL);
> -		if (err) {
> -			pr_err("%s unable to decode %.*s, got %d\n", __func__,
> -			       rde->name_len, rde->name, err);
> -			goto out;
> -		}
> +		struct dentry *dn =3D rde->dentry;
> +		int name_len;
>=20=20
>  		BUG_ON(rde->offset < ctx->pos);
>  		BUG_ON(!rde->inode.in);
> +		BUG_ON(!rde->dentry);
>=20=20
>  		ctx->pos =3D rde->offset;
> -		dout("readdir (%d/%d) -> %llx '%.*s' %p\n",
> -		     i, rinfo->dir_nr, ctx->pos,
> -		     rde->name_len, rde->name, &rde->inode.in);
>=20=20
> -		if (!dir_emit(ctx, oname.name, oname.len,
> +		spin_lock(&dn->d_lock);
> +		memcpy(dentry_name, dn->d_name.name, dn->d_name.len);
> +		name_len =3D dn->d_name.len;
> +		spin_unlock(&dn->d_lock);
> +
> +		dentry_name[name_len] =3D '\0';
> +		dout("readdir (%d/%d) -> %llx '%s' %p\n",
> +		     i, rinfo->dir_nr, ctx->pos, dentry_name, &rde->inode.in);
> +
> +		dput(dn);
> +		rde->dentry =3D NULL;
> +
> +		if (!dir_emit(ctx, dentry_name, name_len,
>  			      ceph_present_ino(inode->i_sb, le64_to_cpu(rde->inode.in->ino)),
>  			      le32_to_cpu(rde->inode.in->mode) >> 12)) {
>  			/*
> @@ -566,8 +565,6 @@ static int ceph_readdir(struct file *file, struct dir=
_context *ctx)
>  			goto out;
>  		}
>=20=20
> -		/* Reset the lengths to their original allocated vals */
> -		oname.len =3D olen;
>  		ctx->pos++;
>  	}
>=20=20
> @@ -625,8 +622,8 @@ static int ceph_readdir(struct file *file, struct dir=
_context *ctx)
>  	err =3D 0;
>  	dout("readdir %p file %p done.\n", inode, file);
>  out:
> -	ceph_fname_free_buffer(inode, &tname);
> -	ceph_fname_free_buffer(inode, &oname);
> +	if (dentry_name)
> +		kfree(dentry_name);
>  	return err;
>  }
>=20=20
> diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
> index e5a9838981ba..dfb7b4461857 100644
> --- a/fs/ceph/inode.c
> +++ b/fs/ceph/inode.c
> @@ -1902,6 +1902,7 @@ int ceph_readdir_prepopulate(struct ceph_mds_reques=
t *req,
>  			goto out;
>  		}
>=20=20
> +		rde->dentry =3D NULL;
>  		dname.name =3D oname.name;
>  		dname.len =3D oname.len;
>  		dname.hash =3D full_name_hash(parent, dname.name, dname.len);
> @@ -1962,6 +1963,12 @@ int ceph_readdir_prepopulate(struct ceph_mds_reque=
st *req,
>  			goto retry_lookup;
>  		}
>=20=20
> +		/*
> +		 * ceph_readdir will use the dentry to get the name
> +		 * to avoid doing the dencrypt again there.
> +		 */
> +		rde->dentry =3D dget(dn);
> +
>  		/* inode */
>  		if (d_really_is_positive(dn)) {
>  			in =3D d_inode(dn);
> diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
> index f0d2442187a3..9de749dd715c 100644
> --- a/fs/ceph/mds_client.c
> +++ b/fs/ceph/mds_client.c
> @@ -733,6 +733,8 @@ static void destroy_reply_info(struct ceph_mds_reply_=
info_parsed *info)
>=20=20
>  		kfree(rde->inode.fscrypt_auth);
>  		kfree(rde->inode.fscrypt_file);
> +		dput(rde->dentry);
> +		rde->dentry =3D NULL;
>  	}
>  	free_pages((unsigned long)info->dir_entries, get_order(info->dir_buf_si=
ze));
>  }
> diff --git a/fs/ceph/mds_client.h b/fs/ceph/mds_client.h
> index 0dfe24f94567..663d7754d57d 100644
> --- a/fs/ceph/mds_client.h
> +++ b/fs/ceph/mds_client.h
> @@ -96,6 +96,7 @@ struct ceph_mds_reply_info_in {
>  };
>=20=20
>  struct ceph_mds_reply_dir_entry {
> +	struct dentry		      *dentry;
>  	char                          *name;
>  	u8			      *altname;
>  	u32                           name_len;
> --=20
>
> 2.27.0
>
