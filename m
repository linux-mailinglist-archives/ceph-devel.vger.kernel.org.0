Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5127E588B09
	for <lists+ceph-devel@lfdr.de>; Wed,  3 Aug 2022 13:20:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235660AbiHCLU1 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 3 Aug 2022 07:20:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235148AbiHCLU0 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 3 Aug 2022 07:20:26 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11F55DF11
        for <ceph-devel@vger.kernel.org>; Wed,  3 Aug 2022 04:20:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BD71CB82188
        for <ceph-devel@vger.kernel.org>; Wed,  3 Aug 2022 11:20:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2AD61C433C1;
        Wed,  3 Aug 2022 11:20:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659525622;
        bh=AT+/ddNoZ1KSXcJ6ywzR+i8yEYwLiVYBM5huG65kMZc=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=lOKA2/frHIlcqv6I56qPacDRZOlmh5bJRVH8PSZkZS3ZlqJqkCzJgG9B6T19NsIMi
         rd3fFfX2q6TD3eWyx3EVw2sfk4skDkVv5A2zq9ohiUd57jdQBXwn0/hEHKTok0E4Qs
         cyI4DnopDPBDYOnvM9gggbQpil22Nk7Iap32RgJzJlAtOTmLmUFJmWQdIRnZP+l97d
         5AMx4aVJmr+ZcPJrrS5zRvU1YIfLunLxQkRB/a2b0emazEOwTwRbhHblr4YCoUJ0oT
         Rgc4WU/vZ6eTe3pq1c7bPgOnKuk9NvOBbTAobSporcr75bZL1S/XoaemKRHxa0RoSB
         j4RGwyTQhCGNQ==
Message-ID: <6fc6c0a2ab957957813cd23567298c63c83f3a33.camel@kernel.org>
Subject: Re: [PATCH] libceph: clean up ceph_osdc_start_request prototype
From:   Jeff Layton <jlayton@kernel.org>
To:     Ilya Dryomov <idryomov@gmail.com>
Cc:     xiubli@redhat.com, ceph-devel@vger.kernel.org
Date:   Wed, 03 Aug 2022 07:20:20 -0400
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
> Thanks,
>=20
>                 Ilya

The incremental "patch to the patch" is here:

diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
index 14793fabc26e..ec76e77f8d4b 100644
--- a/fs/ceph/addr.c
+++ b/fs/ceph/addr.c
@@ -337,6 +337,7 @@ static void ceph_netfs_issue_read(struct netfs_io_subre=
quest *subreq)
        /* should always give us a page-aligned read */
        WARN_ON_ONCE(page_off);
        len =3D err;
+       err =3D 0;
=20
        osd_req_op_extent_osd_data_pages(req, 0, pages, len, 0, false, fals=
e);
        req->r_callback =3D finish_netfs_read;

I'll need to rebuild my test environment to make sure this is working as ex=
pected.
--=20
Jeff Layton <jlayton@kernel.org>
