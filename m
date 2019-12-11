Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D821D11ABD5
	for <lists+ceph-devel@lfdr.de>; Wed, 11 Dec 2019 14:17:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729225AbfLKNRF (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 11 Dec 2019 08:17:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:33844 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729131AbfLKNRF (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Wed, 11 Dec 2019 08:17:05 -0500
Received: from tleilax.poochiereds.net (68-20-15-154.lightspeed.rlghnc.sbcglobal.net [68.20.15.154])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9FD7E20836;
        Wed, 11 Dec 2019 13:17:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576070225;
        bh=GtCOsCrXsq78ONIbQ8Mlz7dysxcZIUTeAabC1cuHm7g=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=YVA3nhXkWJxEUs6WgTXSM5VfFyxl/DlDacQRO+ovwvZ8Q/VhF9NFkD1TvWY3llxEn
         cEhAybctxMjpHRg7lka9bzQnDa5onZllOSeV6ZAMtKZtb973VjTxXEBmsnRiszTzdE
         jefRPX9uesMkYzb7BcrSDvDJt6JVqQuC3mxzsXYc=
Message-ID: <f1ef6025423394c7976df367673244b06dd83dc8.camel@kernel.org>
Subject: Re: [PATCH v3] ceph: check availability of mds cluster on mount
 after wait timeout
From:   Jeff Layton <jlayton@kernel.org>
To:     xiubli@redhat.com
Cc:     sage@redhat.com, idryomov@gmail.com, zyan@redhat.com,
        pdonnell@redhat.com, ceph-devel@vger.kernel.org
Date:   Wed, 11 Dec 2019 08:17:03 -0500
In-Reply-To: <20191211012940.18128-1-xiubli@redhat.com>
References: <20191211012940.18128-1-xiubli@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.2 (3.34.2-1.fc31) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Tue, 2019-12-10 at 20:29 -0500, xiubli@redhat.com wrote:
> From: Xiubo Li <xiubli@redhat.com>
> 
> If all the MDS daemons are down for some reasons and for the first
> time to do the mount, it will fail with IO error after the mount
> request timed out.
> 
> Or if the cluster becomes laggy suddenly, and just before the kclient
> getting the new mdsmap and the mount request is fired off, it also
> will fail with IO error.
> 
> This will add some useful hint message by checking the cluster state
> before the fail the mount operation.
> 
> Signed-off-by: Xiubo Li <xiubli@redhat.com>
> ---
> 
> V3:
> - Rebase to the new mount API version.
> 
>  fs/ceph/mds_client.c | 3 +--
>  fs/ceph/super.c      | 5 +++++
>  2 files changed, 6 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
> index 7d3ec051f179..bf507120659e 100644
> --- a/fs/ceph/mds_client.c
> +++ b/fs/ceph/mds_client.c
> @@ -2576,8 +2576,7 @@ static void __do_request(struct ceph_mds_client *mdsc,
>  		if (!(mdsc->fsc->mount_options->flags &
>  		      CEPH_MOUNT_OPT_MOUNTWAIT) &&
>  		    !ceph_mdsmap_is_cluster_available(mdsc->mdsmap)) {
> -			err = -ENOENT;
> -			pr_info("probably no mds server is up\n");
> +			err = -EHOSTUNREACH;
>  			goto finish;
>  		}
>  	}
> diff --git a/fs/ceph/super.c b/fs/ceph/super.c
> index 9c9a7c68eea3..6f33a265ccf1 100644
> --- a/fs/ceph/super.c
> +++ b/fs/ceph/super.c
> @@ -1068,6 +1068,11 @@ static int ceph_get_tree(struct fs_context *fc)
>  	return 0;
>  
>  out_splat:
> +	if (!ceph_mdsmap_is_cluster_available(fsc->mdsc->mdsmap)) {
> +		pr_info("No mds server is up or the cluster is laggy\n");
> +		err = -EHOSTUNREACH;
> +	}
> +
>  	ceph_mdsc_close_sessions(fsc->mdsc);
>  	deactivate_locked_super(sb);
>  	goto out_final;

Looks reasonable. Merged into testing branch with a revamped changelog.
Please have a look at the testing branch and make sure the changelog is
OK with you.

Thanks,
-- 
Jeff Layton <jlayton@kernel.org>

