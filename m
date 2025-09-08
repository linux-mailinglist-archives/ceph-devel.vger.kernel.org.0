Return-Path: <ceph-devel+bounces-3559-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 16452B49280
	for <lists+ceph-devel@lfdr.de>; Mon,  8 Sep 2025 17:07:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C88241891973
	for <lists+ceph-devel@lfdr.de>; Mon,  8 Sep 2025 15:07:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 26C5B30DD11;
	Mon,  8 Sep 2025 15:06:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="KJMZiDJg"
X-Original-To: ceph-devel@vger.kernel.org
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49F901F0E2E;
	Mon,  8 Sep 2025 15:06:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757343990; cv=none; b=YGMvQA7QABtt+SN5kyHB/kCvwarOMNH+CcdZZPDqKUfjPhk79Ad3KrywkEchltl2qUqCmViRXa8DayVa+KrFem7kcM8+WuvBYgqPpf/dn30i8r/Nq+OASVkoNHHKZtcQROjlzirEdwEMEZ2/7oUPz+5SbHKZENYGkQe43Tq+3G8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757343990; c=relaxed/simple;
	bh=lt+DeUdtdNPuhYg1kY8OE6fJy91fRM6JkDhgek3BnXg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YTZBVd9o2YI63zs+5cYJ0iM45lGjHUvDEIeC5LXS9BGcQCtOop+qUyr5o1Nk2Bo4F4Ot2FxPKOtYAkVG0fixOPJSrVWFsBzYH0fjCxkC6WVxsZYxy7Z6YNYkFJK0UscIEk0Xx+Z7nRP6Jm+0FHtHDJvp/6jvJitYBAEIrVXVNnw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=KJMZiDJg; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=XRKdWPBqgxOOD4haFDefsclhOM8qE/foLVBPNAM3ND4=; b=KJMZiDJgZSjSvrkiLoBzlDQ3fY
	oaIifBFepzZkP/eDQFau5WyJdZTeWYTG+aCWbu3GSzU59ERFD24hJKAuZqGFcBPX7LtKSP/WNqCYn
	wNnWkMojKtUKCns7ttt6tjKGhNUSTH5i74HLkMha4GJVppiDNTcq2XsrkzjHet4Lj7I6oi0nrdRYK
	BBflvfGs3g+E6KUN8RIjnM8+jNk5o7WOFNLOQbgLVSBHrmz0ccf09+/U1Qwv9CyOtkijC3iZbqS30
	rDfTvSk//9KB6TGNt42V6Cjzx91BA91DRJCf0QdCJh9gnwDeb2GxG2ECWM4n2bSSRzxg0NmBIKZVn
	WIvZFaSQ==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uvdRb-00000008eVw-15VO;
	Mon, 08 Sep 2025 15:06:11 +0000
Date: Mon, 8 Sep 2025 16:06:10 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Hugh Dickins <hughd@google.com>
Cc: David Hildenbrand <david@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Will Deacon <will@kernel.org>, Shivank Garg <shivankg@amd.com>,
	Christoph Hellwig <hch@infradead.org>,
	Keir Fraser <keirf@google.com>, Jason Gunthorpe <jgg@ziepe.ca>,
	John Hubbard <jhubbard@nvidia.com>,
	Frederick Mayle <fmayle@google.com>, Peter Xu <peterx@redhat.com>,
	"Aneesh Kumar K.V" <aneesh.kumar@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Vlastimil Babka <vbabka@suse.cz>,
	Alexander Krabler <Alexander.Krabler@kuka.com>,
	Ge Yang <yangge1116@126.com>, Li Zhe <lizhe.67@bytedance.com>,
	Chris Li <chrisl@kernel.org>, Yu Zhao <yuzhao@google.com>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
	Konstantin Khlebnikov <koct9i@gmail.com>,
	David Howells <dhowells@redhat.com>, ceph-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 1/7] mm: fix folio_expected_ref_count() when PG_private_2
