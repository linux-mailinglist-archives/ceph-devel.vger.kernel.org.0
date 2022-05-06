Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 395E751DC72
	for <lists+ceph-devel@lfdr.de>; Fri,  6 May 2022 17:44:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1443104AbiEFPrz (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 6 May 2022 11:47:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245687AbiEFPrz (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Fri, 6 May 2022 11:47:55 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B604668F93
        for <ceph-devel@vger.kernel.org>; Fri,  6 May 2022 08:44:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 31988621CA
        for <ceph-devel@vger.kernel.org>; Fri,  6 May 2022 15:44:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CAC9C385A8;
        Fri,  6 May 2022 15:44:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651851850;
        bh=AQCS9m/P09uxQdk2D0YmyrWeXT9SmX5Gk1RI+vTP63c=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=p81W4BOdopU+agV5XWW1L31oH3E/wMa9jqGJpaYjYyY51dAVJ2PEA2unZW5Sx8zH/
         RWcv/sudwl2zvzCHg9X/5YRtFqF4mUliB+Jp8ctSdEb4TU+5N4NYqhlK+d0NTGsayh
         hA4fp8AebVgdTDjaSeYRC9wXp+R0293jD3c3+vr/D/fHODTw/s8YK1BcO+KkIrTXKX
         A6nE06+N4XPqog7KgW6UdomM8q8ST1P2OIoqoklnjFKsCBSO74+0nnGHAcxKIQkSpg
         EEdJo0H9bAj/oJAJKn9kM8r2Dv/CbIjSxdO4VbM/NwCzYNarI3dEHzMEVE2taVz5EU
         4JOUTFpEZAwew==
Message-ID: <a0e7b4ff82ca16ec7a3f815225c343fc7650cdc8.camel@kernel.org>
Subject: Re: [PATCH v3] ceph: switch to VM_BUG_ON_FOLIO and continue the
 loop for none write op
From:   Jeff Layton <jlayton@kernel.org>
To:     Xiubo Li <xiubli@redhat.com>
Cc:     idryomov@gmail.com, vshankar@redhat.com, ceph-devel@vger.kernel.org
Date:   Fri, 06 May 2022 11:44:08 -0400
In-Reply-To: <20220506152243.497173-1-xiubli@redhat.com>
References: <20220506152243.497173-1-xiubli@redhat.com>
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

On Fri, 2022-05-06 at 23:22 +0800, Xiubo Li wrote:
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
> index 04a6c3f02f0c..63b7430e1ce6 100644
> --- a/fs/ceph/addr.c
> +++ b/fs/ceph/addr.c
> @@ -85,7 +85,7 @@ static bool ceph_dirty_folio(struct address_space *mapping, struct folio *folio)
>  	if (folio_test_dirty(folio)) {
>  		dout("%p dirty_folio %p idx %lu -- already dirty\n",
>  		     mapping->host, folio, folio->index);
> -		BUG_ON(!folio_get_private(folio));
> +		VM_BUG_ON_FOLIO(!folio_get_private(folio), folio);
>  		return false;
>  	}
>  
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
> +		if (req->r_ops[i].op != CEPH_OSD_OP_WRITE) {
> +			pr_warn("%s incorrect op %d req %p index %d tid %llu\n",
> +				__func__, req->r_ops[i].op, req, i, req->r_tid);
>  			break;
> +		}
>  
>  		osd_data = osd_req_op_extent_osd_data(req, i);
>  		BUG_ON(osd_data->type != CEPH_OSD_DATA_TYPE_PAGES);

Reviewed-by: Jeff Layton <jlayton@kernel.org>
