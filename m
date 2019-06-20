Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C06A64CD0B
	for <lists+ceph-devel@lfdr.de>; Thu, 20 Jun 2019 13:41:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726784AbfFTLlK (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 20 Jun 2019 07:41:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:56770 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726404AbfFTLlK (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Thu, 20 Jun 2019 07:41:10 -0400
Received: from tleilax.poochiereds.net (cpe-71-70-156-158.nc.res.rr.com [71.70.156.158])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D4EB52075E;
        Thu, 20 Jun 2019 11:41:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561030869;
        bh=tGcz+zzMCn9y60AI9nhCrbOZgPlgoC8PP4DIQWqvS1g=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=Nikgw3qfW71sRH6WpPpYD5HM1O1pWoMvEPRzVkYTr/xoOZ5RQT7pXzjo4QeviT43K
         x1kxiQJ0GjnhjW3Sl11/hontnLXTZrL5SgpYlm5lnTS7nGX7wv0k5nKsiAPlH4791G
         2zDKfChnMUIQna1wkANW1NW4d4GzFpwpSuB05XKY=
Message-ID: <7c12abe8a7e6cd3cfe9129a1e74d9c788ff2f1a9.camel@kernel.org>
Subject: Re: [PATCH v2 0/3] ceph: don't NULL terminate virtual xattr values
From:   Jeff Layton <jlayton@kernel.org>
To:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc:     linux-kernel@vger.kernel.org, ceph-devel@vger.kernel.org,
        idryomov@gmail.com, zyan@redhat.com, sage@redhat.com,
        agruenba@redhat.com, joe@perches.com, pmladek@suse.com,
        rostedt@goodmis.org, geert+renesas@glider.be
Date:   Thu, 20 Jun 2019 07:41:06 -0400
In-Reply-To: <20190620102410.GT9224@smile.fi.intel.com>
References: <20190619164528.31958-1-jlayton@kernel.org>
         <20190620102410.GT9224@smile.fi.intel.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.32.2 (3.32.2-1.fc30) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Thu, 2019-06-20 at 13:24 +0300, Andy Shevchenko wrote:
> On Wed, Jun 19, 2019 at 12:45:25PM -0400, Jeff Layton wrote:
> > v2: drop bogus EXPORT_SYMBOL of static function
> > 
> > The only real difference between this set and the one I sent originally
> > is the removal of a spurious EXPORT_SYMBOL in the snprintf patch.
> > 
> > I'm mostly sending this with a wider cc list in an effort to get a
> > review from the maintainers of the printf code. Basically ceph needs a
> > snprintf variant that does not NULL terminate in order to handle its
> > virtual xattrs.
> > 
> > Joe Perches had expressed some concerns about stack usage in vsnprintf
> > with this, but I'm not sure I really understand the basis of that
> > concern. If it is problematic, then I could use suggestions as to how
> > best to fix that up.
> 
> It might be problematic, since vsnprintf() can be called recursively.
> 

So the concern is that we'd have extra call/ret activity in the stack?
That seems like a lot of hand-wringing over very little, but ok if so.

> > ----------------------------8<-----------------------------
> > 
> > kcephfs has several "virtual" xattrs that return strings that are
> > currently populated using snprintf(), which always NULL terminates the
> > string.
> > 
> > This leads to the string being truncated when we use a buffer length
> > acquired by calling getxattr with a 0 size first. The last character
> > of the string ends up being clobbered by the termination.
> 
> So, then don't use snprintf() for this, simple memcpy() designed for that kind
> of things.
> 

memcpy from what? For many of these xattrs, we need to format integer
data into strings. I could roll my own routine to do this formatting,
but that's sort of what sprintf and its variants are for and I'd rather
not reimplement all of it from scratch.

> > The convention with xattrs is to not store the termination with string
> > data, given that we have the length. This is how setfattr/getfattr
> > operate.
> 
> Fine.
> 
> > This patch makes ceph's virtual xattrs not include NULL termination
> > when formatting their values. In order to handle this, a new
> > snprintf_noterm function is added, and ceph is changed over to use
> > this to populate the xattr value buffer.
> 
> In terms of vsnprintf(), and actually compiler point of view, it's not a string
> anymore, it's a text-based data.
> 
> Personally, I don't see an advantage of a deep intrusion into vsnprintf().
> The wrapper can be made to achieve this w/o touching the generic code. Thus,
> you can quickly and cleanly fix the issue, while discussing this with wider
> audience.
> 

Sorry, if I'm being dense but I'm not sure I follow here.

Are you suggesting I should just copy/paste most of vsnprintf into a new
function that just leaves off the termination at the end, and leave the
original alone? That seems like a bit of a waste, but if that's the
consensus then ok.

> > Finally, we fix ceph to
> > return -ERANGE properly when the string didn't fit in the buffer.
> > 
> > Jeff Layton (3):
> >   lib/vsprintf: add snprintf_noterm
> >   ceph: don't NULL terminate virtual xattr strings
> >   ceph: return -ERANGE if virtual xattr value didn't fit in buffer
> > 
> >  fs/ceph/xattr.c        |  49 +++++++-------
> >  include/linux/kernel.h |   2 +
> >  lib/vsprintf.c         | 144 ++++++++++++++++++++++++++++-------------
> >  3 files changed, 129 insertions(+), 66 deletions(-)
> > 
> > -- 
> > 2.21.0
> > 

-- 
Jeff Layton <jlayton@kernel.org>

