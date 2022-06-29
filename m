Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED08F55FF3B
	for <lists+ceph-devel@lfdr.de>; Wed, 29 Jun 2022 14:09:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231384AbiF2MId (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 29 Jun 2022 08:08:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229828AbiF2MIc (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 29 Jun 2022 08:08:32 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C288A19C21
        for <ceph-devel@vger.kernel.org>; Wed, 29 Jun 2022 05:08:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5620961AF6
        for <ceph-devel@vger.kernel.org>; Wed, 29 Jun 2022 12:08:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A977C34114;
        Wed, 29 Jun 2022 12:08:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656504510;
        bh=XJ9jwg2XXcw9nEjnAHQEION5kTVOhiNSs0YcqRQe4Wk=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=R5smnpjoPy5zY1pVXnVBaAFIB4IUJA7A+kkx5aPc2t/gNdm743s2zutGEVxI++6C5
         CQ3As4NBoVKfmVL1OfsrzFqC/FGP832RXlEhyt4PeYKgaZktB4AA86y2Pj4/LzOgXJ
         ZALx5yGnwDNhECKGScQp0qACNmtLDsTHiHChhnfB/p/Zcr0E3dnUrl+EhzTZgXHvAr
         sFpgwYDLyzAAr8nyUxy3u0VHe1ICVRkUHshZA1kn+C+qz30xTxKgX3ptgFTzuNhpA7
         JwRrLHwzQQDu4KVkwROepqsoygVn9X4RxlAD5mEzGw6vFjFaz/Oc7+K1m1nIMA3E/x
         8KfhtwfPH142w==
Message-ID: <b66bd239bc69f432ae474c207591a67d3990d09f.camel@kernel.org>
Subject: Re: [PATCH] ceph: wait on async create before checking caps for
 syncfs
From:   Jeff Layton <jlayton@kernel.org>
To:     "Yan, Zheng" <ukernel@gmail.com>
Cc:     Xiubo Li <xiubli@redhat.com>, Ilya Dryomov <idryomov@gmail.com>,
        ceph-devel <ceph-devel@vger.kernel.org>
Date:   Wed, 29 Jun 2022 08:08:28 -0400
In-Reply-To: <CAAM7YAmguEUbX7XWc9HV0traYT-CgKWdDWV8-OyjwLc2+Tk8EQ@mail.gmail.com>
References: <20220606233142.150457-1-jlayton@kernel.org>
         <CAAM7YAmguEUbX7XWc9HV0traYT-CgKWdDWV8-OyjwLc2+Tk8EQ@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.2 (3.44.2-1.fc36) 
MIME-Version: 1.0
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Are you suggesting that the MDS ought to hold a cap message for an inode
before its create request is processed? Note that the MDS won't even be
aware that the inode even _exists_ at that point. As far as the MDS
knows, it's just be a delegated inode number to the client. At what
point does the MDS give up on holding such a cap request if the create
request never comes in for some reason?

I don't see the harm in making the client wait until it gets a create
reply before sending a cap message. If we want to revert fbed7045f552
instead, we can do that, but it'll cause a regression until the MDS is
fixed [1]. Regardless, we need to either take this patch or revert that
one.=20

I move that we take this patch for now to address the softlockups. Once
the MDS is fixed we could revert this and fbed7045f552 without causing a
regression.

[1]: https://tracker.ceph.com/issues/54107


On Thu, 2022-06-09 at 10:15 +0800, Yan, Zheng wrote:
> The recent series of patches that add "wait on async xxxx" at various
> places do not seem correct. The correct fix should make mds avoid any
> wait when handling async requests.
>=20
>=20
> On Wed, Jun 8, 2022 at 12:56 PM Jeff Layton <jlayton@kernel.org> wrote:
> >=20
> > Currently, we'll call ceph_check_caps, but if we're still waiting on th=
e
> > reply, we'll end up spinning around on the same inode in
> > flush_dirty_session_caps. Wait for the async create reply before
> > flushing caps.
> >=20
> > Fixes: fbed7045f552 (ceph: wait for async create reply before sending a=
ny cap messages)
> > URL: https://tracker.ceph.com/issues/55823
> > Signed-off-by: Jeff Layton <jlayton@kernel.org>
> > ---
> >  fs/ceph/caps.c | 1 +
> >  1 file changed, 1 insertion(+)
> >=20
> > I don't know if this will fix the tx queue stalls completely, but I
> > haven't seen one with this patch in place. I think it makes sense on it=
s
> > own, either way.
> >=20
> > diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
> > index 0a48bf829671..5ecfff4b37c9 100644
> > --- a/fs/ceph/caps.c
> > +++ b/fs/ceph/caps.c
> > @@ -4389,6 +4389,7 @@ static void flush_dirty_session_caps(struct ceph_=
mds_session *s)
> >                 ihold(inode);
> >                 dout("flush_dirty_caps %llx.%llx\n", ceph_vinop(inode))=
;
> >                 spin_unlock(&mdsc->cap_dirty_lock);
> > +               ceph_wait_on_async_create(inode);
> >                 ceph_check_caps(ci, CHECK_CAPS_FLUSH, NULL);
> >                 iput(inode);
> >                 spin_lock(&mdsc->cap_dirty_lock);
> > --
> > 2.36.1
> >=20

--=20
Jeff Layton <jlayton@kernel.org>
