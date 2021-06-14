Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 704B33A662D
	for <lists+ceph-devel@lfdr.de>; Mon, 14 Jun 2021 13:59:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232841AbhFNMBc (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 14 Jun 2021 08:01:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232755AbhFNMBb (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 14 Jun 2021 08:01:31 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C705FC061766
        for <ceph-devel@vger.kernel.org>; Mon, 14 Jun 2021 04:59:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=jMEvPEJJPEUYmWmQjX7gbTWnsuw9HPZJTFxcHXQ/cas=; b=HArlAECJI7KBApOLGkJbbP28my
        /SUxyyja8LLErfbid9MC5fhXHPH5kPMyUMQSmQ3ibRqeqrL2WvkBaAL2oETPWykUrEyVbPpmzGJl3
        53VNJkgm3sIzXD/gcKnKsPqO42rJPh6UHvyVtkFiuHzQTCKk1DiKlMcvIFpo5zMoVSqTX3CLA6P6L
        MS9ugH99jv1x8JuSX30ZpogOq1ceR2HLUpgkVnqAXHSSKLkP6IF42AUZRbGC7xkXeRWARYTrTnAih
        HuLrkqwYiyBSfspWYl0/OfgdGks9drN3QsAE8wztwQIoaQgBMvSEytWWYqNjFr/hZiWcTtL6c6V/y
        +aFdpaaQ==;
Received: from willy by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1lslEx-005Nir-3j; Mon, 14 Jun 2021 11:59:02 +0000
Date:   Mon, 14 Jun 2021 12:58:51 +0100
From:   Matthew Wilcox <willy@infradead.org>
To:     David Howells <dhowells@redhat.com>
Cc:     Jeff Layton <jlayton@kernel.org>, linux-cachefs@redhat.com,
        idryomov@gmail.com, pfmeec@rit.edu, ceph-devel@vger.kernel.org,
        Andrew W Elble <aweits@rit.edu>
Subject: Re: [PATCH] netfs: fix test for whether we can skip read when
 writing beyond EOF
Message-ID: <YMdEe+d2SA5MBrT7@casper.infradead.org>
References: <4d1c9cf43d336b32dceabd2a28e9f68937c2e7a9.camel@kernel.org>
 <20210613233345.113565-1-jlayton@kernel.org>
 <338981.1623665093@warthog.procyon.org.uk>
 <348581.1623671134@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <348581.1623671134@warthog.procyon.org.uk>
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Mon, Jun 14, 2021 at 12:45:34PM +0100, David Howells wrote:
> Jeff Layton <jlayton@kernel.org> wrote:
> 
> > > Why not:
> > > 
> > > 	if (page_offset(page) >= i_size)
> > > 
> > 
> > That doesn't handle THP's correctly. It's just a PAGE_SIZE shift.
> 
> I asked Willy about that one and he said it will.  Now, granted, the code
> doesn't seem to do that, but possibly he has a patch for it?

a THP has its index in units of PAGE_SIZE.  If you have an order-4
page at file offset 32 * PAGE_SIZE, it will have page->index set to 32.
So shifting by PAGE_SIZE is correct.  This contrasts with the insanity
of hugetlbfs which has its index in units of the hpage_size.

The only thing is that you have to pass around the head page.  tail->index
is meaningless.  But you should always be passing around the head page
unless there's a really good reason not to (eg vmf->page where we really
need to know which subpage the fault was in).
