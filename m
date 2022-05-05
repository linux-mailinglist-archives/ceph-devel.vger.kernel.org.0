Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E175351C098
	for <lists+ceph-devel@lfdr.de>; Thu,  5 May 2022 15:26:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359516AbiEEN33 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 5 May 2022 09:29:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379752AbiEEN3P (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 5 May 2022 09:29:15 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D3B9E0F9
        for <ceph-devel@vger.kernel.org>; Thu,  5 May 2022 06:25:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 416BDB82D55
        for <ceph-devel@vger.kernel.org>; Thu,  5 May 2022 13:25:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89E2AC385A8;
        Thu,  5 May 2022 13:25:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651757133;
        bh=gxeqR/RgAN53Lk2qwtMZA8uGUF3fNwydmoUYWTm3GGg=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=PcGXt/svY/HD5FYaRhWlRQKO/a2Ofy81X3xu/u5Uf1Tv1gXXQOFez1f7m6ZZiFLhy
         ibXgIMI/lyktyXDH2sDvfL9ByLITGMV6oxE9E2vGHs7q87Gi7Tk8ZkMQzFETxSHoZ7
         QR8iZxWVtVg6L5CoJLGjQkZbnE68dqL7haBAsY1UivtUaL9hyOAtY39S9Y7PRDxhy3
         4YvJfD6f9/yHPjYdESqTOkLFZhLvIstpe55P0iIELkv07pnihhRgKcHEMGS6glky2T
         Xf8Xxucvkp9ktsGgqnMr8U9fbiddd2sxjyPmLfd8Xr8DM+VlVMEN8/Sd8IXt3G8rvu
         8pPle4UEh7WZg==
Message-ID: <f7f4a70b0916ec077c2a72c52002630f9e898fd9.camel@kernel.org>
Subject: Re: [PATCH v2] ceph: switch to VM_BUG_ON_FOLIO and continue the
 loop for none write op
From:   Jeff Layton <jlayton@kernel.org>
To:     Xiubo Li <xiubli@redhat.com>
Cc:     idryomov@gmail.com, vshankar@redhat.com, ceph-devel@vger.kernel.org
Date:   Thu, 05 May 2022 09:25:31 -0400
In-Reply-To: <20220505124718.50261-1-xiubli@redhat.com>
References: <20220505124718.50261-1-xiubli@redhat.com>
Content-Type: text/plain; charset="ISO-8859-15"
User-Agent: Evolution 3.42.4 (3.42.4-2.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Thu, 2022-05-05 at 20:47 +0800, Xiubo Li wrote:
> Use the VM_BUG_ON_FOLIO macro to get more infomation when we hit
> the BUG_ON, and continue the loop when seeing the incorrect none
> write opcode in writepages_finish().
> 
> URL: https://tracker.ceph.com/issues/55421
> Signed-off-by: Xiubo Li <xiubli@redhat.com>
> ---
>  fs/ceph/addr.c | 9 ++++++---
>  1 file changed, 6 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
> index e52b62407b10..d4bcef1d9549 100644
> --- a/fs/ceph/addr.c
> +++ b/fs/ceph/addr.c
> @@ -122,7 +122,7 @@ static bool ceph_dirty_folio(struct address_space *mapping, struct folio *folio)
>  	 * Reference snap context in folio->private.  Also set
>  	 * PagePrivate so that we get invalidate_folio callback.
>  	 */
> -	BUG_ON(folio_get_private(folio));
> +	VM_BUG_ON_FOLIO(folio_get_private(folio), folio);
>  	folio_attach_private(folio, snapc);
>  
>  	return ceph_fscache_dirty_folio(mapping, folio);
> @@ -733,8 +733,11 @@ static void writepages_finish(struct ceph_osd_request *req)
>  
>  	/* clean all pages */
>  	for (i = 0; i < req->r_num_ops; i++) {
> -		if (req->r_ops[i].op != CEPH_OSD_OP_WRITE)
> -			break;
> +		if (req->r_ops[i].op != CEPH_OSD_OP_WRITE) {
> +			pr_warn("%s incorrect op %d req %p index %d tid %llu\n",
> +				__func__, req->r_ops[i].op, req, i, req->r_tid);
> +			continue;

A break here is probably fine. We don't expect to see any non OP_WRITE
ops in here, so if we do I don't see the point in continuing.

> +		}
>  
>  		osd_data = osd_req_op_extent_osd_data(req, i);
>  		BUG_ON(osd_data->type != CEPH_OSD_DATA_TYPE_PAGES);

Otherwise looks fine.
-- 
Jeff Layton <jlayton@kernel.org>
