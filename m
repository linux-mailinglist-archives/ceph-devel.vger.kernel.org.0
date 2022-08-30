Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD4EF5A60B0
	for <lists+ceph-devel@lfdr.de>; Tue, 30 Aug 2022 12:24:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230345AbiH3KXX (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 30 Aug 2022 06:23:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230331AbiH3KXC (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 30 Aug 2022 06:23:02 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 044055EDE2
        for <ceph-devel@vger.kernel.org>; Tue, 30 Aug 2022 03:22:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 74514B819D6
        for <ceph-devel@vger.kernel.org>; Tue, 30 Aug 2022 10:22:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3BF1C433D6;
        Tue, 30 Aug 2022 10:22:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661854956;
        bh=BOtsDmZmJiDQ1rtywQmMMYVdhn/U6bJjAVVtVy68mlc=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=WApguN8GgVFNFpmPwX90KjzgiD+rXkzNemC8HZQ3mSLvLNFuDEHLeaoQ4iVpESZiz
         SaUn8Y2qPnfG9I5GftgM0EAnPGFvxS2BmUM+QuZzatOsm8alD4EsUTZwem0XiexCxM
         7WkDpCmOsSZIFcxAVoIK8H20tRmfIZvWDkOdsdlsvSlNkVI8TCxlmHcn9nio4Ri8vp
         iNisN8cXp1EABhrBiaShxTJbWfVC+pfnjEQpvCPV4RA2f3fI06dqrsp0J1JplFvwwZ
         o5RC7cd9B0hJ6GRzc3b+eF1rdSxuIe7Q+gy86cEYz6GB2eQqvfAoYDo1CDguXS8egx
         Z5t+zDezaAARg==
Message-ID: <fb60cefa8b767ad0fa3b542cd881cc4dc6a8c733.camel@kernel.org>
Subject: Re: [PATCH v2] ceph: fail the open_by_handle_at() if the dentry is
 being unlinked
From:   Jeff Layton <jlayton@kernel.org>
To:     Xiubo Li <xiubli@redhat.com>, ceph-devel@vger.kernel.org
Cc:     idryomov@gmail.com
Date:   Tue, 30 Aug 2022 06:22:34 -0400
In-Reply-To: <68425412-d0c7-6f6f-8982-8c18add75c9e@redhat.com>
References: <20220829045728.488148-1-xiubli@redhat.com>
         <7ae458b7a4000ae6c4ee59dc6f0373490c9d7381.camel@kernel.org>
         <68425412-d0c7-6f6f-8982-8c18add75c9e@redhat.com>
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

On Tue, 2022-08-30 at 10:30 +0800, Xiubo Li wrote:
> On 8/30/22 2:17 AM, Jeff Layton wrote:
> > On Mon, 2022-08-29 at 12:57 +0800, xiubli@redhat.com wrote:
> > > From: Xiubo Li <xiubli@redhat.com>
> > >=20
> > > When unlinking a file the kclient will send a unlink request to MDS
> > > by holding the dentry reference, and then the MDS will return 2 repli=
es,
> > > which are unsafe reply and a deferred safe reply.
> > >=20
> > > After the unsafe reply received the kernel will return and succeed
> > > the unlink request to user space apps.
> > >=20
> > > Only when the safe reply received the dentry's reference will be
> > > released. Or the dentry will only be unhashed from dcache. But when
> > > the open_by_handle_at() begins to open the unlinked files it will
> > > succeed.
> > >=20
> > > URL: https://tracker.ceph.com/issues/56524
> > > Signed-off-by: Xiubo Li <xiubli@redhat.com>
> > > ---
> > >=20
> > > V2:
> > > - If the dentry was released and inode is evicted such as by dropping
> > >    the caches, it will allocate a new dentry, which is also unhashed.
> > >=20
> > >=20
> > >   fs/ceph/export.c | 17 ++++++++++++++++-
> > >   1 file changed, 16 insertions(+), 1 deletion(-)
> > >=20
> > > diff --git a/fs/ceph/export.c b/fs/ceph/export.c
> > > index 0ebf2bd93055..5edc1d31cd79 100644
> > > --- a/fs/ceph/export.c
> > > +++ b/fs/ceph/export.c
> > > @@ -182,6 +182,7 @@ struct inode *ceph_lookup_inode(struct super_bloc=
k *sb, u64 ino)
> > >   static struct dentry *__fh_to_dentry(struct super_block *sb, u64 in=
o)
> > >   {
> > >   	struct inode *inode =3D __lookup_inode(sb, ino);
> > > +	struct dentry *dentry;
> > >   	int err;
> > >  =20
> > >   	if (IS_ERR(inode))
> > > @@ -197,7 +198,21 @@ static struct dentry *__fh_to_dentry(struct supe=
r_block *sb, u64 ino)
> > >   		iput(inode);
> > >   		return ERR_PTR(-ESTALE);
> > >   	}
> > > -	return d_obtain_alias(inode);
> > > +
> > > +	/*
> > > +	 * -ESTALE if the dentry exists and is unhashed,
> > > +	 * which should be being released
> > > +	 */
> > > +	dentry =3D d_find_any_alias(inode);
> > > +	if (dentry && unlikely(d_unhashed(dentry))) {
> > > +		dput(dentry);
> > > +		return ERR_PTR(-ESTALE);
> > > +	}
> > > +
> > > +	if (!dentry)
> > > +		dentry =3D d_obtain_alias(inode);
> > > +
> > > +	return dentry;
> > >   }
> > >  =20
> > >   static struct dentry *__snapfh_to_dentry(struct super_block *sb,
> > This looks racy.
> >=20
> > Suppose we have 2 racing tasks calling __fh_to_dentry for the same
> > inode. The first one races in and doesn't find anything. d_obtain alias
> > creates a disconnected dentry and returns it. The next task then finds
> > it, sees that it's disconnected and gets back -ESTALE.
> >=20
> > I think you may need to detect this situation in a different way.
>=20
> Yeah, you're right. Locally I have another version of patch, which will=
=20
> add one di->flags bit, which is "CEPH_DENTRY_IS_UNLINKING".
>=20
> If the file have hard links and there are more than one alias and one of=
=20
> them is being unlinked, shouldn't we make sure we will pick a normal one=
=20
> here ? If so we should iterate all the alias and filter out the being=20
> unlinked ones.
>=20

Possibly. Another option might be to try to catch this in the open
codepath instead. Test whether the dentry you're trying to open has the
IS_UNLINKING flag set, and return -ESTALE on open if so.

If the problem goes beyond open though, then that may not be sufficient.

> At the same time I found another issue for the "ceph_fh_to_dentry()".=20
> That is we never check the inode->i_generation like other filesystems,=
=20
> which will make sure the inode we are trying to open is the exactly the=
=20
> same one saved in userspace. The inode maybe deleted and created before=
=20
> this.
>=20
> Thanks
>=20
> Xiubo
>=20
>=20

--=20
Jeff Layton <jlayton@kernel.org>
