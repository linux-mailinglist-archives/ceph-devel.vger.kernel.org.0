Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 58DE5723A90
	for <lists+ceph-devel@lfdr.de>; Tue,  6 Jun 2023 09:52:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235968AbjFFHwp (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 6 Jun 2023 03:52:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236215AbjFFHwL (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 6 Jun 2023 03:52:11 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B33CC268D
        for <ceph-devel@vger.kernel.org>; Tue,  6 Jun 2023 00:48:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1686037673;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=80XaQsHGenQGKV0O6CtIF6dJDbvb0EeOUTrzltOJUi8=;
        b=DeeqoYllqE0XOSW0M7AjkV0jkCGvqtnCLveSIcFJcTNJ7e06TB24Y5DRLuxB85wLWEkk+X
        OLr43ZdJVUUZfEJte8V+DqjKk2TJ7g1s1Ivt5wAbNGoqnxCL3PIDXz1DuVoIIuIJoNzeja
        m0nqVt5Iaeg4GHUUrZhRKZ8txVXYjxU=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-457-4PBCbmHnNxamvhW66LOMHQ-1; Tue, 06 Jun 2023 03:47:51 -0400
X-MC-Unique: 4PBCbmHnNxamvhW66LOMHQ-1
Received: by mail-ej1-f69.google.com with SMTP id a640c23a62f3a-9715654ab36so412921666b.0
        for <ceph-devel@vger.kernel.org>; Tue, 06 Jun 2023 00:47:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686037670; x=1688629670;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=80XaQsHGenQGKV0O6CtIF6dJDbvb0EeOUTrzltOJUi8=;
        b=STYMssHnPjQolPzwFf+dLxGO4jkC3fDScjDCwmmLbAE8ZiTaykN13dv8rpLsWAPFq/
         VwFoAQyZ0XOkASZ7CRNrKZUEQjUF8Zbu5Qn3uk5X81xHQX0VrCy2T5qPxi5EZx6EUmF3
         frRaZpcd/8tgJelk3xj41C0UbbgpWL4Yi39GYBGwRF0Hs3zzPvbZZa0KfW0gl1oQVt4F
         ijl/RRFsjovq7QW8Tja+ScAcLql+rrisrF2rnF/DD5J76ndY+FHpP+GjA45B5MBsplKH
         YGLA5fvSYDl1ULkYNxtlr6Bqrm/aibxb3qdePSgLVo3RnEsbMk5vF8JGR4pYo9bwDrY+
         bC3w==
X-Gm-Message-State: AC+VfDzjQpnSzIWzYWYgBUUQBCOT4Y5pZKIbJj4a+U9aqgnFd83a9Ce1
        MmvQ6LKLuNkld51wfUhvcH+AQ+GpIba4CtWSHzU1D7ra7pM+vkFvSt3ka/8Y08jlUQKwZnXnd4e
        5VmKRj6YQUGZ9KWi7+DsuTbAbv+Q6a6ydq6pPyw==
X-Received: by 2002:a17:907:1ca0:b0:971:484:6391 with SMTP id nb32-20020a1709071ca000b0097104846391mr1549396ejc.20.1686037670115;
        Tue, 06 Jun 2023 00:47:50 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ4Go/k97oVTLlRLR8vrfeWATm06veC3iOyt2DEqA0dr9eJypKigF9dZgbSAnlcTXU8CY1cLHvyMo8Kilb0YKLI=
X-Received: by 2002:a17:907:1ca0:b0:971:484:6391 with SMTP id
 nb32-20020a1709071ca000b0097104846391mr1549380ejc.20.1686037669706; Tue, 06
 Jun 2023 00:47:49 -0700 (PDT)
MIME-Version: 1.0
References: <20230606033212.1068823-1-xiubli@redhat.com> <20230606033212.1068823-2-xiubli@redhat.com>
In-Reply-To: <20230606033212.1068823-2-xiubli@redhat.com>
From:   Milind Changire <mchangir@redhat.com>
Date:   Tue, 6 Jun 2023 13:17:13 +0530
Message-ID: <CAED=hWBfB42hfEJPPaE3WNHZM-n_UMDe9HQbUwuMTHYAuRZX+w@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] ceph: drop the messages from MDS when unmounting
To:     xiubli@redhat.com
Cc:     idryomov@gmail.com, ceph-devel@vger.kernel.org, jlayton@kernel.org,
        vshankar@redhat.com, lhenriques@suse.de
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

nits in commit message:
* s/When unmounting and all/When unmounting and ???/
Is something missing after *and* or has been dropped ?
Please remove *and* if something has been dropped or
add it after *and* if it was forgotten to be added

* s/ihode/ihold/

-----
Otherwise, it looks good to me.

Reviewed-by: Milind Changire <mchangir@redhat.com>

On Tue, Jun 6, 2023 at 9:04=E2=80=AFAM <xiubli@redhat.com> wrote:
>
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
>  fs/ceph/caps.c       |  6 ++-
>  fs/ceph/mds_client.c | 14 +++++--
>  fs/ceph/mds_client.h | 11 +++++-
>  fs/ceph/quota.c      | 14 +++----
>  fs/ceph/snap.c       | 10 +++--
>  fs/ceph/super.c      | 88 +++++++++++++++++++++++++++++++++++++++++++-
>  fs/ceph/super.h      |  5 +++
>  7 files changed, 131 insertions(+), 17 deletions(-)
>
> diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
> index ccd4791a5e71..74ba335af25d 100644
> --- a/fs/ceph/caps.c
> +++ b/fs/ceph/caps.c
> @@ -4235,6 +4235,9 @@ void ceph_handle_caps(struct ceph_mds_session *sess=
ion,
>
>         dout("handle_caps from mds%d\n", session->s_mds);
>
> +       if (!ceph_inc_mds_stopping_blocker(mdsc, session))
> +               return;
> +
>         /* decode */
>         end =3D msg->front.iov_base + msg->front.iov_len;
>         if (msg->front.iov_len < sizeof(*h))
> @@ -4336,7 +4339,6 @@ void ceph_handle_caps(struct ceph_mds_session *sess=
ion,
>              vino.snap, inode);
>
>         mutex_lock(&session->s_mutex);
> -       inc_session_sequence(session);
>         dout(" mds%d seq %lld cap seq %u\n", session->s_mds, session->s_s=
eq,
>              (unsigned)seq);
>
> @@ -4448,6 +4450,8 @@ void ceph_handle_caps(struct ceph_mds_session *sess=
ion,
>  done_unlocked:
>         iput(inode);
>  out:
> +       ceph_dec_mds_stopping_blocker(mdsc);
> +
>         ceph_put_string(extra_info.pool_ns);
>
>         /* Defer closing the sessions after s_mutex lock being released *=
/
> diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
> index 6a82b0708343..0a70a2438cb2 100644
> --- a/fs/ceph/mds_client.c
> +++ b/fs/ceph/mds_client.c
> @@ -4904,6 +4904,9 @@ static void handle_lease(struct ceph_mds_client *md=
sc,
>
>         dout("handle_lease from mds%d\n", mds);
>
> +       if (!ceph_inc_mds_stopping_blocker(mdsc, session))
> +               return;
> +
>         /* decode */
>         if (msg->front.iov_len < sizeof(*h) + sizeof(u32))
>                 goto bad;
> @@ -4922,8 +4925,6 @@ static void handle_lease(struct ceph_mds_client *md=
sc,
>              dname.len, dname.name);
>
>         mutex_lock(&session->s_mutex);
> -       inc_session_sequence(session);
> -
>         if (!inode) {
>                 dout("handle_lease no inode %llx\n", vino.ino);
>                 goto release;
> @@ -4985,9 +4986,13 @@ static void handle_lease(struct ceph_mds_client *m=
dsc,
>  out:
>         mutex_unlock(&session->s_mutex);
>         iput(inode);
> +
> +       ceph_dec_mds_stopping_blocker(mdsc);
>         return;
>
>  bad:
> +       ceph_dec_mds_stopping_blocker(mdsc);
> +
>         pr_err("corrupt lease message\n");
>         ceph_msg_dump(msg);
>  }
> @@ -5183,6 +5188,9 @@ int ceph_mdsc_init(struct ceph_fs_client *fsc)
>         }
>
>         init_completion(&mdsc->safe_umount_waiters);
> +       spin_lock_init(&mdsc->stopping_lock);
> +       atomic_set(&mdsc->stopping_blockers, 0);
> +       init_completion(&mdsc->stopping_waiter);
>         init_waitqueue_head(&mdsc->session_close_wq);
>         INIT_LIST_HEAD(&mdsc->waiting_for_map);
>         mdsc->quotarealms_inodes =3D RB_ROOT;
> @@ -5297,7 +5305,7 @@ void send_flush_mdlog(struct ceph_mds_session *s)
>  void ceph_mdsc_pre_umount(struct ceph_mds_client *mdsc)
>  {
>         dout("pre_umount\n");
> -       mdsc->stopping =3D 1;
> +       mdsc->stopping =3D CEPH_MDSC_STOPPING_BEGIN;
>
>         ceph_mdsc_iterate_sessions(mdsc, send_flush_mdlog, true);
>         ceph_mdsc_iterate_sessions(mdsc, lock_unlock_session, false);
> diff --git a/fs/ceph/mds_client.h b/fs/ceph/mds_client.h
> index 82165f09a516..351d92f7fc4f 100644
> --- a/fs/ceph/mds_client.h
> +++ b/fs/ceph/mds_client.h
> @@ -398,6 +398,11 @@ struct cap_wait {
>         int                     want;
>  };
>
> +enum {
> +       CEPH_MDSC_STOPPING_BEGIN =3D 1,
> +       CEPH_MDSC_STOPPING_FLUSHED =3D 2,
> +};
> +
>  /*
>   * mds client state
>   */
> @@ -414,7 +419,11 @@ struct ceph_mds_client {
>         struct ceph_mds_session **sessions;    /* NULL for mds if no sess=
ion */
>         atomic_t                num_sessions;
>         int                     max_sessions;  /* len of sessions array *=
/
> -       int                     stopping;      /* true if shutting down *=
/
> +
> +       spinlock_t              stopping_lock;  /* protect snap_empty */
> +       int                     stopping;      /* the stage of shutting d=
own */
> +       atomic_t                stopping_blockers;
> +       struct completion       stopping_waiter;
>
>         atomic64_t              quotarealms_count; /* # realms with quota=
 */
>         /*
> diff --git a/fs/ceph/quota.c b/fs/ceph/quota.c
> index 64592adfe48f..f7fcf7f08ec6 100644
> --- a/fs/ceph/quota.c
> +++ b/fs/ceph/quota.c
> @@ -47,25 +47,23 @@ void ceph_handle_quota(struct ceph_mds_client *mdsc,
>         struct inode *inode;
>         struct ceph_inode_info *ci;
>
> +       if (!ceph_inc_mds_stopping_blocker(mdsc, session))
> +               return;
> +
>         if (msg->front.iov_len < sizeof(*h)) {
>                 pr_err("%s corrupt message mds%d len %d\n", __func__,
>                        session->s_mds, (int)msg->front.iov_len);
>                 ceph_msg_dump(msg);
> -               return;
> +               goto out;
>         }
>
> -       /* increment msg sequence number */
> -       mutex_lock(&session->s_mutex);
> -       inc_session_sequence(session);
> -       mutex_unlock(&session->s_mutex);
> -
>         /* lookup inode */
>         vino.ino =3D le64_to_cpu(h->ino);
>         vino.snap =3D CEPH_NOSNAP;
>         inode =3D ceph_find_inode(sb, vino);
>         if (!inode) {
>                 pr_warn("Failed to find inode %llu\n", vino.ino);
> -               return;
> +               goto out;
>         }
>         ci =3D ceph_inode(inode);
>
> @@ -78,6 +76,8 @@ void ceph_handle_quota(struct ceph_mds_client *mdsc,
>         spin_unlock(&ci->i_ceph_lock);
>
>         iput(inode);
> +out:
> +       ceph_dec_mds_stopping_blocker(mdsc);
>  }
>
>  static struct ceph_quotarealm_inode *
> diff --git a/fs/ceph/snap.c b/fs/ceph/snap.c
> index a6af991116b9..e03b020d87d7 100644
> --- a/fs/ceph/snap.c
> +++ b/fs/ceph/snap.c
> @@ -1016,6 +1016,9 @@ void ceph_handle_snap(struct ceph_mds_client *mdsc,
>         int locked_rwsem =3D 0;
>         bool close_sessions =3D false;
>
> +       if (!ceph_inc_mds_stopping_blocker(mdsc, session))
> +               return;
> +
>         /* decode */
>         if (msg->front.iov_len < sizeof(*h))
>                 goto bad;
> @@ -1031,10 +1034,6 @@ void ceph_handle_snap(struct ceph_mds_client *mdsc=
,
>         dout("%s from mds%d op %s split %llx tracelen %d\n", __func__,
>              mds, ceph_snap_op_name(op), split, trace_len);
>
> -       mutex_lock(&session->s_mutex);
> -       inc_session_sequence(session);
> -       mutex_unlock(&session->s_mutex);
> -
>         down_write(&mdsc->snap_rwsem);
>         locked_rwsem =3D 1;
>
> @@ -1152,12 +1151,15 @@ void ceph_handle_snap(struct ceph_mds_client *mds=
c,
>         up_write(&mdsc->snap_rwsem);
>
>         flush_snaps(mdsc);
> +       ceph_dec_mds_stopping_blocker(mdsc);
>         return;
>
>  bad:
>         pr_err("%s corrupt snap message from mds%d\n", __func__, mds);
>         ceph_msg_dump(msg);
>  out:
> +       ceph_dec_mds_stopping_blocker(mdsc);
> +
>         if (locked_rwsem)
>                 up_write(&mdsc->snap_rwsem);
>
> diff --git a/fs/ceph/super.c b/fs/ceph/super.c
> index b606b33a253b..d3f54f3d7b17 100644
> --- a/fs/ceph/super.c
> +++ b/fs/ceph/super.c
> @@ -169,6 +169,7 @@ enum {
>         Opt_wsync,
>         Opt_pagecache,
>         Opt_sparseread,
> +       Opt_umount_timeout,
>  };
>
>  enum ceph_recover_session_mode {
> @@ -214,6 +215,7 @@ static const struct fs_parameter_spec ceph_mount_para=
meters[] =3D {
>         fsparam_flag_no ("wsync",                       Opt_wsync),
>         fsparam_flag_no ("pagecache",                   Opt_pagecache),
>         fsparam_flag_no ("sparseread",                  Opt_sparseread),
> +       fsparam_u32     ("umount_timeout",              Opt_umount_timeou=
t),
>         {}
>  };
>
> @@ -600,6 +602,12 @@ static int ceph_parse_mount_param(struct fs_context =
*fc,
>                 else
>                         fsopt->flags |=3D CEPH_MOUNT_OPT_SPARSEREAD;
>                 break;
> +       case Opt_umount_timeout:
> +               /* 0 is "wait forever" (i.e. infinite timeout) */
> +               if (result.uint_32 > INT_MAX / 1000)
> +                       goto out_of_range;
> +               fsopt->umount_timeout =3D msecs_to_jiffies(result.uint_32=
 * 1000);
> +               break;
>         case Opt_test_dummy_encryption:
>  #ifdef CONFIG_FS_ENCRYPTION
>                 fscrypt_free_dummy_policy(&fsopt->dummy_enc_policy);
> @@ -779,6 +787,8 @@ static int ceph_show_options(struct seq_file *m, stru=
ct dentry *root)
>                 seq_printf(m, ",readdir_max_entries=3D%u", fsopt->max_rea=
ddir);
>         if (fsopt->max_readdir_bytes !=3D CEPH_MAX_READDIR_BYTES_DEFAULT)
>                 seq_printf(m, ",readdir_max_bytes=3D%u", fsopt->max_readd=
ir_bytes);
> +       if (fsopt->umount_timeout !=3D CEPH_UMOUNT_TIMEOUT_DEFAULT)
> +               seq_printf(m, ",umount_timeout=3D%u", fsopt->umount_timeo=
ut);
>         if (strcmp(fsopt->snapdir_name, CEPH_SNAPDIRNAME_DEFAULT))
>                 seq_show_option(m, "snapdirname", fsopt->snapdir_name);
>
> @@ -1456,6 +1466,7 @@ static int ceph_init_fs_context(struct fs_context *=
fc)
>         fsopt->max_readdir =3D CEPH_MAX_READDIR_DEFAULT;
>         fsopt->max_readdir_bytes =3D CEPH_MAX_READDIR_BYTES_DEFAULT;
>         fsopt->congestion_kb =3D default_congestion_kb();
> +       fsopt->umount_timeout =3D CEPH_UMOUNT_TIMEOUT_DEFAULT;
>
>  #ifdef CONFIG_CEPH_FS_POSIX_ACL
>         fc->sb_flags |=3D SB_POSIXACL;
> @@ -1472,15 +1483,90 @@ static int ceph_init_fs_context(struct fs_context=
 *fc)
>         return -ENOMEM;
>  }
>
> +/*
> + * Return true if it successfully increases the blocker counter,
> + * or false if the mdsc is in stopping and flushed state.
> + */
> +static bool __inc_stopping_blocker(struct ceph_mds_client *mdsc)
> +{
> +       spin_lock(&mdsc->stopping_lock);
> +       if (mdsc->stopping >=3D CEPH_MDSC_STOPPING_FLUSHED) {
> +               spin_unlock(&mdsc->stopping_lock);
> +               return false;
> +       }
> +       atomic_inc(&mdsc->stopping_blockers);
> +       spin_unlock(&mdsc->stopping_lock);
> +       return true;
> +}
> +
> +static void __dec_stopping_blocker(struct ceph_mds_client *mdsc)
> +{
> +       spin_lock(&mdsc->stopping_lock);
> +       if (!atomic_dec_return(&mdsc->stopping_blockers) &&
> +           mdsc->stopping >=3D CEPH_MDSC_STOPPING_FLUSHED)
> +               complete_all(&mdsc->stopping_waiter);
> +       spin_unlock(&mdsc->stopping_lock);
> +}
> +
> +/* For metadata IO requests */
> +bool ceph_inc_mds_stopping_blocker(struct ceph_mds_client *mdsc,
> +                                  struct ceph_mds_session *session)
> +{
> +       mutex_lock(&session->s_mutex);
> +       inc_session_sequence(session);
> +       mutex_unlock(&session->s_mutex);
> +
> +       return __inc_stopping_blocker(mdsc);
> +}
> +
> +void ceph_dec_mds_stopping_blocker(struct ceph_mds_client *mdsc)
> +{
> +       __dec_stopping_blocker(mdsc);
> +}
> +
>  static void ceph_kill_sb(struct super_block *s)
>  {
>         struct ceph_fs_client *fsc =3D ceph_sb_to_client(s);
> +       struct ceph_mds_client *mdsc =3D fsc->mdsc;
> +       struct ceph_mount_options *opt =3D fsc->mount_options;
> +       bool wait;
>
>         dout("kill_sb %p\n", s);
>
> -       ceph_mdsc_pre_umount(fsc->mdsc);
> +       ceph_mdsc_pre_umount(mdsc);
>         flush_fs_workqueues(fsc);
>
> +       /*
> +        * Though the kill_anon_super() will finally trigger the
> +        * sync_filesystem() anyway, we still need to do it here and
> +        * then bump the stage of shutdown. This will allow us to
> +        * drop any further message, which will increase the inodes'
> +        * i_count reference counters but makes no sense any more,
> +        * from MDSs.
> +        *
> +        * Without this when evicting the inodes it may fail in the
> +        * kill_anon_super(), which will trigger a warning when
> +        * destroying the fscrypt keyring and then possibly trigger
> +        * a further crash in ceph module when the iput() tries to
> +        * evict the inodes later.
> +        */
> +       sync_filesystem(s);
> +
> +       spin_lock(&mdsc->stopping_lock);
> +       mdsc->stopping =3D CEPH_MDSC_STOPPING_FLUSHED;
> +       wait =3D !!atomic_read(&mdsc->stopping_blockers);
> +       spin_unlock(&mdsc->stopping_lock);
> +
> +       if (wait && atomic_read(&mdsc->stopping_blockers)) {
> +               long timeleft =3D wait_for_completion_killable_timeout(
> +                                       &mdsc->stopping_waiter,
> +                                       opt->umount_timeout);
> +               if (!timeleft) /* timed out */
> +                       pr_warn("umount timed out, %ld\n", timeleft);
> +               else if (timeleft < 0) /* killed */
> +                       pr_warn("umount was killed, %ld\n", timeleft);
> +       }
> +
>         kill_anon_super(s);
>
>         fsc->client->extra_mon_dispatch =3D NULL;
> diff --git a/fs/ceph/super.h b/fs/ceph/super.h
> index a0688dc63fa0..cd5b88d819ca 100644
> --- a/fs/ceph/super.h
> +++ b/fs/ceph/super.h
> @@ -66,6 +66,7 @@
>  #define CEPH_MAX_READDIR_DEFAULT        1024
>  #define CEPH_MAX_READDIR_BYTES_DEFAULT  (512*1024)
>  #define CEPH_SNAPDIRNAME_DEFAULT        ".snap"
> +#define CEPH_UMOUNT_TIMEOUT_DEFAULT     msecs_to_jiffies(60 * 1000)
>
>  /*
>   * Delay telling the MDS we no longer want caps, in case we reopen
> @@ -87,6 +88,7 @@ struct ceph_mount_options {
>         int caps_max;
>         unsigned int max_readdir;       /* max readdir result (entries) *=
/
>         unsigned int max_readdir_bytes; /* max readdir result (bytes) */
> +       unsigned int umount_timeout;    /* jiffies */
>
>         bool new_dev_syntax;
>
> @@ -1413,4 +1415,7 @@ extern bool ceph_quota_update_statfs(struct ceph_fs=
_client *fsc,
>                                      struct kstatfs *buf);
>  extern void ceph_cleanup_quotarealms_inodes(struct ceph_mds_client *mdsc=
);
>
> +bool ceph_inc_mds_stopping_blocker(struct ceph_mds_client *mdsc,
> +                              struct ceph_mds_session *session);
> +void ceph_dec_mds_stopping_blocker(struct ceph_mds_client *mdsc);
>  #endif /* _FS_CEPH_SUPER_H */
> --
> 2.40.1
>


--=20
Milind

