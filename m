Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5AAEE4CD9E
	for <lists+ceph-devel@lfdr.de>; Thu, 20 Jun 2019 14:22:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731695AbfFTMWu (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 20 Jun 2019 08:22:50 -0400
Received: from mail-lf1-f67.google.com ([209.85.167.67]:34755 "EHLO
        mail-lf1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726551AbfFTMWt (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 20 Jun 2019 08:22:49 -0400
Received: by mail-lf1-f67.google.com with SMTP id y198so2316536lfa.1;
        Thu, 20 Jun 2019 05:22:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Do38rkY2ZZsrpZAVenJxNuPf8rEp1+WTJHanUUnggSY=;
        b=Igue6LS48NcWq0SrzHdpQS5j9sPEG4tJ013SIDwX/gFZPgma5hccYzUvEgTB8pmANK
         ZGf1N4GsMvI1hYEdTymHElzkR9xsM6sr/woyLxsW/pEhdhSPYE/xmo++1JvjuNnxX7Wi
         aYa3KYf8ihLsT2DFkMjk7W51UsEemBl6ihX6rIRuPpCZm5tmstEJEAPzFBUVNfrGbw4D
         Wa2n8N0YWQ0PoDQnL924coaJP6SW6/YY2XwBkVTyRXKLfNSfdlK8B+zZWXT5UG+XpThm
         s/6xzGMz3Hb6VKKvyCC0TsO8LRItrPfiCLQknGfFD/iWXlKSJLTUTzvAW3BzG5ENljSt
         VXig==
X-Gm-Message-State: APjAAAW5EcbRTih/9hJDYLPQJi+ihf2Il8yXBmg6ieOzLCpgrWRYOxvq
        2tBKbfrtWcJE8Sk6RIuJdQA0qTNkXIw2H2gM1OM=
X-Google-Smtp-Source: APXvYqwPlnium8ZasCca5F+boLpiAogkhXtgkPjorFExMRgRJ5WfheIwnM24bzr1jg/MB8oOchL2EevA9riXd4KJX4w=
X-Received: by 2002:ac2:597c:: with SMTP id h28mr26106828lfp.90.1561033367493;
 Thu, 20 Jun 2019 05:22:47 -0700 (PDT)
MIME-Version: 1.0
References: <20190619164528.31958-1-jlayton@kernel.org> <20190620102410.GT9224@smile.fi.intel.com>
 <7c12abe8a7e6cd3cfe9129a1e74d9c788ff2f1a9.camel@kernel.org>
In-Reply-To: <7c12abe8a7e6cd3cfe9129a1e74d9c788ff2f1a9.camel@kernel.org>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Thu, 20 Jun 2019 14:22:17 +0200
Message-ID: <CAMuHMdUtwtruJtcUe4-YQJQ5h9B-WCcjK57hVMvxjnrZeFjrfA@mail.gmail.com>
Subject: Re: [PATCH v2 0/3] ceph: don't NULL terminate virtual xattr values
To:     Jeff Layton <jlayton@kernel.org>
Cc:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        ceph-devel <ceph-devel@vger.kernel.org>,
        Ilya Dryomov <idryomov@gmail.com>, Zheng Yan <zyan@redhat.com>,
        sage@redhat.com, agruenba@redhat.com,
        Joe Perches <joe@perches.com>, Petr Mladek <pmladek@suse.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Geert Uytterhoeven <geert+renesas@glider.be>
Content-Type: text/plain; charset="UTF-8"
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Hi Jeff,

On Thu, Jun 20, 2019 at 1:41 PM Jeff Layton <jlayton@kernel.org> wrote:
> On Thu, 2019-06-20 at 13:24 +0300, Andy Shevchenko wrote:
> > On Wed, Jun 19, 2019 at 12:45:25PM -0400, Jeff Layton wrote:
> > > v2: drop bogus EXPORT_SYMBOL of static function
> > >
> > > The only real difference between this set and the one I sent originally
> > > is the removal of a spurious EXPORT_SYMBOL in the snprintf patch.
> > >
> > > I'm mostly sending this with a wider cc list in an effort to get a
> > > review from the maintainers of the printf code. Basically ceph needs a
> > > snprintf variant that does not NULL terminate in order to handle its
> > > virtual xattrs.
> > >
> > > Joe Perches had expressed some concerns about stack usage in vsnprintf
> > > with this, but I'm not sure I really understand the basis of that
> > > concern. If it is problematic, then I could use suggestions as to how
> > > best to fix that up.
> >
> > It might be problematic, since vsnprintf() can be called recursively.
> >
>
> So the concern is that we'd have extra call/ret activity in the stack?
> That seems like a lot of hand-wringing over very little, but ok if so.
>
> > > ----------------------------8<-----------------------------
> > >
> > > kcephfs has several "virtual" xattrs that return strings that are
> > > currently populated using snprintf(), which always NULL terminates the
> > > string.
> > >
> > > This leads to the string being truncated when we use a buffer length
> > > acquired by calling getxattr with a 0 size first. The last character
> > > of the string ends up being clobbered by the termination.
> >
> > So, then don't use snprintf() for this, simple memcpy() designed for that kind
> > of things.
> >
>
> memcpy from what? For many of these xattrs, we need to format integer
> data into strings. I could roll my own routine to do this formatting,
> but that's sort of what sprintf and its variants are for and I'd rather
> not reimplement all of it from scratch.

snprintf() to a temporary buffer, and memcpy() to the final destination.
These are all fairly small buffers (most are single integer values),
so the overhead should be minimal, right?

In fact the two largest strings are already formatted in a temporary
buffer, so there is no reason ceph_vxattrcb_layout() cannot just use
snprintf() now.

Or perhaps this can use the existing seq_*() interface in some form?

BTW, while at it, please get rid of the casts when calling snprintf(), and
use the correct format specifiers instead.

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
