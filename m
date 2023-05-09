Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 54A5F6FC8AF
	for <lists+ceph-devel@lfdr.de>; Tue,  9 May 2023 16:18:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235767AbjEIOSb (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 9 May 2023 10:18:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235510AbjEIOSa (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 9 May 2023 10:18:30 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A33D619B0;
        Tue,  9 May 2023 07:18:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 34FC262706;
        Tue,  9 May 2023 14:18:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59E21C4339B;
        Tue,  9 May 2023 14:18:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1683641898;
        bh=yKY4SWARzwjBVi5CTsD6jQ5cnBZuY6uA1YF20AMx5rE=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=epEIbkTecjghcrsKdYFaTozfo5XAZiXIbo8ZKuElG0uwlhmTZs3hq2vzEClX90mg7
         vPeir0x7aQD2trL7MgF3+BzXqM9SXUVi1v21xkfwnZrOFV62WnCQRq3a3/j5R27+hd
         LLK8IofBW9cMxs5O6djoxfL7UwxVkCkJDR9gCqG0ib0og53ZG90QjwwO50ekVBNElu
         oaEyfnkbPKy9Q6y1+0ErGup19zm+Q0F6qH+IhCBm74pB1s5N3QVVr0azan/GUSFJfC
         1uH/lkLDex4yc9XRG337fZIUbT5WWkcsEmakHkgoOrzzCXpnlNUkrWnpaiDDJV/nD3
         CSP7K+cS/SOkA==
Message-ID: <abac46a83389b33d352e9d6fa35ea2b386e4cea2.camel@kernel.org>
Subject: Re: [PATCH v4] ceph: fix blindly expanding the readahead windows
From:   Jeff Layton <jlayton@kernel.org>
To:     xiubli@redhat.com, idryomov@gmail.com, ceph-devel@vger.kernel.org
Cc:     vshankar@redhat.com, stable@vger.kernel.org,
        Hu Weiwen <sehuww@mail.scut.edu.cn>,
        Steve French <smfrench@gmail.com>
Date:   Tue, 09 May 2023 07:18:17 -0700
In-Reply-To: <20230509005703.155321-1-xiubli@redhat.com>
References: <20230509005703.155321-1-xiubli@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.48.1 (3.48.1-1.module_f38+16663+080ec715) 
MIME-Version: 1.0
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Tue, 2023-05-09 at 08:57 +0800, xiubli@redhat.com wrote:
> From: Xiubo Li <xiubli@redhat.com>
>=20
> Blindly expanding the readahead windows will cause unneccessary
> pagecache thrashing and also will introdue the network workload.
> We should disable expanding the windows if the readahead is disabled
> and also shouldn't expand the windows too much.
>=20
> Expanding forward firstly instead of expanding backward for possible
> sequential reads.
>=20
> Bound `rreq->len` to the actual file size to restore the previous page
> cache usage.
>=20
> Cc: stable@vger.kernel.org
> Fixes: 49870056005c ("ceph: convert ceph_readpages to ceph_readahead")
> URL: https://lore.kernel.org/ceph-devel/20230504082510.247-1-sehuww@mail.=
scut.edu.cn
> URL: https://www.spinics.net/lists/ceph-users/msg76183.html
> Cc: Hu Weiwen <sehuww@mail.scut.edu.cn>
> Signed-off-by: Xiubo Li <xiubli@redhat.com>
> ---
>=20
> V4:
> - two small cleanup from Ilya's comments. Thanks
>=20
>=20

(cc'ing Steve French since he was asking me about ceph readahead
yesterday)

FWIW, the original idea here was to try to read whole OSD objects when
we can. I can see that that may have been overzealous though, so
ramping up the size more slowly makes sense.

>  fs/ceph/addr.c | 28 +++++++++++++++++++++-------
>  1 file changed, 21 insertions(+), 7 deletions(-)
>=20
> diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
> index ca4dc6450887..683ba9fbd590 100644
> --- a/fs/ceph/addr.c
> +++ b/fs/ceph/addr.c
> @@ -188,16 +188,30 @@ static void ceph_netfs_expand_readahead(struct netf=
s_io_request *rreq)
>  	struct inode *inode =3D rreq->inode;
>  	struct ceph_inode_info *ci =3D ceph_inode(inode);
>  	struct ceph_file_layout *lo =3D &ci->i_layout;
> +	unsigned long max_pages =3D inode->i_sb->s_bdi->ra_pages;
> +	unsigned long max_len =3D max_pages << PAGE_SHIFT;
> +	loff_t end =3D rreq->start + rreq->len, new_end;
>  	u32 blockoff;
> -	u64 blockno;
> =20
> -	/* Expand the start downward */
> -	blockno =3D div_u64_rem(rreq->start, lo->stripe_unit, &blockoff);
> -	rreq->start =3D blockno * lo->stripe_unit;
> -	rreq->len +=3D blockoff;
> +	/* Readahead is disabled */
> +	if (!max_pages)
> +		return;
> =20
> -	/* Now, round up the length to the next block */
> -	rreq->len =3D roundup(rreq->len, lo->stripe_unit);
> +	/*
> +	 * Try to expand the length forward by rounding  up it to the next
> +	 * block, but do not exceed the file size, unless the original
> +	 * request already exceeds it.
> +	 */

Do you really need to clamp this to the i_size? Is it ever possible for
the client to be out of date as to the real file size? If so then you
might end up with a short read when there is actually more data.

I guess by doing this, you're trying to avoid having to call the OSD
back after a short read and get a zero-length read when the file is
shorter than the requested read?

> +	new_end =3D min(round_up(end, lo->stripe_unit), rreq->i_size);
> +	if (new_end > end && new_end <=3D rreq->start + max_len)
> +		rreq->len =3D new_end - rreq->start;
> +
> +	/* Try to expand the start downward */
> +	div_u64_rem(rreq->start, lo->stripe_unit, &blockoff);
> +	if (rreq->len + blockoff <=3D max_len) {
> +		rreq->start -=3D blockoff;
> +		rreq->len +=3D blockoff;
> +	}
>  }
> =20
>  static bool ceph_netfs_clamp_length(struct netfs_io_subrequest *subreq)

--=20
Jeff Layton <jlayton@kernel.org>
