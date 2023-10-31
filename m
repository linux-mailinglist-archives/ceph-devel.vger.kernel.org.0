Return-Path: <ceph-devel+bounces-23-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 925337DCA96
	for <lists+ceph-devel@lfdr.de>; Tue, 31 Oct 2023 11:18:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4C3C9281443
	for <lists+ceph-devel@lfdr.de>; Tue, 31 Oct 2023 10:18:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 856EC134D1;
	Tue, 31 Oct 2023 10:17:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VF95+RVT"
X-Original-To: ceph-devel@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1598D20EE
	for <ceph-devel@vger.kernel.org>; Tue, 31 Oct 2023 10:17:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E546FC433C8;
	Tue, 31 Oct 2023 10:17:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1698747478;
	bh=ZyVs5n/JemyJQPuotDbEgcCW3M1ARc7JMOqYh6UFJJk=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
	b=VF95+RVTrsLEjFYPAxtxW/5XM2Q/KjiNjwX10r0PkuKlAYdP9d2brk1cCPROqYkGX
	 DGV6va+SCQbKO+qHDnbPSkdPqwzBV+VopbGZi5n9Q3ezw7pHoQh0X6LnLxHM1l8MJn
	 3aeSOSF7GfNjYnkVFikvsO8BBJAzoAFOeOrm685BAZK6W34YdmJ6vAjBktaMKNrJ3/
	 homnpf6WHC414S9tqAyNCcug/7eTWN3wG0L8WQuvS9vfk6fzfw1Fumd7CayFaCJcWU
	 PXi8eUdeKpa9oui9cyZ2pOyZp8q+nTyvgcpqwPnOpf+bJbVbSbpiwsZvArELr99Zhz
	 W9WJ91raOlNaw==
Message-ID: <13f48356b57fae1289776d2f4f84218a845e7c27.camel@kernel.org>
Subject: Re: [PATCH 1/3] libceph: do not decrease the data length more than
 once
