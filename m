Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E16B549C6E
	for <lists+ceph-devel@lfdr.de>; Mon, 13 Jun 2022 20:59:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243259AbiFMS7L (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 13 Jun 2022 14:59:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232535AbiFMS60 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 13 Jun 2022 14:58:26 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A29A62A733
        for <ceph-devel@vger.kernel.org>; Mon, 13 Jun 2022 09:06:52 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 56DEF21AEC;
        Mon, 13 Jun 2022 16:06:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1655136411; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=3FkRIBGwUikXYxVL+SLsS/X6/l6q75nzTi/+Hu9r4/E=;
        b=lDQwP6Md2BS/VbhZ3hg7OxfhYrE6EPqyNpqfy6pt57UfB44BLte4tNLxVQ800d1vo4l0Hq
        JR1R+1+deVQ9VW6nqHvsiXTCO0dj7qt6WQctWBN/Ta2opamoMSWnERbRRF/sqy+dDo0vTx
        08nm7YEuPrel8XJqabWYFJp9PVpr+Kc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1655136411;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=3FkRIBGwUikXYxVL+SLsS/X6/l6q75nzTi/+Hu9r4/E=;
        b=qqhAZkZNals8J9SPG70wMKSoKoEoJci/+S34TVKJjybpXT7NY43/d5c4iiUY4SENFdN7W5
        sMBmV8K9alShV8BA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id F106A134CF;
        Mon, 13 Jun 2022 16:06:50 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id 7X7eN5pgp2IZagAAMHmgww
        (envelope-from <lhenriques@suse.de>); Mon, 13 Jun 2022 16:06:50 +0000
Received: from localhost (brahms.olymp [local])
        by brahms.olymp (OpenSMTPD) with ESMTPA id 62026336;
        Mon, 13 Jun 2022 16:07:34 +0000 (UTC)
From:   =?utf-8?Q?Lu=C3=ADs_Henriques?= <lhenriques@suse.de>
To:     Xiubo Li <xiubli@redhat.com>
Cc:     jlayton@kernel.org, idryomov@gmail.com, vshankar@redhat.com,
        ceph-devel@vger.kernel.org
Subject: Re: [PATCH 2/2] ceph: update the auth cap when the async create req
 is forwarded
References: <20220610043140.642501-1-xiubli@redhat.com>
        <20220610043140.642501-3-xiubli@redhat.com>
Date:   Mon, 13 Jun 2022 17:07:34 +0100
In-Reply-To: <20220610043140.642501-3-xiubli@redhat.com> (Xiubo Li's message
        of "Fri, 10 Jun 2022 12:31:40 +0800")
Message-ID: <87r13seed5.fsf@brahms.olymp>
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

Xiubo Li <xiubli@redhat.com> writes:

> For async create we will always try to choose the auth MDS of frag
> the dentry belonged to of the parent directory to send the request
> and ususally this works fine, but if the MDS migrated the directory
> to another MDS before it could be handled the request will be
> forwarded. And then the auth cap will be changed.
>
> We need to update the auth cap in this case before the request is
> forwarded.
>
> URL: https://tracker.ceph.com/issues/55857
> Signed-off-by: Xiubo Li <xiubli@redhat.com>
> ---
>  fs/ceph/file.c       | 12 +++++++++
>  fs/ceph/mds_client.c | 58 ++++++++++++++++++++++++++++++++++++++++++++
>  fs/ceph/super.h      |  2 ++
>  3 files changed, 72 insertions(+)
>
> diff --git a/fs/ceph/file.c b/fs/ceph/file.c
> index 0e82a1c383ca..54acf76c5e9b 100644
> --- a/fs/ceph/file.c
> +++ b/fs/ceph/file.c
> @@ -613,6 +613,7 @@ static int ceph_finish_async_create(struct inode *dir=
, struct inode *inode,
>  	struct ceph_mds_reply_inode in =3D { };
>  	struct ceph_mds_reply_info_in iinfo =3D { .in =3D &in };
>  	struct ceph_inode_info *ci =3D ceph_inode(dir);
> +	struct ceph_dentry_info *di =3D ceph_dentry(dentry);
>  	struct timespec64 now;
>  	struct ceph_string *pool_ns;
>  	struct ceph_mds_client *mdsc =3D ceph_sb_to_mdsc(dir->i_sb);
> @@ -709,6 +710,12 @@ static int ceph_finish_async_create(struct inode *di=
r, struct inode *inode,
>  		file->f_mode |=3D FMODE_CREATED;
>  		ret =3D finish_open(file, dentry, ceph_open);
>  	}
> +
> +	spin_lock(&dentry->d_lock);
> +	di->flags &=3D ~CEPH_DENTRY_ASYNC_CREATE;
> +	wake_up_bit(&di->flags, CEPH_DENTRY_ASYNC_CREATE_BIT);
> +	spin_unlock(&dentry->d_lock);

Question: shouldn't we initialise 'di' *after* grabbing ->d_lock?  Ceph
code doesn't seem to be consistent with this regard, but my understanding
is that doing it this way is racy.  And if so, some other places may need
fixing.

Cheers,
--=20
Lu=C3=ADs


> +
>  	return ret;
>  }
>=20=20
> @@ -786,6 +793,7 @@ int ceph_atomic_open(struct inode *dir, struct dentry=
 *dentry,
>  				  try_prep_async_create(dir, dentry, &lo, &req->r_deleg_ino))) {
>  			struct ceph_vino vino =3D { .ino =3D req->r_deleg_ino,
>  						  .snap =3D CEPH_NOSNAP };
> +			struct ceph_dentry_info *di =3D ceph_dentry(dentry);
>=20=20
>  			set_bit(CEPH_MDS_R_ASYNC, &req->r_req_flags);
>  			req->r_args.open.flags |=3D cpu_to_le32(CEPH_O_EXCL);
> @@ -800,6 +808,10 @@ int ceph_atomic_open(struct inode *dir, struct dentr=
y *dentry,
>  			}
>  			WARN_ON_ONCE(!(new_inode->i_state & I_NEW));
>=20=20
> +			spin_lock(&dentry->d_lock);
> +			di->flags |=3D CEPH_DENTRY_ASYNC_CREATE;
> +			spin_unlock(&dentry->d_lock);
> +
>  			err =3D ceph_mdsc_submit_request(mdsc, dir, req);
>  			if (!err) {
>  				err =3D ceph_finish_async_create(dir, new_inode, dentry,
> diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
> index fa7f719807d9..a413b389a535 100644
> --- a/fs/ceph/mds_client.c
> +++ b/fs/ceph/mds_client.c
> @@ -2993,6 +2993,64 @@ static void __do_request(struct ceph_mds_client *m=
dsc,
>  	if (req->r_request_started =3D=3D 0)   /* note request start time */
>  		req->r_request_started =3D jiffies;
>=20=20
> +	/*
> +	 * For async create we will choose the auth MDS of frag in parent
> +	 * directory to send the request and ususally this works fine, but
> +	 * if the migrated the dirtory to another MDS before it could handle
> +	 * it the request will be forwarded.
> +	 *
> +	 * And then the auth cap will be changed.
> +	 */
> +	if (test_bit(CEPH_MDS_R_ASYNC, &req->r_req_flags) && req->r_num_fwd) {
> +		struct ceph_dentry_info *di =3D ceph_dentry(req->r_dentry);
> +		struct ceph_inode_info *ci;
> +		struct ceph_cap *cap;
> +
> +		/*
> +		 * The request maybe handled very fast and the new inode
> +		 * hasn't been linked to the dentry yet. We need to wait
> +		 * for the ceph_finish_async_create(), which shouldn't be
> +		 * stuck too long or fail in thoery, to finish when forwarding
> +		 * the request.
> +		 */
> +		if (!d_inode(req->r_dentry)) {
> +			err =3D wait_on_bit(&di->flags, CEPH_DENTRY_ASYNC_CREATE_BIT,
> +					  TASK_KILLABLE);
> +			if (err) {
> +				mutex_lock(&req->r_fill_mutex);
> +				set_bit(CEPH_MDS_R_ABORTED, &req->r_req_flags);
> +				mutex_unlock(&req->r_fill_mutex);
> +				goto out_session;
> +			}
> +		}
> +
> +		ci =3D ceph_inode(d_inode(req->r_dentry));
> +
> +		spin_lock(&ci->i_ceph_lock);
> +		cap =3D ci->i_auth_cap;
> +		if (ci->i_ceph_flags & CEPH_I_ASYNC_CREATE && mds !=3D cap->mds) {
> +			dout("do_request session changed for auth cap %d -> %d\n",
> +			     cap->session->s_mds, session->s_mds);
> +
> +			/* Remove the auth cap from old session */
> +			spin_lock(&cap->session->s_cap_lock);
> +			cap->session->s_nr_caps--;
> +			list_del_init(&cap->session_caps);
> +			spin_unlock(&cap->session->s_cap_lock);
> +
> +			/* Add the auth cap to the new session */
> +			cap->mds =3D mds;
> +			cap->session =3D session;
> +			spin_lock(&session->s_cap_lock);
> +			session->s_nr_caps++;
> +			list_add_tail(&cap->session_caps, &session->s_caps);
> +			spin_unlock(&session->s_cap_lock);
> +
> +			change_auth_cap_ses(ci, session);
> +		}
> +		spin_unlock(&ci->i_ceph_lock);
> +	}
> +
>  	err =3D __send_request(session, req, false);
>=20=20
>  out_session:
> diff --git a/fs/ceph/super.h b/fs/ceph/super.h
> index 3bdd60a3e680..5ccafab21bbb 100644
> --- a/fs/ceph/super.h
> +++ b/fs/ceph/super.h
> @@ -304,6 +304,8 @@ struct ceph_dentry_info {
>  #define CEPH_DENTRY_PRIMARY_LINK	(1 << 3)
>  #define CEPH_DENTRY_ASYNC_UNLINK_BIT	(4)
>  #define CEPH_DENTRY_ASYNC_UNLINK	(1 << CEPH_DENTRY_ASYNC_UNLINK_BIT)
> +#define CEPH_DENTRY_ASYNC_CREATE_BIT	(5)
> +#define CEPH_DENTRY_ASYNC_CREATE	(1 << CEPH_DENTRY_ASYNC_CREATE_BIT)
>=20=20
>  struct ceph_inode_xattrs_info {
>  	/*
> --=20
>
> 2.36.0.rc1
>
