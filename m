Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9C7D246FBF
	for <lists+ceph-devel@lfdr.de>; Sat, 15 Jun 2019 13:08:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726437AbfFOLIp (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Sat, 15 Jun 2019 07:08:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:43090 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725943AbfFOLIp (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Sat, 15 Jun 2019 07:08:45 -0400
Received: from tleilax.poochiereds.net (cpe-71-70-156-158.nc.res.rr.com [71.70.156.158])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AE52320868;
        Sat, 15 Jun 2019 11:08:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560596924;
        bh=d4PhO/BCiNtOO+NzHnU8fQBmsAsfyWLsC7FyggSF/sU=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=a18iU4uMjhWaK3rrpKek54hoED5rbc5LDwQPRdlQmFImUT7bN2sOWdHBAjj/qcuHc
         4gvGCLO9K4IY8ZOzTOkqBCAjzpRaudk74oQhbsMSYVkKzHxsdLGuGC4ICR+Xqlj544
         g4KapH6rPLCwVzwjZpYXJy4s9a9OGyE89VbTFR2g=
Message-ID: <ef030ba8553a8bc81fde998df4bd927bfba17537.camel@kernel.org>
Subject: Re: [PATCH 1/3] lib/vsprintf: add snprintf_noterm
From:   Jeff Layton <jlayton@kernel.org>
To:     Joe Perches <joe@perches.com>, "Yan, Zheng" <ukernel@gmail.com>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        ceph-devel <ceph-devel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ilya Dryomov <idryomov@gmail.com>, Zheng Yan <zyan@redhat.com>,
        Sage Weil <sage@redhat.com>, agruenba@redhat.com
Date:   Sat, 15 Jun 2019 07:08:41 -0400
In-Reply-To: <75c8f066c3aa2e20db2e1554a4d28c20b2952724.camel@perches.com>
References: <20190614134625.6870-1-jlayton@kernel.org>
         <20190614134625.6870-2-jlayton@kernel.org>
         <CAAM7YAnZ=NtsOuR0Pm82fWCSUdFLkJ7NLNk+fNK9+T4viW=_1Q@mail.gmail.com>
         <75c8f066c3aa2e20db2e1554a4d28c20b2952724.camel@perches.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.32.2 (3.32.2-1.fc30) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Fri, 2019-06-14 at 19:58 -0700, Joe Perches wrote:
> On Sat, 2019-06-15 at 10:41 +0800, Yan, Zheng wrote:
> > On Fri, Jun 14, 2019 at 9:48 PM Jeff Layton <jlayton@kernel.org> wrote:
> > > The getxattr interface returns a length after filling out the value
> > > buffer, and the convention with xattrs is to not NULL terminate string
> > > data.
> > > 
> > > CephFS implements some virtual xattrs by using snprintf to fill the
> > > buffer, but that always NULL terminates the string. If userland sends
> > > down a buffer that is just the right length to hold the text without
> > > termination then we end up truncating the value.
> > > 
> > > Factor the formatting piece of vsnprintf into a separate helper
> > > function, and have vsnprintf call that and then do the NULL termination
> > > afterward. Then add a snprintf_noterm function that calls the new helper
> > > to populate the string but skips the termination.
> 
> Is this function really necessary enough to add
> the additional stack use to the generic case?
> 

The only alternative I saw was to allocate an extra buffer in the
callers, call snprintf to populate that and then copy the result into
the destination buffer sans termination. I really would like to avoid
that here.

Does breaking this code out into a helper add any significant stack
usage? I didn't see it that way, but I am quite concerned about not
slowing down the generic vsnprintf routine.

> Why not add have this function call vsnprintf
> and then terminate the string separately?
> 

I don't quite follow what you're suggesting here. vsnprintf is what does
the termination today, and we need a function that doesn't do that.

-- 
Jeff Layton <jlayton@kernel.org>

