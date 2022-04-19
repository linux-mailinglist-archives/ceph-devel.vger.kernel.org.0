Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 13C72506895
	for <lists+ceph-devel@lfdr.de>; Tue, 19 Apr 2022 12:16:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348650AbiDSKSr (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 19 Apr 2022 06:18:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243428AbiDSKSq (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 19 Apr 2022 06:18:46 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D79A213FB2
        for <ceph-devel@vger.kernel.org>; Tue, 19 Apr 2022 03:16:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 71F06610F4
        for <ceph-devel@vger.kernel.org>; Tue, 19 Apr 2022 10:16:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63059C385A5;
        Tue, 19 Apr 2022 10:16:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650363363;
        bh=fKVqiZfYIw+aCq5bjlnwDg5Ha0kizGERcirwG/Q6Hw0=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=XGBykEnYfqNg1Trk7GZDcu8oMH8CT7daFAKzX8N0KcJ3V3rAppC9KkIodXCk33fg6
         vrVcrgTFJQ2PjCxXq2tmE5hTV6DafuvOyO8uCrX55QTJvZG/lc9lO1MatFo2nxinpz
         WohOHi4HXttByOa/+SyNe1kmiDRKEC4U3bhc+S3mZLTmBVHbeOAyRHtp+zR73Zp47h
         5s6H7eDc08F+xwbdqmG/LgHcFj+oFNiOOnbF5cTNBkiYk20tFhIWz9jB1erihIbgZY
         hLohWNDIg2qNYKVXnB/Uw1VeY4HcAg5byGxsq54Ey2GJEP5G7kc+YbT0cU2oQcyzim
         uRkDpAMtsVkbg==
Message-ID: <9f0d95018aac4867bc7e330c86f67de43296f41e.camel@kernel.org>
Subject: Re: [PATCH v4] ceph: flush the mdlog for filesystem sync
From:   Jeff Layton <jlayton@kernel.org>
To:     Xiubo Li <xiubli@redhat.com>
Cc:     idryomov@gmail.com, vshankar@redhat.com, ceph-devel@vger.kernel.org
Date:   Tue, 19 Apr 2022 06:16:02 -0400
In-Reply-To: <20220419005849.802780-1-xiubli@redhat.com>
References: <20220419005849.802780-1-xiubli@redhat.com>
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

On Tue, 2022-04-19 at 08:58 +0800, Xiubo Li wrote:
> Before waiting for a request's safe reply, we will send the mdlog
> flush request to the relevant MDS. And this will also flush the
> mdlog for all the other unsafe requests in the same session, so
> we can record the last session and no need to flush mdlog again
> in the next loop. But there still have cases that it may send the
> mdlog flush requst twice or more, but that should be not often.
> 
> Rename wait_unsafe_requests() to flush_mdlog_and_wait_inode_unsafe_requests()
> to make it more descriptive.
> 
> URL: https://tracker.ceph.com/issues/55284
> Signed-off-by: Xiubo Li <xiubli@redhat.com>
> ---
> 
> V4:
> - Fixed the lock inversion bug.
> 
> 
> 
>  fs/ceph/mds_client.c | 34 ++++++++++++++++++++++++++++------
>  1 file changed, 28 insertions(+), 6 deletions(-)
> 
> diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
> index 0da85c9ce73a..58827af57b7f 100644
> --- a/fs/ceph/mds_client.c
> +++ b/fs/ceph/mds_client.c
> @@ -5093,15 +5093,17 @@ void ceph_mdsc_pre_umount(struct ceph_mds_client *mdsc)
>  }
>  
>  /*
> - * wait for all write mds requests to flush.
> + * flush the mdlog and wait for all write mds requests to flush.
>   */
> -static void wait_unsafe_requests(struct ceph_mds_client *mdsc, u64 want_tid)
> +static void flush_mdlog_and_wait_mdsc_unsafe_requests(struct ceph_mds_client *mdsc,
> +						 u64 want_tid)
>  {
>  	struct ceph_mds_request *req = NULL, *nextreq;
> +	struct ceph_mds_session *last_session = NULL;
>  	struct rb_node *n;
>  
>  	mutex_lock(&mdsc->mutex);
> -	dout("wait_unsafe_requests want %lld\n", want_tid);
> +	dout("%s want %lld\n", __func__, want_tid);
>  restart:
>  	req = __get_oldest_req(mdsc);
>  	while (req && req->r_tid <= want_tid) {
> @@ -5113,14 +5115,33 @@ static void wait_unsafe_requests(struct ceph_mds_client *mdsc, u64 want_tid)
>  			nextreq = NULL;
>  		if (req->r_op != CEPH_MDS_OP_SETFILELOCK &&
>  		    (req->r_op & CEPH_MDS_OP_WRITE)) {
> +			struct ceph_mds_session *s;
> +
>  			/* write op */
>  			ceph_mdsc_get_request(req);
>  			if (nextreq)
>  				ceph_mdsc_get_request(nextreq);
> +
> +			s = req->r_session;
> +			if (!s) {
> +				req = nextreq;
> +				continue;
> +			}
> +			s = ceph_get_mds_session(s);
>  			mutex_unlock(&mdsc->mutex);
> -			dout("wait_unsafe_requests  wait on %llu (want %llu)\n",
> +
> +			/* send flush mdlog request to MDS */
> +			if (last_session != s) {
> +				send_flush_mdlog(s);
> +				ceph_put_mds_session(last_session);
> +				last_session = s;
> +			} else {
> +				ceph_put_mds_session(s);
> +			}
> +			dout("%s wait on %llu (want %llu)\n", __func__,
>  			     req->r_tid, want_tid);
>  			wait_for_completion(&req->r_safe_completion);
> +
>  			mutex_lock(&mdsc->mutex);
>  			ceph_mdsc_put_request(req);
>  			if (!nextreq)
> @@ -5135,7 +5156,8 @@ static void wait_unsafe_requests(struct ceph_mds_client *mdsc, u64 want_tid)
>  		req = nextreq;
>  	}
>  	mutex_unlock(&mdsc->mutex);
> -	dout("wait_unsafe_requests done\n");
> +	ceph_put_mds_session(last_session);
> +	dout("%s done\n", __func__);
>  }
>  
>  void ceph_mdsc_sync(struct ceph_mds_client *mdsc)
> @@ -5164,7 +5186,7 @@ void ceph_mdsc_sync(struct ceph_mds_client *mdsc)
>  	dout("sync want tid %lld flush_seq %lld\n",
>  	     want_tid, want_flush);
>  
> -	wait_unsafe_requests(mdsc, want_tid);
> +	flush_mdlog_and_wait_mdsc_unsafe_requests(mdsc, want_tid);
>  	wait_caps_flush(mdsc, want_flush);
>  }
>  

Reviewed-by: Jeff Layton <jlayton@kernel.org>
