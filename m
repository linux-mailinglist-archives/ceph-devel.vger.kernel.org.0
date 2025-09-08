Return-Path: <ceph-devel+bounces-3555-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 23342B48A2C
	for <lists+ceph-devel@lfdr.de>; Mon,  8 Sep 2025 12:28:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CCEE43AA361
	for <lists+ceph-devel@lfdr.de>; Mon,  8 Sep 2025 10:28:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B2A512F60CC;
	Mon,  8 Sep 2025 10:28:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="jTXfZHow"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-yb1-f173.google.com (mail-yb1-f173.google.com [209.85.219.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C36D72F3617
	for <ceph-devel@vger.kernel.org>; Mon,  8 Sep 2025 10:28:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757327286; cv=none; b=PPR6GTfjIIPovZ+2usPnH1e6cQUYzm2ODSEPXsqSoa2kanoUWYtbbrMaUMfTPrA9qQz74+5V//RRpTP5nP6e3G6MdZa/Gs8UUCHsDefp2eag0ExtAznK2djrmgWfc3hs3skIy/ZAMO7y3XUAQVIhIaXsCTF//nVIH265P+6vMvI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757327286; c=relaxed/simple;
	bh=0uA9ZRM688WYYat0LpSesUOo4rs7caQt8xOBai0wi0w=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=RUCNz0NqMVcfeuMl+zqxuig7Bk8JPJ1KuIaDbjtp9jACUleXepR0mMzTMgc+kiMSUgbq/rWLy7tJSJjWZbQpesgrnrAiMceaIxZojWJSuLRI0xe6sFpak5BweCfJHHEiB11tqp1gq4X41npq7+fUmYXXzHfXFWuCd8ODclPq2xI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=jTXfZHow; arc=none smtp.client-ip=209.85.219.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-yb1-f173.google.com with SMTP id 3f1490d57ef6-e96f401c478so3261153276.3
        for <ceph-devel@vger.kernel.org>; Mon, 08 Sep 2025 03:28:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1757327284; x=1757932084; darn=vger.kernel.org;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=QstgO/h652tnHFsITLWw6M/Son5KgedEpVG+JcbZcbs=;
        b=jTXfZHowsPtvkHyAGB6QF7+sRg6wDguQ6wWL6TU5hfqijiiklC3yzSPWFLtCvHkLGS
         BPW87oNQwEn0v55YSen6fnCB6mus9ZUfRKUmMSXWsNKaKLPd/uIkdZ4W6T30+KsZQdeE
         kg3c/yVurNsld6gVyOMacI+DbZh8WC7ItPIYi1ezMcUw4YtbvAJ34QJlaxxw8IyHWsI8
         SWO+5FYGzLkTyckCbKvmz39oYYQD2+K0FhUYlAG1zR3x7Mk6nMbBt3TP8RCnBJrhuzMr
         ZJ8CsvrwDZrSkBy7lw8nGUFnUz21WZScmj2HDhKl+X4RoPHFcjgfwvX3tIJQ+VmV9Voh
         snMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757327284; x=1757932084;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=QstgO/h652tnHFsITLWw6M/Son5KgedEpVG+JcbZcbs=;
        b=m8ufXrFfGl4/3NEcmc18UZPLrtoI7sWQSJPQ+DBCFWv7THXawlZ2kI3yHTJp36uICo
         RBI1c6aYIajrOU/WT/AQjSlz5BzghM6eo2HAyMbu1NNGaOkSXp8TyXDeckFwVuG7aD3p
         qoG6fLTh1VoAr5uM04RCdtcpP/1zgSRnssw+x8LPXBdyLvpqkzxzTuGuZ6n/DmexjJLX
         iUJxe6GQk5PhO17oPi+AFKsvY3r4lPcJ2haSKybUMEIlLTmlnHIU8BH5TnNzutgNojzl
         nVAF8A9RnlFFWYWvlV68X98qPON9Mhhepn6Bl+bMxsOtwSMg3k8GidFptdyrgxewgEO4
         BTjA==
X-Forwarded-Encrypted: i=1; AJvYcCV5xtSQXIKUdiQfPP79rrber/KZaXB4Cj0A8dF97sR3sk0i418KV6hSYEcKN6wEDdN5LNo+lOblAfX+@vger.kernel.org
X-Gm-Message-State: AOJu0YzvMc5J9jnuEN6SX5DRcz5LvkTrBO5CStTZjXfrsi75FlhB+yZD
	kXQPWvshdyhut+P2kqzlYCEvKQFrloLa4dGEEpE8I+u6ipmUDCrUHPCiMInM6q1U7Q==
X-Gm-Gg: ASbGncuEC/ZSPFZsjAi4wib/s+1cfJeebZL4zPpIgk0VnNP0AnwD1LfN0XZliRf6RTx
	nijTveBcdEVyWM+YGoD93Cok3LYzQeKucrpf9UZxLp9SvoCY8FZjj+xLVq0SRhyHL3S8ixQizRl
	nkmLQlBaav9VreFvbsj4vJUqPPSVdcLd8CsF/oADTjZ/UGQWUCxFBSNPgXyu5fBPqQcHk6k0mJf
	+PHrBCn96wsGYWCBWyP69lwplKYHMRo9lPYtIOB8/OySy5+AvpwSzRMZHZOV1WaNMaEiNFDkRds
	NSkyuz3165oOsYmLidnmOIIDPC9G4sCxd1XxQatcCaRZpN0rluVC6V2poIk4hQkcdurl+FwA4c8
	aM8F2VsJAX/IrPS/JQ9aHKf53O15MxrRHFzSuYKvWffV8t6P/e504/HSgq/nVzKhHS2OlGBKbJz
	jXSTF2RTkqqRc+MDK24HgIh1os
X-Google-Smtp-Source: AGHT+IEG0zC/H9tZD5Bx0cYfI7uzkElpcV9FNOtoZ7SRGcnoij3YDPgfHLSxfLTqn763yITqfrPidA==
X-Received: by 2002:a05:690c:368e:b0:722:7d35:e08d with SMTP id 00721157ae682-727f2dbf41amr79303667b3.10.1757327283278;
        Mon, 08 Sep 2025 03:28:03 -0700 (PDT)
Received: from darker.attlocal.net (172-10-233-147.lightspeed.sntcca.sbcglobal.net. [172.10.233.147])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-723a85ae667sm51092367b3.64.2025.09.08.03.27.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Sep 2025 03:28:00 -0700 (PDT)
Date: Mon, 8 Sep 2025 03:27:47 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
To: David Hildenbrand <david@redhat.com>
cc: Hugh Dickins <hughd@google.com>, Matthew Wilcox <willy@infradead.org>, 
    Andrew Morton <akpm@linux-foundation.org>, Will Deacon <will@kernel.org>, 
    Shivank Garg <shivankg@amd.com>, Christoph Hellwig <hch@infradead.org>, 
    Keir Fraser <keirf@google.com>, Jason Gunthorpe <jgg@ziepe.ca>, 
    John Hubbard <jhubbard@nvidia.com>, Frederick Mayle <fmayle@google.com>, 
    Peter Xu <peterx@redhat.com>, "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, 
    Johannes Weiner <hannes@cmpxchg.org>, Vlastimil Babka <vbabka@suse.cz>, 
    Alexander Krabler <Alexander.Krabler@kuka.com>, 
    Ge Yang <yangge1116@126.com>, Li Zhe <lizhe.67@bytedance.com>, 
    Chris Li <chrisl@kernel.org>, Yu Zhao <yuzhao@google.com>, 
    Axel Rasmussen <axelrasmussen@google.com>, 
    Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
    Konstantin Khlebnikov <koct9i@gmail.com>, 
    David Howells <dhowells@redhat.com>, ceph-devel@vger.kernel.org, 
    linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 1/7] mm: fix folio_expected_ref_count() when
 PG_private_2
In-Reply-To: <2e069441-0bc6-4799-9176-c7a76c51158f@redhat.com>
Message-ID: <3973ecd7-d99c-6d38-7b53-2f3fca57b48d@google.com>
References: <a28b44f7-cdb4-8b81-4982-758ae774fbf7@google.com> <f91ee36e-a8cb-e3a4-c23b-524ff3848da7@google.com> <aLTcsPd4SUAAy5Xb@casper.infradead.org> <52da6c6a-e568-38bd-775b-eff74f87215b@google.com> <92def216-ca9c-402d-8643-226592ca1a85@redhat.com>
 <2e069441-0bc6-4799-9176-c7a76c51158f@redhat.com>
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII

On Mon, 1 Sep 2025, David Hildenbrand wrote:
> On 01.09.25 09:52, David Hildenbrand wrote:
> > On 01.09.25 03:17, Hugh Dickins wrote:
> >> On Mon, 1 Sep 2025, Matthew Wilcox wrote:
> >>> On Sun, Aug 31, 2025 at 02:01:16AM -0700, Hugh Dickins wrote:
> >>>> 6.16's folio_expected_ref_count() is forgetting the PG_private_2 flag,
> >>>> which (like PG_private, but not in addition to PG_private) counts for
> >>>> 1 more reference: it needs to be using folio_has_private() in place of
> >>>> folio_test_private().
> >>>
> >>> No, it doesn't.  I know it used to, but no filesystem was actually doing
> >>> that.  So I changed mm to match how filesystems actually worked.

I think Matthew may be remembering how he wanted it to behave (? but he
wanted it to go away completely) rather than how it ended up behaving:
we've both found that PG_private_2 always goes with refcount increment.

(Always? Well, until 6.13, btrfs used PG_private_2 without any such
increment: that's gone, so now it's consistently with refcount increment.)

Confusing, given David Howells removed deprecated use of PG_private_2
then later reverted the removal: I've not looked up which releases those
came and went, but reverted in stable trees too, so story all the same;
but maybe some of Matthew's mods interleaved between removal and revert.

> >>> I'm not sure if there's still documentation lying around that gets
> >>> this wrong or if you're remembering how things used to be documented,
> >>> but it's never how any filesystem has ever worked.

Not how btrfs used to work, but it is how ceph and nfs work.

> >>>
> >>> We're achingly close to getting rid of PG_private_2.  I think it's just
> >>> ceph and nfs that still use it.
> >>
> >> I knew you were trying to get rid of it (hurrah! thank you), so when I
> >> tried porting my lru_add_drainage to 6.12 I was careful to check whether
> >> folio_expected_ref_count() would need to add it to the accounting there:
> >> apparently yes; but then I was surprised to find that it's still present
> >> in 6.17-rc, I'd assumed it gone long ago.
> >>
> >> I didn't try to read the filesystems (which could easily have been
> >> inconsistent about it) to understand: what convinced me amidst all
> >> the confusion was this comment and code in mm/filemap.c:
> >>
> >> /**
> >>    * folio_end_private_2 - Clear PG_private_2 and wake any waiters.
> >>    * @folio: The folio.
> >>    *
> >>    * Clear the PG_private_2 bit on a folio and wake up any sleepers waiting
> >>    for
> >>    * it.  The folio reference held for PG_private_2 being set is released.
> >>    *
> >>    * This is, for example, used when a netfs folio is being written to a
> >>    local
> >>    * disk cache, thereby allowing writes to the cache for the same folio to
> >>    be
> >>    * serialised.
> >>    */
> >> void folio_end_private_2(struct folio *folio)
> >> {
> >>  VM_BUG_ON_FOLIO(!folio_test_private_2(folio), folio);
> >>  clear_bit_unlock(PG_private_2, folio_flags(folio, 0));
> >>  folio_wake_bit(folio, PG_private_2);
> >>  folio_put(folio);
> >> }
> >> EXPORT_SYMBOL(folio_end_private_2);
> >>
> >> That seems to be clear that PG_private_2 is matched by a folio reference,
> >> but perhaps you can explain it away - worth changing the comment if so.
> >>
> >> I was also anxious to work out whether PG_private with PG_private_2
> >> would mean +1 or +2: I don't think I found any decisive statement,
> >> but traditional use of page_has_private() implied +1; and I expect
> >> there's no filesystem which actually could have both on the same folio.
> > 
> > I think it's "+1", like we used to have.

