Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 39D28673EBB
	for <lists+ceph-devel@lfdr.de>; Thu, 19 Jan 2023 17:27:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230180AbjASQ1c (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 19 Jan 2023 11:27:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230195AbjASQ1T (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 19 Jan 2023 11:27:19 -0500
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CAC248A0FE
        for <ceph-devel@vger.kernel.org>; Thu, 19 Jan 2023 08:27:13 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 7B4CB5D031;
        Thu, 19 Jan 2023 16:27:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1674145632; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=c4+Th41HMycQ9TDbsyEPXfzWIh18ua6BNxfrh+NW2dE=;
        b=T6TnWNzloqqqXcdctCcAAKrd4r2XoJadz0Ni3wIVCfZn4fEHrmwqeyTQXUvkGvvxW6UWEO
        Gptuq74I9ZYVSefBAVReyBxh7yNWLXOwflJa2KySdKrOxS/6DNNPqlyJ/DTfapaZkDeKut
        ezkMT6uKanBmXs0T+89c/6h81KvKa9M=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1674145632;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=c4+Th41HMycQ9TDbsyEPXfzWIh18ua6BNxfrh+NW2dE=;
        b=nWAlPyV7bKLDop5i+EgZhDW9sLliSZrFPoUvDLD7HoRST+mo6s+gWJ5GVkx9Cu5EkDnui7
        Hs53W9rlBSuXb7Dw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 18AEE139ED;
        Thu, 19 Jan 2023 16:27:12 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id qWLOAmBvyWM/ZgAAMHmgww
        (envelope-from <lhenriques@suse.de>); Thu, 19 Jan 2023 16:27:12 +0000
Received: from localhost (brahms.olymp [local])
        by brahms.olymp (OpenSMTPD) with ESMTPA id 7072addd;
        Thu, 19 Jan 2023 16:27:09 +0000 (UTC)
Date:   Thu, 19 Jan 2023 16:27:09 +0000
From:   =?iso-8859-1?Q?Lu=EDs?= Henriques <lhenriques@suse.de>
To:     xiubli@redhat.com
Cc:     idryomov@gmail.com, ceph-devel@vger.kernel.org, jlayton@kernel.org,
        mchangir@redhat.com, vshankar@redhat.com
Subject: Re: [PATCH v2] ceph: drop the messages from MDS when unmouting
Message-ID: <Y8lvXRmHKGdORhs5@suse.de>
References: <20221221093031.132792-1-xiubli@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20221221093031.132792-1-xiubli@redhat.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Wed, Dec 21, 2022 at 05:30:31PM +0800, xiubli@redhat.com wrote:
> From: Xiubo Li <xiubli@redhat.com>
> 
> When unmounting it will just wait for the inflight requests to be
> finished, but just before the sessions are closed the kclient still
> could receive the caps/snaps/lease/quota msgs from MDS. All these
> msgs need to hold some inodes, which will cause ceph_kill_sb() failing
> to evict the inodes in time.
> 
> If encrypt is enabled the kernel generate a warning when removing
> the encrypt keys when the skipped inodes still hold the keyring:

Finally (sorry for the delay!) I managed to look into the 6.1 rebase.  It
does look good, but I started hitting the WARNING added by patch:

  [DO NOT MERGE] ceph: make sure all the files successfully put before unmounting

This patch seems to be working but I'm not sure we really need the extra
'stopping' state.  Looking at the code, we've flushed all the workqueues
and done all the waits, so I *think* the sync_filesystem() call should be
enough.

The other alternative I see would be to add a ->flush() to ceph_file_fops,
where we'd do a filemap_write_and_wait().  But that would probably have a
negative performance impact -- my understand is that it basically means
we'll have sync file closes.

Cheers,
--
Luís

> 
> WARNING: CPU: 4 PID: 168846 at fs/crypto/keyring.c:242 fscrypt_destroy_keyring+0x7e/0xd0
> CPU: 4 PID: 168846 Comm: umount Tainted: G S  6.1.0-rc5-ceph-g72ead199864c #1
> Hardware name: Supermicro SYS-5018R-WR/X10SRW-F, BIOS 2.0 12/17/2015
> RIP: 0010:fscrypt_destroy_keyring+0x7e/0xd0
> RSP: 0018:ffffc9000b277e28 EFLAGS: 00010202
> RAX: 0000000000000002 RBX: ffff88810d52ac00 RCX: ffff88810b56aa00
> RDX: 0000000080000000 RSI: ffffffff822f3a09 RDI: ffff888108f59000
> RBP: ffff8881d394fb88 R08: 0000000000000028 R09: 0000000000000000
> R10: 0000000000000001 R11: 11ff4fe6834fcd91 R12: ffff8881d394fc40
> R13: ffff888108f59000 R14: ffff8881d394f800 R15: 0000000000000000
> FS:  00007fd83f6f1080(0000) GS:ffff88885fd00000(0000) knlGS:0000000000000000
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
> URL: https://tracker.ceph.com/issues/58126
> Signed-off-by: Xiubo Li <xiubli@redhat.com>
> ---
> 
> V2:
> - Fix it in ceph layer.
> 
> 
>  fs/ceph/caps.c       |  3 +++
>  fs/ceph/mds_client.c |  5 ++++-
>  fs/ceph/mds_client.h |  7 ++++++-
>  fs/ceph/quota.c      |  3 +++
>  fs/ceph/snap.c       |  3 +++
>  fs/ceph/super.c      | 14 ++++++++++++++
>  6 files changed, 33 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
> index 15d9e0f0d65a..e8a53aeb2a8c 100644
> --- a/fs/ceph/caps.c
> +++ b/fs/ceph/caps.c
> @@ -4222,6 +4222,9 @@ void ceph_handle_caps(struct ceph_mds_session *session,
>  
>  	dout("handle_caps from mds%d\n", session->s_mds);
>  
> +	if (mdsc->stopping >= CEPH_MDSC_STOPPING_FLUSHED)
> +		return;
> +
>  	/* decode */
>  	end = msg->front.iov_base + msg->front.iov_len;
>  	if (msg->front.iov_len < sizeof(*h))
> diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
> index d41ab68f0130..1ad85af49b45 100644
> --- a/fs/ceph/mds_client.c
> +++ b/fs/ceph/mds_client.c
> @@ -4869,6 +4869,9 @@ static void handle_lease(struct ceph_mds_client *mdsc,
>  
>  	dout("handle_lease from mds%d\n", mds);
>  
> +	if (mdsc->stopping >= CEPH_MDSC_STOPPING_FLUSHED)
> +		return;
> +
>  	/* decode */
>  	if (msg->front.iov_len < sizeof(*h) + sizeof(u32))
>  		goto bad;
> @@ -5262,7 +5265,7 @@ void send_flush_mdlog(struct ceph_mds_session *s)
>  void ceph_mdsc_pre_umount(struct ceph_mds_client *mdsc)
>  {
>  	dout("pre_umount\n");
> -	mdsc->stopping = 1;
> +	mdsc->stopping = CEPH_MDSC_STOPPING_BEGAIN;
>  
>  	ceph_mdsc_iterate_sessions(mdsc, send_flush_mdlog, true);
>  	ceph_mdsc_iterate_sessions(mdsc, lock_unlock_session, false);
> diff --git a/fs/ceph/mds_client.h b/fs/ceph/mds_client.h
> index 81a1f9a4ac3b..56f9d8077068 100644
> --- a/fs/ceph/mds_client.h
> +++ b/fs/ceph/mds_client.h
> @@ -398,6 +398,11 @@ struct cap_wait {
>  	int			want;
>  };
>  
> +enum {
> +	CEPH_MDSC_STOPPING_BEGAIN = 1,
> +	CEPH_MDSC_STOPPING_FLUSHED = 2,
> +};
> +
>  /*
>   * mds client state
>   */
> @@ -414,7 +419,7 @@ struct ceph_mds_client {
>  	struct ceph_mds_session **sessions;    /* NULL for mds if no session */
>  	atomic_t		num_sessions;
>  	int                     max_sessions;  /* len of sessions array */
> -	int                     stopping;      /* true if shutting down */
> +	int                     stopping;      /* the stage of shutting down */
>  
>  	atomic64_t		quotarealms_count; /* # realms with quota */
>  	/*
> diff --git a/fs/ceph/quota.c b/fs/ceph/quota.c
> index 64592adfe48f..f5819fc31d28 100644
> --- a/fs/ceph/quota.c
> +++ b/fs/ceph/quota.c
> @@ -47,6 +47,9 @@ void ceph_handle_quota(struct ceph_mds_client *mdsc,
>  	struct inode *inode;
>  	struct ceph_inode_info *ci;
>  
> +	if (mdsc->stopping >= CEPH_MDSC_STOPPING_FLUSHED)
> +		return;
> +
>  	if (msg->front.iov_len < sizeof(*h)) {
>  		pr_err("%s corrupt message mds%d len %d\n", __func__,
>  		       session->s_mds, (int)msg->front.iov_len);
> diff --git a/fs/ceph/snap.c b/fs/ceph/snap.c
> index a73943e51a77..eeabdd0211d8 100644
> --- a/fs/ceph/snap.c
> +++ b/fs/ceph/snap.c
> @@ -1010,6 +1010,9 @@ void ceph_handle_snap(struct ceph_mds_client *mdsc,
>  	int locked_rwsem = 0;
>  	bool close_sessions = false;
>  
> +	if (mdsc->stopping >= CEPH_MDSC_STOPPING_FLUSHED)
> +		return;
> +
>  	/* decode */
>  	if (msg->front.iov_len < sizeof(*h))
>  		goto bad;
> diff --git a/fs/ceph/super.c b/fs/ceph/super.c
> index f10a076f47e5..012b35be41a9 100644
> --- a/fs/ceph/super.c
> +++ b/fs/ceph/super.c
> @@ -1483,6 +1483,20 @@ static void ceph_kill_sb(struct super_block *s)
>  	ceph_mdsc_pre_umount(fsc->mdsc);
>  	flush_fs_workqueues(fsc);
>  
> +	/*
> +	 * Though the kill_anon_super() will finally trigger the
> +	 * sync_filesystem() anyway, we still need to do it here and
> +	 * then bump the stage of shutdown. This will drop any further
> +	 * message, which makes no sense any more, from MDSs.
> +	 *
> +	 * Without this when evicting the inodes it may fail in the
> +	 * kill_anon_super(), which will trigger a warning when
> +	 * destroying the fscrypt keyring and then possibly trigger
> +	 * a further crash in ceph module when iput() the inodes.
> +	 */
> +	sync_filesystem(s);
> +	fsc->mdsc->stopping = CEPH_MDSC_STOPPING_FLUSHED;
> +
>  	kill_anon_super(s);
>  
>  	fsc->client->extra_mon_dispatch = NULL;
> -- 
> 2.31.1
> 
