Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 590D1504ED7
	for <lists+ceph-devel@lfdr.de>; Mon, 18 Apr 2022 12:25:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233641AbiDRK1y (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 18 Apr 2022 06:27:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235895AbiDRK1w (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 18 Apr 2022 06:27:52 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E12E1BE3F
        for <ceph-devel@vger.kernel.org>; Mon, 18 Apr 2022 03:25:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 11881B80EBE
        for <ceph-devel@vger.kernel.org>; Mon, 18 Apr 2022 10:25:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51D24C385A1;
        Mon, 18 Apr 2022 10:25:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650277509;
        bh=BaC4L3pCogh6Ekl9FlJgW2iOWzeiH+N9pqTHZQU0ERQ=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=dtIznpglHPsvf5KrwmByrOv5LcOJb4YUEEmig9kuMyOj4mLFuin12ha6e5Nf/ZDpI
         NYYSkvMmqaCx0HOUnC1Z0+H9kvaAgmygBpx194Yqp6/eGigeLLGlUnKuf+e/PybV96
         pbMg/C5RPaW2B8oXgvSkeoCRgPxs+E4TknYoChiQEnxct01jPSVypsx87ot85djLDL
         6a1ch92FT8/X/IwaSipdTYOCAVGM+IMpJY+6Jmb7QxiuHzAOLG7jpu2YPR3LjMjaPy
         PMHPyGhD5dn12e6X49ypFwzMngJsVYtcqhYgFfspo6fysLAr1RrFZR1lOaHcXzhDPv
         7TDV8U5pFktsw==
Message-ID: <fd9596a8dc07508588fe8ac1372888eba4f8d82f.camel@kernel.org>
Subject: Re: [PATCH v2] ceph: flush the mdlog for filesystem sync
From:   Jeff Layton <jlayton@kernel.org>
To:     Xiubo Li <xiubli@redhat.com>
Cc:     idryomov@gmail.com, vshankar@redhat.com, ceph-devel@vger.kernel.org
Date:   Mon, 18 Apr 2022 06:25:08 -0400
In-Reply-To: <20220414054512.386293-1-xiubli@redhat.com>
References: <20220414054512.386293-1-xiubli@redhat.com>
Content-Type: text/plain; charset="ISO-8859-15"
User-Agent: Evolution 3.42.4 (3.42.4-2.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Thu, 2022-04-14 at 13:45 +0800, Xiubo Li wrote:
> Before waiting for a request's safe reply, we will send the mdlog
> flush request to the relevant MDS. And this will also flush the
> mdlog for all the other unsafe requests in the same session, so
> we can record the last session and no need to flush mdlog again
> in the next loop. But there still have cases that it may send the
> mdlog flush requst twice or more, but that should be not often.
> 
> URL: https://tracker.ceph.com/issues/55284
> Signed-off-by: Xiubo Li <xiubli@redhat.com>
> ---
> 
> V2:
> - Fixed possible NULL pointer dereference for the req->r_session
> 
> 
>  fs/ceph/mds_client.c | 11 +++++++++++
>  1 file changed, 11 insertions(+)
> 
> diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
> index 0da85c9ce73a..4aaa7b14136e 100644
> --- a/fs/ceph/mds_client.c
> +++ b/fs/ceph/mds_client.c
> @@ -5098,6 +5098,7 @@ void ceph_mdsc_pre_umount(struct ceph_mds_client *mdsc)
>  static void wait_unsafe_requests(struct ceph_mds_client *mdsc, u64 want_tid)
>  {
>  	struct ceph_mds_request *req = NULL, *nextreq;
> +	struct ceph_mds_session *last_session = NULL, *s;
>  	struct rb_node *n;
>  
>  	mutex_lock(&mdsc->mutex);
> @@ -5117,6 +5118,15 @@ static void wait_unsafe_requests(struct ceph_mds_client *mdsc, u64 want_tid)
>  			ceph_mdsc_get_request(req);
>  			if (nextreq)
>  				ceph_mdsc_get_request(nextreq);
> +
> +			/* send flush mdlog request to MDS */
> +			s = req->r_session;
> +			if (s && last_session != s) {
> +				send_flush_mdlog(s);
> +				ceph_put_mds_session(last_session);
> +				last_session = ceph_get_mds_session(s);
> +			}
> +
>  			mutex_unlock(&mdsc->mutex);
>  			dout("wait_unsafe_requests  wait on %llu (want %llu)\n",
>  			     req->r_tid, want_tid);
> @@ -5135,6 +5145,7 @@ static void wait_unsafe_requests(struct ceph_mds_client *mdsc, u64 want_tid)
>  		req = nextreq;
>  	}
>  	mutex_unlock(&mdsc->mutex);
> +	ceph_put_mds_session(last_session);
>  	dout("wait_unsafe_requests done\n");
>  }
>  

Looks reasonable. My only minor nit is that "wait_unsafe_requests" is
not really descriptive of this function anymore since you're not just
waiting on requests anymore, but also sending mdlog flush requests.

The sync handling in this code is a bit of a mess too. We have
unsafe_request_wait which is called from the fsync codepath, and then we
also have wait_unsafe_requests which is called from ceph_sync_fs. I
suspect they do enough of the same things that those could be combined.

So, I'll give my ACK on this, but wouldn't mind seeing some other
cleanup in this area.

Acked-by: Jeff Layton <jlayton@kernel.org>
