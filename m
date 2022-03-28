Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CCB744E9BEE
	for <lists+ceph-devel@lfdr.de>; Mon, 28 Mar 2022 18:09:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241279AbiC1QKb (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 28 Mar 2022 12:10:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236931AbiC1QKa (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 28 Mar 2022 12:10:30 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B678A1F60C
        for <ceph-devel@vger.kernel.org>; Mon, 28 Mar 2022 09:08:48 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 5241C210E5;
        Mon, 28 Mar 2022 16:08:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1648483727; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=JLXXm9cf0vDhAOvngixxvs4jbQgiH1uTnctfmwUFfbc=;
        b=zIo88A1CG4Z5OCaUYTHyU82Q9On/lJu48o5UZLmjb10fwTF9mSCifs32utce0JTCp5W96X
        KXRkm9IVr9zPaKEgKjetkn9Z1I4BTAi6p6uqSzfDZy4jkuyCnWy4/c5BGd53ZHVKLDFXRa
        184nypIkVo4j1HkSQd66nLf7wdxifno=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1648483727;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=JLXXm9cf0vDhAOvngixxvs4jbQgiH1uTnctfmwUFfbc=;
        b=cOZwK1b5MDOdrM9sywNsFB+KN1wHavUF8bYTYyW7CZTtLR4/HKVtzPrsOYbDeLZws30pwO
        vO+AJs7I3Bk5hpBA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 0879413B08;
        Mon, 28 Mar 2022 16:08:46 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id qoHgOo7dQWLYXgAAMHmgww
        (envelope-from <lhenriques@suse.de>); Mon, 28 Mar 2022 16:08:46 +0000
Received: from localhost (brahms.olymp [local])
        by brahms.olymp (OpenSMTPD) with ESMTPA id 45700d67;
        Mon, 28 Mar 2022 16:09:08 +0000 (UTC)
From:   =?utf-8?Q?Lu=C3=ADs_Henriques?= <lhenriques@suse.de>
To:     Jeff Layton <jlayton@kernel.org>
Cc:     ceph-devel@vger.kernel.org, idryomov@gmail.com, xiubli@redhat.com
Subject: Re: [PATCH] ceph: shrink dcache when adding a key
References: <20220328133257.28422-1-jlayton@kernel.org>
Date:   Mon, 28 Mar 2022 17:09:08 +0100
In-Reply-To: <20220328133257.28422-1-jlayton@kernel.org> (Jeff Layton's
        message of "Mon, 28 Mar 2022 09:32:57 -0400")
Message-ID: <87r16mqct7.fsf@brahms.olymp>
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

> Any extant dentries under a directory will be invalid once a key is
> added to the directory. Prune any child dentries of the parent after
> adding a key.
>
> Cc: Lu=C3=ADs Henriques <lhenriques@suse.de>
> Signed-off-by: Jeff Layton <jlayton@kernel.org>
> ---
>  fs/ceph/ioctl.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
>
> This one is for the ceph+fscrypt series.
>
> Luis, this seems to fix 580 and 593 for me. 595 still fails with it, but
> that one is more related to file contents.
>
> diff --git a/fs/ceph/ioctl.c b/fs/ceph/ioctl.c
> index 9675ef3a6c47..12d5469c5df2 100644
> --- a/fs/ceph/ioctl.c
> +++ b/fs/ceph/ioctl.c
> @@ -397,7 +397,10 @@ long ceph_ioctl(struct file *file, unsigned int cmd,=
 unsigned long arg)
>  		ret =3D vet_mds_for_fscrypt(file);
>  		if (ret)
>  			return ret;
> -		return fscrypt_ioctl_add_key(file, (void __user *)arg);
> +		ret =3D fscrypt_ioctl_add_key(file, (void __user *)arg);
> +		if (ret =3D=3D 0)
> +			shrink_dcache_parent(file_dentry(file));
> +		return ret;

OK, a problem with this is that we're using the big hammer: this ioctl is
being executed on the filesystem root and not the directory you're
expecting.  This is because keys can used for more than one directory.
So, the performance penalty with this fix is probably not acceptable.

Cheers,
--=20
Lu=C3=ADs

>=20=20
>  	case FS_IOC_REMOVE_ENCRYPTION_KEY:
>  		return fscrypt_ioctl_remove_key(file, (void __user *)arg);
> --=20
>
> 2.35.1
>

