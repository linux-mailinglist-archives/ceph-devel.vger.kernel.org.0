Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5EDA587855
	for <lists+ceph-devel@lfdr.de>; Fri,  9 Aug 2019 13:25:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405928AbfHILZD (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 9 Aug 2019 07:25:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:40438 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726037AbfHILZD (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Fri, 9 Aug 2019 07:25:03 -0400
Received: from tleilax.poochiereds.net (68-20-15-154.lightspeed.rlghnc.sbcglobal.net [68.20.15.154])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 602252086D;
        Fri,  9 Aug 2019 11:25:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565349902;
        bh=JciUXLKzG32CJnk0QfzfKKNTtJ9F6xeSpXCY5HDRwVc=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=kA+gzUAwOc7nN9Wm2WAfiyMpf3xmtr4wF9zPE97QeyUbO2dC0VXl8S9GXbwchpFRX
         CmZUqVhjk8UWbNwZdTHXgjVdW2qjOXTy1ZWvyt93CLggXzGoFD1POasGoZHBxhN+gd
         uhgRZAG15UOeucySWCEc6IksmKviQyon38FfzVJ4=
Message-ID: <368e0c787cc9d0c0d99121f8f1b03c45e1a93f08.camel@kernel.org>
Subject: Re: [PATCH] fs/ceph: use release_pages() directly
From:   Jeff Layton <jlayton@kernel.org>
To:     john.hubbard@gmail.com
Cc:     LKML <linux-kernel@vger.kernel.org>,
        John Hubbard <jhubbard@nvidia.com>,
        Sage Weil <sage@redhat.com>, Ilya Dryomov <idryomov@gmail.com>,
        ceph-devel@vger.kernel.org
Date:   Fri, 09 Aug 2019 07:24:59 -0400
In-Reply-To: <20190809035647.18866-1-jhubbard@nvidia.com>
References: <20190809035647.18866-1-jhubbard@nvidia.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.32.4 (3.32.4-1.fc30) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Thu, 2019-08-08 at 20:56 -0700, john.hubbard@gmail.com wrote:
> From: John Hubbard <jhubbard@nvidia.com>
> 
> release_pages() has been available to modules since Oct, 2010,
> when commit 0be8557bcd34 ("fuse: use release_pages()") added
> EXPORT_SYMBOL(release_pages). However, this ceph code was still
> using a workaround.
> 
> Remove the workaround, and call release_pages() directly.
> 
> Cc: Jeff Layton <jlayton@kernel.org>
> Cc: Sage Weil <sage@redhat.com>
> Cc: Ilya Dryomov <idryomov@gmail.com>
> Cc: ceph-devel@vger.kernel.org
> Signed-off-by: John Hubbard <jhubbard@nvidia.com>
> ---
> 
> Hi,
> 
> I noticed this while I trying to understand mlock.c's use of
> pagevec_release(). So I was looking around for examples, and stumbled
> across this, which seems worth cleaning up.
> 
> thanks,
> John Hubbard
> NVIDIA
> 
>  fs/ceph/addr.c | 19 +------------------
>  1 file changed, 1 insertion(+), 18 deletions(-)
> 
> diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
> index e078cc55b989..22ed45d143be 100644
> --- a/fs/ceph/addr.c
> +++ b/fs/ceph/addr.c
> @@ -679,23 +679,6 @@ static int ceph_writepage(struct page *page, struct writeback_control *wbc)
>  	return err;
>  }
>  
> -/*
> - * lame release_pages helper.  release_pages() isn't exported to
> - * modules.
> - */
> -static void ceph_release_pages(struct page **pages, int num)
> -{
> -	struct pagevec pvec;
> -	int i;
> -
> -	pagevec_init(&pvec);
> -	for (i = 0; i < num; i++) {
> -		if (pagevec_add(&pvec, pages[i]) == 0)
> -			pagevec_release(&pvec);
> -	}
> -	pagevec_release(&pvec);
> -}
> -
>  /*
>   * async writeback completion handler.
>   *
> @@ -769,7 +752,7 @@ static void writepages_finish(struct ceph_osd_request *req)
>  		dout("writepages_finish %p wrote %llu bytes cleaned %d pages\n",
>  		     inode, osd_data->length, rc >= 0 ? num_pages : 0);
>  
> -		ceph_release_pages(osd_data->pages, num_pages);
> +		release_pages(osd_data->pages, num_pages);
>  	}
>  
>  	ceph_put_wrbuffer_cap_refs(ci, total_pages, snapc);

Thanks John. Running tests on it now, and will probably push to our
testing branch later today. It should make v5.4.

-- 
Jeff Layton <jlayton@kernel.org>

