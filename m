Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B410B53FEC6
	for <lists+ceph-devel@lfdr.de>; Tue,  7 Jun 2022 14:29:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242589AbiFGM3g (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 7 Jun 2022 08:29:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243707AbiFGM3f (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 7 Jun 2022 08:29:35 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5799A2043
        for <ceph-devel@vger.kernel.org>; Tue,  7 Jun 2022 05:29:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 548F861771
        for <ceph-devel@vger.kernel.org>; Tue,  7 Jun 2022 12:29:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60B12C385A5;
        Tue,  7 Jun 2022 12:29:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654604973;
        bh=TY6bJXwJFJ/ErRVQ+lA/MiKEGQACUTxfmBCZB36qFYw=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=jiIl/B2V+CyoxvcFkBgIu5Bq0Y609AVU0fmujldNV4P57tWR8b7NQ93by/ZDYiXk3
         2Pw18syyG1WNWyM2UXiSPU/lpyG4wvT5+8H1tOqKyXo7lGPNiTsRlNuk484+YpW/Ui
         Up1sQvSQOKZmtyD5m/SR4zKR3gPLwKiZphzsEBzpBtH2nYZsylg9qKw310k7Seholw
         5MUWsMmggRyLOw+SQmxRtW/hoRFiU5SfemJEqYuj3ZfXsHdjkWlUZoOAAZsEP4f36n
         rlDZAiA9auIR6uNDijUD9iJ/nuy61bcoO/TfnIQF4YwPYX46LCBADx4VMxFA8D/7DK
         FoVGX5toLc9iQ==
Message-ID: <fbba8ab7a86b18a4a2b6aadb538c0bd2c71591dd.camel@kernel.org>
Subject: Re: [PATCH] ceph: don't take inode lock in llseek
From:   Jeff Layton <jlayton@kernel.org>
To:     Xiubo Li <xiubli@redhat.com>
Cc:     idryomov@gmail.com, ceph-devel@vger.kernel.org
Date:   Tue, 07 Jun 2022 08:29:31 -0400
In-Reply-To: <363c9909-5f62-82ec-2008-73689435c12d@redhat.com>
References: <20220607112712.18023-1-jlayton@kernel.org>
         <363c9909-5f62-82ec-2008-73689435c12d@redhat.com>
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.2 (3.44.2-1.fc36) 
MIME-Version: 1.0
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Tue, 2022-06-07 at 20:23 +0800, Xiubo Li wrote:
> On 6/7/22 7:27 PM, Jeff Layton wrote:
> > There's no reason we need to lock the inode for write in order to handl=
e
> > an llseek. I suspect this should have been dropped in 2013 when we
> > stopped doing vmtruncate in llseek.
> >=20
> > Fixes: b0d7c2231015 (ceph: introduce i_truncate_mutex)
> > Signed-off-by: Jeff Layton <jlayton@kernel.org>
> > ---
> >   fs/ceph/file.c | 3 ---
> >   1 file changed, 3 deletions(-)
> >=20
> > diff --git a/fs/ceph/file.c b/fs/ceph/file.c
> > index 0c13a3f23c99..7d2e9615614d 100644
> > --- a/fs/ceph/file.c
> > +++ b/fs/ceph/file.c
> > @@ -1994,8 +1994,6 @@ static loff_t ceph_llseek(struct file *file, loff=
_t offset, int whence)
> >   	loff_t i_size;
> >   	loff_t ret;
> >  =20
> > -	inode_lock(inode);
> > -
> >   	if (whence =3D=3D SEEK_END || whence =3D=3D SEEK_DATA || whence =3D=
=3D SEEK_HOLE) {
> >   		ret =3D ceph_do_getattr(inode, CEPH_STAT_CAP_SIZE, false);
> >   		if (ret < 0)
> > @@ -2038,7 +2036,6 @@ static loff_t ceph_llseek(struct file *file, loff=
_t offset, int whence)
> >   	ret =3D vfs_setpos(file, offset, max(i_size, fsc->max_file_size));
> >  =20
> >   out:
> > -	inode_unlock(inode);
> >   	return ret;
> >   }
> >  =20
>=20
> Looks good.
>=20
> It seems the 'out' lable makes no sense anymore ?
>=20
> -- Xiubo
>=20

No, it's still used if the getattr errors out.
--=20
Jeff Layton <jlayton@kernel.org>
