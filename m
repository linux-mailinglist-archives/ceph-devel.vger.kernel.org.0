Return-Path: <ceph-devel+bounces-1137-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 874498C1DD8
	for <lists+ceph-devel@lfdr.de>; Fri, 10 May 2024 07:54:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 00B4D1F21C15
	for <lists+ceph-devel@lfdr.de>; Fri, 10 May 2024 05:54:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1DAB915D5BD;
	Fri, 10 May 2024 05:54:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=canonical.com header.i=@canonical.com header.b="GICRpOCe"
X-Original-To: ceph-devel@vger.kernel.org
Received: from smtp-relay-internal-0.canonical.com (smtp-relay-internal-0.canonical.com [185.125.188.122])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DD6B15CD43
	for <ceph-devel@vger.kernel.org>; Fri, 10 May 2024 05:54:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.125.188.122
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715320459; cv=none; b=SFGn7nr6q2fJ5r2wbAUbC1ABLsAaPsUt0nK+e504pjkl+6YapU5qvEDfXhNFKU7kJ8+NJCN4PDVud6y/mTnkzYTOJzUsiLw8vhaIM4v/0tNMnKnIOF+Fg4LYVGapIs1juTI84HEgVVWPm5EEKukTDbrzYAYMEZ8COrkL1C6jXnk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715320459; c=relaxed/simple;
	bh=4PEitjlgb+KO6v9/1VnUNw8pVTM6GDPJ4mUKQsGr/KM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=c8Pb/VNLZ4cxCoXhcGBbrp3TlBPQvt0j+qZ9/PE9OOgLJrn119tA8Ef5on0bnlEv8LVbZ9pE8IIrOx9R7zhDASYNkJJNvySz6HCjj22ctZh6bGaqiQcsFNV9T0KK5bwlV7BSAcA+9qRSB60h7n00SneuibAd+mI94sTvKI7txsk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=canonical.com; spf=pass smtp.mailfrom=canonical.com; dkim=pass (2048-bit key) header.d=canonical.com header.i=@canonical.com header.b=GICRpOCe; arc=none smtp.client-ip=185.125.188.122
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=canonical.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=canonical.com
Received: from mail-lf1-f70.google.com (mail-lf1-f70.google.com [209.85.167.70])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-relay-internal-0.canonical.com (Postfix) with ESMTPS id 2D038411F4
	for <ceph-devel@vger.kernel.org>; Fri, 10 May 2024 05:54:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
	s=20210705; t=1715320456;
	bh=pb53mmGBdA39Om/S6gifWUIT/OZjQtmNrFO1eNmJ+LA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:In-Reply-To;
	b=GICRpOCeJXqZTsQ/akEnWyKbq2UvsoByQ7xDHaVU6tGgfRbqLuja7hDSVbOLRvL5j
	 QpgfT1zDWfcEp+RTSR3JJRw2uSEeerCYjD1XTzk2PpjfkkHfvx/ZGWk6siHFFZBHDO
	 qCrKsUOsbW85jT6O+R0zbj2OkDTG/Mmi65g9lU05m0l1RXMbAfrt6yKHBUwD95W8mB
	 RY/egmAIW7OqVOtHyPNAKqXvA9z9xqkU01aLD4VPahfPuELPLY+jRDpcI3ngs9i8Fd
	 eFyR80BfH6G0NgCuwAij9nCVwOO2EaBTigglCeaLNshiuneGPV62wm8mJFjRikdlnf
	 SB+smoTTJhXTw==
Received: by mail-lf1-f70.google.com with SMTP id 2adb3069b0e04-51f7d5c8500so1347608e87.0
        for <ceph-devel@vger.kernel.org>; Thu, 09 May 2024 22:54:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715320455; x=1715925255;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pb53mmGBdA39Om/S6gifWUIT/OZjQtmNrFO1eNmJ+LA=;
        b=v+RiTabTaICvVpvdJLoYbjTnI+iKefqGO0ajrrXsLyX2vXZPT/yYeN1BliXtcKDP7D
         WPIrJRa8VdYpfy+15kAawJx/eP1zQ7A+MhTL0K9wAW8Ke8+0TCIzES5noQhXMUVoWjdu
         w1LftrFIxVv6H9wDBgu6JLzkg5ppg66NqLrtCbHRE21YVK8f4WcZFWVAUjVdMKk1Ttfb
         g8DVq34r36pI/gRb5Le4UE7+KSzs4YQu6VTut1PWpdNPihcQDeSqVmwfyaqtQwgnYVEK
         OSc+cVUQzc/6AiSxantidXDd0HmcAq8i2xqIEP1n5PNIRjzbblmy3/JzTG/WmvJ8wUq9
         XhoQ==
