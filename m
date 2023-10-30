Return-Path: <ceph-devel+bounces-19-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CA6EE7DB9EE
	for <lists+ceph-devel@lfdr.de>; Mon, 30 Oct 2023 13:30:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id C8BE8B20CD7
	for <lists+ceph-devel@lfdr.de>; Mon, 30 Oct 2023 12:30:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C8AE715E96;
	Mon, 30 Oct 2023 12:30:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MYaTarHF"
X-Original-To: ceph-devel@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 457E415EA6
	for <ceph-devel@vger.kernel.org>; Mon, 30 Oct 2023 12:30:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 356DCC433C7;
	Mon, 30 Oct 2023 12:30:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1698669037;
	bh=tyd1jVHKW7qANZr6A1niky9YqK2sWbmLNLOySEGhz9w=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
	b=MYaTarHFaevjdtoMUEb6w3uKc6KLXTDkW2DMsQoWGzPZqVoWy/p7JRhmvQBI+U/Co
	 B3elP4Cral+0q3gJNe54N1Ox34BS0HoQ6JwgiB1TKhrfAucpvb6yXIvYrSP1MF9VaU
	 c4pNEHXvd7uwlDilqtimEc+F5LAd1VktPwL6xtoTp33ZgbenGlOI9I7aIUKdg3Uq5F
	 NEjQ6j10O4Yy8AX7Q44H+LTOuFEFMo8n7UbgWVn/hhYiZAiSh9giNSDeZuOl6tS4LR
	 mdrskJ6+2MUvMgNrS/aml5WsYPvAwP9fzMVzaQ5CbqqPeYIRfmpy45EKzGW99dAMOF
	 ehhJGpKbwQIhw==
Message-ID: <cc4eb9db0d65d324bb658ef4a40f6715653d75aa.camel@kernel.org>
Subject: Re: [PATCH 1/3] libceph: do not decrease the data length more than
 once
From: Jeff Layton <jlayton@kernel.org>
To: xiubli@redhat.com, ceph-devel@vger.kernel.org
Cc: idryomov@gmail.com, vshankar@redhat.com, mchangir@redhat.com
Date: Mon, 30 Oct 2023 08:30:35 -0400
In-Reply-To: <832919f25c9f923e5f908d18a3581375d02342ef.camel@kernel.org>
References: <20231024050039.231143-1-xiubli@redhat.com>
	 <20231024050039.231143-2-xiubli@redhat.com>
	 <832919f25c9f923e5f908d18a3581375d02342ef.camel@kernel.org>
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.48.4 (3.48.4-1.fc38) 
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Mon, 2023-10-30 at 06:21 -0400, Jeff Layton wrote:
> On Tue, 2023-10-24 at 13:00 +0800, xiubli@redhat.com wrote:
> > From: Xiubo Li <xiubli@redhat.com>
> >=20
> > No need to decrease the data length again if we need to read the
> > left data.
> >=20
> > URL: https://tracker.ceph.com/issues/62081
> > Signed-off-by: Xiubo Li <xiubli@redhat.com>
> > ---
> >  net/ceph/messenger_v2.c | 1 -
> >  1 file changed, 1 deletion(-)
> >=20
> > diff --git a/net/ceph/messenger_v2.c b/net/ceph/messenger_v2.c
> > index d09a39ff2cf0..9e3f95d5e425 100644
> > --- a/net/ceph/messenger_v2.c
> > +++ b/net/ceph/messenger_v2.c
> > @@ -1966,7 +1966,6 @@ static int prepare_sparse_read_cont(struct ceph_c=
onnection *con)
> >  				bv.bv_offset =3D 0;
> >  			}
> >  			set_in_bvec(con, &bv);
> > -			con->v2.data_len_remain -=3D bv.bv_len;
> >  			return 0;
> >  		}
> >  	} else if (iov_iter_is_kvec(&con->v2.in_iter)) {
>=20
> It's been a while since I was in this code, but where does this get
> decremented if you're removing it here?
>=20

My question was a bit vague, so let me elaborate a bit:

data_len_remain should be how much unconsumed data is in the message
(IIRC). As we call prepare_sparse_read_cont multiple times, we're
consuming the message data and this gets decremented as we go.

In the above case, we're consuming the message data into the bvec, so
why shouldn't we be decrementing the remaining data by that amount?=20
--=20
Jeff Layton <jlayton@kernel.org>

