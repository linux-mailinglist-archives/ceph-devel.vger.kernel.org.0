Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 71B11269527
	for <lists+ceph-devel@lfdr.de>; Mon, 14 Sep 2020 20:46:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725953AbgINSp5 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 14 Sep 2020 14:45:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726020AbgINSph (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 14 Sep 2020 14:45:37 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66971C06174A
        for <ceph-devel@vger.kernel.org>; Mon, 14 Sep 2020 11:45:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=Wslww/E2BpMntIv+oixbMkhUhTyO0tkYpL+xlblkrEU=; b=Gd1KC6MipF1SvQzckpI0flSo8q
        sJqY6eWpWlwRNicNX5q8X0JDUUh1cx8cuKudNTKgc54Ta108bsycZSmf12E0RwTWhWAaC08XJuChN
        k36pdTO77HkisOb8eSfqWQzACmQUwpQdg4gZfuYoOQaoEmZeevuW80ekRRfL0vlEtR7PrSNb8m65T
        mpt27bdtMBz+/hz9jdNZFTsjiknvB378X0Slgc6mhVzcF13nNssAgJb2SydAejKGFJLmsaSs3iGTk
        NBpeSBU6h1Cn86CqShftEirg2486QtCrES+e2mVugdQSY/qkhD0BioYZXwx+wh70tOzCY0tg6nb0B
        3hmeHPlw==;
Received: from willy by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kHtTn-0001do-0z; Mon, 14 Sep 2020 18:45:31 +0000
Date:   Mon, 14 Sep 2020 19:45:30 +0100
From:   Matthew Wilcox <willy@infradead.org>
To:     Jeff Layton <jlayton@kernel.org>
Cc:     ceph-devel@vger.kernel.org
Subject: Re: [PATCH] ceph: have ceph_writepages_start call
 pagevec_lookup_range_tag
Message-ID: <20200914184530.GV6583@casper.infradead.org>
References: <20200914183452.378189-1-jlayton@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200914183452.378189-1-jlayton@kernel.org>
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Mon, Sep 14, 2020 at 02:34:52PM -0400, Jeff Layton wrote:
> Ceph is also the only caller of pagevec_lookup_range_nr_tag(), so
> changing this code to use pagevec_lookup_range_tag() should allow us to
> eliminate that call as well. That may mean that we sometimes find more
> pages than are needed, but the extra references will just get put at the
> end regardless.

That was the part I wasn't clear about!

So, let's suppose max_pages is 10 and we get 15 pages back.

We'll run the

for (i = 0; i < pvec_pages && locked_pages < max_pages; i++) {
}
loop ten times, then hit:

if (i) {
	for (j = 0; j < pvec_pages; j++) {
		if (!pvec.pages[j])
			continue;
OK, we do that ten times, then
		if (n < j)
			pvec.pages[n] = pvec.pages[j];
so we now have five pages clustered at the bottom of pvec
                        pvec.nr = n;
... then we do the new_request: stanza ...
ah, and then we call pagevec_release(&pvec);
and everything is good!

Excellent.  I was overwhelmed by the amount of code in this function.
Glad to see the patch was so simple in the end.

Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>

> Reported-by: Matthew Wilcox <willy@infradead.org>
> Signed-off-by: Jeff Layton <jlayton@kernel.org>
> ---
>  fs/ceph/addr.c | 5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)
> 
> I'm still testing this, but it looks good so far. If it's OK, we'll get
> this in for v5.10, and then I'll send a patch to remove
> pagevec_lookup_range_nr_tag.
> 
> diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
> index 6ea761c84494..b03dbaa9d345 100644
> --- a/fs/ceph/addr.c
> +++ b/fs/ceph/addr.c
> @@ -962,9 +962,8 @@ static int ceph_writepages_start(struct address_space *mapping,
>  		max_pages = wsize >> PAGE_SHIFT;
>  
>  get_more_pages:
> -		pvec_pages = pagevec_lookup_range_nr_tag(&pvec, mapping, &index,
> -						end, PAGECACHE_TAG_DIRTY,
> -						max_pages - locked_pages);
> +		pvec_pages = pagevec_lookup_range_tag(&pvec, mapping, &index,
> +						end, PAGECACHE_TAG_DIRTY);
>  		dout("pagevec_lookup_range_tag got %d\n", pvec_pages);
>  		if (!pvec_pages && !locked_pages)
>  			break;
> -- 
> 2.26.2
> 
