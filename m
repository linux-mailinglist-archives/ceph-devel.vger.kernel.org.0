Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DAFB952BE9F
	for <lists+ceph-devel@lfdr.de>; Wed, 18 May 2022 17:26:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238638AbiERObF (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 18 May 2022 10:31:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238670AbiERObB (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 18 May 2022 10:31:01 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 172D9201A2
        for <ceph-devel@vger.kernel.org>; Wed, 18 May 2022 07:30:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 605B46182F
        for <ceph-devel@vger.kernel.org>; Wed, 18 May 2022 14:30:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35B43C385AA;
        Wed, 18 May 2022 14:30:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652884253;
        bh=0yQj+YMseeSP/UuPNaB90YqXUO8s+jm+UKEYVkqQQ5c=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=N5PE4aH9BaQNlAHsvZXqC8qj2Ha29jCxM/g8rWx+bLB+OtAByoaXX/qh/I+4Txmmo
         aRm/m4XHLHSGKmkzxQJ+L0psW942ePUC0adlvZtJi/M7o2I0Bx0jlcWK9qymyyZ83A
         5uBeg2+ZBOUJE1pXzht0szMoKHnf3RYLorkSX7jRXFHv06WJhjpRY/qKFsj6m2Rf+2
         MeichDLtT9p7UXeclLOetaYdMmkD05UiYEXTLljsMnBk2pP4fnYY8k+Ad592kzAdZb
         lKmSHnaXGejPR160RRBkhildZasJEjq0kYs1X0lN4bmw0ydaQUXzfXogd9f+2N5DY6
         SuQViUAKFhm9w==
Message-ID: <ea6da2ac8d879743a29d4eb29c2256bf0be6f905.camel@kernel.org>
Subject: Re: [PATCH] libceph: fix potential use-after-free on linger ping
 and resends
From:   Jeff Layton <jlayton@kernel.org>
To:     Ilya Dryomov <idryomov@gmail.com>, ceph-devel@vger.kernel.org
Cc:     Xiubo Li <xiubli@redhat.com>
Date:   Wed, 18 May 2022 10:30:51 -0400
In-Reply-To: <20220517095346.14984-1-idryomov@gmail.com>
References: <20220517095346.14984-1-idryomov@gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.1 (3.44.1-1.fc36) 
MIME-Version: 1.0
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Tue, 2022-05-17 at 11:53 +0200, Ilya Dryomov wrote:
> request_reinit() is not only ugly as the comment rightfully suggests,
> but also unsafe.  Even though it is called with osdc->lock held for
> write in all cases, resetting the OSD request refcount can still race
> with handle_reply() and result in use-after-free.  Taking linger ping
> as an example:
>=20
>     handle_timeout thread                     handle_reply thread
>=20
>                                               down_read(&osdc->lock)
>                                               req =3D lookup_request(...)
>                                               ...
>                                               finish_request(req)  # unre=
gisters
>                                               up_read(&osdc->lock)
>                                               __complete_request(req)
>                                                 linger_ping_cb(req)
>=20
>       # req->r_kref =3D=3D 2 because handle_reply still holds its ref
>=20
>     down_write(&osdc->lock)
>     send_linger_ping(lreq)
>       req =3D lreq->ping_req  # same req
>       # cancel_linger_request is NOT
>       # called - handle_reply already
>       # unregistered
>       request_reinit(req)
>         WARN_ON(req->r_kref !=3D 1)  # fires
>         request_init(req)
>           kref_init(req->r_kref)
>=20
>                    # req->r_kref =3D=3D 1 after kref_init
>=20
>                                               ceph_osdc_put_request(req)
>                                                 kref_put(req->r_kref)
>=20
>             # req->r_kref =3D=3D 0 after kref_put, req is freed
>=20
>         <further req initialization/use> !!!
>=20
> This happens because send_linger_ping() always (re)uses the same OSD
> request for watch ping requests, relying on cancel_linger_request() to
> unregister it from the OSD client and rip its messages out from the
> messenger.  seng_linger() does the same for watch/notify registration
> and watch reconnect requests.  Unfortunately cancel_request() doesn't
> guarantee that after it returns the OSD client would be completely done
> with the OSD request -- a ref could still be held and the callback (if
> specified) could still be invoked too.
>=20
> The original motivation for request_reinit() was inability to deal with
> allocation failures in send_linger() and send_linger_ping().  Switching
> to using osdc->req_mempool (currently only used by CephFS) respects that
> and allows us to get rid of request_reinit().
>=20
> Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
> ---
>  include/linux/ceph/osd_client.h |   3 +
>  net/ceph/osd_client.c           | 302 +++++++++++++-------------------
>  2 files changed, 122 insertions(+), 183 deletions(-)
>=20

The diffstat is nice!

I'd also like to take this opportunity to ask: What does a linger
request actually do? I see that they're sent during watch and notify,
but it's not clear to me how these are different from other sorts of OSD
ops.

> diff --git a/include/linux/ceph/osd_client.h b/include/linux/ceph/osd_cli=
ent.h
> index 3431011f364d..cba8a6ffc329 100644
> --- a/include/linux/ceph/osd_client.h
> +++ b/include/linux/ceph/osd_client.h
> @@ -287,6 +287,9 @@ struct ceph_osd_linger_request {
>  	rados_watcherrcb_t errcb;
>  	void *data;
> =20
> +	struct ceph_pagelist *request_pl;
> +	struct page **notify_id_pages;
> +
>  	struct page ***preply_pages;
>  	size_t *preply_len;
>  };
> diff --git a/net/ceph/osd_client.c b/net/ceph/osd_client.c
> index 83eb97c94e83..4b88f2a4a6e2 100644
> --- a/net/ceph/osd_client.c
> +++ b/net/ceph/osd_client.c
> @@ -537,43 +537,6 @@ static void request_init(struct ceph_osd_request *re=
q)
>  	target_init(&req->r_t);
>  }
> =20
> -/*
> - * This is ugly, but it allows us to reuse linger registration and ping
> - * requests, keeping the structure of the code around send_linger{_ping}=
()
> - * reasonable.  Setting up a min_nr=3D2 mempool for each linger request
> - * and dealing with copying ops (this blasts req only, watch op remains
> - * intact) isn't any better.
> - */
> -static void request_reinit(struct ceph_osd_request *req)
> -{
> -	struct ceph_osd_client *osdc =3D req->r_osdc;
> -	bool mempool =3D req->r_mempool;
> -	unsigned int num_ops =3D req->r_num_ops;
> -	u64 snapid =3D req->r_snapid;
> -	struct ceph_snap_context *snapc =3D req->r_snapc;
> -	bool linger =3D req->r_linger;
> -	struct ceph_msg *request_msg =3D req->r_request;
> -	struct ceph_msg *reply_msg =3D req->r_reply;
> -
> -	dout("%s req %p\n", __func__, req);
> -	WARN_ON(kref_read(&req->r_kref) !=3D 1);
> -	request_release_checks(req);
> -
> -	WARN_ON(kref_read(&request_msg->kref) !=3D 1);
> -	WARN_ON(kref_read(&reply_msg->kref) !=3D 1);
> -	target_destroy(&req->r_t);
> -
> -	request_init(req);
> -	req->r_osdc =3D osdc;
> -	req->r_mempool =3D mempool;
> -	req->r_num_ops =3D num_ops;
> -	req->r_snapid =3D snapid;
> -	req->r_snapc =3D snapc;
> -	req->r_linger =3D linger;
> -	req->r_request =3D request_msg;
> -	req->r_reply =3D reply_msg;
> -}
> -
>  struct ceph_osd_request *ceph_osdc_alloc_request(struct ceph_osd_client =
*osdc,
>  					       struct ceph_snap_context *snapc,
>  					       unsigned int num_ops,
> @@ -918,14 +881,30 @@ EXPORT_SYMBOL(osd_req_op_xattr_init);
>   * @watch_opcode: CEPH_OSD_WATCH_OP_*
>   */
>  static void osd_req_op_watch_init(struct ceph_osd_request *req, int whic=
h,
> -				  u64 cookie, u8 watch_opcode)
> +				  u8 watch_opcode, u64 cookie, u32 gen)
>  {
>  	struct ceph_osd_req_op *op;
> =20
>  	op =3D osd_req_op_init(req, which, CEPH_OSD_OP_WATCH, 0);
>  	op->watch.cookie =3D cookie;
>  	op->watch.op =3D watch_opcode;
> -	op->watch.gen =3D 0;
> +	op->watch.gen =3D gen;
> +}
> +
> +/*
> + * prot_ver, timeout and notify payload (may be empty) should already be
> + * encoded in @request_pl
> + */
> +static void osd_req_op_notify_init(struct ceph_osd_request *req, int whi=
ch,
> +				   u64 cookie, struct ceph_pagelist *request_pl)
> +{
> +	struct ceph_osd_req_op *op;
> +
> +	op =3D osd_req_op_init(req, which, CEPH_OSD_OP_NOTIFY, 0);
> +	op->notify.cookie =3D cookie;
> +
> +	ceph_osd_data_pagelist_init(&op->notify.request_data, request_pl);
> +	op->indata_len =3D request_pl->length;
>  }
> =20
>  /*
> @@ -2731,10 +2710,13 @@ static void linger_release(struct kref *kref)
>  	WARN_ON(!list_empty(&lreq->pending_lworks));
>  	WARN_ON(lreq->osd);
> =20
> -	if (lreq->reg_req)
> -		ceph_osdc_put_request(lreq->reg_req);
> -	if (lreq->ping_req)
> -		ceph_osdc_put_request(lreq->ping_req);
> +	if (lreq->request_pl)
> +		ceph_pagelist_release(lreq->request_pl);
> +	if (lreq->notify_id_pages)
> +		ceph_release_page_vector(lreq->notify_id_pages, 1);
> +
> +	ceph_osdc_put_request(lreq->reg_req);
> +	ceph_osdc_put_request(lreq->ping_req);
>  	target_destroy(&lreq->t);
>  	kfree(lreq);
>  }
> @@ -3003,6 +2985,12 @@ static void linger_commit_cb(struct ceph_osd_reque=
st *req)
>  	struct ceph_osd_linger_request *lreq =3D req->r_priv;
> =20
>  	mutex_lock(&lreq->lock);
> +	if (req !=3D lreq->reg_req) {
> +		dout("%s lreq %p linger_id %llu unknown req (%p !=3D %p)\n",
> +		     __func__, lreq, lreq->linger_id, req, lreq->reg_req);
> +		goto out;
> +	}
> +
>  	dout("%s lreq %p linger_id %llu result %d\n", __func__, lreq,
>  	     lreq->linger_id, req->r_result);
>  	linger_reg_commit_complete(lreq, req->r_result);
> @@ -3026,6 +3014,7 @@ static void linger_commit_cb(struct ceph_osd_reques=
t *req)
>  		}
>  	}
> =20
> +out:
>  	mutex_unlock(&lreq->lock);
>  	linger_put(lreq);
>  }
> @@ -3048,6 +3037,12 @@ static void linger_reconnect_cb(struct ceph_osd_re=
quest *req)
>  	struct ceph_osd_linger_request *lreq =3D req->r_priv;
> =20
>  	mutex_lock(&lreq->lock);
> +	if (req !=3D lreq->reg_req) {
> +		dout("%s lreq %p linger_id %llu unknown req (%p !=3D %p)\n",
> +		     __func__, lreq, lreq->linger_id, req, lreq->reg_req);
> +		goto out;
> +	}
> +
>  	dout("%s lreq %p linger_id %llu result %d last_error %d\n", __func__,
>  	     lreq, lreq->linger_id, req->r_result, lreq->last_error);
>  	if (req->r_result < 0) {
> @@ -3057,46 +3052,64 @@ static void linger_reconnect_cb(struct ceph_osd_r=
equest *req)
>  		}
>  	}
> =20
> +out:
>  	mutex_unlock(&lreq->lock);
>  	linger_put(lreq);
>  }
> =20
>  static void send_linger(struct ceph_osd_linger_request *lreq)
>  {
> -	struct ceph_osd_request *req =3D lreq->reg_req;
> -	struct ceph_osd_req_op *op =3D &req->r_ops[0];
> +	struct ceph_osd_client *osdc =3D lreq->osdc;
> +	struct ceph_osd_request *req;
> +	int ret;
> =20
> -	verify_osdc_wrlocked(req->r_osdc);
> +	verify_osdc_wrlocked(osdc);
> +	mutex_lock(&lreq->lock);
>  	dout("%s lreq %p linger_id %llu\n", __func__, lreq, lreq->linger_id);
> =20
> -	if (req->r_osd)
> -		cancel_linger_request(req);
> +	if (lreq->reg_req) {
> +		if (lreq->reg_req->r_osd)
> +			cancel_linger_request(lreq->reg_req);
> +		ceph_osdc_put_request(lreq->reg_req);
> +	}
> +
> +	req =3D ceph_osdc_alloc_request(osdc, NULL, 1, true, GFP_NOIO);
> +	BUG_ON(!req);
> =20
> -	request_reinit(req);
>  	target_copy(&req->r_t, &lreq->t);
>  	req->r_mtime =3D lreq->mtime;
> =20
> -	mutex_lock(&lreq->lock);
>  	if (lreq->is_watch && lreq->committed) {
> -		WARN_ON(op->op !=3D CEPH_OSD_OP_WATCH ||
> -			op->watch.cookie !=3D lreq->linger_id);
> -		op->watch.op =3D CEPH_OSD_WATCH_OP_RECONNECT;
> -		op->watch.gen =3D ++lreq->register_gen;
> +		osd_req_op_watch_init(req, 0, CEPH_OSD_WATCH_OP_RECONNECT,
> +				      lreq->linger_id, ++lreq->register_gen);
>  		dout("lreq %p reconnect register_gen %u\n", lreq,
> -		     op->watch.gen);
> +		     req->r_ops[0].watch.gen);
>  		req->r_callback =3D linger_reconnect_cb;
>  	} else {
> -		if (!lreq->is_watch)
> +		if (lreq->is_watch) {
> +			osd_req_op_watch_init(req, 0, CEPH_OSD_WATCH_OP_WATCH,
> +					      lreq->linger_id, 0);
> +		} else {
>  			lreq->notify_id =3D 0;
> -		else
> -			WARN_ON(op->watch.op !=3D CEPH_OSD_WATCH_OP_WATCH);
> +
> +			refcount_inc(&lreq->request_pl->refcnt);
> +			osd_req_op_notify_init(req, 0, lreq->linger_id,
> +					       lreq->request_pl);
> +			ceph_osd_data_pages_init(
> +			    osd_req_op_data(req, 0, notify, response_data),
> +			    lreq->notify_id_pages, PAGE_SIZE, 0, false, false);
> +		}
>  		dout("lreq %p register\n", lreq);
>  		req->r_callback =3D linger_commit_cb;
>  	}
> -	mutex_unlock(&lreq->lock);
> +
> +	ret =3D ceph_osdc_alloc_messages(req, GFP_NOIO);
> +	BUG_ON(ret);
> =20
>  	req->r_priv =3D linger_get(lreq);
>  	req->r_linger =3D true;
> +	lreq->reg_req =3D req;
> +	mutex_unlock(&lreq->lock);
> =20
>  	submit_request(req, true);
>  }
> @@ -3106,6 +3119,12 @@ static void linger_ping_cb(struct ceph_osd_request=
 *req)
>  	struct ceph_osd_linger_request *lreq =3D req->r_priv;
> =20
>  	mutex_lock(&lreq->lock);
> +	if (req !=3D lreq->ping_req) {
> +		dout("%s lreq %p linger_id %llu unknown req (%p !=3D %p)\n",
> +		     __func__, lreq, lreq->linger_id, req, lreq->ping_req);
> +		goto out;
> +	}
> +
>  	dout("%s lreq %p linger_id %llu result %d ping_sent %lu last_error %d\n=
",
>  	     __func__, lreq, lreq->linger_id, req->r_result, lreq->ping_sent,
>  	     lreq->last_error);
> @@ -3121,6 +3140,7 @@ static void linger_ping_cb(struct ceph_osd_request =
*req)
>  		     lreq->register_gen, req->r_ops[0].watch.gen);
>  	}
> =20
> +out:
>  	mutex_unlock(&lreq->lock);
>  	linger_put(lreq);
>  }
> @@ -3128,8 +3148,8 @@ static void linger_ping_cb(struct ceph_osd_request =
*req)
>  static void send_linger_ping(struct ceph_osd_linger_request *lreq)
>  {
>  	struct ceph_osd_client *osdc =3D lreq->osdc;
> -	struct ceph_osd_request *req =3D lreq->ping_req;
> -	struct ceph_osd_req_op *op =3D &req->r_ops[0];
> +	struct ceph_osd_request *req;
> +	int ret;
> =20
>  	if (ceph_osdmap_flag(osdc, CEPH_OSDMAP_PAUSERD)) {
>  		dout("%s PAUSERD\n", __func__);
> @@ -3141,19 +3161,26 @@ static void send_linger_ping(struct ceph_osd_ling=
er_request *lreq)
>  	     __func__, lreq, lreq->linger_id, lreq->ping_sent,
>  	     lreq->register_gen);
> =20
> -	if (req->r_osd)
> -		cancel_linger_request(req);
> +	if (lreq->ping_req) {
> +		if (lreq->ping_req->r_osd)
> +			cancel_linger_request(lreq->ping_req);
> +		ceph_osdc_put_request(lreq->ping_req);
> +	}
> =20
> -	request_reinit(req);
> -	target_copy(&req->r_t, &lreq->t);
> +	req =3D ceph_osdc_alloc_request(osdc, NULL, 1, true, GFP_NOIO);
> +	BUG_ON(!req);
> =20
> -	WARN_ON(op->op !=3D CEPH_OSD_OP_WATCH ||
> -		op->watch.cookie !=3D lreq->linger_id ||
> -		op->watch.op !=3D CEPH_OSD_WATCH_OP_PING);
> -	op->watch.gen =3D lreq->register_gen;
> +	target_copy(&req->r_t, &lreq->t);
> +	osd_req_op_watch_init(req, 0, CEPH_OSD_WATCH_OP_PING, lreq->linger_id,
> +			      lreq->register_gen);
>  	req->r_callback =3D linger_ping_cb;
> +
> +	ret =3D ceph_osdc_alloc_messages(req, GFP_NOIO);
> +	BUG_ON(ret);
> +
>  	req->r_priv =3D linger_get(lreq);
>  	req->r_linger =3D true;
> +	lreq->ping_req =3D req;
> =20
>  	ceph_osdc_get_request(req);
>  	account_request(req);
> @@ -3169,12 +3196,6 @@ static void linger_submit(struct ceph_osd_linger_r=
equest *lreq)
> =20
>  	down_write(&osdc->lock);
>  	linger_register(lreq);
> -	if (lreq->is_watch) {
> -		lreq->reg_req->r_ops[0].watch.cookie =3D lreq->linger_id;
> -		lreq->ping_req->r_ops[0].watch.cookie =3D lreq->linger_id;
> -	} else {
> -		lreq->reg_req->r_ops[0].notify.cookie =3D lreq->linger_id;
> -	}
> =20
>  	calc_target(osdc, &lreq->t, false);
>  	osd =3D lookup_create_osd(osdc, lreq->t.osd, true);
> @@ -3206,9 +3227,9 @@ static void cancel_linger_map_check(struct ceph_osd=
_linger_request *lreq)
>   */
>  static void __linger_cancel(struct ceph_osd_linger_request *lreq)
>  {
> -	if (lreq->is_watch && lreq->ping_req->r_osd)
> +	if (lreq->ping_req && lreq->ping_req->r_osd)
>  		cancel_linger_request(lreq->ping_req);
> -	if (lreq->reg_req->r_osd)
> +	if (lreq->reg_req && lreq->reg_req->r_osd)
>  		cancel_linger_request(lreq->reg_req);
>  	cancel_linger_map_check(lreq);
>  	unlink_linger(lreq->osd, lreq);
> @@ -4657,43 +4678,6 @@ void ceph_osdc_sync(struct ceph_osd_client *osdc)
>  }
>  EXPORT_SYMBOL(ceph_osdc_sync);
> =20
> -static struct ceph_osd_request *
> -alloc_linger_request(struct ceph_osd_linger_request *lreq)
> -{
> -	struct ceph_osd_request *req;
> -
> -	req =3D ceph_osdc_alloc_request(lreq->osdc, NULL, 1, false, GFP_NOIO);
> -	if (!req)
> -		return NULL;
> -
> -	ceph_oid_copy(&req->r_base_oid, &lreq->t.base_oid);
> -	ceph_oloc_copy(&req->r_base_oloc, &lreq->t.base_oloc);
> -	return req;
> -}
> -
> -static struct ceph_osd_request *
> -alloc_watch_request(struct ceph_osd_linger_request *lreq, u8 watch_opcod=
e)
> -{
> -	struct ceph_osd_request *req;
> -
> -	req =3D alloc_linger_request(lreq);
> -	if (!req)
> -		return NULL;
> -
> -	/*
> -	 * Pass 0 for cookie because we don't know it yet, it will be
> -	 * filled in by linger_submit().
> -	 */
> -	osd_req_op_watch_init(req, 0, 0, watch_opcode);
> -
> -	if (ceph_osdc_alloc_messages(req, GFP_NOIO)) {
> -		ceph_osdc_put_request(req);
> -		return NULL;
> -	}
> -
> -	return req;
> -}
> -
>  /*
>   * Returns a handle, caller owns a ref.
>   */
> @@ -4723,18 +4707,6 @@ ceph_osdc_watch(struct ceph_osd_client *osdc,
>  	lreq->t.flags =3D CEPH_OSD_FLAG_WRITE;
>  	ktime_get_real_ts64(&lreq->mtime);
> =20
> -	lreq->reg_req =3D alloc_watch_request(lreq, CEPH_OSD_WATCH_OP_WATCH);
> -	if (!lreq->reg_req) {
> -		ret =3D -ENOMEM;
> -		goto err_put_lreq;
> -	}
> -
> -	lreq->ping_req =3D alloc_watch_request(lreq, CEPH_OSD_WATCH_OP_PING);
> -	if (!lreq->ping_req) {
> -		ret =3D -ENOMEM;
> -		goto err_put_lreq;
> -	}
> -
>  	linger_submit(lreq);
>  	ret =3D linger_reg_commit_wait(lreq);
>  	if (ret) {
> @@ -4772,8 +4744,8 @@ int ceph_osdc_unwatch(struct ceph_osd_client *osdc,
>  	ceph_oloc_copy(&req->r_base_oloc, &lreq->t.base_oloc);
>  	req->r_flags =3D CEPH_OSD_FLAG_WRITE;
>  	ktime_get_real_ts64(&req->r_mtime);
> -	osd_req_op_watch_init(req, 0, lreq->linger_id,
> -			      CEPH_OSD_WATCH_OP_UNWATCH);
> +	osd_req_op_watch_init(req, 0, CEPH_OSD_WATCH_OP_UNWATCH,
> +			      lreq->linger_id, 0);
> =20
>  	ret =3D ceph_osdc_alloc_messages(req, GFP_NOIO);
>  	if (ret)
> @@ -4859,35 +4831,6 @@ int ceph_osdc_notify_ack(struct ceph_osd_client *o=
sdc,
>  }
>  EXPORT_SYMBOL(ceph_osdc_notify_ack);
> =20
> -static int osd_req_op_notify_init(struct ceph_osd_request *req, int whic=
h,
> -				  u64 cookie, u32 prot_ver, u32 timeout,
> -				  void *payload, u32 payload_len)
> -{
> -	struct ceph_osd_req_op *op;
> -	struct ceph_pagelist *pl;
> -	int ret;
> -
> -	op =3D osd_req_op_init(req, which, CEPH_OSD_OP_NOTIFY, 0);
> -	op->notify.cookie =3D cookie;
> -
> -	pl =3D ceph_pagelist_alloc(GFP_NOIO);
> -	if (!pl)
> -		return -ENOMEM;
> -
> -	ret =3D ceph_pagelist_encode_32(pl, 1); /* prot_ver */
> -	ret |=3D ceph_pagelist_encode_32(pl, timeout);
> -	ret |=3D ceph_pagelist_encode_32(pl, payload_len);
> -	ret |=3D ceph_pagelist_append(pl, payload, payload_len);
> -	if (ret) {
> -		ceph_pagelist_release(pl);
> -		return -ENOMEM;
> -	}
> -
> -	ceph_osd_data_pagelist_init(&op->notify.request_data, pl);
> -	op->indata_len =3D pl->length;
> -	return 0;
> -}
> -
>  /*
>   * @timeout: in seconds
>   *
> @@ -4906,7 +4849,6 @@ int ceph_osdc_notify(struct ceph_osd_client *osdc,
>  		     size_t *preply_len)
>  {
>  	struct ceph_osd_linger_request *lreq;
> -	struct page **pages;
>  	int ret;
> =20
>  	WARN_ON(!timeout);
> @@ -4919,41 +4861,35 @@ int ceph_osdc_notify(struct ceph_osd_client *osdc=
,
>  	if (!lreq)
>  		return -ENOMEM;
> =20
> -	lreq->preply_pages =3D preply_pages;
> -	lreq->preply_len =3D preply_len;
> -
> -	ceph_oid_copy(&lreq->t.base_oid, oid);
> -	ceph_oloc_copy(&lreq->t.base_oloc, oloc);
> -	lreq->t.flags =3D CEPH_OSD_FLAG_READ;
> -
> -	lreq->reg_req =3D alloc_linger_request(lreq);
> -	if (!lreq->reg_req) {
> +	lreq->request_pl =3D ceph_pagelist_alloc(GFP_NOIO);
> +	if (!lreq->request_pl) {
>  		ret =3D -ENOMEM;
>  		goto out_put_lreq;
>  	}
> =20
> -	/*
> -	 * Pass 0 for cookie because we don't know it yet, it will be
> -	 * filled in by linger_submit().
> -	 */
> -	ret =3D osd_req_op_notify_init(lreq->reg_req, 0, 0, 1, timeout,
> -				     payload, payload_len);
> -	if (ret)
> +	ret =3D ceph_pagelist_encode_32(lreq->request_pl, 1); /* prot_ver */
> +	ret |=3D ceph_pagelist_encode_32(lreq->request_pl, timeout);
> +	ret |=3D ceph_pagelist_encode_32(lreq->request_pl, payload_len);
> +	ret |=3D ceph_pagelist_append(lreq->request_pl, payload, payload_len);
> +	if (ret) {
> +		ret =3D -ENOMEM;
>  		goto out_put_lreq;
> +	}
> =20
>  	/* for notify_id */
> -	pages =3D ceph_alloc_page_vector(1, GFP_NOIO);
> -	if (IS_ERR(pages)) {
> -		ret =3D PTR_ERR(pages);
> +	lreq->notify_id_pages =3D ceph_alloc_page_vector(1, GFP_NOIO);
> +	if (IS_ERR(lreq->notify_id_pages)) {
> +		ret =3D PTR_ERR(lreq->notify_id_pages);
> +		lreq->notify_id_pages =3D NULL;
>  		goto out_put_lreq;
>  	}
> -	ceph_osd_data_pages_init(osd_req_op_data(lreq->reg_req, 0, notify,
> -						 response_data),
> -				 pages, PAGE_SIZE, 0, false, true);
> =20
> -	ret =3D ceph_osdc_alloc_messages(lreq->reg_req, GFP_NOIO);
> -	if (ret)
> -		goto out_put_lreq;
> +	lreq->preply_pages =3D preply_pages;
> +	lreq->preply_len =3D preply_len;
> +
> +	ceph_oid_copy(&lreq->t.base_oid, oid);
> +	ceph_oloc_copy(&lreq->t.base_oloc, oloc);
> +	lreq->t.flags =3D CEPH_OSD_FLAG_READ;
> =20
>  	linger_submit(lreq);
>  	ret =3D linger_reg_commit_wait(lreq);

This looks like a fairly straightforward change overall, but I don't
think I have enough understanding of what linger requests actually are
to do a proper review.

Acked-by: Jeff Layton <jlayton@kernel.org>
