Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E03693A65C7
	for <lists+ceph-devel@lfdr.de>; Mon, 14 Jun 2021 13:43:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236097AbhFNLmJ (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 14 Jun 2021 07:42:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:60504 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236562AbhFNLjQ (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Mon, 14 Jun 2021 07:39:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1AD3061107;
        Mon, 14 Jun 2021 11:35:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623670536;
        bh=uH4DPbQdVAUSs6BrBqapJofWHc1yMDoS/5769c80zfI=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=fOhurXPaewzNtiRsKZVZyGExZYVCjxdpxWm1mpkYwLkqsnYbcyN7zKuUinLLQbKu4
         uctPKilelE4k6G1fzRpQ2pXTB42p4b3yUquIO/39tbgJJmcCoKHabnp7J83MxBuaE5
         5hyYkpKDU+LisWMQrHqIJpDu2vbr+CgdQZGPTVWq8ZwWUqKutNrA9J4j2imA4ewsIn
         jpSQT2cg3vhu1cbTu/N0O38Cagu515u2/kDNBeDUiOszf8fNQfmK94P7b7q8WXyZMw
         qrIh3f7cjcBxKrH5rE9VlQraj/crozKv5c/t/qkmUFOnIjoFIEhSx4ti3cmo5PjXQD
         3ni+PBfnpzXxQ==
Message-ID: <4d1c9cf43d336b32dceabd2a28e9f68937c2e7a9.camel@kernel.org>
Subject: Re: [PATCH] netfs: fix test for whether we can skip read when
 writing beyond EOF
From:   Jeff Layton <jlayton@kernel.org>
To:     David Howells <dhowells@redhat.com>
Cc:     linux-cachefs@redhat.com, idryomov@gmail.com, willy@infradead.org,
        pfmeec@rit.edu, ceph-devel@vger.kernel.org,
        Andrew W Elble <aweits@rit.edu>
Date:   Mon, 14 Jun 2021 07:35:35 -0400
In-Reply-To: <338981.1623665093@warthog.procyon.org.uk>
References: <20210613233345.113565-1-jlayton@kernel.org>
         <338981.1623665093@warthog.procyon.org.uk>
Content-Type: text/plain; charset="ISO-8859-15"
User-Agent: Evolution 3.40.2 (3.40.2-1.fc34) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Mon, 2021-06-14 at 11:04 +0100, David Howells wrote:
> Jeff Layton <jlayton@kernel.org> wrote:
> 
> > +/**
> > + * prep_noread_page - prep a page for writing without reading first
> 
> It's a static function, so I'm not sure it needs the kernel doc marker.
> 
> It also needs prefixing with "netfs_".
> 

I added the comment since the logic here is somewhat complex. It didn't
need to be a kerneldoc header, but I figured that didn't hurt anything.

> > +	/* pos beyond last page in the file */
> > +	if (index > ((i_size - 1) / thp_size(page)))
> > +		goto zero_out;
> 
> thp_size() is not a constant, so this gets you a DIV instruction.
> 

Ugh, ok.

> Why not:
> 
> 	if (page_offset(page) >= i_size)
> 

That doesn't handle THP's correctly. It's just a PAGE_SIZE shift.

> or maybe:
> 
> 	if (pos - offset >= i_size)
> 

That might work.

> > +	zero_user_segments(page, 0, offset, offset + len, thp_size(page));
> 
> If you're going to leave a hole in the file, this will break afs, so this
> patch needs to deal with that too (basically if copied < len, then the
> remainder needs clearing, give or take len being trimmed to the end of the
> page).  I can look at adding that.
> 

I think we have to contend with that in write_end. Basically if the copy
is short, then we probably want to pretend it was a zero length copy and
let generic_perform_write handle it as such. See commit b9de313cf05fe
where Al fixed some sketchy error handling in ceph_write_end along those
lines.

> Matthew Wilcox <willy@infradead.org> wrote:
> 
> > > +	size_t offset = offset_in_page(pos);
> > 
> > offset_in_thp(page, pos);
> 
> I can make this change too.
> 

Thanks.

> (btw, can offset_in_thp() have it's second arg renamed to 'pos', not just 'p'?
>  'p' is normally used to indicate a pointer of some sort).
> 

-- 
Jeff Layton <jlayton@kernel.org>

