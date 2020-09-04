Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF07325D896
	for <lists+ceph-devel@lfdr.de>; Fri,  4 Sep 2020 14:27:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730189AbgIDM1v (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 4 Sep 2020 08:27:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:40100 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730006AbgIDM1t (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Fri, 4 Sep 2020 08:27:49 -0400
Received: from tleilax.poochiereds.net (68-20-15-154.lightspeed.rlghnc.sbcglobal.net [68.20.15.154])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9F6BD2084D;
        Fri,  4 Sep 2020 12:27:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599222468;
        bh=30H3jt5X8txF6aIgqA5PgxUby+nacex3jtBnkm2cAe4=;
        h=Subject:From:To:Date:In-Reply-To:References:From;
        b=M6qILb93xSdfW+XoMDMNIFO9+0C7kUog7+vYibm8judsONSu7pLoI4tSnFKVRZRbu
         c9xFB2jiO6EHDmiO3MckenYrr1yIvqdakTpfzxRrF33XceJNkbut0Oca2HuJ8OcQor
         G2qO+TKqddGjArIwsJONaMCQxujwkas6T713FfvA=
Message-ID: <57ed74011b01f28a25b682d92a72a61c919d78e3.camel@kernel.org>
Subject: Re: [PATCH] rbd: require global CAP_SYS_ADMIN for mapping and
 unmapping
From:   Jeff Layton <jlayton@kernel.org>
To:     Ilya Dryomov <idryomov@gmail.com>, ceph-devel@vger.kernel.org
Date:   Fri, 04 Sep 2020 08:27:47 -0400
In-Reply-To: <20200904091005.7537-1-idryomov@gmail.com>
References: <20200904091005.7537-1-idryomov@gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Fri, 2020-09-04 at 11:10 +0200, Ilya Dryomov wrote:
> It turns out that currently we rely only on sysfs attribute
> permissions:
> 
>   $ ll /sys/bus/rbd/{add*,remove*}
>   --w------- 1 root root 4096 Sep  3 20:37 /sys/bus/rbd/add
>   --w------- 1 root root 4096 Sep  3 20:37 /sys/bus/rbd/add_single_major
>   --w------- 1 root root 4096 Sep  3 20:37 /sys/bus/rbd/remove
>   --w------- 1 root root 4096 Sep  3 20:38 /sys/bus/rbd/remove_single_major
> 
> This means that images can be mapped and unmapped (i.e. block devices
> can be created and deleted) by a UID 0 process even after it drops all
> privileges or by any process with CAP_DAC_OVERRIDE in its user namespace
> as long as UID 0 is mapped into that user namespace.
> 
> Be consistent with other virtual block devices (loop, nbd, dm, md, etc)
> and require CAP_SYS_ADMIN in the initial user namespace for mapping and
> unmapping, and also for dumping the configuration string and refreshing
> the image header.
> 
> Cc: stable@vger.kernel.org
> Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
> ---
>  drivers/block/rbd.c | 12 ++++++++++++
>  1 file changed, 12 insertions(+)
> 
> diff --git a/drivers/block/rbd.c b/drivers/block/rbd.c
> index fa252e8ed276..180587ce606c 100644
> --- a/drivers/block/rbd.c
> +++ b/drivers/block/rbd.c
> @@ -5120,6 +5120,9 @@ static ssize_t rbd_config_info_show(struct device *dev,
>  {
>  	struct rbd_device *rbd_dev = dev_to_rbd_dev(dev);
>  
> +	if (!capable(CAP_SYS_ADMIN))
> +		return -EPERM;
> +
>  	return sprintf(buf, "%s\n", rbd_dev->config_info);
>  }
>  
> @@ -5231,6 +5234,9 @@ static ssize_t rbd_image_refresh(struct device *dev,
>  	struct rbd_device *rbd_dev = dev_to_rbd_dev(dev);
>  	int ret;
>  
> +	if (!capable(CAP_SYS_ADMIN))
> +		return -EPERM;
> +
>  	ret = rbd_dev_refresh(rbd_dev);
>  	if (ret)
>  		return ret;
> @@ -7059,6 +7065,9 @@ static ssize_t do_rbd_add(struct bus_type *bus,
>  	struct rbd_client *rbdc;
>  	int rc;
>  
> +	if (!capable(CAP_SYS_ADMIN))
> +		return -EPERM;
> +
>  	if (!try_module_get(THIS_MODULE))
>  		return -ENODEV;
>  
> @@ -7209,6 +7218,9 @@ static ssize_t do_rbd_remove(struct bus_type *bus,
>  	bool force = false;
>  	int ret;
>  
> +	if (!capable(CAP_SYS_ADMIN))
> +		return -EPERM;
> +
>  	dev_id = -1;
>  	opt_buf[0] = '\0';
>  	sscanf(buf, "%d %5s", &dev_id, opt_buf);

Good catch!
Reviewed-by: Jeff Layton <jlayton@kernel.org>

