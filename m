Return-Path: <ceph-devel+bounces-283-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A4D61811454
	for <lists+ceph-devel@lfdr.de>; Wed, 13 Dec 2023 15:11:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id DA240B20E7D
	for <lists+ceph-devel@lfdr.de>; Wed, 13 Dec 2023 14:11:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6F6672E82F;
	Wed, 13 Dec 2023 14:11:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cgets07O"
X-Original-To: ceph-devel@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A90D28DD6
	for <ceph-devel@vger.kernel.org>; Wed, 13 Dec 2023 14:11:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06B03C433C7;
	Wed, 13 Dec 2023 14:11:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1702476681;
	bh=BIUIUQ+4G0YX4LqLP+6gRDA+COp3ZDIA2QLxK71rwHI=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
	b=cgets07OY23VBqRmfJFffu3E02PNBgapK4CcZtVKDKkkZgXsdN/YZDv5RNs0nOxf7
	 KDZPOaqFnavMot+Ib7Wm/oVgvXdv46sECse5/C2FfAuP0ESiDUX5n9J/drMKIRjnHz
	 N/Y4Sh1CNSKmMaSPZo319jjkJJCmpZ0xn9stADm4RCLjKu9shDSeRp6xzfUDe9lmz9
	 kLHYQdziPe0MBLASOkl/8MihvQIwxh4BWE8EEQDOPUutSlTdXKv1OWkAPogrk6G9kY
	 NlsZ1Yl/9+pqtBt6qJ0J8h6uLfG066juJDr1xoGDMf5FOJCz3ivWtGolRT9MOp2q6o
	 mUKNXYLoDWMvg==
Message-ID: <a4ece4d4aedfc80a5b9b3d73b1ee9360c34be777.camel@kernel.org>
Subject: Re: [PATCH v2 2/2] libceph: just wait for more data to be available
 on the socket
From: Jeff Layton <jlayton@kernel.org>
To: Ilya Dryomov <idryomov@gmail.com>, Xiubo Li <xiubli@redhat.com>
Cc: ceph-devel@vger.kernel.org, vshankar@redhat.com, mchangir@redhat.com
Date: Wed, 13 Dec 2023 09:11:19 -0500
In-Reply-To: <CAOi1vP-NLswzoSFjctyJdXW2qHetLPn89pLeHtiP=tQeGBXvfg@mail.gmail.com>
References: <20231208160601.124892-1-xiubli@redhat.com>
	 <20231208160601.124892-3-xiubli@redhat.com>
	 <CAOi1vP8ft0nFh2qdQDRpGr7gPCj3HHDzY4Q7i69WQLiASPxNyw@mail.gmail.com>
	 <af3d24bc-0a4f-4e30-ba3d-80d41a7fd94c@redhat.com>
	 <CAOi1vP9EzGZM=U1jDzAnTwFvWD6fpZ+qMedgOQuK79qOodU+NQ@mail.gmail.com>
	 <008fe687-9df0-45d2-929c-168a10222b2f@redhat.com>
	 <CAOi1vP9yYkv+cxazfwbrKD0g2LcS9Pa0PLF33kAf4uKvDXgoLQ@mail.gmail.com>
	 <9115452a-0ca0-4760-9407-bcc3146134ff@redhat.com>
	 <CAOi1vP-NLswzoSFjctyJdXW2qHetLPn89pLeHtiP=tQeGBXvfg@mail.gmail.com>
