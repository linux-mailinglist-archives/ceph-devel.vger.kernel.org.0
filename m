Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 879FA51BC45
	for <lists+ceph-devel@lfdr.de>; Thu,  5 May 2022 11:34:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348101AbiEEJia (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 5 May 2022 05:38:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234023AbiEEJi3 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 5 May 2022 05:38:29 -0400
Received: from us-smtp-delivery-74.mimecast.com (us-smtp-delivery-74.mimecast.com [170.10.129.74])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 7EFB915FEB
        for <ceph-devel@vger.kernel.org>; Thu,  5 May 2022 02:34:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1651743288;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=q4/exfFs9Dj9q6kQSO5phdbq0m7l7SwK7sYFRKigcJ0=;
        b=UyaaaBml/v0UbXnNnYkm9F+d+X7JvZcC/cAXLXzMcr0oofMGL5cQx5JHgPSz425uYJmLH3
        mZsQQZvCRjc6IGK+9Djd/XW4yQ6r8V2sA4HhCOxla5YCYUfSqZ3ofD3xzvrLsMz/drAilv
        A91v56Wbzfs6ekAiQ2NQia3jxKYF18A=
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com
 [209.85.214.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-461-kVAbz6P2MFWkgkZFhYelbg-1; Thu, 05 May 2022 05:34:47 -0400
X-MC-Unique: kVAbz6P2MFWkgkZFhYelbg-1
Received: by mail-pl1-f199.google.com with SMTP id x4-20020a1709028ec400b0015e84d42eaaso2032443plo.7
        for <ceph-devel@vger.kernel.org>; Thu, 05 May 2022 02:34:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=q4/exfFs9Dj9q6kQSO5phdbq0m7l7SwK7sYFRKigcJ0=;
        b=Txwj/T4On6Kzjav1kvV1ptN9DxqBcOYss2qlZVsXIOHqBItwHGzS8X+6EfS8oMSzsc
         Caegz73E+toVJtwguIkOb4Fgfa0+VMzZGq8ut4brWu2yFb4uXVmt0NRlM8L28KhG0zIy
         0TgxJCKPMC/ufcE9YBZXtTxdWGvydkX54Xn72ExTNy57d7ij6WsEyN3DFl8A23TDumNp
         D7lUy+GDy2p2Q2A3wygRlp1tm2qCNazhUEsOxW1wfqMnajibfJyuMN30yDkbP0MwmfBx
         KX36YL6M9fRBCmkyuo14DDlIYhu/ov0rQKECHXz0hY+R97ckQietNSCYExQXciGi30ha
         sdTw==
X-Gm-Message-State: AOAM533NzOUJQ8eqh+kXYPxVV12tmjUdpfgauMjvHyYrGIn1SBTMo6x8
        ImkRQ/QX6qzj4By1oUjEPyHgLEO0/4QkKbcyNnJiuY/9J5V19bPXJ5FYu+3PFhZTAKz3I8wDGrm
        LtL759EaqGwB0dSO1WzjLvg==
X-Received: by 2002:a17:902:c14d:b0:15e:c301:5f9f with SMTP id 13-20020a170902c14d00b0015ec3015f9fmr8582089plj.87.1651743286272;
        Thu, 05 May 2022 02:34:46 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyqBqrf43DX41OOXhsb2f12qzcmfgzTmXee+FIvXMGkK4P1kVn08h0NTY40LMKxX+vSEKjS7w==
X-Received: by 2002:a17:902:c14d:b0:15e:c301:5f9f with SMTP id 13-20020a170902c14d00b0015ec3015f9fmr8582071plj.87.1651743286007;
        Thu, 05 May 2022 02:34:46 -0700 (PDT)
Received: from [10.72.12.122] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id i15-20020a17090332cf00b0015e8d4eb20csm1056628plr.86.2022.05.05.02.34.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 05 May 2022 02:34:45 -0700 (PDT)
Subject: Re: [PATCH v14 58/64] ceph: add encryption support to writepage
To:     Jeff Layton <jlayton@kernel.org>, ceph-devel@vger.kernel.org
Cc:     lhenriques@suse.de, idryomov@gmail.com
References: <20220427191314.222867-1-jlayton@kernel.org>
 <20220427191314.222867-59-jlayton@kernel.org>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <f2557ca6-adfc-c661-b2f8-9e17eff264e8@redhat.com>
Date:   Thu, 5 May 2022 17:34:40 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20220427191314.222867-59-jlayton@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Spam-Status: No, score=-5.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


On 4/28/22 3:13 AM, Jeff Layton wrote:
> Allow writepage to issue encrypted writes. Extend out the requested size
> and offset to cover complete blocks, and then encrypt and write them to
> the OSDs.
>
> Signed-off-by: Jeff Layton <jlayton@kernel.org>
> ---
>   fs/ceph/addr.c | 34 +++++++++++++++++++++++++++-------
>   1 file changed, 27 insertions(+), 7 deletions(-)
>
> diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
> index d65d431ec933..f54940fc96ee 100644
> --- a/fs/ceph/addr.c
> +++ b/fs/ceph/addr.c
> @@ -586,10 +586,12 @@ static int writepage_nounlock(struct page *page, struct writeback_control *wbc)
>   	loff_t page_off = page_offset(page);
>   	int err;
>   	loff_t len = thp_size(page);
> +	loff_t wlen;
>   	struct ceph_writeback_ctl ceph_wbc;
>   	struct ceph_osd_client *osdc = &fsc->client->osdc;
>   	struct ceph_osd_request *req;
>   	bool caching = ceph_is_cache_enabled(inode);
> +	struct page *bounce_page = NULL;
>   
>   	dout("writepage %p idx %lu\n", page, page->index);
>   
> @@ -621,6 +623,8 @@ static int writepage_nounlock(struct page *page, struct writeback_control *wbc)
>   
>   	if (ceph_wbc.i_size < page_off + len)
>   		len = ceph_wbc.i_size - page_off;
> +	if (IS_ENCRYPTED(inode))
> +		wlen = round_up(len, CEPH_FSCRYPT_BLOCK_SIZE);
>   
>   	dout("writepage %p page %p index %lu on %llu~%llu snapc %p seq %lld\n",
>   	     inode, page, page->index, page_off, len, snapc, snapc->seq);
> @@ -629,24 +633,39 @@ static int writepage_nounlock(struct page *page, struct writeback_control *wbc)
>   	    CONGESTION_ON_THRESH(fsc->mount_options->congestion_kb))
>   		fsc->write_congested = true;
>   
> -	req = ceph_osdc_new_request(osdc, &ci->i_layout, ceph_vino(inode), page_off, &len, 0, 1,
> -				    CEPH_OSD_OP_WRITE, CEPH_OSD_FLAG_WRITE, snapc,
> -				    ceph_wbc.truncate_seq, ceph_wbc.truncate_size,
> -				    true);
> +	req = ceph_osdc_new_request(osdc, &ci->i_layout, ceph_vino(inode),
> +				    page_off, &wlen, 0, 1, CEPH_OSD_OP_WRITE,
> +				    CEPH_OSD_FLAG_WRITE, snapc,
> +				    ceph_wbc.truncate_seq,
> +				    ceph_wbc.truncate_size, true);
>   	if (IS_ERR(req)) {
>   		redirty_page_for_writepage(wbc, page);
>   		return PTR_ERR(req);
>   	}
>   
> +	if (wlen < len)
> +		len = wlen;
> +
>   	set_page_writeback(page);
>   	if (caching)
>   		ceph_set_page_fscache(page);
>   	ceph_fscache_write_to_cache(inode, page_off, len, caching);
>   
> +	if (IS_ENCRYPTED(inode)) {
> +		bounce_page = fscrypt_encrypt_pagecache_blocks(page, CEPH_FSCRYPT_BLOCK_SIZE,
> +								0, GFP_NOFS);
> +		if (IS_ERR(bounce_page)) {
> +			err = PTR_ERR(bounce_page);
> +			goto out;
> +		}
> +	}

Here IMO we should redirty the page instead of detaching the page's 
private data in 'out:' ?

-- Xiubo


>   	/* it may be a short write due to an object boundary */
>   	WARN_ON_ONCE(len > thp_size(page));
> -	osd_req_op_extent_osd_data_pages(req, 0, &page, len, 0, false, false);
> -	dout("writepage %llu~%llu (%llu bytes)\n", page_off, len, len);
> +	osd_req_op_extent_osd_data_pages(req, 0,
> +			bounce_page ? &bounce_page : &page, wlen, 0,
> +			false, false);
> +	dout("writepage %llu~%llu (%llu bytes, %sencrypted)\n",
> +	     page_off, len, wlen, IS_ENCRYPTED(inode) ? "" : "not ");
>   
>   	req->r_mtime = inode->i_mtime;
>   	err = ceph_osdc_start_request(osdc, req, true);
> @@ -655,7 +674,8 @@ static int writepage_nounlock(struct page *page, struct writeback_control *wbc)
>   
>   	ceph_update_write_metrics(&fsc->mdsc->metric, req->r_start_latency,
>   				  req->r_end_latency, len, err);
> -
> +	fscrypt_free_bounce_page(bounce_page);
> +out:
>   	ceph_osdc_put_request(req);
>   	if (err == 0)
>   		err = len;

