Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 64E6C102AC8
	for <lists+ceph-devel@lfdr.de>; Tue, 19 Nov 2019 18:28:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728528AbfKSR26 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 19 Nov 2019 12:28:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:38350 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728060AbfKSR25 (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Tue, 19 Nov 2019 12:28:57 -0500
Received: from tleilax.poochiereds.net (68-20-15-154.lightspeed.rlghnc.sbcglobal.net [68.20.15.154])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6B2E9208A1;
        Tue, 19 Nov 2019 17:28:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574184537;
        bh=GKlGK69iHTa/H5Ql41aPNCWtNEMlnT25CP6rvry5zzk=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=XdLQyR5v5zb6/W/g9hXuSrLoLV5bAcGR0C4WTgrk0TMVteatA+Wf0NF4hrQB/qlAe
         3bLCHFOnSPmXQPJf5E1lGjDaJ4VJ0PgSSO8pGhYeFQTJ4v106E/t/lPjvKOjYCwbcn
         v0ghcl5JNblkyLUGgejyFnvLpk8Ou2QMpx6Qw7Ek=
Message-ID: <d3650353d002964adb4b3f38335ff9e90a11a918.camel@kernel.org>
Subject: Re: [PATCH] ceph: check availability of mds cluster on mount after
 wait timeout
From:   Jeff Layton <jlayton@kernel.org>
To:     xiubli@redhat.com, sage@redhat.com, idryomov@gmail.com
Cc:     ceph-devel@vger.kernel.org, zyan@redhat.com, pdonnell@redhat.com
Date:   Tue, 19 Nov 2019 12:28:55 -0500
In-Reply-To: <20191119130440.19384-1-xiubli@redhat.com>
References: <20191119130440.19384-1-xiubli@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.1 (3.34.1-1.fc31) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Tue, 2019-11-19 at 08:04 -0500, xiubli@redhat.com wrote:
> From: Xiubo Li <xiubli@redhat.com>
> 
> If all the MDS daemons are down for some reasons, and immediately
> just before the kclient getting the new mdsmap the mount request is
> fired out, it will be the request wait will timeout with -EIO.
> 
> After this just check the mds cluster availability to give a friendly
> hint to let the users check the MDS cluster status.
> 
> Signed-off-by: Xiubo Li <xiubli@redhat.com>
> ---
>  fs/ceph/mds_client.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
> index a5163296d9d9..82a929084671 100644
> --- a/fs/ceph/mds_client.c
> +++ b/fs/ceph/mds_client.c
> @@ -2712,6 +2712,9 @@ static int ceph_mdsc_wait_request(struct ceph_mds_client *mdsc,
>  	if (test_bit(CEPH_MDS_R_GOT_RESULT, &req->r_req_flags)) {
>  		err = le32_to_cpu(req->r_reply_info.head->result);
>  	} else if (err < 0) {
> +		if (!ceph_mdsmap_is_cluster_available(mdsc->mdsmap))
> +			pr_info("probably no mds server is up\n");
> +
>  		dout("aborted request %lld with %d\n", req->r_tid, err);
>  
>  		/*

Probably? If they're all unavailable then definitely. Also, this is a
pr_info message, so you probably need to prefix this with "ceph: ".

Beyond that though, do we want to do this in what amounts to low-level
infrastructure for MDS requests?

I wonder if a warning like this would be better suited in
open_root_dentry(). If ceph_mdsc_do_request returns -EIO [1] maybe have
open_root_dentry do the check and pr_info?

[1]: Why does it use -EIO here anyway? Wouldn't -ETIMEOUT or something
be better? Maybe the worry was that that error could bubble up to userla
nd?

-- 
Jeff Layton <jlayton@kernel.org>

