Return-Path: <ceph-devel+bounces-15-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id AE2357DB7D8
	for <lists+ceph-devel@lfdr.de>; Mon, 30 Oct 2023 11:21:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 4F774B20CE6
	for <lists+ceph-devel@lfdr.de>; Mon, 30 Oct 2023 10:21:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A316911196;
	Mon, 30 Oct 2023 10:21:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="a9DBozX4"
X-Original-To: ceph-devel@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B01C1078E
	for <ceph-devel@vger.kernel.org>; Mon, 30 Oct 2023 10:21:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A635C433C7;
	Mon, 30 Oct 2023 10:21:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1698661281;
	bh=t2yoV4g9BBWStuiUaUjnftbOuAO5HfC6tfbpGD6h4F4=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
	b=a9DBozX4NBCBNUwW31cEUaAr0TuEKI2DTHCKhFqEXPVO9vk3Xm3HGocAsHOAnQ7tu
	 YheVVVAR3VQLYNgQ41gRJcXkYF6y2kERw8JN250WQYowrPGPUX442Hlhc+JjKkkBBt
	 XiOxHkJuWlnnAzYkKvsDXu7qSqcuc7dMvSo47pusCp5BawTk6mpuEGqjHLBmL3naOW
	 gYG2EhDvcS7Z/44fd0YrZyqBT3H6bBeWlkRG3EpRuxYYCApYTcEGW1qMUaMuRwxzpy
	 63DC4PJbffrD0LEhJ9s2hHs9DfDUejwpKiWRj3gUxPqjwH8pKy8QYpKR0r7BfWEQ12
	 rsGcHKXOsUnKg==
Message-ID: <832919f25c9f923e5f908d18a3581375d02342ef.camel@kernel.org>
Subject: Re: [PATCH 1/3] libceph: do not decrease the data length more than
 once
From: Jeff Layton <jlayton@kernel.org>
To: xiubli@redhat.com, ceph-devel@vger.kernel.org
Cc: idryomov@gmail.com, vshankar@redhat.com, mchangir@redhat.com
Date: Mon, 30 Oct 2023 06:21:19 -0400
In-Reply-To: <20231024050039.231143-2-xiubli@redhat.com>
References: <20231024050039.231143-1-xiubli@redhat.com>
	 <20231024050039.231143-2-xiubli@redhat.com>
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.48.4 (3.48.4-1.fc38) 
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Tue, 2023-10-24 at 13:00 +0800, xiubli@redhat.com wrote:
> From: Xiubo Li <xiubli@redhat.com>
>=20
> No need to decrease the data length again if we need to read the
> left data.
>=20
> URL: https://tracker.ceph.com/issues/62081
> Signed-off-by: Xiubo Li <xiubli@redhat.com>
> ---
>  net/ceph/messenger_v2.c | 1 -
>  1 file changed, 1 deletion(-)
>=20
> diff --git a/net/ceph/messenger_v2.c b/net/ceph/messenger_v2.c
> index d09a39ff2cf0..9e3f95d5e425 100644
> --- a/net/ceph/messenger_v2.c
> +++ b/net/ceph/messenger_v2.c
> @@ -1966,7 +1966,6 @@ static int prepare_sparse_read_cont(struct ceph_con=
nection *con)
>  				bv.bv_offset =3D 0;
>  			}
>  			set_in_bvec(con, &bv);
> -			con->v2.data_len_remain -=3D bv.bv_len;
>  			return 0;
>  		}
>  	} else if (iov_iter_is_kvec(&con->v2.in_iter)) {

It's been a while since I was in this code, but where does this get
decremented if you're removing it here?

Thanks,
--=20
Jeff Layton <jlayton@kernel.org>

