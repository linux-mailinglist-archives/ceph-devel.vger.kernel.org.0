Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D4F43A44CE
	for <lists+ceph-devel@lfdr.de>; Fri, 11 Jun 2021 17:21:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230451AbhFKPXI (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 11 Jun 2021 11:23:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229705AbhFKPXH (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Fri, 11 Jun 2021 11:23:07 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 985FCC061574
        for <ceph-devel@vger.kernel.org>; Fri, 11 Jun 2021 08:21:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=I/5EtfhFfD1E4Z5hwDUvn4/vUJEUyRkhcPz3Uwkf5mY=; b=dWQkpzt103o/XocU+4oWouFJ+Y
        doU1pgOQBgqMRdumkaQNJZsFACmlA9Koc1+wlFDRjDwodk9qNcnWOZV8Ve1XxKdCJRT6mIilicXXl
        KJCA4E65zXL11FIwGx42y/749OphKFuuzCBpBD/bPtWpLemj2GMaJLn58lW9wemkso1//QZzaD6gZ
        2v/oaW7QZKzawSZF3LZAdAqctIgZt/TTgmHzu0Oa7Ckqjq6xU5H8i4mgXUhqDX5PnhB1AWmfstYu2
        EgRaAx84JFcDy7aRDVwobJO1dDu/oN2ZNz/MgfrfajB/7zWWZ1+3oaMnWITZzXhzjKMspg66JEIca
        E04rrnwg==;
Received: from willy by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1lrixR-002rst-8i; Fri, 11 Jun 2021 15:20:35 +0000
Date:   Fri, 11 Jun 2021 16:20:29 +0100
From:   Matthew Wilcox <willy@infradead.org>
To:     David Howells <dhowells@redhat.com>
Cc:     Jeff Layton <jlayton@kernel.org>, Andrew W Elble <aweits@rit.edu>,
        ceph-devel@vger.kernel.org, pfmeec@rit.edu,
        linux-cachefs@redhat.com
Subject: Re: [PATCH 5/5] ceph: fold ceph_update_writeable_page into
 ceph_write_begin
Message-ID: <YMN/PfW2t8e5M58m@casper.infradead.org>
References: <a24c3c070c9fc3529a51f00f9ccc3d0abdd0b821.camel@kernel.org>
 <20200916173854.330265-1-jlayton@kernel.org>
 <20200916173854.330265-6-jlayton@kernel.org>
 <7817f98d3b2daafe113bf8290cc8c7adbb86fe99.camel@kernel.org>
 <m2h7i45vzl.fsf@discipline.rit.edu>
 <66264.1623424309@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <66264.1623424309@warthog.procyon.org.uk>
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Fri, Jun 11, 2021 at 04:11:49PM +0100, David Howells wrote:
> Jeff Layton <jlayton@kernel.org> wrote:
> 
> > On Fri, 2021-06-11 at 10:14 -0400, Andrew W Elble wrote:
> > > We're seeing file corruption while running 5.10, bisected to 1cc1699070bd:
> > > 
> > > > > +static int ceph_write_begin(struct file *file, struct address_space *mapping,
> > > > > +			    loff_t pos, unsigned len, unsigned flags,
> > > > > +			    struct page **pagep, void **fsdata)
> > > 
> > > <snip>
> > > 
> > > > > +		/*
> > > > > +		 * In some cases we don't need to read at all:
> > > > > +		 * - full page write
> > > > > +		 * - write that lies completely beyond EOF
> > > > > +		 * - write that covers the the page from start to EOF or beyond it
> > > > > +		 */
> > > > > +		if ((pos_in_page == 0 && len == PAGE_SIZE) ||
> > > > > +		    (pos >= i_size_read(inode)) ||
> > > 
> > > Shouldn't this be '((pos & PAGE_MASK) >= i_size_read(inode)) ||' ?
> > > 
> > > Seems like fs/netfs/read_helper.c currently has the same issue?

How does (pos & PAGE_MASK) >= i_size_read() make sense?  That could only
be true if the file is less than a page in size, whereas it should
always be true if the write starts outside the current i_size.

> That's not quite right either.  page may be larger than PAGE_MASK if
> grab_cache_page_write_begin() returns a THP (if that's possible).
> 
> Maybe:
> 
> 	(pos & thp_size(page) - 1) >= i_size_read(inode)
> 
> Really, we want something like thp_pos().  Maybe Willy has something like that
> up his sleeve.
> 
> In fact, in netfs_write_begin(), index and pos_in_page should be calculated
> after grab_cache_page_write_begin() has been called, just in case the new page
> extends before the page containing the requested position.

Yes.  I do that kind of thing in iomap.  What you're doing there looks
a bit like offset_in_folio(), but I don't understand the problem with
just checking pos against i_size directly.

https://git.infradead.org/users/willy/pagecache.git/shortlog/refs/heads/folio
contains a number of commits that start 'iomap:' which may be of interest.
