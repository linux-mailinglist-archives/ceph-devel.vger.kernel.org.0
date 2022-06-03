Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8923A53C9E7
	for <lists+ceph-devel@lfdr.de>; Fri,  3 Jun 2022 14:24:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244318AbiFCMYL (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 3 Jun 2022 08:24:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230159AbiFCMYK (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Fri, 3 Jun 2022 08:24:10 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7B4B14D3F
        for <ceph-devel@vger.kernel.org>; Fri,  3 Jun 2022 05:24:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7B16A615B7
        for <ceph-devel@vger.kernel.org>; Fri,  3 Jun 2022 12:24:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68F14C385B8;
        Fri,  3 Jun 2022 12:24:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654259048;
        bh=gVHxMXp8mYvG1gF0v3CCDxyC9yE+WfvStTU+BzOEPYM=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=tOhq3L8MQai22T3MxpUoQBw+RJ0JaZ31aBSuB3K0HQYWO85lC6f5//Wn94tT08wDf
         w+i9jtKpZscXwIHoMwEPVmykICb4vlgS/I6YagoEwPmlBsCueclloGNXgi5rfWBSyT
         wU+OxzlAVNFyN93gUeFld04Zc45cM7ikBwFqpiHy3fXvhBEbrkDq0BYvjVUWcHrbe9
         MYhRroi5Y9cfyh+++ceRsJVszshUylvuurR4tPLuK1nzL5CviMewDLHbUvo4Qlbv66
         9Z/a490UKFxSiOBo+FgLQQA7u9BsUy1VTMtnNPLhEC9KmUcZFzwa9ThYP4GOV4McOW
         8M87GyAkb+Wiw==
Message-ID: <d18e02c9d6652e533f8a81c92ab011d907b5f8fe.camel@kernel.org>
Subject: Re: [PATCH v14 58/64] ceph: add encryption support to writepage
From:   Jeff Layton <jlayton@kernel.org>
To:     =?ISO-8859-1?Q?Lu=EDs?= Henriques <lhenriques@suse.de>
Cc:     ceph-devel@vger.kernel.org, xiubli@redhat.com, idryomov@gmail.com
Date:   Fri, 03 Jun 2022 08:24:07 -0400
In-Reply-To: <875yli3y34.fsf@brahms.olymp>
References: <20220427191314.222867-1-jlayton@kernel.org>
         <20220427191314.222867-59-jlayton@kernel.org>
         <5a4d4ca805797f745fb9885fcd8d8d6252db0787.camel@kernel.org>
         <875yli3y34.fsf@brahms.olymp>
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.2 (3.44.2-1.fc36) 
MIME-Version: 1.0
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Fri, 2022-06-03 at 10:17 +0100, Lu=EDs Henriques wrote:
> Jeff Layton <jlayton@kernel.org> writes:
>=20
> > On Wed, 2022-04-27 at 15:13 -0400, Jeff Layton wrote:
> > > Allow writepage to issue encrypted writes. Extend out the requested s=
ize
> > > and offset to cover complete blocks, and then encrypt and write them =
to
> > > the OSDs.
> > >=20
> > > Signed-off-by: Jeff Layton <jlayton@kernel.org>
> > > ---
> > >  fs/ceph/addr.c | 34 +++++++++++++++++++++++++++-------
> > >  1 file changed, 27 insertions(+), 7 deletions(-)
> > >=20
> > > diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
> > > index d65d431ec933..f54940fc96ee 100644
> > > --- a/fs/ceph/addr.c
> > > +++ b/fs/ceph/addr.c
> > > @@ -586,10 +586,12 @@ static int writepage_nounlock(struct page *page=
, struct writeback_control *wbc)
> > >  	loff_t page_off =3D page_offset(page);
> > >  	int err;
> > >  	loff_t len =3D thp_size(page);
> > > +	loff_t wlen;
> > >  	struct ceph_writeback_ctl ceph_wbc;
> > >  	struct ceph_osd_client *osdc =3D &fsc->client->osdc;
> > >  	struct ceph_osd_request *req;
> > >  	bool caching =3D ceph_is_cache_enabled(inode);
> > > +	struct page *bounce_page =3D NULL;
> > > =20
> > >  	dout("writepage %p idx %lu\n", page, page->index);
> > > =20
> > > @@ -621,6 +623,8 @@ static int writepage_nounlock(struct page *page, =
struct writeback_control *wbc)
> > > =20
> > >  	if (ceph_wbc.i_size < page_off + len)
> > >  		len =3D ceph_wbc.i_size - page_off;
> > > +	if (IS_ENCRYPTED(inode))
> > > +		wlen =3D round_up(len, CEPH_FSCRYPT_BLOCK_SIZE);
> > > =20
> >=20
> > The above is buggy. We're only setting "wlen" in the encrypted case. Yo=
u
> > would think that the compiler would catch that, but next usage of wlen
> > just passes a pointer to it to another function and that cloaks the
> > warning.
>=20
> Yikes!  That's indeed the sort of things we got used to have compilers
> complaining about.  That must have been fun to figure this out.  Nice ;-)
>=20

Yeah. I remember that some older versions of gcc would complain about
uninitialized vars when you passed a pointer to it to another function.
That went away a while back, which was good since it often fired on
false positives.

What would have been nice here would be for the compiler to notice that
wlen was inconsistently initialized before we passed the pointer to the
function. Not sure how hard that would be to catch though.
--=20
Jeff Layton <jlayton@kernel.org>
