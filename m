Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 33D4D3A5B26
	for <lists+ceph-devel@lfdr.de>; Mon, 14 Jun 2021 02:10:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232269AbhFNAMt (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Sun, 13 Jun 2021 20:12:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232233AbhFNAMt (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Sun, 13 Jun 2021 20:12:49 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97F26C061574
        for <ceph-devel@vger.kernel.org>; Sun, 13 Jun 2021 17:10:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=+MbsRSN4ftv1ukGEV8urboQkIJzwdQkMgTQj3qzAYEc=; b=E1kVJVjnfwpim96SuvFs052taI
        B6BJKJrOdgsNaHeW3EyBFuwHkYvzjiX8jlcd83+k73XtK8PDKX2L4scSM5QUCJCrQ2DcZEnj7Wusp
        BlEUXFIDXvPVCOlFRiip3HyTHoVV21F6BpcQtLYhImn9O7fZWD0fNmZKCqXK6x/18W6nRubuX/QCy
        41j67IJzbaxMuluKt0NrPIko2iz/8Po0ri0iZUwa48HcV2nbOSMR1M5SjgS64xY8i953w2kjPVVJ8
        EyB8lKxhgH2v+H8krmEHuq+Bf8c4azvaFMsKX+gr5Mb4WV2RQOGdSIQP6mvmwp9nmhUzTfBGKs+ub
        Lg2woqLQ==;
Received: from willy by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1lsa9F-004tqR-IF; Mon, 14 Jun 2021 00:08:32 +0000
Date:   Mon, 14 Jun 2021 01:08:13 +0100
From:   Matthew Wilcox <willy@infradead.org>
To:     Jeff Layton <jlayton@kernel.org>
Cc:     dhowells@redhat.com, linux-cachefs@redhat.com, idryomov@gmail.com,
        pfmeec@rit.edu, ceph-devel@vger.kernel.org,
        Andrew W Elble <aweits@rit.edu>
Subject: Re: [PATCH] netfs: fix test for whether we can skip read when
 writing beyond EOF
Message-ID: <YMad7WZ4PbHTPTxd@casper.infradead.org>
References: <20210613233345.113565-1-jlayton@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210613233345.113565-1-jlayton@kernel.org>
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Sun, Jun 13, 2021 at 07:33:45PM -0400, Jeff Layton wrote:
> +static bool prep_noread_page(struct page *page, loff_t pos, size_t len)
>  {
> -	unsigned int i;
> +	struct inode *inode = page->mapping->host;
> +	loff_t i_size = i_size_read(inode);
> +	pgoff_t index = pos / thp_size(page);
> +	size_t offset = offset_in_page(pos);

offset_in_thp(page, pos);

With that change:

Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
