Return-Path: <ceph-devel+bounces-21-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 219E97DC38C
	for <lists+ceph-devel@lfdr.de>; Tue, 31 Oct 2023 01:23:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CE6032814DD
	for <lists+ceph-devel@lfdr.de>; Tue, 31 Oct 2023 00:23:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8F6F4365;
	Tue, 31 Oct 2023 00:23:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="R+aCQUCV"
X-Original-To: ceph-devel@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27989A28
	for <ceph-devel@vger.kernel.org>; Tue, 31 Oct 2023 00:23:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0338CC433C8;
	Tue, 31 Oct 2023 00:23:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1698711827;
	bh=kPiGLFEGjXybfuwBjaBJrBo1hXGpErQE1HLk1VMf+Wk=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
	b=R+aCQUCVPLSQG47OViWlKeu4JHEHZG1u1FCtH1NLKCl866xZl4ed+HM7ufo1JOABc
	 4/Qac8hwABjkjvskVCTxxOGKcRRd4ai9g9Zszj+eoJY1ZO59KjicXNrbG8AG8Wy7lx
	 rrVXTKoJZ+ISMag06biFa/wJoqpeTZXL4OggK+Fl9QteysaL/LIxppDgwe/NUHWQWB
	 2Uaht2C37iDBN4dmaswCJcS6W2N18ShW+dYipcY/1dUMKBV6vb/ZD2vM2FTSVT4z3z
	 2636ea2Y/GWSUOdcA+vx74XTPQjc39on92ZiklQwIFFFcDx0h0t4JvMl6DV9cjAqwC
	 BAd3EE0X67cTA==
Message-ID: <9ed3a4a7a481f1d40661a717d0f6110558b29f7f.camel@kernel.org>
Subject: Re: [PATCH 1/3] libceph: do not decrease the data length more than
 once
From: Jeff Layton <jlayton@kernel.org>
To: Xiubo Li <xiubli@redhat.com>, ceph-devel@vger.kernel.org
Cc: idryomov@gmail.com, vshankar@redhat.com, mchangir@redhat.com
Date: Mon, 30 Oct 2023 20:23:45 -0400
In-Reply-To: <5562bc72-679c-46e8-1d6c-f31782479649@redhat.com>
References: <20231024050039.231143-1-xiubli@redhat.com>
	 <20231024050039.231143-2-xiubli@redhat.com>
	 <832919f25c9f923e5f908d18a3581375d02342ef.camel@kernel.org>
	 <cc4eb9db0d65d324bb658ef4a40f6715653d75aa.camel@kernel.org>
	 <5562bc72-679c-46e8-1d6c-f31782479649@redhat.com>
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.48.4 (3.48.4-1.fc38) 
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Tue, 2023-10-31 at 08:17 +0800, Xiubo Li wrote:
> On 10/30/23 20:30, Jeff Layton wrote:
> > On Mon, 2023-10-30 at 06:21 -0400, Jeff Layton wrote:
> > > On Tue, 2023-10-24 at 13:00 +0800, xiubli@redhat.com wrote:
> > > > From: Xiubo Li <xiubli@redhat.com>
> > > >=20
> > > > No need to decrease the data length again if we need to read the
> > > > left data.
> > > >=20
> > > > URL: https://tracker.ceph.com/issues/62081
> > > > Signed-off-by: Xiubo Li <xiubli@redhat.com>
> > > > ---
> > > >   net/ceph/messenger_v2.c | 1 -
> > > >   1 file changed, 1 deletion(-)
> > > >=20
> > > > diff --git a/net/ceph/messenger_v2.c b/net/ceph/messenger_v2.c
> > > > index d09a39ff2cf0..9e3f95d5e425 100644
> > > > --- a/net/ceph/messenger_v2.c
> > > > +++ b/net/ceph/messenger_v2.c
> > > > @@ -1966,7 +1966,6 @@ static int prepare_sparse_read_cont(struct ce=
ph_connection *con)
> > > >   				bv.bv_offset =3D 0;
> > > >   			}
> > > >   			set_in_bvec(con, &bv);
> > > > -			con->v2.data_len_remain -=3D bv.bv_len;
> > > >   			return 0;
> > > >   		}
> > > >   	} else if (iov_iter_is_kvec(&con->v2.in_iter)) {
> > > It's been a while since I was in this code, but where does this get
> > > decremented if you're removing it here?
> > >=20
> > My question was a bit vague, so let me elaborate a bit:
> >=20
> > data_len_remain should be how much unconsumed data is in the message
> > (IIRC). As we call prepare_sparse_read_cont multiple times, we're
> > consuming the message data and this gets decremented as we go.
> >=20
> > In the above case, we're consuming the message data into the bvec, so
> > why shouldn't we be decrementing the remaining data by that amount?
>=20
> Hi Jeff,
>=20
> If I didn't miss something about this. IMO we have already decreased it=
=20
> in the following two cases:
>=20
> [1]=20
> https://github.com/ceph/ceph-client/blob/for-linus/net/ceph/messenger_v2.=
c#L2000
>=20
> [2]=20
> https://github.com/ceph/ceph-client/blob/for-linus/net/ceph/messenger_v2.=
c#L2025
>=20
> And here won't we decrease them twice ?
>=20
>=20

I don't get it. The functions returns in both of those cases just after
decrementing data_len_remain, so how can it have already decremented it?

Maybe I don't understand the bug you're trying to fix. data_len_remain
only comes into play when we need to revert. Does the problem involve a
trip through revoke_at_prepare_sparse_data()?
--=20
Jeff Layton <jlayton@kernel.org>