I've given up worrying about that.  I'm inclined to think it's +2,
since there's no test_private when incrementing and decrementing
for private_2; but I don't need to care any more.

> > 
> > I was seriously confused when discovering (iow, concerned about false
> > positives):
> > 
> >  PG_fscache = PG_private_2,
> > 
> > But in the end PG_fscache is only used in comments and e.g.,
> > __fscache_clear_page_bits() calls folio_end_private_2(). So both are
> > really just aliases.
> > 
> > [Either PG_fscache should be dropped and referred to as PG_private_2, or
> > PG_private_2 should be dropped and PG_fscache used instead. It's even
> > inconsistently used in that fscache. file.
> > 
> > Or both should be dropped, of course, once we can actually get rid of it
> > ...]
> > 
> > So PG_private_2 should not be used for any other purpose.

Yes, ghastly the hiding of one behind the other; that, and the
PageFlags versus folio_flags, made it all tiresome to track down.

I have considered adding PG_Spanish_Inquisition = PG_private_2
since folio_expect_ref_count() ignoring PG_private_2 implies that
no-one expects the PG_private_2.

> > 
> > folio_start_private_2() / folio_end_private_2() indeed pair the flag
> > with a reference. There are no other callers that would set/clear the
> > flag without involving a reference.
> > 
> > The usage of private_2 is declared deprecated all over the place. So the
> > question is if we really still care.
> > 
> > The ceph usage is guarded by CONFIG_CEPH_FSCACHE, the NFS one by
> > NFS_FSCACHE, nothing really seems to prevent it from getting configured
> > in easily.
> > 
> > Now, one problem would be if migration / splitting / ... code where we
> > use folio_expected_ref_count() cannot deal with that additional
> > reference properly, in which case this patch would indeed cause harm.

