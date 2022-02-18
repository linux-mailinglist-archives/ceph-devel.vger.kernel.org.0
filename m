Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8861C4BBF11
	for <lists+ceph-devel@lfdr.de>; Fri, 18 Feb 2022 19:11:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238798AbiBRSL4 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 18 Feb 2022 13:11:56 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:60310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236218AbiBRSLz (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Fri, 18 Feb 2022 13:11:55 -0500
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E25B56472
        for <ceph-devel@vger.kernel.org>; Fri, 18 Feb 2022 10:11:35 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 9BDF4210E6;
        Fri, 18 Feb 2022 18:11:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1645207894; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=mC4YuF2A18TScPlqP/pH87/rzZ0mySXjxcisebyPFY4=;
        b=zAFYdVFmDkjwPyE4I8FdHX1E5xDOsJroDlQZFVgfStuM0FO4zvS1Il84SFlOLjz1v3v57y
        DOCvCuWbZflCswUIgbYHPmcKmEFOtF1qQu9iixDvL6S/fhIY1ISRCfqZzcbkcEtzQKTapX
        uNjznMUeS6bAU1K9+68aPwCQXXRkpIY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1645207894;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=mC4YuF2A18TScPlqP/pH87/rzZ0mySXjxcisebyPFY4=;
        b=eLPCC8C2AIvM2zn7hQre0XskY2lk9ZMycsfZPTOwBn+EscjeZyfh3C/hP1uqlJ1GFWLNaY
        DVOkfHBkgaiNSbCg==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 46B5713CC6;
        Fri, 18 Feb 2022 18:11:34 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id kIcyDlbhD2K7awAAMHmgww
        (envelope-from <lhenriques@suse.de>); Fri, 18 Feb 2022 18:11:34 +0000
Received: from localhost (brahms.olymp [local])
        by brahms.olymp (OpenSMTPD) with ESMTPA id 109dadf6;
        Fri, 18 Feb 2022 18:11:47 +0000 (UTC)
From:   =?utf-8?Q?Lu=C3=ADs_Henriques?= <lhenriques@suse.de>
To:     xiubli@redhat.com
Cc:     jlayton@kernel.org, idryomov@gmail.com, vshankar@redhat.com,
        ceph-devel@vger.kernel.org
Subject: Re: [PATCH 1/3] ceph: move to a dedicated slabcache for ceph_cap_snap
References: <20220215122316.7625-1-xiubli@redhat.com>
        <20220215122316.7625-2-xiubli@redhat.com>
Date:   Fri, 18 Feb 2022 18:11:47 +0000
In-Reply-To: <20220215122316.7625-2-xiubli@redhat.com> (xiubli@redhat.com's
        message of "Tue, 15 Feb 2022 20:23:14 +0800")
Message-ID: <8735kghwnw.fsf@brahms.olymp>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
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
> There could be huge number of capsnap queued in a short time, on
> x86_64 it's 248 bytes, which will be rounded up to 256 bytes by
> kzalloc. Move this to a dedicated slabcache to save 8 bytes for
> each.
>
> For the kmalloc-256 slab cache, the actual size will be 512 bytes:
> kmalloc-256        21797  74656    512   32    4 : tunables, etc
>
> For a dedicated slab cache the real size is 312 bytes:
> ceph_cap_snap          0      0    312   52    4 : tunables, etc
>
> So actually we can save 200 bytes for each.
>
> Signed-off-by: Xiubo Li <xiubli@redhat.com>
> ---
>  fs/ceph/snap.c               | 5 +++--
>  fs/ceph/super.c              | 7 +++++++
>  fs/ceph/super.h              | 2 +-
>  include/linux/ceph/libceph.h | 1 +
>  4 files changed, 12 insertions(+), 3 deletions(-)
>
> diff --git a/fs/ceph/snap.c b/fs/ceph/snap.c
> index b41e6724c591..c787775eaf2a 100644
> --- a/fs/ceph/snap.c
> +++ b/fs/ceph/snap.c
> @@ -482,7 +482,7 @@ static void ceph_queue_cap_snap(struct ceph_inode_inf=
o *ci)
>  	struct ceph_buffer *old_blob =3D NULL;
>  	int used, dirty;
>=20=20
> -	capsnap =3D kzalloc(sizeof(*capsnap), GFP_NOFS);
> +	capsnap =3D kmem_cache_alloc(ceph_cap_snap_cachep, GFP_NOFS);

Unfortunately, this is causing issues in my testing.  Looks like there are
several fields that are assumed to be initialised to zero.  I've seen two
BUGs so far, in functions ceph_try_drop_cap_snap (capsnap->cap_flush.tid > =
0)
and __ceph_finish_cap_snap (capsnap->writing).

I guess you'll have to either zero out all that memory, or manually
initialise the fields (not sure which ones really require that).

Cheers,
--=20
Lu=C3=ADs

>  	if (!capsnap) {
>  		pr_err("ENOMEM allocating ceph_cap_snap on %p\n", inode);
>  		return;
> @@ -603,7 +603,8 @@ static void ceph_queue_cap_snap(struct ceph_inode_inf=
o *ci)
>  	spin_unlock(&ci->i_ceph_lock);
>=20=20
>  	ceph_buffer_put(old_blob);
> -	kfree(capsnap);
> +	if (capsnap)
> +		kmem_cache_free(ceph_cap_snap_cachep, capsnap);
>  	ceph_put_snap_context(old_snapc);
>  }
>=20=20
> diff --git a/fs/ceph/super.c b/fs/ceph/super.c
> index bf79f369aec6..978463fa822c 100644
> --- a/fs/ceph/super.c
> +++ b/fs/ceph/super.c
> @@ -864,6 +864,7 @@ static void destroy_fs_client(struct ceph_fs_client *=
fsc)
>   */
>  struct kmem_cache *ceph_inode_cachep;
>  struct kmem_cache *ceph_cap_cachep;
> +struct kmem_cache *ceph_cap_snap_cachep;
>  struct kmem_cache *ceph_cap_flush_cachep;
>  struct kmem_cache *ceph_dentry_cachep;
>  struct kmem_cache *ceph_file_cachep;
> @@ -892,6 +893,9 @@ static int __init init_caches(void)
>  	ceph_cap_cachep =3D KMEM_CACHE(ceph_cap, SLAB_MEM_SPREAD);
>  	if (!ceph_cap_cachep)
>  		goto bad_cap;
> +	ceph_cap_snap_cachep =3D KMEM_CACHE(ceph_cap_snap, SLAB_MEM_SPREAD);
> +	if (!ceph_cap_snap_cachep)
> +		goto bad_cap_snap;
>  	ceph_cap_flush_cachep =3D KMEM_CACHE(ceph_cap_flush,
>  					   SLAB_RECLAIM_ACCOUNT|SLAB_MEM_SPREAD);
>  	if (!ceph_cap_flush_cachep)
> @@ -931,6 +935,8 @@ static int __init init_caches(void)
>  bad_dentry:
>  	kmem_cache_destroy(ceph_cap_flush_cachep);
>  bad_cap_flush:
> +	kmem_cache_destroy(ceph_cap_snap_cachep);
> +bad_cap_snap:
>  	kmem_cache_destroy(ceph_cap_cachep);
>  bad_cap:
>  	kmem_cache_destroy(ceph_inode_cachep);
> @@ -947,6 +953,7 @@ static void destroy_caches(void)
>=20=20
>  	kmem_cache_destroy(ceph_inode_cachep);
>  	kmem_cache_destroy(ceph_cap_cachep);
> +	kmem_cache_destroy(ceph_cap_snap_cachep);
>  	kmem_cache_destroy(ceph_cap_flush_cachep);
>  	kmem_cache_destroy(ceph_dentry_cachep);
>  	kmem_cache_destroy(ceph_file_cachep);
> diff --git a/fs/ceph/super.h b/fs/ceph/super.h
> index c0718d5a8fb8..2d08104c8955 100644
> --- a/fs/ceph/super.h
> +++ b/fs/ceph/super.h
> @@ -231,7 +231,7 @@ static inline void ceph_put_cap_snap(struct ceph_cap_=
snap *capsnap)
>  	if (refcount_dec_and_test(&capsnap->nref)) {
>  		if (capsnap->xattr_blob)
>  			ceph_buffer_put(capsnap->xattr_blob);
> -		kfree(capsnap);
> +		kmem_cache_free(ceph_cap_snap_cachep, capsnap);
>  	}
>  }
>=20=20
> diff --git a/include/linux/ceph/libceph.h b/include/linux/ceph/libceph.h
> index edf62eaa6285..00af2c98da75 100644
> --- a/include/linux/ceph/libceph.h
> +++ b/include/linux/ceph/libceph.h
> @@ -284,6 +284,7 @@ DEFINE_RB_LOOKUP_FUNC(name, type, keyfld, nodefld)
>=20=20
>  extern struct kmem_cache *ceph_inode_cachep;
>  extern struct kmem_cache *ceph_cap_cachep;
> +extern struct kmem_cache *ceph_cap_snap_cachep;
>  extern struct kmem_cache *ceph_cap_flush_cachep;
>  extern struct kmem_cache *ceph_dentry_cachep;
>  extern struct kmem_cache *ceph_file_cachep;
> --=20
>
> 2.27.0
>

