Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 45E8551BD8B
	for <lists+ceph-devel@lfdr.de>; Thu,  5 May 2022 12:53:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353592AbiEEK5A (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 5 May 2022 06:57:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233254AbiEEK47 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 5 May 2022 06:56:59 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 515C246176
        for <ceph-devel@vger.kernel.org>; Thu,  5 May 2022 03:53:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E494E61B7A
        for <ceph-devel@vger.kernel.org>; Thu,  5 May 2022 10:53:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6E4EC385A4;
        Thu,  5 May 2022 10:53:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651747999;
        bh=1TR2xjDqhYGeDwzMXk/XX/FPyMuY8SLKz2GzQ3alFF4=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=TBiJdCSH+Il7NpCbAKM2W8Fzk1a2zzN17mTBH7YysVDsWBrh2exxB9fX/+0yfZF4k
         0q23Q7TJDKK55yuegAdIm6K2xJSxT1Ldb1i/thlo3/KVdQawLHQAj2CnHUZfRd+Dw3
         CEo+s8qZ2M0yP0cSthkKA7CWvzZco4Dv/KO57jnls8/rSDQWlgL8OgLC307RtSeZFs
         axztDK/6hIi+403GGZkssRwv2cS2CG7z9RdesWAnrpz1oxYp81wMasV47hgJjxxjXc
         y+yY+72x5OoG5YiMI/LWSBZkYSl59Bo2AnvdvYOLiN7ap56i9z7WeW8fyCBhNW2P+M
         eCYVr6ryuvXZg==
Message-ID: <77caeb6df50d890028ee5fd0d7cacc01595f1e18.camel@kernel.org>
Subject: Re: [PATCH v14 58/64] ceph: add encryption support to writepage
From:   Jeff Layton <jlayton@kernel.org>
To:     Xiubo Li <xiubli@redhat.com>, ceph-devel@vger.kernel.org
Cc:     lhenriques@suse.de, idryomov@gmail.com
Date:   Thu, 05 May 2022 06:53:17 -0400
In-Reply-To: <f2557ca6-adfc-c661-b2f8-9e17eff264e8@redhat.com>
References: <20220427191314.222867-1-jlayton@kernel.org>
         <20220427191314.222867-59-jlayton@kernel.org>
         <f2557ca6-adfc-c661-b2f8-9e17eff264e8@redhat.com>
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

On Thu, 2022-05-05 at 17:34 +0800, Xiubo Li wrote:
> On 4/28/22 3:13 AM, Jeff Layton wrote:
> > Allow writepage to issue encrypted writes. Extend out the requested size
> > and offset to cover complete blocks, and then encrypt and write them to
> > the OSDs.
> > 
> > Signed-off-by: Jeff Layton <jlayton@kernel.org>
> > ---
> >   fs/ceph/addr.c | 34 +++++++++++++++++++++++++++-------
> >   1 file changed, 27 insertions(+), 7 deletions(-)
> > 
> > diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
> > index d65d431ec933..f54940fc96ee 100644
> > --- a/fs/ceph/addr.c
> > +++ b/fs/ceph/addr.c
> > @@ -586,10 +586,12 @@ static int writepage_nounlock(struct page *page, struct writeback_control *wbc)
> >   	loff_t page_off = page_offset(page);
> >   	int err;
> >   	loff_t len = thp_size(page);
> > +	loff_t wlen;
> >   	struct ceph_writeback_ctl ceph_wbc;
> >   	struct ceph_osd_client *osdc = &fsc->client->osdc;
> >   	struct ceph_osd_request *req;
> >   	bool caching = ceph_is_cache_enabled(inode);
> > +	struct page *bounce_page = NULL;
> >   
> >   	dout("writepage %p idx %lu\n", page, page->index);
> >   
> > @@ -621,6 +623,8 @@ static int writepage_nounlock(struct page *page, struct writeback_control *wbc)
> >   
> >   	if (ceph_wbc.i_size < page_off + len)
> >   		len = ceph_wbc.i_size - page_off;
> > +	if (IS_ENCRYPTED(inode))
> > +		wlen = round_up(len, CEPH_FSCRYPT_BLOCK_SIZE);
> >   
> >   	dout("writepage %p page %p index %lu on %llu~%llu snapc %p seq %lld\n",
> >   	     inode, page, page->index, page_off, len, snapc, snapc->seq);
> > @@ -629,24 +633,39 @@ static int writepage_nounlock(struct page *page, struct writeback_control *wbc)
> >   	    CONGESTION_ON_THRESH(fsc->mount_options->congestion_kb))
> >   		fsc->write_congested = true;
> >   
> > -	req = ceph_osdc_new_request(osdc, &ci->i_layout, ceph_vino(inode), page_off, &len, 0, 1,
> > -				    CEPH_OSD_OP_WRITE, CEPH_OSD_FLAG_WRITE, snapc,
> > -				    ceph_wbc.truncate_seq, ceph_wbc.truncate_size,
> > -				    true);
> > +	req = ceph_osdc_new_request(osdc, &ci->i_layout, ceph_vino(inode),
> > +				    page_off, &wlen, 0, 1, CEPH_OSD_OP_WRITE,
> > +				    CEPH_OSD_FLAG_WRITE, snapc,
> > +				    ceph_wbc.truncate_seq,
> > +				    ceph_wbc.truncate_size, true);
> >   	if (IS_ERR(req)) {
> >   		redirty_page_for_writepage(wbc, page);
> >   		return PTR_ERR(req);
> >   	}
> >   
> > +	if (wlen < len)
> > +		len = wlen;
> > +
> >   	set_page_writeback(page);
> >   	if (caching)
> >   		ceph_set_page_fscache(page);
> >   	ceph_fscache_write_to_cache(inode, page_off, len, caching);
> >   
> > +	if (IS_ENCRYPTED(inode)) {
> > +		bounce_page = fscrypt_encrypt_pagecache_blocks(page, CEPH_FSCRYPT_BLOCK_SIZE,
> > +								0, GFP_NOFS);
> > +		if (IS_ERR(bounce_page)) {
> > +			err = PTR_ERR(bounce_page);
> > +			goto out;
> > +		}
> > +	}
> 
> Here IMO we should redirty the page instead of detaching the page's 
> private data in 'out:' ?
> 
> -- Xiubo
> 
> 

