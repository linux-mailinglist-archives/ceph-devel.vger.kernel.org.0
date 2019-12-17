Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 211FC122C4E
	for <lists+ceph-devel@lfdr.de>; Tue, 17 Dec 2019 13:52:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727621AbfLQMwz (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 17 Dec 2019 07:52:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:52070 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726920AbfLQMwz (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Tue, 17 Dec 2019 07:52:55 -0500
Received: from tleilax.poochiereds.net (68-20-15-154.lightspeed.rlghnc.sbcglobal.net [68.20.15.154])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 157952072D;
        Tue, 17 Dec 2019 12:52:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576587174;
        bh=V9PIr3nEOrRp98f4uDerja29cWXZNIMaFdksHuN7UdE=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=Br/7CodPKtVsnaGOAdwxf2NZRwwUnA5ZN0mWXgtZlansCzOPXGdISBiJcfoHvwin5
         BapOF15+9BbKxQ0qaG9/enW/UoyyaAnG78rjpKLoLEqUWYr/JfnY52c9/5ZtSUKmov
         FzLH6Xo6cJ3n+7j/i90BmmXtGRSCJqFter6V0kIs=
Message-ID: <36ce4302dfe0716fa8db9f1bd08f47ecc984d627.camel@kernel.org>
Subject: Re: [PATCH v2] ceph: remove the extra slashes in the server path
From:   Jeff Layton <jlayton@kernel.org>
To:     xiubli@redhat.com
Cc:     sage@redhat.com, idryomov@gmail.com, zyan@redhat.com,
        pdonnell@redhat.com, ceph-devel@vger.kernel.org
Date:   Tue, 17 Dec 2019 07:52:53 -0500
In-Reply-To: <20191217050231.3856-1-xiubli@redhat.com>
References: <20191217050231.3856-1-xiubli@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.2 (3.34.2-1.fc31) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Tue, 2019-12-17 at 00:02 -0500, xiubli@redhat.com wrote:
> From: Xiubo Li <xiubli@redhat.com>
> 
> When mounting if the server path has more than one slash continously,
> such as:
> 
> 'mount.ceph 192.168.195.165:40176:/// /mnt/cephfs/'
> 
> In the MDS server side the extra slashes of the server path will be
> treated as snap dir, and then we can get the following debug logs:
> 
> <7>[  ...] ceph:  mount opening path //
> <7>[  ...] ceph:  open_root_inode opening '//'
> <7>[  ...] ceph:  fill_trace 0000000059b8a3bc is_dentry 0 is_target 1
> <7>[  ...] ceph:  alloc_inode 00000000dc4ca00b
> <7>[  ...] ceph:  get_inode created new inode 00000000dc4ca00b 1.ffffffffffffffff ino 1
> <7>[  ...] ceph:  get_inode on 1=1.ffffffffffffffff got 00000000dc4ca00b
> 
> And then when creating any new file or directory under the mount
> point, we can get the following crash core dump:
> 
> <4>[  ...] ------------[ cut here ]------------
> <2>[  ...] kernel BUG at fs/ceph/inode.c:1347!
> <4>[  ...] invalid opcode: 0000 [#1] SMP PTI
> <4>[  ...] CPU: 0 PID: 7 Comm: kworker/0:1 Tainted: G            E     5.4.0-rc5+ #1
> <4>[  ...] Hardware name: VMware, Inc. VMware Virtual Platform/440BX Desktop Reference Platform, BIOS 6.00 05/19/2017
> <4>[  ...] Workqueue: ceph-msgr ceph_con_workfn [libceph]
> <4>[  ...] RIP: 0010:ceph_fill_trace+0x992/0xb30 [ceph]
> <4>[  ...] Code: ff 0f 0b 0f 0b 0f 0b 4c 89 fa 48 c7 c6 4d [...]
> <4>[  ...] RSP: 0018:ffffa23d40067c70 EFLAGS: 00010297
> <4>[  ...] RAX: fffffffffffffffe RBX: ffff8a229eb566c0 RCX: 0000000000000006
> <4>[  ...] RDX: 0000000000000000 RSI: 0000000000000092 RDI: ffff8a23aec17900
> <4>[  ...] RBP: ffff8a226bd91eb0 R08: 0000000000000001 R09: 0000000000000885
> <4>[  ...] R10: 000000000002dfd8 R11: ffff8a226bd95b30 R12: ffff8a239347e000
> <4>[  ...] R13: 0000000000000000 R14: ffff8a22fabeb000 R15: ffff8a2338b0c900
> <4>[  ...] FS:  0000000000000000(0000) GS:ffff8a23aec00000(0000) knlGS:0000000000000000
> <4>[  ...] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> <4>[  ...] CR2: 000055b479d92068 CR3: 00000003764f6004 CR4: 00000000003606f0
> <4>[  ...] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> <4>[  ...] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> <4>[  ...] Call Trace:
> <4>[  ...]  dispatch+0x2ac/0x12b0 [ceph]
> <4>[  ...]  ceph_con_workfn+0xd40/0x27c0 [libceph]
> <4>[  ...]  process_one_work+0x1b0/0x350
> <4>[  ...]  worker_thread+0x50/0x3b0
> <4>[  ...]  kthread+0xfb/0x130
> <4>[  ...]  ? process_one_work+0x350/0x350
> <4>[  ...]  ? kthread_park+0x90/0x90
> <4>[  ...]  ret_from_fork+0x35/0x40
> <4>[  ...] Modules linked in: ceph(E) libceph fscache [...]
> <4>[  ...] ---[ end trace ba883d8ccf9afcb0 ]---
> <4>[  ...] RIP: 0010:ceph_fill_trace+0x992/0xb30 [ceph]
> <4>[  ...] Code: ff 0f 0b 0f 0b 0f 0b 4c 89 fa 48 c7 c6 [...]
> <4>[  ...] RSP: 0018:ffffa23d40067c70 EFLAGS: 00010297
> <4>[  ...] RAX: fffffffffffffffe RBX: ffff8a229eb566c0 RCX: 0000000000000006
> <4>[  ...] RDX: 0000000000000000 RSI: 0000000000000092 RDI: ffff8a23aec17900
> <4>[  ...] RBP: ffff8a226bd91eb0 R08: 0000000000000001 R09: 0000000000000885
> <4>[  ...] R10: 000000000002dfd8 R11: ffff8a226bd95b30 R12: ffff8a239347e000
> <4>[  ...] R13: 0000000000000000 R14: ffff8a22fabeb000 R15: ffff8a2338b0c900
> <4>[  ...] FS:  0000000000000000(0000) GS:ffff8a23aec00000(0000) knlGS:0000000000000000
> <4>[  ...] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> <4>[  ...] CR2: 000055b479d92068 CR3: 00000003764f6004 CR4: 00000000003606f0
> <4>[  ...] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> <4>[  ...] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> 
> And we should ignore the extra slashes in the server path when mount
> opening in case users have added them by mistake.
> 
> This will also help us to get an existing superblock if all the
> other options are the same, such as all the following server paths
> are treated as the same:
> 
> 1) "//mydir1///mydir//"
> 2) "/mydir1/mydir"
> 3) "/mydir1/mydir/"
> 
> The mount_options->server_path will always save the original string
> including the leading '/'.
> 
> Signed-off-by: Xiubo Li <xiubli@redhat.com>
> ---
>  fs/ceph/super.c | 108 +++++++++++++++++++++++++++++++++++++++++-------
>  1 file changed, 93 insertions(+), 15 deletions(-)
> 
> diff --git a/fs/ceph/super.c b/fs/ceph/super.c
> index 6f33a265ccf1..9fe1bfac66a2 100644
> --- a/fs/ceph/super.c
> +++ b/fs/ceph/super.c
> @@ -211,7 +211,6 @@ struct ceph_parse_opts_ctx {
>  
>  /*
>   * Parse the source parameter.  Distinguish the server list from the path.
> - * Internally we do not include the leading '/' in the path.
>   *
>   * The source will look like:
>   *     <server_spec>[,<server_spec>...]:[<path>]
> @@ -232,12 +231,15 @@ static int ceph_parse_source(struct fs_parameter *param, struct fs_context *fc)
>  
>  	dev_name_end = strchr(dev_name, '/');
>  	if (dev_name_end) {
> -		if (strlen(dev_name_end) > 1) {
> -			kfree(fsopt->server_path);
> -			fsopt->server_path = kstrdup(dev_name_end, GFP_KERNEL);
> -			if (!fsopt->server_path)
> -				return -ENOMEM;
> -		}
> +		kfree(fsopt->server_path);
> +
> +		/*
> +		 * The server_path will include the whole chars from userland
> +		 * including the leading '/'.
> +		 */
> +		fsopt->server_path = kstrdup(dev_name_end, GFP_KERNEL);
> +		if (!fsopt->server_path)
> +			return -ENOMEM;
>  	} else {
>  		dev_name_end = dev_name + strlen(dev_name);
>  	}
> @@ -459,6 +461,64 @@ static int strcmp_null(const char *s1, const char *s2)
>  	return strcmp(s1, s2);
>  }
>  
> +/**
> + * path_remove_extra_slash - Remove the extra slashes in the server path
> + * @server_path: the server path and could be NULL
> + *
> + * Return NULL if the path is NULL or only consists of "/", or a string
> + * without any extra slashes including the leading slash(es) and the
> + * slash(es) at the end of the server path, such as:
> + * "//dir1////dir2///" --> "dir1/dir2"
> + */
> +static char *path_remove_extra_slash(const char *server_path)
> +{
> +	const char *path = server_path;
> +	bool last_is_slash;
> +	int i, j, len;
> +	char *p;
> +
> +	/* if the server path is omitted */
> +	if (!path)
> +		return NULL;
> +
> +	/* remove all the leading slashes */
> +	while (*path == '/')
> +		path++;
> +
> +	/* if the server path only consists of slashes */
> +	if (*path == '\0')
> +		return NULL;
> +
> +	len = strlen(path);
> +
> +	p = kmalloc(len, GFP_KERNEL);
> +	if (!p)
> +		return ERR_PTR(-ENOMEM);
> +
> +	last_is_slash = false;
> +	for (j = 0, i = 0; i < len; i++) {
> +		if (path[i] == '/') {
> +			if (last_is_slash)
> +				continue;
> +			last_is_slash = true;
> +		} else {
> +			last_is_slash = false;
> +		}
> +		p[j++] = path[i];
> +	}
> +

Rather than walking through character by character, it might be better
to use strchr and the other string handling functions in
include/linux/string.h. Some arches have optimized string handling
routines that may perform better here.

> +	/*
> +	 * remove the last slash if there has just to make sure that
> +	 * we will get "dir1/dir2"
> +	 */
> +	if (p[j - 1] == '/')
> +		j--;
> +
> +	p[j] = '\0';
> +
> +	return p;
> +}
> +
>  static int compare_mount_options(struct ceph_mount_options *new_fsopt,
>  				 struct ceph_options *new_opt,
>  				 struct ceph_fs_client *fsc)
> @@ -466,6 +526,7 @@ static int compare_mount_options(struct ceph_mount_options *new_fsopt,
>  	struct ceph_mount_options *fsopt1 = new_fsopt;
>  	struct ceph_mount_options *fsopt2 = fsc->mount_options;
>  	int ofs = offsetof(struct ceph_mount_options, snapdir_name);
> +	char *p1, *p2;
>  	int ret;
>  
>  	ret = memcmp(fsopt1, fsopt2, ofs);
> @@ -478,9 +539,21 @@ static int compare_mount_options(struct ceph_mount_options *new_fsopt,
>  	ret = strcmp_null(fsopt1->mds_namespace, fsopt2->mds_namespace);
>  	if (ret)
>  		return ret;
> -	ret = strcmp_null(fsopt1->server_path, fsopt2->server_path);
> +
> +	p1 = path_remove_extra_slash(fsopt1->server_path);
> +	if (IS_ERR(p1))
> +		return PTR_ERR(p1);
> +	p2 = path_remove_extra_slash(fsopt2->server_path);
> +	if (IS_ERR(p2)) {
> +		kfree(p1);
> +		return PTR_ERR(p2);
> +	}
> +	ret = strcmp_null(p1, p2);
> +	kfree(p1);
> +	kfree(p2);
>  	if (ret)
>  		return ret;
> +
>  	ret = strcmp_null(fsopt1->fscache_uniq, fsopt2->fscache_uniq);
>  	if (ret)
>  		return ret;
> @@ -883,7 +956,7 @@ static struct dentry *ceph_real_mount(struct ceph_fs_client *fsc,
>  	mutex_lock(&fsc->client->mount_mutex);
>  
>  	if (!fsc->sb->s_root) {
> -		const char *path;
> +		const char *path, *p;
>  		err = __ceph_open_session(fsc->client, started);
>  		if (err < 0)
>  			goto out;
> @@ -895,17 +968,22 @@ static struct dentry *ceph_real_mount(struct ceph_fs_client *fsc,
>  				goto out;
>  		}
>  
> -		if (!fsc->mount_options->server_path) {
> -			path = "";
> -			dout("mount opening path \\t\n");
> -		} else {
> -			path = fsc->mount_options->server_path + 1;
> -			dout("mount opening path %s\n", path);
> +		p = path_remove_extra_slash(fsc->mount_options->server_path);
> +		if (IS_ERR(p)) {
> +			err = PTR_ERR(p);
> +			goto out;
>  		}
> +		/* if the server path is omitted or just consists of '/' */
> +		if (!p)
> +			path = "";
> +		else
> +			path = p;
> +		dout("mount opening path '%s'\n", path);
>  
>  		ceph_fs_debugfs_init(fsc);
>  
>  		root = open_root_dentry(fsc, path, started);
> +		kfree(p);
>  		if (IS_ERR(root)) {
>  			err = PTR_ERR(root);
>  			goto out;

-- 
Jeff Layton <jlayton@kernel.org>

