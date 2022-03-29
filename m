Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 51D894EAAC3
	for <lists+ceph-devel@lfdr.de>; Tue, 29 Mar 2022 11:53:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234850AbiC2JzM (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 29 Mar 2022 05:55:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231397AbiC2JzJ (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 29 Mar 2022 05:55:09 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C1A212097
        for <ceph-devel@vger.kernel.org>; Tue, 29 Mar 2022 02:53:26 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 13E1321115;
        Tue, 29 Mar 2022 09:53:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1648547605; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=7kYpNKi8jXXMTPr//ADphAAsvbmHK7h5JUfszSnvFAQ=;
        b=yX/eKy+grv+NywC/LEvVDkFThTkMZK1CwfN6k+ioj7SIVkyXwwlLkkHOofVRGV4jkB0mkO
        50uKCU9eGG25SU+rrhd5oVankrj17ky+CC6qCJkZJ6Up0QfrXy1tq9ligZn7YF41J+JIRz
        HuGQltWpMScu+uoSBmTTnH6rS7ufJ5Q=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1648547605;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=7kYpNKi8jXXMTPr//ADphAAsvbmHK7h5JUfszSnvFAQ=;
        b=V/XzJl7Rrguyo1XTggtSeOhJWJDE+3SY+8FQ1BMudqNkt/hNtPJh+gN9BQhO5qYH/cZHua
        vqJ24qelrq87PABg==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id A6C6513A7E;
        Tue, 29 Mar 2022 09:53:24 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id bYZjJRTXQmKIVAAAMHmgww
        (envelope-from <lhenriques@suse.de>); Tue, 29 Mar 2022 09:53:24 +0000
Received: from localhost (brahms.olymp [local])
        by brahms.olymp (OpenSMTPD) with ESMTPA id 6e6d671e;
        Tue, 29 Mar 2022 09:53:46 +0000 (UTC)
From:   =?utf-8?Q?Lu=C3=ADs_Henriques?= <lhenriques@suse.de>
To:     xiubli@redhat.com
Cc:     jlayton@kernel.org, idryomov@gmail.com, vshankar@redhat.com,
        gfarnum@redhat.com, ceph-devel@vger.kernel.org
Subject: Re: [PATCH] ceph: stop forwarding the request when exceeding 256 times
References: <20220329080608.14667-1-xiubli@redhat.com>
Date:   Tue, 29 Mar 2022 10:53:46 +0100
In-Reply-To: <20220329080608.14667-1-xiubli@redhat.com> (xiubli@redhat.com's
        message of "Tue, 29 Mar 2022 16:06:08 +0800")
Message-ID: <87fsn1qe39.fsf@brahms.olymp>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

xiubli@redhat.com writes:

> From: Xiubo Li <xiubli@redhat.com>
>
> The type of 'num_fwd' in ceph 'MClientRequestForward' is 'int32_t',
> while in 'ceph_mds_request_head' the type is '__u8'. So in case
> the request bounces between MDSes exceeding 256 times, the client
> will get stuck.
>
> In this case it's ususally a bug in MDS and continue bouncing the
> request makes no sense.

Ouch.  Nice catch.  This patch looks OK to me, just 2 minor comments
bellow.

> Signed-off-by: Xiubo Li <xiubli@redhat.com>
> ---
>  fs/ceph/mds_client.c | 31 ++++++++++++++++++++++++++++---
>  1 file changed, 28 insertions(+), 3 deletions(-)
>
> diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
> index a89ee866ebbb..0bb6e7bc499c 100644
> --- a/fs/ceph/mds_client.c
> +++ b/fs/ceph/mds_client.c
> @@ -3293,6 +3293,7 @@ static void handle_forward(struct ceph_mds_client *=
mdsc,
>  	int err =3D -EINVAL;
>  	void *p =3D msg->front.iov_base;
>  	void *end =3D p + msg->front.iov_len;
> +	bool aborted =3D false;
>=20=20
>  	ceph_decode_need(&p, end, 2*sizeof(u32), bad);
>  	next_mds =3D ceph_decode_32(&p);
> @@ -3309,8 +3310,28 @@ static void handle_forward(struct ceph_mds_client =
*mdsc,
>  		dout("forward tid %llu aborted, unregistering\n", tid);
>  		__unregister_request(mdsc, req);
>  	} else if (fwd_seq <=3D req->r_num_fwd) {
> -		dout("forward tid %llu to mds%d - old seq %d <=3D %d\n",
> -		     tid, next_mds, req->r_num_fwd, fwd_seq);
> +		/*
> +		 * The type of 'num_fwd' in ceph 'MClientRequestForward'
> +		 * is 'int32_t', while in 'ceph_mds_request_head' the
> +		 * type is '__u8'. So in case the request bounces between
> +		 * MDSes exceeding 256 times, the client will get stuck.
> +		 *
> +		 * In this case it's ususally a bug in MDS and continue
> +		 * bouncing the request makes no sense.
> +		 */
> +		if (req->r_num_fwd =3D=3D 256) {
> +			mutex_lock(&req->r_fill_mutex);
> +			req->r_err =3D -EIO;

Not sure -EIO is the most appropriate.  Maybe -E2BIG... although not quite
it either.

> +			set_bit(CEPH_MDS_R_ABORTED, &req->r_req_flags);
> +			mutex_unlock(&req->r_fill_mutex);
> +			aborted =3D true;
> +			dout("forward tid %llu to mds%d - seq overflowed %d <=3D %d\n",
> +			     tid, next_mds, req->r_num_fwd, fwd_seq);
> +			goto out;

This 'goto' statement can be dropped, but one before (when the
lookup_get_request() fails) needs to be adjusted, otherwise
ceph_mdsc_put_request() may be called with a NULL pointer.

Cheers,
--=20
Lu=C3=ADs

> +		} else {
> +			dout("forward tid %llu to mds%d - old seq %d <=3D %d\n",
> +			     tid, next_mds, req->r_num_fwd, fwd_seq);
> +		}
>  	} else {
>  		/* resend. forward race not possible; mds would drop */
>  		dout("forward tid %llu to mds%d (we resend)\n", tid, next_mds);
> @@ -3322,9 +3343,13 @@ static void handle_forward(struct ceph_mds_client =
*mdsc,
>  		put_request_session(req);
>  		__do_request(mdsc, req);
>  	}
> -	ceph_mdsc_put_request(req);
>  out:
>  	mutex_unlock(&mdsc->mutex);
> +
> +	/* kick calling process */
> +	if (aborted)
> +		complete_request(mdsc, req);
> +	ceph_mdsc_put_request(req);
>  	return;
>=20=20
>  bad:
> --=20
>
> 2.27.0
>

