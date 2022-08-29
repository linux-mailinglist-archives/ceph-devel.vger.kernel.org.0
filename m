Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 63BF35A53DB
	for <lists+ceph-devel@lfdr.de>; Mon, 29 Aug 2022 20:17:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229624AbiH2SRU (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 29 Aug 2022 14:17:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229609AbiH2SRT (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 29 Aug 2022 14:17:19 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 383969C534
        for <ceph-devel@vger.kernel.org>; Mon, 29 Aug 2022 11:17:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D3186B80F00
        for <ceph-devel@vger.kernel.org>; Mon, 29 Aug 2022 18:17:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DE6BC433D6;
        Mon, 29 Aug 2022 18:17:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661797035;
        bh=dyLz4ggteSyJW8nG9XxBzqW0v/fm/YMj5tmbjk/Kg4g=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=ldaa+4FS4jwrsvv1JBiO017vaugOID7qQLSPoKH+xLK2ibPcjnpmc/5uXBsukWmwv
         4P2dHZaJD8+TLb2l6Ib4gEUobQwCzW3X+KCzoG6oFqRGTIJJpSRPHMTQMV92ZSFjLu
         Se4RPjsf/pSL9oaZcg/caKFqQftQUigf7CSQ/3k5Op5d1H1D4Y0wuSkmE3j+rFCudb
         /Qvj/p8DKbLhLax86pKzyC2f10mPWuxPVRtSvfEDZRMPJPX25Ij93u84HrZ2tQ65eg
         HIpItaWmjJS7+8JIMu0IeyDIgwg0NNoJf+Jrqz38hrPIZq8EW5M67LV+2I6I3ibEcc
         YwaroUvcxtcFw==
Message-ID: <7ae458b7a4000ae6c4ee59dc6f0373490c9d7381.camel@kernel.org>
Subject: Re: [PATCH v2] ceph: fail the open_by_handle_at() if the dentry is
 being unlinked
From:   Jeff Layton <jlayton@kernel.org>
To:     xiubli@redhat.com, ceph-devel@vger.kernel.org
Cc:     idryomov@gmail.com
Date:   Mon, 29 Aug 2022 14:17:13 -0400
In-Reply-To: <20220829045728.488148-1-xiubli@redhat.com>
References: <20220829045728.488148-1-xiubli@redhat.com>
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

On Mon, 2022-08-29 at 12:57 +0800, xiubli@redhat.com wrote:
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
>=20
> V2:
> - If the dentry was released and inode is evicted such as by dropping
>   the caches, it will allocate a new dentry, which is also unhashed.
>=20
>=20
>  fs/ceph/export.c | 17 ++++++++++++++++-
>  1 file changed, 16 insertions(+), 1 deletion(-)
>=20
> diff --git a/fs/ceph/export.c b/fs/ceph/export.c
> index 0ebf2bd93055..5edc1d31cd79 100644
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
> @@ -197,7 +198,21 @@ static struct dentry *__fh_to_dentry(struct super_bl=
ock *sb, u64 ino)
>  		iput(inode);
>  		return ERR_PTR(-ESTALE);
>  	}
> -	return d_obtain_alias(inode);
> +
> +	/*
> +	 * -ESTALE if the dentry exists and is unhashed,
> +	 * which should be being released
> +	 */
> +	dentry =3D d_find_any_alias(inode);
> +	if (dentry && unlikely(d_unhashed(dentry))) {
> +		dput(dentry);
> +		return ERR_PTR(-ESTALE);
> +	}
> +
> +	if (!dentry)
> +		dentry =3D d_obtain_alias(inode);
> +
> +	return dentry;
>  }
> =20
>  static struct dentry *__snapfh_to_dentry(struct super_block *sb,

This looks racy.

Suppose we have 2 racing tasks calling __fh_to_dentry for the same
inode. The first one races in and doesn't find anything. d_obtain alias
creates a disconnected dentry and returns it. The next task then finds
it, sees that it's disconnected and gets back -ESTALE.

I think you may need to detect this situation in a different way.
--=20
Jeff Layton <jlayton@kernel.org>
