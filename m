Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA2534EBF66
	for <lists+ceph-devel@lfdr.de>; Wed, 30 Mar 2022 12:59:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245651AbiC3LBG (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 30 Mar 2022 07:01:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245677AbiC3LA5 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 30 Mar 2022 07:00:57 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2B9CDF70
        for <ceph-devel@vger.kernel.org>; Wed, 30 Mar 2022 03:59:11 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 8A2321F37B;
        Wed, 30 Mar 2022 10:59:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1648637950; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=38xLAYWecz3UWc4PH6WQF86uJD9bJ/Wvrz+EgjkYMc4=;
        b=Mfc8YlmA57mqMZhpkJge9JKHKTHypChBNUp1AssfwUshB+BNXsudTfUW/ZKzqaLdvuUAiK
        M0DgPb6B3SZUlqJK2aRn06PdtMmldLOM5Qvc8Q2IRzo9w4pjlUqHqZV57+P0HpMVEasOpD
        fP1djDiTO1tXQDgZB8tShXzMX9NCyzU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1648637950;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=38xLAYWecz3UWc4PH6WQF86uJD9bJ/Wvrz+EgjkYMc4=;
        b=DJeftvaEKSreenzNPi1WPRCIp/hOyJBWdYckpe+apPAvxarailnRBcKQpgSYmxhXSyBssd
        +nxt4nkwcq3j1sCw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 1A67813AF3;
        Wed, 30 Mar 2022 10:59:10 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id pUNKA/43RGLVCQAAMHmgww
        (envelope-from <lhenriques@suse.de>); Wed, 30 Mar 2022 10:59:10 +0000
Received: from localhost (brahms.olymp [local])
        by brahms.olymp (OpenSMTPD) with ESMTPA id 249a07b7;
        Wed, 30 Mar 2022 10:59:31 +0000 (UTC)
From:   =?utf-8?Q?Lu=C3=ADs_Henriques?= <lhenriques@suse.de>
To:     xiubli@redhat.com
Cc:     jlayton@kernel.org, idryomov@gmail.com, vshankar@redhat.com,
        gfarnum@redhat.com, ceph-devel@vger.kernel.org
Subject: Re: [PATCH v3] ceph: stop forwarding the request when exceeding 256
 times
References: <20220330012521.170962-1-xiubli@redhat.com>
Date:   Wed, 30 Mar 2022 11:59:31 +0100
In-Reply-To: <20220330012521.170962-1-xiubli@redhat.com> (xiubli@redhat.com's
        message of "Wed, 30 Mar 2022 09:25:21 +0800")
Message-ID: <874k3fr9ik.fsf@brahms.olymp>
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
>
> Signed-off-by: Xiubo Li <xiubli@redhat.com>
> ---
>
> V3:
> - avoid usig the hardcode of 256
>
> V2:
> - s/EIO/EMULTIHOP/
> - Fixed dereferencing NULL seq bug
> - Removed the out lable
>
>
>  fs/ceph/mds_client.c | 39 ++++++++++++++++++++++++++++++++++-----
>  1 file changed, 34 insertions(+), 5 deletions(-)
>
> diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
> index a89ee866ebbb..e11d31401f12 100644
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
> @@ -3301,16 +3302,41 @@ static void handle_forward(struct ceph_mds_client=
 *mdsc,
>  	mutex_lock(&mdsc->mutex);
>  	req =3D lookup_get_request(mdsc, tid);
>  	if (!req) {
> +		mutex_unlock(&mdsc->mutex);
>  		dout("forward tid %llu to mds%d - req dne\n", tid, next_mds);
> -		goto out;  /* dup reply? */
> +		return;  /* dup reply? */
>  	}
>=20=20
>  	if (test_bit(CEPH_MDS_R_ABORTED, &req->r_req_flags)) {
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
> +		 *
> +		 * In future this could be fixed in ceph code, so avoid
> +		 * using the hardcode here.
> +		 */
> +		int max =3D sizeof_field(struct ceph_mds_request_head, num_fwd);
> +		max =3D 1 << (max * BITS_PER_BYTE);
> +		if (req->r_num_fwd >=3D max) {
> +			mutex_lock(&req->r_fill_mutex);
> +			req->r_err =3D -EMULTIHOP;
> +			set_bit(CEPH_MDS_R_ABORTED, &req->r_req_flags);
> +			mutex_unlock(&req->r_fill_mutex);
> +			aborted =3D true;
> +			pr_warn_ratelimited("forward tid %llu seq overflow\n",
> +					    tid);
> +		} else {
> +			dout("forward tid %llu to mds%d - old seq %d <=3D %d\n",
> +			     tid, next_mds, req->r_num_fwd, fwd_seq);
> +		}
>  	} else {
>  		/* resend. forward race not possible; mds would drop */
>  		dout("forward tid %llu to mds%d (we resend)\n", tid, next_mds);
> @@ -3322,9 +3348,12 @@ static void handle_forward(struct ceph_mds_client =
*mdsc,
>  		put_request_session(req);
>  		__do_request(mdsc, req);
>  	}
> -	ceph_mdsc_put_request(req);
> -out:
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

Yeah, looks good to me.  Thanks.

Reviewed-by: Lu=C3=ADs Henriques <lhenriques@suse.de>

Cheers,
--=20
Lu=C3=ADs
