Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 65C055A11B7
	for <lists+ceph-devel@lfdr.de>; Thu, 25 Aug 2022 15:17:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241016AbiHYNRS (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 25 Aug 2022 09:17:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239695AbiHYNRR (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 25 Aug 2022 09:17:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 270DF1EAD0
        for <ceph-devel@vger.kernel.org>; Thu, 25 Aug 2022 06:16:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 74CCA61CBF
        for <ceph-devel@vger.kernel.org>; Thu, 25 Aug 2022 13:16:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 771C5C433C1;
        Thu, 25 Aug 2022 13:16:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661433406;
        bh=WjcIZI9VqwT+gJ2VKZ8libVYc/3nVpwNTzVF6XhzeVI=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=lLtKg3kqEYgzPsCKN6nEkoV+Ee3a0YkHZafEAvTevLcjqhpprxJr/vFyc3L5NaQw6
         Xtw7dkvDzdMdt8Z6mSB/5tnTGgmOvDzrI93HB8MFwKl1r4surSKNtgrFTs9peflu5G
         WO1XcAiUiz7zezG2ZPx8Z4P8uE/M08Wc1s2ybXtQX7Fc83bvmu7pPY60idEdCVVqys
         4lzDPDeV40cjshiciyAhPiMTFSNyUwu09HyXlNtCB313Tefa9CJ8kOg1H0O2mMS7M4
         of1hUsOwXoGBD/W3+yMk4BPlDtXYOcGRPhCVLF103KRCItKN4oBZnVwcBkd3iG2MM1
         3O8mOn5OMixFA==
Message-ID: <b40e97ec41a013f796c6df981c55e7458ae205f8.camel@kernel.org>
Subject: Re: [PATCH] ceph: fix error handling in ceph_sync_write
From:   Jeff Layton <jlayton@kernel.org>
To:     Ilya Dryomov <idryomov@gmail.com>
Cc:     xiubli@redhat.com, ceph-devel@vger.kernel.org
Date:   Thu, 25 Aug 2022 09:16:45 -0400
In-Reply-To: <9a9218cad137d07b81fa8d2c984f840098b3ae29.camel@kernel.org>
References: <20220824205331.473248-1-jlayton@kernel.org>
         <CAOi1vP9-kOHNjtSY0uEQP0bWwfn17BbiRbeuAmoCf2X9RrFHBA@mail.gmail.com>
         <9a9218cad137d07b81fa8d2c984f840098b3ae29.camel@kernel.org>
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

On Thu, 2022-08-25 at 06:56 -0400, Jeff Layton wrote:
> On Thu, 2022-08-25 at 10:32 +0200, Ilya Dryomov wrote:
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
> >=20
>=20
> That's what I had thought too but I wasn't sure:
>=20
>     [ceph: root@quad1 /]# ceph --version
>     ceph version 17.0.0-14400-gf61b38dc (f61b38dc82e94f14e7a0a5f6a5888c0c=
78fafa6c) quincy (dev)
>=20
> I'll see if I can confirm that this is coming from the OSD and not some
> other layer as well.

My mistake. This bug turns out to be a different bug in the fscrypt
stack. We can drop this patch (and I probably should have sent it as an
RFC in the first place). Sorry for the noise!

--=20
Jeff Layton <jlayton@kernel.org>
