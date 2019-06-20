Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 11FE64CFA4
	for <lists+ceph-devel@lfdr.de>; Thu, 20 Jun 2019 15:54:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726784AbfFTNyR (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 20 Jun 2019 09:54:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:51436 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726551AbfFTNyR (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Thu, 20 Jun 2019 09:54:17 -0400
Received: from tleilax.poochiereds.net (cpe-71-70-156-158.nc.res.rr.com [71.70.156.158])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 149E920675;
        Thu, 20 Jun 2019 13:54:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561038856;
        bh=ujco4toh4VcjlC1PwExMobr+TbEakBM2rfFRTVzVA9w=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=DcVNrNiFpeuOwljp7LA2Gtb02dNaMIRCyt2onZkB+mR6mFkpcrSlYGpiTB9KervaC
         /H9aM9bFIH90qaIB4tLZYT5gsUm8dXfLXtqP0hiqbkQiyxN/OtVbv7oXBTxHX9fWFk
         qfMa7L8TI19+SYm/jjA1KH+05QZpKoxAhMLYBMng=
Message-ID: <d8218bd280f19ebbd38f396dbf4e763b945d40bd.camel@kernel.org>
Subject: Re: [PATCH v2 0/3] ceph: don't NULL terminate virtual xattr values
From:   Jeff Layton <jlayton@kernel.org>
To:     Geert Uytterhoeven <geert@linux-m68k.org>
Cc:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        ceph-devel <ceph-devel@vger.kernel.org>,
        Ilya Dryomov <idryomov@gmail.com>, Zheng Yan <zyan@redhat.com>,
        sage@redhat.com, agruenba@redhat.com,
        Joe Perches <joe@perches.com>, Petr Mladek <pmladek@suse.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Geert Uytterhoeven <geert+renesas@glider.be>
Date:   Thu, 20 Jun 2019 09:54:13 -0400
In-Reply-To: <CAMuHMdUtwtruJtcUe4-YQJQ5h9B-WCcjK57hVMvxjnrZeFjrfA@mail.gmail.com>
References: <20190619164528.31958-1-jlayton@kernel.org>
         <20190620102410.GT9224@smile.fi.intel.com>
         <7c12abe8a7e6cd3cfe9129a1e74d9c788ff2f1a9.camel@kernel.org>
         <CAMuHMdUtwtruJtcUe4-YQJQ5h9B-WCcjK57hVMvxjnrZeFjrfA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.32.2 (3.32.2-1.fc30) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Thu, 2019-06-20 at 14:22 +0200, Geert Uytterhoeven wrote:
> Hi Jeff,
> 
> On Thu, Jun 20, 2019 at 1:41 PM Jeff Layton <jlayton@kernel.org> wrote:
> > On Thu, 2019-06-20 at 13:24 +0300, Andy Shevchenko wrote:
> > > On Wed, Jun 19, 2019 at 12:45:25PM -0400, Jeff Layton wrote:
> > > > v2: drop bogus EXPORT_SYMBOL of static function
> > > > 
> > > > The only real difference between this set and the one I sent originally
> > > > is the removal of a spurious EXPORT_SYMBOL in the snprintf patch.
> > > > 
> > > > I'm mostly sending this with a wider cc list in an effort to get a
> > > > review from the maintainers of the printf code. Basically ceph needs a
> > > > snprintf variant that does not NULL terminate in order to handle its
> > > > virtual xattrs.
> > > > 
> > > > Joe Perches had expressed some concerns about stack usage in vsnprintf
> > > > with this, but I'm not sure I really understand the basis of that
> > > > concern. If it is problematic, then I could use suggestions as to how
> > > > best to fix that up.
> > > 
> > > It might be problematic, since vsnprintf() can be called recursively.
> > > 
> > 
> > So the concern is that we'd have extra call/ret activity in the stack?
> > That seems like a lot of hand-wringing over very little, but ok if so.
> > 
> > > > ----------------------------8<-----------------------------
> > > > 
> > > > kcephfs has several "virtual" xattrs that return strings that are
> > > > currently populated using snprintf(), which always NULL terminates the
> > > > string.
> > > > 
> > > > This leads to the string being truncated when we use a buffer length
> > > > acquired by calling getxattr with a 0 size first. The last character
> > > > of the string ends up being clobbered by the termination.
> > > 
> > > So, then don't use snprintf() for this, simple memcpy() designed for that kind
> > > of things.
> > > 
> > 
> > memcpy from what? For many of these xattrs, we need to format integer
> > data into strings. I could roll my own routine to do this formatting,
> > but that's sort of what sprintf and its variants are for and I'd rather
> > not reimplement all of it from scratch.
> 
> snprintf() to a temporary buffer, and memcpy() to the final destination.
> These are all fairly small buffers (most are single integer values),
> so the overhead should be minimal, right?
> 

Yeah. I was trying to avoid having to deal with a second buffer, but
this is not a performance-critical codepath, so maybe that's the best
option.

> In fact the two largest strings are already formatted in a temporary
> buffer, so there is no reason ceph_vxattrcb_layout() cannot just use
> snprintf() now.
>
> Or perhaps this can use the existing seq_*() interface in some form?
> 

Hmm. I'll have to think about that.

> BTW, while at it, please get rid of the casts when calling snprintf(), and
> use the correct format specifiers instead.
> 

Sure, will do.

Thanks for the suggestions so far (and from Andy too),
-- 
Jeff Layton <jlayton@kernel.org>

