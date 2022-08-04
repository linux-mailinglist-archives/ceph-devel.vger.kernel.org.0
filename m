Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 320BE589F5F
	for <lists+ceph-devel@lfdr.de>; Thu,  4 Aug 2022 18:25:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233114AbiHDQZk (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 4 Aug 2022 12:25:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236941AbiHDQZg (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 4 Aug 2022 12:25:36 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F8D31FD
        for <ceph-devel@vger.kernel.org>; Thu,  4 Aug 2022 09:25:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C1AC1614A3
        for <ceph-devel@vger.kernel.org>; Thu,  4 Aug 2022 16:25:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5CD8C433C1;
        Thu,  4 Aug 2022 16:25:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659630335;
        bh=BtD+Jt9g9KlglP46qjU9/G3kt6WcT6WYhN3V/xI6Cmw=;
        h=Subject:From:To:Date:In-Reply-To:References:From;
        b=TnhA0krda5KehJ8G83Wt20GzipsavsSNJUYrsFooHquOWEl7NpsJUWLeigXM/GrAp
         A9db0ZAjApCRRNLnRz7S2Vv4z/1SIc1lmO3VuX9vOEIeRwLD/I9Sq2M0tHTL3qOQCh
         H3MxjDD34M8ED3AXuh3SWKKO4mY4qrFOUW3r1tadvKLBESSwAK6AsAj9mYeyQ6ZinW
         k8BIXFPQo9saa67TddRlB2PmTQhZUS4MxSXUeXSnNxYSEART2mWyEkck7EwnBIlLbo
         tKXBoH4D+T3UJ1fNOYh4dR9sVzmiy2gf5OxIZPBtj9DtnEx+HvNMmp8mor+DTfKUnD
         V1P+PeHzgKhUQ==
Message-ID: <afbd8615b4bb651c505c933576350a8afa082e41.camel@kernel.org>
Subject: Re: [PATCH] ceph: fail the open_by_handle_at() if the dentry is
 being unlinked
From:   Jeff Layton <jlayton@kernel.org>
To:     xiubli@redhat.com, ceph-devel@vger.kernel.org
Date:   Thu, 04 Aug 2022 12:25:32 -0400
In-Reply-To: <20220804080624.14768-1-xiubli@redhat.com>
References: <20220804080624.14768-1-xiubli@redhat.com>
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

On Thu, 2022-08-04 at 16:06 +0800, xiubli@redhat.com wrote:
> From: Xiubo Li <xiubli@redhat.com>
>=20
> When unlinking a file the kclient will send a unlink request to MDS
> by holding the dentry reference, and then the MDS will return 2 replies,
> which are unsafe reply and a deferred safe reply.
>=20
> After the unsafe reply received the kernel will return and succeed
> the unlink request to user space apps.
>=20
> Only when the safe reply received the dentry's reference will be
> released. Or the dentry will only be unhashed from dcache. But when
> the open_by_handle_at() begins to open the unlinked files it will
> succeed.
>=20
> URL: https://tracker.ceph.com/issues/56524
> Signed-off-by: Xiubo Li <xiubli@redhat.com>
> ---
>  fs/ceph/export.c | 11 ++++++++++-
>  1 file changed, 10 insertions(+), 1 deletion(-)
>=20
> diff --git a/fs/ceph/export.c b/fs/ceph/export.c
> index 0ebf2bd93055..7d2ae977b8c9 100644
> --- a/fs/ceph/export.c
> +++ b/fs/ceph/export.c
> @@ -182,6 +182,7 @@ struct inode *ceph_lookup_inode(struct super_block *s=
b, u64 ino)
>  static struct dentry *__fh_to_dentry(struct super_block *sb, u64 ino)
>  {
>  	struct inode *inode =3D __lookup_inode(sb, ino);
> +	struct dentry *dentry;
>  	int err;
> =20
>  	if (IS_ERR(inode))
> @@ -197,7 +198,15 @@ static struct dentry *__fh_to_dentry(struct super_bl=
ock *sb, u64 ino)
>  		iput(inode);
>  		return ERR_PTR(-ESTALE);
>  	}
> -	return d_obtain_alias(inode);
> +
> +	/* -ESTALE if the dentry is unhashed, which should being released */
> +	dentry =3D d_obtain_alias(inode);
> +	if (d_unhashed(dentry)) {
> +		dput(dentry);
> +		return ERR_PTR(-ESTALE);
> +	}
> +
> +	return dentry;
>  }
> =20
>  static struct dentry *__snapfh_to_dentry(struct super_block *sb,

Reviewed-by: Jeff Layton <jlayton@kernel.org>
