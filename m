Return-Path: <ceph-devel+bounces-3562-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 60916B49A4E
	for <lists+ceph-devel@lfdr.de>; Mon,  8 Sep 2025 21:48:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4760A1B24B96
	for <lists+ceph-devel@lfdr.de>; Mon,  8 Sep 2025 19:48:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EFA5E2D3A72;
	Mon,  8 Sep 2025 19:48:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="P75I/mNA"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-yx1-f44.google.com (mail-yx1-f44.google.com [74.125.224.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 439542D323D
	for <ceph-devel@vger.kernel.org>; Mon,  8 Sep 2025 19:48:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.224.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757360894; cv=none; b=efCFyTMq61ZDaBkpVfPN86KOGbrEy7mSgixDmTXfAcXlYIOgzv/YROctZR49CMThQkNo7Lohq+K0H1dbGrEQ3VGINWZ+T54cEa8PAkIWj3W/UkpI44NHXAQfA9nmkhfScUWScuIY8jznxLg/iNJQsmLEUVdrKtRW8dSoITe1zXQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757360894; c=relaxed/simple;
	bh=3omYiVett5KT69OkLw6cgQRfDeNeE/hk5f2AnLMqdpY=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=eSXSP10+KrxT/dyUmbUm28FY8YlBacGWQCLs0ksZwiW8WwHEVwm1MsKC0Aqx/YK2BAATAo53HvkZhFGJ0uic0ObeQ3Os42qqhU6/7TnscPTylRYK6LVaKpftHxxWDrYWO90rDtB5qM5z/Vtho/mPn5+4DX/jnmDjcD3XJczSwp4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=P75I/mNA; arc=none smtp.client-ip=74.125.224.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-yx1-f44.google.com with SMTP id 956f58d0204a3-60f47bcdc5cso822906d50.3
        for <ceph-devel@vger.kernel.org>; Mon, 08 Sep 2025 12:48:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1757360892; x=1757965692; darn=vger.kernel.org;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=lkWutJuoMHFChanlNo58aMCO1DUKKA6gzqFMsdXKD24=;
        b=P75I/mNA5tBUoM9rBXhoelsHenVVgG9C/CsXqhHBEAuOCWy9BYVXFvCX+KZ3SQ2ODY
         dCt/r2XjVW/DNc7ro30rTyR61gYIzWj4p8cTm6sheu2KWmEftfYeRSTbPhoSx3DpHF9c
         X0Zuq7E7lxyX9mWY1mzgRIx6TTTI83LYy+7xDNCQx038b3tV7/i/Nu3Criu4CgDVLuzo
         y6ZBkIleLeu5Knil0hUqUE6JCepgcH5pl/3kEQ/7vRCsiH5FQcsy1LC/nD8Y7i+C90Nc
         l0Lpnpafvwd4E8XHW4n5bDs1GD38kFpkEZDoFnHcJvszUrDTunxjZiieE9Y9TwMbjiqZ
         Pung==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757360892; x=1757965692;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=lkWutJuoMHFChanlNo58aMCO1DUKKA6gzqFMsdXKD24=;
        b=FSW7RPndaI4PmnMTVJDMchmgXrf1+Uvr2NNge/GliBbQOGLE1h+jNg/mWzFOksJ/9X
         JS80XD75oj62pywqutWqgtZB0NO7KPN34w6blaWjBwrYFvvGSVhqzFiGNqy7U68WwK1l
         hmFGRKLE/nkc+MiYljURduf2d7XjxXHkdhjkssHg8xqaME0WDKaThFaFvAp/OyWgKvad
         zbr8I9NkN/2XWP/JGHNEfblVhAjdivP3ZNBtpMWt+sy3iB9tADiN5tnheCAm5upXGk9R
         IBkWyPeeWhWTSR5PLUmaE/G4VQTojJY6r8ArkAFyLe6dYzKC5Xivj2mb+leMNg7TNXUM
         ClNQ==
X-Forwarded-Encrypted: i=1; AJvYcCWuriEQLPEP8YN5JG2JrIJrHaPj0XJ5kNd4BEFmUyV0gIubDwxLL4S/+OP9MOnVV8E37ZWCNRoPA87b@vger.kernel.org
X-Gm-Message-State: AOJu0Yy7hxTYtbhXW4JG6kDMgANvPl18IlYS7x9nXWLT553Ol5FAlgth
	hXxGjt1qfQtHTOFDsthgu6TlbG/2dLwPohmjQqHuKeBMxczUYVrXIaSbIekWH2ZPfA==
X-Gm-Gg: ASbGncs4Dxf5094NNq6rZf+qJ1AAk2zZObtQVnVaYGqb1gtOUFCE379lvlpJaz+E0i5
	mO1ZDYA8MMj95R11InnsmT1XDD++5voYdG7rNJw+qYIx5rp6tnlVdpxWe4u5G8lZ8QPiN3CO9Q0
	criZpZFM11/p1bxdCWt9GdvGuZ/6dhlIsUqWmCPwgVEgiv551pjdGhXcppqVt4pacZI6oY5ivS1
	j5l0utQmFhdD8OnP8vAgYM7sxkI95FHrMAXRCKaZ2Mi/6lggRw3Fx47kAS46+yycOCSayedTNcZ
	s1K6NqCc5x8ECRz6AUTJ+4a4busuOpz9DIpLsbcR6UgYboX60+jQv9ePKtCa14r6bm16m2I7Z0Y
	v6gr3N/bC0fVqGM1UUBT6fSCTlfPe1Vp5D8CIOS9hOF4v1SwQLZMyH+4Gw9XjggVLhqrMMFyJGL
	mwEgBO01o=
X-Google-Smtp-Source: AGHT+IG4PW91kFyjbmPgXJLgM5A2EFr+Ploj908V1ZohpTeRJB9+gDbvi/48Raxp7i+jqIStykUZkQ==
X-Received: by 2002:a05:690c:3681:b0:721:29fe:1d49 with SMTP id 00721157ae682-727f5a347b5mr89278617b3.52.1757360892016;
        Mon, 08 Sep 2025 12:48:12 -0700 (PDT)
Received: from darker.attlocal.net (172-10-233-147.lightspeed.sntcca.sbcglobal.net. [172.10.233.147])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-723a82d58b8sm55941157b3.9.2025.09.08.12.48.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Sep 2025 12:48:11 -0700 (PDT)
Date: Mon, 8 Sep 2025 12:47:59 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
To: Matthew Wilcox <willy@infradead.org>
cc: Hugh Dickins <hughd@google.com>, David Hildenbrand <david@redhat.com>, 
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
In-Reply-To: <aL7w4qrJtvKE1cu5@casper.infradead.org>
Message-ID: <685fa6c1-e343-ae92-b673-48524918548d@google.com>
References: <a28b44f7-cdb4-8b81-4982-758ae774fbf7@google.com> <f91ee36e-a8cb-e3a4-c23b-524ff3848da7@google.com> <aLTcsPd4SUAAy5Xb@casper.infradead.org> <52da6c6a-e568-38bd-775b-eff74f87215b@google.com> <92def216-ca9c-402d-8643-226592ca1a85@redhat.com>
 <2e069441-0bc6-4799-9176-c7a76c51158f@redhat.com> <3973ecd7-d99c-6d38-7b53-2f3fca57b48d@google.com> <aL7w4qrJtvKE1cu5@casper.infradead.org>
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII

On Mon, 8 Sep 2025, Matthew Wilcox wrote:
> On Mon, Sep 08, 2025 at 03:27:47AM -0700, Hugh Dickins wrote:
> > On Mon, 1 Sep 2025, David Hildenbrand wrote:
> > > On 01.09.25 09:52, David Hildenbrand wrote:
> > > > On 01.09.25 03:17, Hugh Dickins wrote:
> > > >> On Mon, 1 Sep 2025, Matthew Wilcox wrote:
> > > >>> On Sun, Aug 31, 2025 at 02:01:16AM -0700, Hugh Dickins wrote:
> > > >>>> 6.16's folio_expected_ref_count() is forgetting the PG_private_2 flag,
> > > >>>> which (like PG_private, but not in addition to PG_private) counts for
> > > >>>> 1 more reference: it needs to be using folio_has_private() in place of
> > > >>>> folio_test_private().
> > > >>>
> > > >>> No, it doesn't.  I know it used to, but no filesystem was actually doing
> > > >>> that.  So I changed mm to match how filesystems actually worked.
> > 
> > I think Matthew may be remembering how he wanted it to behave (? but he
> > wanted it to go away completely) rather than how it ended up behaving:
> > we've both found that PG_private_2 always goes with refcount increment.
> 
> Let me explain that better.  No filesystem followed the documented rule
> that the refcount must be incremented by one if either PG_private or
> PG_private_2 was set.  And no surprise; that's a very complicated rule
> for filesystems to follow.  Many of them weren't even following the rule
> to increment the refcount by one when PG_private was set.

Thanks, yes, I hadn't realized that you were referring to the +1 (versus
+2) part of it: yes, a quite unnecessarily difficult rule to follow.

...

> So the current behaviour where we set private_2 and bump the refcount,
> but don't take the private_2 status into account is the safe one,
> because the elevated refcount means we'll skip the PG_fscache folio.
> Maybe it'd be better to wait for it to clear.  But since Dave Howells
> is busy killing it off, I'm just inclined to wait for that to happen.

Yes, that's where my internalized-Matthew brought me in the end;
though killing off PG_private_2 seems to have been just around
the corner for a very long time.

It's a pity that there isn't much incentive on ceph folks to
get it fixed: the one who suffers is the compactor or pinner.

Hugh

