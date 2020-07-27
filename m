Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5644B22ED7F
	for <lists+ceph-devel@lfdr.de>; Mon, 27 Jul 2020 15:36:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728220AbgG0NgB (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 27 Jul 2020 09:36:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:38350 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726298AbgG0NgA (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Mon, 27 Jul 2020 09:36:00 -0400
Received: from tleilax.poochiereds.net (68-20-15-154.lightspeed.rlghnc.sbcglobal.net [68.20.15.154])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F25DA20672;
        Mon, 27 Jul 2020 13:35:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595856960;
        bh=nQPMLV2pRAnKLbxdF7Pi3Zysr8TRhC+bmSClTWZUc1w=;
        h=Subject:From:To:Date:In-Reply-To:References:From;
        b=hsB1U+2xzAPLjcqm1Ah6LiUhNRjEaKfwduPTKSGLFpwFBq414h5mZYccxllK7tw7V
         C8bWJaZWbDEGRMT5uue2S9KoM4yLzxCUhZKV0eC1JWQaLYjaxyyOf5GCodpe6hG86h
         rT4H4jkIBJl87rK043TXROeoALzPT+8dhcnYIt9w=
Message-ID: <b9c88da029462acd45dea1035e5be3c4f40463d0.camel@kernel.org>
Subject: Re: [PATCH] ceph: fix memory leak when reallocating pages array for
 writepages
From:   Jeff Layton <jlayton@kernel.org>
To:     Xiubo Li <xiubli@redhat.com>, ceph-devel@vger.kernel.org
Date:   Mon, 27 Jul 2020 09:35:59 -0400
In-Reply-To: <f1265009-9d5c-4685-8ecf-8e06e7500baa@redhat.com>
References: <20200726122804.16008-1-jlayton@kernel.org>
         <3c8fb2aa-834b-a202-24b4-7eb29cd9b7c3@redhat.com>
         <ff6497016429a0ba962d97d6997427a5020ac6d4.camel@kernel.org>
         <f1265009-9d5c-4685-8ecf-8e06e7500baa@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.4 (3.36.4-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Mon, 2020-07-27 at 21:27 +0800, Xiubo Li wrote:
> On 2020/7/27 21:18, Jeff Layton wrote:
> > On Mon, 2020-07-27 at 20:16 +0800, Xiubo Li wrote:
> > > On 2020/7/26 20:28, Jeff Layton wrote:
> > > > Once we've replaced it, we don't want to keep the old one around
> > > > anymore.
> > > > 
> > > > Signed-off-by: Jeff Layton <jlayton@kernel.org>
> > > > ---
> > > >    fs/ceph/addr.c | 1 +
> > > >    1 file changed, 1 insertion(+)
> > > > 
> > > > diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
> > > > index 01ad09733ac7..01e167efa104 100644
> > > > --- a/fs/ceph/addr.c
> > > > +++ b/fs/ceph/addr.c
> > > > @@ -1212,6 +1212,7 @@ static int ceph_writepages_start(struct address_space *mapping,
> > > >    			       locked_pages * sizeof(*pages));
> > > >    			memset(data_pages + i, 0,
> > > >    			       locked_pages * sizeof(*pages));
> > > BTW， do we still need to memset() the data_pages ?
> > > 
> > Self-NAK on this patch...
> > 
> > Zheng pointed out that this array is actually freed by the request
> > handler after the submission. This loop is creating a new pages array
> > for a second request.
> 
> Do you mean ceph_osd_data_release() ?
> 
> The request is only freeing the pages in that arrary, not the arrary 
> itself, did I miss something ?
> 
> 

No, I meant in writepages_finish(). It has this:

        if (osd_data->pages_from_pool)
                mempool_free(osd_data->pages,
                             ceph_sb_to_client(inode->i_sb)->wb_pagevec_pool);
        else
                kfree(osd_data->pages);

The pages themselves are freed in the loop above that point however.

> > As far as whether we need to memset the end of the original array...I
> > don't think we do. It looks like the pointers at the end of the array
> > are ignored once you go past the length of the request. That said, it's
> > fairly cheap to do so, and I'm not inclined to change it, just in case
> > there is code that does look at those pointers.
> > 
> > > > +			kfree(data_pages);
> > > >    		} else {
> > > >    			BUG_ON(num_ops != req->r_num_ops);
> > > >    			index = pages[i - 1]->index + 1;

-- 
Jeff Layton <jlayton@kernel.org>

