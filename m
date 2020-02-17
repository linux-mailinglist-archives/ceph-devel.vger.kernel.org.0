Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1025516129F
	for <lists+ceph-devel@lfdr.de>; Mon, 17 Feb 2020 14:04:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728124AbgBQNEb (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 17 Feb 2020 08:04:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:42662 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726401AbgBQNEb (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Mon, 17 Feb 2020 08:04:31 -0500
Received: from tleilax.poochiereds.net (68-20-15-154.lightspeed.rlghnc.sbcglobal.net [68.20.15.154])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6890A20578;
        Mon, 17 Feb 2020 13:04:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581944670;
        bh=ydjtpzEffG+9PItisid7H/sAQse3TP/ApaXBKjBWudw=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=DF8gfBMHXIVptRuo5kpUKpYMLIlKrI0RburtkdpuqUGsu7Ifx+TacgS033N8tXqzY
         zZITtOyQm3N+OGpYa+RPYIgyJ2XTeWsZwDRXsQfELnzKz6NzoOO91jPymBfD4llpxc
         rV0I+sNVAz9qA6iGXGdUjr8Kk8c/xgL/dprHz6NE=
Message-ID: <78ff80dd12d497be7a6606a60973f7e2d864e910.camel@kernel.org>
Subject: Re: [PATCH] ceph: add halt mount option support
From:   Jeff Layton <jlayton@kernel.org>
To:     xiubli@redhat.com, idryomov@gmail.com
Cc:     sage@redhat.com, zyan@redhat.com, pdonnell@redhat.com,
        ceph-devel@vger.kernel.org
Date:   Mon, 17 Feb 2020 08:04:28 -0500
In-Reply-To: <20200216064945.61726-1-xiubli@redhat.com>
References: <20200216064945.61726-1-xiubli@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.3 (3.34.3-1.fc31) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Sun, 2020-02-16 at 01:49 -0500, xiubli@redhat.com wrote:
> From: Xiubo Li <xiubli@redhat.com>
> 
> This will simulate pulling the power cable situation, which will
> do:
> 
> - abort all the inflight osd/mds requests and fail them with -EIO.
> - reject any new coming osd/mds requests with -EIO.
> - close all the mds connections directly without doing any clean up
>   and disable mds sessions recovery routine.
> - close all the osd connections directly without doing any clean up.
> - set the msgr as stopped.
> 
> URL: https://tracker.ceph.com/issues/44044
> Signed-off-by: Xiubo Li <xiubli@redhat.com>

There is no explanation of how to actually _use_ this feature? I assume
you have to remount the fs with "-o remount,halt" ? Is it possible to
reenable the mount as well?  If not, why keep the mount around? Maybe we
should consider wiring this in to a new umount2() flag instead?

This needs much better documentation.

In the past, I've generally done this using iptables. Granted that that
is difficult with a clustered fs like ceph (given that you potentially
have to set rules for a lot of addresses), but I wonder whether a scheme
like that might be more viable in the long run.

Note too that this may have interesting effects when superblocks end up
being shared between vfsmounts.

> ---
>  fs/ceph/mds_client.c            | 12 ++++++++++--
>  fs/ceph/mds_client.h            |  3 ++-
>  fs/ceph/super.c                 | 33 ++++++++++++++++++++++++++++-----
>  fs/ceph/super.h                 |  1 +
>  include/linux/ceph/libceph.h    |  1 +
>  include/linux/ceph/mon_client.h |  2 ++
>  include/linux/ceph/osd_client.h |  1 +
>  net/ceph/ceph_common.c          | 14 ++++++++++++++
>  net/ceph/mon_client.c           | 16 ++++++++++++++--
>  net/ceph/osd_client.c           | 11 +++++++++++
>  10 files changed, 84 insertions(+), 10 deletions(-)
> 
> diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
> index b0f34251ad28..b6aa357f7c61 100644
> --- a/fs/ceph/mds_client.c
> +++ b/fs/ceph/mds_client.c
> @@ -4110,6 +4110,9 @@ static void maybe_recover_session(struct ceph_mds_client *mdsc)
>  {
>  	struct ceph_fs_client *fsc = mdsc->fsc;
>  
> +	if (ceph_test_mount_opt(fsc, HALT))
> +		return;
> +
>  	if (!ceph_test_mount_opt(fsc, CLEANRECOVER))
>  		return;
>  
> @@ -4735,7 +4738,7 @@ void ceph_mdsc_close_sessions(struct ceph_mds_client *mdsc)
>  	dout("stopped\n");
>  }
>  
> -void ceph_mdsc_force_umount(struct ceph_mds_client *mdsc)
> +void ceph_mdsc_force_umount(struct ceph_mds_client *mdsc, bool halt)
>  {
>  	struct ceph_mds_session *session;
>  	int mds;
> @@ -4748,7 +4751,12 @@ void ceph_mdsc_force_umount(struct ceph_mds_client *mdsc)
>  		if (!session)
>  			continue;
>  
> -		if (session->s_state == CEPH_MDS_SESSION_REJECTED)
> +		/*
> +		 * when halting the superblock, it will simulate pulling
> +		 * the power cable, so here close the connection before
> +		 * doing any cleanup.
> +		 */
> +		if (halt || (session->s_state == CEPH_MDS_SESSION_REJECTED))
>  			__unregister_session(mdsc, session);

Note that this is not exactly like pulling the power cable. The
connection will be closed, which will send a FIN to the peer.

>  		__wake_requests(mdsc, &session->s_waiting);
>  		mutex_unlock(&mdsc->mutex);
> diff --git a/fs/ceph/mds_client.h b/fs/ceph/mds_client.h
> index c13910da07c4..b66eea830ae1 100644
> --- a/fs/ceph/mds_client.h
> +++ b/fs/ceph/mds_client.h
> @@ -478,7 +478,8 @@ extern int ceph_send_msg_mds(struct ceph_mds_client *mdsc,
>  
>  extern int ceph_mdsc_init(struct ceph_fs_client *fsc);
>  extern void ceph_mdsc_close_sessions(struct ceph_mds_client *mdsc);
> -extern void ceph_mdsc_force_umount(struct ceph_mds_client *mdsc);
> +extern void ceph_mdsc_force_umount(struct ceph_mds_client *mdsc,
> +				   bool halt);
>  extern void ceph_mdsc_destroy(struct ceph_fs_client *fsc);
>  
>  extern void ceph_mdsc_sync(struct ceph_mds_client *mdsc);
> diff --git a/fs/ceph/super.c b/fs/ceph/super.c
> index 8b52bea13273..2a6fd5d2fffa 100644
> --- a/fs/ceph/super.c
> +++ b/fs/ceph/super.c
> @@ -155,6 +155,7 @@ enum {
>  	Opt_acl,
>  	Opt_quotadf,
>  	Opt_copyfrom,
> +	Opt_halt,
>  };
>  
>  enum ceph_recover_session_mode {
> @@ -194,6 +195,7 @@ static const struct fs_parameter_spec ceph_mount_param_specs[] = {
>  	fsparam_string	("snapdirname",			Opt_snapdirname),
>  	fsparam_string	("source",			Opt_source),
>  	fsparam_u32	("wsize",			Opt_wsize),
> +	fsparam_flag	("halt",			Opt_halt),
>  	{}
>  };
>  
> @@ -435,6 +437,9 @@ static int ceph_parse_mount_param(struct fs_context *fc,
>  			fc->sb_flags &= ~SB_POSIXACL;
>  		}
>  		break;
> +	case Opt_halt:
> +		fsopt->flags |= CEPH_MOUNT_OPT_HALT;
> +		break;
>  	default:
>  		BUG();
>  	}
> @@ -601,6 +606,8 @@ static int ceph_show_options(struct seq_file *m, struct dentry *root)
>  	if (m->count == pos)
>  		m->count--;
>  
> +	if (fsopt->flags & CEPH_MOUNT_OPT_HALT)
> +		seq_puts(m, ",halt");
>  	if (fsopt->flags & CEPH_MOUNT_OPT_DIRSTAT)
>  		seq_puts(m, ",dirstat");
>  	if ((fsopt->flags & CEPH_MOUNT_OPT_RBYTES))
> @@ -877,22 +884,28 @@ static void destroy_caches(void)
>  }
>  
>  /*
> - * ceph_umount_begin - initiate forced umount.  Tear down down the
> - * mount, skipping steps that may hang while waiting for server(s).
> + * ceph_umount_begin - initiate forced umount.  Tear down the mount,
> + * skipping steps that may hang while waiting for server(s).
>   */
> -static void ceph_umount_begin(struct super_block *sb)
> +static void __ceph_umount_begin(struct super_block *sb, bool halt)
>  {
>  	struct ceph_fs_client *fsc = ceph_sb_to_client(sb);
>  
> -	dout("ceph_umount_begin - starting forced umount\n");
>  	if (!fsc)
>  		return;
>  	fsc->mount_state = CEPH_MOUNT_SHUTDOWN;
>  	ceph_osdc_abort_requests(&fsc->client->osdc, -EIO);
> -	ceph_mdsc_force_umount(fsc->mdsc);
> +	ceph_mdsc_force_umount(fsc->mdsc, halt);
>  	fsc->filp_gen++; // invalidate open files
>  }
>  
> +static void ceph_umount_begin(struct super_block *sb)
> +{
> +	dout("%s - starting forced umount\n", __func__);
> +
> +	__ceph_umount_begin(sb, false);
> +}
> +
>  static const struct super_operations ceph_super_ops = {
>  	.alloc_inode	= ceph_alloc_inode,
>  	.free_inode	= ceph_free_inode,
> @@ -1193,6 +1206,16 @@ static int ceph_reconfigure_fc(struct fs_context *fc)
>  	struct ceph_parse_opts_ctx *pctx = fc->fs_private;
>  	struct ceph_mount_options *new_fsopt = pctx->opts;
>  
> +	/* halt the mount point, will ignore other options */
> +	if (new_fsopt->flags & CEPH_MOUNT_OPT_HALT) {
> +		dout("halt the mount point\n");
> +		fsopt->flags |= CEPH_MOUNT_OPT_HALT;
> +		__ceph_umount_begin(sb, true);
> +		ceph_halt_client(fsc->client);
> +
> +		return 0;
> +	}
> +
>  	sync_filesystem(sb);
>  
>  	if (strcmp_null(new_fsopt->snapdir_name, fsopt->snapdir_name))
> diff --git a/fs/ceph/super.h b/fs/ceph/super.h
> index 4c40e86ad016..64f16083b216 100644
> --- a/fs/ceph/super.h
> +++ b/fs/ceph/super.h
> @@ -43,6 +43,7 @@
>  #define CEPH_MOUNT_OPT_MOUNTWAIT       (1<<12) /* mount waits if no mds is up */
>  #define CEPH_MOUNT_OPT_NOQUOTADF       (1<<13) /* no root dir quota in statfs */
>  #define CEPH_MOUNT_OPT_NOCOPYFROM      (1<<14) /* don't use RADOS 'copy-from' op */
> +#define CEPH_MOUNT_OPT_HALT            (1<<15) /* halt the mount point */
>  
>  #define CEPH_MOUNT_OPT_DEFAULT			\
>  	(CEPH_MOUNT_OPT_DCACHE |		\
> diff --git a/include/linux/ceph/libceph.h b/include/linux/ceph/libceph.h
> index 8fe9b80e80a5..12e9f0cc8501 100644
> --- a/include/linux/ceph/libceph.h
> +++ b/include/linux/ceph/libceph.h
> @@ -295,6 +295,7 @@ struct ceph_client *ceph_create_client(struct ceph_options *opt, void *private);
>  struct ceph_entity_addr *ceph_client_addr(struct ceph_client *client);
>  u64 ceph_client_gid(struct ceph_client *client);
>  extern void ceph_destroy_client(struct ceph_client *client);
> +void ceph_halt_client(struct ceph_client *client);
>  extern void ceph_reset_client_addr(struct ceph_client *client);
>  extern int __ceph_open_session(struct ceph_client *client,
>  			       unsigned long started);
> diff --git a/include/linux/ceph/mon_client.h b/include/linux/ceph/mon_client.h
> index dbb8a6959a73..7718a2e65d07 100644
> --- a/include/linux/ceph/mon_client.h
> +++ b/include/linux/ceph/mon_client.h
> @@ -78,6 +78,7 @@ struct ceph_mon_client {
>  	struct ceph_msg *m_auth, *m_auth_reply, *m_subscribe, *m_subscribe_ack;
>  	int pending_auth;
>  
> +	bool halt;
>  	bool hunting;
>  	int cur_mon;                       /* last monitor i contacted */
>  	unsigned long sub_renew_after;
> @@ -109,6 +110,7 @@ extern int ceph_monmap_contains(struct ceph_monmap *m,
>  
>  extern int ceph_monc_init(struct ceph_mon_client *monc, struct ceph_client *cl);
>  extern void ceph_monc_stop(struct ceph_mon_client *monc);
> +void ceph_monc_halt(struct ceph_mon_client *monc);
>  extern void ceph_monc_reopen_session(struct ceph_mon_client *monc);
>  
>  enum {
> diff --git a/include/linux/ceph/osd_client.h b/include/linux/ceph/osd_client.h
> index 02ff3a302d26..4b9143f7d989 100644
> --- a/include/linux/ceph/osd_client.h
> +++ b/include/linux/ceph/osd_client.h
> @@ -382,6 +382,7 @@ extern void ceph_osdc_cleanup(void);
>  extern int ceph_osdc_init(struct ceph_osd_client *osdc,
>  			  struct ceph_client *client);
>  extern void ceph_osdc_stop(struct ceph_osd_client *osdc);
> +extern void ceph_osdc_halt(struct ceph_osd_client *osdc);
>  extern void ceph_osdc_reopen_osds(struct ceph_osd_client *osdc);
>  
>  extern void ceph_osdc_handle_reply(struct ceph_osd_client *osdc,
> diff --git a/net/ceph/ceph_common.c b/net/ceph/ceph_common.c
> index a9d6c97b5b0d..c47578ed0546 100644
> --- a/net/ceph/ceph_common.c
> +++ b/net/ceph/ceph_common.c
> @@ -652,6 +652,20 @@ struct ceph_client *ceph_create_client(struct ceph_options *opt, void *private)
>  }
>  EXPORT_SYMBOL(ceph_create_client);
>  
> +void ceph_halt_client(struct ceph_client *client)
> +{
> +	dout("halt_client %p\n", client);
> +
> +	atomic_set(&client->msgr.stopping, 1);
> +
> +	/* unmount */
> +	ceph_osdc_halt(&client->osdc);
> +	ceph_monc_halt(&client->monc);
> +
> +	dout("halt_client %p done\n", client);
> +}
> +EXPORT_SYMBOL(ceph_halt_client);
> +
>  void ceph_destroy_client(struct ceph_client *client)
>  {
>  	dout("destroy_client %p\n", client);
> diff --git a/net/ceph/mon_client.c b/net/ceph/mon_client.c
> index 9d9e4e4ea600..5819a02af7fe 100644
> --- a/net/ceph/mon_client.c
> +++ b/net/ceph/mon_client.c
> @@ -979,14 +979,16 @@ static void delayed_work(struct work_struct *work)
>  	mutex_lock(&monc->mutex);
>  	if (monc->hunting) {
>  		dout("%s continuing hunt\n", __func__);
> -		reopen_session(monc);
> +		if (!monc->halt)
> +			reopen_session(monc);
>  	} else {
>  		int is_auth = ceph_auth_is_authenticated(monc->auth);
>  		if (ceph_con_keepalive_expired(&monc->con,
>  					       CEPH_MONC_PING_TIMEOUT)) {
>  			dout("monc keepalive timeout\n");
>  			is_auth = 0;
> -			reopen_session(monc);
> +			if (!monc->halt)
> +				reopen_session(monc);
>  		}
>  
>  		if (!monc->hunting) {
> @@ -1115,6 +1117,16 @@ int ceph_monc_init(struct ceph_mon_client *monc, struct ceph_client *cl)
>  }
>  EXPORT_SYMBOL(ceph_monc_init);
>  
> +void ceph_monc_halt(struct ceph_mon_client *monc)
> +{
> +	dout("monc halt\n");
> +
> +	mutex_lock(&monc->mutex);
> +	monc->halt = true;
> +	ceph_con_close(&monc->con);
> +	mutex_unlock(&monc->mutex);
> +}
> +

The changelog doesn't mention shutting down connections to the mons.

>  void ceph_monc_stop(struct ceph_mon_client *monc)
>  {
>  	dout("stop\n");
> diff --git a/net/ceph/osd_client.c b/net/ceph/osd_client.c
> index 108c9457d629..161daf35d7f1 100644
> --- a/net/ceph/osd_client.c
> +++ b/net/ceph/osd_client.c
> @@ -5202,6 +5202,17 @@ int ceph_osdc_init(struct ceph_osd_client *osdc, struct ceph_client *client)
>  	return err;
>  }
>  
> +void ceph_osdc_halt(struct ceph_osd_client *osdc)
> +{
> +	down_write(&osdc->lock);
> +	while (!RB_EMPTY_ROOT(&osdc->osds)) {
> +		struct ceph_osd *osd = rb_entry(rb_first(&osdc->osds),
> +						struct ceph_osd, o_node);
> +		close_osd(osd);
> +	}
> +	up_write(&osdc->lock);
> +}
> +
>  void ceph_osdc_stop(struct ceph_osd_client *osdc)
>  {
>  	destroy_workqueue(osdc->completion_wq);

-- 
Jeff Layton <jlayton@kernel.org>

