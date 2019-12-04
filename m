Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CBF1B112D69
	for <lists+ceph-devel@lfdr.de>; Wed,  4 Dec 2019 15:26:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727911AbfLDO0M (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 4 Dec 2019 09:26:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:58856 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727867AbfLDO0M (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Wed, 4 Dec 2019 09:26:12 -0500
Received: from tleilax.poochiereds.net (68-20-15-154.lightspeed.rlghnc.sbcglobal.net [68.20.15.154])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D602D20675;
        Wed,  4 Dec 2019 14:26:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575469571;
        bh=Z8eK8/MSuwOkBqh5TqyNn+JjBARYSgpBx4V3X08U2Ak=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=QOQLkfHnu/g6IN/Tnq16D3GZtz8s1PIsss7et78nlLp7WoMwAtKX7WKOdD7y8GeBO
         eEZuGhBRMIuCEpbl8TSOrJ7MTihzI60x1gKID1aHdxO/nhjgixltYamDUylhjOh2zX
         tyuw1gdfYJPyiQ4wI855CkwiwQIRTlcHO9zqAFzM=
Message-ID: <0cc3149a27bf6c64ba3a7b1530d623c68ed02531.camel@kernel.org>
Subject: Re: [PATCH] ceph: fix possible long time wait during umount
From:   Jeff Layton <jlayton@kernel.org>
To:     xiubli@redhat.com
Cc:     sage@redhat.com, idryomov@gmail.com, zyan@redhat.com,
        pdonnell@redhat.com, ceph-devel@vger.kernel.org
Date:   Wed, 04 Dec 2019 09:26:09 -0500
In-Reply-To: <20191204062718.56105-1-xiubli@redhat.com>
References: <20191204062718.56105-1-xiubli@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.2 (3.34.2-1.fc31) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Wed, 2019-12-04 at 01:27 -0500, xiubli@redhat.com wrote:
> From: Xiubo Li <xiubli@redhat.com>
> 
> During umount, if there has no any unsafe request in the mdsc and
> some requests still in-flight and not got reply yet, and if the
> rest requets are all safe ones, after that even all of them in mdsc
> are unregistered, the umount must wait until after mount_timeout
> seconds anyway.
> 
> Signed-off-by: Xiubo Li <xiubli@redhat.com>
> ---
>  fs/ceph/mds_client.c | 7 ++++---
>  1 file changed, 4 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
> index 163b470f3000..39f4d8501df5 100644
> --- a/fs/ceph/mds_client.c
> +++ b/fs/ceph/mds_client.c
> @@ -2877,6 +2877,10 @@ static void handle_reply(struct ceph_mds_session *session, struct ceph_msg *msg)
>  		set_bit(CEPH_MDS_R_GOT_SAFE, &req->r_req_flags);
>  		__unregister_request(mdsc, req);
>  
> +		/* last request during umount? */
> +		if (mdsc->stopping && !__get_oldest_req(mdsc))
> +			complete_all(&mdsc->safe_umount_waiters);
> +
>  		if (test_bit(CEPH_MDS_R_GOT_UNSAFE, &req->r_req_flags)) {
>  			/*
>  			 * We already handled the unsafe response, now do the
> @@ -2887,9 +2891,6 @@ static void handle_reply(struct ceph_mds_session *session, struct ceph_msg *msg)
>  			 */
>  			dout("got safe reply %llu, mds%d\n", tid, mds);
>  
> -			/* last unsafe request during umount? */
> -			if (mdsc->stopping && !__get_oldest_req(mdsc))
> -				complete_all(&mdsc->safe_umount_waiters);
>  			mutex_unlock(&mdsc->mutex);
>  			goto out;
>  		}

Looks reasonable. AIUI, the MDS is free to send a safe reply without
ever sending an unsafe one, so I don't see why we want to make that
conditional on receiving an earlier unsafe reply.
-- 
Jeff Layton <jlayton@kernel.org>

