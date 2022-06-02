Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C56553BC1C
	for <lists+ceph-devel@lfdr.de>; Thu,  2 Jun 2022 18:09:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235132AbiFBQIe (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 2 Jun 2022 12:08:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232051AbiFBQId (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 2 Jun 2022 12:08:33 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC60B186281
        for <ceph-devel@vger.kernel.org>; Thu,  2 Jun 2022 09:08:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 65497B81F1B
        for <ceph-devel@vger.kernel.org>; Thu,  2 Jun 2022 16:08:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCDA5C385A5;
        Thu,  2 Jun 2022 16:08:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654186110;
        bh=nNHlMuHUYySO09oRndEPH9dW8MMfHYTIrurWuDKRl50=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=qM2Tphv8LXU4W7OrxnXxNZo5BwDsgTJJmXBXpHfZAsN+nfhBGbvTFA4O7Z6cUuwVp
         5PpgXrMrGWqKMPQ3GAZ61CnWDPsBktQVsm9E4EGkKz55PtMZKJXFk6ztQdqrt2Vr5M
         4n3FcW3J9dqcWRb6tswJGkPNbWP0NCyb+RkazkK7f+ndAXDXVB7B9/jCeYaHSYb+mT
         MCVgSmyzwS7hkiuNycSdC6Z5BY6qns3mrAZxigg/jKd5e9Tv2mp5ZtL7r1nGK5Def5
         762P6d6q8AzbWnpCEF/AqZYlV/7/7v7gIbpcJISiNCXnZZZY/GKdcEgydYDZY5j/qk
         ajmXzDTW3m1ig==
Message-ID: <5a4d4ca805797f745fb9885fcd8d8d6252db0787.camel@kernel.org>
Subject: Re: [PATCH v14 58/64] ceph: add encryption support to writepage
From:   Jeff Layton <jlayton@kernel.org>
To:     ceph-devel@vger.kernel.org
Cc:     xiubli@redhat.com, lhenriques@suse.de, idryomov@gmail.com
Date:   Thu, 02 Jun 2022 12:08:28 -0400
In-Reply-To: <20220427191314.222867-59-jlayton@kernel.org>
References: <20220427191314.222867-1-jlayton@kernel.org>
         <20220427191314.222867-59-jlayton@kernel.org>
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.1 (3.44.1-1.fc36) 
MIME-Version: 1.0
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Wed, 2022-04-27 at 15:13 -0400, Jeff Layton wrote:
> Allow writepage to issue encrypted writes. Extend out the requested size
> and offset to cover complete blocks, and then encrypt and write them to
> the OSDs.
>=20
> Signed-off-by: Jeff Layton <jlayton@kernel.org>
> ---
>  fs/ceph/addr.c | 34 +++++++++++++++++++++++++++-------
>  1 file changed, 27 insertions(+), 7 deletions(-)
>=20
> diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
> index d65d431ec933..f54940fc96ee 100644
> --- a/fs/ceph/addr.c
> +++ b/fs/ceph/addr.c
> @@ -586,10 +586,12 @@ static int writepage_nounlock(struct page *page, st=
ruct writeback_control *wbc)
>  	loff_t page_off =3D page_offset(page);
>  	int err;
>  	loff_t len =3D thp_size(page);
> +	loff_t wlen;
>  	struct ceph_writeback_ctl ceph_wbc;
>  	struct ceph_osd_client *osdc =3D &fsc->client->osdc;
>  	struct ceph_osd_request *req;
>  	bool caching =3D ceph_is_cache_enabled(inode);
> +	struct page *bounce_page =3D NULL;
> =20
>  	dout("writepage %p idx %lu\n", page, page->index);
> =20
> @@ -621,6 +623,8 @@ static int writepage_nounlock(struct page *page, stru=
ct writeback_control *wbc)
> =20
>  	if (ceph_wbc.i_size < page_off + len)
>  		len =3D ceph_wbc.i_size - page_off;
> +	if (IS_ENCRYPTED(inode))
> +		wlen =3D round_up(len, CEPH_FSCRYPT_BLOCK_SIZE);
> =20

The above is buggy. We're only setting "wlen" in the encrypted case. You
would think that the compiler would catch that, but next usage of wlen
just passes a pointer to it to another function and that cloaks the
warning.

Fixed in the wip-fscrypt branch, but I'll hold off on re-posting the
series in case any other new bugs turn up.

>  	dout("writepage %p page %p index %lu on %llu~%llu snapc %p seq %lld\n",
>  	     inode, page, page->index, page_off, len, snapc, snapc->seq);
> @@ -629,24 +633,39 @@ static int writepage_nounlock(struct page *page, st=
ruct writeback_control *wbc)
>  	    CONGESTION_ON_THRESH(fsc->mount_options->congestion_kb))
>  		fsc->write_congested =3D true;
> =20
> -	req =3D ceph_osdc_new_request(osdc, &ci->i_layout, ceph_vino(inode), pa=
ge_off, &len, 0, 1,
> -				    CEPH_OSD_OP_WRITE, CEPH_OSD_FLAG_WRITE, snapc,
> -				    ceph_wbc.truncate_seq, ceph_wbc.truncate_size,
> -				    true);
> +	req =3D ceph_osdc_new_request(osdc, &ci->i_layout, ceph_vino(inode),
> +				    page_off, &wlen, 0, 1, CEPH_OSD_OP_WRITE,
> +				    CEPH_OSD_FLAG_WRITE, snapc,
> +				    ceph_wbc.truncate_seq,
> +				    ceph_wbc.truncate_size, true);
>  	if (IS_ERR(req)) {
>  		redirty_page_for_writepage(wbc, page);
>  		return PTR_ERR(req);
>  	}
> =20
> +	if (wlen < len)
> +		len =3D wlen;
> +
>  	set_page_writeback(page);
>  	if (caching)
>  		ceph_set_page_fscache(page);
>  	ceph_fscache_write_to_cache(inode, page_off, len, caching);
> =20
> +	if (IS_ENCRYPTED(inode)) {
> +		bounce_page =3D fscrypt_encrypt_pagecache_blocks(page, CEPH_FSCRYPT_BL=
OCK_SIZE,
> +								0, GFP_NOFS);
> +		if (IS_ERR(bounce_page)) {
> +			err =3D PTR_ERR(bounce_page);
> +			goto out;
> +		}
> +	}
>  	/* it may be a short write due to an object boundary */
>  	WARN_ON_ONCE(len > thp_size(page));
> -	osd_req_op_extent_osd_data_pages(req, 0, &page, len, 0, false, false);
> -	dout("writepage %llu~%llu (%llu bytes)\n", page_off, len, len);
> +	osd_req_op_extent_osd_data_pages(req, 0,
> +			bounce_page ? &bounce_page : &page, wlen, 0,
> +			false, false);
> +	dout("writepage %llu~%llu (%llu bytes, %sencrypted)\n",
> +	     page_off, len, wlen, IS_ENCRYPTED(inode) ? "" : "not ");
> =20
>  	req->r_mtime =3D inode->i_mtime;
>  	err =3D ceph_osdc_start_request(osdc, req, true);
> @@ -655,7 +674,8 @@ static int writepage_nounlock(struct page *page, stru=
ct writeback_control *wbc)
> =20
>  	ceph_update_write_metrics(&fsc->mdsc->metric, req->r_start_latency,
>  				  req->r_end_latency, len, err);
> -
> +	fscrypt_free_bounce_page(bounce_page);
> +out:
>  	ceph_osdc_put_request(req);
>  	if (err =3D=3D 0)
>  		err =3D len;

--=20
Jeff Layton <jlayton@kernel.org>