Message-ID: <aL7w4qrJtvKE1cu5@casper.infradead.org>
References: <a28b44f7-cdb4-8b81-4982-758ae774fbf7@google.com>
 <f91ee36e-a8cb-e3a4-c23b-524ff3848da7@google.com>
 <aLTcsPd4SUAAy5Xb@casper.infradead.org>
 <52da6c6a-e568-38bd-775b-eff74f87215b@google.com>
 <92def216-ca9c-402d-8643-226592ca1a85@redhat.com>
 <2e069441-0bc6-4799-9176-c7a76c51158f@redhat.com>
 <3973ecd7-d99c-6d38-7b53-2f3fca57b48d@google.com>
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3973ecd7-d99c-6d38-7b53-2f3fca57b48d@google.com>

On Mon, Sep 08, 2025 at 03:27:47AM -0700, Hugh Dickins wrote:
> On Mon, 1 Sep 2025, David Hildenbrand wrote:
> > On 01.09.25 09:52, David Hildenbrand wrote:
> > > On 01.09.25 03:17, Hugh Dickins wrote:
> > >> On Mon, 1 Sep 2025, Matthew Wilcox wrote:
> > >>> On Sun, Aug 31, 2025 at 02:01:16AM -0700, Hugh Dickins wrote:
> > >>>> 6.16's folio_expected_ref_count() is forgetting the PG_private_2 flag,
> > >>>> which (like PG_private, but not in addition to PG_private) counts for
> > >>>> 1 more reference: it needs to be using folio_has_private() in place of
> > >>>> folio_test_private().
> > >>>
> > >>> No, it doesn't.  I know it used to, but no filesystem was actually doing
> > >>> that.  So I changed mm to match how filesystems actually worked.
> 
> I think Matthew may be remembering how he wanted it to behave (? but he
> wanted it to go away completely) rather than how it ended up behaving:
> we've both found that PG_private_2 always goes with refcount increment.

Let me explain that better.  No filesystem followed the documented rule
that the refcount must be incremented by one if either PG_private or
PG_private_2 was set.  And no surprise; that's a very complicated rule
for filesystems to follow.  Many of them weren't even following the rule
to increment the refcount by one when PG_private was set.

So some were incrementing the refcount by one if PG_private were set, but
not bumping the refcount by one if PG_private_2 were set (I think this is
how btrfs worked, and you seem to believe the same thing).  Others were
bumping the refcount by two if both PG_private and PG_private_2 were set
(I think this is how netfs works today).

> > > Now, one problem would be if migration / splitting / ... code where we
> > > use folio_expected_ref_count() cannot deal with that additional
> > > reference properly, in which case this patch would indeed cause harm.
> 
> Yes, that appears to be why Matthew said NAK and "dangerously wrong".
> 
> So far as I could tell, there is no problem with nfs, it has, and has
> all along had, the appropriate release_folio and migrate_folio methods.
> 
> ceph used to have what's needed, but 6.0's changes from page_has_private()
> to folio_test_private() (the change from "has" either bit to "test" just
> the one bit really should have been highlighted) broke the migration of
> ceph's PG_private_2 folios.
> 
> (I think it may have got re-enabled in intervening releases: David
> Howells reinstated folio_has_private() inside fallback_migrate_folio()'s
> filemap_release_folio(), which may have been enough to get ceph's
> PG_private_2s migratable again; but then 6.15's ceph .migrate_folio =
> filemap_migrate_folio will have broken it again.)
> 
> Folio migration does not and never has copied over PG_private_2 from
> src to dst; so my 1/7 patch would have permitted migration of a ceph
> PG_private_2 src folio to a dst folio left with refcount 1 more than
> it should be (plus whatever the consequences of migrating such a
> folio which should have waited for the flag to be cleared first).

But that's another problem.  The current meaning of PG_fscache (and also
that has changed over the years!) is that the data in the folio is being
written to the fscache.  So we _shouldn't_ migrate the folio as some
piece of storage hardware is busy reading from the old folio.  And if
somebody else starts writing to the old folio, we'll have a corrupted
fscache.

So the current behaviour where we set private_2 and bump the refcount,
but don't take the private_2 status into account is the safe one,
because the elevated refcount means we'll skip the PG_fscache folio.
Maybe it'd be better to wait for it to clear.  But since Dave Howells
is busy killing it off, I'm just inclined to wait for that to happen.

> I'm just going to drop this 1/7, and add a (briefer than this!)
> paragraph to 2/7 == 1/6's commit message in v2 later today.

Thank you!

