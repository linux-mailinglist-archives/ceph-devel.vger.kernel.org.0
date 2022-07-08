Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6375E56B7D6
	for <lists+ceph-devel@lfdr.de>; Fri,  8 Jul 2022 12:57:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237557AbiGHK5b (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 8 Jul 2022 06:57:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237630AbiGHK53 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Fri, 8 Jul 2022 06:57:29 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A49DA88F07
        for <ceph-devel@vger.kernel.org>; Fri,  8 Jul 2022 03:57:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 65297B80189
        for <ceph-devel@vger.kernel.org>; Fri,  8 Jul 2022 10:57:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A814DC341C0;
        Fri,  8 Jul 2022 10:57:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657277846;
        bh=gKhI0Acw+oEcKc4REiQDxhp4Qc7kPu6UafyI8aogQpE=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=J726f1Ynm4GouEOlMNP3+KLdnbjvdO2LxDcZFOqaIMWqCjiB93ZEBHijgVDqDSeVY
         4Lbafvb1kiFCVW7NjMWAOVU9o6fTlKUYzbxpEMwzdKRS3UEyTrI2gtENqD2v0Iwk/V
         2fPVXinehILjH0ip253kXxjBISZ01RBbUrdyrNuKJd/kgZ12JLbcrpQYN36+vxwuuk
         J7Qm4eohqoGVDQUCdxWxit0Fq1MzHlLRc/BxnpMh4Qj/4iAqdoln7RvEK4ZiEKOLW/
         1eFvCZx6XwLgcDyUcMGPWTlJD2wJwDyUYDHEdQweRrqgZBuCbYcPqaMzPe2STl3mbF
         DaMuliKP7ZopA==
Message-ID: <ea91438a349390dd0daf8130f8fae18564f99f2f.camel@kernel.org>
Subject: Re: [PATCH wip-fscrypt] ceph: reset "err = 0" after
 iov_get_pages_alloc in ceph_netfs_issue_read
From:   Jeff Layton <jlayton@kernel.org>
To:     Xiubo Li <xiubli@redhat.com>
Cc:     dhowells@redhat.com, ceph-devel@vger.kernel.org, idryomov@gmail.com
Date:   Fri, 08 Jul 2022 06:57:24 -0400
In-Reply-To: <d5e9d800-750f-2422-8ff6-fe4eb2cd10bc@redhat.com>
References: <20220707140811.35155-1-jlayton@kernel.org>
         <d5e9d800-750f-2422-8ff6-fe4eb2cd10bc@redhat.com>
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.3 (3.44.3-1.fc36) 
MIME-Version: 1.0
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Fri, 2022-07-08 at 08:27 +0800, Xiubo Li wrote:
> On 7/7/22 10:08 PM, Jeff Layton wrote:
> > Currently, when we call ceph_netfs_issue_read for an encrypted inode,
> > we'll call iov_iter_get_pages_alloc and assign its result to "err".
> > Later we'll end up inappropriately calling netfs_subreq_terminated with
> > that value after submitting the request. Ensure we reset "err =3D 0;"
> > after calling iov_iter_get_pages_alloc.
> >=20
> > Signed-off-by: Jeff Layton <jlayton@kernel.org>
> > ---
> >   fs/ceph/addr.c | 1 +
> >   1 file changed, 1 insertion(+)
> >=20
> > Probably this should get squashed into the patch that adds fscrypt
> > support to buffered reads.
> >=20
> > diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
> > index c713b5491012..64facef79883 100644
> > --- a/fs/ceph/addr.c
> > +++ b/fs/ceph/addr.c
> > @@ -376,6 +376,7 @@ static void ceph_netfs_issue_read(struct netfs_io_s=
ubrequest *subreq)
> >   		/* should always give us a page-aligned read */
> >   		WARN_ON_ONCE(page_off);
> >   		len =3D err;
> > +		err =3D 0;
> >  =20
> >   		osd_req_op_extent_osd_data_pages(req, 0, pages, len, 0, false, fals=
e);
> >   	} else {
> Looks good. Thanks Jeff!
>=20
> Show we fold it into the previous patch ?
>=20
> -- Xiubo
>=20
>=20

Yes, please do.
--=20
Jeff Layton <jlayton@kernel.org>
