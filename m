Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A0C06CEBFF
	for <lists+ceph-devel@lfdr.de>; Wed, 29 Mar 2023 16:44:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229601AbjC2OoD (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 29 Mar 2023 10:44:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230295AbjC2OnW (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 29 Mar 2023 10:43:22 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2001:67c:2178:6::1c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18552F0
        for <ceph-devel@vger.kernel.org>; Wed, 29 Mar 2023 07:41:04 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id BC73A219E6;
        Wed, 29 Mar 2023 14:41:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1680100862; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Ahsadsn8zETeg3X62I75SSaNgRRRN/jHzpe3mutqU8A=;
        b=Bae5TzsnMJ0bz4Mh6rPL/YPpDLi9sBPy+otq18YhdJyX0rdemEuk4p3BhoOYcokC3HjRpu
        hIqbZVCSAkrzsO+4OqrksB7orxbw+2jAip6GdfMqOtN30hZ95LN4f+kgVh/Y/JrjubPF8E
        t9VihVLb6+cDpr4YgFmycaUY5uQnGRo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1680100862;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Ahsadsn8zETeg3X62I75SSaNgRRRN/jHzpe3mutqU8A=;
        b=egwqJIT474QlM6+7tk9XoVm43ZUihKl3W98jwoYAgRbSkmIMR8N1GLn3gV0ZnV18ySm7L+
        gkdbmqR+HYwZe6Aw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 5A020139D3;
        Wed, 29 Mar 2023 14:41:02 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id C2nNEv5NJGR2PQAAMHmgww
        (envelope-from <lhenriques@suse.de>); Wed, 29 Mar 2023 14:41:02 +0000
Received: from localhost (brahms.olymp [local])
        by brahms.olymp (OpenSMTPD) with ESMTPA id 846c990f;
        Wed, 29 Mar 2023 14:41:01 +0000 (UTC)
From:   =?utf-8?Q?Lu=C3=ADs_Henriques?= <lhenriques@suse.de>
To:     xiubli@redhat.com
Cc:     idryomov@gmail.com, ceph-devel@vger.kernel.org, jlayton@kernel.org,
        vshankar@redhat.com, mchangir@redhat.com
Subject: Re: [PATCH v4] ceph: drop the messages from MDS when unmounting
References: <20230327030508.310588-1-xiubli@redhat.com>
Date:   Wed, 29 Mar 2023 15:41:01 +0100
In-Reply-To: <20230327030508.310588-1-xiubli@redhat.com> (xiubli@redhat.com's
        message of "Mon, 27 Mar 2023 11:05:08 +0800")
Message-ID: <87v8ij4o3m.fsf@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Hi!

I finally got to have a look at this patch because I found that the
version you sent along with fscrypt v17 is a bit different from what's in
the testing branch :-)

xiubli@redhat.com writes:

> From: Xiubo Li <xiubli@redhat.com>
>
> When unmounting and all the dirty buffer will be flushed and after
> the last osd request is finished the last reference of the i_count
> will be released. Then it will flush the dirty cap/snap to MDSs,
> and the unmounting won't wait the possible acks, which will ihode
> the inodes when updating the metadata locally but makes no sense
> any more, of this. This will make the evict_inodes() to skip these
> inodes.
>
> If encrypt is enabled the kernel generate a warning when removing
> the encrypt keys when the skipped inodes still hold the keyring:
>
> WARNING: CPU: 4 PID: 168846 at fs/crypto/keyring.c:242 fscrypt_destroy_ke=
yring+0x7e/0xd0
> CPU: 4 PID: 168846 Comm: umount Tainted: G S  6.1.0-rc5-ceph-g72ead199864=
c #1
> Hardware name: Supermicro SYS-5018R-WR/X10SRW-F, BIOS 2.0 12/17/2015
> RIP: 0010:fscrypt_destroy_keyring+0x7e/0xd0
> RSP: 0018:ffffc9000b277e28 EFLAGS: 00010202
> RAX: 0000000000000002 RBX: ffff88810d52ac00 RCX: ffff88810b56aa00
> RDX: 0000000080000000 RSI: ffffffff822f3a09 RDI: ffff888108f59000
> RBP: ffff8881d394fb88 R08: 0000000000000028 R09: 0000000000000000
> R10: 0000000000000001 R11: 11ff4fe6834fcd91 R12: ffff8881d394fc40
> R13: ffff888108f59000 R14: ffff8881d394f800 R15: 0000000000000000
> FS:  00007fd83f6f1080(0000) GS:ffff88885fd00000(0000) knlGS:0000000000000=
000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007f918d417000 CR3: 000000017f89a005 CR4: 00000000003706e0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> Call Trace:
> <TASK>
> generic_shutdown_super+0x47/0x120
> kill_anon_super+0x14/0x30
> ceph_kill_sb+0x36/0x90 [ceph]
> deactivate_locked_super+0x29/0x60
> cleanup_mnt+0xb8/0x140
> task_work_run+0x67/0xb0
> exit_to_user_mode_prepare+0x23d/0x240
> syscall_exit_to_user_mode+0x25/0x60
> do_syscall_64+0x40/0x80
> entry_SYSCALL_64_after_hwframe+0x63/0xcd
> RIP: 0033:0x7fd83dc39e9b
>
> Later the kernel will crash when iput() the inodes and dereferencing
> the "sb->s_master_keys", which has been released by the
> generic_shutdown_super().
>
> URL: https://tracker.ceph.com/issues/58126
> URL: https://tracker.ceph.com/issues/59162
> Signed-off-by: Xiubo Li <xiubli@redhat.com>
> ---
>
> Only updated the 2/2 patch since series V3:
>
> Changed in V4:
> - Always resend the session close requests to MDS when receives
>   new messages just before dropping them.
> - Even receives a corrupted message we should increase the s_seq
>   and resend the session close requests.
>
>
>  fs/ceph/caps.c       |  6 ++++-
>  fs/ceph/mds_client.c | 14 ++++++++---
>  fs/ceph/mds_client.h | 11 ++++++++-
>  fs/ceph/quota.c      |  9 ++++---
>  fs/ceph/snap.c       | 10 ++++----
>  fs/ceph/super.c      | 57 ++++++++++++++++++++++++++++++++++++++++++++
>  fs/ceph/super.h      |  3 +++
>  7 files changed, 96 insertions(+), 14 deletions(-)
>
> diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
> index 6379c0070492..e1bb6d9c16f8 100644
> --- a/fs/ceph/caps.c
> +++ b/fs/ceph/caps.c
> @@ -4222,6 +4222,9 @@ void ceph_handle_caps(struct ceph_mds_session *sess=
ion,
>=20=20
>  	dout("handle_caps from mds%d\n", session->s_mds);
>=20=20
> +	if (!ceph_inc_stopping_blocker(mdsc, session))
> +		return;
> +
>  	/* decode */
>  	end =3D msg->front.iov_base + msg->front.iov_len;
>  	if (msg->front.iov_len < sizeof(*h))
> @@ -4323,7 +4326,6 @@ void ceph_handle_caps(struct ceph_mds_session *sess=
ion,
>  	     vino.snap, inode);
>=20=20
>  	mutex_lock(&session->s_mutex);
> -	inc_session_sequence(session);
>  	dout(" mds%d seq %lld cap seq %u\n", session->s_mds, session->s_seq,
>  	     (unsigned)seq);
>=20=20
> @@ -4435,6 +4437,8 @@ void ceph_handle_caps(struct ceph_mds_session *sess=
ion,
>  done_unlocked:
>  	iput(inode);
>  out:
> +	ceph_dec_stopping_blocker(mdsc);
> +
>  	ceph_put_string(extra_info.pool_ns);
>=20=20
>  	/* Defer closing the sessions after s_mutex lock being released */
> diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
> index 85d639f75ea1..21ca41e5f68b 100644
> --- a/fs/ceph/mds_client.c
> +++ b/fs/ceph/mds_client.c
> @@ -4877,6 +4877,9 @@ static void handle_lease(struct ceph_mds_client *md=
sc,
>=20=20
>  	dout("handle_lease from mds%d\n", mds);
>=20=20
> +	if (!ceph_inc_stopping_blocker(mdsc, session))
> +		return;
> +
>  	/* decode */
>  	if (msg->front.iov_len < sizeof(*h) + sizeof(u32))
>  		goto bad;
> @@ -4895,8 +4898,6 @@ static void handle_lease(struct ceph_mds_client *md=
sc,
>  	     dname.len, dname.name);
>=20=20
>  	mutex_lock(&session->s_mutex);
> -	inc_session_sequence(session);
> -
>  	if (!inode) {
>  		dout("handle_lease no inode %llx\n", vino.ino);
>  		goto release;
> @@ -4958,9 +4959,13 @@ static void handle_lease(struct ceph_mds_client *m=
dsc,
>  out:
>  	mutex_unlock(&session->s_mutex);
>  	iput(inode);
> +
> +	ceph_dec_stopping_blocker(mdsc);
>  	return;
>=20=20
>  bad:
> +	ceph_dec_stopping_blocker(mdsc);
> +
>  	pr_err("corrupt lease message\n");
>  	ceph_msg_dump(msg);
>  }
> @@ -5156,6 +5161,9 @@ int ceph_mdsc_init(struct ceph_fs_client *fsc)
>  	}
>=20=20
>  	init_completion(&mdsc->safe_umount_waiters);
> +	spin_lock_init(&mdsc->stopping_lock);
> +	atomic_set(&mdsc->stopping_blockers, 0);
> +	init_completion(&mdsc->stopping_waiter);
>  	init_waitqueue_head(&mdsc->session_close_wq);
>  	INIT_LIST_HEAD(&mdsc->waiting_for_map);
>  	mdsc->quotarealms_inodes =3D RB_ROOT;
> @@ -5270,7 +5278,7 @@ void send_flush_mdlog(struct ceph_mds_session *s)
>  void ceph_mdsc_pre_umount(struct ceph_mds_client *mdsc)
>  {
>  	dout("pre_umount\n");
> -	mdsc->stopping =3D 1;
> +	mdsc->stopping =3D CEPH_MDSC_STOPPING_BEGAIN;
>=20=20
>  	ceph_mdsc_iterate_sessions(mdsc, send_flush_mdlog, true);
>  	ceph_mdsc_iterate_sessions(mdsc, lock_unlock_session, false);
> diff --git a/fs/ceph/mds_client.h b/fs/ceph/mds_client.h
> index 81a1f9a4ac3b..5bf32701c84c 100644
> --- a/fs/ceph/mds_client.h
> +++ b/fs/ceph/mds_client.h
> @@ -398,6 +398,11 @@ struct cap_wait {
>  	int			want;
>  };
>=20=20
> +enum {
> +	CEPH_MDSC_STOPPING_BEGAIN =3D 1,

Typo: I think you want to define this as "CEPH_MDSC_STOPPING_BEGIN"
instead, right?

> +	CEPH_MDSC_STOPPING_FLUSHED =3D 2,
> +};
> +
>  /*
>   * mds client state
>   */
> @@ -414,7 +419,11 @@ struct ceph_mds_client {
>  	struct ceph_mds_session **sessions;    /* NULL for mds if no session */
>  	atomic_t		num_sessions;
>  	int                     max_sessions;  /* len of sessions array */
> -	int                     stopping;      /* true if shutting down */
> +
> +	spinlock_t              stopping_lock;  /* protect snap_empty */
> +	int                     stopping;      /* the stage of shutting down */
> +	atomic_t                stopping_blockers;
> +	struct completion	stopping_waiter;
>=20=20
>  	atomic64_t		quotarealms_count; /* # realms with quota */
>  	/*
> diff --git a/fs/ceph/quota.c b/fs/ceph/quota.c
> index 64592adfe48f..37b062783717 100644
> --- a/fs/ceph/quota.c
> +++ b/fs/ceph/quota.c
> @@ -47,6 +47,9 @@ void ceph_handle_quota(struct ceph_mds_client *mdsc,
>  	struct inode *inode;
>  	struct ceph_inode_info *ci;
>=20=20
> +	if (!ceph_inc_stopping_blocker(mdsc, session))
> +		return;
> +
>  	if (msg->front.iov_len < sizeof(*h)) {
>  		pr_err("%s corrupt message mds%d len %d\n", __func__,
>  		       session->s_mds, (int)msg->front.iov_len);
> @@ -54,11 +57,6 @@ void ceph_handle_quota(struct ceph_mds_client *mdsc,
>  		return;
>  	}
>=20=20
> -	/* increment msg sequence number */
> -	mutex_lock(&session->s_mutex);
> -	inc_session_sequence(session);
> -	mutex_unlock(&session->s_mutex);
> -
>  	/* lookup inode */
>  	vino.ino =3D le64_to_cpu(h->ino);
>  	vino.snap =3D CEPH_NOSNAP;
> @@ -78,6 +76,7 @@ void ceph_handle_quota(struct ceph_mds_client *mdsc,
>  	spin_unlock(&ci->i_ceph_lock);
>=20=20
>  	iput(inode);
> +	ceph_dec_stopping_blocker(mdsc);

There are two 'return' statements in this function where function
ceph_dec_stopping_blocker() isn't being called.

>  }
>=20=20
>  static struct ceph_quotarealm_inode *
> diff --git a/fs/ceph/snap.c b/fs/ceph/snap.c
> index aa8e0657fc03..23b31600ee3c 100644
> --- a/fs/ceph/snap.c
> +++ b/fs/ceph/snap.c
> @@ -1011,6 +1011,9 @@ void ceph_handle_snap(struct ceph_mds_client *mdsc,
>  	int locked_rwsem =3D 0;
>  	bool close_sessions =3D false;
>=20=20
> +	if (!ceph_inc_stopping_blocker(mdsc, session))
> +		return;
> +
>  	/* decode */
>  	if (msg->front.iov_len < sizeof(*h))
>  		goto bad;
> @@ -1026,10 +1029,6 @@ void ceph_handle_snap(struct ceph_mds_client *mdsc,
>  	dout("%s from mds%d op %s split %llx tracelen %d\n", __func__,
>  	     mds, ceph_snap_op_name(op), split, trace_len);
>=20=20
> -	mutex_lock(&session->s_mutex);
> -	inc_session_sequence(session);
> -	mutex_unlock(&session->s_mutex);
> -
>  	down_write(&mdsc->snap_rwsem);
>  	locked_rwsem =3D 1;
>=20=20
> @@ -1134,12 +1133,15 @@ void ceph_handle_snap(struct ceph_mds_client *mds=
c,
>  	up_write(&mdsc->snap_rwsem);
>=20=20
>  	flush_snaps(mdsc);
> +	ceph_dec_stopping_blocker(mdsc);
>  	return;
>=20=20
>  bad:
>  	pr_err("%s corrupt snap message from mds%d\n", __func__, mds);
>  	ceph_msg_dump(msg);
>  out:
> +	ceph_dec_stopping_blocker(mdsc);
> +
>  	if (locked_rwsem)
>  		up_write(&mdsc->snap_rwsem);
>=20=20
> diff --git a/fs/ceph/super.c b/fs/ceph/super.c
> index 4b0a070d5c6d..f5ddd4abc0ab 100644
> --- a/fs/ceph/super.c
> +++ b/fs/ceph/super.c
> @@ -1467,15 +1467,72 @@ static int ceph_init_fs_context(struct fs_context=
 *fc)
>  	return -ENOMEM;
>  }
>=20=20
> +/*
> + * Return true if mdsc successfully increase blocker counter,
> + * or false if the mdsc is in stopping and flushed state.
> + */
> +bool ceph_inc_stopping_blocker(struct ceph_mds_client *mdsc,
> +			       struct ceph_mds_session *session)
> +{
> +	mutex_lock(&session->s_mutex);
> +	inc_session_sequence(session);
> +	mutex_unlock(&session->s_mutex);
> +
> +	spin_lock(&mdsc->stopping_lock);
> +	if (mdsc->stopping >=3D CEPH_MDSC_STOPPING_FLUSHED) {
> +		spin_unlock(&mdsc->stopping_lock);
> +		return false;
> +	}
> +	atomic_inc(&mdsc->stopping_blockers);
> +	spin_unlock(&mdsc->stopping_lock);
> +	return true;
> +}
> +
> +void ceph_dec_stopping_blocker(struct ceph_mds_client *mdsc)
> +{
> +	spin_lock(&mdsc->stopping_lock);
> +	if (!atomic_dec_return(&mdsc->stopping_blockers) &&
> +	    mdsc->stopping >=3D CEPH_MDSC_STOPPING_FLUSHED)
> +		complete_all(&mdsc->stopping_waiter);
> +	spin_unlock(&mdsc->stopping_lock);
> +}
> +
>  static void ceph_kill_sb(struct super_block *s)
>  {
>  	struct ceph_fs_client *fsc =3D ceph_sb_to_client(s);
> +	bool wait;
>=20=20
>  	dout("kill_sb %p\n", s);
>=20=20
>  	ceph_mdsc_pre_umount(fsc->mdsc);
>  	flush_fs_workqueues(fsc);
>=20=20
> +	/*
> +	 * Though the kill_anon_super() will finally trigger the
> +	 * sync_filesystem() anyway, we still need to do it here and
> +	 * then bump the stage of shutdown. This will allow us to
> +	 * drop any further message, which will increase the inodes'
> +	 * i_count reference counters but makes no sense any more,
> +	 * from MDSs.
> +	 *
> +	 * Without this when evicting the inodes it may fail in the
> +	 * kill_anon_super(), which will trigger a warning when
> +	 * destroying the fscrypt keyring and then possibly trigger
> +	 * a further crash in ceph module when the iput() tries to
> +	 * evict the inodes later.
> +	 */
> +	sync_filesystem(s);
> +
> +	spin_lock(&fsc->mdsc->stopping_lock);
> +	fsc->mdsc->stopping =3D CEPH_MDSC_STOPPING_FLUSHED;
> +	wait =3D !!atomic_read(&fsc->mdsc->stopping_blockers);
> +	spin_unlock(&fsc->mdsc->stopping_lock);
> +
> +	while (wait || atomic_read(&fsc->mdsc->stopping_blockers)) {
> +		wait =3D false;
> +		wait_for_completion(&fsc->mdsc->stopping_waiter);
> +	}

This is a odd construct :-) I'd rather see it like this:

	if (wait) {
		while (atomic_read(&fsc->mdsc->stopping_blockers))
			wait_for_completion(&fsc->mdsc->stopping_waiter);
	}

But... even with my suggestion, can't we deadlock here if we get preempted
just before the wait_for_completion() and ceph_dec_stopping_blocker() is
executed?

Cheers,
--=20
Lu=C3=ADs

> + kill_anon_super(s);
>=20=20
>  	fsc->client->extra_mon_dispatch =3D NULL;
> diff --git a/fs/ceph/super.h b/fs/ceph/super.h
> index a785e5cb9b40..8a9afa81a76f 100644
> --- a/fs/ceph/super.h
> +++ b/fs/ceph/super.h
> @@ -1398,4 +1398,7 @@ extern bool ceph_quota_update_statfs(struct ceph_fs=
_client *fsc,
>  				     struct kstatfs *buf);
>  extern void ceph_cleanup_quotarealms_inodes(struct ceph_mds_client *mdsc=
);
>=20=20
> +bool ceph_inc_stopping_blocker(struct ceph_mds_client *mdsc,
> +			       struct ceph_mds_session *session);
> +void ceph_dec_stopping_blocker(struct ceph_mds_client *mdsc);
>  #endif /* _FS_CEPH_SUPER_H */
> --=20
>
> 2.31.1
>
