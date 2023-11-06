Return-Path: <ceph-devel+bounces-56-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 7135C7E219C
	for <lists+ceph-devel@lfdr.de>; Mon,  6 Nov 2023 13:32:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1D48728150D
	for <lists+ceph-devel@lfdr.de>; Mon,  6 Nov 2023 12:32:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 73B6ACA65;
	Mon,  6 Nov 2023 12:32:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fj6/V+8T"
X-Original-To: ceph-devel@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 075A0208BD
	for <ceph-devel@vger.kernel.org>; Mon,  6 Nov 2023 12:32:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED7FFC433C7;
	Mon,  6 Nov 2023 12:32:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1699273934;
	bh=8mLWNB6iAD5hVufLe2xwoqaxE3Je+qjzzwJCQ637NMs=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
	b=fj6/V+8Tb3RvpATcstHqnOkdKQYGTV00HuG2qM3IUM01mlwYnUljPoB0kBb8MGyD4
	 69fZtiOwi0kXetfoJassmnUQSqiUlOGsvYoQH0fu6EqHDEg/MiVHv2a0hjGz7tVLkP
	 Kc8/+iA1bm7v/Az8nV8JHtbiv/RKkiwjIywhdSSMH3Zo5SRWo1isdNlv6j1sJLK2M0
	 ezMWJK/kM7OJzRjaCsxSDo0UXYBTetyCsTsu2eG5++r6/ojUDYvLQ2cYNTkNV7AIif
	 5xyrXPpOKfS/WfWOB3ST4SBxlZJwnWut+47JOjf7dP5dFb+zwZkOtDZpTBhnKWl7pH
	 aX4d2eDA0fxhA==
Message-ID: <85fd22f7f3b3c18cbb9a1edf5894300faca0f2fa.camel@kernel.org>
Subject: Re: [PATCH v3 2/2] libceph: check the data length when sparse-read
 finishes
From: Jeff Layton <jlayton@kernel.org>
To: Xiubo Li <xiubli@redhat.com>, Ilya Dryomov <idryomov@gmail.com>
Cc: ceph-devel@vger.kernel.org, vshankar@redhat.com, mchangir@redhat.com
Date: Mon, 06 Nov 2023 07:32:12 -0500
In-Reply-To: <873e9540-cf61-e517-eb68-5b83e8984f0e@redhat.com>
References: <20231106011644.248119-1-xiubli@redhat.com>
	 <20231106011644.248119-3-xiubli@redhat.com>
	 <CAOi1vP_NQmkreqVoM+CP=v3PkGh-79jYV8xgrmDA0b4z8PJ3mA@mail.gmail.com>
	 <873e9540-cf61-e517-eb68-5b83e8984f0e@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.48.4 (3.48.4-1.fc38) 
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Mon, 2023-11-06 at 20:17 +0800, Xiubo Li wrote:
> On 11/6/23 19:54, Ilya Dryomov wrote:
> > On Mon, Nov 6, 2023 at 2:19=E2=80=AFAM <xiubli@redhat.com> wrote:
> > > From: Xiubo Li <xiubli@redhat.com>
> > >=20
> > > For sparse reading the real length of the data should equal to the
> > > total length from the extent array.
> > >=20
> > > URL: https://tracker.ceph.com/issues/62081
> > > Signed-off-by: Xiubo Li <xiubli@redhat.com>
> > > Reviewed-by: Jeff Layton <jlayton@kernel.org>
> > > ---
> > >   net/ceph/osd_client.c | 8 ++++++++
> > >   1 file changed, 8 insertions(+)
> > >=20
> > > diff --git a/net/ceph/osd_client.c b/net/ceph/osd_client.c
> > > index 0e629dfd55ee..050dc39065fb 100644
> > > --- a/net/ceph/osd_client.c
> > > +++ b/net/ceph/osd_client.c
> > > @@ -5920,6 +5920,12 @@ static int osd_sparse_read(struct ceph_connect=
ion *con,
> > >                  fallthrough;
> > >          case CEPH_SPARSE_READ_DATA:
> > >                  if (sr->sr_index >=3D count) {
> > > +                       if (sr->sr_datalen && count) {
> > > +                               pr_warn_ratelimited("%s: datalen and =
extents mismath, %d left\n",
> > > +                                                   __func__, sr->sr_=
datalen);
> > > +                               return -EREMOTEIO;
> > By returning EREMOTEIO here you have significantly changed the
> > semantics (in v2 it was just a warning) but Jeff's Reviewed-by is
> > retained.  Has he acked the change?
>=20
> Oh, sorry I forgot to remove that.
>=20
> Jeff, Please take a look here again.
>=20
> Thanks
>=20
> - Xiubo
>=20
>=20

Returning EREMOTEIO if the lengths don't match seems like a reasonable
thing to do. You can retain the R-b.


--=20
Jeff Layton <jlayton@kernel.org>

