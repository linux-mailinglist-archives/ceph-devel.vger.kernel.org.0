Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A42AD2AD61F
	for <lists+ceph-devel@lfdr.de>; Tue, 10 Nov 2020 13:24:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726827AbgKJMYp (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 10 Nov 2020 07:24:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:35586 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726690AbgKJMYp (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Tue, 10 Nov 2020 07:24:45 -0500
Received: from tleilax.poochiereds.net (68-20-15-154.lightspeed.rlghnc.sbcglobal.net [68.20.15.154])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DC842206B6;
        Tue, 10 Nov 2020 12:24:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605011084;
        bh=RGK13axtqtSXlDZwZ/8/6jbRcdAAbJcbwM0Ty3YXBVI=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=XPKgGkVNwz4S/Yx6/SjClW4ZCGByZ+3mgvv4oinSoHCgl04ekFRSxGIqldm1dbm1a
         DvL0lqt0umx/8An112Ms9naXTO0YJdHh62Mc0g8i2zBRuKJ2aIO+TogdveaSbzJUUU
         /p/gUT4ZzfA9CVbUGdOcaofPHJj5l2SHPkz7pKbw=
Message-ID: <4e7ca1cec2ad6bc78423fc77ac9295c8740a8601.camel@kernel.org>
Subject: Re: [PATCH v2 2/2] ceph: add CEPH_IOC_GET_CLUSTER_AND_CLIENT_IDS
 ioctl cmd support
From:   Jeff Layton <jlayton@kernel.org>
To:     xiubli@redhat.com, idryomov@gmail.com
Cc:     zyan@redhat.com, pdonnell@redhat.com, ceph-devel@vger.kernel.org
Date:   Tue, 10 Nov 2020 07:24:42 -0500
In-Reply-To: <20201110105755.340315-3-xiubli@redhat.com>
References: <20201110105755.340315-1-xiubli@redhat.com>
         <20201110105755.340315-3-xiubli@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.1 (3.38.1-1.fc33) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Tue, 2020-11-10 at 18:57 +0800, xiubli@redhat.com wrote:
> From: Xiubo Li <xiubli@redhat.com>
> 
> This ioctl will return the cluster and client ids back to userspace.
> With this we can easily know which mountpoint the file belongs to and
> also they can help locate the debugfs path quickly.
> 
> URL: https://tracker.ceph.com/issues/48124
> Signed-off-by: Xiubo Li <xiubli@redhat.com>
> ---
>  fs/ceph/ioctl.c | 23 +++++++++++++++++++++++
>  fs/ceph/ioctl.h | 15 +++++++++++++++
>  2 files changed, 38 insertions(+)
> 

I know I opened this bug and suggested an ioctl for this, but I think
that this may be better presented as new vxattrs. Driving ioctls from
scripts is difficult (in particular). An xattr is easier for them to
deal with. Maybe:

    ceph.clusterid
    ceph.clientid

...or you could even make one that gives you the same format as the
dirnames in /sys/kernel/debug/ceph.

> diff --git a/fs/ceph/ioctl.c b/fs/ceph/ioctl.c
> index 6e061bf62ad4..a4b69c1026ce 100644
> --- a/fs/ceph/ioctl.c
> +++ b/fs/ceph/ioctl.c
> @@ -268,6 +268,27 @@ static long ceph_ioctl_syncio(struct file *file)
>  	return 0;
>  }
>  
> +/*
> + * Return the cluster and client ids
> + */
> +static long ceph_ioctl_get_fs_ids(struct file *file, void __user *arg)
> +{
> +	struct inode *inode = file_inode(file);
> +	struct ceph_fs_client *fsc = ceph_sb_to_client(inode->i_sb);
> +	struct cluster_client_ids ids;
> +
> +	snprintf(ids.cluster_id, sizeof(ids.cluster_id), "%pU",
> +		 &fsc->client->fsid);
> +	snprintf(ids.client_id, sizeof(ids.client_id), "client%lld",
> +		 ceph_client_gid(fsc->client));
> +
> +	/* send result back to user */
> +	if (copy_to_user(arg, &ids, sizeof(ids)))
> +		return -EFAULT;
> +
> +	return 0;
> +}
> +
>  long ceph_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
>  {
>  	dout("ioctl file %p cmd %u arg %lu\n", file, cmd, arg);
> @@ -289,6 +310,8 @@ long ceph_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
>  
> 
> 
> 
>  	case CEPH_IOC_SYNCIO:
>  		return ceph_ioctl_syncio(file);
> +	case CEPH_IOC_GET_CLUSTER_AND_CLIENT_IDS:
> +		return ceph_ioctl_get_fs_ids(file, (void __user *)arg);
>  	}
>  
> 
> 
> 
>  	return -ENOTTY;
> diff --git a/fs/ceph/ioctl.h b/fs/ceph/ioctl.h
> index 51f7f1d39a94..9879d58854fb 100644
> --- a/fs/ceph/ioctl.h
> +++ b/fs/ceph/ioctl.h
> @@ -98,4 +98,19 @@ struct ceph_ioctl_dataloc {
>   */
>  #define CEPH_IOC_SYNCIO _IO(CEPH_IOCTL_MAGIC, 5)
>  
> 
> 
> 
> +/*
> + * CEPH_IOC_GET_CLUSTER_AND_CLIENT_IDS - get the cluster and client ids
> + *
> + * This ioctl will return the cluster and client ids back to user space.
> + * With this we can easily know which mountpoint the file belongs to and
> + * also they can help locate the debugfs path quickly.
> + */
> +
> +struct cluster_client_ids {
> +	char cluster_id[40];
> +	char client_id[24];
> +};
> +#define CEPH_IOC_GET_CLUSTER_AND_CLIENT_IDS _IOR(CEPH_IOCTL_MAGIC, 6, \
> +					struct cluster_client_ids)
> +
>  #endif

-- 
Jeff Layton <jlayton@kernel.org>

