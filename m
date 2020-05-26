Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 439A11E294F
	for <lists+ceph-devel@lfdr.de>; Tue, 26 May 2020 19:45:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388975AbgEZRps (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 26 May 2020 13:45:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:54156 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388794AbgEZRps (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Tue, 26 May 2020 13:45:48 -0400
Received: from tleilax.poochiereds.net (68-20-15-154.lightspeed.rlghnc.sbcglobal.net [68.20.15.154])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4412220704;
        Tue, 26 May 2020 17:45:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590515147;
        bh=Ps4DhrKP7xuN3oWvf+n24VJztP7gLUxaV3Hx/CAeoDo=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=UmXibeH5wL2z8iL7Ot453yspY2o+JCqMpr/AH4BGKXjjKEgXjNNCUjCwRmV/Gaddq
         PTRJjOz/y+E3oFjXIu7XpxYOISMUZbF1OQ6sXO3S3reZx//Og/xaCPborKojoUckfm
         hQayLH9DvhWQKma9pAXNZm4FYRGTbPF+8JViDtmc=
Message-ID: <3860895382201ae7a2eb687070724872e77e347a.camel@kernel.org>
Subject: Re: [v2] ceph: show max caps in debugfs caps file
From:   Jeff Layton <jlayton@kernel.org>
To:     Yanhu Cao <gmayyyha@gmail.com>
Cc:     idryomov@gmail.com, ceph-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org, Yanhu Cao <jrcaoyanhu@jd.com>,
        kbuild test robot <lkp@intel.com>
Date:   Tue, 26 May 2020 13:45:46 -0400
In-Reply-To: <20200525025049.4292-1-gmayyyha@gmail.com>
References: <20200525025049.4292-1-gmayyyha@gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.2 (3.36.2-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Mon, 2020-05-25 at 10:50 +0800, Yanhu Cao wrote:
> before
> ------
> total		1286
> avail		1005
> used		281
> reserved	0
> min		1024
> 
> after
> -----
> total		1286
> avail		1005
> used		281
> limit		261
> reserved	0
> min		1024
> 

The description should explain what this new field actually _means_.

> Signed-off-by: Yanhu Cao <gmayyyha@gmail.com>
> Signed-off-by: Yanhu Cao <jrcaoyanhu@jd.com>
> Reported-by: kbuild test robot <lkp@intel.com>
> ---
>  fs/ceph/caps.c       | 6 ++++--
>  fs/ceph/debugfs.c    | 8 +++++---
>  fs/ceph/mds_client.c | 1 +
>  fs/ceph/mds_client.h | 4 +++-
>  fs/ceph/super.h      | 2 +-
>  5 files changed, 14 insertions(+), 7 deletions(-)
> 
> diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
> index 5f3aa4d607de..17191d6cd3b5 100644
> --- a/fs/ceph/caps.c
> +++ b/fs/ceph/caps.c
> @@ -404,8 +404,8 @@ void ceph_put_cap(struct ceph_mds_client *mdsc, struct ceph_cap *cap)
>  }
>  
>  void ceph_reservation_status(struct ceph_fs_client *fsc,
> -			     int *total, int *avail, int *used, int *reserved,
> -			     int *min)
> +			     int *total, int *avail, int *used, int *limit,
> +			     int *reserved, int *min)
>  {
>  	struct ceph_mds_client *mdsc = fsc->mdsc;
>  
> @@ -417,6 +417,8 @@ void ceph_reservation_status(struct ceph_fs_client *fsc,
>  		*avail = mdsc->caps_avail_count;
>  	if (used)
>  		*used = mdsc->caps_use_count;
> +	if (limit)
> +		*limit = mdsc->caps_limit;
>  	if (reserved)
>  		*reserved = mdsc->caps_reserve_count;
>  	if (min)
> diff --git a/fs/ceph/debugfs.c b/fs/ceph/debugfs.c
> index 481ac97b4d25..617020261902 100644
> --- a/fs/ceph/debugfs.c
> +++ b/fs/ceph/debugfs.c
> @@ -138,16 +138,18 @@ static int caps_show(struct seq_file *s, void *p)
>  {
>  	struct ceph_fs_client *fsc = s->private;
>  	struct ceph_mds_client *mdsc = fsc->mdsc;
> -	int total, avail, used, reserved, min, i;
> +	int total, avail, used, limit, reserved, min, i;
>  	struct cap_wait	*cw;
>  
> -	ceph_reservation_status(fsc, &total, &avail, &used, &reserved, &min);
> +	ceph_reservation_status(fsc, &total, &avail, &used,
> +				&limit, &reserved, &min);
>  	seq_printf(s, "total\t\t%d\n"
>  		   "avail\t\t%d\n"
>  		   "used\t\t%d\n"
> +		   "limit\t\t%d\n"
>  		   "reserved\t%d\n"
>  		   "min\t\t%d\n\n",
> -		   total, avail, used, reserved, min);
> +		   total, avail, used, limit, reserved, min);
>  	seq_printf(s, "ino                issued           implemented\n");
>  	seq_printf(s, "-----------------------------------------------\n");
>  
> diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
> index 7c63abf5bea9..d26bc065f5f5 100644
> --- a/fs/ceph/mds_client.c
> +++ b/fs/ceph/mds_client.c
> @@ -1920,6 +1920,7 @@ int ceph_trim_caps(struct ceph_mds_client *mdsc,
>  		   int max_caps)
>  {
>  	int trim_caps = session->s_nr_caps - max_caps;
> +	mdsc->caps_limit = max_caps;
>  

I was thinking that you'd track this in handle_session. Note that
ceph_trim_caps is called from ceph_reserve_caps as well. There's also
some delay between calling ceph_trim_caps and actually releasing them,
so it's not clear to me how one should interpret mdsc->caps_limit. 

What does that value actually _mean_? I think it would be a lot more
straightforward to have this be the limit sent by the MDS (if any). If
there is value in tracking it this way then we need to carefully
document what it means and how it should be interpreted.

>  	dout("trim_caps mds%d start: %d / %d, trim %d\n",
>  	     session->s_mds, session->s_nr_caps, max_caps, trim_caps);
> diff --git a/fs/ceph/mds_client.h b/fs/ceph/mds_client.h
> index 903d9edfd4bf..840d47976dbb 100644
> --- a/fs/ceph/mds_client.h
> +++ b/fs/ceph/mds_client.h
> @@ -445,7 +445,9 @@ struct ceph_mds_client {
>  	struct		list_head cap_wait_list;
>  	int		caps_total_count;    /* total caps allocated */
>  	int		caps_use_count;      /* in use */
> -	int		caps_use_max;	     /* max used caps */
> +	int		caps_use_max;	     /* max used caps,
> +						limited by client */
> +	int		caps_limit;          /* limited by mds */
>  	int		caps_reserve_count;  /* unused, reserved */
>  	int		caps_avail_count;    /* unused, unreserved */
>  	int		caps_min_count;      /* keep at least this many
> diff --git a/fs/ceph/super.h b/fs/ceph/super.h
> index 60aac3aee055..052d7725761d 100644
> --- a/fs/ceph/super.h
> +++ b/fs/ceph/super.h
> @@ -700,7 +700,7 @@ extern void ceph_unreserve_caps(struct ceph_mds_client *mdsc,
>  			       struct ceph_cap_reservation *ctx);
>  extern void ceph_reservation_status(struct ceph_fs_client *client,
>  				    int *total, int *avail, int *used,
> -				    int *reserved, int *min);
> +				    int *limit, int *reserved, int *min);
>  
>  
>  

-- 
Jeff Layton <jlayton@kernel.org>

