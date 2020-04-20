Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E15C71B0924
	for <lists+ceph-devel@lfdr.de>; Mon, 20 Apr 2020 14:17:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726984AbgDTMQy (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 20 Apr 2020 08:16:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:52274 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726936AbgDTMQr (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Mon, 20 Apr 2020 08:16:47 -0400
Received: from tleilax.poochiereds.net (68-20-15-154.lightspeed.rlghnc.sbcglobal.net [68.20.15.154])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 923C42072B;
        Mon, 20 Apr 2020 12:16:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587385007;
        bh=mVVhiLWYoJYsxwNunGtZw2deVsVqQX5hegxPcF8jXEc=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=gP4Cr4Z5ZHEb4bcJyPTJt5zBQurdyOt5Fiy1sNYvMkyVSghB2nOZcVmkGmRrnurK0
         amnRBOLxSY+3m02vnE0K8ToD8XBKtmk4DrTUroEeKN/dsk2KIQm9UVh9+zwnskujS0
         zEBMk7tbQCn0dRMbtmjpddQ8WkKjn799bVzeZtJU=
Message-ID: <ad6ca41f601d4feb2c3bd2850aeab95c3187bf2d.camel@kernel.org>
Subject: Re: [v3] ceph: if we are blacklisted, __do_request returns directly
From:   Jeff Layton <jlayton@kernel.org>
To:     Yanhu Cao <gmayyyha@gmail.com>
Cc:     sage@redhat.com, idryomov@gmail.com, ceph-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Mon, 20 Apr 2020 08:16:45 -0400
In-Reply-To: <20200417110723.12235-1-gmayyyha@gmail.com>
References: <20200417110723.12235-1-gmayyyha@gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.4 (3.34.4-1.fc31) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Fri, 2020-04-17 at 19:07 +0800, Yanhu Cao wrote:
> If we mount cephfs by the recover_session option,
> __do_request can return directly until the client automatically reconnects.
> 
> Signed-off-by: Yanhu Cao <gmayyyha@gmail.com>
> ---
>  fs/ceph/mds_client.c | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
> index 486f91f9685b..16ac5e5f7f79 100644
> --- a/fs/ceph/mds_client.c
> +++ b/fs/ceph/mds_client.c
> @@ -2708,6 +2708,12 @@ static void __do_request(struct ceph_mds_client *mdsc,
>  
>  	put_request_session(req);
>  
> +	if (mdsc->fsc->blacklisted &&
> +	    ceph_test_mount_opt(mdsc->fsc, CLEANRECOVER)) {
> +		err = -EBLACKLISTED;
> +		goto finish;
> +	}
> +

Why check for CLEANRECOVER? If we're mounted with recover_session=no
wouldn't we want to do the same thing here?

Either way, it's still blacklisted. The only difference is that it won't
attempt to automatically recover the session that way.


>  	mds = __choose_mds(mdsc, req, &random);
>  	if (mds < 0 ||
>  	    ceph_mdsmap_get_state(mdsc->mdsmap, mds) < CEPH_MDS_STATE_ACTIVE) {
-- 
Jeff Layton <jlayton@kernel.org>

