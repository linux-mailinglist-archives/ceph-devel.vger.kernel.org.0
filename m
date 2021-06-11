Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 04F963A4595
	for <lists+ceph-devel@lfdr.de>; Fri, 11 Jun 2021 17:38:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230373AbhFKPkj (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 11 Jun 2021 11:40:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:34986 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231844AbhFKPki (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Fri, 11 Jun 2021 11:40:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2D689613CD;
        Fri, 11 Jun 2021 15:38:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623425920;
        bh=/qD8/RYU7AaSsvuFN56bjUL4doqxsAo7Mma5HZNTN6c=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=QmjA1hwxS4BecPWeCpqqdDZDCqV1xOusnKDvCin7g5ua51lHwKR3pqQHSH6zs7TUI
         og5sB4sTX+qMOHUTi5b+URVm/3uac4KD9UWoWZNOQlG3OdTOjgJ1jATGfiH1x4yro/
         DoRwPBE9YRmnKQ/eE9++XiplLuVQ9MFctliDwxP2t9Av7PhS+xXimXAPvUb+H1Qx51
         BfYQlsgx3ody/gKWvKtXsSeCyVIfyKs6EQ2G6GsMCoDtju/EaU8hKRq5UNb66pPJm+
         7+qGsW06LvqOy41A06Qhss7ZppOfhAGx81QlTsFAE8SnZKc2dgzpPABIr928u4ZLIB
         2nkVQ/AgYQxBw==
Message-ID: <d9fec91d22d985737ceefbc2b8f02c42dfed7df8.camel@kernel.org>
Subject: Re: [PATCH 5/5] ceph: fold ceph_update_writeable_page into
 ceph_write_begin
From:   Jeff Layton <jlayton@kernel.org>
To:     Matthew Wilcox <willy@infradead.org>,
        David Howells <dhowells@redhat.com>
Cc:     Andrew W Elble <aweits@rit.edu>, ceph-devel@vger.kernel.org,
        pfmeec@rit.edu, linux-cachefs@redhat.com
Date:   Fri, 11 Jun 2021 11:38:39 -0400
In-Reply-To: <YMN/PfW2t8e5M58m@casper.infradead.org>
References: <a24c3c070c9fc3529a51f00f9ccc3d0abdd0b821.camel@kernel.org>
         <20200916173854.330265-1-jlayton@kernel.org>
         <20200916173854.330265-6-jlayton@kernel.org>
         <7817f98d3b2daafe113bf8290cc8c7adbb86fe99.camel@kernel.org>
         <m2h7i45vzl.fsf@discipline.rit.edu>
         <66264.1623424309@warthog.procyon.org.uk>
         <YMN/PfW2t8e5M58m@casper.infradead.org>
Content-Type: text/plain; charset="ISO-8859-15"
User-Agent: Evolution 3.40.1 (3.40.1-1.fc34) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Fri, 2021-06-11 at 16:20 +0100, Matthew Wilcox wrote:
> On Fri, Jun 11, 2021 at 04:11:49PM +0100, David Howells wrote:
> > Jeff Layton <jlayton@kernel.org> wrote:
> > 
> > > On Fri, 2021-06-11 at 10:14 -0400, Andrew W Elble wrote:
> > > > We're seeing file corruption while running 5.10, bisected to 1cc1699070bd:
> > > > 
> > > > > > +static int ceph_write_begin(struct file *file, struct address_space *mapping,
> > > > > > +			    loff_t pos, unsigned len, unsigned flags,
> > > > > > +			    struct page **pagep, void **fsdata)
> > > > 
> > > > <snip>
> > > > 
> > > > > > +		/*
> > > > > > +		 * In some cases we don't need to read at all:
> > > > > > +		 * - full page write
> > > > > > +		 * - write that lies completely beyond EOF
> > > > > > +		 * - write that covers the the page from start to EOF or beyond it
> > > > > > +		 */
> > > > > > +		if ((pos_in_page == 0 && len == PAGE_SIZE) ||
> > > > > > +		    (pos >= i_size_read(inode)) ||
> > > > 
> > > > Shouldn't this be '((pos & PAGE_MASK) >= i_size_read(inode)) ||' ?
> > > > 
> > > > Seems like fs/netfs/read_helper.c currently has the same issue?
> 
> How does (pos & PAGE_MASK) >= i_size_read() make sense?  That could only
> be true if the file is less than a page in size, whereas it should
> always be true if the write starts outside the current i_size.
> 

Yeah, I guess what we really need is to round the i_size up to the start
of the next page and then compare whether pos is beyond that.

> > That's not quite right either.  page may be larger than PAGE_MASK if
> > grab_cache_page_write_begin() returns a THP (if that's possible).
> > 
> > Maybe:
> > 
> > 	(pos & thp_size(page) - 1) >= i_size_read(inode)
> > 
> > Really, we want something like thp_pos().  Maybe Willy has something like that
> > up his sleeve.
> > 
> > In fact, in netfs_write_begin(), index and pos_in_page should be calculated
> > after grab_cache_page_write_begin() has been called, just in case the new page
> > extends before the page containing the requested position.
> 
> Yes.  I do that kind of thing in iomap.  What you're doing there looks
> a bit like offset_in_folio(), but I don't understand the problem with
> just checking pos against i_size directly.
> 

Suppose the i_size is 3 and you do a 1 byte write at offset 5. You're
beyond the EOF, so the condition would return true, but you still need
to read in the start of the page in that case.

I think we probably need a testcase that does this in xfstests:

open file
write 3 bytes at start
close
unmount or drop pagecache in some way
then write 1 byte at offset 5
see whether the resulting contents match the expect ones

>
https://git.infradead.org/users/willy/pagecache.git/shortlog/refs/heads/folio
> contains a number of commits that start 'iomap:' which may be of interest.

-- 
Jeff Layton <jlayton@kernel.org>