Good catch. I think you're right. I'll fold the following delta into
this patch:

diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
index f54940fc96ee..b266656f2951 100644
--- a/fs/ceph/addr.c
+++ b/fs/ceph/addr.c
@@ -655,10 +655,12 @@ static int writepage_nounlock(struct page *page, struct writeback_control *wbc)
                bounce_page = fscrypt_encrypt_pagecache_blocks(page, CEPH_FSCRYPT_BLOCK_SIZE,
                                                                0, GFP_NOFS);
                if (IS_ERR(bounce_page)) {
-                       err = PTR_ERR(bounce_page);
-                       goto out;
+                       redirty_page_for_writepage(wbc, page);
+                       end_page_writeback(page);
+                       return PTR_ERR(bounce_page);
                }
        }
+
        /* it may be a short write due to an object boundary */
        WARN_ON_ONCE(len > thp_size(page));
        osd_req_op_extent_osd_data_pages(req, 0,


> >   	/* it may be a short write due to an object boundary */
> >   	WARN_ON_ONCE(len > thp_size(page));
> > -	osd_req_op_extent_osd_data_pages(req, 0, &page, len, 0, false, false);
> > -	dout("writepage %llu~%llu (%llu bytes)\n", page_off, len, len);
> > +	osd_req_op_extent_osd_data_pages(req, 0,
> > +			bounce_page ? &bounce_page : &page, wlen, 0,
> > +			false, false);
> > +	dout("writepage %llu~%llu (%llu bytes, %sencrypted)\n",
> > +	     page_off, len, wlen, IS_ENCRYPTED(inode) ? "" : "not ");
> >   
> >   	req->r_mtime = inode->i_mtime;
> >   	err = ceph_osdc_start_request(osdc, req, true);
> > @@ -655,7 +674,8 @@ static int writepage_nounlock(struct page *page, struct writeback_control *wbc)
> >   
> >   	ceph_update_write_metrics(&fsc->mdsc->metric, req->r_start_latency,
> >   				  req->r_end_latency, len, err);
> > -
> > +	fscrypt_free_bounce_page(bounce_page);
> > +out:
> >   	ceph_osdc_put_request(req);
> >   	if (err == 0)
> >   		err = len;
> 

-- 
Jeff Layton <jlayton@kernel.org>