Yes, that appears to be why Matthew said NAK and "dangerously wrong".

So far as I could tell, there is no problem with nfs, it has, and has
all along had, the appropriate release_folio and migrate_folio methods.

ceph used to have what's needed, but 6.0's changes from page_has_private()
to folio_test_private() (the change from "has" either bit to "test" just
the one bit really should have been highlighted) broke the migration of
ceph's PG_private_2 folios.

(I think it may have got re-enabled in intervening releases: David
Howells reinstated folio_has_private() inside fallback_migrate_folio()'s
filemap_release_folio(), which may have been enough to get ceph's
PG_private_2s migratable again; but then 6.15's ceph .migrate_folio =
filemap_migrate_folio will have broken it again.)

Folio migration does not and never has copied over PG_private_2 from
src to dst; so my 1/7 patch would have permitted migration of a ceph
PG_private_2 src folio to a dst folio left with refcount 1 more than
it should be (plus whatever the consequences of migrating such a
folio which should have waited for the flag to be cleared first).

Earlier, I did intend to add protection against PG_private_2 into
folio_migrate_mapping() and/or whatever else needs it in mm/migrate.c,
as part of the 1/7 patch; and later submit a ceph patch to give it
back the release_folio wait on PG_private_2 it wants.

But (a) I ran out of steam, and (b) I couldn't test it or advise
ceph folks how to test it, and (c) guessed that Matthew would hate
me populating the codebase with further references to PG_private_2,
and (d) realized that this PG_private_2 thing is a transient
condition (more like writeback than private) which probably nobody
cares too much about (its lack of migration has gone unnoticed).

