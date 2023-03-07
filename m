Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0452E6AF3B8
	for <lists+ceph-devel@lfdr.de>; Tue,  7 Mar 2023 20:08:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233715AbjCGTId (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 7 Mar 2023 14:08:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233562AbjCGTID (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 7 Mar 2023 14:08:03 -0500
Received: from smtp-out2.suse.de (smtp-out2.suse.de [IPv6:2001:67c:2178:6::1d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C261FC168
        for <ceph-devel@vger.kernel.org>; Tue,  7 Mar 2023 10:53:10 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 582D61FD6B;
        Tue,  7 Mar 2023 18:53:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1678215186; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Q6mhFhgHQ2SJbVfsaKBDON40GLdbUzFm+uLfOf5KPuk=;
        b=Gw9NvDZeJ8Pqje/357MdKLGSwIerTFD4vRqQJZxJMYzDttrX04a92uM9PlgRCRol1TkhkO
        d3CpcWgVcYK0UViROJkSmDTqUvjPj9vqHUaUX82o9kdnGiiHoammrUlNbdeTSh1+8WKN57
        gtJOZkAo1ORhvnZn/qXVHLBDt7fh0NI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1678215186;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Q6mhFhgHQ2SJbVfsaKBDON40GLdbUzFm+uLfOf5KPuk=;
        b=VdQbOq5ggNnU/vziqxt2XACZF3GiMGgGFqcZ5G6xS8/eGLO0GhXqAufUtDVEYaJ43cHz/w
        0MeZW4POoiHN6TAQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id E8B9213440;
        Tue,  7 Mar 2023 18:53:05 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id StiwNRGIB2S3GQAAMHmgww
        (envelope-from <lhenriques@suse.de>); Tue, 07 Mar 2023 18:53:05 +0000
Received: from localhost (brahms.olymp [local])
        by brahms.olymp (OpenSMTPD) with ESMTPA id b166b2dd;
        Tue, 7 Mar 2023 18:53:05 +0000 (UTC)
From:   =?utf-8?Q?Lu=C3=ADs_Henriques?= <lhenriques@suse.de>
To:     xiubli@redhat.com
Cc:     idryomov@gmail.com, ceph-devel@vger.kernel.org, jlayton@kernel.org,
        vshankar@redhat.com, mchangir@redhat.com
Subject: Re: [PATCH v16 25/68] ceph: make d_revalidate call fscrypt
 revalidator for encrypted dentries
References: <20230227032813.337906-1-xiubli@redhat.com>
        <20230227032813.337906-26-xiubli@redhat.com>
Date:   Tue, 07 Mar 2023 18:53:05 +0000
In-Reply-To: <20230227032813.337906-26-xiubli@redhat.com> (xiubli@redhat.com's
        message of "Mon, 27 Feb 2023 11:27:30 +0800")
Message-ID: <87o7p48kby.fsf@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

xiubli@redhat.com writes:

> From: Jeff Layton <jlayton@kernel.org>
>
> If we have a dentry which represents a no-key name, then we need to test
> whether the parent directory's encryption key has since been added.  Do
> that before we test anything else about the dentry.
>
> Reviewed-by: Xiubo Li <xiubli@redhat.com>
> Signed-off-by: Jeff Layton <jlayton@kernel.org>
> ---
>  fs/ceph/dir.c | 8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)
>
> diff --git a/fs/ceph/dir.c b/fs/ceph/dir.c
> index d3c2853bb0f1..5ead9f59e693 100644
> --- a/fs/ceph/dir.c
> +++ b/fs/ceph/dir.c
> @@ -1770,6 +1770,10 @@ static int ceph_d_revalidate(struct dentry *dentry=
, unsigned int flags)
>  	struct inode *dir, *inode;
>  	struct ceph_mds_client *mdsc;
>=20=20
> +	valid =3D fscrypt_d_revalidate(dentry, flags);
> +	if (valid <=3D 0)
> +		return valid;
> +

This patch has confused me in the past, and today I found myself
scratching my head again looking at it.

So, I've started seeing generic/123 test failing when running it with
test_dummy_encryption.  I was almost sure that this test used to run fine
before, but I couldn't find any evidence (somehow I lost my old testing
logs...).

Anyway, the test is quite simple:

1. Creates a directory with write permissions for root only
2. Writes into a file in that directory
3. Uses 'su' to try to modify that file as a different user, and
   gets -EPERM

All these steps run fine, and the test should pass.  *However*, in the
test cleanup function, a simple 'rm -rf <dir>' will fail with -ENOTEMPTY.
'strace' shows that calling unlinkat() to remove the file got a '-ENOENT'
and then -ENOTEMPTY for the directory.

Some digging allowed me to figure out that running commands with 'su' will
drop caches (I see 'su (874): drop_caches: 2' in the log).  And this is
how I ended up looking at this patch.  fscrypt_d_revalidate() will return
'0' if the parent directory does has a key (fscrypt_has_encryption_key()).
Can we really say here that the dentry is *not* valid in that case?  Or
should that '<=3D 0' be a '< 0'?

(But again, this patch has confused me before...)

Cheers,
--=20
Lu=C3=ADs


>=20
>  	if (flags & LOOKUP_RCU) {
>  		parent =3D READ_ONCE(dentry->d_parent);
>  		dir =3D d_inode_rcu(parent);
> @@ -1782,8 +1786,8 @@ static int ceph_d_revalidate(struct dentry *dentry,=
 unsigned int flags)
>  		inode =3D d_inode(dentry);
>  	}
>=20=20
> -	dout("d_revalidate %p '%pd' inode %p offset 0x%llx\n", dentry,
> -	     dentry, inode, ceph_dentry(dentry)->offset);
> +	dout("d_revalidate %p '%pd' inode %p offset 0x%llx nokey %d\n", dentry,
> +	     dentry, inode, ceph_dentry(dentry)->offset, !!(dentry->d_flags & D=
CACHE_NOKEY_NAME));
>=20=20
>  	mdsc =3D ceph_sb_to_client(dir->i_sb)->mdsc;
>=20=20
> --=20
>
> 2.31.1
>
