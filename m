Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 20CAB1FF504
	for <lists+ceph-devel@lfdr.de>; Thu, 18 Jun 2020 16:43:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730922AbgFROnA (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 18 Jun 2020 10:43:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:34396 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730920AbgFROnA (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Thu, 18 Jun 2020 10:43:00 -0400
Received: from tleilax.poochiereds.net (68-20-15-154.lightspeed.rlghnc.sbcglobal.net [68.20.15.154])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DA2BC20773;
        Thu, 18 Jun 2020 14:42:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592491379;
        bh=yFWOa+LFj0zZwZc8GsY6AOJ2v8E0c4q6j16v7JD/zaw=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=eNAiau/6LolbEHpp2CK41Gc3zevAfGF2W7tieHXlbBycRyxVjp4IY9lh6cGerGHMF
         t7N1BQoLDJk31d/KCAPo7tkCZrfacpR5fjtI9zb7lft+FTmXbiCgD2LeQgM/piu9Zm
         EH9Y3YRwEctIpxcwU0xRTMJkIdKRdRlV9/4kOo54=
Message-ID: <0b035117f68e00be64569021e10e202371589205.camel@kernel.org>
Subject: Re: [PATCH v2 2/5] ceph: periodically send perf metrics to ceph
From:   Jeff Layton <jlayton@kernel.org>
To:     xiubli@redhat.com, idryomov@gmail.com
Cc:     zyan@redhat.com, pdonnell@redhat.com, ceph-devel@vger.kernel.org
Date:   Thu, 18 Jun 2020 10:42:57 -0400
In-Reply-To: <1592481599-7851-3-git-send-email-xiubli@redhat.com>
References: <1592481599-7851-1-git-send-email-xiubli@redhat.com>
         <1592481599-7851-3-git-send-email-xiubli@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.3 (3.36.3-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Thu, 2020-06-18 at 07:59 -0400, xiubli@redhat.com wrote:
> From: Xiubo Li <xiubli@redhat.com>
> 
> This will send the caps/read/write/metadata metrics to any available
> MDS only once per second as default, which will be the same as the
> userland client, or every metric_send_interval seconds, which is a
> module parameter.
> 
> URL: https://tracker.ceph.com/issues/43215
> Signed-off-by: Xiubo Li <xiubli@redhat.com>
> ---
>  fs/ceph/mds_client.c         |   3 +
>  fs/ceph/metric.c             | 134 +++++++++++++++++++++++++++++++++++++++++++
>  fs/ceph/metric.h             |  78 +++++++++++++++++++++++++
>  fs/ceph/super.c              |  49 ++++++++++++++++
>  fs/ceph/super.h              |   2 +
>  include/linux/ceph/ceph_fs.h |   1 +
>  6 files changed, 267 insertions(+)
> 
> 

I think 3/5 needs to moved ahead of this one or folded into it, as we'll
have a temporary regression otherwise.

> diff --git a/fs/ceph/super.c b/fs/ceph/super.c
> index c9784eb1..5f409dd 100644
> --- a/fs/ceph/super.c
> +++ b/fs/ceph/super.c
> @@ -27,6 +27,9 @@
>  #include <linux/ceph/auth.h>
>  #include <linux/ceph/debugfs.h>
>  
> +static DEFINE_MUTEX(ceph_fsc_lock);
> +static LIST_HEAD(ceph_fsc_list);
> +
>  /*
>   * Ceph superblock operations
>   *
> @@ -691,6 +694,10 @@ static struct ceph_fs_client *create_fs_client(struct ceph_mount_options *fsopt,
>  	if (!fsc->wb_pagevec_pool)
>  		goto fail_cap_wq;
>  
> +	mutex_lock(&ceph_fsc_lock);
> +	list_add_tail(&fsc->list, &ceph_fsc_list);
> +	mutex_unlock(&ceph_fsc_lock);
> +
>  	return fsc;
>  
>  fail_cap_wq:
> @@ -717,6 +724,10 @@ static void destroy_fs_client(struct ceph_fs_client *fsc)
>  {
>  	dout("destroy_fs_client %p\n", fsc);
>  
> +	mutex_lock(&ceph_fsc_lock);
> +	list_del(&fsc->list);
> +	mutex_unlock(&ceph_fsc_lock);
> +
>  	ceph_mdsc_destroy(fsc);
>  	destroy_workqueue(fsc->inode_wq);
>  	destroy_workqueue(fsc->cap_wq);
> @@ -1282,6 +1293,44 @@ static void __exit exit_ceph(void)
>  	destroy_caches();
>  }
>  
> +static int param_set_metric_interval(const char *val, const struct kernel_param *kp)
> +{
> +	struct ceph_fs_client *fsc;
> +	unsigned int interval;
> +	int ret;
> +
> +	ret = kstrtouint(val, 0, &interval);
> +	if (ret < 0) {
> +		pr_err("Failed to parse metric interval '%s'\n", val);
> +		return ret;
> +	}
> +
> +	if (interval > 5) {
> +		pr_err("Invalid metric interval %u\n", interval);
> +		return -EINVAL;
> +	}
> +

Why do we want to reject an interval larger than 5s? Is that problematic
for some reason? In any case, it would be good to replace this with a
#defined constant that describes what that value represents.

> +	metric_send_interval = interval;
> +
> +	// wake up all the mds clients
> +	mutex_lock(&ceph_fsc_lock);
> +	list_for_each_entry(fsc, &ceph_fsc_list, list) {
> +		metric_schedule_delayed(&fsc->mdsc->metric);
> +	}
> +	mutex_unlock(&ceph_fsc_lock);
> +
> +	return 0;
> +}
> +
> +static const struct kernel_param_ops param_ops_metric_interval = {
> +	.set = param_set_metric_interval,
> +	.get = param_get_uint,
> +};
> +
> +unsigned int metric_send_interval = 1;
> +module_param_cb(metric_send_interval, &param_ops_metric_interval, &metric_send_interval, 0644);
> +MODULE_PARM_DESC(metric_send_interval, "Interval (in seconds) of sending perf metric to ceph cluster, valid values are 0~5, 0 means disabled (default: 1)");
> +
>  module_init(init_ceph);
>  module_exit(exit_ceph);
>  
> diff --git a/fs/ceph/super.h b/fs/ceph/super.h
> index 5a6cdd3..05edc9a 100644
> --- a/fs/ceph/super.h
> +++ b/fs/ceph/super.h
> @@ -101,6 +101,8 @@ struct ceph_mount_options {
>  struct ceph_fs_client {
>  	struct super_block *sb;
>  
> +	struct list_head list;
> +
>  	struct ceph_mount_options *mount_options;
>  	struct ceph_client *client;
>  
> diff --git a/include/linux/ceph/ceph_fs.h b/include/linux/ceph/ceph_fs.h
> index ebf5ba6..455e9b9 100644
> --- a/include/linux/ceph/ceph_fs.h
> +++ b/include/linux/ceph/ceph_fs.h
> @@ -130,6 +130,7 @@ struct ceph_dir_layout {
>  #define CEPH_MSG_CLIENT_REQUEST         24
>  #define CEPH_MSG_CLIENT_REQUEST_FORWARD 25
>  #define CEPH_MSG_CLIENT_REPLY           26
> +#define CEPH_MSG_CLIENT_METRICS         29
>  #define CEPH_MSG_CLIENT_CAPS            0x310
>  #define CEPH_MSG_CLIENT_LEASE           0x311
>  #define CEPH_MSG_CLIENT_SNAP            0x312

Thanks,
-- 
Jeff Layton <jlayton@kernel.org>

