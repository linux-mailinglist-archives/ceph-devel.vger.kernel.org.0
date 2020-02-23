Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3CE12169994
	for <lists+ceph-devel@lfdr.de>; Sun, 23 Feb 2020 20:18:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726678AbgBWTSf (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Sun, 23 Feb 2020 14:18:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:39064 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726208AbgBWTSf (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Sun, 23 Feb 2020 14:18:35 -0500
Received: from tleilax.poochiereds.net (68-20-15-154.lightspeed.rlghnc.sbcglobal.net [68.20.15.154])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5DAD8206E0;
        Sun, 23 Feb 2020 19:18:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582485513;
        bh=7gZR0U0OKqFVfunXPZf+epq4S+arQfDDgUcn+4aU4AU=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=ZIw1EhRCstH9fEOtLmCcZKPsE0rsxUPpB6cUo8vykai7Y4IzDYO/dJu4ZzY1zHHWB
         NM9F1BwCNdhYX74bnK8UGJAFzhZozOWix2jQ+EdVDvaHZ8Q4DbtlvC7riSysARnP1s
         nVtKURK09tEFz0Y3QYkSkAsv8VQLl1WXGv8AJ/T0=
Message-ID: <e430129d5d670c929cae62acd5a6714624d7b3db.camel@kernel.org>
Subject: Re: [PATCH] ceph: show more detail logs during mount
From:   Jeff Layton <jlayton@kernel.org>
To:     xiubli@redhat.com, idryomov@gmail.com
Cc:     sage@redhat.com, zyan@redhat.com, pdonnell@redhat.com,
        ceph-devel@vger.kernel.org
Date:   Sun, 23 Feb 2020 14:18:32 -0500
In-Reply-To: <20200223121808.5584-1-xiubli@redhat.com>
References: <20200223121808.5584-1-xiubli@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.4 (3.34.4-1.fc31) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Sun, 2020-02-23 at 07:18 -0500, xiubli@redhat.com wrote:
> From: Xiubo Li <xiubli@redhat.com>
> 
> Return -ETIMEDOUT when the requests are timed out instead of -EIO
> to make it cleaner for the userland. And just print the logs in
> error level to give a helpful hint.
> 
> URL: https://tracker.ceph.com/issues/44215
> Signed-off-by: Xiubo Li <xiubli@redhat.com>
> ---
>  fs/ceph/mds_client.c   |  4 ++--
>  fs/ceph/super.c        | 28 ++++++++++++++++++++--------
>  net/ceph/ceph_common.c |  7 +++++--
>  net/ceph/mon_client.c  |  1 +
>  4 files changed, 28 insertions(+), 12 deletions(-)
> 
> diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
> index 82f63ef2694c..0dfea8cdb50a 100644
> --- a/fs/ceph/mds_client.c
> +++ b/fs/ceph/mds_client.c
> @@ -2578,7 +2578,7 @@ static void __do_request(struct ceph_mds_client *mdsc,
>  	if (req->r_timeout &&
>  	    time_after_eq(jiffies, req->r_started + req->r_timeout)) {
>  		dout("do_request timed out\n");
> -		err = -EIO;
> +		err = -ETIMEDOUT;
>  		goto finish;
>  	}
>  	if (READ_ONCE(mdsc->fsc->mount_state) == CEPH_MOUNT_SHUTDOWN) {
> @@ -2752,7 +2752,7 @@ static int ceph_mdsc_wait_request(struct ceph_mds_client *mdsc,
>  		if (timeleft > 0)
>  			err = 0;
>  		else if (!timeleft)
> -			err = -EIO;  /* timed out */
> +			err = -ETIMEDOUT;  /* timed out */
>  		else
>  			err = timeleft;  /* killed */
>  	}

I'm fine with the two hunks above.

Note that AFAICT, r_timeout is only set at mount time, so we should
never see this in other codepaths. This probably ought to be done in a
separate patch from the rest.

> diff --git a/fs/ceph/super.c b/fs/ceph/super.c
> index 31acb4fe1f2c..6778f2a7d6d4 100644
> --- a/fs/ceph/super.c
> +++ b/fs/ceph/super.c
> @@ -849,11 +849,13 @@ static struct dentry *open_root_dentry(struct ceph_fs_client *fsc,
>  {
>  	struct ceph_mds_client *mdsc = fsc->mdsc;
>  	struct ceph_mds_request *req = NULL;
> +	struct ceph_mds_session *session;
>  	int err;
>  	struct dentry *root;
> +	char buf[32] = {0};
>  
>  	/* open dir */
> -	dout("open_root_inode opening '%s'\n", path);
> +	dout("mount open_root_inode opening '%s'\n", path);
>  	req = ceph_mdsc_create_request(mdsc, CEPH_MDS_OP_GETATTR, USE_ANY_MDS);
>  	if (IS_ERR(req))
>  		return ERR_CAST(req);
> @@ -873,18 +875,26 @@ static struct dentry *open_root_dentry(struct ceph_fs_client *fsc,
>  	if (err == 0) {
>  		struct inode *inode = req->r_target_inode;
>  		req->r_target_inode = NULL;
> -		dout("open_root_inode success\n");
>  		root = d_make_root(inode);
>  		if (!root) {
>  			root = ERR_PTR(-ENOMEM);
>  			goto out;
>  		}
> -		dout("open_root_inode success, root dentry is %p\n", root);
> +		dout(" root dentry is %p\n", root);
>  	} else {
>  		root = ERR_PTR(err);
>  	}
>  out:
> +	session = ceph_get_mds_session(req->r_session);
> +	if (session)
> +		snprintf(buf, 32, " on mds%d", session->s_mds);
> +

Where is this new session reference put? I'm not sure I understand this
change.

>  	ceph_mdsc_put_request(req);
> +	if (!IS_ERR(root))
> +		dout("mount open_root_inode success%s\n", buf[0] ? buf : "");
> +	else
> +		pr_err("mount open_root_inode fail %ld%s\n", PTR_ERR(root),
> +		       buf[0] ? buf : "");
>  	return root;
>  }
>  

This goes to the generic kernel log. This may warrant an error message
there, but it needs to be something a typical user would understand.

> @@ -937,6 +947,7 @@ static struct dentry *ceph_real_mount(struct ceph_fs_client *fsc,
>  
>  out:
>  	mutex_unlock(&fsc->client->mount_mutex);
> +	pr_err("mount fail\n");

This is not something we'd want to add here.

>  	return ERR_PTR(err);
>  }
>  
> @@ -1028,7 +1039,7 @@ static int ceph_get_tree(struct fs_context *fc)
>  		ceph_compare_super;
>  	int err;
>  
> -	dout("ceph_get_tree\n");
> +	dout("ceph_get_tree start\n");
>  
>  	if (!fc->source)
>  		return invalfc(fc, "No source");
> @@ -1073,14 +1084,15 @@ static int ceph_get_tree(struct fs_context *fc)
>  		err = PTR_ERR(res);
>  		goto out_splat;
>  	}
> -	dout("root %p inode %p ino %llx.%llx\n", res,
> -	     d_inode(res), ceph_vinop(d_inode(res)));
> +        dout(" root %p inode %p ino %llx.%llx\n",
> +	     res, d_inode(res), ceph_vinop(d_inode(res)));
>  	fc->root = fsc->sb->s_root;
> +	dout("ceph_get_tree success\n");
>  	return 0;
>  
>  out_splat:
>  	if (!ceph_mdsmap_is_cluster_available(fsc->mdsc->mdsmap)) {
> -		pr_info("No mds server is up or the cluster is laggy\n");
> +		pr_err("No mds server is up or the cluster is laggy\n");
> 		err = -EHOSTUNREACH;

Is pr_err the right infolevel here? It may be, I'm just curious why the
change after making this pr_info before.

>  	}
>  
> @@ -1091,7 +1103,7 @@ static int ceph_get_tree(struct fs_context *fc)
>  out:
>  	destroy_fs_client(fsc);
>  out_final:
> -	dout("ceph_get_tree fail %d\n", err);
> +	pr_err("ceph_get_tree fail %d\n", err);

This doesn't seem to be something we want to pr_err.

>  	return err;
>  }
>  
> diff --git a/net/ceph/ceph_common.c b/net/ceph/ceph_common.c
> index a0e97f6c1072..5971a815fb8e 100644
> --- a/net/ceph/ceph_common.c
> +++ b/net/ceph/ceph_common.c
> @@ -700,11 +700,14 @@ int __ceph_open_session(struct ceph_client *client, unsigned long started)
>  		return err;
>  
>  	while (!have_mon_and_osd_map(client)) {
> -		if (timeout && time_after_eq(jiffies, started + timeout))
> +		if (timeout && time_after_eq(jiffies, started + timeout)) {
> +			pr_err("mount wating for mon/osd maps timed out on mon%d\n",
> +			       client->monc.cur_mon);
>  			return -ETIMEDOUT;
> +		}
> 

This code is also called from RBD codepaths and those don't necessarily
involve a "mount". You should consider how to make the new message more
generic, or maybe handle it at a higher level, so that rbd isn't
affected.

>  		/* wait */
> -		dout("mount waiting for mon_map\n");
> +		dout("mount waiting for mon/osd maps\n");
>  		err = wait_event_interruptible_timeout(client->auth_wq,
>  			have_mon_and_osd_map(client) || (client->auth_err < 0),
>  			ceph_timeout_jiffies(timeout));


> diff --git a/net/ceph/mon_client.c b/net/ceph/mon_client.c
> index 9d9e4e4ea600..8f09df9c3aee 100644
> --- a/net/ceph/mon_client.c
> +++ b/net/ceph/mon_client.c
> @@ -1179,6 +1179,7 @@ static void handle_auth_reply(struct ceph_mon_client *monc,
>  
>  	if (ret < 0) {
>  		monc->client->auth_err = ret;
> +		pr_err("mon%d session auth failed %d\n", monc->cur_mon, ret);
>  	} else if (!was_auth && ceph_auth_is_authenticated(monc->auth)) {
>  		dout("authenticated, starting session\n");
>  

Again, these need to be human-readable, and not just debugging messages
that are hard to disable.
-- 
Jeff Layton <jlayton@kernel.org>

