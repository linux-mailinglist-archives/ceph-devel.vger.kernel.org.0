Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F0365A0E91
	for <lists+ceph-devel@lfdr.de>; Thu, 25 Aug 2022 12:57:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241415AbiHYK5B (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 25 Aug 2022 06:57:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240849AbiHYK45 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 25 Aug 2022 06:56:57 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C9E4AA3FA
        for <ceph-devel@vger.kernel.org>; Thu, 25 Aug 2022 03:56:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 64B2B618D1
        for <ceph-devel@vger.kernel.org>; Thu, 25 Aug 2022 10:56:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6EB1FC433C1;
        Thu, 25 Aug 2022 10:56:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661425012;
        bh=Qd5DieE9eW9aHxorVlzf82zXn5dlzOu0xN4IiDbhM3Q=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=GUqH40vKNEm0KvxBScffQzP5m362d6O65DlMeBv9kPDKBJb2u8xsI2TH9aSTlfctY
         KgSH+if3EgRdpU1zuekS+ztm049IiQVtVpKvs7XOzI7hOYEeZ23z6qlO+ySX2JAi0j
         jskAE+GaCMLjTdQL2qVcZvGcrObs/c5rV/BtnpzW970yVT+3EgaBjdWfhAH9+TxNnS
         KH7nFBSQTX8yAZbo/tNKlDqA8oopj4YgyINFQ8P+uJp6v+8MYJNWVa1ct7CtEmAX5w
         yxpXQKD/8+vBHNBcQlPWZZ/nmxVKLmdA0LIfxMX0WdxWpbHZxuP1jo6ngjwL2WcNMv
         hJTj16VbEGDoA==
Message-ID: <9a9218cad137d07b81fa8d2c984f840098b3ae29.camel@kernel.org>
Subject: Re: [PATCH] ceph: fix error handling in ceph_sync_write
From:   Jeff Layton <jlayton@kernel.org>
To:     Ilya Dryomov <idryomov@gmail.com>
Cc:     xiubli@redhat.com, ceph-devel@vger.kernel.org
Date:   Thu, 25 Aug 2022 06:56:51 -0400
In-Reply-To: <CAOi1vP9-kOHNjtSY0uEQP0bWwfn17BbiRbeuAmoCf2X9RrFHBA@mail.gmail.com>
References: <20220824205331.473248-1-jlayton@kernel.org>
         <CAOi1vP9-kOHNjtSY0uEQP0bWwfn17BbiRbeuAmoCf2X9RrFHBA@mail.gmail.com>
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

On Thu, 2022-08-25 at 10:32 +0200, Ilya Dryomov wrote:
> On Wed, Aug 24, 2022 at 10:53 PM Jeff Layton <jlayton@kernel.org> wrote:
> >=20
> > ceph_sync_write has assumed that a zero result in req->r_result means
> > success. Testing with a recent cluster however shows the OSD returning
> > a non-zero length written here. I'm not sure whether and when this
> > changed, but fix the code to accept either result.
> >=20
> > Assume a negative result means error, and anything else is a success. I=
f
> > we're given a short length, then return a short write.
> >=20
> > Signed-off-by: Jeff Layton <jlayton@kernel.org>
> > ---
> >  fs/ceph/file.c | 10 +++++++++-
> >  1 file changed, 9 insertions(+), 1 deletion(-)
> >=20
> > diff --git a/fs/ceph/file.c b/fs/ceph/file.c
> > index 86265713a743..c0b2c8968be9 100644
> > --- a/fs/ceph/file.c
> > +++ b/fs/ceph/file.c
> > @@ -1632,11 +1632,19 @@ ceph_sync_write(struct kiocb *iocb, struct iov_=
iter *from, loff_t pos,
> >                                           req->r_end_latency, len, ret)=
;
> >  out:
> >                 ceph_osdc_put_request(req);
> > -               if (ret !=3D 0) {
> > +               if (ret < 0) {
> >                         ceph_set_error_write(ci);
> >                         break;
> >                 }
> >=20
> > +               /*
> > +                * FIXME: it's unclear whether all OSD versions return =
the
> > +                * length written on a write. For now, assume that a 0 =
return
> > +                * means that everything got written.
> > +                */
> > +               if (ret && ret < len)
> > +                       len =3D ret;
> > +
> >                 ceph_clear_error_write(ci);
> >                 pos +=3D len;
> >                 written +=3D len;
> > --
> > 2.37.2
> >=20
>=20
> Hi Jeff,
>=20
> AFAIK OSDs aren't allowed to return any kind of length on a write
> and there is no such thing as a short write.  This definitely needs
> deeper investigation.
>=20
> What is the cluster version you are testing against?
>=20

That's what I had thought too but I wasn't sure:

    [ceph: root@quad1 /]# ceph --version
    ceph version 17.0.0-14400-gf61b38dc (f61b38dc82e94f14e7a0a5f6a5888c0c78=
fafa6c) quincy (dev)

I'll see if I can confirm that this is coming from the OSD and not some
other layer as well.
--=20
Jeff Layton <jlayton@kernel.org>
