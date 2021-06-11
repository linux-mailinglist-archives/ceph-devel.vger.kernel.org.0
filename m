Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 794A73A4837
	for <lists+ceph-devel@lfdr.de>; Fri, 11 Jun 2021 19:57:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229969AbhFKR7W (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 11 Jun 2021 13:59:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229572AbhFKR7W (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Fri, 11 Jun 2021 13:59:22 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E98CFC061574
        for <ceph-devel@vger.kernel.org>; Fri, 11 Jun 2021 10:57:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=0LTf2IBkERT6izmxLAnZBQfhT9dMuwZ0+CGqKcpqwKA=; b=qBJZhXbZDMuSkco/9EzrISWIJR
        ckpjfR5KSoBigK41ud5kIEcINdhsy4sRNA9Qd/vt3FqNbSUGYvTRfTIJvSsJqKkNZxD+Af3Q4WLWw
        nnKMTK1YB7+GOflaAVAps7RoP01YdiOzKqq9QzkTqj3jd/G+gU1o35kOP/OcpoHjcC+IP/cgo588v
        YzIDzgh7iR57Bd7UdcScIg730y9yWWGGbeti6esRnf4uzijcI73U1u8qUf60HzwuqEH7n9yFBGxNS
        TOkhPk+ADMd8wmUxRD8tzpIL7sWA9XaC49x6Um9Nxeodv2fzsOW5fwjCOZQKWM69PTt3OFbld1ora
        u7LFYbaw==;
Received: from willy by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1lrlOY-002zx8-Nm; Fri, 11 Jun 2021 17:56:51 +0000
Date:   Fri, 11 Jun 2021 18:56:38 +0100
From:   Matthew Wilcox <willy@infradead.org>
To:     David Howells <dhowells@redhat.com>
Cc:     Jeff Layton <jlayton@kernel.org>, Andrew W Elble <aweits@rit.edu>,
        ceph-devel@vger.kernel.org, pfmeec@rit.edu,
        linux-cachefs@redhat.com
Subject: Re: [PATCH 5/5] ceph: fold ceph_update_writeable_page into
 ceph_write_begin
Message-ID: <YMOj1rjCOb4fQo5Y@casper.infradead.org>
References: <YMN/PfW2t8e5M58m@casper.infradead.org>
 <a24c3c070c9fc3529a51f00f9ccc3d0abdd0b821.camel@kernel.org>
 <20200916173854.330265-1-jlayton@kernel.org>
 <20200916173854.330265-6-jlayton@kernel.org>
 <7817f98d3b2daafe113bf8290cc8c7adbb86fe99.camel@kernel.org>
 <m2h7i45vzl.fsf@discipline.rit.edu>
 <66264.1623424309@warthog.procyon.org.uk>
 <68477.1623425725@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <68477.1623425725@warthog.procyon.org.uk>
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Fri, Jun 11, 2021 at 04:35:25PM +0100, David Howells wrote:
> Matthew Wilcox <willy@infradead.org> wrote:
> 
> > Yes.  I do that kind of thing in iomap.  What you're doing there looks
> > a bit like offset_in_folio(), but I don't understand the problem with
> > just checking pos against i_size directly.
> 
> pos can be in the middle of a page.  If i_size is at, say, the same point in
> the middle of that page and the page isn't currently in the cache, then we'll
> just clear the entire page and not read the bottom part of it (ie. the bit
> prior to the EOF).

The comment says that's expected, though.  I think the comment is wrong;
consider the case where the page size is 4kB, file is 5kB long and
we do a 1kB write at offset=6kB.  The existing CEPH code (prior to
netfs) will zero out 4-6KB and 7-8kB, which is wrong.

Anyway, looking at netfs_write_begin(), it's wrong too, in a bunch of
ways.  You don't need to zero out the part of the page you're going to
copy into.  And the condition is overly complicated which makes it
hard to know what's going on.  Setting aside the is_cache_enabled part,
I think you want:

	if (offset == 0 && len >= thp_size(page))
		goto have_page_no_wait;
	if (page_offset(page) >= size) {
		zero_user_segments(page, 0, offset,
				   offset + len, thp_size(page));
		goto have_page_no_wait;
	}
	... read the interesting chunks of page ...

