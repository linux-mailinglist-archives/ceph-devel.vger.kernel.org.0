Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 65FD56671C8
	for <lists+ceph-devel@lfdr.de>; Thu, 12 Jan 2023 13:13:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232269AbjALMM7 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 12 Jan 2023 07:12:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232268AbjALMM3 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 12 Jan 2023 07:12:29 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0885FBE06
        for <ceph-devel@vger.kernel.org>; Thu, 12 Jan 2023 04:09:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A659DB81E10
        for <ceph-devel@vger.kernel.org>; Thu, 12 Jan 2023 12:09:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C25D9C433EF;
        Thu, 12 Jan 2023 12:09:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673525355;
        bh=xtbtKkGSnjRq2MOcg/Vokqx0ZyzeEgCIKepbMDDjG/8=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=JbZ0UIc5Nx8jw+TNsYNTDX00sFNZ92p32R4RjFC9kbHOcX3WfK4MskmFtDmLuz1B3
         ABTJoDGT+951sWF83jZFQAKSBp7EW41qjdY9C/brKIjPV/MCBBJGtCA5NCcBNTapbr
         XQzsz30QVxRWsBTeJIoLFS1K6NSt9k1dGrKQaU/ayNBhCOr34bp0wpySVlvRh4HtcB
         qfg+Rn0K82GhNOPeBtbkq535urkKz8CRtJnd6HvuC1twVMAcMzUdcyXIwJ2dFITXhs
         FGhRyMRJ6mmk8+d8faL6Np0ikwewMAeamBkh0+Lj7DDhCiV38ghjz4va/L8Z2Z8EOC
         JorNNJM0fSV0A==
Message-ID: <18fb6b6426b7a18cd4245e12ac8709c646a81871.camel@kernel.org>
Subject: Re: [PATCH] ceph: fix double free for req when failing to allocate
 sparse ext map
From:   Jeff Layton <jlayton@kernel.org>
To:     xiubli@redhat.com, idryomov@gmail.com, ceph-devel@vger.kernel.org
Cc:     mchangir@redhat.com, vshankar@redhat.com
Date:   Thu, 12 Jan 2023 07:09:13 -0500
In-Reply-To: <20230111011403.570964-1-xiubli@redhat.com>
References: <20230111011403.570964-1-xiubli@redhat.com>
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.3 (3.46.3-1.fc37) 
MIME-Version: 1.0
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Wed, 2023-01-11 at 09:14 +0800, xiubli@redhat.com wrote:
> From: Xiubo Li <xiubli@redhat.com>
>=20
> Introduced by commit d1f436736924 ("ceph: add new mount option to enable
> sparse reads") and will fold this into the above commit since it's
> still in the testing branch.
>=20
> Reported-by: Ilya Dryomov <idryomov@gmail.com>
> Signed-off-by: Xiubo Li <xiubli@redhat.com>
> ---
>  fs/ceph/addr.c | 4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)
>=20
> diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
> index 17758cb607ec..3561c95d7e23 100644
> --- a/fs/ceph/addr.c
> +++ b/fs/ceph/addr.c
> @@ -351,10 +351,8 @@ static void ceph_netfs_issue_read(struct netfs_io_su=
brequest *subreq)
> =20
>  	if (sparse) {
>  		err =3D ceph_alloc_sparse_ext_map(&req->r_ops[0]);
> -		if (err) {
> -			ceph_osdc_put_request(req);
> +		if (err)
>  			goto out;
> -		}
>  	}
> =20
>  	dout("%s: pos=3D%llu orig_len=3D%zu len=3D%llu\n", __func__, subreq->st=
art, subreq->len, len);

Looks right.

Reviewed-by: Jeff Layton <jlayton@kernel.org>
