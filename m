Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 43636723C37
	for <lists+ceph-devel@lfdr.de>; Tue,  6 Jun 2023 10:52:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237293AbjFFIwA (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 6 Jun 2023 04:52:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232587AbjFFIv7 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 6 Jun 2023 04:51:59 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 301BAF4
        for <ceph-devel@vger.kernel.org>; Tue,  6 Jun 2023 01:51:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1686041473;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=LKSKYbMdiUIRmobWG6txK4hDPdxW2M2+3ZYN2ooPCSc=;
        b=MR509aEzvI/ylQf/72z3NFONalDMIM1KeZ0GikeM4FrBCuZ4qeFUGdkTH3esR9E9w8a/bC
        iV7CjK3qpvIEILBgNEYB5jvxV2cGYRvDCEqsSX20A7wudu/AVuu/dotebRwK4HX7g+gL8A
        YUN+osuv8QR6UbJQ2Pw2ZDlxkMl6EdU=
Received: from mail-il1-f198.google.com (mail-il1-f198.google.com
 [209.85.166.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-338-bNsr-kNGNhiiH57QR5QSCw-1; Tue, 06 Jun 2023 04:50:25 -0400
X-MC-Unique: bNsr-kNGNhiiH57QR5QSCw-1
Received: by mail-il1-f198.google.com with SMTP id e9e14a558f8ab-33b3f549628so46975235ab.0
        for <ceph-devel@vger.kernel.org>; Tue, 06 Jun 2023 01:50:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686041424; x=1688633424;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=LKSKYbMdiUIRmobWG6txK4hDPdxW2M2+3ZYN2ooPCSc=;
        b=jl5OEUmxTkdOP/ne4lfUX9VRWyNkpmjreJ2izUQTalEb9k2K2MjcRVauHyxVqhif+u
         dbQSvek1cpEkrChzoi5qFdHYy8C5ptw8v2K+v1StcFC4yFNY9Cb38j2H7CTeed4ZZ5O0
         iMqDwf20sEG0vO9wRC5NaMfifzrPFh4zTBNUPrqq13rGj0qTj23suNPc8eNh3vcB6f9t
         kGLoxlTd93w9fYCCMlG+QO1Za1ZlhGz/7xqrweLML6agFnP5iatF9scAuGfb13HDAqPf
         zeXCWB4wKJnFrFx342rAXWZP1o6xCQXfD5OqUo6im5FJJhPFAQQnftVyuBddJe2qQ7XP
         3scw==
X-Gm-Message-State: AC+VfDxVmt2lVJawlbaLIUBH58gN+ybneEo7+gBiujje/hs++8yfsVLe
        x2YchWvXuoGqrc7icsts/oL9iY/00uJ8OAqahcvwojbNoxmwP+zliEKTUWS8LIOqvo8dAXwnj2k
        TRfze/dmMkfZkfH0s4bH1Tw==
X-Received: by 2002:a92:d30d:0:b0:331:cd3:90a7 with SMTP id x13-20020a92d30d000000b003310cd390a7mr1643728ila.17.1686041424161;
        Tue, 06 Jun 2023 01:50:24 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ4ClgEel9BcjYx08nglsxpbEQKQTW6OR+NhJ2efXmbfhCjpp9AOAXZKmFt4YU91tJXMu0yEng==
X-Received: by 2002:a92:d30d:0:b0:331:cd3:90a7 with SMTP id x13-20020a92d30d000000b003310cd390a7mr1643703ila.17.1686041423774;
        Tue, 06 Jun 2023 01:50:23 -0700 (PDT)
Received: from [10.72.12.128] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id u36-20020a631424000000b0053474697607sm7032054pgl.4.2023.06.06.01.50.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 06 Jun 2023 01:50:23 -0700 (PDT)
Message-ID: <8b4024cf-a691-9162-9fe3-61fba77caa07@redhat.com>
Date:   Tue, 6 Jun 2023 16:50:17 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH v2 1/2] ceph: drop the messages from MDS when unmounting
Content-Language: en-US
To:     Milind Changire <mchangir@redhat.com>
Cc:     idryomov@gmail.com, ceph-devel@vger.kernel.org, jlayton@kernel.org,
        vshankar@redhat.com, lhenriques@suse.de
References: <20230606033212.1068823-1-xiubli@redhat.com>
 <20230606033212.1068823-2-xiubli@redhat.com>
 <CAED=hWBfB42hfEJPPaE3WNHZM-n_UMDe9HQbUwuMTHYAuRZX+w@mail.gmail.com>
From:   Xiubo Li <xiubli@redhat.com>
In-Reply-To: <CAED=hWBfB42hfEJPPaE3WNHZM-n_UMDe9HQbUwuMTHYAuRZX+w@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


On 6/6/23 15:47, Milind Changire wrote:
> nits in commit message:
> * s/When unmounting and all/When unmounting and ???/
> Is something missing after *and* or has been dropped ?
> Please remove *and* if something has been dropped or
> add it after *and* if it was forgotten to be added
>
> * s/ihode/ihold/

Good catch, will fix it.

Thanks

- Xiubo


> -----
> Otherwise, it looks good to me.
>
> Reviewed-by: Milind Changire <mchangir@redhat.com>
>
> On Tue, Jun 6, 2023 at 9:04 AM <xiubli@redhat.com> wrote:
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
>>   fs/ceph/caps.c       |  6 ++-
>>   fs/ceph/mds_client.c | 14 +++++--
>>   fs/ceph/mds_client.h | 11 +++++-
>>   fs/ceph/quota.c      | 14 +++----
>>   fs/ceph/snap.c       | 10 +++--
>>   fs/ceph/super.c      | 88 +++++++++++++++++++++++++++++++++++++++++++-
>>   fs/ceph/super.h      |  5 +++
>>   7 files changed, 131 insertions(+), 17 deletions(-)
>>
>> diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
>> index ccd4791a5e71..74ba335af25d 100644
>> --- a/fs/ceph/caps.c
>> +++ b/fs/ceph/caps.c
>> @@ -4235,6 +4235,9 @@ void ceph_handle_caps(struct ceph_mds_session *session,
>>
>>          dout("handle_caps from mds%d\n", session->s_mds);
>>
>> +       if (!ceph_inc_mds_stopping_blocker(mdsc, session))
>> +               return;
>> +
>>          /* decode */
>>          end = msg->front.iov_base + msg->front.iov_len;
>>          if (msg->front.iov_len < sizeof(*h))
>> @@ -4336,7 +4339,6 @@ void ceph_handle_caps(struct ceph_mds_session *session,
>>               vino.snap, inode);
>>
>>          mutex_lock(&session->s_mutex);
>> -       inc_session_sequence(session);
>>          dout(" mds%d seq %lld cap seq %u\n", session->s_mds, session->s_seq,
>>               (unsigned)seq);
>>
>> @@ -4448,6 +4450,8 @@ void ceph_handle_caps(struct ceph_mds_session *session,
>>   done_unlocked:
>>          iput(inode);
>>   out:
>> +       ceph_dec_mds_stopping_blocker(mdsc);
>> +
>>          ceph_put_string(extra_info.pool_ns);
>>
>>          /* Defer closing the sessions after s_mutex lock being released */
>> diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
>> index 6a82b0708343..0a70a2438cb2 100644
>> --- a/fs/ceph/mds_client.c
>> +++ b/fs/ceph/mds_client.c
>> @@ -4904,6 +4904,9 @@ static void handle_lease(struct ceph_mds_client *mdsc,
>>
>>          dout("handle_lease from mds%d\n", mds);
>>
>> +       if (!ceph_inc_mds_stopping_blocker(mdsc, session))
>> +               return;
>> +
>>          /* decode */
>>          if (msg->front.iov_len < sizeof(*h) + sizeof(u32))
>>                  goto bad;
>> @@ -4922,8 +4925,6 @@ static void handle_lease(struct ceph_mds_client *mdsc,
>>               dname.len, dname.name);
>>
>>          mutex_lock(&session->s_mutex);
>> -       inc_session_sequence(session);
>> -
>>          if (!inode) {
>>                  dout("handle_lease no inode %llx\n", vino.ino);
>>                  goto release;
>> @@ -4985,9 +4986,13 @@ static void handle_lease(struct ceph_mds_client *mdsc,
>>   out:
>>          mutex_unlock(&session->s_mutex);
>>          iput(inode);
>> +
>> +       ceph_dec_mds_stopping_blocker(mdsc);
>>          return;
>>
>>   bad:
>> +       ceph_dec_mds_stopping_blocker(mdsc);
>> +
>>          pr_err("corrupt lease message\n");
>>          ceph_msg_dump(msg);
>>   }
>> @@ -5183,6 +5188,9 @@ int ceph_mdsc_init(struct ceph_fs_client *fsc)
>>          }
>>
>>          init_completion(&mdsc->safe_umount_waiters);
>> +       spin_lock_init(&mdsc->stopping_lock);
>> +       atomic_set(&mdsc->stopping_blockers, 0);
>> +       init_completion(&mdsc->stopping_waiter);
>>          init_waitqueue_head(&mdsc->session_close_wq);
>>          INIT_LIST_HEAD(&mdsc->waiting_for_map);
>>          mdsc->quotarealms_inodes = RB_ROOT;
>> @@ -5297,7 +5305,7 @@ void send_flush_mdlog(struct ceph_mds_session *s)
>>   void ceph_mdsc_pre_umount(struct ceph_mds_client *mdsc)
>>   {
>>          dout("pre_umount\n");
>> -       mdsc->stopping = 1;
>> +       mdsc->stopping = CEPH_MDSC_STOPPING_BEGIN;
>>
>>          ceph_mdsc_iterate_sessions(mdsc, send_flush_mdlog, true);
>>          ceph_mdsc_iterate_sessions(mdsc, lock_unlock_session, false);
>> diff --git a/fs/ceph/mds_client.h b/fs/ceph/mds_client.h
>> index 82165f09a516..351d92f7fc4f 100644
>> --- a/fs/ceph/mds_client.h
>> +++ b/fs/ceph/mds_client.h
>> @@ -398,6 +398,11 @@ struct cap_wait {
>>          int                     want;
>>   };
>>
>> +enum {
>> +       CEPH_MDSC_STOPPING_BEGIN = 1,
>> +       CEPH_MDSC_STOPPING_FLUSHED = 2,
>> +};
>> +
>>   /*
>>    * mds client state
>>    */
>> @@ -414,7 +419,11 @@ struct ceph_mds_client {
>>          struct ceph_mds_session **sessions;    /* NULL for mds if no session */
>>          atomic_t                num_sessions;
>>          int                     max_sessions;  /* len of sessions array */
>> -       int                     stopping;      /* true if shutting down */
>> +
>> +       spinlock_t              stopping_lock;  /* protect snap_empty */
>> +       int                     stopping;      /* the stage of shutting down */
>> +       atomic_t                stopping_blockers;
>> +       struct completion       stopping_waiter;
>>
>>          atomic64_t              quotarealms_count; /* # realms with quota */
>>          /*
>> diff --git a/fs/ceph/quota.c b/fs/ceph/quota.c
>> index 64592adfe48f..f7fcf7f08ec6 100644
>> --- a/fs/ceph/quota.c
>> +++ b/fs/ceph/quota.c
>> @@ -47,25 +47,23 @@ void ceph_handle_quota(struct ceph_mds_client *mdsc,
>>          struct inode *inode;
>>          struct ceph_inode_info *ci;
>>
>> +       if (!ceph_inc_mds_stopping_blocker(mdsc, session))
>> +               return;
>> +
>>          if (msg->front.iov_len < sizeof(*h)) {
>>                  pr_err("%s corrupt message mds%d len %d\n", __func__,
>>                         session->s_mds, (int)msg->front.iov_len);
>>                  ceph_msg_dump(msg);
>> -               return;
>> +               goto out;
>>          }
>>
>> -       /* increment msg sequence number */
>> -       mutex_lock(&session->s_mutex);
>> -       inc_session_sequence(session);
>> -       mutex_unlock(&session->s_mutex);
>> -
>>          /* lookup inode */
>>          vino.ino = le64_to_cpu(h->ino);
>>          vino.snap = CEPH_NOSNAP;
>>          inode = ceph_find_inode(sb, vino);
>>          if (!inode) {
>>                  pr_warn("Failed to find inode %llu\n", vino.ino);
>> -               return;
>> +               goto out;
>>          }
>>          ci = ceph_inode(inode);
>>
>> @@ -78,6 +76,8 @@ void ceph_handle_quota(struct ceph_mds_client *mdsc,
>>          spin_unlock(&ci->i_ceph_lock);
>>
>>          iput(inode);
>> +out:
>> +       ceph_dec_mds_stopping_blocker(mdsc);
>>   }
>>
>>   static struct ceph_quotarealm_inode *
>> diff --git a/fs/ceph/snap.c b/fs/ceph/snap.c
>> index a6af991116b9..e03b020d87d7 100644
>> --- a/fs/ceph/snap.c
>> +++ b/fs/ceph/snap.c
>> @@ -1016,6 +1016,9 @@ void ceph_handle_snap(struct ceph_mds_client *mdsc,
>>          int locked_rwsem = 0;
>>          bool close_sessions = false;
>>
>> +       if (!ceph_inc_mds_stopping_blocker(mdsc, session))
>> +               return;
>> +
>>          /* decode */
>>          if (msg->front.iov_len < sizeof(*h))
>>                  goto bad;
>> @@ -1031,10 +1034,6 @@ void ceph_handle_snap(struct ceph_mds_client *mdsc,
>>          dout("%s from mds%d op %s split %llx tracelen %d\n", __func__,
>>               mds, ceph_snap_op_name(op), split, trace_len);
>>
>> -       mutex_lock(&session->s_mutex);
>> -       inc_session_sequence(session);
>> -       mutex_unlock(&session->s_mutex);
>> -
>>          down_write(&mdsc->snap_rwsem);
>>          locked_rwsem = 1;
>>
>> @@ -1152,12 +1151,15 @@ void ceph_handle_snap(struct ceph_mds_client *mdsc,
>>          up_write(&mdsc->snap_rwsem);
>>
>>          flush_snaps(mdsc);
>> +       ceph_dec_mds_stopping_blocker(mdsc);
>>          return;
>>
>>   bad:
>>          pr_err("%s corrupt snap message from mds%d\n", __func__, mds);
>>          ceph_msg_dump(msg);
>>   out:
>> +       ceph_dec_mds_stopping_blocker(mdsc);
>> +
>>          if (locked_rwsem)
>>                  up_write(&mdsc->snap_rwsem);
>>
>> diff --git a/fs/ceph/super.c b/fs/ceph/super.c
>> index b606b33a253b..d3f54f3d7b17 100644
>> --- a/fs/ceph/super.c
>> +++ b/fs/ceph/super.c
>> @@ -169,6 +169,7 @@ enum {
>>          Opt_wsync,
>>          Opt_pagecache,
>>          Opt_sparseread,
>> +       Opt_umount_timeout,
>>   };
>>
>>   enum ceph_recover_session_mode {
>> @@ -214,6 +215,7 @@ static const struct fs_parameter_spec ceph_mount_parameters[] = {
>>          fsparam_flag_no ("wsync",                       Opt_wsync),
>>          fsparam_flag_no ("pagecache",                   Opt_pagecache),
>>          fsparam_flag_no ("sparseread",                  Opt_sparseread),
>> +       fsparam_u32     ("umount_timeout",              Opt_umount_timeout),
>>          {}
>>   };
>>
>> @@ -600,6 +602,12 @@ static int ceph_parse_mount_param(struct fs_context *fc,
>>                  else
>>                          fsopt->flags |= CEPH_MOUNT_OPT_SPARSEREAD;
>>                  break;
>> +       case Opt_umount_timeout:
>> +               /* 0 is "wait forever" (i.e. infinite timeout) */
>> +               if (result.uint_32 > INT_MAX / 1000)
>> +                       goto out_of_range;
>> +               fsopt->umount_timeout = msecs_to_jiffies(result.uint_32 * 1000);
>> +               break;
>>          case Opt_test_dummy_encryption:
>>   #ifdef CONFIG_FS_ENCRYPTION
>>                  fscrypt_free_dummy_policy(&fsopt->dummy_enc_policy);
>> @@ -779,6 +787,8 @@ static int ceph_show_options(struct seq_file *m, struct dentry *root)
>>                  seq_printf(m, ",readdir_max_entries=%u", fsopt->max_readdir);
>>          if (fsopt->max_readdir_bytes != CEPH_MAX_READDIR_BYTES_DEFAULT)
>>                  seq_printf(m, ",readdir_max_bytes=%u", fsopt->max_readdir_bytes);
>> +       if (fsopt->umount_timeout != CEPH_UMOUNT_TIMEOUT_DEFAULT)
>> +               seq_printf(m, ",umount_timeout=%u", fsopt->umount_timeout);
>>          if (strcmp(fsopt->snapdir_name, CEPH_SNAPDIRNAME_DEFAULT))
>>                  seq_show_option(m, "snapdirname", fsopt->snapdir_name);
>>
>> @@ -1456,6 +1466,7 @@ static int ceph_init_fs_context(struct fs_context *fc)
>>          fsopt->max_readdir = CEPH_MAX_READDIR_DEFAULT;
>>          fsopt->max_readdir_bytes = CEPH_MAX_READDIR_BYTES_DEFAULT;
>>          fsopt->congestion_kb = default_congestion_kb();
>> +       fsopt->umount_timeout = CEPH_UMOUNT_TIMEOUT_DEFAULT;
>>
>>   #ifdef CONFIG_CEPH_FS_POSIX_ACL
>>          fc->sb_flags |= SB_POSIXACL;
>> @@ -1472,15 +1483,90 @@ static int ceph_init_fs_context(struct fs_context *fc)
>>          return -ENOMEM;
>>   }
>>
>> +/*
>> + * Return true if it successfully increases the blocker counter,
>> + * or false if the mdsc is in stopping and flushed state.
>> + */
>> +static bool __inc_stopping_blocker(struct ceph_mds_client *mdsc)
>> +{
>> +       spin_lock(&mdsc->stopping_lock);
>> +       if (mdsc->stopping >= CEPH_MDSC_STOPPING_FLUSHED) {
>> +               spin_unlock(&mdsc->stopping_lock);
>> +               return false;
>> +       }
>> +       atomic_inc(&mdsc->stopping_blockers);
>> +       spin_unlock(&mdsc->stopping_lock);
>> +       return true;
>> +}
>> +
>> +static void __dec_stopping_blocker(struct ceph_mds_client *mdsc)
>> +{
>> +       spin_lock(&mdsc->stopping_lock);
>> +       if (!atomic_dec_return(&mdsc->stopping_blockers) &&
>> +           mdsc->stopping >= CEPH_MDSC_STOPPING_FLUSHED)
>> +               complete_all(&mdsc->stopping_waiter);
>> +       spin_unlock(&mdsc->stopping_lock);
>> +}
>> +
>> +/* For metadata IO requests */
>> +bool ceph_inc_mds_stopping_blocker(struct ceph_mds_client *mdsc,
>> +                                  struct ceph_mds_session *session)
>> +{
>> +       mutex_lock(&session->s_mutex);
>> +       inc_session_sequence(session);
>> +       mutex_unlock(&session->s_mutex);
>> +
>> +       return __inc_stopping_blocker(mdsc);
>> +}
>> +
>> +void ceph_dec_mds_stopping_blocker(struct ceph_mds_client *mdsc)
>> +{
>> +       __dec_stopping_blocker(mdsc);
>> +}
>> +
>>   static void ceph_kill_sb(struct super_block *s)
>>   {
>>          struct ceph_fs_client *fsc = ceph_sb_to_client(s);
>> +       struct ceph_mds_client *mdsc = fsc->mdsc;
>> +       struct ceph_mount_options *opt = fsc->mount_options;
>> +       bool wait;
>>
>>          dout("kill_sb %p\n", s);
>>
>> -       ceph_mdsc_pre_umount(fsc->mdsc);
>> +       ceph_mdsc_pre_umount(mdsc);
>>          flush_fs_workqueues(fsc);
>>
>> +       /*
>> +        * Though the kill_anon_super() will finally trigger the
>> +        * sync_filesystem() anyway, we still need to do it here and
>> +        * then bump the stage of shutdown. This will allow us to
>> +        * drop any further message, which will increase the inodes'
>> +        * i_count reference counters but makes no sense any more,
>> +        * from MDSs.
>> +        *
>> +        * Without this when evicting the inodes it may fail in the
>> +        * kill_anon_super(), which will trigger a warning when
>> +        * destroying the fscrypt keyring and then possibly trigger
>> +        * a further crash in ceph module when the iput() tries to
>> +        * evict the inodes later.
>> +        */
>> +       sync_filesystem(s);
>> +
>> +       spin_lock(&mdsc->stopping_lock);
>> +       mdsc->stopping = CEPH_MDSC_STOPPING_FLUSHED;
>> +       wait = !!atomic_read(&mdsc->stopping_blockers);
>> +       spin_unlock(&mdsc->stopping_lock);
>> +
>> +       if (wait && atomic_read(&mdsc->stopping_blockers)) {
>> +               long timeleft = wait_for_completion_killable_timeout(
>> +                                       &mdsc->stopping_waiter,
>> +                                       opt->umount_timeout);
>> +               if (!timeleft) /* timed out */
>> +                       pr_warn("umount timed out, %ld\n", timeleft);
>> +               else if (timeleft < 0) /* killed */
>> +                       pr_warn("umount was killed, %ld\n", timeleft);
>> +       }
>> +
>>          kill_anon_super(s);
>>
>>          fsc->client->extra_mon_dispatch = NULL;
>> diff --git a/fs/ceph/super.h b/fs/ceph/super.h
>> index a0688dc63fa0..cd5b88d819ca 100644
>> --- a/fs/ceph/super.h
>> +++ b/fs/ceph/super.h
>> @@ -66,6 +66,7 @@
>>   #define CEPH_MAX_READDIR_DEFAULT        1024
>>   #define CEPH_MAX_READDIR_BYTES_DEFAULT  (512*1024)
>>   #define CEPH_SNAPDIRNAME_DEFAULT        ".snap"
>> +#define CEPH_UMOUNT_TIMEOUT_DEFAULT     msecs_to_jiffies(60 * 1000)
>>
>>   /*
>>    * Delay telling the MDS we no longer want caps, in case we reopen
>> @@ -87,6 +88,7 @@ struct ceph_mount_options {
>>          int caps_max;
>>          unsigned int max_readdir;       /* max readdir result (entries) */
>>          unsigned int max_readdir_bytes; /* max readdir result (bytes) */
>> +       unsigned int umount_timeout;    /* jiffies */
>>
>>          bool new_dev_syntax;
>>
>> @@ -1413,4 +1415,7 @@ extern bool ceph_quota_update_statfs(struct ceph_fs_client *fsc,
>>                                       struct kstatfs *buf);
>>   extern void ceph_cleanup_quotarealms_inodes(struct ceph_mds_client *mdsc);
>>
>> +bool ceph_inc_mds_stopping_blocker(struct ceph_mds_client *mdsc,
>> +                              struct ceph_mds_session *session);
>> +void ceph_dec_mds_stopping_blocker(struct ceph_mds_client *mdsc);
>>   #endif /* _FS_CEPH_SUPER_H */
>> --
>> 2.40.1
>>
>

