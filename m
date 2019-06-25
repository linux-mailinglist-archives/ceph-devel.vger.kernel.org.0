Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 645EF55BA3
	for <lists+ceph-devel@lfdr.de>; Wed, 26 Jun 2019 00:50:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726407AbfFYWun (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 25 Jun 2019 18:50:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:45978 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726179AbfFYWum (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Tue, 25 Jun 2019 18:50:42 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 15E042086D;
        Tue, 25 Jun 2019 22:50:40 +0000 (UTC)
Date:   Tue, 25 Jun 2019 18:50:39 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Jeff Layton <jlayton@kernel.org>
Cc:     Geert Uytterhoeven <geert@linux-m68k.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        ceph-devel <ceph-devel@vger.kernel.org>,
        Ilya Dryomov <idryomov@gmail.com>, Zheng Yan <zyan@redhat.com>,
        sage@redhat.com, agruenba@redhat.com,
        Joe Perches <joe@perches.com>, Petr Mladek <pmladek@suse.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>
Subject: Re: [PATCH v2 0/3] ceph: don't NULL terminate virtual xattr values
Message-ID: <20190625185039.08fa5a4f@gandalf.local.home>
In-Reply-To: <d8218bd280f19ebbd38f396dbf4e763b945d40bd.camel@kernel.org>
References: <20190619164528.31958-1-jlayton@kernel.org>
        <20190620102410.GT9224@smile.fi.intel.com>
        <7c12abe8a7e6cd3cfe9129a1e74d9c788ff2f1a9.camel@kernel.org>
        <CAMuHMdUtwtruJtcUe4-YQJQ5h9B-WCcjK57hVMvxjnrZeFjrfA@mail.gmail.com>
        <d8218bd280f19ebbd38f396dbf4e763b945d40bd.camel@kernel.org>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Thu, 20 Jun 2019 09:54:13 -0400
Jeff Layton <jlayton@kernel.org> wrote:

> > snprintf() to a temporary buffer, and memcpy() to the final destination.
> > These are all fairly small buffers (most are single integer values),
> > so the overhead should be minimal, right?
> >   
> 
> Yeah. I was trying to avoid having to deal with a second buffer, but
> this is not a performance-critical codepath, so maybe that's the best
> option.

Yes, this looks like the better solution than adding a new library
function for other people to (ab)use.

-- Steve
