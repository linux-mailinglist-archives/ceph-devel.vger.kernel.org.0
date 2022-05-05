Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C8C451BE14
	for <lists+ceph-devel@lfdr.de>; Thu,  5 May 2022 13:32:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357495AbiEELgV (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 5 May 2022 07:36:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357692AbiEELgL (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 5 May 2022 07:36:11 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2392D25C70
        for <ceph-devel@vger.kernel.org>; Thu,  5 May 2022 04:32:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 92CCA61CE6
        for <ceph-devel@vger.kernel.org>; Thu,  5 May 2022 11:32:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 799BCC385A8;
        Thu,  5 May 2022 11:32:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651750337;
        bh=LbuyO7bXMxA4/k+s7sNUTtyCejwzSNqz5+wLTVBNpiE=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=sntNjWmAxlwHZ40hjwH2j0H6g/wg9+AAJOy10CZriRuQS3wcqq8CJMtxwjfXmVFk8
         sAJ/LwCIqUsHJ7TsZeIFuDDTj+YrOPFnfpOtIb6zRgaVKnFS2zn3PDJLM69RFG5LlF
         0rUGP7SoO56e8kfIEp/OlGg7BRXju/giAwgLOOOL4eyYPt48ejCxnITjSlVrNGFlOq
         FL/bwx81BeJ0HRXS+zpq/RhOdM85SWKY1iwaBcuAZrGjNHqGtWpdNjpP/jnxIL7SvT
         yPcFD+d8LZBqHfahJwuNiB6ZC6/himD+I7YX8p/8mLIKFxZszpae0nOR5Z0Ax/iGik
         3mX3BMJz2E4pA==
Message-ID: <873fc305d96e023974cbc209c752a44de97eb88c.camel@kernel.org>
Subject: Re: [PATCH] ceph: redirty the folio/page when offset and size are
 not aligned
From:   Jeff Layton <jlayton@kernel.org>
To:     Xiubo Li <xiubli@redhat.com>
Cc:     idryomov@gmail.com, vshankar@redhat.com, ceph-devel@vger.kernel.org
Date:   Thu, 05 May 2022 07:32:16 -0400
In-Reply-To: <20220505105808.35214-1-xiubli@redhat.com>
References: <20220505105808.35214-1-xiubli@redhat.com>
Content-Type: text/plain; charset="ISO-8859-15"
User-Agent: Evolution 3.42.4 (3.42.4-2.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Thu, 2022-05-05 at 18:58 +0800, Xiubo Li wrote:
> At the same time fix another buggy code because in writepages_finish
> if the opcode doesn't equal to CEPH_OSD_OP_WRITE the request memory
> must have been corrupted.
> 
> URL: https://tracker.ceph.com/issues/55421
> Signed-off-by: Xiubo Li <xiubli@redhat.com>
> ---
>  fs/ceph/addr.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
> index e52b62407b10..ae224135440b 100644
> --- a/fs/ceph/addr.c
> +++ b/fs/ceph/addr.c
> @@ -146,6 +146,8 @@ static void ceph_invalidate_folio(struct folio *folio, size_t offset,
>  	if (offset != 0 || length != folio_size(folio)) {
>  		dout("%p invalidate_folio idx %lu partial dirty page %zu~%zu\n",
>  		     inode, folio->index, offset, length);
> +		filemap_dirty_folio(folio->mapping, folio);
> +		folio_account_redirty(folio);
>  		return;
>  	}
>  

This looks wrong to me. 

How do you know the page was dirty in the first place? The caller should
not have cleaned a dirty page without writing it back first so it should
still be dirty if it hasn't. I don't see that we need to do anything
like this.

> @@ -733,8 +735,7 @@ static void writepages_finish(struct ceph_osd_request *req)
>  
>  	/* clean all pages */
>  	for (i = 0; i < req->r_num_ops; i++) {
> -		if (req->r_ops[i].op != CEPH_OSD_OP_WRITE)
> -			break;
> +		BUG_ON(req->r_ops[i].op != CEPH_OSD_OP_WRITE);

I'd prefer we not BUG here. This does mean the data in the incoming
frame was probably scrambled, but I don't see that as a good reason to
crash the box.

Throwing a warning message would be fine here, but a WARN_ON is probably
not terribly helpful. Maybe add a pr_warn that dumps some info about the
request in this situation (index, tid, flags, rval, etc...) ?


>  
>  		osd_data = osd_req_op_extent_osd_data(req, i);
>  		BUG_ON(osd_data->type != CEPH_OSD_DATA_TYPE_PAGES);

-- 
Jeff Layton <jlayton@kernel.org>
