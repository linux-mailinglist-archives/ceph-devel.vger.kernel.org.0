Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A0252AE7AB
	for <lists+ceph-devel@lfdr.de>; Tue, 10 Sep 2019 12:11:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392136AbfIJKL2 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 10 Sep 2019 06:11:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:40256 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726142AbfIJKL2 (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Tue, 10 Sep 2019 06:11:28 -0400
Received: from tleilax.poochiereds.net (68-20-15-154.lightspeed.rlghnc.sbcglobal.net [68.20.15.154])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CBAE52067B;
        Tue, 10 Sep 2019 10:11:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568110287;
        bh=/sv86EXYpamicuJc0DartGaeeC7iUdx22MRZOFBjLE4=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=M4sXwjN/mVpT9K7IhMkCe4Xd/a60aW4pPJ4nN8tCeKMgEtUFS2YDlbCtKx1XBGs3T
         UNoJ39+IUNndMb4lG22uZNbF37PgM7N6WMcEi7hCVsMEyWiuI3Vk0kdMbAUK1jdcMu
         rIVHOX2Ktf8TfI5oa78lE4Yjhimcx5U+2RVNe33A=
Message-ID: <e413734270fc43cabbf9df09b0ed4bff06a96699.camel@kernel.org>
Subject: Re: [PATCH] ceph: add mount opt, always_auth
From:   Jeff Layton <jlayton@kernel.org>
To:     simon gao <simon29rock@gmail.com>, ceph-devel@vger.kernel.org
Cc:     Gregory Farnum <gfarnum@redhat.com>
Date:   Tue, 10 Sep 2019 06:11:25 -0400
In-Reply-To: <1568083391-920-1-git-send-email-simon29rock@gmail.com>
References: <1568083391-920-1-git-send-email-simon29rock@gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.32.4 (3.32.4-1.fc30) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Mon, 2019-09-09 at 22:43 -0400, simon gao wrote:
> In larger clusters (hundreds of millions of files). We have to pin the
> directory on a fixed mds now. Some op of client use USE_ANY_MDS mode
> to access mds, which may result in requests being sent to noauth mds
> and then forwarded to authmds.
> the opt is used to reduce forward ops by sending req to auth mds.
> ---
>  fs/ceph/mds_client.c | 7 ++++++-
>  fs/ceph/super.c      | 7 +++++++
>  fs/ceph/super.h      | 1 +
>  3 files changed, 14 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
> index 920e9f0..aca4490 100644
> --- a/fs/ceph/mds_client.c
> +++ b/fs/ceph/mds_client.c
> @@ -878,6 +878,7 @@ static struct inode *get_nonsnap_parent(struct dentry *dentry)
>  static int __choose_mds(struct ceph_mds_client *mdsc,
>  			struct ceph_mds_request *req)
>  {
> +	struct ceph_mount_options *ma = mdsc->fsc->mount_options;
>  	struct inode *inode;
>  	struct ceph_inode_info *ci;
>  	struct ceph_cap *cap;
> @@ -900,7 +901,11 @@ static int __choose_mds(struct ceph_mds_client *mdsc,
>  
>  	if (mode == USE_RANDOM_MDS)
>  		goto random;
> -
> +	// force to send the req to auth mds
> +	if (ma->flags & CEPH_MOUNT_OPT_ALWAYS_AUTH && mode != USE_AUTH_MDS){
> +		dout("change mode %d => USE_AUTH_MDS", mode);
> +		mode = USE_AUTH_MDS;
> +	}
>  	inode = NULL;
>  	if (req->r_inode) {
>  		if (ceph_snap(req->r_inode) != CEPH_SNAPDIR) {
> diff --git a/fs/ceph/super.c b/fs/ceph/super.c
> index ab4868c..1e81ebc 100644
> --- a/fs/ceph/super.c
> +++ b/fs/ceph/super.c
> @@ -169,6 +169,7 @@ enum {
>  	Opt_noquotadf,
>  	Opt_copyfrom,
>  	Opt_nocopyfrom,
> +	Opt_always_auth,
>  };
>  
>  static match_table_t fsopt_tokens = {
> @@ -210,6 +211,7 @@ enum {
>  	{Opt_noquotadf, "noquotadf"},
>  	{Opt_copyfrom, "copyfrom"},
>  	{Opt_nocopyfrom, "nocopyfrom"},
> +	{Opt_always_auth, "always_auth"},
>  	{-1, NULL}
>  };
>  
> @@ -381,6 +383,9 @@ static int parse_fsopt_token(char *c, void *private)
>  	case Opt_noacl:
>  		fsopt->sb_flags &= ~SB_POSIXACL;
>  		break;
> +	case Opt_always_auth:
> +		fsopt->flags |= CEPH_MOUNT_OPT_ALWAYS_AUTH;
> +		break;
>  	default:
>  		BUG_ON(token);
>  	}
> @@ -563,6 +568,8 @@ static int ceph_show_options(struct seq_file *m, struct dentry *root)
>  		seq_puts(m, ",nopoolperm");
>  	if (fsopt->flags & CEPH_MOUNT_OPT_NOQUOTADF)
>  		seq_puts(m, ",noquotadf");
> +	if (fsopt->flags & CEPH_MOUNT_OPT_ALWAYS_AUTH)
> +		seq_puts(m, ",always_auth");
>  
>  #ifdef CONFIG_CEPH_FS_POSIX_ACL
>  	if (fsopt->sb_flags & SB_POSIXACL)
> diff --git a/fs/ceph/super.h b/fs/ceph/super.h
> index 6b9f1ee..65f6423 100644
> --- a/fs/ceph/super.h
> +++ b/fs/ceph/super.h
> @@ -41,6 +41,7 @@
>  #define CEPH_MOUNT_OPT_MOUNTWAIT       (1<<12) /* mount waits if no mds is up */
>  #define CEPH_MOUNT_OPT_NOQUOTADF       (1<<13) /* no root dir quota in statfs */
>  #define CEPH_MOUNT_OPT_NOCOPYFROM      (1<<14) /* don't use RADOS 'copy-from' op */
> +#define CEPH_MOUNT_OPT_ALWAYS_AUTH     (1<<15) /* send op to auth mds, not to replicative mds */
>  
>  #define CEPH_MOUNT_OPT_DEFAULT			\
>  	(CEPH_MOUNT_OPT_DCACHE |		\

I've no particular objection here, but I'd prefer Greg's ack before we
merge it, since he raised earlier concerns.

If we are going to take it, then this will need to be rebased on top of
the mount API conversion that's currently in ceph-client/testing branch.
-- 
Jeff Layton <jlayton@kernel.org>

