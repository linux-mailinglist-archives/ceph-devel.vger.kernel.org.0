Return-Path: <ceph-devel+bounces-34-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 531867E002A
	for <lists+ceph-devel@lfdr.de>; Fri,  3 Nov 2023 11:14:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 04FC0281DEA
	for <lists+ceph-devel@lfdr.de>; Fri,  3 Nov 2023 10:14:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1696112B97;
	Fri,  3 Nov 2023 10:14:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZL1qQ+32"
X-Original-To: ceph-devel@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94B0A125CC
	for <ceph-devel@vger.kernel.org>; Fri,  3 Nov 2023 10:14:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85CBEC433CD;
	Fri,  3 Nov 2023 10:14:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1699006451;
	bh=GHpuSlE1CxWJkFGVRDxTQJa1aokpqi/B5kO3bhbn6uU=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
	b=ZL1qQ+329qujXh+/qPa1NWY7H4lY3tqU/xkdLczfHeUgOIV8zeHJlA4ceLmdU3riG
	 i0vGg8ZyF6DW/NOFtDcrzPDl+iDp5z2ksGmwAKDJPCDF4M+1Hb42Mqo0ln9Tqz/7Gx
	 blBe+3S/gukphKSiP7wXUFFj1QBUYH+0RVXjsIl4mi7zBW2vA69lV/9E6rlUn2RrtR
	 BPiZRtrYJosJNsiK7F9QRyuIJ+J8VDZKbCG0y7gabsMDS6FMeTTwAtPTFn+04ccCFn
	 dqALD9dh2SGLiZ9dbN+kwPxucePLG7SacYBIdtP4J7vNM13N9LLtk9PSnwwvyXEfzZ
	 OVeViCEPf2QcA==
Message-ID: <23b5dc4e0607a033714e50c3326d587fd0cf99bf.camel@kernel.org>
Subject: Re: [PATCH] libceph: remove the max extents check for sparse read
From: Jeff Layton <jlayton@kernel.org>
To: Ilya Dryomov <idryomov@gmail.com>, xiubli@redhat.com
Cc: ceph-devel@vger.kernel.org, vshankar@redhat.com, mchangir@redhat.com
Date: Fri, 03 Nov 2023 06:14:09 -0400
In-Reply-To: <CAOi1vP8EtALzni0sdj0o4j61KkC6XqgzEgikCDhDPOHX6LNYZw@mail.gmail.com>
References: <20231103033900.122990-1-xiubli@redhat.com>
	 <CAOi1vP8EtALzni0sdj0o4j61KkC6XqgzEgikCDhDPOHX6LNYZw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.48.4 (3.48.4-1.fc38) 
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Fri, 2023-11-03 at 11:07 +0100, Ilya Dryomov wrote:
> On Fri, Nov 3, 2023 at 4:41=E2=80=AFAM <xiubli@redhat.com> wrote:
> >=20
> > From: Xiubo Li <xiubli@redhat.com>
> >=20
> > There is no any limit for the extent array size and it's possible
> > that when reading with a large size contents. Else the messager
> > will fail by reseting the connection and keeps resending the inflight
> > IOs.
> >=20
> > URL: https://tracker.ceph.com/issues/62081
> > Signed-off-by: Xiubo Li <xiubli@redhat.com>
> > ---
> >  net/ceph/osd_client.c | 12 ------------
> >  1 file changed, 12 deletions(-)
> >=20
> > diff --git a/net/ceph/osd_client.c b/net/ceph/osd_client.c
> > index 7af35106acaf..177a1d92c517 100644
> > --- a/net/ceph/osd_client.c
> > +++ b/net/ceph/osd_client.c
> > @@ -5850,8 +5850,6 @@ static inline void convert_extent_map(struct ceph=
_sparse_read *sr)
> >  }
> >  #endif
> >=20
> > -#define MAX_EXTENTS 4096
> > -
> >  static int osd_sparse_read(struct ceph_connection *con,
> >                            struct ceph_msg_data_cursor *cursor,
> >                            char **pbuf)
> > @@ -5882,16 +5880,6 @@ static int osd_sparse_read(struct ceph_connectio=
n *con,
> >=20
> >                 if (count > 0) {
> >                         if (!sr->sr_extent || count > sr->sr_ext_len) {
> > -                               /*
> > -                                * Apply a hard cap to the number of ex=
tents.
> > -                                * If we have more, assume something is=
 wrong.
> > -                                */
> > -                               if (count > MAX_EXTENTS) {
> > -                                       dout("%s: OSD returned 0x%x ext=
ents in a single reply!\n",
> > -                                            __func__, count);
> > -                                       return -EREMOTEIO;
> > -                               }
> > -
> >                                 /* no extent array provided, or too sho=
rt */
> >                                 kfree(sr->sr_extent);
> >                                 sr->sr_extent =3D kmalloc_array(count,
> > --
> > 2.39.1
> >=20
>=20
> Hi Xiubo,
>=20
> As noted in the tracker ticket, there are many "sanity" limits like
> that in the messenger and other parts of the kernel client.  First,
> let's change that dout to pr_warn_ratelimited so that it's immediately
> clear what is going on.  Then, if the limit actually gets hit, let's
> dig into why and see if it can be increased rather than just removed.
>=20

Yeah, agreed. I think when I wrote this, I couldn't figure out if there
was an actual hard cap on the number of extents, so I figured 4k ought
to be enough for anybody. Clearly that was wrong though.

I'd still favor raising the cap instead eliminating it altogether. Is
there a hard cap on the number of extents that the OSD will send in a
single reply? That's really what this limit should be.
--=20
Jeff Layton <jlayton@kernel.org>

