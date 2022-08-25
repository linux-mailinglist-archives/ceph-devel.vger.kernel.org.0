Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 925C95A11C1
	for <lists+ceph-devel@lfdr.de>; Thu, 25 Aug 2022 15:18:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242498AbiHYNST (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 25 Aug 2022 09:18:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235527AbiHYNSG (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 25 Aug 2022 09:18:06 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9E3BAA347
        for <ceph-devel@vger.kernel.org>; Thu, 25 Aug 2022 06:18:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 39D6861CDB
        for <ceph-devel@vger.kernel.org>; Thu, 25 Aug 2022 13:18:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32242C433D6;
        Thu, 25 Aug 2022 13:18:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661433483;
        bh=VCtAODmfT0VqLfT1GTzi2eLi6sQSh5XsPQnrrS5rkXk=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=Hx3luK+klhOjIIoIH5qbQoDPwEwaeSGIp+YXLFEHqqlEIx9hG7kJWRRfsHG9+EsQN
         lOTg0GDEDaMaZTQcyqgaG8L3D/2fVpk1jH9zUV8iHwz75hPuKLttbyGasdHtUDYVNS
         nlG8OTUB9RwnOJ6/AXZM2+lUpx2JtPAnstQqKB3Tz9/EOkaK7QzZtlc0bUbAs4HxRD
         m2iVT0hc+IddzfBhCb20BSZ5nVpsh8PmFPP/fKQLHGCqMUHaYdLO0npjBk2xtoWlWs
         PMDWMLU+CcjmxzgJ5uSaFLUvn/YHt1x9oLvNDOw2qOnu7VaDFkK+J7jLEgCZO/Wjpx
         XfqhSJSqUwSxg==
Message-ID: <c369ad1402ef31e2e543cd20eab2ba48f1e95d6e.camel@kernel.org>
Subject: Re: [PATCH] ceph: fix error handling in ceph_sync_write
From:   Jeff Layton <jlayton@kernel.org>
To:     =?ISO-8859-1?Q?Lu=EDs?= Henriques <lhenriques@suse.de>,
        Ilya Dryomov <idryomov@gmail.com>
Cc:     xiubli@redhat.com, ceph-devel@vger.kernel.org
Date:   Thu, 25 Aug 2022 09:18:01 -0400
In-Reply-To: <YwdDrguhbzhqMPgr@suse.de>
References: <20220824205331.473248-1-jlayton@kernel.org>
         <CAOi1vP9-kOHNjtSY0uEQP0bWwfn17BbiRbeuAmoCf2X9RrFHBA@mail.gmail.com>
         <YwdDrguhbzhqMPgr@suse.de>
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.4 (3.44.4-1.fc36) 
MIME-Version: 1.0
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Thu, 2022-08-25 at 10:41 +0100, Lu=EDs Henriques wrote:
> On Thu, Aug 25, 2022 at 10:32:56AM +0200, Ilya Dryomov wrote:
> > On Wed, Aug 24, 2022 at 10:53 PM Jeff Layton <jlayton@kernel.org> wrote=
:
> > >=20
> > > ceph_sync_write has assumed that a zero result in req->r_result means
> > > success. Testing with a recent cluster however shows the OSD returnin=
g
> > > a non-zero length written here. I'm not sure whether and when this
> > > changed, but fix the code to accept either result.
> > >=20
> > > Assume a negative result means error, and anything else is a success.=
 If
> > > we're given a short length, then return a short write.
> > >=20
> > > Signed-off-by: Jeff Layton <jlayton@kernel.org>
> > > ---
> > >  fs/ceph/file.c | 10 +++++++++-
> > >  1 file changed, 9 insertions(+), 1 deletion(-)
> > >=20
> > > diff --git a/fs/ceph/file.c b/fs/ceph/file.c
> > > index 86265713a743..c0b2c8968be9 100644
> > > --- a/fs/ceph/file.c
> > > +++ b/fs/ceph/file.c
> > > @@ -1632,11 +1632,19 @@ ceph_sync_write(struct kiocb *iocb, struct io=
v_iter *from, loff_t pos,
> > >                                           req->r_end_latency, len, re=
t);
> > >  out:
> > >                 ceph_osdc_put_request(req);
> > > -               if (ret !=3D 0) {
> > > +               if (ret < 0) {
> > >                         ceph_set_error_write(ci);
> > >                         break;
> > >                 }
> > >=20
> > > +               /*
> > > +                * FIXME: it's unclear whether all OSD versions retur=
n the
> > > +                * length written on a write. For now, assume that a =
0 return
> > > +                * means that everything got written.
> > > +                */
> > > +               if (ret && ret < len)
> > > +                       len =3D ret;
> > > +
> > >                 ceph_clear_error_write(ci);
> > >                 pos +=3D len;
> > >                 written +=3D len;
> > > --
> > > 2.37.2
> > >=20
> >=20
> > Hi Jeff,
> >=20
> > AFAIK OSDs aren't allowed to return any kind of length on a write
> > and there is no such thing as a short write.  This definitely needs
> > deeper investigation.
> >=20
> > What is the cluster version you are testing against?
>=20
> OK, I'm only seeing 'ret' being set to the write length only when enablin=
g
> encryption (i.e. with test_dummy_encryption mount option).  So, maybe the
> right fix is something like:
>=20
> diff --git a/fs/ceph/file.c b/fs/ceph/file.c
> index 16dcade66923..5119d87d61fb 100644
> --- a/fs/ceph/file.c
> +++ b/fs/ceph/file.c
> @@ -1889,6 +1889,7 @@ ceph_sync_write(struct kiocb *iocb, struct iov_iter=
 *from, loff_t pos,
>  				ceph_release_page_vector(pages, num_pages);
>  				break;
>  			}
> +			ret =3D 0;
>  		}
> =20
>  		req =3D ceph_osdc_new_request(osdc, &ci->i_layout,
>=20

No, actually. I think the original patch I sent is just wrong. There was
another bug (another missing ceph_osdc_wait_request) in the fscrypt
stack that was causing r_result to not appear to be zero.

I've fixed this in the ceph-fscrypt branch in my tree and it seems to be
working. I'll plan do a re-send of the fscrypt patches that are not yet
in the testing branch today.

Thanks!
--=20
Jeff Layton <jlayton@kernel.org>
