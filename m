Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B68FF3AD9AF
	for <lists+ceph-devel@lfdr.de>; Sat, 19 Jun 2021 12:51:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233022AbhFSKxY (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Sat, 19 Jun 2021 06:53:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:39020 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233143AbhFSKxU (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Sat, 19 Jun 2021 06:53:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 212246120A;
        Sat, 19 Jun 2021 10:51:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624099869;
        bh=aUsPX+nFItWHPd+EdQgT8+dhm7c6uNdqhHhjptNmOss=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=JH4xBrXd9BAC3Lr6WW2Yw6oT09Zeci220I4NDA/EKgK1zDsyxNNszJf0gWFIHuBFc
         giTbZ8z/zqQPfp+TAFiD8vLwSAYAlzalyZUinyE3vdwT9fBEQi4xbrhQQ/Y1OUNYZe
         a5TapQqIoN601UmJ8uiBvhr4Wj/Eu+hiQflLWHbf/Rau6cW97a/RC38VsK11ZQy7+j
         yfeOICVOKKAv4PFi4ixHdO57QfCouJ+acLh43LJ7/wcmdGpWac8k23gO1UgYWQcfza
         B8S25Au7oNt+xZ/wZseDIqRniZCkzVE6wVoV3sRNVVHgmpqpoOnvj3rWWVBeNnW3dm
         EF4H1ScNWJJLQ==
Message-ID: <ca37212d9c848bbb6228cce95ca7f39ef3696437.camel@kernel.org>
Subject: Re: [PATCH] net: ceph: Use CLOCK_MONOTONIC ktime_get_ts64()
From:   Jeff Layton <jlayton@kernel.org>
To:     Yejune Deng <yejune.deng@gmail.com>, idryomov@gmail.com,
        davem@davemloft.net, kuba@kernel.org
Cc:     ceph-devel@vger.kernel.org, linux-kernel@vger.kernel.org
Date:   Sat, 19 Jun 2021 06:51:08 -0400
In-Reply-To: <20210618142740.3345-1-yejune.deng@gmail.com>
References: <20210618142740.3345-1-yejune.deng@gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
User-Agent: Evolution 3.40.2 (3.40.2-1.fc34) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Fri, 2021-06-18 at 22:27 +0800, Yejune Deng wrote:
> The Documentation/core-api/timekeeping.rst recommend that we should use
> monotonic time ktime_get_ts64(), to avoid glitches with a concurrent
> settimeofday().
> 
> Signed-off-by: Yejune Deng <yejune.deng@gmail.com>
> ---
>  net/ceph/messenger.c    | 2 +-
>  net/ceph/messenger_v1.c | 2 +-
>  net/ceph/messenger_v2.c | 2 +-
>  net/ceph/osd_client.c   | 4 ++--
>  4 files changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/net/ceph/messenger.c b/net/ceph/messenger.c
> index 57d043b..2d07ab5 100644
> --- a/net/ceph/messenger.c
> +++ b/net/ceph/messenger.c
> @@ -1809,7 +1809,7 @@ bool ceph_con_keepalive_expired(struct ceph_connection *con,
>  	    (con->peer_features & CEPH_FEATURE_MSGR_KEEPALIVE2)) {
>  		struct timespec64 now;
>  		struct timespec64 ts;
> -		ktime_get_real_ts64(&now);
> +		ktime_get_ts64(&now);
>  		jiffies_to_timespec64(interval, &ts);
>  		ts = timespec64_add(con->last_keepalive_ack, ts);
>  		return timespec64_compare(&now, &ts) >= 0;
> diff --git a/net/ceph/messenger_v1.c b/net/ceph/messenger_v1.c
> index 2cb5ffd..2ec7b1d 100644
> --- a/net/ceph/messenger_v1.c
> +++ b/net/ceph/messenger_v1.c
> @@ -310,7 +310,7 @@ static void prepare_write_keepalive(struct ceph_connection *con)
>  	if (con->peer_features & CEPH_FEATURE_MSGR_KEEPALIVE2) {
>  		struct timespec64 now;
>  
> -		ktime_get_real_ts64(&now);
> +		ktime_get_ts64(&now);
>  		con_out_kvec_add(con, sizeof(tag_keepalive2), &tag_keepalive2);
>  		ceph_encode_timespec64(&con->v1.out_temp_keepalive2, &now);
>  		con_out_kvec_add(con, sizeof(con->v1.out_temp_keepalive2),
> diff --git a/net/ceph/messenger_v2.c b/net/ceph/messenger_v2.c
> index cc40ce4..2125e77 100644
> --- a/net/ceph/messenger_v2.c
> +++ b/net/ceph/messenger_v2.c
> @@ -1439,7 +1439,7 @@ static int prepare_keepalive2(struct ceph_connection *con)
>  	struct ceph_timespec *ts = CTRL_BODY(con->v2.out_buf);
>  	struct timespec64 now;
>  
> -	ktime_get_real_ts64(&now);
> +	ktime_get_ts64(&now);
>  	dout("%s con %p timestamp %lld.%09ld\n", __func__, con, now.tv_sec,
>  	     now.tv_nsec);
>  
> diff --git a/net/ceph/osd_client.c b/net/ceph/osd_client.c
> index ff8624a..5192a8a 100644
> --- a/net/ceph/osd_client.c
> +++ b/net/ceph/osd_client.c
> @@ -4717,7 +4717,7 @@ ceph_osdc_watch(struct ceph_osd_client *osdc,
>  	ceph_oid_copy(&lreq->t.base_oid, oid);
>  	ceph_oloc_copy(&lreq->t.base_oloc, oloc);
>  	lreq->t.flags = CEPH_OSD_FLAG_WRITE;
> -	ktime_get_real_ts64(&lreq->mtime);
> +	ktime_get_ts64(&lreq->mtime);
>  
>  	lreq->reg_req = alloc_watch_request(lreq, CEPH_OSD_WATCH_OP_WATCH);
>  	if (!lreq->reg_req) {
> @@ -4767,7 +4767,7 @@ int ceph_osdc_unwatch(struct ceph_osd_client *osdc,
>  	ceph_oid_copy(&req->r_base_oid, &lreq->t.base_oid);
>  	ceph_oloc_copy(&req->r_base_oloc, &lreq->t.base_oloc);
>  	req->r_flags = CEPH_OSD_FLAG_WRITE;
> -	ktime_get_real_ts64(&req->r_mtime);
> +	ktime_get_ts64(&req->r_mtime);
>  	osd_req_op_watch_init(req, 0, lreq->linger_id,
>  			      CEPH_OSD_WATCH_OP_UNWATCH);
>  

I think this is OK. Most of these timestamps get marshalled onto the
wire to use as identifiers. Those are almost certainly better off with
CLOCK_MONOTONIC since you could have a clock jump that caused you to
send (e.g.) 2 keepalives with the same timestamp otherwise.

Reviewed-by: Jeff Layton <jlayton@kernel.org>

