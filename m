Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 46785596CA7
	for <lists+ceph-devel@lfdr.de>; Wed, 17 Aug 2022 12:19:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233625AbiHQKRu (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 17 Aug 2022 06:17:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229752AbiHQKRt (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 17 Aug 2022 06:17:49 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB78958DCE
        for <ceph-devel@vger.kernel.org>; Wed, 17 Aug 2022 03:17:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 51D96613F7
        for <ceph-devel@vger.kernel.org>; Wed, 17 Aug 2022 10:17:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54373C43140;
        Wed, 17 Aug 2022 10:17:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660731467;
        bh=9zWm6y14IIEQH79LT1ch5BoqbRiITiPThNnvO5kLHZM=;
        h=Subject:From:To:Date:In-Reply-To:References:From;
        b=HbzKg1lTbQCY4P3pmoHMzZqzvz4t4sIPvTe/iEogdjqLKwplywtVEk1lh6UGQIOKi
         k6lOrfFAG8z1Si4hey5t85MCAQbqr942oQkFs1AooUeHmpdhi9DiCvZkp1DuMg8MVh
         +cfkMcmByXEkhpmRs2vLHs/QPhWPXUnLZ243NO1lJgfLNnd0QeOFbdUW0NSeIE9Xxn
         9iIXfgtA4sQYIb8mZ+b8e1PHFWF8d+0NdpsI/IB8q7P071R0i2Apbbq8myvOjx2XC7
         2RAB7pUT4RzPQcmWJRjvuC3NzKiA5z/9TRQKRyOYHQtiJtHnz50EC40pt1Yv46GHx/
         Fx4cgkYT1m6AA==
Message-ID: <a21d882df74b91738b56d8a289bb55a9dbe2bc34.camel@kernel.org>
Subject: Re: [PATCH] libceph: advancing variants of iov_iter_get_pages()
From:   Jeff Layton <jlayton@kernel.org>
To:     xiubli@redhat.com, idryomov@gmail.com, ceph-devel@vger.kernel.org
Date:   Wed, 17 Aug 2022 06:17:45 -0400
In-Reply-To: <20220816024143.519027-1-xiubli@redhat.com>
References: <20220816024143.519027-1-xiubli@redhat.com>
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

On Tue, 2022-08-16 at 10:41 +0800, xiubli@redhat.com wrote:
> From: Xiubo Li <xiubli@redhat.com>
>=20
> The upper layer has changed it to iov_iter_get_pages2(). And this
> should be folded into the previous commit.
>=20
> Signed-off-by: Xiubo Li <xiubli@redhat.com>
> ---
>  net/ceph/messenger.c | 17 ++---------------
>  1 file changed, 2 insertions(+), 15 deletions(-)
>=20
> diff --git a/net/ceph/messenger.c b/net/ceph/messenger.c
> index 945f6d1a9efa..020474cf137c 100644
> --- a/net/ceph/messenger.c
> +++ b/net/ceph/messenger.c
> @@ -985,25 +985,12 @@ static struct page *ceph_msg_data_iter_next(struct =
ceph_msg_data_cursor *cursor,
>  	if (cursor->lastlen)
>  		iov_iter_revert(&cursor->iov_iter, cursor->lastlen);
> =20
> -	len =3D iov_iter_get_pages(&cursor->iov_iter, &page, PAGE_SIZE,
> -				 1, page_offset);
> +	len =3D iov_iter_get_pages2(&cursor->iov_iter, &page, PAGE_SIZE,
> +				  1, page_offset);
>  	BUG_ON(len < 0);
> =20
>  	cursor->lastlen =3D len;
> =20
> -	/*
> -	 * FIXME: Al Viro says that he will soon change iov_iter_get_pages
> -	 * to auto-advance the iterator. Emulate that here for now.
> -	 */
> -	iov_iter_advance(&cursor->iov_iter, len);
> -
> -	/*
> -	 * FIXME: The assumption is that the pages represented by the iov_iter
> -	 * 	  are pinned, with the references held by the upper-level
> -	 * 	  callers, or by virtue of being under writeback. Eventually,
> -	 * 	  we'll get an iov_iter_get_pages variant that doesn't take page
> -	 * 	  refs. Until then, just put the page ref.
> -	 */

I think the comment above should not be removed. Eventually Al plans to
add a version of this that doesn't take page refs, and this patch
doesn't change that.

>  	VM_BUG_ON_PAGE(!PageWriteback(page) && page_count(page) < 2, page);
>  	put_page(page);
> =20

Patch itself looks fine though. Thanks for fixing it up!

Reviewed-by: Jeff Layton <jlayton@kernel.org>
