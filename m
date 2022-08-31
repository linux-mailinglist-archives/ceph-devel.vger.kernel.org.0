Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F2EDC5A7CA3
	for <lists+ceph-devel@lfdr.de>; Wed, 31 Aug 2022 13:57:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230105AbiHaL5C (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 31 Aug 2022 07:57:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230106AbiHaL5B (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 31 Aug 2022 07:57:01 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D2D1D275B
        for <ceph-devel@vger.kernel.org>; Wed, 31 Aug 2022 04:56:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id B5F9FCE2064
        for <ceph-devel@vger.kernel.org>; Wed, 31 Aug 2022 11:56:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7632EC433D6;
        Wed, 31 Aug 2022 11:56:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661947015;
        bh=Wn2THyoqFdjahecfDulVGJHPWdXVRdhDhtjYR45QNx8=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=AZEqvKGQsdoUUFSHadgUfNISYkhWVeBqVbsds4XxGX74uFyQWUUZrOBfKoAM9l2nE
         +IGNM9zIQH0li7KhQWyzoDn6iqyOQ+Cetmd7dKfgsgQTiV5yItkcnSUGihwCs2T72T
         bsZQsll8BrPUWIAAZteLZPa8S+4tiu/fNqUb03vggbdfUJOqep5nziOpNA7jGJ+7yH
         6Lcxr0/oV9lGm/oCWh9qr2s8o8iPPwJuUwDSkLPWY0zrUgAI8DkAcUWL+b7ifoSltM
         mtr9vscCr7vKQt8sBFftpqCD1dQMrM8OXvVZtvwnwR7lTvfpbw63eRej1P/XZwhQ2Z
         yOtAkDBY40Kbw==
Message-ID: <ea330c9f25f1e209ed35bd50e075b0a98e6eceaa.camel@kernel.org>
Subject: Re: [PATCH v3] ceph: fail the open_by_handle_at() if the dentry is
 being unlinked
From:   Jeff Layton <jlayton@kernel.org>
To:     xiubli@redhat.com, ceph-devel@vger.kernel.org
Cc:     idryomov@gmail.com, lhenriques@suse.de, mchangir@redhat.com
Date:   Wed, 31 Aug 2022 07:56:52 -0400
In-Reply-To: <20220831021617.11058-1-xiubli@redhat.com>
References: <20220831021617.11058-1-xiubli@redhat.com>
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

On Wed, 2022-08-31 at 10:16 +0800, xiubli@redhat.com wrote:
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
> The inode->i_count couldn't be used to check whether the inode is
> opened or not.
>=20
> URL: https://tracker.ceph.com/issues/56524
> Signed-off-by: Xiubo Li <xiubli@redhat.com>
> ---
>=20
> V3:
> - The inode->i_count couldn't be correctly indicate that whether the
>   file is opened or not.
>=20
> V2:
> - If the dentry was released and inode is evicted such as by dropping
>   the caches, it will allocate a new dentry, which is also unhashed.
>=20
>  fs/ceph/export.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>=20
> diff --git a/fs/ceph/export.c b/fs/ceph/export.c
> index 0ebf2bd93055..8559990a59a5 100644
> --- a/fs/ceph/export.c
> +++ b/fs/ceph/export.c
> @@ -182,6 +182,7 @@ struct inode *ceph_lookup_inode(struct super_block *s=
b, u64 ino)
>  static struct dentry *__fh_to_dentry(struct super_block *sb, u64 ino)
>  {
>  	struct inode *inode =3D __lookup_inode(sb, ino);
> +	struct ceph_inode_info *ci =3D ceph_inode(inode);
>  	int err;
> =20
>  	if (IS_ERR(inode))
> @@ -193,7 +194,7 @@ static struct dentry *__fh_to_dentry(struct super_blo=
ck *sb, u64 ino)
>  		return ERR_PTR(err);
>  	}
>  	/* -ESTALE if inode as been unlinked and no file is open */
> -	if ((inode->i_nlink =3D=3D 0) && (atomic_read(&inode->i_count) =3D=3D 1=
)) {
> +	if ((inode->i_nlink =3D=3D 0) && !__ceph_is_file_opened(ci)) {
>  		iput(inode);
>  		return ERR_PTR(-ESTALE);
>  	}

Looks reasonable

Reviewed-by: Jeff Layton <jlayton@kernel.org>
