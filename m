Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D21B4BE5BF
	for <lists+ceph-devel@lfdr.de>; Mon, 21 Feb 2022 19:01:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380813AbiBUQnS (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 21 Feb 2022 11:43:18 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:57412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229579AbiBUQnP (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 21 Feb 2022 11:43:15 -0500
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7B5F21E1B
        for <ceph-devel@vger.kernel.org>; Mon, 21 Feb 2022 08:42:51 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 840D521112;
        Mon, 21 Feb 2022 16:42:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1645461770; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=mz20JFY/PaeaZRbG0BUsKX+ESifAPyn11BVtgTHiDx0=;
        b=cubkmbzgWxmonnwogFZjg+9QCpe+N2DMeTsHBP9R7cwqv+5cRQoCvvPVShYT1IGbhDX108
        ZGM5ubwFjYUkE1fj7QdulAJSblOamY8hGBydFd3GlMFFsnP7tOJ5IdSK6tsntJpngdsMEx
        bm2XN1e6lsKgtZfD2u+itr1qcFnDOuw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1645461770;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=mz20JFY/PaeaZRbG0BUsKX+ESifAPyn11BVtgTHiDx0=;
        b=T6nefxOM/a3zkW6latrlI1IPMEPhZGqIKO23IsHpKAkd5zklH/OtHyFA/6b0HyIoQQAAa5
        8XOjCNiDoDodmADQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 2A5F313B5E;
        Mon, 21 Feb 2022 16:42:50 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id L2xhBgrBE2JmbgAAMHmgww
        (envelope-from <lhenriques@suse.de>); Mon, 21 Feb 2022 16:42:50 +0000
Received: from localhost (brahms.olymp [local])
        by brahms.olymp (OpenSMTPD) with ESMTPA id 16ebbed5;
        Mon, 21 Feb 2022 16:43:04 +0000 (UTC)
From:   =?utf-8?Q?Lu=C3=ADs_Henriques?= <lhenriques@suse.de>
To:     xiubli@redhat.com
Cc:     jlayton@kernel.org, idryomov@gmail.com, vshankar@redhat.com,
        ceph-devel@vger.kernel.org
Subject: Re: [PATCH v3] ceph: do not update snapshot context when there is
 no new snapshot
References: <20220219062833.30192-1-xiubli@redhat.com>
Date:   Mon, 21 Feb 2022 16:43:04 +0000
In-Reply-To: <20220219062833.30192-1-xiubli@redhat.com> (xiubli@redhat.com's
        message of "Sat, 19 Feb 2022 14:28:33 +0800")
Message-ID: <87y224xjaf.fsf@brahms.olymp>
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
> We will only track the uppest parent snapshot realm from which we
> need to rebuild the snapshot contexts _downward_ in hierarchy. For
> all the others having no new snapshot we will do nothing.
>
> This fix will avoid calling ceph_queue_cap_snap() on some inodes
> inappropriately. For example, with the code in mainline, suppose there
> are 2 directory hierarchies (with 6 directories total), like this:
>
> /dir_X1/dir_X2/dir_X3/
> /dir_Y1/dir_Y2/dir_Y3/
>
> Firstly, make a snapshot under /dir_X1/dir_X2/.snap/snap_X2, then make a
> root snapshot under /.snap/root_snap. Every time we make snapshots under
> /dir_Y1/..., the kclient will always try to rebuild the snap context for
> snap_X2 realm and finally will always try to queue cap snaps for dir_Y2
> and dir_Y3, which makes no sense.
>
> That's because the snap_X2's seq is 2 and root_snap's seq is 3. So when
> creating a new snapshot under /dir_Y1/... the new seq will be 4, and
> the mds will send the kclient a snapshot backtrace in _downward_
> order: seqs 4, 3.
>
> When ceph_update_snap_trace() is called, it will always rebuild the from
> the last realm, that's the root_snap. So later when rebuilding the snap
> context, the current logic will always cause it to rebuild the snap_X2
> realm and then try to queue cap snaps for all the inodes related in that
> realm, even though it's not necessary.
>
> This is accompanied by a lot of these sorts of dout messages:
>
>     "ceph:  queue_cap_snap 00000000a42b796b nothing dirty|writing"
>
> Fix the logic to avoid this situation.
>
> Also, the 'invalidate' word is not precise here. In actuality, it will
> cause a rebuild of the existing snapshot contexts or just build
> non-existant ones. Rename it to 'rebuild_snapcs'.
>
> URL: https://tracker.ceph.com/issues/44100
> Signed-off-by: Xiubo Li <xiubli@redhat.com>
> Signed-off-by: Jeff Layton <jlayton@kernel.org>
> ---
>
>
>
> V3:
> - Fixed the crash issue reproduced by Lu=C3=ADs.

Thanks, I can confirm I'm no longer seeing this issue.

Cheers,
--=20
Lu=C3=ADs

>
>
>
>
>  fs/ceph/snap.c | 28 +++++++++++++++++++---------
>  1 file changed, 19 insertions(+), 9 deletions(-)
>
> diff --git a/fs/ceph/snap.c b/fs/ceph/snap.c
> index 32e246138793..25a29304b74d 100644
> --- a/fs/ceph/snap.c
> +++ b/fs/ceph/snap.c
> @@ -736,7 +736,8 @@ int ceph_update_snap_trace(struct ceph_mds_client *md=
sc,
>  	__le64 *prior_parent_snaps;        /* encoded */
>  	struct ceph_snap_realm *realm =3D NULL;
>  	struct ceph_snap_realm *first_realm =3D NULL;
> -	int invalidate =3D 0;
> +	struct ceph_snap_realm *realm_to_rebuild =3D NULL;
> +	int rebuild_snapcs;
>  	int err =3D -ENOMEM;
>  	LIST_HEAD(dirty_realms);
>=20=20
> @@ -744,6 +745,7 @@ int ceph_update_snap_trace(struct ceph_mds_client *md=
sc,
>=20=20
>  	dout("update_snap_trace deletion=3D%d\n", deletion);
>  more:
> +	rebuild_snapcs =3D 0;
>  	ceph_decode_need(&p, e, sizeof(*ri), bad);
>  	ri =3D p;
>  	p +=3D sizeof(*ri);
> @@ -767,7 +769,7 @@ int ceph_update_snap_trace(struct ceph_mds_client *md=
sc,
>  	err =3D adjust_snap_realm_parent(mdsc, realm, le64_to_cpu(ri->parent));
>  	if (err < 0)
>  		goto fail;
> -	invalidate +=3D err;
> +	rebuild_snapcs +=3D err;
>=20=20
>  	if (le64_to_cpu(ri->seq) > realm->seq) {
>  		dout("update_snap_trace updating %llx %p %lld -> %lld\n",
> @@ -792,22 +794,30 @@ int ceph_update_snap_trace(struct ceph_mds_client *=
mdsc,
>  		if (realm->seq > mdsc->last_snap_seq)
>  			mdsc->last_snap_seq =3D realm->seq;
>=20=20
> -		invalidate =3D 1;
> +		rebuild_snapcs =3D 1;
>  	} else if (!realm->cached_context) {
>  		dout("update_snap_trace %llx %p seq %lld new\n",
>  		     realm->ino, realm, realm->seq);
> -		invalidate =3D 1;
> +		rebuild_snapcs =3D 1;
>  	} else {
>  		dout("update_snap_trace %llx %p seq %lld unchanged\n",
>  		     realm->ino, realm, realm->seq);
>  	}
>=20=20
> -	dout("done with %llx %p, invalidated=3D%d, %p %p\n", realm->ino,
> -	     realm, invalidate, p, e);
> +	dout("done with %llx %p, rebuild_snapcs=3D%d, %p %p\n", realm->ino,
> +	     realm, rebuild_snapcs, p, e);
>=20=20
> -	/* invalidate when we reach the _end_ (root) of the trace */
> -	if (invalidate && p >=3D e)
> -		rebuild_snap_realms(realm, &dirty_realms);
> +	/*
> +	 * this will always track the uppest parent realm from which
> +	 * we need to rebuild the snapshot contexts _downward_ in
> +	 * hierarchy.
> +	 */
> +	if (rebuild_snapcs)
> +		realm_to_rebuild =3D realm;
> +
> +	/* rebuild_snapcs when we reach the _end_ (root) of the trace */
> +	if (realm_to_rebuild && p >=3D e)
> +		rebuild_snap_realms(realm_to_rebuild, &dirty_realms);
>=20=20
>  	if (!first_realm)
>  		first_realm =3D realm;
> --=20
>
> 2.27.0
>
