Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B71CE1DCBBB
	for <lists+ceph-devel@lfdr.de>; Thu, 21 May 2020 13:10:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729076AbgEULJ5 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 21 May 2020 07:09:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:41496 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729017AbgEULJy (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Thu, 21 May 2020 07:09:54 -0400
Received: from tleilax.poochiereds.net (68-20-15-154.lightspeed.rlghnc.sbcglobal.net [68.20.15.154])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 75F7120721;
        Thu, 21 May 2020 11:09:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590059393;
        bh=CYq5LvpdIkzN5Q2ml6NSFNeLsYGmkIUAGsU26W6nIUE=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=sSAB0ijeU/zJF/ltw7k79k69ZikOCsnrNtoPtdEHHISk+BhL7kaXFLaQnxh43Jn/I
         tazH3muCMsoFMJFPkE9Q5fCGKRGV+jrFzHJrghjznDxlFd2aEIMENW8sFFQu38VCUh
         p4hJhm+i8jSZMA8ZrNQ4SXXOjUFTkDI/whSvkEzU=
Message-ID: <cad949df361b68a1c929f9053bce34d1892c8291.camel@kernel.org>
Subject: Re: [PATCH] ceph: show max caps in debugfs caps file
From:   Jeff Layton <jlayton@kernel.org>
To:     Yanhu Cao <gmayyyha@gmail.com>
Cc:     idryomov@gmail.com, ceph-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Thu, 21 May 2020 07:09:52 -0400
In-Reply-To: <20200521093845.15101-1-gmayyyha@gmail.com>
References: <20200521093845.15101-1-gmayyyha@gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.2 (3.36.2-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Thu, 2020-05-21 at 17:38 +0800, Yanhu Cao wrote:
>         before
>         ------
>         total           1026
>         avail           1024
>         used            2
>         reserved        0
>         min             1024
> 
>         after
>         ------
>         total           1026
>         avail           1024
>         used            2
>         max             2048
>         reserved        0
>         min             1024
> 
> Signed-off-by: Yanhu Cao <gmayyyha@gmail.com>
> ---
>  fs/ceph/caps.c    | 6 ++++--
>  fs/ceph/debugfs.c | 7 ++++---
>  fs/ceph/super.h   | 2 +-
>  3 files changed, 9 insertions(+), 6 deletions(-)
> 
> diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
> index 5f3aa4d607de..e2c759a2ef35 100644
> --- a/fs/ceph/caps.c
> +++ b/fs/ceph/caps.c
> @@ -404,8 +404,8 @@ void ceph_put_cap(struct ceph_mds_client *mdsc, struct ceph_cap *cap)
>  }
>  
>  void ceph_reservation_status(struct ceph_fs_client *fsc,
> -			     int *total, int *avail, int *used, int *reserved,
> -			     int *min)
> +			     int *total, int *avail, int *used, int *max,
> +			     int *reserved, int *min)
>  {
>  	struct ceph_mds_client *mdsc = fsc->mdsc;
>  
> @@ -417,6 +417,8 @@ void ceph_reservation_status(struct ceph_fs_client *fsc,
>  		*avail = mdsc->caps_avail_count;
>  	if (used)
>  		*used = mdsc->caps_use_count;
> +	if (max)
> +		*max = mdsc->caps_use_max;

Can you lay out what value this will provide? I'm not convinced that
this information is really that helpful:

mdsc->caps_use_max is just set to the value of the "caps_max" mount
option, and that information is displayed in /proc/mounts if it's not
set to the default.

What might be more interesting is to track the most recent "max_caps"
value sent by the MDS (see the CEPH_SESSION_RECALL_STATE message
handling). Tracking that would give us a more dynamic view of the
current maximum requested by the MDS, which is often going to be less
than what "caps_max" was set to at mount time.

>  	if (reserved)
>  		*reserved = mdsc->caps_reserve_count;
>  	if (min)
> diff --git a/fs/ceph/debugfs.c b/fs/ceph/debugfs.c
> index 481ac97b4d25..942004376588 100644
> --- a/fs/ceph/debugfs.c
> +++ b/fs/ceph/debugfs.c
> @@ -138,16 +138,17 @@ static int caps_show(struct seq_file *s, void *p)
>  {
>  	struct ceph_fs_client *fsc = s->private;
>  	struct ceph_mds_client *mdsc = fsc->mdsc;
> -	int total, avail, used, reserved, min, i;
> +	int total, avail, used, max, reserved, min, i;
>  	struct cap_wait	*cw;
>  
> -	ceph_reservation_status(fsc, &total, &avail, &used, &reserved, &min);
> +	ceph_reservation_status(fsc, &total, &avail, &used, &max,
> +				&reserved, &min);
>  	seq_printf(s, "total\t\t%d\n"
>  		   "avail\t\t%d\n"
>  		   "used\t\t%d\n"
>  		   "reserved\t%d\n"
>  		   "min\t\t%d\n\n",
> -		   total, avail, used, reserved, min);
> +		   total, avail, used, max, reserved, min);
>  	seq_printf(s, "ino                issued           implemented\n");
>  	seq_printf(s, "-----------------------------------------------\n");
>  
> diff --git a/fs/ceph/super.h b/fs/ceph/super.h
> index 60aac3aee055..79aa42d9336c 100644
> --- a/fs/ceph/super.h
> +++ b/fs/ceph/super.h
> @@ -700,7 +700,7 @@ extern void ceph_unreserve_caps(struct ceph_mds_client *mdsc,
>  			       struct ceph_cap_reservation *ctx);
>  extern void ceph_reservation_status(struct ceph_fs_client *client,
>  				    int *total, int *avail, int *used,
> -				    int *reserved, int *min);
> +				    int *max, int *reserved, int *min);
>  
>  
>  

-- 
Jeff Layton <jlayton@kernel.org>

