Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A69B3A45CF
	for <lists+ceph-devel@lfdr.de>; Fri, 11 Jun 2021 17:59:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230298AbhFKQA7 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 11 Jun 2021 12:00:59 -0400
Received: from discipline.rit.edu ([129.21.6.207]:32429 "HELO
        discipline.rit.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with SMTP id S229935AbhFKQA7 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Fri, 11 Jun 2021 12:00:59 -0400
Received: (qmail 46356 invoked by uid 501); 11 Jun 2021 15:59:00 -0000
From:   Andrew W Elble <aweits@rit.edu>
To:     David Howells <dhowells@redhat.com>
Cc:     Matthew Wilcox <willy@infradead.org>,
        Jeff Layton <jlayton@kernel.org>, ceph-devel@vger.kernel.org,
        pfmeec@rit.edu, linux-cachefs@redhat.com
Subject: Re: [PATCH 5/5] ceph: fold ceph_update_writeable_page into ceph_write_begin
References: <YMN/PfW2t8e5M58m@casper.infradead.org>
        <a24c3c070c9fc3529a51f00f9ccc3d0abdd0b821.camel@kernel.org>
        <20200916173854.330265-1-jlayton@kernel.org>
        <20200916173854.330265-6-jlayton@kernel.org>
        <7817f98d3b2daafe113bf8290cc8c7adbb86fe99.camel@kernel.org>
        <m2h7i45vzl.fsf@discipline.rit.edu>
        <66264.1623424309@warthog.procyon.org.uk>
        <68477.1623425725@warthog.procyon.org.uk>
Date:   Fri, 11 Jun 2021 11:59:00 -0400
In-Reply-To: <68477.1623425725@warthog.procyon.org.uk> (David Howells's
        message of "Fri, 11 Jun 2021 16:35:25 +0100")
Message-ID: <m2a6nw5r5n.fsf@discipline.rit.edu>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (berkeley-unix)
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

David Howells <dhowells@redhat.com> writes:

> Matthew Wilcox <willy@infradead.org> wrote:
>
>> Yes.  I do that kind of thing in iomap.  What you're doing there looks
>> a bit like offset_in_folio(), but I don't understand the problem with
>> just checking pos against i_size directly.
>
> pos can be in the middle of a page.  If i_size is at, say, the same point in
> the middle of that page and the page isn't currently in the cache, then we'll
> just clear the entire page and not read the bottom part of it (ie. the bit
> prior to the EOF).
>
> It's odd, though, that xfstests doesn't catch this.

Some more details/information:

1.) The test is a really simple piece of code that essentially writes
    a incrementing number to a file on 'node a', while a 'tail -f'
    is run and exited multiple times on 'node b'. We haven't had much
    luck in this causing the problem when done on a single node
2.) ((pos & PAGE_MASK) >= i_size_read(inode)) ||' merely reflects the
    logic that was in place prior to 1cc1699070bd. Patching
    fs/ceph/addr.c with this does seem to eliminate the corruption.
    (We'll test with the patch Jeff posted here shortly)
3.) After finding all of this, I went upstream to look at fs/ceph/addr.c
    and discovered the move to leveraging fs/netfs/read_helper.c - we've
    only just compiled against git master and replicated the corruption
    there.


-- 
Andrew W. Elble
Infrastructure Engineer
Information and Technology Services
Rochester Institute of Technology
tel: (585)-475-2411 | aweits@rit.edu
PGP: BFAD 8461 4CCF DC95 DA2C B0EB 965B 082E 863E C912