X-Forwarded-Encrypted: i=1; AJvYcCXPD84qhicgfOGiUcn1TzGXhWyXrxBb1fG61Na6HwVobgrwRWZ9QqrsalmJjj3ypK5SLST8/gyvN8tVmX8f7jkNlxPVezSGfegvsw==
X-Gm-Message-State: AOJu0YwD6KBrvQmKQciE2t/IO98pdL9Ok8MMsn2zHK10kfoJtWVLg2wQ
	+HXpNQBF+R224KOEXrXNqS+EFiNxEBf35HwDLKcMwUREtaqhqBRQ7RJI0K4pyHnKVn8Hjyr9a2j
	5C+e4+nsAPYiCCCMeMTs0b9VayPva+KeyI2bUmu9VJey3Hx0OrGsFsv2fdYN/5Vgh9k22kA8AKO
	8=
X-Received: by 2002:a50:bb05:0:b0:572:5f28:1f25 with SMTP id 4fb4d7f45d1cf-5734d5c1692mr1161729a12.7.1715320435059;
        Thu, 09 May 2024 22:53:55 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEUERLBxoc5gVqjALyHDp2f85+2hPeKHWBMU3eKKrua9AkiVLI6CvgwDj1X1kdppOmcHMa0VA==
X-Received: by 2002:a50:bb05:0:b0:572:5f28:1f25 with SMTP id 4fb4d7f45d1cf-5734d5c1692mr1161698a12.7.1715320434315;
        Thu, 09 May 2024 22:53:54 -0700 (PDT)
Received: from localhost (host-82-49-69-7.retail.telecomitalia.it. [82.49.69.7])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5733c3229b5sm1436042a12.79.2024.05.09.22.53.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 May 2024 22:53:53 -0700 (PDT)
Date: Fri, 10 May 2024 07:53:52 +0200
From: Andrea Righi <andrea.righi@canonical.com>
To: David Howells <dhowells@redhat.com>
Cc: Jeff Layton <jlayton@kernel.org>, Steve French <smfrench@gmail.com>,
	Matthew Wilcox <willy@infradead.org>,
	Marc Dionne <marc.dionne@auristor.com>,
	Paulo Alcantara <pc@manguebit.com>,
	Shyam Prasad N <sprasad@microsoft.com>, Tom Talpey <tom@talpey.com>,
	Dominique Martinet <asmadeus@codewreck.org>,
	Eric Van Hensbergen <ericvh@kernel.org>,
	Ilya Dryomov <idryomov@gmail.com>,
	Christian Brauner <christian@brauner.io>, linux-cachefs@redhat.com,
	linux-afs@lists.infradead.org, linux-cifs@vger.kernel.org,
	linux-nfs@vger.kernel.org, ceph-devel@vger.kernel.org,
	v9fs@lists.linux.dev, linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, Latchesar Ionkov <lucho@ionkov.net>,
	Christian Schoenebeck <linux_oss@crudebyte.com>
Subject: Re: [PATCH v5 40/40] 9p: Use netfslib read/write_iter
Message-ID: <Zj22cFnMynv_EF8x@gpd>
References: <Zj0ErxVBE3DYT2Ea@gpd>
 <20231221132400.1601991-1-dhowells@redhat.com>
 <20231221132400.1601991-41-dhowells@redhat.com>
 <1567252.1715290417@warthog.procyon.org.uk>
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1567252.1715290417@warthog.procyon.org.uk>

On Thu, May 09, 2024 at 10:33:37PM +0100, David Howells wrote:
> Andrea Righi <andrea.righi@canonical.com> wrote:
> 
> > On Thu, Dec 21, 2023 at 01:23:35PM +0000, David Howells wrote:
> > > Use netfslib's read and write iteration helpers, allowing netfslib to take
> > > over the management of the page cache for 9p files and to manage local disk
> > > caching.  In particular, this eliminates write_begin, write_end, writepage
> > > and all mentions of struct page and struct folio from 9p.
> > > 
> > > Note that netfslib now offers the possibility of write-through caching if
> > > that is desirable for 9p: just set the NETFS_ICTX_WRITETHROUGH flag in
> > > v9inode->netfs.flags in v9fs_set_netfs_context().
> > > 
> > > Note also this is untested as I can't get ganesha.nfsd to correctly parse
> > > the config to turn on 9p support.
> > 
> > It looks like this patch has introduced a regression with autopkgtest,
> > see: https://bugs.launchpad.net/bugs/2056461
> > 
> > I haven't looked at the details yet, I just did some bisecting and
> > apparently reverting this one seems to fix the problem.
> > 
> > Let me know if you want me to test something in particular or if you
> > already have a potential fix. Otherwise I'll take a look.
> 
> Do you have a reproducer?
> 
> I'll be at LSF next week, so if I can't fix it tomorrow, I won't be able to
> poke at it until after that.
> 
> David

The only reproducer that I have at the moment is the autopkgtest command
mentioned in the bug, that is a bit convoluted, I'll try to see if I can
better isolate the problem and find a simpler reproducer, but I'll also
be travelling next week to a Canonical event.

At the moment I'll temporarily revert the commit (that seems to prevent
the issue from happening) and I'll keep you posted if I find something.

Thanks,
-Andrea

