Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6CAE23E9341
	for <lists+ceph-devel@lfdr.de>; Wed, 11 Aug 2021 16:08:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232292AbhHKOJT (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 11 Aug 2021 10:09:19 -0400
Received: from smtp-out1.suse.de ([195.135.220.28]:54694 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232280AbhHKOJT (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 11 Aug 2021 10:09:19 -0400
Received: from imap1.suse-dmz.suse.de (imap1.suse-dmz.suse.de [192.168.254.73])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id D34AA221A2;
        Wed, 11 Aug 2021 14:08:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1628690934; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=130QXqQCXKd9FO27P9MIpNsKYJ3FakjNWgeGbkK9GpI=;
        b=aKE2grpk/bdSwf2kacAy9sGk0CguyiORV1qJo9NJ053RmEcNTXXbvLUZQLlmXC5QSL2O/Q
        6U3dCjdfNmG21qudwpVXjvOOZHO0WCszLuRB3oN090smfE08KZc/Z5Hs+jkeYff1Fwkmwk
        RdMjDcOAvGYxdI/MAet1BW98fbyAgcM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1628690934;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=130QXqQCXKd9FO27P9MIpNsKYJ3FakjNWgeGbkK9GpI=;
        b=ewVUWCa9IZX1+okTzVwPzZFuUz7ELQuJr11caT0QoY241fK7Brw004DFrnz477O6zVpX+I
        dNpuQ0/WFz/JS1DA==
Received: from imap1.suse-dmz.suse.de (imap1.suse-dmz.suse.de [192.168.254.73])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap1.suse-dmz.suse.de (Postfix) with ESMTPS id 6E7D413969;
        Wed, 11 Aug 2021 14:08:54 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap1.suse-dmz.suse.de with ESMTPSA
        id CQwHGPbZE2EdRwAAGKfGzw
        (envelope-from <lhenriques@suse.de>); Wed, 11 Aug 2021 14:08:54 +0000
Received: from localhost (brahms [local])
        by brahms (OpenSMTPD) with ESMTPA id 937be8c8;
        Wed, 11 Aug 2021 14:08:53 +0000 (UTC)
From:   Luis Henriques <lhenriques@suse.de>
To:     Jeff Layton <jlayton@kernel.org>
Cc:     ceph-devel@vger.kernel.org, idryomov@gmail.com, xiubli@redhat.com,
        Jozef =?utf-8?B?S292w6HEjQ==?= <kovac@firma.zoznam.sk>
Subject: Re: [PATCH] ceph: request Fw caps before updating the mtime in
 ceph_write_iter
References: <20210811112324.8870-1-jlayton@kernel.org>
Date:   Wed, 11 Aug 2021 15:08:53 +0100
In-Reply-To: <20210811112324.8870-1-jlayton@kernel.org> (Jeff Layton's message
        of "Wed, 11 Aug 2021 07:23:24 -0400")
Message-ID: <87sfzgqdje.fsf@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Jeff Layton <jlayton@kernel.org> writes:

> The current code will update the mtime and then try to get caps to
> handle the write. If we end up having to request caps from the MDS, then
> the mtime in the cap grant will clobber the updated mtime and it'll be
> lost.
>
> This is most noticable when two clients are alternately writing to the
> same file. Fw caps are continually being granted and revoked, and the
> mtime ends up stuck because the updated mtimes are always being
> overwritten with the old one.
>
> Fix this by changing the order of operations in ceph_write_iter. Get the
> caps much earlier, and only update the times afterward. Also, make sure
> we check the NEARFULL conditions before making any changes to the inode.
>
> URL: https://tracker.ceph.com/issues/46574
> Reported-by: Jozef Kov=C3=A1=C4=8D <kovac@firma.zoznam.sk>
> Signed-off-by: Jeff Layton <jlayton@kernel.org>
> ---
>  fs/ceph/file.c | 34 +++++++++++++++++-----------------
>  1 file changed, 17 insertions(+), 17 deletions(-)
>
> diff --git a/fs/ceph/file.c b/fs/ceph/file.c
> index f55ca2c4c7de..5867acfc6a51 100644
> --- a/fs/ceph/file.c
> +++ b/fs/ceph/file.c
> @@ -1722,22 +1722,6 @@ static ssize_t ceph_write_iter(struct kiocb *iocb,=
 struct iov_iter *from)
>  		goto out;
>  	}
>=20=20
> -	err =3D file_remove_privs(file);
> -	if (err)
> -		goto out;
> -
> -	err =3D file_update_time(file);
> -	if (err)
> -		goto out;
> -
> -	inode_inc_iversion_raw(inode);
> -
> -	if (ci->i_inline_version !=3D CEPH_INLINE_NONE) {
> -		err =3D ceph_uninline_data(file, NULL);
> -		if (err < 0)
> -			goto out;
> -	}
> -
>  	down_read(&osdc->lock);
>  	map_flags =3D osdc->osdmap->flags;
>  	pool_flags =3D ceph_pg_pool_flags(osdc->osdmap, ci->i_layout.pool_id);
> @@ -1748,6 +1732,12 @@ static ssize_t ceph_write_iter(struct kiocb *iocb,=
 struct iov_iter *from)
>  		goto out;
>  	}
>=20=20
> +	if (ci->i_inline_version !=3D CEPH_INLINE_NONE) {
> +		err =3D ceph_uninline_data(file, NULL);
> +		if (err < 0)
> +			goto out;
> +	}
> +
>  	dout("aio_write %p %llx.%llx %llu~%zd getting caps. i_size %llu\n",
>  	     inode, ceph_vinop(inode), pos, count, i_size_read(inode));
>  	if (fi->fmode & CEPH_FILE_MODE_LAZY)
> @@ -1759,6 +1749,16 @@ static ssize_t ceph_write_iter(struct kiocb *iocb,=
 struct iov_iter *from)
>  	if (err < 0)
>  		goto out;
>=20=20
> +	err =3D file_remove_privs(file);
> +	if (err)
> +		goto out_caps;
> +
> +	err =3D file_update_time(file);
> +	if (err)
> +		goto out_caps;

Unless I'm missing something (which happens quite frequently!) i_rwsem
still needs to be released through either ceph_end_io_write() or
ceph_end_io_direct().  And this isn't being done if we jump to out_caps
(yeah, goto's spaghetti fun).

Also, this patch is probably worth adding to stable@ too, although I
haven't checked how easy is it to cherry-pick to older kernel versions.

Cheers,
--=20
Luis

> +
> +	inode_inc_iversion_raw(inode);
> +
>  	dout("aio_write %p %llx.%llx %llu~%zd got cap refs on %s\n",
>  	     inode, ceph_vinop(inode), pos, count, ceph_cap_string(got));
>=20=20
> @@ -1822,7 +1822,7 @@ static ssize_t ceph_write_iter(struct kiocb *iocb, =
struct iov_iter *from)
>  		if (ceph_quota_is_max_bytes_approaching(inode, iocb->ki_pos))
>  			ceph_check_caps(ci, 0, NULL);
>  	}
> -
> +out_caps:
>  	dout("aio_write %p %llx.%llx %llu~%u  dropping cap refs on %s\n",
>  	     inode, ceph_vinop(inode), pos, (unsigned)count,
>  	     ceph_cap_string(got));
> --=20
>
> 2.31.1
>
