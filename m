Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8B4E49CF9F
	for <lists+ceph-devel@lfdr.de>; Wed, 26 Jan 2022 17:25:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236694AbiAZQZf (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 26 Jan 2022 11:25:35 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:45888 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236441AbiAZQZf (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 26 Jan 2022 11:25:35 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 19A21B81978
        for <ceph-devel@vger.kernel.org>; Wed, 26 Jan 2022 16:25:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77197C340E3;
        Wed, 26 Jan 2022 16:25:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643214332;
        bh=w/fmPR0VpQFNn1a28XmCmiXWJb2hihbEHZH5Fz7bC5o=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=SoLHg3rVkUDFZzg2ZKKI/VOQHsjdjZX7K7Ju5SfRiS+mOSSCnWMh/Ewprm04up/rX
         A6b9h+wcYNTnWZ2+hFoWMUMseTH/yozTaexJ3A8hQm2gzmBiOogCwwD5GPMwaHwK/5
         x0G50kvx7oP+IpOSAQ7Qy2OQZRlrwOI9Fk6MVMnyt8AY3hmMaZCNnyVEI3HvVxnOqo
         zGsF/z5yZ+jdQt5yc3hJxM7m35OSfDwDIEgxhipiNKiDWiVCXBd2IFtIMFduBoanpZ
         puCU+ZBsVdD4VSq8+sBBBJKOoQLojzKhzb1lbkVVjKZgmdhn4n0aaxrtQP8aAesg24
         as5D0KaLRTnfA==
Message-ID: <b886282e58dfcda09e4d9336c60b2732c4c9764c.camel@kernel.org>
Subject: Re: [PATCH] ceph: properly put ceph_string reference after async
 create attempt
From:   Jeff Layton <jlayton@kernel.org>
To:     Ilya Dryomov <idryomov@gmail.com>
Cc:     Ceph Development <ceph-devel@vger.kernel.org>
Date:   Wed, 26 Jan 2022 11:25:31 -0500
In-Reply-To: <CAOi1vP8zhO4omTv2eVb43KbsqL4iqxi9FW55K7cXi8ue-NuUKQ@mail.gmail.com>
References: <20220125210842.114067-1-jlayton@kernel.org>
         <CAOi1vP8zhO4omTv2eVb43KbsqL4iqxi9FW55K7cXi8ue-NuUKQ@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
User-Agent: Evolution 3.42.3 (3.42.3-1.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Wed, 2022-01-26 at 17:22 +0100, Ilya Dryomov wrote:
> On Tue, Jan 25, 2022 at 10:08 PM Jeff Layton <jlayton@kernel.org> wrote:
> > 
> > The reference acquired by try_prep_async_create is currently leaked.
> > Ensure we put it.
> > 
> > Fixes: 9a8d03ca2e2c ("ceph: attempt to do async create when possible")
> > Signed-off-by: Jeff Layton <jlayton@kernel.org>
> > ---
> >  fs/ceph/file.c | 2 ++
> >  1 file changed, 2 insertions(+)
> > 
> > diff --git a/fs/ceph/file.c b/fs/ceph/file.c
> > index ea1e9ac6c465..cbe4d5a5cde5 100644
> > --- a/fs/ceph/file.c
> > +++ b/fs/ceph/file.c
> > @@ -766,8 +766,10 @@ int ceph_atomic_open(struct inode *dir, struct dentry *dentry,
> >                                 restore_deleg_ino(dir, req->r_deleg_ino);
> >                                 ceph_mdsc_put_request(req);
> >                                 try_async = false;
> > +                               ceph_put_string(rcu_dereference_raw(lo.pool_ns));
> >                                 goto retry;
> >                         }
> > +                       ceph_put_string(rcu_dereference_raw(lo.pool_ns));
> >                         goto out_req;
> >                 }
> >         }
> > --
> > 2.34.1
> > 
> 
> Hi Jeff,
> 
> Where is the try_prep_async_create() reference put in case of success?
> It doesn't look like ceph_finish_async_create() actually consumes it.
> 

The second call above puts it in the case of success, or in the case of
any error that isn't -EJUKEBOX.
-- 
Jeff Layton <jlayton@kernel.org>
