Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F7C954040E
	for <lists+ceph-devel@lfdr.de>; Tue,  7 Jun 2022 18:47:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345169AbiFGQrW (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 7 Jun 2022 12:47:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345174AbiFGQrU (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 7 Jun 2022 12:47:20 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C71CF1F607
        for <ceph-devel@vger.kernel.org>; Tue,  7 Jun 2022 09:47:19 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 7B6F51F989;
        Tue,  7 Jun 2022 16:47:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1654620438; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=VitC4kryWKIQMDPXU/TRbHIEi98l6tvpvFElrpZpj04=;
        b=z7AUjAxqp943YaC9nIaBvnG2Bk8RIxxgIiQYLC8UDyhp8dHxD6/s3QUIWWAEoPykqb3aR5
        0UQdZmNvQTKlDYxrnxa9mmC+2E2To1aq02yZWAApogCHJC7qBOnkNgYY1h729H85OvUb1f
        1DCV/PdlivGdHdmTl696uSkOjwvt1Jc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1654620438;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=VitC4kryWKIQMDPXU/TRbHIEi98l6tvpvFElrpZpj04=;
        b=CVzoPhTsvkun55sEpsYDW1iEnhD2yMYYaM3lKwotiUzf5T+oHzaHyIQO/7uTlLObgHF4ZM
        kf7SrISiZ7JtrWCQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 12B7713638;
        Tue,  7 Jun 2022 16:47:18 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id vq54ARaBn2KRAgAAMHmgww
        (envelope-from <lhenriques@suse.de>); Tue, 07 Jun 2022 16:47:18 +0000
Received: from localhost (brahms.olymp [local])
        by brahms.olymp (OpenSMTPD) with ESMTPA id d849c1da;
        Tue, 7 Jun 2022 16:47:59 +0000 (UTC)
From:   =?utf-8?Q?Lu=C3=ADs_Henriques?= <lhenriques@suse.de>
To:     Jeff Layton <jlayton@kernel.org>
Cc:     xiubli@redhat.com, idryomov@gmail.com, ceph-devel@vger.kernel.org
Subject: Re: [PATCH] ceph: convert to generic_file_llseek
References: <20220607150549.217390-1-jlayton@kernel.org>
Date:   Tue, 07 Jun 2022 17:47:59 +0100
In-Reply-To: <20220607150549.217390-1-jlayton@kernel.org> (Jeff Layton's
        message of "Tue, 7 Jun 2022 11:05:49 -0400")
Message-ID: <87o7z48log.fsf@brahms.olymp>
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

Jeff Layton <jlayton@kernel.org> writes:

> There's no reason we need to lock the inode for write in order to handle
> an llseek. I suspect this should have been dropped in 2013 when we
> stopped doing vmtruncate in llseek.
>
> With that gone, ceph_llseek is functionally equivalent to
> generic_file_llseek, so just call that after getting the size.
>
> Signed-off-by: Jeff Layton <jlayton@kernel.org>
> ---
>  fs/ceph/file.c | 52 +++++---------------------------------------------
>  1 file changed, 5 insertions(+), 47 deletions(-)
>

Nice!  I started reviewing your previous patch, and while checking other
filesystems I wondered if the generic_* could be used instead.  And here
it is.  And it may even fix races in the SEEK_CUR by locking f_lock.

Reviewed-by: Lu=C3=ADs Henriques <lhenriques@suse.de>

Cheers,
--=20
Lu=C3=ADs

> diff --git a/fs/ceph/file.c b/fs/ceph/file.c
> index 0c13a3f23c99..0e82a1c383ca 100644
> --- a/fs/ceph/file.c
> +++ b/fs/ceph/file.c
> @@ -1989,57 +1989,15 @@ static ssize_t ceph_write_iter(struct kiocb *iocb=
, struct iov_iter *from)
>   */
>  static loff_t ceph_llseek(struct file *file, loff_t offset, int whence)
>  {
> -	struct inode *inode =3D file->f_mapping->host;
> -	struct ceph_fs_client *fsc =3D ceph_inode_to_client(inode);
> -	loff_t i_size;
> -	loff_t ret;
> -
> -	inode_lock(inode);
> -
>  	if (whence =3D=3D SEEK_END || whence =3D=3D SEEK_DATA || whence =3D=3D =
SEEK_HOLE) {
> +		struct inode *inode =3D file_inode(file);
> +		int ret;
> +
>  		ret =3D ceph_do_getattr(inode, CEPH_STAT_CAP_SIZE, false);
>  		if (ret < 0)
> -			goto out;
> -	}
> -
> -	i_size =3D i_size_read(inode);
> -	switch (whence) {
> -	case SEEK_END:
> -		offset +=3D i_size;
> -		break;
> -	case SEEK_CUR:
> -		/*
> -		 * Here we special-case the lseek(fd, 0, SEEK_CUR)
> -		 * position-querying operation.  Avoid rewriting the "same"
> -		 * f_pos value back to the file because a concurrent read(),
> -		 * write() or lseek() might have altered it
> -		 */
> -		if (offset =3D=3D 0) {
> -			ret =3D file->f_pos;
> -			goto out;
> -		}
> -		offset +=3D file->f_pos;
> -		break;
> -	case SEEK_DATA:
> -		if (offset < 0 || offset >=3D i_size) {
> -			ret =3D -ENXIO;
> -			goto out;
> -		}
> -		break;
> -	case SEEK_HOLE:
> -		if (offset < 0 || offset >=3D i_size) {
> -			ret =3D -ENXIO;
> -			goto out;
> -		}
> -		offset =3D i_size;
> -		break;
> +			return ret;
>  	}
> -
> -	ret =3D vfs_setpos(file, offset, max(i_size, fsc->max_file_size));
> -
> -out:
> -	inode_unlock(inode);
> -	return ret;
> +	return generic_file_llseek(file, offset, whence);
>  }
>=20=20
>  static inline void ceph_zero_partial_page(
> --=20
>
> 2.36.1
>

