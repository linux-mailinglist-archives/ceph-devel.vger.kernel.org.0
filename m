Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D15E415AD8B
	for <lists+ceph-devel@lfdr.de>; Wed, 12 Feb 2020 17:41:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727923AbgBLQla (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 12 Feb 2020 11:41:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:46608 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727372AbgBLQla (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Wed, 12 Feb 2020 11:41:30 -0500
Received: from tleilax.poochiereds.net (68-20-15-154.lightspeed.rlghnc.sbcglobal.net [68.20.15.154])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4627920714;
        Wed, 12 Feb 2020 16:41:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581525688;
        bh=6w5RXgxmsnlGLVf2ScASAMuXVCg+aZQTzBTNiXAaLUA=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=o00RihTbaMCyBDaxMoV4d0X4ee6bO1TtqTdmsdZg2lqp08aW5pm3trrO3OhOHWRvv
         jB83MfVmOSoKx0NZtLeMyertE9booiNqLtCE0GMg9BuhIry0vs/C7akRC8F9Gie8IY
         r7oRIo7Msggi8OmOo/1rDQ0gQLIrtHghpfidFpjc=
Message-ID: <576dc97ce9e62af9baaaa069f2959f518a5d3d35.camel@kernel.org>
Subject: Re: [PATCH] ceph: fs add reconfiguring superblock parameters support
From:   Jeff Layton <jlayton@kernel.org>
To:     Xiubo Li <xiubli@redhat.com>, idryomov@gmail.com
Cc:     sage@redhat.com, zyan@redhat.com, pdonnell@redhat.com,
        ceph-devel@vger.kernel.org
Date:   Wed, 12 Feb 2020 11:41:27 -0500
In-Reply-To: <8fa89139-4774-65f7-fc48-e1ef368beb6e@redhat.com>
References: <20200212085454.35665-1-xiubli@redhat.com>
         <c2571e75d3fe3f37ea77c5b1acaa5e3dcc45cb2b.camel@kernel.org>
         <8fa89139-4774-65f7-fc48-e1ef368beb6e@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.3 (3.34.3-1.fc31) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Wed, 2020-02-12 at 23:01 +0800, Xiubo Li wrote:
> On 2020/2/12 20:01, Jeff Layton wrote:
> > On Wed, 2020-02-12 at 03:54 -0500, xiubli@redhat.com wrote:
> > > From: Xiubo Li <xiubli@redhat.com>
> > > 
> > > This will enable the remount and reconfiguring superblock params
> > > for the fs. Currently some mount options are not allowed to be
> > > reconfigured.
> > > 
> > > It will working like:
> > > $ mount.ceph :/ /mnt/cephfs -o remount,mount_timeout=100
> > > 
> > > URL:https://tracker.ceph.com/issues/44071
> > > Signed-off-by: Xiubo Li <xiubli@redhat.com>
> > > ---
> > >   block/bfq-cgroup.c           |   1 +
> > >   drivers/block/rbd.c          |   2 +-
> > >   fs/ceph/caps.c               |   2 +
> > >   fs/ceph/mds_client.c         |   5 +-
> > >   fs/ceph/super.c              | 126 +++++++++++++++++++++++++++++------
> > >   fs/ceph/super.h              |   2 +
> > >   include/linux/ceph/libceph.h |   4 +-
> > >   net/ceph/ceph_common.c       |  83 ++++++++++++++++++++---
> > >   8 files changed, 192 insertions(+), 33 deletions(-)
> > > 
> > > diff --git a/block/bfq-cgroup.c b/block/bfq-cgroup.c
> > > index e1419edde2ec..b3d42200182e 100644
> > > --- a/block/bfq-cgroup.c
> > > +++ b/block/bfq-cgroup.c
> > > @@ -12,6 +12,7 @@
> > >   #include <linux/ioprio.h>
> > >   #include <linux/sbitmap.h>
> > >   #include <linux/delay.h>
> > > +#include <linux/rbtree.h>
> > >   
> > >   #include "bfq-iosched.h"
> > >   
> > > diff --git a/drivers/block/rbd.c b/drivers/block/rbd.c
> > > index 4e494d5600cc..470de27cf809 100644
> > > --- a/drivers/block/rbd.c
> > > +++ b/drivers/block/rbd.c
> > > @@ -6573,7 +6573,7 @@ static int rbd_add_parse_args(const char *buf,
> > >   	*(snap_name + len) = '\0';
> > >   	pctx.spec->snap_name = snap_name;
> > >   
> > > -	pctx.copts = ceph_alloc_options();
> > > +	pctx.copts = ceph_alloc_options(NULL);
> > >   	if (!pctx.copts)
> > >   		goto out_mem;
> > >   
> > > diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
> > > index b4f122eb74bb..020f83186f94 100644
> > > --- a/fs/ceph/caps.c
> > > +++ b/fs/ceph/caps.c
> > > @@ -491,10 +491,12 @@ static void __cap_set_timeouts(struct ceph_mds_client *mdsc,
> > >   {
> > >   	struct ceph_mount_options *opt = mdsc->fsc->mount_options;
> > >   
> > > +	spin_lock(&opt->ceph_opt_lock);
> > >   	ci->i_hold_caps_min = round_jiffies(jiffies +
> > >   					    opt->caps_wanted_delay_min * HZ);
> > >   	ci->i_hold_caps_max = round_jiffies(jiffies +
> > >   					    opt->caps_wanted_delay_max * HZ);
> > > +	spin_unlock(&opt->ceph_opt_lock);
> > >   	dout("__cap_set_timeouts %p min %lu max %lu\n", &ci->vfs_inode,
> > >   	     ci->i_hold_caps_min - jiffies, ci->i_hold_caps_max - jiffies);
> > >   }
> > > diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
> > > index 376e7cf1685f..451c3727cd0b 100644
> > > --- a/fs/ceph/mds_client.c
> > > +++ b/fs/ceph/mds_client.c
> > > @@ -2099,6 +2099,7 @@ int ceph_alloc_readdir_reply_buffer(struct ceph_mds_request *req,
> > >   	struct ceph_inode_info *ci = ceph_inode(dir);
> > >   	struct ceph_mds_reply_info_parsed *rinfo = &req->r_reply_info;
> > >   	struct ceph_mount_options *opt = req->r_mdsc->fsc->mount_options;
> > > +	unsigned int max_readdir = opt->max_readdir;
> > >   	size_t size = sizeof(struct ceph_mds_reply_dir_entry);
> > >   	unsigned int num_entries;
> > >   	int order;
> > > @@ -2107,7 +2108,7 @@ int ceph_alloc_readdir_reply_buffer(struct ceph_mds_request *req,
> > >   	num_entries = ci->i_files + ci->i_subdirs;
> > >   	spin_unlock(&ci->i_ceph_lock);
> > >   	num_entries = max(num_entries, 1U);
> > > -	num_entries = min(num_entries, opt->max_readdir);
> > > +	num_entries = min(num_entries, max_readdir);
> > >   
> > >   	order = get_order(size * num_entries);
> > >   	while (order >= 0) {
> > > @@ -2122,7 +2123,7 @@ int ceph_alloc_readdir_reply_buffer(struct ceph_mds_request *req,
> > >   		return -ENOMEM;
> > >   
> > >   	num_entries = (PAGE_SIZE << order) / size;
> > > -	num_entries = min(num_entries, opt->max_readdir);
> > > +	num_entries = min(num_entries, max_readdir);
> > >   
> > >   	rinfo->dir_buf_size = PAGE_SIZE << order;
> > >   	req->r_num_caps = num_entries + 1;
> > > diff --git a/fs/ceph/super.c b/fs/ceph/super.c
> > > index 9a21054059f2..8df506dd9039 100644
> > > --- a/fs/ceph/super.c
> > > +++ b/fs/ceph/super.c
> > > @@ -1175,7 +1175,57 @@ static void ceph_free_fc(struct fs_context *fc)
> > >   
> > >   static int ceph_reconfigure_fc(struct fs_context *fc)
> > >   {
> > > -	sync_filesystem(fc->root->d_sb);
> > > +	struct super_block *sb = fc->root->d_sb;
> > > +	struct ceph_fs_client *fsc = ceph_sb_to_client(sb);
> > > +	struct ceph_mount_options *fsopt = fsc->mount_options;
> > > +	struct ceph_parse_opts_ctx *pctx = fc->fs_private;
> > > +	struct ceph_mount_options *new_fsopt = pctx->opts;
> > > +	int ret;
> > > +
> > > +	sync_filesystem(sb);
> > > +
> > > +	ret = ceph_reconfigure_copts(fc, pctx->copts, fsc->client->options);
> > > +	if (ret)
> > > +		return ret;
> > > +
> > > +	if (new_fsopt->snapdir_name != fsopt->snapdir_name)
> > > +		return invalf(fc, "ceph: reconfiguration of snapdir_name not allowed");
> > > +
> > > +	if (new_fsopt->mds_namespace != fsopt->mds_namespace)
> > > +		return invalf(fc, "ceph: reconfiguration of mds_namespace not allowed");
> > > +
> > > +	if (new_fsopt->wsize != fsopt->wsize)
> > > +		return invalf(fc, "ceph: reconfiguration of wsize not allowed");
> > > +	if (new_fsopt->rsize != fsopt->rsize)
> > > +		return invalf(fc, "ceph: reconfiguration of rsize not allowed");
> > > +	if (new_fsopt->rasize != fsopt->rasize)
> > > +		return invalf(fc, "ceph: reconfiguration of rasize not allowed");
> > > +
> > Odd. I would think the wsize, rsize and rasize are things you _could_
> > reconfigure at remount time.
> 
> There has some race for the wsize,
> 
> 
> > In any case, I agree with Ilya. Not everything can be changed on a
> > remount. It'd be best to identify some small subset of mount options
> > that you do need to allow to be changed, and ensure we can do that.
> 
> Yeah, I have disabled some already which may be racing when changing 
> them in remount.
> 
> Will disable the low level ones and some others in next version.
> 
> 
> > > diff --git a/fs/ceph/super.h b/fs/ceph/super.h
> > > index 2acb09980432..ad44b98f3c3b 100644
> > > --- a/fs/ceph/super.h
> > > +++ b/fs/ceph/super.h
> > > @@ -95,6 +95,8 @@ struct ceph_mount_options {
> > >   	char *mds_namespace;  /* default NULL */
> > >   	char *server_path;    /* default  "/" */
> > >   	char *fscache_uniq;   /* default NULL */
> > > +
> > > +	spinlock_t ceph_opt_lock;
> > I'm not sure we really need an extra lock around these fields,
> > particularly if you're intending to only allow a few different things to
> > be changed at remount.
> 
> This will only protect the "fsopt->caps_wanted_delay_min" and 
> "fsopt->caps_wanted_delay_min", just in case we are changing them both 
> which may be racing with __cap_set_timeouts().
> 
> For example:
> 
> The old range is [40, 60] and if the new range is [10, 30], we may hit 
> the [i_hold_caps_min, i_hold_caps_max] are set as [40, 30].
> 

For parameters that are linked like that, you could also consider a
seqlock. Having to take a spinlock to just read sort of sucks, when most
of the time there should be no change occurring.

-- 
Jeff Layton <jlayton@kernel.org>

