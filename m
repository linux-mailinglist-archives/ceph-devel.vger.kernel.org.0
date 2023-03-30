Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8458D6CFA69
	for <lists+ceph-devel@lfdr.de>; Thu, 30 Mar 2023 06:52:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229886AbjC3Ewj (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 30 Mar 2023 00:52:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229552AbjC3Ewi (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 30 Mar 2023 00:52:38 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8AA530EB
        for <ceph-devel@vger.kernel.org>; Wed, 29 Mar 2023 21:51:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1680151912;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=FMcD/SM0OXJcgjQULxINcDTrmc+MlsbqpYVp4g3LS+s=;
        b=Wh5r6sMt6esQd1KT2xKDMOyOViIjO8V/QNRdaQvVnGfuYpa2cOBouaKQNo3DQKfhSofRbi
        Vb7nHcjcmxHDX+8pqVuoYpIsW7icL6Q5R8ESon4oVvMMtsys66A9+nkCZsAhX4xt+hXkeO
        grLZ0SB2DDp4FP8P7Jyr9zAEedzDWNA=
Received: from mail-pf1-f199.google.com (mail-pf1-f199.google.com
 [209.85.210.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-294-IW1dww92OgqSAWxZD44Q6Q-1; Thu, 30 Mar 2023 00:51:48 -0400
X-MC-Unique: IW1dww92OgqSAWxZD44Q6Q-1
Received: by mail-pf1-f199.google.com with SMTP id d12-20020a056a0024cc00b006256990dddeso8224675pfv.9
        for <ceph-devel@vger.kernel.org>; Wed, 29 Mar 2023 21:51:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680151908;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=FMcD/SM0OXJcgjQULxINcDTrmc+MlsbqpYVp4g3LS+s=;
        b=LfZCNpHC44IbNRgjI99OGHAuKwaHyNx8K90qfbb3KelSNimJQZr/ZlEeXyVN6suRwG
         rVC6ERGuPvTw0+2C18Rok2WK/EHdl/0AttzGmfONxudNd0411Z1+0zpubkQRzadFmY5A
         aX+LkrGV5wPiZmM0Ye83rCLRpvQcWrcQIapokAdTqHreOKoDCoZ2/wfzpRooOTOdOnlP
         CvX3VV6twCTHxQQpDx3CGmAhn/Pm72BoItZHZCZw/fyDaJjxLFpMHgZGqOM5LbbQcImS
         tWw4ShYCizroBM7j7a6OPPLsHuNZUoyALD9Ck7LFbIjYSyVKz43zl9WbJIgmgWdOcAjI
         hAeg==
X-Gm-Message-State: AO0yUKVHEKpztpGWIJMcpYjBPuq4+UYb7z4nf9ToOaFBOUr077ebkTho
        S7I9Ngq/K4XjIdkNKJJGQYkOT51DSjtwKdEKi9VPNtYi0wXFEl/4rgUrGWrrwoW7Vlw4P8mkxJQ
        yOXJmI7AmMUoUGnrRrkhvCg==
X-Received: by 2002:a05:6a20:29a0:b0:d9:e45d:95cd with SMTP id f32-20020a056a2029a000b000d9e45d95cdmr17814682pzh.17.1680151907553;
        Wed, 29 Mar 2023 21:51:47 -0700 (PDT)
X-Google-Smtp-Source: AK7set+Se39+ikgj41sWnuRbMZKh6hPDnSkzOPZ+vDsnSPzd1Vo391QHeCswG8SULxPaB2UFhm8zrA==
X-Received: by 2002:a05:6a20:29a0:b0:d9:e45d:95cd with SMTP id f32-20020a056a2029a000b000d9e45d95cdmr17814665pzh.17.1680151907086;
        Wed, 29 Mar 2023 21:51:47 -0700 (PDT)
Received: from [10.72.12.51] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id h10-20020a056a001a4a00b0062dcaa50a9asm259133pfv.58.2023.03.29.21.51.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 29 Mar 2023 21:51:46 -0700 (PDT)
Message-ID: <20c54387-6a9f-c505-9452-3506abc0c021@redhat.com>
Date:   Thu, 30 Mar 2023 12:51:40 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [PATCH v17 68/71] ceph: drop the messages from MDS when
 unmounting
Content-Language: en-US
To:     idryomov@gmail.com, ceph-devel@vger.kernel.org
Cc:     jlayton@kernel.org, vshankar@redhat.com, mchangir@redhat.com,
        lhenriques@suse.de
References: <20230323065525.201322-1-xiubli@redhat.com>
 <20230323065525.201322-69-xiubli@redhat.com>
From:   Xiubo Li <xiubli@redhat.com>
In-Reply-To: <20230323065525.201322-69-xiubli@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

I updated this patch to address Luis' comments and fix another bug in:

V4: https://patchwork.kernel.org/project/ceph-devel/list/?series=734003

V5: https://patchwork.kernel.org/project/ceph-devel/list/?series=735196

Thanks

- Xiubo


On 23/03/2023 14:55, xiubli@redhat.com wrote:
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
> Later the kernel will crash when iput() the inodes and dereferencing
> the "sb->s_master_keys", which has been released by the
> generic_shutdown_super().
>
> URL: https://tracker.ceph.com/issues/58126
> Signed-off-by: Xiubo Li <xiubli@redhat.com>
> ---
>   fs/ceph/caps.c       |  5 +++++
>   fs/ceph/mds_client.c | 12 +++++++++-
>   fs/ceph/mds_client.h | 11 +++++++++-
>   fs/ceph/quota.c      |  4 ++++
>   fs/ceph/snap.c       |  6 +++++
>   fs/ceph/super.c      | 52 ++++++++++++++++++++++++++++++++++++++++++++
>   fs/ceph/super.h      |  2 ++
>   7 files changed, 90 insertions(+), 2 deletions(-)
>
> diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
> index 6379c0070492..2a62e095fff3 100644
> --- a/fs/ceph/caps.c
> +++ b/fs/ceph/caps.c
> @@ -4222,6 +4222,9 @@ void ceph_handle_caps(struct ceph_mds_session *session,
>   
>   	dout("handle_caps from mds%d\n", session->s_mds);
>   
> +	if (!ceph_inc_stopping_blocker(mdsc))
> +		return;
> +
>   	/* decode */
>   	end = msg->front.iov_base + msg->front.iov_len;
>   	if (msg->front.iov_len < sizeof(*h))
> @@ -4435,6 +4438,8 @@ void ceph_handle_caps(struct ceph_mds_session *session,
>   done_unlocked:
>   	iput(inode);
>   out:
> +	ceph_dec_stopping_blocker(mdsc);
> +
>   	ceph_put_string(extra_info.pool_ns);
>   
>   	/* Defer closing the sessions after s_mutex lock being released */
> diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
> index 85d639f75ea1..b8d6cca16005 100644
> --- a/fs/ceph/mds_client.c
> +++ b/fs/ceph/mds_client.c
> @@ -4877,6 +4877,9 @@ static void handle_lease(struct ceph_mds_client *mdsc,
>   
>   	dout("handle_lease from mds%d\n", mds);
>   
> +	if (!ceph_inc_stopping_blocker(mdsc))
> +		return;
> +
>   	/* decode */
>   	if (msg->front.iov_len < sizeof(*h) + sizeof(u32))
>   		goto bad;
> @@ -4958,9 +4961,13 @@ static void handle_lease(struct ceph_mds_client *mdsc,
>   out:
>   	mutex_unlock(&session->s_mutex);
>   	iput(inode);
> +
> +	ceph_dec_stopping_blocker(mdsc);
>   	return;
>   
>   bad:
> +	ceph_dec_stopping_blocker(mdsc);
> +
>   	pr_err("corrupt lease message\n");
>   	ceph_msg_dump(msg);
>   }
> @@ -5156,6 +5163,9 @@ int ceph_mdsc_init(struct ceph_fs_client *fsc)
>   	}
>   
>   	init_completion(&mdsc->safe_umount_waiters);
> +	spin_lock_init(&mdsc->stopping_lock);
> +	atomic_set(&mdsc->stopping_blockers, 0);
> +	init_completion(&mdsc->stopping_waiter);
>   	init_waitqueue_head(&mdsc->session_close_wq);
>   	INIT_LIST_HEAD(&mdsc->waiting_for_map);
>   	mdsc->quotarealms_inodes = RB_ROOT;
> @@ -5270,7 +5280,7 @@ void send_flush_mdlog(struct ceph_mds_session *s)
>   void ceph_mdsc_pre_umount(struct ceph_mds_client *mdsc)
>   {
>   	dout("pre_umount\n");
> -	mdsc->stopping = 1;
> +	mdsc->stopping = CEPH_MDSC_STOPPING_BEGAIN;
>   
>   	ceph_mdsc_iterate_sessions(mdsc, send_flush_mdlog, true);
>   	ceph_mdsc_iterate_sessions(mdsc, lock_unlock_session, false);
> diff --git a/fs/ceph/mds_client.h b/fs/ceph/mds_client.h
> index 81a1f9a4ac3b..5bf32701c84c 100644
> --- a/fs/ceph/mds_client.h
> +++ b/fs/ceph/mds_client.h
> @@ -398,6 +398,11 @@ struct cap_wait {
>   	int			want;
>   };
>   
> +enum {
> +	CEPH_MDSC_STOPPING_BEGAIN = 1,
> +	CEPH_MDSC_STOPPING_FLUSHED = 2,
> +};
> +
>   /*
>    * mds client state
>    */
> @@ -414,7 +419,11 @@ struct ceph_mds_client {
>   	struct ceph_mds_session **sessions;    /* NULL for mds if no session */
>   	atomic_t		num_sessions;
>   	int                     max_sessions;  /* len of sessions array */
> -	int                     stopping;      /* true if shutting down */
> +
> +	spinlock_t              stopping_lock;  /* protect snap_empty */
> +	int                     stopping;      /* the stage of shutting down */
> +	atomic_t                stopping_blockers;
> +	struct completion	stopping_waiter;
>   
>   	atomic64_t		quotarealms_count; /* # realms with quota */
>   	/*
> diff --git a/fs/ceph/quota.c b/fs/ceph/quota.c
> index 64592adfe48f..3309ae071739 100644
> --- a/fs/ceph/quota.c
> +++ b/fs/ceph/quota.c
> @@ -47,6 +47,9 @@ void ceph_handle_quota(struct ceph_mds_client *mdsc,
>   	struct inode *inode;
>   	struct ceph_inode_info *ci;
>   
> +	if (!ceph_inc_stopping_blocker(mdsc))
> +		return;
> +
>   	if (msg->front.iov_len < sizeof(*h)) {
>   		pr_err("%s corrupt message mds%d len %d\n", __func__,
>   		       session->s_mds, (int)msg->front.iov_len);
> @@ -78,6 +81,7 @@ void ceph_handle_quota(struct ceph_mds_client *mdsc,
>   	spin_unlock(&ci->i_ceph_lock);
>   
>   	iput(inode);
> +	ceph_dec_stopping_blocker(mdsc);
>   }
>   
>   static struct ceph_quotarealm_inode *
> diff --git a/fs/ceph/snap.c b/fs/ceph/snap.c
> index aa8e0657fc03..2775d526a6e0 100644
> --- a/fs/ceph/snap.c
> +++ b/fs/ceph/snap.c
> @@ -1011,6 +1011,9 @@ void ceph_handle_snap(struct ceph_mds_client *mdsc,
>   	int locked_rwsem = 0;
>   	bool close_sessions = false;
>   
> +	if (!ceph_inc_stopping_blocker(mdsc))
> +		return;
> +
>   	/* decode */
>   	if (msg->front.iov_len < sizeof(*h))
>   		goto bad;
> @@ -1134,12 +1137,15 @@ void ceph_handle_snap(struct ceph_mds_client *mdsc,
>   	up_write(&mdsc->snap_rwsem);
>   
>   	flush_snaps(mdsc);
> +	ceph_dec_stopping_blocker(mdsc);
>   	return;
>   
>   bad:
>   	pr_err("%s corrupt snap message from mds%d\n", __func__, mds);
>   	ceph_msg_dump(msg);
>   out:
> +	ceph_dec_stopping_blocker(mdsc);
> +
>   	if (locked_rwsem)
>   		up_write(&mdsc->snap_rwsem);
>   
> diff --git a/fs/ceph/super.c b/fs/ceph/super.c
> index 4b0a070d5c6d..4a6dc47bc4e1 100644
> --- a/fs/ceph/super.c
> +++ b/fs/ceph/super.c
> @@ -1467,15 +1467,67 @@ static int ceph_init_fs_context(struct fs_context *fc)
>   	return -ENOMEM;
>   }
>   
> +/*
> + * Return true if mdsc successfully increase blocker counter,
> + * or false if the mdsc is in stopping and flushed state.
> + */
> +bool ceph_inc_stopping_blocker(struct ceph_mds_client *mdsc)
> +{
> +	spin_lock(&mdsc->stopping_lock);
> +	if (mdsc->stopping >= CEPH_MDSC_STOPPING_FLUSHED) {
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
> +	    mdsc->stopping >= CEPH_MDSC_STOPPING_FLUSHED)
> +		complete_all(&mdsc->stopping_waiter);
> +	spin_unlock(&mdsc->stopping_lock);
> +}
> +
>   static void ceph_kill_sb(struct super_block *s)
>   {
>   	struct ceph_fs_client *fsc = ceph_sb_to_client(s);
> +	bool wait;
>   
>   	dout("kill_sb %p\n", s);
>   
>   	ceph_mdsc_pre_umount(fsc->mdsc);
>   	flush_fs_workqueues(fsc);
>   
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
> +	fsc->mdsc->stopping = CEPH_MDSC_STOPPING_FLUSHED;
> +	wait = !!atomic_read(&fsc->mdsc->stopping_blockers);
> +	spin_unlock(&fsc->mdsc->stopping_lock);
> +
> +	while (wait || atomic_read(&fsc->mdsc->stopping_blockers)) {
> +		wait = false;
> +		wait_for_completion(&fsc->mdsc->stopping_waiter);
> +	}
> +
>   	kill_anon_super(s);
>   
>   	fsc->client->extra_mon_dispatch = NULL;
> diff --git a/fs/ceph/super.h b/fs/ceph/super.h
> index a785e5cb9b40..5659821fa88c 100644
> --- a/fs/ceph/super.h
> +++ b/fs/ceph/super.h
> @@ -1398,4 +1398,6 @@ extern bool ceph_quota_update_statfs(struct ceph_fs_client *fsc,
>   				     struct kstatfs *buf);
>   extern void ceph_cleanup_quotarealms_inodes(struct ceph_mds_client *mdsc);
>   
> +bool ceph_inc_stopping_blocker(struct ceph_mds_client *mdsc);
> +void ceph_dec_stopping_blocker(struct ceph_mds_client *mdsc);
>   #endif /* _FS_CEPH_SUPER_H */

-- 
Best Regards,

Xiubo Li (李秀波)

Email: xiubli@redhat.com/xiubli@ibm.com
Slack: @Xiubo Li

