Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2516627D759
	for <lists+ceph-devel@lfdr.de>; Tue, 29 Sep 2020 21:55:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728800AbgI2TzK (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 29 Sep 2020 15:55:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:48884 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728226AbgI2TzK (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Tue, 29 Sep 2020 15:55:10 -0400
Received: from tleilax.poochiereds.net (68-20-15-154.lightspeed.rlghnc.sbcglobal.net [68.20.15.154])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 125D020774;
        Tue, 29 Sep 2020 19:55:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601409309;
        bh=Ry+IsHRby46BDMgnna99JY+kLtsmnM5PZLFbpm/w1R0=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=IR/pKK5OuMj8uDP3xHpd4v+Thza9sOMf8fxZuuuusIkaYs1FAVl/l0SKnMLbJFPfI
         U4jNto+o4+LV7EMGf9t5KS6cFiXZmupuaIhIJT8B3a3RgUNu21iybjVTog8ec02YXb
         ksa5GqeFEbGCyS3xCvWc4jgp++GN/Cz+eJv1yeUs=
Message-ID: <eb2d601b8b9d7bac8fa5df4c7dc1f6a15bde6b47.camel@kernel.org>
Subject: Re: [RFC PATCH 4/4] ceph: queue request when CLEANRECOVER is set
From:   Jeff Layton <jlayton@kernel.org>
To:     ceph-devel@vger.kernel.org
Cc:     idryomov@gmail.com, ukernel@gmail.com, pdonnell@redhat.com
Date:   Tue, 29 Sep 2020 15:55:07 -0400
In-Reply-To: <20200925140851.320673-5-jlayton@kernel.org>
References: <20200925140851.320673-1-jlayton@kernel.org>
         <20200925140851.320673-5-jlayton@kernel.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Fri, 2020-09-25 at 10:08 -0400, Jeff Layton wrote:
> Ilya noticed that the first access to a blacklisted mount would often
> get back -EACCES, but then subsequent calls would be OK. The problem is
> in __do_request. If the session is marked as REJECTED, a hard error is
> returned instead of waiting for a new session to come into being.
> 
> When the session is REJECTED and the mount was done with
> recover_session=clean, queue the request to the waiting_for_map queue,
> which will be awoken after tearing down the old session.
> 
> URL: https://tracker.ceph.com/issues/47385
> Reported-by: Ilya Dryomov <idryomov@gmail.com>
> Signed-off-by: Jeff Layton <jlayton@kernel.org>
> ---
>  fs/ceph/mds_client.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
> index fd16db6ecb0a..b07e7adf146f 100644
> --- a/fs/ceph/mds_client.c
> +++ b/fs/ceph/mds_client.c
> @@ -2819,7 +2819,10 @@ static void __do_request(struct ceph_mds_client *mdsc,
>  	if (session->s_state != CEPH_MDS_SESSION_OPEN &&
>  	    session->s_state != CEPH_MDS_SESSION_HUNG) {
>  		if (session->s_state == CEPH_MDS_SESSION_REJECTED) {
> -			err = -EACCES;
> +			if (ceph_test_mount_opt(mdsc->fsc, CLEANRECOVER))
> +				list_add(&req->r_wait, &mdsc->waiting_for_map);
> +			else
> +				err = -EACCES;
>  			goto out_session;
>  		}
>  		/*

I think this is wrong when CEPH_MDS_R_ASYNC is set. I'll send a v2 set
if we end up staying with this approach.
-- 
Jeff Layton <jlayton@kernel.org>

