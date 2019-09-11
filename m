Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1A93FAF5D0
	for <lists+ceph-devel@lfdr.de>; Wed, 11 Sep 2019 08:32:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726793AbfIKGcA (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 11 Sep 2019 02:32:00 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:50692 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725906AbfIKGcA (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 11 Sep 2019 02:32:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=rSMXG9Hy9fZNo02FoEJGjdCjy4PTCmZ0SD4kb7qkntQ=; b=GSwrIGsfvPSeQJ81u5cQj7Qdq
        5K8ynVM1yiCDt1mXHLWuO4S/tVMo9V63ppWlOeVDlYCzlLBuTMam6jDOYmkAObLCTQ0aLEwOzti/K
        tWNbJr1B0URx0XKRcUo9zrzs20b1Vdl4pqsP6o3ut5NXv2LtqMTS1UuoBVfUd2D+5O7XzWJl9J0Ly
        MBDnqBklXS7L3Sxdd8njoeO+cLvbsRFk+2gvy5rWshZmGaOoHS4BtEDpeLEoXHaCcoZAEPV8VSI4I
        Rcu9Lr5foHjC6bQtIkKR2VKbp6Lpdy3VmYBthrOxaindVzjLW6QE72DAq+YiqQdFSYty7nZGA51yh
        RuFNEt8Aw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92 #3 (Red Hat Linux))
        id 1i7wAZ-0006fl-My; Wed, 11 Sep 2019 06:31:59 +0000
Date:   Tue, 10 Sep 2019 23:31:59 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Ilya Dryomov <idryomov@gmail.com>
Cc:     ceph-devel@vger.kernel.org
Subject: Re: [PATCH] libceph: avoid a __vmalloc() deadlock in ceph_kvmalloc()
Message-ID: <20190911063159.GA25496@infradead.org>
References: <20190910151748.914-1-idryomov@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190910151748.914-1-idryomov@gmail.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Tue, Sep 10, 2019 at 05:17:48PM +0200, Ilya Dryomov wrote:
> The vmalloc allocator doesn't fully respect the specified gfp mask:
> while the actual pages are allocated as requested, the page table pages
> are always allocated with GFP_KERNEL.  ceph_kvmalloc() may be called
> with GFP_NOFS and GFP_NOIO (for ceph and rbd respectively), so this may
> result in a deadlock.
> 
> There is no real reason for the current PAGE_ALLOC_COSTLY_ORDER logic,
> it's just something that seemed sensible at the time (ceph_kvmalloc()
> predates kvmalloc()).  kvmalloc() is smarter: in an attempt to reduce
> long term fragmentation, it first tries to kmalloc non-disruptively.
> 
> Switch to kvmalloc() and set the respective PF_MEMALLOC_* flag using
> the scope API to avoid the deadlock.  Note that kvmalloc() needs to be
> passed GFP_KERNEL to enable the fallback.

If you can please just stop using GFP_NOFS altogether and set
PF_MEMALLOC_* for the actual contexts.