Autocrypt: addr=jlayton@kernel.org; prefer-encrypt=mutual;
 keydata=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
	kZWuOsJdJQdmwlWC5L5ln9xgfr/4mOY38B0U=
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.50.2 (3.50.2-1.fc39) 
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Wed, 2023-12-13 at 14:07 +0100, Ilya Dryomov wrote:
> On Wed, Dec 13, 2023 at 1:05=E2=80=AFPM Xiubo Li <xiubli@redhat.com> wrot=
e:
> >=20
> >=20
> > On 12/13/23 19:54, Ilya Dryomov wrote:
> >=20
> > On Wed, Dec 13, 2023 at 12:03=E2=80=AFPM Xiubo Li <xiubli@redhat.com> w=
rote:
> >=20
> > On 12/13/23 18:31, Ilya Dryomov wrote:
> >=20
> > On Wed, Dec 13, 2023 at 2:02=E2=80=AFAM Xiubo Li <xiubli@redhat.com> wr=
ote:
> >=20
> > On 12/13/23 00:31, Ilya Dryomov wrote:
> >=20
> > On Fri, Dec 8, 2023 at 5:08=E2=80=AFPM <xiubli@redhat.com> wrote:
> >=20
> > From: Xiubo Li <xiubli@redhat.com>
> >=20
> > The messages from ceph maybe split into multiple socket packages
> > and we just need to wait for all the data to be availiable on the
> > sokcet.
> >=20
> > This will add a new _FINISH state for the sparse-read to mark the
> > current sparse-read succeeded. Else it will treat it as a new
> > sparse-read when the socket receives the last piece of the osd
> > request reply message, and the cancel_request() later will help
> > init the sparse-read context.
> >=20
> > URL: https://tracker.ceph.com/issues/63586
> > Signed-off-by: Xiubo Li <xiubli@redhat.com>
> > ---
> >    include/linux/ceph/osd_client.h | 1 +
> >    net/ceph/osd_client.c           | 6 +++---
> >    2 files changed, 4 insertions(+), 3 deletions(-)
> >=20
> > diff --git a/include/linux/ceph/osd_client.h b/include/linux/ceph/osd_c=
lient.h
> > index 493de3496cd3..00d98e13100f 100644
> > --- a/include/linux/ceph/osd_client.h
> > +++ b/include/linux/ceph/osd_client.h
> > @@ -47,6 +47,7 @@ enum ceph_sparse_read_state {
> >           CEPH_SPARSE_READ_DATA_LEN,
> >           CEPH_SPARSE_READ_DATA_PRE,
> >           CEPH_SPARSE_READ_DATA,
> > +       CEPH_SPARSE_READ_FINISH,
> >    };
> >=20
> >    /*
> > diff --git a/net/ceph/osd_client.c b/net/ceph/osd_client.c
> > index 848ef19055a0..f1705b4f19eb 100644
> > --- a/net/ceph/osd_client.c
> > +++ b/net/ceph/osd_client.c
> > @@ -5802,8 +5802,6 @@ static int prep_next_sparse_read(struct ceph_conn=
ection *con,
> >                           advance_cursor(cursor, sr->sr_req_len - end, =
false);
> >           }
> >=20
> > -       ceph_init_sparse_read(sr);
> > -
> >           /* find next op in this request (if any) */
> >           while (++o->o_sparse_op_idx < req->r_num_ops) {
> >                   op =3D &req->r_ops[o->o_sparse_op_idx];
> > @@ -5919,7 +5917,7 @@ static int osd_sparse_read(struct ceph_connection=
 *con,
> >                                   return -EREMOTEIO;
> >                           }
> >=20
> > -                       sr->sr_state =3D CEPH_SPARSE_READ_HDR;
> > +                       sr->sr_state =3D CEPH_SPARSE_READ_FINISH;
> >                           goto next_op;
> >=20
> > Hi Xiubo,
> >=20
> > This code appears to be set up to handle multiple (sparse-read) ops in
> > a single OSD request.  Wouldn't this break that case?
> >=20
> > Yeah, it will break it. I just missed it.
> >=20
> > I think the bug is in read_sparse_msg_data().  It shouldn't be calling
> > con->ops->sparse_read() after the message has progressed to the footer.
> > osd_sparse_read() is most likely fine as is.
> >=20
> > Yes it is. We cannot tell exactly whether has it progressed to the
> > footer IMO, such as when in case 'con->v1.in_base_pos =3D=3D
> >=20
> > Hi Xiubo,
> >=20
> > I don't buy this.  If the messenger is trying to read the footer, it
> > _has_ progressed to the footer.  This is definitive and irreversible,
> > not a "maybe".
> >=20
> > sizeof(con->v1.in_hdr)' the socket buffer may break just after finishin=
g
> > sparse-read and before reading footer or some where in sparse-read. For
> > the later case then we should continue in the sparse reads.
> >=20
> > The size of the data section of the message is always known.  The
> > contract is that read_partial_msg_data*() returns 1 and does nothing
> > else after the data section is consumed.  This is how the messenger is
> > told to move on to the footer.
> >=20
> > read_partial_sparse_msg_data() doesn't adhere to this contract and
> > should be fixed.
> >=20
> > Notice how read_partial_msg_data() and read_partial_msg_data_bounce()
> > behave: if called at that point (i.e. after the data section has been
> > processed, meaning that cursor->total_resid =3D=3D 0), they do nothing.
> > read_sparse_msg_data() should have a similar condition and basically
> > no-op itself.
> >=20
> > Correct, this what I want to do in the sparse-read code.
> >=20
> > No, this needs to be done on the messenger side.  sparse-read code
> > should not be invoked after the messenger has moved on to the footer.
> >=20
> >  From my reading, even the messenger has moved on to the 'footer', it
> > will always try to invoke to parse the 'header':
> >=20
> > read_partial(con, end, size, &con->v1.in_hdr);
> >=20
> > But it will do nothing and just returns.
> >=20
> > And the same for 'front', 'middle' and '(page) data', then the last for
> > 'footer'.
> >=20
> > This is correct.
> >=20
> > Did I miss something ?
> >=20
> > No, it's how the messenger is set up to work.  The problem is that
> > read_sparse_msg_data() doesn't fit this model, so it should be fixed
> > and renamed to read_partial_sparse_msg_data().
> >=20
> > Okay, let me try.
> >=20
> > Did you see my new patch in last mail ? Will that work ?
> >=20
> > If not I will try to fix it in read_partial_sparse_msg_data().
>=20
> It might work around the problem, but it's not the right fix.  Think
> about it: what business does code in the OSD client have being called
> when the messenger is 14 bytes into reading the footer (number taken
> from the log in the cover letter)?  All data is read at that point and
> the last op in a multi-op OSD request may not even be sparse-read...
>=20

The assumption in ceph_osdc_new_request is that if you have a multi-op
request, that they are either all reads or all writes. The assumption
about writes has been there a long time. I simply added the ability to
do the same for reads:

    4e8c4c235578 libceph: allow ceph_osdc_new_request to accept a multi-op =
read

Note that we do this in ceph_sync_write in the rmw case, so that does
need to keep working.

Technically we could have a normal read in the same request as a sparse
read but I figured that would be a little silly. That's why it tries to
prep a second sparse read once the first is done. If there isn't one
then that should fall through to the return 0 just before the "found:"
label in prep_next_sparse_read.

So, I tend to agree with Ilya that the problem isn't down in the OSD
state machine, but more likely at the receive handling layer. It's
certainly plausible that I didn't get the handling of short receives
right (particularly in the messenger_v1 part).
--=20
Jeff Layton <jlayton@kernel.org>