I'm just going to drop this 1/7, and add a (briefer than this!)
paragraph to 2/7 == 1/6's commit message in v2 later today.

> > 
> > If all folio_expected_ref_count() callers can deal with updating that
> > reference, all good.
> > 
> > nfs_migrate_folio(), for example, has folio_test_private_2() handling in
> > there (just wait until it is gone). ceph handles it during
> > ceph_writepages_start(), but uses ordinary filemap_migrate_folio.
> > 
> > Long story short: this patch is problematic if one
> > folio_expected_ref_count() users is not aware of how to handle that
> > additional reference.
> > 
> 
> Case in point, I just stumbled over
> 
> commit 682a71a1b6b363bff71440f4eca6498f827a839d
> Author: Matthew Wilcox (Oracle) <willy@infradead.org>
> Date:   Fri Sep 2 20:46:46 2022 +0100
> 
>     migrate: convert __unmap_and_move() to use folios
> 
> and
> 
> commit 8faa8ef5dd11abe119ad0c8ccd39f2064ca7ed0e
> Author: Matthew Wilcox (Oracle) <willy@infradead.org>
> Date:   Mon Jun 6 09:34:36 2022 -0400
> 
>     mm/migrate: Convert fallback_migrate_page() to fallback_migrate_folio()
>     
>     Use a folio throughout.  migrate_page() will be converted to
>     migrate_folio() later.
> 
> 
> where we converted from page_has_private() to folio_test_private(). Maybe
> that's all sane, but it raises the question if migration (and maybe splitting)
> as a whole is no incompatible with PG_private_2

The commit I blamed in my notes was 108ca835, I think that's the one
that changes "has" to "test" in the "expected" calculaton; but yes,
8faa8ef5 is significant for skipping the call to folio_release.

Hugh