From: Jeff Layton <jlayton@kernel.org>
To: Xiubo Li <xiubli@redhat.com>, ceph-devel@vger.kernel.org
Cc: idryomov@gmail.com, vshankar@redhat.com, mchangir@redhat.com
Date: Tue, 31 Oct 2023 06:17:56 -0400
In-Reply-To: <a333ae58-1133-1030-f4d2-007d6297fe55@redhat.com>
References: <20231024050039.231143-1-xiubli@redhat.com>
	 <20231024050039.231143-2-xiubli@redhat.com>
	 <832919f25c9f923e5f908d18a3581375d02342ef.camel@kernel.org>
	 <cc4eb9db0d65d324bb658ef4a40f6715653d75aa.camel@kernel.org>
	 <5562bc72-679c-46e8-1d6c-f31782479649@redhat.com>
	 <9ed3a4a7a481f1d40661a717d0f6110558b29f7f.camel@kernel.org>
	 <a333ae58-1133-1030-f4d2-007d6297fe55@redhat.com>
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.48.4 (3.48.4-1.fc38) 
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Tue, 2023-10-31 at 10:04 +0800, Xiubo Li wrote:
> On 10/31/23 08:23, Jeff Layton wrote:
> > On Tue, 2023-10-31 at 08:17 +0800, Xiubo Li wrote:
> > > On 10/30/23 20:30, Jeff Layton wrote:
> > > > On Mon, 2023-10-30 at 06:21 -0400, Jeff Layton wrote:
> > > > > On Tue, 2023-10-24 at 13:00 +0800, xiubli@redhat.com wrote:
> > > > > > From: Xiubo Li <xiubli@redhat.com>
> > > > > >=20
> > > > > > No need to decrease the data length again if we need to read th=
e
> > > > > > left data.
> > > > > >=20
> > > > > > URL: https://tracker.ceph.com/issues/62081
> > > > > > Signed-off-by: Xiubo Li <xiubli@redhat.com>
> > > > > > ---
> > > > > >    net/ceph/messenger_v2.c | 1 -
> > > > > >    1 file changed, 1 deletion(-)
> > > > > >=20
> > > > > > diff --git a/net/ceph/messenger_v2.c b/net/ceph/messenger_v2.c
> > > > > > index d09a39ff2cf0..9e3f95d5e425 100644
> > > > > > --- a/net/ceph/messenger_v2.c
> > > > > > +++ b/net/ceph/messenger_v2.c
> > > > > > @@ -1966,7 +1966,6 @@ static int prepare_sparse_read_cont(struc=
t ceph_connection *con)
> > > > > >    				bv.bv_offset =3D 0;
> > > > > >    			}
> > > > > >    			set_in_bvec(con, &bv);
> > > > > > -			con->v2.data_len_remain -=3D bv.bv_len;
> > > > > >    			return 0;
> > > > > >    		}
> > > > > >    	} else if (iov_iter_is_kvec(&con->v2.in_iter)) {
> > > > > It's been a while since I was in this code, but where does this g=
et
> > > > > decremented if you're removing it here?
> > > > >=20
> > > > My question was a bit vague, so let me elaborate a bit:
> > > >=20
> > > > data_len_remain should be how much unconsumed data is in the messag=
e
> > > > (IIRC). As we call prepare_sparse_read_cont multiple times, we're
> > > > consuming the message data and this gets decremented as we go.
> > > >=20
> > > > In the above case, we're consuming the message data into the bvec, =
so
> > > > why shouldn't we be decrementing the remaining data by that amount?
> > > Hi Jeff,
> > >=20
> > > If I didn't miss something about this. IMO we have already decreased =
it
> > > in the following two cases:
> > >=20
> > > [1]
> > > https://github.com/ceph/ceph-client/blob/for-linus/net/ceph/messenger=
_v2.c#L2000
> > >=20
> > > [2]
> > > https://github.com/ceph/ceph-client/blob/for-linus/net/ceph/messenger=
_v2.c#L2025
> > >=20
> > > And here won't we decrease them twice ?
> > >=20
> > >=20
> > I don't get it. The functions returns in both of those cases just after
> > decrementing data_len_remain, so how can it have already decremented it=
?
> >=20
> > Maybe I don't understand the bug you're trying to fix. data_len_remain
> > only comes into play when we need to revert. Does the problem involve a
> > trip through revoke_at_prepare_sparse_data()?
>=20
> Such as for the first time to read the data it will trigger:
>=20
> prepare_sparse_read_cont()
>=20
>  =A0 --> ret =3D con->ops->sparse_read()

>  =A0=A0=A0=A0=A0=A0 --> cursor->sr_resid =3D elen;
>=20
>=20
>  =A0 --> if (buf) {con->v2.data_len_remain -=3D ret;} =A0 // After callin=
g=20
> ->sparse_read() it will decrease 'ret', which is 'elen'.
>=20

> Then the msg will try to read data from the socket buffer, and if the=20
> data read is less than expected 'elen' then it will go to the code:
>=20
> https://github.com/ceph/ceph-client/blob/for-linus/net/ceph/messenger_v2.=
c#L1960-L1971
>=20
> And then won't it decrease 'data_len_remain' twice ?
>=20
> Did I misreading it the sparse read state machine ?
>=20


Here's the full snippet of code around that area. In this code, we've
just received the data from "in" iter into the current bvec and have
either copied it from the bounce buffer or done the CRC for the last
bvec. Now, we're advancing the iter by the amount we've just read, and
reducing the sr_resid value (which is the residual data in the  current
extent):

                ceph_msg_data_advance(cursor, con->v2.in_bvec.bv_len);
                cursor->sr_resid -=3D con->v2.in_bvec.bv_len;
                dout("%s: advance by 0x%x sr_resid 0x%x\n", __func__,
                     con->v2.in_bvec.bv_len, cursor->sr_resid);
                WARN_ON_ONCE(cursor->sr_resid > cursor->total_resid);
                if (cursor->sr_resid) {

There's still some more data in this extent? Set up the next bvec for
the next receive:

                        get_bvec_at(cursor, &bv);
                        if (bv.bv_len > cursor->sr_resid)
                                bv.bv_len =3D cursor->sr_resid;
                        if (ceph_test_opt(from_msgr(con->msgr), RXBOUNCE)) =
{
                                bv.bv_page =3D con->bounce_page;
                                bv.bv_offset =3D 0;
                        }
                        set_in_bvec(con, &bv);
                        con->v2.data_len_remain -=3D bv.bv_len;

...and reduce the data_len_remain for the amount of that next bvec.

                        return 0;
                }

So yeah, I think this is not being decremented twice. The code is
dealing with a different bvec at the point where data_len_remain is
reduced above and it looks correct to me.

What problem are you trying to solve with this patch?
--=20
Jeff Layton <jlayton@kernel.org>

