Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 28E5553E6B7
	for <lists+ceph-devel@lfdr.de>; Mon,  6 Jun 2022 19:07:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236891AbiFFM0H (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 6 Jun 2022 08:26:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236886AbiFFM0G (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 6 Jun 2022 08:26:06 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90D5E2A3B94
        for <ceph-devel@vger.kernel.org>; Mon,  6 Jun 2022 05:26:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2D20C60FA4
        for <ceph-devel@vger.kernel.org>; Mon,  6 Jun 2022 12:26:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FDEBC34119;
        Mon,  6 Jun 2022 12:26:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654518364;
        bh=fzYsTRTT3Gz8f67dLkLievzQ/0wE2Pxv/XZ3OQb/9sg=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=m2WeHxIS81/OgAj9L7q6UW4AZ9BEk+ZVCWxEXth7NhllD84ZJmjZetlcgHdsxnZbc
         inFtyX13UV8FD2lTHE7Sj2+w9GmUm7P6DadlBgssZZ2fWcXs7Y+bF2F7oXb1XxN9Ve
         WvnwACLP8obkcWlvUeVBNesVqFa/2ETQwTx3g8fDHzSKMf1Pl2N17Y0BKpH8nwHJXl
         Bo+wNqHqVZpx+J2cLxJV088NOAu/aLgW4oRqUKupRwAh4Y/n54oU6LGixSusEgUBzp
         dzfprsfGjNgSjwl3E063o8YjnzhVRlyhfsWoYMhkIHWkW/7Iu9gLzcf/iovIz9T0CZ
         eKSVouhNF5U9g==
Message-ID: <660e7d7382715af210af3293942b4f6ada0d4341.camel@kernel.org>
Subject: Re: [PATCH] ceph: fix the incorrect comment for the ceph_mds_caps
 struct
From:   Jeff Layton <jlayton@kernel.org>
To:     Xiubo Li <xiubli@redhat.com>, idryomov@gmail.com
Cc:     lhenriques@suse.de, vshankar@redhat.com, ceph-devel@vger.kernel.org
Date:   Mon, 06 Jun 2022 08:26:02 -0400
In-Reply-To: <20220606122425.316004-1-xiubli@redhat.com>
References: <20220606122425.316004-1-xiubli@redhat.com>
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

On Mon, 2022-06-06 at 20:24 +0800, Xiubo Li wrote:
> The incorrect comment is misleading. Acutally the last members
> in ceph_mds_caps strcut is a union for none export and export
> bodies.
>=20
> Signed-off-by: Xiubo Li <xiubli@redhat.com>
> ---
>  include/linux/ceph/ceph_fs.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/include/linux/ceph/ceph_fs.h b/include/linux/ceph/ceph_fs.h
> index 86bf82dbd8b8..24622ecb9900 100644
> --- a/include/linux/ceph/ceph_fs.h
> +++ b/include/linux/ceph/ceph_fs.h
> @@ -768,7 +768,7 @@ struct ceph_mds_caps {
>  	__le32 xattr_len;
>  	__le64 xattr_version;
> =20
> -	/* filelock */
> +	/* a union of none export and export bodies. */

Also confusing :)

I think you mean "a union of non-export and export bodies."

>  	__le64 size, max_size, truncate_size;
>  	__le32 truncate_seq;
>  	struct ceph_timespec mtime, atime, ctime;

--=20
Jeff Layton <jlayton@kernel.org>
