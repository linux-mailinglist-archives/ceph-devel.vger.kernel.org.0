Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1030E50E91C
	for <lists+ceph-devel@lfdr.de>; Mon, 25 Apr 2022 21:04:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238024AbiDYTHW (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 25 Apr 2022 15:07:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231592AbiDYTHV (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 25 Apr 2022 15:07:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDB6112C6A1
        for <ceph-devel@vger.kernel.org>; Mon, 25 Apr 2022 12:04:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6B1B461723
        for <ceph-devel@vger.kernel.org>; Mon, 25 Apr 2022 19:04:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 608E9C385A4;
        Mon, 25 Apr 2022 19:04:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650913455;
        bh=nRy673wKKLzlZQbCq9C3/73gO/qcZfT6aEYEnNzbWE8=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=Gd8Zzvj1dumqKPY73QdwPYGQ9XwgPSpS3AIqrHddHNd6GgF/R9zbtvDnyr7A8DU+y
         NxRtA+6QNgPjyyy4kUwAN1doAB8Ji1VcpkVLzE2ynB9dEedGC11im+DXLgt5xCAerj
         idzYIbPlllags9f1/uz/9h18VIkO1YrT3gM+W/D7BJCQ5LUO9Bo3KU/7ReoIQTGNiE
         5fXFLfUsrtXRoZRKP8IMpf4GvaIW0bq5VPjsfCmGGrAZheVg7SbfuX/d7VC/CLxak9
         hr/ZpDUObU1Q+z5LNVwPtikbNXj+rC15xdmpYLMjAertIqCnKfSiy7x6ReiT8ZVQxJ
         AVx0pbS24d7nQ==
Message-ID: <02b307040a4ee64a7d63fac5ef0d7220365e13e4.camel@kernel.org>
Subject: Re: [PATCH] ceph: redirty the page for wirtepage if fails
From:   Jeff Layton <jlayton@kernel.org>
To:     Xiubo Li <xiubli@redhat.com>
Cc:     idryomov@gmail.com, vshankar@redhat.com, ceph-devel@vger.kernel.org
Date:   Mon, 25 Apr 2022 15:04:14 -0400
In-Reply-To: <20220424093924.32691-1-xiubli@redhat.com>
References: <20220424093924.32691-1-xiubli@redhat.com>
Content-Type: text/plain; charset="ISO-8859-15"
User-Agent: Evolution 3.42.4 (3.42.4-2.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Sun, 2022-04-24 at 17:39 +0800, Xiubo Li wrote:
> When run out of memories we should redirty the page before failing
> the writepage. Or we will hit BUG_ON(folio_get_private(folio)) in
> ceph_dirty_folio().
> 
> URL: https://tracker.ceph.com/issues/55421
> Signed-off-by: Xiubo Li <xiubli@redhat.com>
> ---
>  fs/ceph/addr.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
> index 261bc8bb2ab8..656bc0ca7a78 100644
> --- a/fs/ceph/addr.c
> +++ b/fs/ceph/addr.c
> @@ -606,8 +606,10 @@ static int writepage_nounlock(struct page *page, struct writeback_control *wbc)
>  				    CEPH_OSD_OP_WRITE, CEPH_OSD_FLAG_WRITE, snapc,
>  				    ceph_wbc.truncate_seq, ceph_wbc.truncate_size,
>  				    true);
> -	if (IS_ERR(req))
> +	if (IS_ERR(req)) {
> +		redirty_page_for_writepage(wbc, page);
>  		return PTR_ERR(req);
> +	}
>  
>  	set_page_writeback(page);
>  	if (caching)

Reviewed-by: Jeff Layton <jlayton@kernel.org>
