Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 236BC6CF8C0
	for <lists+ceph-devel@lfdr.de>; Thu, 30 Mar 2023 03:34:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229687AbjC3BeI (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 29 Mar 2023 21:34:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229580AbjC3BeH (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 29 Mar 2023 21:34:07 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6F2E49EF
        for <ceph-devel@vger.kernel.org>; Wed, 29 Mar 2023 18:33:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1680140000;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=GlAE9AJXV6tV9okv1er8Db2gV699mLnwb/leqM3i/KQ=;
        b=bLhu4gJ2n+Fyn/cMRxzTiPDkr4ykdQs5/BYtHqYbe1l7rbeHOCpwl9rrYC5DANqqgJXqL5
        fH7Wzgur3GyVh+9AmncFgoTjd8FqQN97EHzsCZo0F39iVx54LgAHT9FaDH9vnE5qJS2fxz
        Op+0rJ14BlLOLBr+jueylZt63ma9hTE=
Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com
 [209.85.214.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-159-CWCJ-gaxMeen5GO7BvI9QQ-1; Wed, 29 Mar 2023 21:33:19 -0400
X-MC-Unique: CWCJ-gaxMeen5GO7BvI9QQ-1
Received: by mail-pl1-f200.google.com with SMTP id h4-20020a170902f54400b001a1f5f00f3fso10248688plf.2
        for <ceph-devel@vger.kernel.org>; Wed, 29 Mar 2023 18:33:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680139998;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=GlAE9AJXV6tV9okv1er8Db2gV699mLnwb/leqM3i/KQ=;
        b=CPJ9ub8wPJgA5M3EXxyS6ofbhGMoZH4nTMmJloRIJ80oS31MhG6iwX4IaIKEfOcmOD
         iIY8G6NqY1s61LceXUGP6s8kZYHMmA8DrSJ5uwuz5kixTt3uLEGsnnV+8mH0tlIXAAf3
         I9lbGEeM58le0Vy070fu7salm07Ge4204DVwnSk02VVVOx/HPJgDWXt04ZhwjE4ogpLU
         m9sII4mdX32XurzGeBw8R4BiCJV8NZIjPJjd4kfIrCA9SexB9TJkCvy1DnvXS2Tze2y4
         /Riobtc+o8tGEauOutmnu3tgBOyEOSa3is+yzo9uKh4qI/6aFM5xZZWT1g3pRLvS6FXk
         feaQ==
X-Gm-Message-State: AAQBX9c7JQTIHyTw5MYEm/eXU50p3vQy3TluMW3zvaLtNmOvUp1QOniW
        x/30WSYh5mOFytNLBM5ufoWs+Pz9jIbWBGnwe3p+j/pb9Txm+L63DZZxi8RbZ3ZgYl8RrXsIY2Z
        PvjU/bxiOyg/cY8dYM2aD7Q==
X-Received: by 2002:a17:90b:2245:b0:23f:634a:6c7 with SMTP id hk5-20020a17090b224500b0023f634a06c7mr4464311pjb.15.1680139997961;
        Wed, 29 Mar 2023 18:33:17 -0700 (PDT)
X-Google-Smtp-Source: AKy350auQ8eQku5jbJxVHgn9Gfb69rREaVpdaMpvNVUdDpdXNTdo+8gOzCXgR1gGvE2YaEJajHZaTA==
X-Received: by 2002:a17:90b:2245:b0:23f:634a:6c7 with SMTP id hk5-20020a17090b224500b0023f634a06c7mr4464286pjb.15.1680139997456;
        Wed, 29 Mar 2023 18:33:17 -0700 (PDT)
Received: from [10.72.12.51] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id s1-20020a17090a948100b0023d386e4806sm2011133pjo.57.2023.03.29.18.33.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 29 Mar 2023 18:33:17 -0700 (PDT)
Message-ID: <cc0f3aac-39be-4dd3-dc5e-611923680047@redhat.com>
Date:   Thu, 30 Mar 2023 09:33:10 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [PATCH v4] ceph: drop the messages from MDS when unmounting
Content-Language: en-US
To:     =?UTF-8?Q?Lu=c3=ads_Henriques?= <lhenriques@suse.de>
Cc:     idryomov@gmail.com, ceph-devel@vger.kernel.org, jlayton@kernel.org,
        vshankar@redhat.com, mchangir@redhat.com
References: <20230327030508.310588-1-xiubli@redhat.com>
 <87v8ij4o3m.fsf@suse.de>
From:   Xiubo Li <xiubli@redhat.com>
In-Reply-To: <87v8ij4o3m.fsf@suse.de>
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


On 29/03/2023 22:41, Luís Henriques wrote:
> Hi!
>
> I finally got to have a look at this patch because I found that the
> version you sent along with fscrypt v17 is a bit different from what's in
> the testing branch :-)

Yeah, after v17 I updated this and force pushed to the testing branch to 
run the test.

> xiubli@redhat.com writes:
>
>> From: Xiubo Li <xiubli@redhat.com>
>>
>> When unmounting and all the dirty buffer will be flushed and after
>> the last osd request is finished the last reference of the i_count
>> will be released. Then it will flush the dirty cap/snap to MDSs,
>> and the unmounting won't wait the possible acks, which will ihode
>> the inodes when updating the metadata locally but makes no sense
>> any more, of this. This will make the evict_inodes() to skip these
>> inodes.
>>
>> If encrypt is enabled the kernel generate a warning when removing
>> the encrypt keys when the skipped inodes still hold the keyring:
>>
>> WARNING: CPU: 4 PID: 168846 at fs/crypto/keyring.c:242 fscrypt_destroy_keyring+0x7e/0xd0
>> CPU: 4 PID: 168846 Comm: umount Tainted: G S  6.1.0-rc5-ceph-g72ead199864c #1
>> Hardware name: Supermicro SYS-5018R-WR/X10SRW-F, BIOS 2.0 12/17/2015
>> RIP: 0010:fscrypt_destroy_keyring+0x7e/0xd0
>> RSP: 0018:ffffc9000b277e28 EFLAGS: 00010202
>> RAX: 0000000000000002 RBX: ffff88810d52ac00 RCX: ffff88810b56aa00
>> RDX: 0000000080000000 RSI: ffffffff822f3a09 RDI: ffff888108f59000
>> RBP: ffff8881d394fb88 R08: 0000000000000028 R09: 0000000000000000
>> R10: 0000000000000001 R11: 11ff4fe6834fcd91 R12: ffff8881d394fc40
>> R13: ffff888108f59000 R14: ffff8881d394f800 R15: 0000000000000000
>> FS:  00007fd83f6f1080(0000) GS:ffff88885fd00000(0000) knlGS:0000000000000000
>> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>> CR2: 00007f918d417000 CR3: 000000017f89a005 CR4: 00000000003706e0
>> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
>> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
>> Call Trace:
>> <TASK>
>> generic_shutdown_super+0x47/0x120
>> kill_anon_super+0x14/0x30
>> ceph_kill_sb+0x36/0x90 [ceph]
>> deactivate_locked_super+0x29/0x60
>> cleanup_mnt+0xb8/0x140
>> task_work_run+0x67/0xb0
>> exit_to_user_mode_prepare+0x23d/0x240
>> syscall_exit_to_user_mode+0x25/0x60
>> do_syscall_64+0x40/0x80
>> entry_SYSCALL_64_after_hwframe+0x63/0xcd
>> RIP: 0033:0x7fd83dc39e9b
>>
>> Later the kernel will crash when iput() the inodes and dereferencing
>> the "sb->s_master_keys", which has been released by the
>> generic_shutdown_super().
>>
>> URL: https://tracker.ceph.com/issues/58126
>> URL: https://tracker.ceph.com/issues/59162
>> Signed-off-by: Xiubo Li <xiubli@redhat.com>
>> ---
>>
>> Only updated the 2/2 patch since series V3:
>>
>> Changed in V4:
>> - Always resend the session close requests to MDS when receives
>>    new messages just before dropping them.
>> - Even receives a corrupted message we should increase the s_seq
>>    and resend the session close requests.
>>
>>
>>   fs/ceph/caps.c       |  6 ++++-
>>   fs/ceph/mds_client.c | 14 ++++++++---
>>   fs/ceph/mds_client.h | 11 ++++++++-
>>   fs/ceph/quota.c      |  9 ++++---
>>   fs/ceph/snap.c       | 10 ++++----
>>   fs/ceph/super.c      | 57 ++++++++++++++++++++++++++++++++++++++++++++
>>   fs/ceph/super.h      |  3 +++
>>   7 files changed, 96 insertions(+), 14 deletions(-)
>>
>> diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
>> index 6379c0070492..e1bb6d9c16f8 100644
>> --- a/fs/ceph/caps.c
>> +++ b/fs/ceph/caps.c
>> @@ -4222,6 +4222,9 @@ void ceph_handle_caps(struct ceph_mds_session *session,
>>   
>>   	dout("handle_caps from mds%d\n", session->s_mds);
>>   
>> +	if (!ceph_inc_stopping_blocker(mdsc, session))
>> +		return;
>> +
>>   	/* decode */
>>   	end = msg->front.iov_base + msg->front.iov_len;
>>   	if (msg->front.iov_len < sizeof(*h))
>> @@ -4323,7 +4326,6 @@ void ceph_handle_caps(struct ceph_mds_session *session,
>>   	     vino.snap, inode);
>>   
>>   	mutex_lock(&session->s_mutex);
>> -	inc_session_sequence(session);
>>   	dout(" mds%d seq %lld cap seq %u\n", session->s_mds, session->s_seq,
>>   	     (unsigned)seq);
>>   
>> @@ -4435,6 +4437,8 @@ void ceph_handle_caps(struct ceph_mds_session *session,
>>   done_unlocked:
>>   	iput(inode);
>>   out:
>> +	ceph_dec_stopping_blocker(mdsc);
>> +
>>   	ceph_put_string(extra_info.pool_ns);
>>   
>>   	/* Defer closing the sessions after s_mutex lock being released */
>> diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
>> index 85d639f75ea1..21ca41e5f68b 100644
>> --- a/fs/ceph/mds_client.c
>> +++ b/fs/ceph/mds_client.c
>> @@ -4877,6 +4877,9 @@ static void handle_lease(struct ceph_mds_client *mdsc,
>>   
>>   	dout("handle_lease from mds%d\n", mds);
>>   
>> +	if (!ceph_inc_stopping_blocker(mdsc, session))
>> +		return;
>> +
>>   	/* decode */
>>   	if (msg->front.iov_len < sizeof(*h) + sizeof(u32))
>>   		goto bad;
>> @@ -4895,8 +4898,6 @@ static void handle_lease(struct ceph_mds_client *mdsc,
>>   	     dname.len, dname.name);
>>   
>>   	mutex_lock(&session->s_mutex);
>> -	inc_session_sequence(session);
>> -
>>   	if (!inode) {
>>   		dout("handle_lease no inode %llx\n", vino.ino);
>>   		goto release;
>> @@ -4958,9 +4959,13 @@ static void handle_lease(struct ceph_mds_client *mdsc,
>>   out:
>>   	mutex_unlock(&session->s_mutex);
>>   	iput(inode);
>> +
>> +	ceph_dec_stopping_blocker(mdsc);
>>   	return;
>>   
>>   bad:
>> +	ceph_dec_stopping_blocker(mdsc);
>> +
>>   	pr_err("corrupt lease message\n");
>>   	ceph_msg_dump(msg);
>>   }
>> @@ -5156,6 +5161,9 @@ int ceph_mdsc_init(struct ceph_fs_client *fsc)
>>   	}
>>   
>>   	init_completion(&mdsc->safe_umount_waiters);
>> +	spin_lock_init(&mdsc->stopping_lock);
>> +	atomic_set(&mdsc->stopping_blockers, 0);
>> +	init_completion(&mdsc->stopping_waiter);
>>   	init_waitqueue_head(&mdsc->session_close_wq);
>>   	INIT_LIST_HEAD(&mdsc->waiting_for_map);
>>   	mdsc->quotarealms_inodes = RB_ROOT;
>> @@ -5270,7 +5278,7 @@ void send_flush_mdlog(struct ceph_mds_session *s)
>>   void ceph_mdsc_pre_umount(struct ceph_mds_client *mdsc)
>>   {
>>   	dout("pre_umount\n");
>> -	mdsc->stopping = 1;
>> +	mdsc->stopping = CEPH_MDSC_STOPPING_BEGAIN;
>>   
>>   	ceph_mdsc_iterate_sessions(mdsc, send_flush_mdlog, true);
>>   	ceph_mdsc_iterate_sessions(mdsc, lock_unlock_session, false);
>> diff --git a/fs/ceph/mds_client.h b/fs/ceph/mds_client.h
>> index 81a1f9a4ac3b..5bf32701c84c 100644
>> --- a/fs/ceph/mds_client.h
>> +++ b/fs/ceph/mds_client.h
>> @@ -398,6 +398,11 @@ struct cap_wait {
>>   	int			want;
>>   };
>>   
>> +enum {
>> +	CEPH_MDSC_STOPPING_BEGAIN = 1,
> Typo: I think you want to define this as "CEPH_MDSC_STOPPING_BEGIN"
> instead, right?

Yeah, good catch.

>> +	CEPH_MDSC_STOPPING_FLUSHED = 2,
>> +};
>> +
>>   /*
>>    * mds client state
>>    */
>> @@ -414,7 +419,11 @@ struct ceph_mds_client {
>>   	struct ceph_mds_session **sessions;    /* NULL for mds if no session */
>>   	atomic_t		num_sessions;
>>   	int                     max_sessions;  /* len of sessions array */
>> -	int                     stopping;      /* true if shutting down */
>> +
>> +	spinlock_t              stopping_lock;  /* protect snap_empty */
>> +	int                     stopping;      /* the stage of shutting down */
>> +	atomic_t                stopping_blockers;
>> +	struct completion	stopping_waiter;
>>   
>>   	atomic64_t		quotarealms_count; /* # realms with quota */
>>   	/*
>> diff --git a/fs/ceph/quota.c b/fs/ceph/quota.c
>> index 64592adfe48f..37b062783717 100644
>> --- a/fs/ceph/quota.c
>> +++ b/fs/ceph/quota.c
>> @@ -47,6 +47,9 @@ void ceph_handle_quota(struct ceph_mds_client *mdsc,
>>   	struct inode *inode;
>>   	struct ceph_inode_info *ci;
>>   
>> +	if (!ceph_inc_stopping_blocker(mdsc, session))
>> +		return;
>> +
>>   	if (msg->front.iov_len < sizeof(*h)) {
>>   		pr_err("%s corrupt message mds%d len %d\n", __func__,
>>   		       session->s_mds, (int)msg->front.iov_len);
>> @@ -54,11 +57,6 @@ void ceph_handle_quota(struct ceph_mds_client *mdsc,
>>   		return;
>>   	}
>>   
>> -	/* increment msg sequence number */
>> -	mutex_lock(&session->s_mutex);
>> -	inc_session_sequence(session);
>> -	mutex_unlock(&session->s_mutex);
>> -
>>   	/* lookup inode */
>>   	vino.ino = le64_to_cpu(h->ino);
>>   	vino.snap = CEPH_NOSNAP;
>> @@ -78,6 +76,7 @@ void ceph_handle_quota(struct ceph_mds_client *mdsc,
>>   	spin_unlock(&ci->i_ceph_lock);
>>   
>>   	iput(inode);
>> +	ceph_dec_stopping_blocker(mdsc);
> There are two 'return' statements in this function where function
> ceph_dec_stopping_blocker() isn't being called.
Good catch.
>>   }
>>   
>>   static struct ceph_quotarealm_inode *
>> diff --git a/fs/ceph/snap.c b/fs/ceph/snap.c
>> index aa8e0657fc03..23b31600ee3c 100644
>> --- a/fs/ceph/snap.c
>> +++ b/fs/ceph/snap.c
>> @@ -1011,6 +1011,9 @@ void ceph_handle_snap(struct ceph_mds_client *mdsc,
>>   	int locked_rwsem = 0;
>>   	bool close_sessions = false;
>>   
>> +	if (!ceph_inc_stopping_blocker(mdsc, session))
>> +		return;
>> +
>>   	/* decode */
>>   	if (msg->front.iov_len < sizeof(*h))
>>   		goto bad;
>> @@ -1026,10 +1029,6 @@ void ceph_handle_snap(struct ceph_mds_client *mdsc,
>>   	dout("%s from mds%d op %s split %llx tracelen %d\n", __func__,
>>   	     mds, ceph_snap_op_name(op), split, trace_len);
>>   
>> -	mutex_lock(&session->s_mutex);
>> -	inc_session_sequence(session);
>> -	mutex_unlock(&session->s_mutex);
>> -
>>   	down_write(&mdsc->snap_rwsem);
>>   	locked_rwsem = 1;
>>   
>> @@ -1134,12 +1133,15 @@ void ceph_handle_snap(struct ceph_mds_client *mdsc,
>>   	up_write(&mdsc->snap_rwsem);
>>   
>>   	flush_snaps(mdsc);
>> +	ceph_dec_stopping_blocker(mdsc);
>>   	return;
>>   
>>   bad:
>>   	pr_err("%s corrupt snap message from mds%d\n", __func__, mds);
>>   	ceph_msg_dump(msg);
>>   out:
>> +	ceph_dec_stopping_blocker(mdsc);
>> +
>>   	if (locked_rwsem)
>>   		up_write(&mdsc->snap_rwsem);
>>   
>> diff --git a/fs/ceph/super.c b/fs/ceph/super.c
>> index 4b0a070d5c6d..f5ddd4abc0ab 100644
>> --- a/fs/ceph/super.c
>> +++ b/fs/ceph/super.c
>> @@ -1467,15 +1467,72 @@ static int ceph_init_fs_context(struct fs_context *fc)
>>   	return -ENOMEM;
>>   }
>>   
>> +/*
>> + * Return true if mdsc successfully increase blocker counter,
>> + * or false if the mdsc is in stopping and flushed state.
>> + */
>> +bool ceph_inc_stopping_blocker(struct ceph_mds_client *mdsc,
>> +			       struct ceph_mds_session *session)
>> +{
>> +	mutex_lock(&session->s_mutex);
>> +	inc_session_sequence(session);
>> +	mutex_unlock(&session->s_mutex);
>> +
>> +	spin_lock(&mdsc->stopping_lock);
>> +	if (mdsc->stopping >= CEPH_MDSC_STOPPING_FLUSHED) {
>> +		spin_unlock(&mdsc->stopping_lock);
>> +		return false;
>> +	}
>> +	atomic_inc(&mdsc->stopping_blockers);
>> +	spin_unlock(&mdsc->stopping_lock);
>> +	return true;
>> +}
>> +
>> +void ceph_dec_stopping_blocker(struct ceph_mds_client *mdsc)
>> +{
>> +	spin_lock(&mdsc->stopping_lock);
>> +	if (!atomic_dec_return(&mdsc->stopping_blockers) &&
>> +	    mdsc->stopping >= CEPH_MDSC_STOPPING_FLUSHED)
>> +		complete_all(&mdsc->stopping_waiter);
>> +	spin_unlock(&mdsc->stopping_lock);
>> +}
>> +
>>   static void ceph_kill_sb(struct super_block *s)
>>   {
>>   	struct ceph_fs_client *fsc = ceph_sb_to_client(s);
>> +	bool wait;
>>   
>>   	dout("kill_sb %p\n", s);
>>   
>>   	ceph_mdsc_pre_umount(fsc->mdsc);
>>   	flush_fs_workqueues(fsc);
>>   
>> +	/*
>> +	 * Though the kill_anon_super() will finally trigger the
>> +	 * sync_filesystem() anyway, we still need to do it here and
>> +	 * then bump the stage of shutdown. This will allow us to
>> +	 * drop any further message, which will increase the inodes'
>> +	 * i_count reference counters but makes no sense any more,
>> +	 * from MDSs.
>> +	 *
>> +	 * Without this when evicting the inodes it may fail in the
>> +	 * kill_anon_super(), which will trigger a warning when
>> +	 * destroying the fscrypt keyring and then possibly trigger
>> +	 * a further crash in ceph module when the iput() tries to
>> +	 * evict the inodes later.
>> +	 */
>> +	sync_filesystem(s);
>> +
>> +	spin_lock(&fsc->mdsc->stopping_lock);
>> +	fsc->mdsc->stopping = CEPH_MDSC_STOPPING_FLUSHED;
>> +	wait = !!atomic_read(&fsc->mdsc->stopping_blockers);
>> +	spin_unlock(&fsc->mdsc->stopping_lock);
>> +
>> +	while (wait || atomic_read(&fsc->mdsc->stopping_blockers)) {
>> +		wait = false;
>> +		wait_for_completion(&fsc->mdsc->stopping_waiter);
>> +	}
> This is a odd construct :-) I'd rather see it like this:
>
> 	if (wait) {
> 		while (atomic_read(&fsc->mdsc->stopping_blockers))
> 			wait_for_completion(&fsc->mdsc->stopping_waiter);
> 	}
This also looks good to me. As I remembered when reading the kernel code 
I just saw another place in VFS is also doing like this and I just 
followed it.
> But... even with my suggestion, can't we deadlock here if we get preempted
> just before the wait_for_completion() and ceph_dec_stopping_blocker() is
> executed?

Good question. Actually it won't.

The 'x->done' member in the completion will be initialized as 0, and the 
complete_all() will set it to 'UINT_MAX'. And only when 'x->done == 0' 
will the wait_for_completion() go to sleep and wait.

Thanks

- Xiubo

>
> Cheers,

