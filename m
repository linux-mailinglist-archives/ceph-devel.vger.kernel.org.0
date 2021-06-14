Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE7093A660D
	for <lists+ceph-devel@lfdr.de>; Mon, 14 Jun 2021 13:52:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233552AbhFNLys (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 14 Jun 2021 07:54:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235688AbhFNLxl (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 14 Jun 2021 07:53:41 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 482F9C061280
        for <ceph-devel@vger.kernel.org>; Mon, 14 Jun 2021 04:51:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=BCXMhnSKxHMguYIR4i+AJzAjxh2uRN1YV70g9z2bDIs=; b=OvyjoUTHe5zNqbKbwbb7QEudGA
        bK6Dy5z3guLG3QbFbdgYH4SKmNQELi2Gebn6Gc3by0TVhjajOS6MmbH17MBK/aJi9R0iisCU/UcQr
        vdDdffEmk6f1pmvBKnR0/HTGEx9z2doDrtFz8EFqNfgKPXUz0cLyRBcMRcp9JbW1QfVb+k2c40IJH
        9hZuOxXEwwlq2hCIlIUK0s4EUvXaqf3eKqWrlLjlDvFi3Opy5YwZIcwVIURrsqCNU/wGtz/VmIlZd
        xk7n8P3EhW9DDlgPqH1nF3JMODkradfCCCT2MkK1TJ2MDg/XDQDWbU5IvjEUaMEaMDG+jd5YQSdF7
        VuVBlrhA==;
Received: from willy by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1lsl7R-005NWC-KO; Mon, 14 Jun 2021 11:51:10 +0000
Date:   Mon, 14 Jun 2021 12:51:05 +0100
From:   Matthew Wilcox <willy@infradead.org>
To:     David Howells <dhowells@redhat.com>
Cc:     Jeff Layton <jlayton@kernel.org>, linux-cachefs@redhat.com,
        idryomov@gmail.com, pfmeec@rit.edu, ceph-devel@vger.kernel.org,
        Andrew W Elble <aweits@rit.edu>
Subject: Re: [PATCH] netfs: fix test for whether we can skip read when
 writing beyond EOF
Message-ID: <YMdCqWtMVpwYKaj2@casper.infradead.org>
References: <20210613233345.113565-1-jlayton@kernel.org>
 <338981.1623665093@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <338981.1623665093@warthog.procyon.org.uk>
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Mon, Jun 14, 2021 at 11:04:53AM +0100, David Howells wrote:
> (btw, can offset_in_thp() have it's second arg renamed to 'pos', not just 'p'?
>  'p' is normally used to indicate a pointer of some sort).

the argument is sometimes a pointer.  for example:

arch/arm64/kernel/mte.c:                offset = offset_in_page(addr);
fs/jbd2/commit.c:               (void *)(addr + offset_in_page(bh->b_data)), bh->b_size);

yes, those are offset_in_page(), not offset_in_thp(), but i'll bet
you a cadbury's creme egg that we find someone who needs to use
offset_in_thp() (or offset_in_folio()) on a pointer within three years.
