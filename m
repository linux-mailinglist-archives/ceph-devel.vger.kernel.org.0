Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3B55A588AF9
	for <lists+ceph-devel@lfdr.de>; Wed,  3 Aug 2022 13:15:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234698AbiHCLPu (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 3 Aug 2022 07:15:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235850AbiHCLPg (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 3 Aug 2022 07:15:36 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 919289FEC
        for <ceph-devel@vger.kernel.org>; Wed,  3 Aug 2022 04:15:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 341E2610A4
        for <ceph-devel@vger.kernel.org>; Wed,  3 Aug 2022 11:15:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DC97C433D7;
        Wed,  3 Aug 2022 11:15:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659525334;
        bh=d8nV0Zvakmmocirbrv4YQTqbPYhhKIErq1B2RMm/hNk=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=Z4ARBKHJEbiDvB9hAfCDm4BNm1rx6zqFYZhYlAFRwjHdrH66g/MeFKHnI7thCxXRG
         peHU3pODh+nxmc3mKJOmW0rrkWUpJ2Wm19PuMDv2bteQJbxD5e4etvabpzmsI7/1ki
         xYlAhO7817a8eVZDCUQvSbbKYVZddiGjQz5Iy8MvwO6eARJ0lqqH8UpF5vpZUPGqbM
         iEh0SYR4Ylbuq92oZxJ3JgU+DE+DOwxFQ+3Op7ULnWQM3/98ehCTwJgw0h2k40txqA
         V37Hw1mnMO9sTsbgIT5iC6kLJpFciaht/a2NgpOG0tttp4uCuVyhBphCvRlFwxYY8/
         yoUjGTFOmlRhg==
Message-ID: <95c06864af1704c9752c14e48e80817f363ce450.camel@kernel.org>
Subject: Re: [PATCH] libceph: clean up ceph_osdc_start_request prototype
From:   Jeff Layton <jlayton@kernel.org>
To:     Ilya Dryomov <idryomov@gmail.com>
Cc:     xiubli@redhat.com, ceph-devel@vger.kernel.org
Date:   Wed, 03 Aug 2022 07:15:32 -0400
In-Reply-To: <CAOi1vP_PETHhCm3nUm5B_t0tMJQdmdBxsAmMpbPoGTD1WimMpg@mail.gmail.com>
References: <20220630202150.653547-1-jlayton@kernel.org>
         <CAOi1vP_PETHhCm3nUm5B_t0tMJQdmdBxsAmMpbPoGTD1WimMpg@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.3 (3.44.3-1.fc36) 
MIME-Version: 1.0
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Wed, 2022-08-03 at 09:13 +0200, Ilya Dryomov wrote:
> On Thu, Jun 30, 2022 at 10:21 PM Jeff Layton <jlayton@kernel.org> wrote:
> >=20
> > This function always returns 0, and ignores the nofail boolean. Drop th=
e
> > nofail argument, make the function void return and fix up the callers.
> >=20
> > Signed-off-by: Jeff Layton <jlayton@kernel.org>
> > ---
> >  drivers/block/rbd.c             |  6 +++---
> >  fs/ceph/addr.c                  | 32 ++++++++++++--------------------
> >  fs/ceph/file.c                  | 32 +++++++++++++-------------------
> >  include/linux/ceph/osd_client.h |  5 ++---
> >  net/ceph/osd_client.c           | 15 ++++++---------
> >  5 files changed, 36 insertions(+), 54 deletions(-)
> >=20
> > diff --git a/drivers/block/rbd.c b/drivers/block/rbd.c
> > index 91e541aa1f64..a8af0329ab77 100644
> > --- a/drivers/block/rbd.c
> > +++ b/drivers/block/rbd.c
> > @@ -1297,7 +1297,7 @@ static void rbd_osd_submit(struct ceph_osd_reques=
t *osd_req)
> >         dout("%s osd_req %p for obj_req %p objno %llu %llu~%llu\n",
> >              __func__, osd_req, obj_req, obj_req->ex.oe_objno,
> >              obj_req->ex.oe_off, obj_req->ex.oe_len);
> > -       ceph_osdc_start_request(osd_req->r_osdc, osd_req, false);
> > +       ceph_osdc_start_request(osd_req->r_osdc, osd_req);
> >  }
> >=20
> >  /*
> > @@ -2081,7 +2081,7 @@ static int rbd_object_map_update(struct rbd_obj_r=
equest *obj_req, u64 snap_id,
> >         if (ret)
> >                 return ret;
> >=20
> > -       ceph_osdc_start_request(osdc, req, false);
> > +       ceph_osdc_start_request(osdc, req);
> >         return 0;
> >  }
> >=20
> > @@ -4768,7 +4768,7 @@ static int rbd_obj_read_sync(struct rbd_device *r=
bd_dev,
> >         if (ret)
> >                 goto out_req;
> >=20
> > -       ceph_osdc_start_request(osdc, req, false);
> > +       ceph_osdc_start_request(osdc, req);
> >         ret =3D ceph_osdc_wait_request(osdc, req);
> >         if (ret >=3D 0)
> >                 ceph_copy_from_page_vector(pages, buf, 0, ret);
> > diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
> > index fe6147f20dee..66dc7844fcc6 100644
> > --- a/fs/ceph/addr.c
> > +++ b/fs/ceph/addr.c
> > @@ -357,9 +357,7 @@ static void ceph_netfs_issue_read(struct netfs_io_s=
ubrequest *subreq)
> >         req->r_inode =3D inode;
> >         ihold(inode);
> >=20
> > -       err =3D ceph_osdc_start_request(req->r_osdc, req, false);
> > -       if (err)
> > -               iput(inode);
> > +       ceph_osdc_start_request(req->r_osdc, req);
> >  out:
> >         ceph_osdc_put_request(req);
> >         if (err)
>=20
> Hi Jeff,
>=20
> I'm confused by this err !=3D 0 check.  Previously err was set to 0
> by ceph_osdc_start_request() and netfs_subreq_terminated() was never
> called after an OSD request submission.  Now it is called, but only if
> len !=3D 0?
>=20
> I see that netfs_subreq_terminated() accepts either the amount of data
> transferred or an error code but it also has some transferred_or_error
> =3D=3D 0 handling which this check effectively disables.  And do we reall=
y
> want to account for transferred data before the transfer occurs?
>=20

No we don't. I think you're correct. What I'm not sure of is why this
doesn't cause test failures all over the place.

In any case, I'll need to respin this. I'll do that and send a v2.

Good catch!
--=20
Jeff Layton <jlayton@kernel.org>
